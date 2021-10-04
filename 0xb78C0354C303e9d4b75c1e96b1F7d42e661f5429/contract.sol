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
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  // function name() external pure returns (string memory);

  // function symbol() external pure returns (string memory);

  // function decimals() external pure returns (uint8);

  // function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  // function DOMAIN_SEPARATOR() external view returns (bytes32);

  // function PERMIT_TYPEHASH() external pure returns (bytes32);

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
  event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
  event Swap(
    address indexed sender,
    uint256 amount0In,
    uint256 amount1In,
    uint256 amount0Out,
    uint256 amount1Out,
    address indexed to
  );
  event Sync(uint112 reserve0, uint112 reserve1);

  // function MINIMUM_LIQUIDITY() external pure returns (uint256);

  function factory() external view returns (address);

  // function token0() external view returns (address);

  // function token1() external view returns (address);

  // function getReserves()
  //   external
  //   view
  //   returns (
  //     uint112 reserve0,
  //     uint112 reserve1,
  //     uint32 blockTimestampLast
  //   );

  // function price0CumulativeLast() external view returns (uint256);

  // function price1CumulativeLast() external view returns (uint256);

  // function kLast() external view returns (uint256);

  function mint(address to) external returns (uint256 liquidity);

  function burn(address to) external returns (uint256 amount0, uint256 amount1);

  function swap(
    uint256 amount0Out,
    uint256 amount1Out,
    address to,
    bytes calldata data
  ) external;

  // function skim(address to) external;

  // function sync() external;

  // function initialize(address, address) external;
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

