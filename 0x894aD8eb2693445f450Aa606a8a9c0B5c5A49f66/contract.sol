// SPDX-License-Identifier: MIT

/*

FATOSHI is built to reward its holders with BITCOIN and also 
to be the main token of a stunning Cross-Chain NFT ecosystem.

Official website: https://fatoshi.community

*/

pragma solidity >=0.6.0 <0.9.0;

abstract contract Context {
    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function allPairs(uint) external view returns (address lpPair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface Cashier {
    function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection) external;
    function tally(address shareholder, uint256 amount) external;
    function load() external payable;
    function cashout(uint256 gas) external;
    function giveMeWelfarePlease(address hobo) external;
    function getTotalDistributed() external view returns(uint256);
    function getShareholderInfo(address shareholder) external view returns(string memory, string memory, string memory, string memory);
    function getShareholderRealized(address shareholder) external view returns (uint256);
    function getPendingRewards(address shareholder) external view returns (uint256);
}

contract Fatoshi is IERC20 {
    // Ownership moved to in-contract for customizability.
    address private _owner;

    mapping (address => uint256) _tOwned;
    mapping (address => bool) lpPairs;
    uint256 private timeSinceLastPair = 0;
    mapping (address => mapping (address => uint256)) _allowances;
    mapping (address => bool) _isFeeExcluded;
    mapping (address => bool) _isDividendExcluded;
    mapping (address => uint256) userSellTime;
    mapping (address => uint256) userSoldAmt;

    mapping (address => bool) private presaleAddresses;
    bool private allowedPresaleExclusion = true;
    mapping (address => bool) private _isBlacklisted;
    mapping (address => bool) private _liquidityHolders;

    uint256 private constant startingSupply = 100_000_000_000;

    string constant _name = "FatSatoshi";
    string constant _symbol = "FATOSHI";

    uint256 public masterTaxDivisor = 10000;

    uint256 private _buyReflectionFee = 1000;
    uint256 private _buyLiquidityFee = 200;
    uint256 private _buyMarketingFee = 300;

    uint256 private _sellReflectionFee = _buyReflectionFee;
    uint256 private _sellLiquidityFee = _buyLiquidityFee;
    uint256 private _sellMarketingFee = _buyMarketingFee;

    uint256 private _transferReflectionFee = _buyReflectionFee;
    uint256 private _transferLiquidityFee = _buyLiquidityFee;
    uint256 private _transferMarketingFee = _buyMarketingFee;

    uint256 private _reflectionRatio = _buyReflectionFee;
    uint256 private _liquidityRatio = _buyLiquidityFee;
    uint256 private _marketingRatio = _buyMarketingFee;

    uint256 public _buyFee = _buyReflectionFee + _buyLiquidityFee + _buyMarketingFee;
    uint256 public _sellFee = _sellReflectionFee + _sellLiquidityFee + _sellMarketingFee;
    uint256 public _transferFee = _transferReflectionFee + _transferLiquidityFee + _transferMarketingFee;

    uint256 constant public maxBuyTaxes = 3400;
    uint256 constant public maxSellTaxes = 3400;
    uint256 constant public maxTransferTaxes = 3400;

    uint8 private _decimals = 9;
    uint256 private _decimalsMul = _decimals;
    uint256 private _tTotal = startingSupply * (10 ** _decimalsMul);

    IUniswapV2Router02 public dexRouter;
    address public lpPair;

    // PCS ROUTER
    address private _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address private WBNB;
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    address private ZERO = 0x0000000000000000000000000000000000000000;

    address payable private _marketingWallet = payable(0xf7b98Bbf13903B28876CE0DB900da4fb3001a3ee);

    uint256 private maxTxPercent = 5;
    uint256 private maxTxDivisor = 1000;
    uint256 private _maxTxAmount = (_tTotal * maxTxPercent) / maxTxDivisor;
    uint256 public maxTxAmountUI = (startingSupply * maxTxPercent) / maxTxDivisor;
    uint256 private maxTxAmtBlock1 = (_tTotal * 15) / 10000;
    uint256 private maxTxAmtBlock2 = (_tTotal * 30) / 10000;

    uint256 private maxWalletPercent = 100;
    uint256 private maxWalletDivisor = 100;
    uint256 private _maxWalletSize = (_tTotal * maxWalletPercent) / maxWalletDivisor;
    uint256 private _previousMaxWalletSize = _maxWalletSize;
    uint256 public maxWalletSizeUI = (startingSupply * maxWalletPercent) / maxWalletDivisor;

    uint256 targetLiquidity = 100;
    uint256 targetLiquidityDenominator = 100;

    Cashier reflector;
    uint256 reflectorGas = 300000;

    bool public swapAndLiquifyEnabled = false;
    bool public processReflect = false;
    uint256 private swapThreshold = _tTotal / 20000;
    uint256 private swapAmount = _tTotal * 5 / 1000;
    bool private initialSubEnabled = false;
    bool inSwap;
    bool private init = false;

    bool private sniperProtection = true;
    bool public _hasLiqBeenAdded = false;
    uint256 private _liqAddBlock = 0;
    uint256 private _liqAddStamp = 0;
    uint256 private snipeBlockAmt;
    uint256 public snipersCaught = 0;
    bool private gasLimitActive = true;
    uint256 private gasPriceLimit;

    uint256 public maxSellTimeLimit = 24 hours;
    uint256 private maxSellPerTimeLimit = (5 * _tTotal) / 1000;
    uint256 public maxSellPerTimeLimitUI = (5 * startingSupply) / 1000;

    bool public tradingEnabled = false;
    bool public scalingMaxTxEnabled = true;
    bool public maxSellTimeLimitEnabled = true;

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event AutoLiquify(uint256 amountBNB, uint256 amount);
    event SniperCaught(address sniperAddress);

    constructor () payable {
        address msgSender = msg.sender;
        _tOwned[msgSender] = _tTotal;

        _owner = msgSender;
        dexRouter = IUniswapV2Router02(_routerAddress);
        lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
        lpPairs[lpPair] = true;
        _allowances[address(this)][address(dexRouter)] = type(uint256).max;

        WBNB = dexRouter.WETH();

        _isFeeExcluded[owner()] = true;
        _isFeeExcluded[address(this)] = true;
        _isDividendExcluded[owner()] = true;
        _isDividendExcluded[lpPair] = true;
        _isDividendExcluded[address(this)] = true;
        _isDividendExcluded[burnAddress] = true;
        _isDividendExcluded[ZERO] = true;
        // DxLocker Address (BSC)
        _isFeeExcluded[0x81E0eF68e103Ee65002d3Cf766240eD1c070334d] = true;
        _isDividendExcluded[0x81E0eF68e103Ee65002d3Cf766240eD1c070334d] = true;

        // Approve the owner for PancakeSwap, timesaver.
        approveMax(_routerAddress);

        // Ever-growing sniper/tool blacklist
        _isBlacklisted[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
        _isBlacklisted[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
        _isBlacklisted[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
        _isBlacklisted[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
        _isBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
        _isBlacklisted[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
        _isBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
        _isBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
        _isBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
        _isBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
        _isBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
        _isBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;

        emit Transfer(ZERO, msg.sender, _tTotal);
        emit OwnershipTransferred(address(0), msgSender);
    }

//===============================================================================================================
//===============================================================================================================
//===============================================================================================================
    // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
    // This allows for removal of ownership privelages from the owner once renounced or transferred.
    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwner(address newOwner) external onlyOwner() {
        require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
        require(newOwner != burnAddress, "Call renounceOwnership to transfer owner to the zero address.");
        _isFeeExcluded[_owner] = false;
        _isDividendExcluded[_owner] = false;
        _isFeeExcluded[newOwner] = true;
        _isDividendExcluded[newOwner] = true;
        
        if (_marketingWallet == payable(_owner))
            _marketingWallet = payable(newOwner);
        
        _allowances[_owner][newOwner] = _tOwned[_owner];
        if(_tOwned[_owner] > 0) {
            _transfer(_owner, newOwner, _tOwned[_owner]);
        }
        
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
        
    }

    function renounceOwnership() public virtual onlyOwner() {
        _isFeeExcluded[_owner] = false;
        _isDividendExcluded[_owner] = false;
        _owner = address(0);
        emit OwnershipTransferred(_owner, address(0));
    }
//===============================================================================================================
//===============================================================================================================
//===============================================================================================================

    receive() external payable {}

    function totalSupply() external view override returns (uint256) { return _tTotal; }
    function decimals() external view override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner(); }
    function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) public returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function _approve(address sender, address spender, uint256 amount) private {
        require(sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }

        return _transfer(sender, recipient, amount);
    }

    function isSniper(address account) public view returns (bool) {
        return _isBlacklisted[account];
    }

    function isFeeExcluded(address account) public view returns(bool) {
        return _isFeeExcluded[account];
    }

    function isDividendExcluded(address account) public view returns(bool) {
        return _isDividendExcluded[account];
    }

    function setBlacklistEnabled(address account, bool enabled) external onlyOwner {
        require(_isBlacklisted[account], "Account is not a recorded sniper.");
        _isBlacklisted[account] = enabled;
    }

    function setProtectionSettings(bool antiSnipe, bool antiGas) external onlyOwner() {
        sniperProtection = antiSnipe;
        gasLimitActive = antiGas;
    }

    function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
        require (snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
        snipeBlockAmt = _block;
        gasPriceLimit = _gas * 1 gwei;
    }

    function setInitializer(address initializer) external onlyOwner {
        require(init == false);
        reflector = Cashier(initializer);
        init = true;
    }

    function setGasPriceLimit(uint256 gas) external onlyOwner {
        require(gas >= 75);
        gasPriceLimit = gas * 1 gwei;
    }

    function setDividendExcluded(address holder, bool enabled) public onlyOwner {
        require(holder != address(this) && holder != lpPair);
        _isDividendExcluded[holder] = enabled;
        if (enabled) {
            reflector.tally(holder, 0);
        } else {
            reflector.tally(holder, _tOwned[holder]);
        }
    }

    function setExcludeFromFees(address account, bool enabled) public onlyOwner {
        _isFeeExcluded[account] = enabled;
    }

    function setTaxes(uint256 buyFee, uint256 sellFee, uint256 transferFee) external onlyOwner {
        require(buyFee <= maxBuyTaxes
                && sellFee <= maxSellTaxes
                && transferFee <= maxTransferTaxes);
        _buyFee = buyFee;
        _sellFee = sellFee;
        _transferFee = transferFee;
    }

    function setRatios(uint256 reflection, uint256 liquidity, uint256 marketing) external onlyOwner {
        require (reflection < 100 
                 && liquidity < 100 
                 && marketing < 100
                 && reflection + liquidity + marketing == 100, "Must be between 0 and 100, with a total of 100.");
        if (marketing > 0) {
            require(marketing <= 50 && liquidity + reflection == 100 - marketing, "Marketing cannot be more than 50% of the distribution.");
        }
        _liquidityRatio = liquidity;
        _reflectionRatio = reflection;
        _marketingRatio = marketing;
    }

    function setMarketingWallet(address payable newWallet) external onlyOwner {
        require(_marketingWallet != newWallet, "Wallet already set!");
        _marketingWallet = payable(newWallet);
    }

    function setSwapBackSettings(bool _enabled, bool processReflectEnabled) external onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        processReflect = processReflectEnabled;
    }

    function setSwapThreshold(uint256 percent, uint256 divisor) external onlyOwner() {
        swapThreshold = (_tTotal * percent) / divisor;
    }

    function setSwapAmount(uint256 percent, uint256 divisor) external onlyOwner {
        swapAmount = (_tTotal * percent) / divisor;
    }

    function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
        targetLiquidity = _target;
        targetLiquidityDenominator = _denominator;
    }

    function setReflectionCriteria(uint256 _minPeriod, uint256 _minReflection, uint256 minReflectionMultiplier) external onlyOwner {
        _minReflection = _minReflection * 10**minReflectionMultiplier;
        reflector.setReflectionCriteria(_minPeriod, _minReflection);
    }

    function setReflectorSettings(uint256 gas) external onlyOwner {
        require(gas < 750000);
        reflectorGas = gas;
    }

    function setInitialSubEnabled(bool enabled) external onlyOwner() {
        initialSubEnabled = enabled;
    }
    
    function getCirculatingSupply() public view returns (uint256) {
        return _tTotal - (balanceOf(burnAddress) + balanceOf(ZERO));
    }

    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        return accuracy * balanceOf(lpPair) / getCirculatingSupply();
    }

    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
        return getLiquidityBacking(accuracy) > target;
    }

    function giveMeWelfarePlease() external {
        reflector.giveMeWelfarePlease(msg.sender);
    }

    function getTotalReflected() external view returns (uint256) {
        return reflector.getTotalDistributed();
    }

    function getUserInfo(address shareholder) external view returns (string memory, string memory, string memory, string memory) {
        return reflector.getShareholderInfo(shareholder);
    }

    function getUserRealizedGains(address shareholder) external view returns (uint256) {
        return reflector.getShareholderRealized(shareholder);
    }

    function getUserUnpaidEarnings(address shareholder) external view returns (uint256) {
        return reflector.getPendingRewards(shareholder);
    }

    function setNewRouter(address newRouter) public onlyOwner() {
        IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
        address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
        if (get_pair == address(0)) {
            lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
        }
        else {
            lpPair = get_pair;
        }
        dexRouter = _newRouter;
    }

    function setLpPair(address pair, bool enabled) external onlyOwner {
        if (enabled == false) {
            lpPairs[pair] = false;
        } else {
            if (timeSinceLastPair != 0) {
                require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
            }
            lpPairs[pair] = true;
            timeSinceLastPair = block.timestamp;
        }
    }

    function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
        uint256 check = (_tTotal * percent) / divisor;
        require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
        _maxTxAmount = check;
        maxTxAmountUI = (startingSupply * percent) / divisor;
    }

    function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
        uint256 check = (_tTotal * percent) / divisor;
        require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
        _maxWalletSize = check;
        maxWalletSizeUI = (startingSupply * percent) / divisor;
    }

    function setMaxSellLimits(uint256 percent, uint256 divisor, uint256 time) external onlyOwner {
        uint256 check = (_tTotal * percent) / divisor;
        require(check >= (_tTotal / 1000), "Max Sell amt must be above 0.1% of total supply.");
        require(time <= 24 hours, "Cannot set to more than a day in time.");
        maxSellPerTimeLimit = check;
        maxSellPerTimeLimitUI = (startingSupply * percent) / divisor;
        maxSellTimeLimit = time;
    }

    function setSellPropertiesEnabled(bool _maxSellTimeLimitEnabled, bool _scalingMaxTxEnabled) external onlyOwner {
        maxSellTimeLimitEnabled = _maxSellTimeLimitEnabled;
        scalingMaxTxEnabled = _scalingMaxTxEnabled;
    }

    function excludePresaleAddresses(address router, address presale) external onlyOwner {
        require(allowedPresaleExclusion, "Function already used.");
        _liquidityHolders[router] = true;
        _liquidityHolders[presale] = true;
        presaleAddresses[router] = true;
        presaleAddresses[presale] = true;
        setDividendExcluded(router, true);
        setDividendExcluded(presale, true);
        setExcludeFromFees(router, true);
        setExcludeFromFees(presale, true);
    }

    function _hasLimits(address from, address to) private view returns (bool) {
        return from != owner()
            && to != owner()
            && !_liquidityHolders[to]
            && !_liquidityHolders[from]
            && to != burnAddress
            && to != address(0)
            && from != address(this);
    }

    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Already enabled.");
        tradingEnabled = true;
        _liqAddBlock = block.number;
        _liqAddStamp = block.timestamp;
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (gasLimitActive) {
            require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
        }
        if(_hasLimits(from, to)) {
            require(tradingEnabled, "Trading is not yet enabled.");
            if (lpPairs[to]){
                if (maxSellTimeLimitEnabled) {
                    if (block.timestamp - userSellTime[from] >= maxSellTimeLimit) {
                        require(amount <= maxSellPerTimeLimit, "Selling too much within the time limit!");
                        userSoldAmt[from] = amount;
                        userSellTime[from] = block.timestamp;
                    } else {
                        require(userSoldAmt[from] + amount <= maxSellPerTimeLimit, "Selling too much within the time limit!");
                        userSoldAmt[from] += amount;
                    }
                }
            }
            if(scalingMaxTxEnabled) {
                if (block.number - _liqAddBlock <= 100) {
                    require(amount <= maxTxAmtBlock1, "Transfer amount exceeds the maxTxAmount.");
                } else if (block.number - _liqAddBlock <= 200) {
                    require(amount <= maxTxAmtBlock2, "Transfer amount exceeds the maxTxAmount.");
                } else {
                    require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
                }
            }
            if(to != _routerAddress && !lpPairs[to]) {
                require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
            }
        }

        bool takeFee = true;
        
        if(_isFeeExcluded[from] || _isFeeExcluded[to]){
            takeFee = false;
        }

        return _finalizeTransfer(from, to, amount, takeFee);
    }

    function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee) internal returns (bool) {
        if (sniperProtection){
            if (isSniper(from) || isSniper(to)) {
                revert("Sniper rejected.");
            }

            if (!_hasLiqBeenAdded) {
                _checkLiquidityAdd(from, to);
                if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
                    revert("Only owner can transfer at this time.");
                }
            } else {
                if (_liqAddBlock > 0 
                    && from == lpPair 
                    && _hasLimits(from, to)
                ) {
                    if (block.number - _liqAddBlock < snipeBlockAmt) {
                        _isBlacklisted[to] = true;
                        _isDividendExcluded[to] = true;
                        snipersCaught ++;
                        emit SniperCaught(to);
                    }
                }
            }
        }

        _tOwned[from] -= amount;

        if (inSwap) {
            return _basicTransfer(from, to, amount);
        }

        

        uint256 contractTokenBalance = _tOwned[address(this)];
        if(contractTokenBalance >= swapAmount)
            contractTokenBalance = swapAmount;

        if (!inSwap
            && !lpPairs[from]
            && swapAndLiquifyEnabled
            && contractTokenBalance >= swapThreshold
            && !presaleAddresses[from]
            && !presaleAddresses[to]
        ) {
            swapBack(contractTokenBalance);
        }

        uint256 amountReceived = (takeFee) ? takeTaxes(from, to, amount) : amount;

        _tOwned[to] += amountReceived;

        processTokenReflect(from, to);

        emit Transfer(from, to, amountReceived);
        return true;
    }

    function processTokenReflect(address from, address to) internal {
        // Process TOKEN Reflect.
        if (!_isDividendExcluded[from]) {
            try reflector.tally(from, _tOwned[from]) {} catch {}
        }
        if (!_isDividendExcluded[to]) {
            try reflector.tally(to, _tOwned[to]) {} catch {}
        }
        if (processReflect) {
            try reflector.cashout(reflectorGas) {} catch {}
        }
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _tOwned[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }


    function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
        uint256 currentFee;
        if (from == lpPair) {
            currentFee = _buyFee;
        } else if (to == lpPair) {
            currentFee = _sellFee;
        } else {
            currentFee = _transferFee;
        }

        uint256 feeAmount = amount * currentFee / masterTaxDivisor;

        _tOwned[address(this)] += feeAmount;
        emit Transfer(from, address(this), feeAmount);

        return amount - feeAmount;
    }

    uint256 public _marketBal;
    uint256 public _liqBal;
    uint256 public _rewardBal;

    function swapBack(uint256 numTokensToSwap) internal swapping {
        uint256 totalRatioFee = _marketingRatio + _liquidityRatio + _reflectionRatio;
        uint256 dynamicLiquidityRatio = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : _liquidityRatio;
        uint256 amountToLiquify = numTokensToSwap * dynamicLiquidityRatio / totalRatioFee / 2;
        uint256 amountToSwap = numTokensToSwap - amountToLiquify;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        uint256 balanceBefore = address(this).balance;

        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;
        if (initialSubEnabled) 
            amountBNB = address(this).balance - balanceBefore;
        uint256 amountBNBLiquidity = amountBNB * dynamicLiquidityRatio / totalRatioFee / 2;
        uint256 amountBNBReflection = ((amountBNB - amountBNBLiquidity) * _reflectionRatio) / (_marketingRatio + _reflectionRatio);
        uint256 amountBNBMarketing = amountBNB - (amountBNBReflection + amountBNBLiquidity);
        _marketingWallet.transfer(amountBNBMarketing);

        _marketBal = amountBNBMarketing;
        _liqBal = amountBNBLiquidity;
        _rewardBal = amountBNBReflection;

        if (amountToLiquify > 0) {
            dexRouter.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                burnAddress,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        } else {
            amountBNBReflection += amountBNBLiquidity;
        }

        try reflector.load{value: amountBNBReflection}() {} catch {}
    }

    function manualDepost() external onlyOwner() {
        try reflector.load{value: address(this).balance}() {} catch {}
    }

    function _checkLiquidityAdd(address from, address to) private {
        require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
        if (!_hasLimits(from, to) && to == lpPair) {
            _liquidityHolders[from] = true;
            _hasLiqBeenAdded = true;
            _liqAddBlock = block.number;
            _liqAddStamp = block.timestamp;

            swapAndLiquifyEnabled = true;
            allowedPresaleExclusion = false;
            processReflect = true;
            emit SwapAndLiquifyEnabledUpdated(true);
        }
    }
}