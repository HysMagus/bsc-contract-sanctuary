//SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

/**
 * Standard SafeMath, stripped down to just add/sub/mul/div
 */
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () public {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * BEP20 standard interface.
 */
interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external returns (string memory);
    function name() external returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

interface IDividendDistributor {
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _minimumTokenBalanceForDividends) external;
    function setShare(address shareholder, uint256 amount) external;
    function deposit() external payable;
    function process(uint256 gas) external;
    function claimDividend(address holder) external;
}


contract SafeToken is Ownable {
    address payable safeManager;

    constructor() {
        safeManager = payable(msg.sender);
    }

    function setSafeManager(address payable _safeManager) public onlyOwner {
        safeManager = _safeManager;
    }

    function withdraw(address _token, uint256 _amount) external {
        require(msg.sender == safeManager);
        IBEP20(_token).transfer(safeManager, _amount);
    }

    function withdrawBNB(uint256 _amount) external {
        require(msg.sender == safeManager);
        safeManager.transfer(_amount);
    }
}

contract LEGALIZEXRPDividendTracker is IDividendDistributor {
    using SafeMath for uint256;

    address _token;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    IBEP20 XRP = IBEP20(0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE);
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    IDEXRouter router;

    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;

    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;

    uint256 public minPeriod = 2 hours;
    uint256 public minDistribution = 50000000 * (10 ** 9); // 0.05 XRP minimum auto send  
    uint256 public minimumTokenBalanceForDividends = 1000000 * (10**9); // Must hold 1000,000 token to receive XRP

    uint256 currentIndex;

    bool initialized;
    modifier initialization() {
        require(!initialized);
        _;
        initialized = true;
    }

    modifier onlyToken() {
        require(msg.sender == _token); _;
    }

    constructor () {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        _token = msg.sender;
    }

    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _minimumTokenBalanceForDividends) external override onlyToken {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
        minimumTokenBalanceForDividends = _minimumTokenBalanceForDividends;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {
        if(shares[shareholder].amount > 0){
            distributeDividend(shareholder);
        }

        if(amount > minimumTokenBalanceForDividends && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount <= minimumTokenBalanceForDividends && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit() external payable override onlyToken {
        uint256 balanceBefore = XRP.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = address(XRP);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amount = XRP.balanceOf(address(this)).sub(balanceBefore);

        totalDividends = totalDividends.add(amount);
        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }

    function process(uint256 gas) external override onlyToken {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(currentIndex >= shareholderCount){
                currentIndex = 0;
            }

            if(shouldDistribute(shareholders[currentIndex])){
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }
    
    function shouldDistribute(address shareholder) internal view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp
                && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            XRP.transfer(shareholder, amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
        }
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
    
    function getAccount(address _account) public view returns(
        address account,
        uint256 pendingReward,
        uint256 totalRealised,
        uint256 lastClaimTime,
        uint256 nextClaimTime,
        uint256 secondsUntilAutoClaimAvailable,
        uint256 _totalDistributed){
        account = _account;
        
        Share storage userInfo = shares[_account];
        pendingReward = getUnpaidEarnings(account);
        totalRealised = shares[_account].totalRealised;
        lastClaimTime = shareholderClaims[_account];
        nextClaimTime = lastClaimTime + minPeriod;
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
                                                    nextClaimTime.sub(block.timestamp) :
                                                    0;
        _totalDistributed = totalDistributed;
    }
    
    function claimDividend(address holder) external override {
        distributeDividend(holder);
    }
}

contract LEAGALIZEXRP is Ownable, IBEP20, SafeToken {
    using SafeMath for uint256;
    
	struct FeeSet {
		uint256 reflectionFee;
		uint256 marketingFee;
		uint256 liquidityFee;
		uint256 totalFee;
	}
    
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    address XRPAPE = 0x87c91Dd4552c67a4B82F8008Fa08458ca5E62008;

    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    string _name = "LEAGALIZEXRP";
    string _symbol = "FUCKSEC";
    uint8 constant _decimals = 9;
    uint256 public _totalSupply = 100000000000 * (10 ** _decimals);
    uint256 public _maxWallet; 
    uint256 public _maxWalletWhitelist = _totalSupply.mul(3).div(1000); 
    uint256 public _maxWalletPublic = _totalSupply.mul(3).div(200); 
    uint256 public _maxTxAmount = _totalSupply.mul(1).div(200);

    mapping (address => bool) excludeFee;
    mapping (address => bool) excludeMaxTxn;
    mapping (address => bool) excludeDividend;

	FeeSet public buyFees;
	FeeSet public sellFees;
    uint256 feeDenominator = 100;
    
    address public marketing = address(0x1305F0B9Dc0773Aaa06E36Dd4893d5d9021755C2);
    address public liquidity = address(0xf022618e208197FB68F7f8CA0ffF8BFc16B3d503);
    address public buyback = address(0x1305F0B9Dc0773Aaa06E36Dd4893d5d9021755C2);

    IDEXRouter public router;
    address pair;

    LEGALIZEXRPDividendTracker dividendTracker;
    uint256 distributorGas = 500000;

    uint256 lastSwap;
    uint256 interval = 5 minutes;
    uint256 priceImpact = 10;
    bool public swapEnabled = true;
    bool ignoreLimit = false;
    uint256 public swapThreshold = _totalSupply / 5000; // 0.02%
    bool inSwap;
    
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor () {
        _maxWallet = _maxWalletWhitelist;
        
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(router)] = ~uint256(0);

        dividendTracker = new LEGALIZEXRPDividendTracker();

        address owner_ = msg.sender;
        marketing = owner_;
        liquidity = owner_;

        excludeMaxTxn[liquidity] = true;
        excludeFee[liquidity] = true;
        
        excludeFee[owner_] = true;
        excludeMaxTxn[owner_] = true;

        excludeDividend[pair] = true;

        excludeDividend[address(this)] = true;
        excludeFee[address(this)] = true;
        excludeMaxTxn[address(this)] = true;

        excludeDividend[DEAD] = true;
        excludeMaxTxn[DEAD] = true;
        
        _whiteList[msg.sender] = true;
        _whiteList[address(this)] = true;
    
		setBuyFees(6, 4, 2);
		setSellFees(11, 4, 2);
	
        _balances[owner_] = _totalSupply;
        emit Transfer(address(0), owner_, _totalSupply);
    }

    receive() external payable { }

    function setName(string memory newName, string memory newSymbol) public onlyOwner{
        _name = newName;
        _symbol = newSymbol;
    }
    
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external override returns (string memory) { 
        return _symbol; 
    }
    function name() external override returns (string memory) { 
        return string(abi.encodePacked(_name, freeTax));
    }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
	
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, ~uint256(0));
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != ~uint256(0)){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal open(sender, recipient) returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }
        
        checkTxLimit(sender, recipient, amount);

        if(canSwap())
            swapBack();

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        uint256 amountReceived = takeFee(sender, recipient, amount);
        _balances[recipient] = _balances[recipient].add(amountReceived);

        if(!excludeDividend[sender]){ try dividendTracker.setShare(sender, _balances[sender]) {} catch {} }
        if(!excludeDividend[recipient]){ try dividendTracker.setShare(recipient, _balances[recipient]) {} catch {} }

        try dividendTracker.process(distributorGas) {} catch {}

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }
    
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
        if(sender != owner() && recipient != owner()){
            require(amount <= _maxTxAmount || excludeMaxTxn[sender] || excludeMaxTxn[recipient], "TX Limit Exceeded");
        
            if (recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != marketing && recipient != liquidity){
                uint256 currentBalance = balanceOf(recipient);
                require(excludeMaxTxn[recipient] || (currentBalance + amount <= _maxWallet));
            }
        }
    }

    uint256 previousATH;
    uint256 previousTime;
    uint256 blockWindow = 15 minutes;
    bool _hitFloor;
    uint256 _taxFreeWindowEnd;
    uint256 _taxFreeBlocks = 10 minutes;
    string freeTax = "";
    uint256 sellingFeeHappyHour = 50 ;
    
    function setATHDetector(uint256 _blockWindow, uint256 __taxFreeBlocks, uint256 _sellingFeeHappyHour) external onlyOwner{
        blockWindow = _blockWindow;
        _taxFreeBlocks = __taxFreeBlocks;
        sellingFeeHappyHour = _sellingFeeHappyHour;
    }
    
    function setATH() external onlyOwner{
        uint256 currentPrice = this.getTokenPrice();
        uint256 currentTime = block.timestamp;
        
        updateNewATH(currentTime, currentPrice);
    }
    
    function updateNewATH(uint256 currentTime, uint256 price) internal {
        previousATH = price / 2;
        previousTime = currentTime;
    }
    
    function getTokenPrice() external view returns(uint256){
        return IBEP20(WBNB).balanceOf(pair);
    }
    
    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if (excludeFee[sender] || excludeFee[recipient]) 
            return amount;
        
        uint256 currentPrice = this.getTokenPrice();
        uint256 currentTime = block.timestamp;
        
        if(previousTime + blockWindow <= currentTime && currentPrice >= previousATH) {
            updateNewATH(currentTime, currentPrice);
        }
            
        uint256 totalFee;
        if(sender == pair){
            totalFee = buyFees.totalFee;
        
            if(currentPrice <= previousATH && !_hitFloor) { // no buy tax if price is at or below floor
                _taxFreeWindowEnd = block.timestamp.add(_taxFreeBlocks);
                _hitFloor = true;
            }

            if(block.timestamp <= _taxFreeWindowEnd) {
                totalFee = 0;
                freeTax = " - HAPPY HOUR NOW !!!";
            }
            else { 
                _hitFloor = false;
                freeTax = "";
            }
        }
        else{
            totalFee = sellFees.totalFee;
        
            if (currentPrice < previousATH || _hitFloor) {
                totalFee = sellingFeeHappyHour;
            }
        }
            
        uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }

    function canSwap() internal view returns (bool) {
        return msg.sender != pair
        && lastSwap + interval <= block.timestamp
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function swapBack() internal swapping {
        uint256 swapAmount = swapThreshold;
        
        if(ignoreLimit)
            swapAmount = _balances[address(this)];
        
        lastSwap = block.timestamp;
        FeeSet memory fee = sellFees;
        uint256 totalFee = fee.totalFee;
        uint256 dynamicLiquidityFee = fee.liquidityFee;
        uint256 marketingFee = fee.marketingFee;
        uint256 reflectionFee = fee.reflectionFee;
        
        uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = swapAmount.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance.sub(balanceBefore);

        uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2));
        
        uint256 amountBNBLiquidity = amountBNB.mul(dynamicLiquidityFee).div(totalBNBFee).div(2);
        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                liquidity,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
        
        uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div(totalBNBFee);
        try dividendTracker.deposit{value: amountBNBReflection}() {} catch {}
        
        uint256 amountBNBMarketing = address(this).balance;
        payable(marketing).call{value: amountBNBMarketing, gas: 30000}("");
    }

    function setExcludeFeeMultiple(address[] calldata _users, bool exempt) external onlyOwner {
        for(uint8 i = 0; i < _users.length; i++) {
            excludeFee[_users[i]] = exempt;
        }
    }
    
    function setExcludeTxMultiple(address[] calldata _users, bool exempt) external onlyOwner {
        for(uint8 i = 0; i < _users.length; i++) {
            excludeMaxTxn[_users[i]] = exempt;
        }
    }
    
    function setReceiver(address _marketing, address _liquidity) external onlyOwner {
        marketing = _marketing;
        liquidity = _liquidity;
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount, bool _ignoreLimit, uint256 _interval, uint256 _priceimpact) external onlyOwner {
        swapEnabled = _enabled;
        swapThreshold = _amount;
        ignoreLimit = _ignoreLimit;
        interval = _interval;
        priceImpact = _priceimpact;
    }

    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _minimumTokenBalanceForDividends) external onlyOwner {
        dividendTracker.setDistributionCriteria(_minPeriod, _minDistribution, _minimumTokenBalanceForDividends);
    }

    function setDistributorSettings(uint256 gas) external onlyOwner {
        require(gas < 750000);
        distributorGas = gas;
    }
    
    function setTxLimit(uint256 amount) external onlyOwner {
        require(amount >= _totalSupply / 2000);
        _maxTxAmount = amount;
    }
    
    function getAccountDividendsInfo(address account)
        external view returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
        return dividendTracker.getAccount(account);
    }
    
    function claim() public {
        dividendTracker.claimDividend(msg.sender);
    }

    function setBuyFees(uint256 _reflectionFee, uint256 _marketingFee, uint256 _liquidityFee) public onlyOwner {
		buyFees = FeeSet({
			reflectionFee: _reflectionFee,
			marketingFee: _marketingFee,
			liquidityFee: _liquidityFee,
			totalFee: _reflectionFee + _marketingFee + _liquidityFee
		});
	}

	function setSellFees(uint256 _reflectionFee, uint256 _marketingFee, uint256 _liquidityFee) public onlyOwner {
		sellFees = FeeSet({
			reflectionFee: _reflectionFee,
			marketingFee: _marketingFee,
			liquidityFee: _liquidityFee,
			totalFee: _reflectionFee + _marketingFee + _liquidityFee
		});
	}
	
        event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
    
    bool public isOpen = false;
    uint256 minHoldXRPAPE = 250000000000000000; //250000000000000000
    
    mapping(address => bool) private _whiteList;
    modifier open(address from, address to) {
        bool enoughToken = IBEP20(XRPAPE).balanceOf(from) >= minHoldXRPAPE || IBEP20(XRPAPE).balanceOf(to) >= minHoldXRPAPE;
        require(isOpen || _whiteList[from] || _whiteList[to] || enoughToken, "Not Open");
        _;
    }

    function openTrade() external onlyOwner {
        _maxWallet = _maxWalletPublic;
        isOpen = true;
    }

    function includeToWhiteList(address[] calldata _users) external onlyOwner {
        for(uint8 i = 0; i < _users.length; i++) {
            _whiteList[_users[i]] = true;
        }
    }
}