contract RRZVault is Context, Ownable {
  using SafeMath for uint256;

  TokenInterface public _bzb;
  TokenInterface public _wbnb;
  TokenInterface public _bfi;
  TokenInterface public _btcb;
  TokenInterface public _beth;

  IPancakeSwapV2Pair public _bzbBFIV2Pair;

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
  uint16 public _allocPointForBTCB;
  uint16 public _allocPointForBETH;
  uint16 public _allocPointForBUSD;
  uint16 public _allocPointForWBNB;

  uint256 public _firstRewardPeriod;
  uint256 public _secondRewardPeriod;

  uint256 public _firstRewardAmount;
  uint256 public _secondRewardAmount;

  uint256 public _claimPeriodForBzbReward;
  uint256 public _claimPeriodForSwapReward;

  uint256 public _lockPeriod;
  uint256 public _minDepositBFIAmount;

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
    _beth = TokenInterface(0x250632378E573c6Be1AC2f97Fcdf00515d0Aa91B);
    _btcb = TokenInterface(0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c);

    _pancakeswapV2Router = IPancakeSwapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);

    _firstRewardPeriod = 200; // 316800; // around 11 days, 3s block times
    _secondRewardPeriod = 1800900; // around 66 days, 3s block times

    _firstRewardAmount = 2000e18; // 2000 bzb tokens, could be changed by governance
    _secondRewardAmount = 7900e18; // 7900 bzb tokens, could be changed by governance

    _claimPeriodForBzbReward = 60; //400000; // around 14 days, could be changed by governance
    _claimPeriodForSwapReward = 100; // 2500000; // around 90 days, could be changed by governance

    _allocPointForBZBReward = 8000; // 80% of reward will go to BZB reward, could be changed by governance
    _allocPointForSwapReward = 2000; // 20% of reward will go to swap(beth, btcb, bfi) reward, could be changed by governance

    // Set values divited from taxFee
    _treasuryFee = 2500; // 25% of taxFee to treasuryFee, could be changed by governance
    _rewardFee = 5000; // 50% of taxFee to stakers, could be changed by governance
    _lotteryFee = 500; // 5% of lottery Fee, could be changed by governance
    _swapRewardFee = 2000; // 20% of taxFee to swap tokens, could be changed by governance

    _earlyUnstakeFee = 1000; // 10% of early unstake fee, could be changed by governance

    // set alloc points of BFI, BTCB, BETH in swap rewards, could be changed by governance
    _allocPointForBTCB = 5000; // 50% of fee to buy BTCB token, could be changed by governance
    _allocPointForBFI = 3000; // 30% of fee to buy BFI token, could be changed by governance
    _allocPointForBETH = 2000; // 20% of fee to buy BETH token, could be changed by governance

    // set the burn fee for withdraw early
    _burnFee = 2000; // 20% of pending reward to burn when staker request to withdraw pending reward, could be changed by governance

    _minDepositBFIAmount = 5e9; // 250 BFI
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
   * @dev Change Minimum Deposit BFI Amount. Call by only Governance.
   */
  function changeMinimumDepositBFIAmount(uint256 amount) external onlyOwner {
    _minDepositBFIAmount = amount;
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
  function changeAllocPointsForSwapReward(
    uint16 allocPointForBFI_,
    uint16 allocPointForBTCB_,
    uint16 allocPointForBETH_
  ) external onlyOwner {
    _allocPointForBFI = allocPointForBFI_;
    _allocPointForBTCB = allocPointForBTCB_;
    _allocPointForBETH = allocPointForBETH_;
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
    IERC20(toTokenAddress).approve(address(_pancakeswapV2Router), tokenAmount);
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

  function stake(uint256 bfiAmount) external returns (bool) {
    require(!isContract(_msgSender()), "Vault: Could not be contract.");
    require(bfiAmount >= _minDepositBFIAmount, "Vault: insufficient staking amount.");

    // Check Initial Balance
    uint256 initialBalance = _bzbBFIV2Pair.balanceOf(address(this));

    // Get BFI Tokens for staking from the user
    IERC20(_bfi).transferFrom(_msgSender(), address(this), bfiAmount);

    // Call swap for YZY&ETH
    require(swapAndLiquifyForBZB(bfiAmount), "Vault: Failed to get LP tokens.");

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

  /**
   * @dev Stake LP Token to get BZB-BFI LP tokens
   */
  function stakeLPToken(uint256 amount) external returns (bool) {
    require(!isContract(_msgSender()), "Vault: Could not be contract.");

    _bzbBFIV2Pair.transferFrom(_msgSender(), address(this), amount);

    StakerInfo storage staker = _stakers[_msgSender()];

    if (staker.stakedAmount > 0) {
      claimBzbReward();
      claimSwapReward();
    } else {
      staker.lastClimedBlockForBzbReward = block.number;
      staker.lastClimedBlockForSwapReward = block.number;
    }

    staker.stakedAmount = staker.stakedAmount.add(amount);
    staker.lockedTo = _lockPeriod.add(block.timestamp);

    return _sendLotteryAmount();
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

    // Swap BZB -> BFI and get tokens for reward
    require(
      swapTokensForTokens(address(_bzb), address(_bfi), rewards, address(this)),
      "Vault: Failed to swap from BZB to BFI."
    );

    // Get New Swaped BFI Amount
    uint256 bfiNewBalance = IERC20(_bfi).balanceOf(address(this)).sub(bfiOldBalance);

    require(bfiNewBalance > 0, "Vault: Invalid BFI amount.");

    uint256 btcbTokenReward = bfiNewBalance.mul(_allocPointForBTCB).div(10000);
    uint256 bethTokenReward = bfiNewBalance.mul(_allocPointForBETH).div(10000);
    uint256 bfiTokenReward = bfiNewBalance.sub(btcbTokenReward).sub(bethTokenReward);

    // Transfer BFI Reward Tokens From Contract To Staker
    require(IERC20(_bfi).transfer(_msgSender(), bfiTokenReward), "Vault: Failed to transfer BFI");

    // Swap BFI -> BTCB and give BTCB token to User as reward
    require(
      swapTokensForTokens(address(_bfi), address(_btcb), btcbTokenReward, _msgSender()),
      "Vault: Failed to swap BTCB."
    );

    // Swap BFI -> BETH and give BETH token to User as reward
    require(
      swapTokensForTokens(address(_bfi), address(_beth), bethTokenReward, _msgSender()),
      "Vault: Failed to swap BETH."
    );
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