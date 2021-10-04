//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// import "hardhat/console.sol";

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
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

abstract contract Context {
  function _msgSender() internal view virtual returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this;
    return msg.data;
  }
}

abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface TokenInterface is IERC20 {
  function burnFromVault(uint256 amount) external returns (bool);
}

interface IPancakeSwapV2Pair {
  // interface IUniswapV2Pair {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  // function skim(address to) external;

  // function sync() external;

  // function initialize(address, address) external;
}

interface IPancakeSwapV2Router01 {
  // interface IUniswapV2Router01 {
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
  // interface IUniswapV2Router02 is IUniswapV2Router01 {
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

contract BZBVault is Context, Ownable {
  using SafeMath for uint256;

  TokenInterface public _bzb;
  TokenInterface public _wbnb;
  TokenInterface public _bfi;
  TokenInterface public _btcb;
  TokenInterface public _beth;

  // IUniswapV2Pair public _bzbBFIV2Pair;
  IPancakeSwapV2Pair public _bzbBFIV2Pair;

  // IUniswapV2Router02 private _pancakeswapV2Router;
  IPancakeSwapV2Router02 private _pancakeswapV2Router;

  address public _treasury;

  uint16 public _allocPointForBZBReward;
  uint16 public _allocPointForSwapReward;

  uint16 public _treasuryFee;
  uint16 public _rewardFee;
  uint16 public _lotteryFee;
  uint16 public _swapRewardFee;
  uint16 public _burnFee;
  uint16 public _earlyUnstakeFee;

  uint16 public _allocPointForBFI;
  uint16 public _allocPointForBNB;

  uint256 public _firstRewardPeriod;
  uint256 public _secondRewardPeriod;

  uint256 public _firstRewardAmount;
  uint256 public _secondRewardAmount;

  uint256 public _claimPeriodForBzbReward;
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
    uint256 lastClimedBlockForBzbReward;
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

  // Modifier
  modifier onlyBzb() {
    require(address(_bzb) == _msgSender(), "Ownable: caller is not the BZB token contract");
    _;
  }

  constructor(address treasury, address bfi) {
    _treasury = treasury;

    _bfi = TokenInterface(bfi);
    // _btcb = TokenInterface(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599); // wbtc
    // _wbnb = TokenInterface(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // Weth
    _btcb = TokenInterface(0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c);
    _wbnb = TokenInterface(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

    // _pancakeswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    _pancakeswapV2Router = IPancakeSwapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);

    _firstRewardPeriod = 316800; // around 11 days, 3s block times
    _secondRewardPeriod = 1800900; // around 66 days, 3s block times

    _firstRewardAmount = 2000e18; // 2000 bzb tokens, could be changed by governance
    _secondRewardAmount = 7900e18; // 7900 bzb tokens, could be changed by governance

    _claimPeriodForBzbReward = 400000; // around 14 days, could be changed by governance
    _claimPeriodForSwapReward = 2500000; // around 90 days, could be changed by governance

    _allocPointForBZBReward = 5000; // 50% of reward will go to BZB reward, could be changed by governance
    _allocPointForSwapReward = 5000; // 50% of reward will go to swap(beth, btcb, bfi) reward, could be changed by governance

    // Set values divited from taxFee
    _treasuryFee = 2500; // 25% of taxFee to treasuryFee, could be changed by governance
    _rewardFee = 5000; // 50% of taxFee to stakers, could be changed by governance
    _lotteryFee = 500; // 5% of lottery Fee, could be changed by governance
    _swapRewardFee = 2000; // 20% of taxFee to swap tokens, could be changed by governance

    _earlyUnstakeFee = 1000; // 10% of early unstake fee, could be changed by governance

    // set alloc points of BFI, BTCB, BETH in swap rewards, could be changed by governance
    _allocPointForBNB = 5000; // 50% of fee to buy BTCB token, could be changed by governance
    _allocPointForBFI = 5000; // 50% of fee to buy BFI token, could be changed by governance

    // set the burn fee for withdraw early
    _burnFee = 2000; // 20% of pending reward to burn when staker request to withdraw pending reward, could be changed by governance

    _minDepositBNBAmount = 5e17; // 0.5 BNB
    _lockPeriod = 90 days; // could be changed by governance

    _enabledLock = true; // could be changed by governance
    _enabledLottery = true; // could be changed by governance

    _lotteryLimit = 5e17; // 0.5 BZB
    _lotteryPaidOut = 0;
    _startBlock = block.number;
  }

  /**
   * @dev Get block numbers.
   */
  function getBlockNumbers()
    public
    view
    returns (
      uint256 start,
      uint256 epoch1,
      uint256 epoch2,
      uint256 current
    )
  {
    return (
      _startBlock,
      _startBlock.add(_firstRewardPeriod),
      _startBlock.add(_secondRewardPeriod),
      block.number
    );
  }

  /**
   * @dev Change Minimum Deposit BNB Amount. Call by only Governance.
   */
  function changeMinimumDepositBNBAmount(uint256 amount) external onlyOwner {
    _minDepositBNBAmount = amount;
  }

  /**
   * @dev Change value of reward period. Call by only Governance.
   */
  function changeRewardPeriod(uint256 firstRewardPeriod, uint256 secondRewardPeriod)
    external
    onlyOwner
  {
    _firstRewardPeriod = firstRewardPeriod;
    _secondRewardPeriod = secondRewardPeriod;
  }

  /**
   * @dev Change value of claim period. Call by only Governance.
   */
  function changeClaimPeriod(uint256 claimPeriodForBzbReward, uint256 claimPeriodForSwapReward)
    external
    onlyOwner
  {
    _claimPeriodForBzbReward = claimPeriodForBzbReward;
    _claimPeriodForSwapReward = claimPeriodForSwapReward;
  }

  /**
   * @dev Enable lottery functionality. Call by only Governance.
   */
  function enableLottery(bool lottery) external onlyOwner {
    _enabledLottery = lottery;
  }

  /**
   * @dev Change maximun lock period. Call by only Governance.
   */
  function changeLockPeriod(uint256 period) external onlyOwner {
    _lockPeriod = period;
  }

  /**
   * @dev Update the treasury fee for this contract
   * defaults at 25% of taxFee, It can be set on only by BZB governance.
   * Note contract owner is meant to be a governance contract allowing BZB governance consensus
   */
  function changeFeeInfo(
    uint16 treasuryFee,
    uint16 rewardFee,
    uint16 swapRewardFee,
    uint16 burnFee
  ) external onlyOwner {
    _treasuryFee = treasuryFee;
    _rewardFee = rewardFee;
    _swapRewardFee = swapRewardFee;
    _burnFee = burnFee;
  }

  function changeBZBBFIPair(address bzbBFIV2Pair) external onlyOwner {
    // _bzbBFIV2Pair = IUniswapV2Pair(bzbBFIV2Pair);
    _bzbBFIV2Pair = IPancakeSwapV2Pair(bzbBFIV2Pair);
  }

  function changeBZBAddress(address bzb) external onlyOwner {
    _bzb = TokenInterface(bzb);
  }

  function changeEarlyUnstakeFee(uint16 fee) external onlyOwner {
    _earlyUnstakeFee = fee;
  }

  /**
   * @dev Update the dev fee for this contract
   * defaults at 5% of taxFee, It can be set on only by BZB governance.
   * Note contract owner is meant to be a governance contract allowing BZB governance consensus
   */
  function changeLotteryInfo(uint16 lotteryFee, uint256 lotteryLimit) external onlyOwner {
    _lotteryFee = lotteryFee;
    _lotteryLimit = lotteryLimit;
  }

  /**
   * @dev Update the alloc points for bfi, beth, btcb rewards
   * defaults at 50, 30, 20 of
   * Note contract owner is meant to be a governance contract allowing BZB governance consensus
   */
  function changeAllocPointsForSwapReward(uint16 allocPointForBFI_, uint16 allocPointForBNB_)
    external
    onlyOwner
  {
    _allocPointForBFI = allocPointForBFI_;
    _allocPointForBNB = allocPointForBNB_;
  }

  function addTaxFee(uint256 amount) external onlyBzb returns (bool) {
    uint256 daoTreasuryReward = amount.mul(uint256(_treasuryFee)).div(10000);
    _bzb.transfer(_treasury, daoTreasuryReward);

    uint256 stakerReward = amount.mul(uint256(_rewardFee)).div(10000);
    _collectedAmountForStakers = _collectedAmountForStakers.add(stakerReward);

    uint256 lotteryReward = amount.mul(uint256(_lotteryFee)).div(10000);
    _collectedAmountForLottery = _collectedAmountForLottery.add(lotteryReward);

    _collectedAmountForSwap = _collectedAmountForSwap.add(
      amount.sub(daoTreasuryReward).sub(stakerReward).sub(lotteryReward)
    );

    return true;
  }

  function getTotalStakedAmount() public view returns (uint256) {
    return _bzbBFIV2Pair.balanceOf(address(this));
  }

  function getWinners() external view returns (uint256) {
    return winnerInfo.length;
  }

  // Get BZB reward per block
  function getBzbPerBlockForBzbReward() public view returns (uint256) {
    uint256 multiplier = getMultiplier(_startBlock, block.number);

    if (multiplier == 0 || getTotalStakedAmount() == 0) {
      return 0;
    } else if (multiplier <= _firstRewardPeriod) {
      return
        _firstRewardAmount
          .mul(uint256(_allocPointForBZBReward))
          .mul(1 ether)
          .div(getTotalStakedAmount())
          .div(_firstRewardPeriod)
          .div(10000);
    } else if (multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod) {
      return
        _secondRewardAmount
          .mul(uint256(_allocPointForBZBReward))
          .mul(1 ether)
          .div(getTotalStakedAmount())
          .div(_secondRewardPeriod)
          .div(10000);
    } else {
      return _collectedAmountForStakers.mul(1 ether).div(getTotalStakedAmount()).div(multiplier);
    }
  }

  function getBzbPerBlockForSwapReward() public view returns (uint256) {
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
    } else if (multiplier > _firstRewardPeriod && multiplier <= _secondRewardPeriod) {
      return
        _secondRewardAmount
          .mul(uint256(_allocPointForSwapReward))
          .mul(1 ether)
          .div(getTotalStakedAmount())
          .div(_secondRewardPeriod)
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
    require(from <= to, "Vault: Invalid parameters for block number.");
    require(period > 0, "Vault: Invalid period.");

    uint256 multiplier = getMultiplier(from, to);

    return from.add(multiplier.sub(multiplier.mod(period)));
  }

  function addLiquidityForBFI(uint256 tokenAmount, uint256 bfiAmount) private {
    _bzb.approve(address(_pancakeswapV2Router), tokenAmount);
    _bfi.approve(address(_pancakeswapV2Router), bfiAmount);

    // add the liquidity
    _pancakeswapV2Router.addLiquidity(
      address(_bfi),
      address(_bzb),
      bfiAmount,
      tokenAmount,
      0, // min bfi, slippage is unavoidable
      0, // min bzb, slippage is unavoidable
      address(this),
      block.timestamp
    );
  }

  function swapAndLiquifyForBZB(uint256 amount) private returns (bool) {
    uint256 halfForBfi = amount.div(2);
    uint256 otherHalfForBZB = amount.sub(halfForBfi);

    // capture the contract's current BZB balance.
    // this is so that we can capture exactly the amount of BZB that the
    // swap creates, and not make the liquidity event include any BZB that
    // has been manually sent to the contract
    uint256 initialBalance = _bzb.balanceOf(address(this));

    require(
      swapTokensForTokens(address(_bfi), address(_bzb), otherHalfForBZB, address(this)),
      "Vault: Failed to swap from BFI to BZB."
    );

    // how much BZB did we just swap into?
    uint256 newBalance = _bzb.balanceOf(address(this)).sub(initialBalance);

    // add liquidity to panc
    addLiquidityForBFI(newBalance, halfForBfi);

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

    IERC20(fromTokenAddress).approve(address(_pancakeswapV2Router), tokenAmount);

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
    require(!isContract(_msgSender()), "Vault: Could not be contract.");
    require(msg.value >= _minDepositBNBAmount, "Vault: insufficient staking amount.");

    // Check Initial Balance
    uint256 initialBalance = _bzbBFIV2Pair.balanceOf(address(this));

    // We trade the received BNB for BFI (in full)
    uint256 initialBFIBalance = _bfi.balanceOf(address(this));
    swapBNBForBFI(msg.value);
    uint256 newBFIBalance = _bfi.balanceOf(address(this)).sub(initialBFIBalance);

    require(newBFIBalance > 0, "Vault: Trade BNB -> BFI, resulted in 0 tokens.");

    // Swap half of the received BFI with BZB and liquify
    require(swapAndLiquifyForBZB(newBFIBalance), "Vault: Failed to get LP tokens.");

    uint256 newBalance = _bzbBFIV2Pair.balanceOf(address(this)).sub(initialBalance);

    StakerInfo storage staker = _stakers[_msgSender()];

    if (staker.stakedAmount > 0) {
      claimBzbReward();
      claimSwapReward();
    } else {
      staker.lastClimedBlockForBzbReward = block.number;
      staker.lastClimedBlockForSwapReward = block.number;
    }

    staker.stakedAmount = staker.stakedAmount.add(newBalance);
    staker.lockedTo = _lockPeriod.add(block.timestamp);

    return _sendLotteryAmount();
  }

  function swapBNBForBFI(uint256 bnbAmount) private {
    address[] memory path = new address[](2);
    path[0] = _pancakeswapV2Router.WETH();
    path[1] = address(_bfi);

    // make the swap
    _pancakeswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmount}(
      0,
      path,
      address(this),
      block.timestamp
    );
  }

  /**
   * @dev Unstake staked BZB-BFI LP tokens
   */
  function unstake(uint256 amount) external returns (bool) {
    require(!isContract(_msgSender()), "Vault: Could not be contract.");

    StakerInfo storage staker = _stakers[_msgSender()];

    require(
      staker.stakedAmount > 0 && amount > 0 && amount <= staker.stakedAmount,
      "Vault: Invalid amount to unstake."
    );

    claimBzbReward();
    claimSwapReward();

    if (
      _enabledLock &&
      _stakers[_msgSender()].lockedTo > 0 &&
      block.timestamp < _stakers[_msgSender()].lockedTo
    ) {
      uint256 feeAmount = amount.mul(uint256(_earlyUnstakeFee)).div(10000);
      _bzbBFIV2Pair.transfer(_treasury, feeAmount);
      _bzbBFIV2Pair.transfer(_msgSender(), amount.sub(feeAmount));
    } else {
      _bzbBFIV2Pair.transfer(_msgSender(), amount);
    }

    staker.stakedAmount = staker.stakedAmount.sub(amount);

    return _sendLotteryAmount();
  }

  function getBzbReward(address account) public view returns (uint256 available, uint256 pending) {
    StakerInfo memory staker = _stakers[account];
    uint256 multiplier = getMultiplier(staker.lastClimedBlockForBzbReward, block.number);

    if (staker.stakedAmount <= 0 || multiplier <= 0) {
      return (0, 0);
    }

    uint256 bzbPerblock = getBzbPerBlockForBzbReward();
    uint256 pendingBlockNum = multiplier.mod(_claimPeriodForBzbReward);

    pending = bzbPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
    available = bzbPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(
      1 ether
    );
  }

  function getSwapReward(address account) public view returns (uint256 available, uint256 pending) {
    StakerInfo memory staker = _stakers[account];
    uint256 multiplier = getMultiplier(staker.lastClimedBlockForSwapReward, block.number);

    if (staker.stakedAmount <= 0 || multiplier <= 0) {
      return (0, 0);
    }

    uint256 bzbPerblock = getBzbPerBlockForSwapReward();
    uint256 pendingBlockNum = multiplier.mod(_claimPeriodForSwapReward);

    pending = bzbPerblock.mul(pendingBlockNum).mul(staker.stakedAmount).div(1 ether);
    available = bzbPerblock.mul(multiplier.sub(pendingBlockNum)).mul(staker.stakedAmount).div(
      1 ether
    );
  }

  function claimBzbAvailableReward() public returns (bool) {
    (uint256 available, ) = getBzbReward(_msgSender());

    require(available > 0, "Vault: No available reward.");

    require(safeBzbTransfer(_msgSender(), available), "Vault: Failed to transfer.");

    StakerInfo storage staker = _stakers[_msgSender()];
    staker.lastClimedBlockForBzbReward = _getLastAvailableClaimedBlock(
      staker.lastClimedBlockForBzbReward,
      block.number,
      _claimPeriodForBzbReward
    );

    return _sendLotteryAmount();
  }

  function claimBzbReward() public returns (bool) {
    (uint256 available, uint256 pending) = getBzbReward(_msgSender());

    require(available > 0 || pending > 0, "Vault: No rewards");

    StakerInfo storage staker = _stakers[_msgSender()];

    if (available > 0) {
      require(safeBzbTransfer(_msgSender(), available), "Vault: Failed to transfer.");
    }

    if (pending > 0) {
      uint256 burnAmount = pending.mul(_burnFee).div(10000);
      _bzb.burnFromVault(burnAmount);
      safeBzbTransfer(_msgSender(), pending.sub(burnAmount));
      staker.lastClimedBlockForBzbReward = block.number;
    } else if (available > 0) {
      staker.lastClimedBlockForBzbReward = _getLastAvailableClaimedBlock(
        staker.lastClimedBlockForBzbReward,
        block.number,
        _claimPeriodForBzbReward
      );
    }

    return _sendLotteryAmount();
  }

  function claimSwapAvailableReward() public returns (bool) {
    (uint256 available, ) = getSwapReward(_msgSender());

    _swapAndClaimTokens(available);

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
      _bzb.burnFromVault(burnAmount);
      pending = pending.sub(burnAmount);
    }

    _swapAndClaimTokens(available.add(pending));

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

    uint256 bfiOldBalance = IERC20(_bfi).balanceOf(address(this));
    // Swap BZB -> BNB and get tokens for reward
    require(
      swapTokensForTokens(address(_bzb), address(_bfi), rewards, address(this)),
      "Vault: Failed to swap from BZB to BFI."
    );

    uint256 bfiNewBalance = IERC20(_bfi).balanceOf(address(this)).sub(bfiOldBalance);

    uint256 bfiTokenReward = bfiNewBalance.mul(_allocPointForBFI).div(10000);
    uint256 bnbTokenReward = bfiNewBalance.sub(bfiTokenReward);

    require(IERC20(_bfi).transfer(_msgSender(), bfiTokenReward), "Vault: Failed to send BFI");

    uint256 bnbOldBalance = IERC20(_wbnb).balanceOf(address(this));
    require(
      swapTokensForTokens(address(_bfi), address(_wbnb), bnbTokenReward, address(this)),
      "Vault: Failed to swap from BZB to BNB."
    );
    uint256 bnbNewBalance = IERC20(_wbnb).balanceOf(address(this)).sub(bnbOldBalance);

    require(IERC20(_wbnb).transfer(_msgSender(), bnbNewBalance), "Vault: Failed to send BNB");
  }

  /**
   * @dev internal function to send lottery rewards
   */
  function _sendLotteryAmount() internal returns (bool) {
    if (!_enabledLottery || _collectedAmountForLottery <= 0) return false;

    if (_collectedAmountForLottery >= _lotteryLimit) {
      uint256 amount = _collectedAmountForLottery;

      _bzb.transfer(_msgSender(), amount);
      _collectedAmountForLottery = _collectedAmountForLottery.sub(amount);
      _lotteryPaidOut = _lotteryPaidOut.add(amount);

      winnerInfo.push(
        WinnerInfo({winner: _msgSender(), amount: amount, timestamp: block.timestamp})
      );
    }

    return false;
  }

  function safeBzbTransfer(address to, uint256 amount) internal returns (bool) {
    uint256 bzbBal = _bzb.balanceOf(address(this));

    if (amount > bzbBal) {
      _bzb.transfer(to, bzbBal);
    } else {
      _bzb.transfer(to, amount);
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