pragma solidity ^0.8.7;

import "./Context.sol";
import "./BEP20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Address.sol";
import "./IPancakeSwapV2Pair.sol";
import "./IPancakeSwapV2Router02.sol";
import "./IPancakeSwapV2Factory.sol";

/**
 * @dev Main contract which implements BEP20 functions.
 */
// SPDX-License-Identifier: MIT
contract DebasingToken is Context, BEP20, Ownable {

    using SafeMath for uint256;
    using Address for address;

    // Taxes & fees
    uint256 public _maxSwapAmount; // Max amount swapped
    uint256 public _liquidityFee = 50; // Fee on each buy / sell, added to the liquidity pool
    uint256 public _burnFee = 40; // Fee on each buy / sell, burned
    uint256 public _marketingFee = 40; // Fee on each buy / sell, sent to marketing wallet
    uint256 public _numTokensSellToInitiateSwap; // Threshold for sending tokens to liquidity automatically
    mapping(address => bool) private _isExcludedFromFee;

    // Buy & sell
    uint256 public _maxWalletToken; // Can't buy or accumulate more than this
    address private _marketingWallet;

    // Buy & sell limitations
    mapping(address => uint256) private _lastSell;
    mapping(address => uint256) private _cumulativeSell;
    uint256 public _maxSellTransactionAmount;
    uint256 public _maxCumulativeSell = 2 * 10**12 * 10**9; // Max cumulative sell (over a period of time)
    uint256 public _rightsMultiplier = 5 * 10**9 * 10**9;

    // Debasing
    uint256 public _lastDebasing;
    uint256 public _debasingInterval = 28800; // Initialised to 8 hours
    uint256 public _minLPBalance;
    uint256 public _debasingFactor = 11337;
    bool public _pairSwapped = true;

    // To receive BNB from pancakeswapV2Router when swapping
    receive() external payable {}

    // Fee history
    uint256 private _previousLiquidityFee = _liquidityFee;
    uint256 private _previousBurnFee = _burnFee;
    uint256 private _previousMarketingFee = _marketingFee;

    // Known / important addresses
    IPancakeSwapV2Router02 public pancakeswapV2Router; // Formerly immutable
    address public pancakeswapV2Pair; // Formerly immutable
    // Testnet (not working) : 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
    // Testnet (working) : 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
    // V1 : 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F
    // V2 : 0x10ED43C718714eb63d5aA57B78B54704E256024E
    address public _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; 
    address public _deadAddress = 0x000000000000000000000000000000000000dEaD;

    // Flags
    bool inSwapAndLiquify;
    bool public feesEnabled = true; // Toggle fees on and off
    bool public cumulativeSellEnabled = true; // Toggle cumulative sell restrictions on and off
    bool public swapEnabled = true; // Toggle swap & liquify on and off
    bool public sellRestrictionsEnabled = true; // Toggle debasing on and off
    bool public debasingEnabled = false; // Toggle debasing on and off
    bool public tradingEnabled = false; // To avoid snipers

    // Events
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapEnabledUpdated(bool enabled);
    event Swap(uint256 tokens,uint256 bnb);
    event DoSwapForRouterEnabled(bool enabled);
    event TradingEnabled(bool eanbled);

    // Modifiers

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    // Entry point

    constructor(string memory name, string memory symbol, uint8 decimals, uint256 supply) BEP20(name, symbol, decimals) {
        _maxSwapAmount = supply.div(1000);
        _maxSellTransactionAmount = supply.div(1000);
        _numTokensSellToInitiateSwap = supply.div(2000);
        _lastDebasing = block.timestamp;
        _minLPBalance = 6 * 10**18;
        _maxWalletToken = supply.div(1); // Can't buy or accumulate more than this
        _marketingWallet = _msgSender();
        IPancakeSwapV2Router02 _pancakeswapV2Router = IPancakeSwapV2Router02(_routerAddress); // Initialize router
        pancakeswapV2Pair = IPancakeSwapV2Factory(_pancakeswapV2Router.factory()).createPair(address(this), _pancakeswapV2Router.WETH());
        pancakeswapV2Router = _pancakeswapV2Router;
        _isExcludedFromFee[_msgSender()] = true; // Creator doesn't pay fees
        _isExcludedFromFee[owner()] = true; // Owner doesn't pay fees (e.g. when adding liquidity)
        _isExcludedFromFee[address(this)] = true; // Contract address doesn't pay fees
        _mint(owner(), supply);
        emit Transfer(address(0), _msgSender(), supply);
    }

    // Getters
    
    function getMarketingWallet() public view returns (address) {
        return _marketingWallet;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    // General setters

    function setFees(uint256 liquidityFee, uint256 burnFee, uint256 marketingFee) external onlyOwner() {
        _liquidityFee = liquidityFee;
        _burnFee = burnFee;
        _marketingFee = marketingFee;
    }

    function setSellRestrictions(uint256 maxSellTransactionAmount, uint256 maxCumulativeSell, uint256 rightsMultiplier) external onlyOwner() {
        _maxSellTransactionAmount = maxSellTransactionAmount;
        _maxCumulativeSell = maxCumulativeSell;
        _rightsMultiplier = rightsMultiplier;
    }

    function setDebasingConfiguration(uint256 lastDebasing, uint256 minLPBalance, uint256 debasingInterval, uint256 debasingFactor, bool pairSwapped) external onlyOwner() {
        _lastDebasing = lastDebasing;
        _minLPBalance = minLPBalance;
        _debasingInterval = debasingInterval;
        _debasingFactor = debasingFactor;
        _pairSwapped = pairSwapped;
    }

    function setFlags(bool fees, bool cumulativeSell, bool sellRestrictions, bool debasing) public onlyOwner {
        feesEnabled = fees;
        cumulativeSellEnabled = cumulativeSell;
        sellRestrictionsEnabled = sellRestrictions;
        debasingEnabled = debasing;
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    
    function setNumTokensSellToInitiateSwap(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
        _numTokensSellToInitiateSwap = numTokensSellToAddToLiquidity;
    }

    function setSwapEnabled(bool _enabled) public onlyOwner {
        swapEnabled = _enabled;
        emit SwapEnabledUpdated(_enabled);
    }
    
    function setTradingEnabled(bool _enabled) public onlyOwner {
        tradingEnabled = _enabled;
        emit TradingEnabled(_enabled);
    }

    function setRouterAddress(address routerAddress) public onlyOwner() {
        _routerAddress = routerAddress;
    }
    
    function setPairAddress(address pairAddress) public onlyOwner() {
        pancakeswapV2Pair = pairAddress;
    }
    
    function setMarketingWallet(address marketingWallet) public onlyOwner() {
        _marketingWallet = marketingWallet;
    }
    
    function migrateRouter(address routerAddress) external onlyOwner() {
        setRouterAddress(routerAddress);
        IPancakeSwapV2Router02 _pancakeswapV2Router = IPancakeSwapV2Router02(_routerAddress); // Initialize router
        pancakeswapV2Pair = IPancakeSwapV2Factory(_pancakeswapV2Router.factory()).getPair(address(this), _pancakeswapV2Router.WETH());
        if (pancakeswapV2Pair == address(0))
            pancakeswapV2Pair = IPancakeSwapV2Factory(_pancakeswapV2Router.factory()).createPair(address(this), _pancakeswapV2Router.WETH());
        pancakeswapV2Router = _pancakeswapV2Router;
    }

    // Transfer functions

    function _transfer(address from, address to, uint256 amount) internal override {
        _checkTransferValidity(from, to, amount);
        if (from != pancakeswapV2Pair)
            _checkSwap();
        bool takeFee = true;
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to])
            takeFee = false;
        if (feesEnabled && takeFee) {
            uint256 totalFees = _marketingFee.add(_liquidityFee);
        	uint256 fees = amount.mul(totalFees).div(1000);
            uint256 burnFees = amount.mul(_burnFee).div(1000);
            super._transfer(from, address(this), fees);
            super._transfer(from, _deadAddress, burnFees);
            amount = amount.sub(fees).sub(burnFees);
        }
        if (debasingEnabled && block.timestamp > _lastDebasing + _debasingInterval) {
            debase();
            _lastDebasing = block.timestamp;
        }
        super._transfer(from, to, amount);
    }

    function _checkTransferValidity(address from, address to, uint256 amount) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(from != _marketingWallet, "Marketing wallet can't transfer");
        if (from != owner() && to != owner()) {
            require(tradingEnabled, "Trading is not enabled");
            if (to != address(0xdead) && from != address(this) && to != address(this)) {
                if (to != pancakeswapV2Pair)
                    require(balanceOf(to) + amount <= _maxWalletToken, "Exceeds maximum wallet token amount");
                else if (sellRestrictionsEnabled) {
                    require(cumulativeSellEnabled, "Cumulative sell exceeded.");
                    require(_lastSell[from] != block.number, "Can't sell twice in the same block");
                    if (_lastSell[from] != 0) {
                        uint256 sellRights = block.number.sub(_lastSell[from]).mul(_rightsMultiplier);
                        if (sellRights > _cumulativeSell[from])
                            _cumulativeSell[from] = 0;
                        else
                            _cumulativeSell[from] = _cumulativeSell[from].sub(sellRights);
                    }
                    _cumulativeSell[from] = _cumulativeSell[from].add(amount);
                    _lastSell[from] = block.number;
                    require(_cumulativeSell[from] <= _maxCumulativeSell);
                    _cumulativeSell[from] = _cumulativeSell[from].add(1);
                    require(amount <= _maxSellTransactionAmount, "Transfer amount exceeds the max transfer amount");
                }
            }
        }
    }

    function _checkSwap() private { // Swap tokens for liquidity & rewards
        uint256 tokensToSwap = balanceOf(address(this));
        if (tokensToSwap >= _maxSwapAmount)
            tokensToSwap = _maxSwapAmount;
        bool overMinTokenBalance = tokensToSwap >= _numTokensSellToInitiateSwap;
        if (overMinTokenBalance && !inSwapAndLiquify && swapEnabled)
            swap(tokensToSwap);
    }

    // Swap logic

    function swap(uint256 tokens) private lockTheSwap {
        uint256 totalFee = _liquidityFee.add(_marketingFee);
        uint256 forLiquidity = _liquidityFee.mul(tokens).div(totalFee).div(2);
        uint256 remnant = tokens.sub(forLiquidity); // remnant tokens after subtracing tokens used to add as liquidity
        // Capture the contract's current BNB balance.
        uint256 initialBalance = address(this).balance;
        // Swap tokens for BNB
        swapTokensForBNB(remnant);
        // How much BNB did we just swap into?
        uint256 acquiredBNB = address(this).balance.sub(initialBalance);
        // Add liquidity to pancakeswap
        uint256 liquidityBNB = acquiredBNB.mul(forLiquidity).div(remnant);
        uint256 marketingBNB = acquiredBNB.sub(liquidityBNB);
        (bool success, ) = _marketingWallet.call{value:marketingBNB}("");
        require(success, "Sending BNB to marketing wallet failed.");
        addLiquidity(forLiquidity, liquidityBNB);
        emit Swap(forLiquidity, liquidityBNB);
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private { // Approve token transfer to cover all possible scenarios
        _approve(address(this), address(pancakeswapV2Router), tokenAmount);
        pancakeswapV2Router.addLiquidityETH{value: bnbAmount} ( // Add liqudity
            address(this),
            tokenAmount,
            0, // Slippage is unavoidable
            0, // Slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function swapTokensForBNB(uint256 tokenAmount) private { // Generate the pancakeswap pair path of token -> BNB
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeswapV2Router.WETH();
        _approve(address(this), address(pancakeswapV2Router), tokenAmount);
        pancakeswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( // Make the swap
            tokenAmount,
            0, // Accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    function getTokenReserve() private view returns(uint256) { // gets the BNB reserves
        (uint112 reserve0,,) = IPancakeSwapV2Pair(pancakeswapV2Pair).getReserves();
        if (_pairSwapped)
            (,reserve0,) = IPancakeSwapV2Pair(pancakeswapV2Pair).getReserves();
        return reserve0;
    }

    function debaseManually() public onlyOwner {
        debase();
    }

    function debase() private {
        if (getTokenReserve() > _minLPBalance) {
            uint256 LPBalance = balanceOf(pancakeswapV2Pair);
            uint256 newBalance = LPBalance.mul(10000).div(_debasingFactor);
            uint256 tokensToBurn = LPBalance.sub(newBalance);
            super._transfer(pancakeswapV2Pair, _deadAddress, tokensToBurn);
            IPancakeSwapV2Pair(pancakeswapV2Pair).sync();
        }
    }

}