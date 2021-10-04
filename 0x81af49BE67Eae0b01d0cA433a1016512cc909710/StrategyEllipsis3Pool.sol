// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./ERC20.sol";
import "./SafeERC20.sol";
import "./SafeMath.sol";

import "./IUniswap.sol";
import "./StratManager.sol";
import "./FeeManager.sol";
import "./GasThrottler.sol";

interface IEpsLP {
    // solhint-disable-next-line
    function add_liquidity(uint256[3] memory amounts, uint256 min_mint_amount) external;
}

interface ILpStaker {
    function poolInfo(uint256 _pid)
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256
        );

    function userInfo(uint256 _pid, address _user) external view returns (uint256, uint256);

    function claimableReward(uint256 _pid, address _user) external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

    function emergencyWithdraw(uint256 _pid) external;

    function claim(uint256[] calldata _pids) external;
}

interface IMultiFeeDistribution {
    function exit() external;
}

contract StrategyEllipsis3Pool is StratManager, FeeManager, GasThrottler {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    /**
     * @dev Tokens Used:
     * {wbnb, busd} - Required for liquidity routing when doing swaps.
     * {eps} - Token generated by staking our funds. In this case it's the EPS token.
     * {want} - Token that the strategy maximizes. The same token that users deposit in the vault. 3eps BUSD/USDT/USDC
     */
    address public constant wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address public constant busd = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    address public constant eps = address(0xA7f552078dcC247C2684336020c03648500C6d9F);
    address public constant want = address(0xaF4dE8E872131AE328Ce21D909C74705d3Aaf452);

    /**
     * @dev Third Party Contracts:
     * {unirouter} - PancakeSwap unirouter
     * {stakingPool} - LpTokenStaker contract
     * {feeDistribution} - MultiFeeDistribution contract
     * {poolLP} - 3Pool LP contract to deposit BUSD/USDC/USDT and mint {want}
     * {poolId} - LpTokenStaker pool id
     */
    address public constant stakingPool = address(0xcce949De564fE60e7f96C85e55177F8B9E4CF61b);
    address public constant feeDistribution = address(0x4076CC26EFeE47825917D0feC3A79d0bB9a6bB5c);
    address public constant poolLp = address(0x160CAed03795365F3A589f10C379FfA7d75d4E76);
    uint8 public constant poolId = 1;
    bool public harvestOnDeposit;

    /**
     * @dev Routes we take to swap tokens using PancakeSwap.
     * {epsToWbnbRoute} - Route we take to go from {eps} into {wbnb}.
     * {epsToBusdRoute} - Route we take to get from {eps} into {busd}.
     */
    address[] public epsToWbnbRoute = [eps, wbnb];
    address[] public epsToBusdRoute = [eps, wbnb, busd];

    /**
     * @dev Event that is fired each time someone harvests the strat.
     */
    event StratHarvest(address indexed harvester);

    /**
     * @dev Initializes the strategy with the token to maximize.
     */
    constructor(
        address _vault,
        address _unirouter,
        address _keeper,
        address _strategist,
        address _platformFeeRecipient,
        address _gasPrice
    ) public StratManager(_keeper, _strategist, _unirouter, _vault, _platformFeeRecipient) GasThrottler(_gasPrice) {
        IERC20(want).safeApprove(stakingPool, uint256(-1));
        IERC20(eps).safeApprove(unirouter, uint256(-1));
        IERC20(wbnb).safeApprove(unirouter, uint256(-1));
        IERC20(busd).safeApprove(poolLp, uint256(-1));
    }

    /**
     * @dev Function that puts the funds to work.
     * It gets called whenever someone deposits in the strategy's vault contract.
     * It deposits {want} in the Pool to farm {eps}
     */
    function deposit() public whenNotPaused {
        uint256 wantBal = IERC20(want).balanceOf(address(this));

        if (wantBal > 0) {
            ILpStaker(stakingPool).deposit(poolId, wantBal);
        }
    }

    /**
     * @dev Withdraws funds and sends them back to the vault.
     * It withdraws {want} from the Pool.
     * The available {want} minus fees is returned to the vault.
     */
    function withdraw(uint256 _amount) external {
        require(msg.sender == vault, "!vault");

        uint256 wantBal = IERC20(want).balanceOf(address(this));

        if (wantBal < _amount) {
            ILpStaker(stakingPool).withdraw(poolId, _amount.sub(wantBal));
            wantBal = IERC20(want).balanceOf(address(this));
        }

        if (wantBal > _amount) {
            wantBal = _amount;
        }

        // solhint-disable-next-line
        if (tx.origin == owner()) {
            IERC20(want).safeTransfer(vault, wantBal);
        } else {
            uint256 withdrawalFeeAmount = wantBal.mul(withdrawalFee).div(MAX_FEE);
            IERC20(want).safeTransfer(vault, wantBal.sub(withdrawalFeeAmount));
        }
    }

    function beforeDeposit() external override {
        if (harvestOnDeposit) {
            require(msg.sender == vault, "!vault");
            _harvest();
        }
    }

    function harvest() external whenNotPaused onlyEOA gasThrottle {
        _harvest();
    }

    function managerHarvest() external onlyManager {
        _harvest();
    }

    /**
     * @dev Core function of the strat, in charge of collecting and re-investing rewards.
     * 1. It claims rewards from the Pool.
     * 2. It charges the system fees to simplify the split.
     * 3. It swaps the {eps} token for {busd}.
     * 4. Adds more liquidity to the pool.
     * 5. It deposits the new LP tokens.
     */
    function _harvest() internal {
        uint256[] memory pids = new uint256[](1);
        pids[0] = poolId;
        ILpStaker(stakingPool).claim(pids);
        IMultiFeeDistribution(feeDistribution).exit();

        chargeFees();
        swapRewards();
        deposit();

        emit StratHarvest(msg.sender);
    }

    function chargeFees() internal {
        uint256 toWbnb = IERC20(eps).balanceOf(address(this)).mul(totalHarvestFee).div(MAX_FEE);
        IUniswapRouter(unirouter).swapExactTokensForTokens(toWbnb, 0, epsToWbnbRoute, address(this), now.add(600));

        uint256 wbnbBal = IERC20(wbnb).balanceOf(address(this));

        uint256 callFeeAmount = wbnbBal.mul(callFee).div(MAX_FEE);
        // solhint-disable-next-line
        IERC20(wbnb).safeTransfer(tx.origin, callFeeAmount);

        uint256 platformFeeAmount = wbnbBal.mul(platformFee()).div(MAX_FEE);
        IERC20(wbnb).safeTransfer(platformFeeRecipient, platformFeeAmount);

        uint256 strategistFeeAmount = wbnbBal.mul(strategistFee).div(MAX_FEE);
        IERC20(wbnb).safeTransfer(strategist, strategistFeeAmount);
    }

    /**
     * @dev Swaps {eps} rewards earned for {busd} and adds to 3Pool LP.
     */
    function swapRewards() internal {
        uint256 epsBal = IERC20(eps).balanceOf(address(this));
        IUniswapRouter(unirouter).swapExactTokensForTokens(epsBal, 0, epsToBusdRoute, address(this), now.add(600));

        uint256 busdBal = IERC20(busd).balanceOf(address(this));
        uint256[3] memory amounts = [busdBal, 0, 0];
        IEpsLP(poolLp).add_liquidity(amounts, 0);
    }

    /**
     * @dev Function to calculate the total underlying {want} held by the strat.
     * It takes into account both the funds in hand, as the funds allocated in the Pool.
     */
    function balanceOf() public view returns (uint256) {
        return balanceOfWant().add(balanceOfPool());
    }

    /**
     * @dev It calculates how much {want} the contract holds.
     */
    function balanceOfWant() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }

    /**
     * @dev It calculates how much {want} the strategy has allocated in the Pool
     */
    function balanceOfPool() public view returns (uint256) {
        (uint256 _amount, ) = ILpStaker(stakingPool).userInfo(poolId, address(this));
        return _amount;
    }

    function setHarvestOnDeposit(bool _harvestOnDeposit) external onlyManager {
        harvestOnDeposit = _harvestOnDeposit;
    }

    /**
     * @dev Function that has to be called as part of strat migration. It sends all the available funds back to the
     * vault, ready to be migrated to the new strat.
     */
    function retireStrat() external {
        require(msg.sender == vault, "!vault");

        ILpStaker(stakingPool).emergencyWithdraw(poolId);

        uint256 pairBal = IERC20(want).balanceOf(address(this));
        IERC20(want).transfer(vault, pairBal);
    }

    /**
     * @dev Pauses deposits. Withdraws all funds from the Pool, leaving rewards behind
     */
    function panic() public onlyOwner {
        pause();
        ILpStaker(stakingPool).emergencyWithdraw(poolId);
    }

    /**
     * @dev Pauses the strat.
     */
    function pause() public onlyOwner {
        _pause();

        IERC20(want).safeApprove(stakingPool, 0);
        IERC20(eps).safeApprove(unirouter, 0);
        IERC20(wbnb).safeApprove(unirouter, 0);
        IERC20(busd).safeApprove(poolLp, 0);
    }

    /**
     * @dev Unpauses the strat.
     */
    function unpause() external onlyOwner {
        _unpause();

        IERC20(want).safeApprove(stakingPool, uint256(-1));
        IERC20(eps).safeApprove(unirouter, uint256(-1));
        IERC20(wbnb).safeApprove(unirouter, uint256(-1));
        IERC20(busd).safeApprove(poolLp, uint256(-1));
    }
}
