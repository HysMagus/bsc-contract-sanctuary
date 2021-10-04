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

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface TokenInterface is IERC20 {
    function burnFromVault(uint256 amount) external returns (bool);
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IPancakeSwapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

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

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
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

contract Dao888Vault is Context, Ownable {
    using SafeMath for uint256;

    TokenInterface public _dao888;
    TokenInterface public _bifi;
    TokenInterface public _btcb;
    TokenInterface public _wbnb;

    IPancakeSwapV2Pair public _dao888BNBV2Pair;
    IPancakeSwapV2Pair public _busdBNBV2Pair;

    IPancakeSwapV2Router02 private _pancakeswapV2Router;

    address public _daoTreasury;

    uint16 public _allocPointFor888Reward;
    uint16 public _allocPointForSwapReward;

    uint16 public _treasuryFee;
    uint16 public _rewardFee;
    uint16 public _lotteryFee;
    uint16 public _burnFee;
    uint16 public _earlyUnstakeFee;

    uint16 public _allocPointForBIFI;
    uint16 public _allocPointForBTCB;
    uint16 public _allocPointForWBNB;

    uint256 public _firstRewardPeriod;
    uint256 public _secondRewardPeriod;

    uint256 public _firstRewardAmount;
    uint256 public _secondRewardAmount;

    uint256 public _claimPeriodFor888Reward;
    uint256 public _claimPeriodForSwapReward;

    uint256 public _lockPeriod;

    uint256 public _minDepositETHAmount;

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
        uint256 lastClimedBlockFor888Reward;
        uint256 lastClimedBlockForSwapReward;
        uint256 lockedTo;
    }

    mapping(address => StakerInfo) public _stakers;

    // Info of winners for lottery.
    struct WinnerInfo {
        address winner;
        uint256 amount;
        uint256 timestamp;
    }
    WinnerInfo[] public winnerInfo;

    event ChangedEnabledLock(address indexed owner, bool lock);
    event ChangedEnabledLottery(address indexed owner, bool lottery);
    event ChangedLockPeriod(address indexed owner, uint256 period);
    event ChangedMinimumETHDepositAmount(address indexed owner, uint256 value);
    event ChangedRewardPeriod(
        address indexed owner,
        uint256 firstRewardPeriod,
        uint256 secondRewardPeriod
    );
    event ChangedClaimPeriod(
        address indexed owner,
        uint256 claimPeriodFor888Reward,
        uint256 claimPeriodForSwapReward
    );
    event Changed888Address(address indexed owner, address indexed dao888);
    event Changed888ETHPair(
        address indexed owner,
        address indexed dao888ETHPair
    );
    event ChangedFeeInfo(
        address indexed owner,
        uint16 treasuryFee,
        uint16 rewardFee,
        uint16 lotteryFee,
        uint16 burnFee
    );
    event ChangedAllocPointsForSwapReward(
        address indexed owner,
        uint16 valueForBIFI,
        uint16 valueForBTCB,
        uint16 valueForWBNB
    );
    event ChangedBurnFee(address indexed owner, uint16 value);
    event ChangedEarlyUnstakeFee(address indexed owner, uint16 value);
    event ChangedLotteryInfo(
        address indexed owner,
        uint16 lotteryFee,
        uint256 lotteryLimit
    );

    event Claimed888AvailableReward(address indexed owner, uint256 amount);
    event ClaimedSwapAvailableReward(address indexed owner, uint256 amount);
    event Claimed888Reward(
        address indexed owner,
        uint256 available,
        uint256 pending
    );
    event ClaimedSwapReward(address indexed owner, uint256 amount);

    event Staked(address indexed account, uint256 amount);
    event Unstaked(address indexed account, uint256 amount);

    event SentLotteryAmount(address indexed owner, uint256 amount, bool status);
    event SwapAndLiquifyFor888(
        address indexed msgSender,
        uint256 totAmount,
        uint256 ethAmount,
        uint256 dao888Amount
    );

    // Modifier

    modifier only888() {
        require(
            address(_dao888) == _msgSender(),
            "Ownable: caller is not the 888 token contract"
        );
        _;
    }

    constructor(
        address daoTreasury,
        address bifi,
        address btcb,
        address wbnb,
        address busdBNBV2Pair
    ) {
        _daoTreasury = daoTreasury;

        _bifi = TokenInterface(bifi);
        _btcb = TokenInterface(btcb);
        _wbnb = TokenInterface(wbnb);

        _busdBNBV2Pair = IPancakeSwapV2Pair(busdBNBV2Pair);
        _pancakeswapV2Router = IPancakeSwapV2Router02(
            0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F
        );

        _firstRewardPeriod = 316800; // around 11 days, could be changed by governance
        _secondRewardPeriod = 2217600; // around 77 days, could be changed by governance

        _firstRewardAmount = 1888e18; // 1888 888 tokens, could be changed by governance
        _secondRewardAmount = 6112e18; // 6112 888 tokens, could be changed by governance

        _claimPeriodFor888Reward = 403200; // around 14 days, could be changed by governance
        _claimPeriodForSwapReward = 2592000; // around 90 days, could be changed by governance

        _allocPointFor888Reward = 8000; // 80% of reward will go to 888 reward, could be changed by governance
        _allocPointForSwapReward = 2000; // 20% of reward will go to swap(wbnb, btcb, bifi) reward, could be changed by governance

        // Set values divited from taxFee
        _treasuryFee = 2500; // 25% of taxFee to treasuryFee, could be changed by governance
        _rewardFee = 5000; // 50% of taxFee to stakers, could be changed by governance
        _lotteryFee = 500; // 5% of lottery Fee, could be changed by governance

        _earlyUnstakeFee = 1000; // 10% of early unstake fee, could be changed by governance

        // set alloc points of BIFI, BTCB, WBNB in swap rewards, could be changed by governance
        _allocPointForBIFI = 3000; // 30% of fee to buy BIFI token, could be changed by governance
        _allocPointForBTCB = 5000; // 50% of fee to buy BTCB token, could be changed by governance
        _allocPointForWBNB = 2000; // 20% of fee to buy WBNB token, could be changed by governance

        // set the burn fee for withdraw early
        _burnFee = 2000; // 20% of pending reward to burn when staker request to withdraw pending reward, could be changed by governance

        _minDepositETHAmount = 1e17; // 0.1 bnb, could be changed by governance
        _lockPeriod = 90 days; // could be changed by governance

        _enabledLock = true; // could be changed by governance
        _enabledLottery = true; // could be changed by governance

        _lotteryLimit = 1200e18; // $1200(1200 usd, decimals 18), could be changed by governance
        _startBlock = block.number;
    }

    /**
     * @dev Change Minimum Deposit BNB Amount. Call by only Governance.
     */
    function changeMinimumDepositETHAmount(uint256 amount) external onlyOwner {
        _minDepositETHAmount = amount;

        emit ChangedMinimumETHDepositAmount(_msgSender(), amount);
    }

    /**
     * @dev Change value of reward period. Call by only Governance.
     */
    function changeRewardPeriod(
        uint256 firstRewardPeriod,
        uint256 secondRewardPeriod
    ) external onlyOwner {
        _firstRewardPeriod = firstRewardPeriod;
        _secondRewardPeriod = secondRewardPeriod;

        emit ChangedRewardPeriod(
            _msgSender(),
            firstRewardPeriod,
            secondRewardPeriod
        );
    }

    /**
     * @dev Change value of claim period. Call by only Governance.
     */
    function changeClaimPeriod(
        uint256 claimPeriodFor888Reward,
        uint256 claimPeriodForSwapReward
    ) external onlyOwner {
        _claimPeriodFor888Reward = claimPeriodFor888Reward;
        _claimPeriodForSwapReward = claimPeriodForSwapReward;

        emit ChangedClaimPeriod(
            _msgSender(),
            claimPeriodFor888Reward,
            claimPeriodForSwapReward
        );
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

    function change888Address(address dao888) external onlyOwner {
        _dao888 = TokenInterface(dao888);

        emit Changed888Address(_msgSender(), dao888);
    }

    function change888BNBPair(address dao888ETHPair) external onlyOwner {
        _dao888BNBV2Pair = IPancakeSwapV2Pair(dao888ETHPair);

        emit Changed888ETHPair(_msgSender(), dao888ETHPair);
    }

    /**
     * @dev Update the treasury fee for this contract
     * defaults at 25% of taxFee, It can be set on only by 888 governance.
     * Note contract owner is meant to be a governance contract allowing 888 governance consensus
     */
    function changeFeeInfo(
        uint16 treasuryFee,
        uint16 rewardFee,
        uint16 lotteryFee,
        uint16 burnFee
    ) external onlyOwner {
        _treasuryFee = treasuryFee;
        _rewardFee = rewardFee;
        _lotteryFee = lotteryFee;
        _burnFee = burnFee;

        emit ChangedFeeInfo(
            _msgSender(),
            treasuryFee,
            rewardFee,
            lotteryFee,
            burnFee
        );
    }

    function changeEarlyUnstakeFee(uint16 fee) external onlyOwner {
        _earlyUnstakeFee = fee;

        emit ChangedEarlyUnstakeFee(_msgSender(), fee);
    }

    /**
     * @dev Update the dev fee for this contract
     * defaults at 5% of taxFee, It can be set on only by 888 governance.
     * Note contract owner is meant to be a governance contract allowing 888 governance consensus
     */
    function changeLotteryInfo(uint16 lotteryFee, uint256 lotteryLimit)
        external
        onlyOwner
    {
        _lotteryFee = lotteryFee;
        _lotteryLimit = lotteryLimit;

        emit ChangedLotteryInfo(_msgSender(), lotteryFee, lotteryLimit);
    }

    /**
     * @dev Update the alloc points for bifi, wbnb, btcb rewards
     * defaults at 50, 30, 20 of
     * Note contract owner is meant to be a governance contract allowing 888 governance consensus
     */
    function changeAllocPointsForSwapReward(
        uint16 allocPointForBIFI_,
        uint16 allocPointForBTCB_,
        uint16 allocPointForWBNB_
    ) external onlyOwner {
        _allocPointForBIFI = allocPointForBIFI_;
        _allocPointForBTCB = allocPointForBTCB_;
        _allocPointForWBNB = allocPointForWBNB_;

        emit ChangedAllocPointsForSwapReward(
            _msgSender(),
            allocPointForBIFI_,
            allocPointForBTCB_,
            allocPointForWBNB_
        );
    }

    function addTaxFee(uint256 amount) external only888 returns (bool) {
        uint256 daoTreasuryReward =
            amount.mul(uint256(_treasuryFee)).div(10000);
        _dao888.transfer(_daoTreasury, daoTreasuryReward);

        uint256 stakerReward = amount.mul(uint256(_rewardFee)).div(10000);
        _collectedAmountForStakers = _collectedAmountForStakers.add(
            stakerReward
        );

        uint256 lotteryReward = amount.mul(uint256(_lotteryFee)).div(10000);
        _collectedAmountForLottery = _collectedAmountForLottery.add(
            lotteryReward
        );

        _collectedAmountForSwap = _collectedAmountForSwap.add(
            amount.sub(daoTreasuryReward).sub(stakerReward).sub(lotteryReward)
        );

        return true;
    }

    function getTotalStakedAmount() public view returns (uint256) {
        return _dao888BNBV2Pair.balanceOf(address(this));
    }

    function getWinners() external view returns (uint256) {
        return winnerInfo.length;
    }

    // Get 888 reward per block
    function get888PerBlockFor888Reward() public view returns (uint256) {
        uint256 multiplier = getMultiplier(_startBlock, block.number);

        if (multiplier == 0 || getTotalStakedAmount() == 0) {
            return 0;
        } else if (multiplier <= _firstRewardPeriod) {
            return
                _firstRewardAmount
                    .mul(uint256(_allocPointFor888Reward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_firstRewardPeriod)
                    .div(10000);
        } else if (
            multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod
        ) {
            return
                _secondRewardAmount
                    .mul(uint256(_allocPointFor888Reward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_secondRewardPeriod)
                    .div(10000);
        } else {
            return
                _collectedAmountForStakers
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(multiplier);
        }
    }

    function get888PerBlockForSwapReward() public view returns (uint256) {
        uint256 multiplier = getMultiplier(_startBlock, block.number);

        if (multiplier == 0 || getTotalStakedAmount() == 0) {
            return 0;
        } else if (multiplier <= _firstRewardPeriod) {
            return
                _firstRewardAmount
                    .mul(uint256(_allocPointForSwapReward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_firstRewardPeriod)
                    .div(10000);
        } else if (
            multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod
        ) {
            return
                _secondRewardAmount
                    .mul(uint256(_allocPointForSwapReward))
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(_secondRewardPeriod)
                    .div(10000);
        } else {
            return
                _collectedAmountForSwap
                    .mul(1 ether)
                    .div(getTotalStakedAmount())
                    .div(multiplier);
        }
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 from, uint256 to)
        public
        pure
        returns (uint256)
    {
        return to.sub(from);
    }

    function _getLastAvailableClaimedBlock(
        uint256 from,
        uint256 to,
        uint256 period
    ) internal pure returns (uint256) {
        require(from <= to, "Vault: Invalid parameters for block number.");
        require(period > 0, "Vault: Invalid period.");

        uint256 multiplier = getMultiplier(from, to);

        return from.add(multiplier.sub(multiplier.mod(period)));
    }

    function swapBNBForTokens(uint256 bnbAmount) private {
        // generate the pancakeswap pair path of wbnb -> dao888
        address[] memory path = new address[](2);
        path[0] = _pancakeswapV2Router.WETH();
        path[1] = address(_dao888);

        // make the swap
        _pancakeswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: bnbAmount
        }(0, path, address(this), block.timestamp);
    }

    function addLiquidityForEth(uint256 tokenAmount, uint256 bnbAmount)
        private
    {
        _dao888.approve(address(_pancakeswapV2Router), tokenAmount);

        // add the liquidity
        _pancakeswapV2Router.addLiquidityETH{value: bnbAmount}(
            address(_dao888),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    function swapAndLiquifyFor888(uint256 amount) private returns (bool) {
        uint256 halfForBNB = amount.div(2);
        uint256 otherHalfFor888 = amount.sub(halfForBNB);

        // capture the contract's current BNB balance.
        // this is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // has been manually sent to the contract
        uint256 initialBalance = _dao888.balanceOf(address(this));

        // swap BNB for tokens
        swapBNBForTokens(otherHalfFor888);

        // how much 888 did we just swap into?
        uint256 newBalance =
            _dao888.balanceOf(address(this)).sub(initialBalance);

        // add liquidity to pancakeswap
        addLiquidityForEth(newBalance, halfForBNB);

        emit SwapAndLiquifyFor888(_msgSender(), amount, halfForBNB, newBalance);

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
        _pancakeswapV2Router
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
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
        require(!isContract(_msgSender()), "Vault: Could not be contract.");
        require(
            msg.value >= _minDepositETHAmount,
            "Vault: insufficient staking amount."
        );

        // Check Initial Balance
        uint256 initialBalance = _dao888BNBV2Pair.balanceOf(address(this));

        // Call swap for 888&BNB
        require(
            swapAndLiquifyFor888(msg.value),
            "Vault: Failed to get LP tokens."
        );

        uint256 newBalance =
            _dao888BNBV2Pair.balanceOf(address(this)).sub(initialBalance);

        StakerInfo storage staker = _stakers[_msgSender()];

        if (staker.stakedAmount > 0) {
            claim888Reward();
            claimSwapReward();
        } else {
            staker.lastClimedBlockFor888Reward = block.number;
            staker.lastClimedBlockForSwapReward = block.number;
        }

        staker.stakedAmount = staker.stakedAmount.add(newBalance);
        staker.lockedTo = _lockPeriod.add(block.timestamp);

        emit Staked(_msgSender(), newBalance);

        return _sendLotteryAmount();
    }

    /**
     * @dev Stake LP Token to get 888-BNB LP tokens
     */
    function stakeLPToken(uint256 amount) external returns (bool) {
        require(!isContract(_msgSender()), "Vault: Could not be contract.");

        _dao888BNBV2Pair.transferFrom(_msgSender(), address(this), amount);

        StakerInfo storage staker = _stakers[_msgSender()];

        if (staker.stakedAmount > 0) {
            claim888Reward();
            claimSwapReward();
        } else {
            staker.lastClimedBlockFor888Reward = block.number;
            staker.lastClimedBlockForSwapReward = block.number;
        }

        staker.stakedAmount = staker.stakedAmount.add(amount);
        staker.lockedTo = _lockPeriod.add(block.timestamp);

        emit Staked(_msgSender(), amount);

        return _sendLotteryAmount();
    }

    /**
     * @dev Unstake staked 888-BNB LP tokens
     */
    function unstake(uint256 amount) external returns (bool) {
        require(!isContract(_msgSender()), "Vault: Could not be contract.");

        StakerInfo storage staker = _stakers[_msgSender()];

        require(
            staker.stakedAmount > 0 &&
                amount > 0 &&
                amount <= staker.stakedAmount,
            "Vault: Invalid amount to unstake."
        );

        claim888Reward();

        claimSwapReward();

        if (
            _enabledLock &&
            _stakers[_msgSender()].lockedTo > 0 &&
            block.timestamp < _stakers[_msgSender()].lockedTo
        ) {
            uint256 feeAmount =
                amount.mul(uint256(_earlyUnstakeFee)).div(10000);
            _dao888BNBV2Pair.transfer(_daoTreasury, feeAmount);
            _dao888BNBV2Pair.transfer(_msgSender(), amount.sub(feeAmount));
        } else {
            _dao888BNBV2Pair.transfer(_msgSender(), amount);
        }

        staker.stakedAmount = staker.stakedAmount.sub(amount);

        emit Unstaked(_msgSender(), amount);

        return _sendLotteryAmount();
    }

    function get888Reward(address account)
        public
        view
        returns (uint256 available, uint256 pending)
    {
        StakerInfo memory staker = _stakers[account];
        uint256 multiplier =
            getMultiplier(staker.lastClimedBlockFor888Reward, block.number);

        if (staker.stakedAmount <= 0 || multiplier <= 0) {
            return (0, 0);
        }

        uint256 dao888Perblock = get888PerBlockFor888Reward();
        uint256 pendingBlockNum = multiplier.mod(_claimPeriodFor888Reward);

        pending = dao888Perblock
            .mul(pendingBlockNum)
            .mul(staker.stakedAmount)
            .div(1 ether);
        available = dao888Perblock
            .mul(multiplier.sub(pendingBlockNum))
            .mul(staker.stakedAmount)
            .div(1 ether);
    }

    function getSwapReward(address account)
        public
        view
        returns (uint256 available, uint256 pending)
    {
        StakerInfo memory staker = _stakers[account];
        uint256 multiplier =
            getMultiplier(staker.lastClimedBlockForSwapReward, block.number);

        if (staker.stakedAmount <= 0 || multiplier <= 0) {
            return (0, 0);
        }

        uint256 dao888Perblock = get888PerBlockForSwapReward();
        uint256 pendingBlockNum = multiplier.mod(_claimPeriodForSwapReward);

        pending = dao888Perblock
            .mul(pendingBlockNum)
            .mul(staker.stakedAmount)
            .div(1 ether);
        available = dao888Perblock
            .mul(multiplier.sub(pendingBlockNum))
            .mul(staker.stakedAmount)
            .div(1 ether);
    }

    function claim888AvailableReward() public returns (bool) {
        (uint256 available, ) = get888Reward(_msgSender());

        require(available > 0, "Vault: No available reward.");

        require(
            safe888Transfer(_msgSender(), available),
            "Vault: Failed to transfer."
        );

        emit Claimed888AvailableReward(_msgSender(), available);

        StakerInfo storage staker = _stakers[_msgSender()];
        staker.lastClimedBlockFor888Reward = _getLastAvailableClaimedBlock(
            staker.lastClimedBlockFor888Reward,
            block.number,
            _claimPeriodFor888Reward
        );

        return _sendLotteryAmount();
    }

    function claim888Reward() public returns (bool) {
        (uint256 available, uint256 pending) = get888Reward(_msgSender());

        require(available > 0 || pending > 0, "Vault: No rewards");

        StakerInfo storage staker = _stakers[_msgSender()];

        if (available > 0) {
            require(
                safe888Transfer(_msgSender(), available),
                "Vault: Failed to transfer."
            );
        }

        if (pending > 0) {
            uint256 burnAmount = pending.mul(_burnFee).div(10000);
            _dao888.burnFromVault(burnAmount);
            safe888Transfer(_msgSender(), pending.sub(burnAmount));
            staker.lastClimedBlockFor888Reward = block.number;
        } else if (available > 0) {
            staker.lastClimedBlockFor888Reward = _getLastAvailableClaimedBlock(
                staker.lastClimedBlockFor888Reward,
                block.number,
                _claimPeriodFor888Reward
            );
        }

        emit Claimed888Reward(_msgSender(), available, pending);

        return _sendLotteryAmount();
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

        return _sendLotteryAmount();
    }

    function claimSwapReward() public returns (bool) {
        (uint256 available, uint256 pending) = getSwapReward(_msgSender());

        if (pending > 0) {
            uint256 burnAmount = pending.mul(_burnFee).div(10000);
            _dao888.burnFromVault(burnAmount);
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

        return _sendLotteryAmount();
    }

    function _swapAndClaimTokens(uint256 rewards) internal {
        require(rewards > 0, "Vault: No reward state");

        uint256 wbnbOldBalance = IERC20(_wbnb).balanceOf(address(this));

        // Swap 888 -> WBNB And Get Weth Tokens For Reward
        require(
            swapTokensForTokens(
                address(_dao888),
                address(_wbnb),
                rewards,
                address(this)
            ),
            "Vault: Failed to swap from 888 to WBNB."
        );

        // Get New Swaped BNB Amount
        uint256 wbnbNewBalance =
            IERC20(_wbnb).balanceOf(address(this)).sub(wbnbOldBalance);

        require(wbnbNewBalance > 0, "Vault: Invalid WBNB amount.");

        uint256 bifiTokenReward =
            wbnbNewBalance.mul(_allocPointForBIFI).div(10000);
        uint256 btcbTokenReward =
            wbnbNewBalance.mul(_allocPointForBTCB).div(10000);
        uint256 wbnbTokenReward =
            wbnbNewBalance.sub(bifiTokenReward).sub(btcbTokenReward);

        // Transfer Weth Reward Tokens From Contract To Staker
        require(
            IERC20(_wbnb).transfer(_msgSender(), wbnbTokenReward),
            "Vault: Faild to WBNB"
        );

        // Swap WBNB -> BIFI and give BIFI token to User as reward
        require(
            swapTokensForTokens(
                address(_wbnb),
                address(_bifi),
                bifiTokenReward,
                _msgSender()
            ),
            "Vault: Failed to swap BIFI."
        );

        // Swap 888 -> BTCB and give BTCB token to User as reward
        require(
            swapTokensForTokens(
                address(_wbnb),
                address(_btcb),
                btcbTokenReward,
                _msgSender()
            ),
            "Vault: Failed to swap BTCB."
        );
    }

    /**
     * @dev internal function to send lottery rewards
     */
    function _sendLotteryAmount() internal returns (bool) {
        if (!_enabledLottery || _collectedAmountForLottery <= 0) return false;

        uint256 busdReserve = 0;
        uint256 bnbReserve1 = 0;
        uint256 dao888Reserve = 0;
        uint256 bnbReserve2 = 0;
        address token0 = _busdBNBV2Pair.token0();

        if (token0 == address(_wbnb)) {
            (bnbReserve1, busdReserve, ) = _busdBNBV2Pair.getReserves();
        } else {
            (busdReserve, bnbReserve1, ) = _busdBNBV2Pair.getReserves();
        }

        token0 = _dao888BNBV2Pair.token0();

        if (token0 == address(_wbnb)) {
            (bnbReserve2, dao888Reserve, ) = _dao888BNBV2Pair.getReserves();
        } else {
            (dao888Reserve, bnbReserve2, ) = _dao888BNBV2Pair.getReserves();
        }

        if (bnbReserve1 <= 0 || dao888Reserve <= 0) return false;

        uint256 dao888Price =
            busdReserve.mul(1 ether).div(bnbReserve1).mul(bnbReserve2).div(
                dao888Reserve
            );
        uint256 lotteryValue =
            dao888Price.mul(_collectedAmountForLottery).div(1 ether);

        if (lotteryValue > 0 && lotteryValue >= _lotteryLimit) {
            uint256 amount = _lotteryLimit.mul(1 ether).div(dao888Price);

            if (amount > _collectedAmountForLottery)
                amount = _collectedAmountForLottery;

            _dao888.transfer(_msgSender(), amount);
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

    function safe888Transfer(address to, uint256 amount)
        internal
        returns (bool)
    {
        uint256 dao888Bal = _dao888.balanceOf(address(this));

        if (amount > dao888Bal) {
            _dao888.transfer(to, dao888Bal);
        } else {
            _dao888.transfer(to, amount);
        }

        return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}