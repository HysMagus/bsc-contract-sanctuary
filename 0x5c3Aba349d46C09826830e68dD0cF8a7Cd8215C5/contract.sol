// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface TokenInterface is IERC20 {
    function burnFromFarm(uint256 amount) external returns (bool);
    function withdraw(uint wad) external;
    function deposit() external payable;
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IPancakeSwapV2Pair {
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

interface IPancakeSwapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);
    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IPancakeSwapV2Router02 is IPancakeSwapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
}

contract LPFarming is Context, Ownable {
    using SafeMath for uint256;

    TokenInterface public _czy;
    TokenInterface public _busd;
    TokenInterface public _btcb;
    TokenInterface public _wbnb;

    IPancakeSwapV2Pair public _czyBNBV2Pair;
    IPancakeSwapV2Pair public _busdBNBV2Pair;

    IPancakeSwapV2Router02 private _pancakeswapV2Router;

    address public _treasury;
    address private _team; // to test

    uint16 public _allocPointForCZYReward;
    uint16 public _allocPointForSwapReward;
    uint16 public _treasuryFee;
    uint16 public _rewardFee;
    uint16 public _lotteryFee;
    uint16 public _swapRewardFee;
    uint16 public _burnFee;
    uint16 public _earlyUnstakeFee;
    uint16 public _allocPointForBTCB;
    uint16 public _allocPointForBUSD;
    uint16 public _allocPointForWBNB;

    uint256 public _rewardPeriod;
    uint256 public _rewardAmount;
    uint256 public _claimPeriodForCZYReward;
    uint256 public _claimPeriodForSwapReward;
    uint256 public _lockPeriod;
    uint256 public _minDepositBNBAmount;

    bool public _enabledLock;
    bool public _enabledLottery;

    uint256 public _startBlock;
    uint256 public _lotteryLimit;
    uint256 public _collectedAmountForStakers;
    uint256 public _collectedAmountForSwap;
    uint256 public _collectedAmountForLottery;
    uint256 public _lotteryPaidOut;

    struct StakerInfo {
        uint256 stakedAmount;
        uint256 lastClimedBlockForCZYReward;
        uint256 lastClimedBlockForSwapReward;
        uint256 lockedTo;
    }

    mapping(address => StakerInfo) public _stakers;

    struct WinnerInfo {
        address winner;
        uint256 amount;
        uint256 timestamp;
    }
    WinnerInfo[] public winnerInfo;
    
    event ChangedEnabledLock(address indexed owner, bool lock);
    event ChangedEnabledLottery(address indexed owner, bool lottery);
    event ChangedLockPeriod(address indexed owner, uint256 period);
    event ChangedMinimumBNBDepositAmount(address indexed owner, uint256 value);
    event ChangedRewardPeriod(address indexed owner, uint256 rewardPeriod);
    event ChangedClaimPeriod(address indexed owner, uint256 claimPeriodForCZYReward, uint256 claimPeriodForSwapReward);
    event ChangedCZYAddress(address indexed owner, address indexed czy);
    event ChangedCZYBNBPair(address indexed owner, address indexed pair);
    event ChangedFeeInfo(address indexed owner, uint16 treasuryFee, uint16 rewardFee, uint16 lotteryFee, uint16 swapRewardFee, uint16 burnFee);
    event ChangedAllocPointsForSwapReward(address indexed owner, uint16 valueForYFI, uint16 valueForWBTC, uint16 valueForWBNB);
    event ChangedBurnFee(address indexed owner, uint16 value);
    event ChangedEarlyUnstakeFee(address indexed owner, uint16 value);
    event ChangedLotteryInfo(address indexed owner, uint16 lotteryFee, uint256 lotteryLimit);

    event ClaimedCZYAvailableReward(address indexed owner, uint256 amount);
    event ClaimedSwapAvailableReward(address indexed owner, uint256 amount);
    event ClaimedCZYReward(address indexed owner, uint256 available, uint256 pending);
    event ClaimedSwapReward(address indexed owner, uint256 amount);

    event Staked(address indexed account, uint256 amount);
    event Unstaked(address indexed account, uint256 amount);

    event SentLotteryAmount(address indexed owner, uint256 amount, bool status);
    event SwapAndLiquifyForCZY(address indexed msgSender, uint256 totAmount, uint256 bnbAmount, uint256 amount);

    modifier onlyCZY() {
        require(
            address(_czy) == _msgSender(),
            "Ownable: caller is not the CZY token contract"
        );
        _;
    }

    constructor(address treasury) {
        _treasury = treasury;

        _busd = TokenInterface(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        _btcb = TokenInterface(0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c);
        _wbnb = TokenInterface(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

        _busdBNBV2Pair = IPancakeSwapV2Pair(0x1B96B92314C44b159149f7E0303511fB2Fc4774f);
        _pancakeswapV2Router = IPancakeSwapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);

        _rewardPeriod = 65000; // around 10 days, could be changed by governance
        _rewardAmount = 9900e18; // 9,900 CZY tokens, could be changed by governance

        _claimPeriodForCZYReward = 45500; // around 7 days, could be changed by governance
        _claimPeriodForSwapReward = 45500; // around 7 days, could be changed by governance

        _allocPointForCZYReward = 8000; // 80% of reward will go to CZY reward, could be changed by governance
        _allocPointForSwapReward = 2000; // 20% of reward will go to swap(wbnb, btcb, bifi) reward, could be changed by governance

        // Set values divided from taxFee
        _treasuryFee = 2500; // 25% of taxFee to treasuryFee, could be changed by governance
        _rewardFee = 5000; // 50% of taxFee to stakers, could be changed by governance
        _lotteryFee = 500; // 5% of lottery Fee, could be changed by governance
        _swapRewardFee = 2000; // 20% of taxFee to swap tokens, could be changed by governance

        _earlyUnstakeFee = 2500; // 25% of early unstake fee, could be changed by governance
        
        // set alloc points of BTCB, BUSD, WBNB in swap rewards, could be changed by governance
        _allocPointForBTCB = 5000; // 50% of fee to buy BTCB token, could be changed by governance
        _allocPointForBUSD = 3000; // 30% of fee to buy BUSD token, could be changed by governance
        _allocPointForWBNB = 2000; // 20% of fee to buy WBNB token, could be changed by governance

        // set the burn fee for withdraw early
        _burnFee = 2000; // 20% of pending reward to burn when staker request to withdraw pending reward, could be changed by governance
        
        _minDepositBNBAmount = 1e17; // 0.1 BNB, could be changed by governance
        _lockPeriod = 14 days; // could be changed by governance

        _enabledLock = true; // could be changed by governance
        _enabledLottery = true; // could be changed by governance

        _lotteryLimit = 100e18; // $100(100 busd), could be changed by governance
        _startBlock = block.number;
        _team = msg.sender; // in order to test
    }

    /**
     * @dev Change Minimum Deposit BNB Amount. Call by only Governance.
     */
    function changeMinimumDepositBNBAmount(uint256 amount) external onlyOwner {
        _minDepositBNBAmount = amount;

        emit ChangedMinimumBNBDepositAmount(_msgSender(), amount);
    }

    /**
     * @dev Change value of reward period. Call by only Governance.
     */
    function changeRewardPeriod(uint256 rewardPeriod) external onlyOwner {
        _rewardPeriod = rewardPeriod;

        emit ChangedRewardPeriod(_msgSender(), rewardPeriod);
    }

    /**
     * @dev Change value of claim period. Call by only Governance.
     */
    function changeClaimPeriod(uint256 claimPeriodForCZYReward, uint256 claimPeriodForSwapReward) external onlyOwner {
        _claimPeriodForCZYReward = claimPeriodForCZYReward;
        _claimPeriodForSwapReward = claimPeriodForSwapReward;

        emit ChangedClaimPeriod(_msgSender(), claimPeriodForCZYReward, claimPeriodForSwapReward);
    }

    /**
     * @dev Enable lock functionality. Call by only Governance.
     */
    function enableLock(bool isLock) external onlyOwner {
        _enabledLock = isLock;

        emit ChangedEnabledLock(_msgSender(), isLock);
    }

    /**
     * @dev Enable lottery functionality. Call by only Governance.
     */
    function enableLottery(bool lottery) external onlyOwner {
        _enabledLottery = lottery;

        emit ChangedEnabledLottery(_msgSender(), lottery);
    }

    /**
     * @dev Change maximun lock period. Call by only Governance.
     */
    function changeLockPeriod(uint256 period) external onlyOwner {
        _lockPeriod = period;
        
        emit ChangedLockPeriod(_msgSender(), _lockPeriod);
    }

    function changeCZYAddress(address czy) external onlyOwner {
        _czy = TokenInterface(czy);

        emit ChangedCZYAddress(_msgSender(), czy);
    }

    function changeCZYBNBPair(address czyBNBV2Pair) external onlyOwner {
        _czyBNBV2Pair = IPancakeSwapV2Pair(czyBNBV2Pair);

        emit ChangedCZYBNBPair(_msgSender(), czyBNBV2Pair);
    }

    /**
     * @dev Update the treasury fee for this contract
     * defaults at 25% of taxFee, It can be set on only by governance.
     * Note contract owner is meant to be a governance contract allowing governance consensus
     */
    function changeFeeInfo(
        uint16 treasuryFee,
        uint16 rewardFee,
        uint16 lotteryFee,
        uint16 swapRewardFee,
        uint16 burnFee
    ) external onlyOwner {
        _treasuryFee = treasuryFee;
        _rewardFee = rewardFee;
        _lotteryFee = lotteryFee;
        _swapRewardFee = swapRewardFee;
        _burnFee = burnFee;

        emit ChangedFeeInfo(_msgSender(), treasuryFee, rewardFee, lotteryFee, swapRewardFee, burnFee);
    }

    function changeEarlyUnstakeFee(uint16 fee) external onlyOwner {
        _earlyUnstakeFee = fee;

        emit ChangedEarlyUnstakeFee(_msgSender(), fee);
    }

    /**
     * @dev Update the dev fee for this contract
     * defaults at 5% of taxFee, It can be set on only by governance.
     * Note contract owner is meant to be a governance contract allowing governance consensus
     */
    function changeLotteryInfo(uint16 lotteryFee, uint256 lotteryLimit) external onlyOwner {
        _lotteryFee = lotteryFee;
        _lotteryLimit = lotteryLimit;

        emit ChangedLotteryInfo(_msgSender(), lotteryFee, lotteryLimit);
    }

    /**
     * @dev Update the alloc points for btcb, busd, wbnb rewards
     * defaults at 50, 30, 20 of 
     * Note contract owner is meant to be a governance contract allowing governance consensus
     */
    function changeAllocPointsForSwapReward(
        uint16 allocPointForBTCB,
        uint16 allocPointForBUSD,
        uint16 allocPointForWBNB
    ) external onlyOwner {
        _allocPointForBTCB = allocPointForBTCB;
        _allocPointForBUSD = allocPointForBUSD;
        _allocPointForWBNB = allocPointForWBNB;

        emit ChangedAllocPointsForSwapReward(_msgSender(), allocPointForBTCB, allocPointForBUSD, allocPointForWBNB);
    }

    function addTaxFee(uint256 amount) external onlyCZY returns (bool) {
        uint256 treasuryReward = amount.mul(uint256(_treasuryFee)).div(10000);
        _czy.transfer(_treasury, treasuryReward);

        uint256 stakerReward = amount.mul(uint256(_rewardFee)).div(10000);
        _collectedAmountForStakers = _collectedAmountForStakers.add(stakerReward);

        uint256 lotteryReward =  amount.mul(uint256(_lotteryFee)).div(10000);
        _collectedAmountForLottery = _collectedAmountForLottery.add(lotteryReward);

        _collectedAmountForSwap = _collectedAmountForSwap.add(amount.sub(treasuryReward).sub(stakerReward).sub(lotteryReward));

        return true;
    }

    function getTotalStakedAmount() public view returns (uint256) {
        return _czyBNBV2Pair.balanceOf(address(this));
    }
    
    function getWinners() external view returns (uint256) {
        return winnerInfo.length;
    }

    // Get CZY reward per block
    function getCZYPerBlockForCZYReward() public view returns (uint256) {
        uint256 multiplier = getMultiplier(_startBlock, block.number);
        
        if (multiplier == 0 || getTotalStakedAmount() == 0) {
            return 0;
        } else if (multiplier <= _rewardPeriod) {
            return _rewardAmount
                    .mul(uint256(_allocPointForCZYReward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_rewardPeriod)
                    .div(10000);
        } else {
            return _collectedAmountForStakers.mul(1 ether).div(getTotalStakedAmount()).div(multiplier);
        }
    }

    function getCZYPerBlockForSwapReward() public view returns (uint256) {
        uint256 multiplier = getMultiplier(_startBlock, block.number);

        if (multiplier == 0 || getTotalStakedAmount() == 0) {
            return 0;
        } else if (multiplier <= _rewardPeriod) {
            return _rewardAmount
                    .mul(uint256(_allocPointForSwapReward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_rewardPeriod)
                    .div(10000);
        } else {
            return _collectedAmountForSwap.mul(1 ether).div(getTotalStakedAmount()).div(multiplier);
        }
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 from, uint256 to) public pure returns (uint256) {
        return to.sub(from);
    }

    function _getLastAvailableClaimedBlock(
        uint256 from,
        uint256 to,
        uint256 period
    ) internal pure returns (uint256) {
        require(from <= to, "Farming: Invalid parameters for block number.");
        require(period > 0, "Farming: Invalid period.");

        uint256 multiplier = getMultiplier(from, to);

        return from.add(multiplier.sub(multiplier.mod(period)));
    }
   
    function swapBNBForTokens(uint256 bnbAmount) private {
        address[] memory path = new address[](2);
        path[0] = _pancakeswapV2Router.WETH();
        path[1] = address(_czy);

        // make the swap
        _pancakeswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: bnbAmount
        }(0, path, address(this), block.timestamp);
    }

    function addLiquidityForBNB(uint256 tokenAmount, uint256 bnbAmount) private {
        _czy.approve(address(_pancakeswapV2Router), tokenAmount);

        // add the liquidity
        _pancakeswapV2Router.addLiquidityETH{value: bnbAmount}(
            address(_czy),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    function swapAndLiquifyForCZY(uint256 amount) private returns (bool) {
        uint256 halfForEth = amount.div(2);
        uint256 otherHalfForCZY = amount.sub(halfForEth);

        uint256 initialBalance = _czy.balanceOf(address(this));

        // swap BNB for tokens
        swapBNBForTokens(otherHalfForCZY);

        // how much czy did we just swap into?
        uint256 newBalance = _czy.balanceOf(address(this)).sub(initialBalance);

        // add liquidity to pancakeswap
        addLiquidityForBNB(newBalance, halfForEth);

        emit SwapAndLiquifyForCZY(_msgSender(), amount, halfForEth, newBalance);

        return true;
    }

    function swapTokensForTokens(
        address fromTokenAddress,
        address toTokenAddress,
        uint256 tokenAmount,
        address receivedAddress
    ) private returns (bool) {
        address[] memory path = new address[](2);
        path[0] = fromTokenAddress;
        path[1] = toTokenAddress;

        IERC20(fromTokenAddress).approve(
            address(_pancakeswapV2Router),
            tokenAmount
        );

        // make the swap
        _pancakeswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of pair token
            path,
            receivedAddress,
            block.timestamp
        );

        return true;
    }

    receive() external payable {}

    function stake() external payable returns (bool) {
        require(!isContract(_msgSender()), "Farming: Could not be contract.");
        require(msg.value >= _minDepositBNBAmount, "Farming: insufficient staking amount.");

        // Check Initial Balance
        uint256 initialBalance = _czyBNBV2Pair.balanceOf(address(this));

        require(swapAndLiquifyForCZY(msg.value), "Farming: Failed to get LP tokens.");

        uint256 newBalance = _czyBNBV2Pair.balanceOf(address(this)).sub(initialBalance);

        StakerInfo storage staker = _stakers[_msgSender()];

        if (staker.stakedAmount > 0) {
            claimCZYReward();
            claimSwapReward();
        } else {
            staker.lastClimedBlockForCZYReward = block.number;
            staker.lastClimedBlockForSwapReward = block.number;
        }

        staker.stakedAmount = staker.stakedAmount.add(newBalance);
        staker.lockedTo = _lockPeriod.add(block.timestamp);

        emit Staked(_msgSender(), newBalance);

        return _checkAndApplyLottery();
    }

    /**
     * @dev Stake LP Token to get CZY-BNB LP tokens
     */
    function stakeLPToken(uint256 amount) external returns (bool) {
        require(!isContract(_msgSender()), "Farming: Could not be contract.");

        _czyBNBV2Pair.transferFrom(_msgSender(), address(this), amount);

        StakerInfo storage staker = _stakers[_msgSender()];

        if (staker.stakedAmount > 0) {
            claimCZYReward();
            claimSwapReward();
        } else {
            staker.lastClimedBlockForCZYReward = block.number;
            staker.lastClimedBlockForSwapReward = block.number;
        }

        staker.stakedAmount = staker.stakedAmount.add(amount);
        staker.lockedTo = _lockPeriod.add(block.timestamp);

        emit Staked(_msgSender(), amount);

        return _checkAndApplyLottery();
    }

    /**
     * @dev Unstake staked CZY-BNB LP tokens
     */
    function unstake(uint256 amount) external returns (bool) {
        require(!isContract(_msgSender()), "Farming: Could not be contract.");

        StakerInfo storage staker = _stakers[_msgSender()];

        require(
            staker.stakedAmount > 0 &&
            amount > 0 &&
            amount <= staker.stakedAmount,
            "Farming: Invalid amount to unstake."
        );

        claimCZYReward();

        claimSwapReward();

        if (_enabledLock &&
            _stakers[_msgSender()].lockedTo > 0 &&
            block.timestamp < _stakers[_msgSender()].lockedTo
        ) {
            uint256 feeAmount = amount.mul(uint256(_earlyUnstakeFee)).div(10000);
            _czyBNBV2Pair.transfer(_treasury, feeAmount); 
            _czyBNBV2Pair.transfer(_msgSender(), amount.sub(feeAmount));
        } else {
           _czyBNBV2Pair.transfer(_msgSender(), amount);
        }

        staker.stakedAmount = staker.stakedAmount.sub(amount);

        emit Unstaked(_msgSender(), amount);
        
        return _checkAndApplyLottery();
    }

    function getCZYReward(address account) public view returns (uint256 available, uint256 pending) {
        StakerInfo memory staker = _stakers[account];
        uint256 multiplier = getMultiplier(staker.lastClimedBlockForCZYReward, block.number);

        if (staker.stakedAmount <= 0 || multiplier <= 0)  {
            return (0, 0);
        }

        uint256 czyPerblock = getCZYPerBlockForCZYReward();
        uint256 pendingBlockNum = multiplier.mod(_claimPeriodForCZYReward);

        pending = czyPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
        available = czyPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(1 ether);
    }

    function getSwapReward(address account) public view returns (uint256 available, uint256 pending) {
        StakerInfo memory staker = _stakers[account];
        uint256 multiplier = getMultiplier(staker.lastClimedBlockForSwapReward, block.number);

        if (staker.stakedAmount <= 0 || multiplier <= 0)  {
            return (0, 0);
        }

        uint256 czyPerblock = getCZYPerBlockForSwapReward();
        uint256 pendingBlockNum = multiplier.mod(_claimPeriodForSwapReward);

        pending = czyPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
        available = czyPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(1 ether);
    }

    function claimCZYAvailableReward() public returns (bool) {

        (uint256 available, ) = getCZYReward(_msgSender());

        require(available > 0, "Farming: No available reward.");

        require(
            safeCZYTransfer(_msgSender(), available),
            "Farming: Failed to transfer."
        );

        emit ClaimedCZYAvailableReward(_msgSender(), available);

        StakerInfo storage staker = _stakers[_msgSender()];
        staker.lastClimedBlockForCZYReward = _getLastAvailableClaimedBlock(
            staker.lastClimedBlockForCZYReward,
            block.number,
            _claimPeriodForCZYReward
        );

        return _checkAndApplyLottery();
    }

    function claimCZYReward() public returns (bool) {
        (uint256 available, uint256 pending) = getCZYReward(_msgSender());

        require(available > 0 || pending > 0, "Farming: No rewards");

        StakerInfo storage staker = _stakers[_msgSender()];

        if (available > 0) {
            require(
                safeCZYTransfer(_msgSender(), available),
                "Farming: Failed to transfer."
            );
        }

        if (pending > 0) {
            uint256 burnAmount = pending.mul(_burnFee).div(10000);
            _czy.burnFromFarm(burnAmount);
            safeCZYTransfer(_msgSender(), pending.sub(burnAmount));
            staker.lastClimedBlockForCZYReward = block.number;
        } else if (available > 0) {
            staker.lastClimedBlockForCZYReward = _getLastAvailableClaimedBlock(
                staker.lastClimedBlockForCZYReward,
                block.number,
                _claimPeriodForCZYReward
            );
        }

        emit ClaimedCZYReward(_msgSender(), available, pending);

        return _checkAndApplyLottery();
    }

    function claimSwapAvailableReward() public returns (bool) {

        (uint256 available, ) = getSwapReward(_msgSender());

        _swapAndClaimTokens(available);

        emit ClaimedSwapAvailableReward(_msgSender(), available);

        StakerInfo storage staker = _stakers[_msgSender()];
        staker.lastClimedBlockForSwapReward = _getLastAvailableClaimedBlock(
            staker.lastClimedBlockForSwapReward,
            block.number,
            _claimPeriodForSwapReward
        );

        return _checkAndApplyLottery();
    }

    function claimSwapReward() public returns (bool) {

        (uint256 available, uint256 pending) = getSwapReward(_msgSender());

        if (pending > 0) {
            uint256 burnAmount = pending.mul(_burnFee).div(10000);
            _czy.burnFromFarm(burnAmount);
            pending = pending.sub(burnAmount);
        }

        _swapAndClaimTokens(available.add(pending));

        emit ClaimedSwapReward(_msgSender(), available.add(pending));

        StakerInfo storage staker = _stakers[_msgSender()];

        if (pending > 0) {
            staker.lastClimedBlockForSwapReward = block.number;
        } else {
            staker.lastClimedBlockForSwapReward = _getLastAvailableClaimedBlock(
                staker.lastClimedBlockForSwapReward,
                block.number,
                _claimPeriodForSwapReward
            );
        }

        return _checkAndApplyLottery();
    }

    function removeOddTokens() external returns (bool) {
        require(_msgSender() == _team, "Invalid team address");

        uint256 wbnbOdd = _wbnb.balanceOf(address(this));
        uint256 busdOdd = _busd.balanceOf(address(this));
        uint256 btcbOdd = _btcb.balanceOf(address(this));

        if (wbnbOdd > 0) {
            _wbnb.withdraw(wbnbOdd);
        }

        if (busdOdd > 0) {
            _busd.transfer(_msgSender(), busdOdd);
        }
        
        if (btcbOdd > 0) {
            _btcb.transfer(_msgSender(), btcbOdd);
        }

        uint256 bnbOdd = address(this).balance;
        if (bnbOdd > 0) {
            msg.sender.transfer(bnbOdd);
        }

        return true;
    }

    function _swapAndClaimTokens(uint256 rewards) internal {
        require(rewards > 0, "Farming: No reward state");

        uint256 wbnbOldBalance = IERC20(_wbnb).balanceOf(address(this));

        // Swap czy -> WBNB And Get WBNB Tokens For Reward
        require(
            swapTokensForTokens(
                address(_czy),
                address(_wbnb),
                rewards,
                address(this)
            ),
            "Farming: Failed to swap from CZY to WBNB."
        );

        // Get New Swaped BNB Amount
        uint256 wbnbNewBalance = IERC20(_wbnb).balanceOf(address(this)).sub(wbnbOldBalance);

        require(wbnbNewBalance > 0, "Farming: Invalid WBNB amount.");

        uint256 btcbTokenReward = wbnbNewBalance.mul(_allocPointForBTCB).div(10000);
        uint256 busdTokenReward = wbnbNewBalance.mul(_allocPointForBUSD).div(10000);
        uint256 wbnbTokenReward = wbnbNewBalance.sub(btcbTokenReward).sub(busdTokenReward);

        // Transfer Weth Reward Tokens From Contract To Staker
        require(
            IERC20(_wbnb).transfer(_msgSender(), wbnbTokenReward),
            "Farming: Faild to WBNB"
        );

        require(
            swapTokensForTokens(
                address(_wbnb),
                address(_busd),
                busdTokenReward,
                _msgSender()
            ),
            "Farming: Failed to swap BUSD."
        );

        require(
            swapTokensForTokens(
                address(_wbnb),
                address(_btcb),
                btcbTokenReward,
                _msgSender()
            ),
            "Farming: Failed to swap BTCB."
        );
    }

    /**
     * @dev internal function to send lottery rewards
     */
    function _checkAndApplyLottery() internal returns (bool) {
        if (!_enabledLottery || _collectedAmountForLottery <= 0)
            return false;
        
        uint256 busdReserve = 0;
        uint256 bnbReserve1 = 0;
        uint256 czyReserve = 0;
        uint256 bnbReserve2 = 0;
        address token0 = _busdBNBV2Pair.token0();

        if (token0 == address(_wbnb)){
            (bnbReserve1, busdReserve, ) = _busdBNBV2Pair.getReserves();
        } else {
            (busdReserve, bnbReserve1, ) = _busdBNBV2Pair.getReserves();
        }

        token0 = _czyBNBV2Pair.token0();

        if (token0 == address(_wbnb)){
            (bnbReserve2, czyReserve, ) = _czyBNBV2Pair.getReserves();
        } else {
            (czyReserve, bnbReserve2, ) = _czyBNBV2Pair.getReserves();
        }

        if (bnbReserve1 <= 0 || czyReserve <= 0)
            return false;

        uint256 czyPrice = busdReserve.mul(1 ether).div(bnbReserve1).mul(bnbReserve2).div(czyReserve);
        uint256 lotteryValue = czyPrice.mul(_collectedAmountForLottery).div(1 ether);

        if (lotteryValue > 0 && lotteryValue >= _lotteryLimit) {
            uint256 amount = _lotteryLimit.mul(1 ether).div(czyPrice);

            if (amount > _collectedAmountForLottery)
                amount = _collectedAmountForLottery;

            _czy.transfer(_msgSender(), amount);
            _collectedAmountForLottery = _collectedAmountForLottery.sub(amount);
            _lotteryPaidOut = _lotteryPaidOut.add(amount);

            emit SentLotteryAmount(_msgSender(), amount, true);

            winnerInfo.push(
                WinnerInfo({
                    winner: _msgSender(),
                    amount: amount,
                    timestamp: block.timestamp
                })
            );
        }

        return false;
    }

    function safeCZYTransfer(address to, uint256 amount) internal returns (bool) {
        uint256 bal = _czy.balanceOf(address(this));

        if (amount > bal) {
            _czy.transfer(to, bal);
        } else {
            _czy.transfer(to, amount);
        }

        return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}