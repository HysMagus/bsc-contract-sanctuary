pragma solidity ^0.6.0;

  /**
   * PLEASE JOIN OUR COMMUNITY :  https://t.me/autonomyprotocol
  */


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

    
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

   
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
          
            if (returndata.length > 0) {
               
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    constructor () internal {
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


interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function sync() external;
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
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
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
}

pragma solidity ^0.6.12;

contract RewardWallet {
    constructor() public {
    }
}

contract Balancer {
    using SafeMath for uint256;
    IUniswapV2Router02 public immutable _uniswapV2Router;
    Autonomy private _tokenContract;
    
    constructor(Autonomy tokenContract, IUniswapV2Router02 uniswapV2Router) public {
        _tokenContract =tokenContract;
        _uniswapV2Router = uniswapV2Router;
    }
    
    receive() external payable {}
    
    function rebalance() external returns (uint256) { 
        swapEthForTokens(address(this).balance);
    }

    function swapEthForTokens(uint256 EthAmount) private {
        address[] memory uniswapPairPath = new address[](2);
        uniswapPairPath[0] = _uniswapV2Router.WETH();
        uniswapPairPath[1] = address(_tokenContract);

        _uniswapV2Router
            .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
                0,
                uniswapPairPath,
                address(this),
                block.timestamp
            );
    }
}

contract Swaper {
    using SafeMath for uint256;
    IUniswapV2Router02 public immutable _uniswapV2Router;
    Autonomy private _tokenContract;
    
    constructor(Autonomy tokenContract, IUniswapV2Router02 uniswapV2Router) public {
        _tokenContract = tokenContract;
        _uniswapV2Router = uniswapV2Router;
    }
    
    function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
        uint256 initialPairTokenBalance = IBEP20(pairTokenAddress).balanceOf(address(this));
        swapTokensForTokens(pairTokenAddress, tokenAmount);
        uint256 newPairTokenBalance = IBEP20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
        IBEP20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
    }
    
    function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(_tokenContract);
        path[1] = pairTokenAddress;

        _tokenContract.approve(address(_uniswapV2Router), tokenAmount);

        // make the swap
        _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of pair token
            path,
            address(this),
            block.timestamp
        );
    }
}

contract Autonomy is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    IUniswapV2Router02 public immutable _uniswapV2Router;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;
    address public _rewardWallet;
    uint256 public _initialRewardLockAmount;
    address public _uniswapETHPool;
    
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 10000000e9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 public _tFeeTotal;
    uint256 public _tBurnTotal;

    string private _name = 'Autonomy';
    string private _symbol = 'AUTO';
    uint8 private _decimals = 9;
    
    uint256 public _feeDecimals = 1;
    uint256 public _taxFee = 0;
    uint256 public _lockFee = 0;
    uint256 public _maxTxAmount = 2000000e9;
    uint256 public _minTokensBeforeSwap = 10000e9;
    uint256 public _minInterestForReward = 10e9;
    uint256 private _autoSwapCallerFee = 200e9;
    
    bool private inSwapAndLiquify;
    bool public swapAndLiquifyEnabled;
    bool public tradingEnabled;
    
    address private currentPairTokenAddress;
    address private currentPoolAddress;
    
    uint256 private _liquidityRemoveFee = 2;
    uint256 private _alchemyCallerFee = 5;
    uint256 private _minTokenForAlchemy = 1000e9;
    uint256 private _lastAlchemy;
    uint256 private _alchemyInterval = 12 hours;
    

    event FeeDecimalsUpdated(uint256 taxFeeDecimals);
    event TaxFeeUpdated(uint256 taxFee);
    event LockFeeUpdated(uint256 lockFee);
    event MaxTxAmountUpdated(uint256 maxTxAmount);
    event WhitelistUpdated(address indexed pairTokenAddress);
    event TradingEnabled();
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        address indexed pairTokenAddress,
        uint256 tokensSwapped,
        uint256 pairTokenReceived,
        uint256 tokensIntoLiqudity
    );
    event Rebalance(uint256 tokenBurnt);
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
    event MinInterestForRewardUpdated(uint256 minInterestForReward);
    event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
    event AlchemyCallerFeeUpdated(uint256 rebalnaceCallerFee);
    event MinTokenForAlchemyUpdated(uint256 minRebalanceAmount);
    event AlchemyIntervalUpdated(uint256 rebalanceInterval);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    Balancer public balancer;
    Swaper public swaper;

    constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
        _lastAlchemy = now;
        
        _uniswapV2Router = uniswapV2Router;
        _rewardWallet = address(new RewardWallet());
        _initialRewardLockAmount = initialRewardLockAmount;
        
        balancer = new Balancer(this, uniswapV2Router);
        swaper = new Swaper(this, uniswapV2Router);
        
        currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), uniswapV2Router.WETH());
        currentPairTokenAddress = uniswapV2Router.WETH();
        _uniswapETHPool = currentPoolAddress;
        
        updateSwapAndLiquifyEnabled(false);
        
        _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
        _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
        
        emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
        emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    
    function reflect(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Autonomy: Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Autonomy: Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeAccount(address account) external onlyOwner() {
        require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Autonomy: We can not exclude Pancakeswap router.');
        require(account != address(this), 'Autonomy: We can not exclude contract self.');
        require(account != _rewardWallet, 'Autonomy: We can not exclude reweard wallet.');
        require(!_isExcluded[account], "Autonomy: Account is already excluded");
        
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyOwner() {
        require(_isExcluded[account], "Autonomy: Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "Autonomy: approve from the zero address");
        require(spender != address(0), "Autonomy: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Autonomy: transfer from the zero address");
        require(recipient != address(0), "Autonomy: transfer to the zero address");
        require(amount > 0, "Autonomy: Transfer amount must be greater than zero");
        
        if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
            require(amount <= _maxTxAmount, "Autonomy: Transfer amount exceeds the maxTxAmount.");
            if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
                require(false, "Autonomy: trading is disabled.");
        }
        
        if(!inSwapAndLiquify) {
            uint256 lockedBalanceForPool = balanceOf(address(this));
            bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
            if (
                overMinTokenBalance &&
                msg.sender != currentPoolAddress &&
                swapAndLiquifyEnabled
            ) {
                if(currentPairTokenAddress == _uniswapV2Router.WETH())
                    swapAndLiquifyForEth(lockedBalanceForPool);
                else
                    swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
            }
        }
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
    }
    
    receive() external payable {}
    
    function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
        // split the contract balance except swapCallerFee into halves
        uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
        uint256 half = lockedForSwap.div(2);
        uint256 otherHalf = lockedForSwap.sub(half);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH
        swapTokensForEth(half);
        
        // how much ETH did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to uniswap
        addLiquidityForEth(otherHalf, newBalance);
        
        emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
        
        _transfer(address(this), tx.origin, _autoSwapCallerFee);
        
        _sendRewardInterestToPool();
    }
    
    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniswapV2Router.WETH();

        _approve(address(this), address(_uniswapV2Router), tokenAmount);

        // make the swap
        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(_uniswapV2Router), tokenAmount);

        // add the liquidity
        _uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }
    
    function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
        uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
        uint256 half = lockedForSwap.div(2);
        uint256 otherHalf = lockedForSwap.sub(half);
        
        _transfer(address(this), address(swaper), half);
        
        uint256 initialPairTokenBalance = IBEP20(pairTokenAddress).balanceOf(address(this));
        
       
        swaper.swapTokens(pairTokenAddress, half);
        
        uint256 newPairTokenBalance = IBEP20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);

       
        addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
        
        emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
        
        _transfer(address(this), tx.origin, _autoSwapCallerFee);
        
        _sendRewardInterestToPool();
    }

    function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(_uniswapV2Router), tokenAmount);
        IBEP20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);

        // add the liquidity
        _uniswapV2Router.addLiquidity(
            address(this),
            pairTokenAddress,
            tokenAmount,
            pairTokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }

    function alchemy() public lockTheSwap {
        require(balanceOf(_msgSender()) >= _minTokenForAlchemy, "Autonomy: You have not enough Autonomy to ");
        require(now > _lastAlchemy + _alchemyInterval, 'Autonomy: Too Soon.');
        
        _lastAlchemy = now;

        uint256 amountToRemove = IBEP20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);

        removeLiquidityETH(amountToRemove);
        balancer.rebalance();

        uint256 tNewTokenBalance = balanceOf(address(balancer));
        uint256 tRewardForCaller = tNewTokenBalance.mul(_alchemyCallerFee).div(100);
        uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
        
        uint256 currentRate =  _getRate();
        uint256 rBurn =  tBurn.mul(currentRate);
        
        _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
        _rOwned[address(balancer)] = 0;
        
        _tBurnTotal = _tBurnTotal.add(tBurn);
        _tTotal = _tTotal.sub(tBurn);
        _rTotal = _rTotal.sub(rBurn);

        emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
        emit Transfer(address(balancer), address(0), tBurn);
        emit Rebalance(tBurn);
    }
    
    function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
        IBEP20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
        (ETHAmount) = _uniswapV2Router
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                address(this),
                lpAmount,
                0,
                0,
                address(balancer),
                block.timestamp
            );
    }

    function _sendRewardInterestToPool() private {
        uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
        if(tRewardInterest > _minInterestForReward) {
            uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
            _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
            _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
            emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
            IUniswapV2Pair(currentPoolAddress).sync();
        }
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
        uint256 rLock =  tLock.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if(inSwapAndLiquify) {
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
        uint256 rLock =  tLock.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if(inSwapAndLiquify) {
            _tOwned[recipient] = _tOwned[recipient].add(tAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
        uint256 rLock =  tLock.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if(inSwapAndLiquify) {
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
        uint256 rLock =  tLock.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if(inSwapAndLiquify) {
            _tOwned[recipient] = _tOwned[recipient].add(tAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        }
        else {
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
    }

    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
        uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
        uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
        return (tTransferAmount, tFee, tLockFee);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLock = tLock.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() public view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() public view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
    
    function getCurrentPoolAddress() public view returns(address) {
        return currentPoolAddress;
    }
    
    function getCurrentPairTokenAddress() public view returns(address) {
        return currentPairTokenAddress;
    }

    function getLiquidityRemoveFee() public view returns(uint256) {
        return _liquidityRemoveFee;
    }
    
    function getAlchemyCallerFee() public view returns(uint256) {
        return _alchemyCallerFee;
    }
    
    function getMinTokenForAlchemy() public view returns(uint256) {
        return _minTokenForAlchemy;
    }
    
    function getLastAlchemy() public view returns(uint256) {
        return _lastAlchemy;
    }
    
    function getAlchemyInterval() public view returns(uint256) {
        return _alchemyInterval;
    }
    
    function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
        require(feeDecimals >= 0 && feeDecimals <= 2, 'Autonomy: fee decimals should be in 0 - 2');
        _feeDecimals = feeDecimals;
        emit FeeDecimalsUpdated(feeDecimals);
    }
    
    function _setTaxFee(uint256 taxFee) external onlyOwner() {
        require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Autonomy: taxFee should be in 0 - 5');
        _taxFee = taxFee;
        emit TaxFeeUpdated(taxFee);
    }
    
    function _setLockFee(uint256 lockFee) external onlyOwner() {
        require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Autonomy: lockFee should be in 0 - 5');
        _lockFee = lockFee;
        emit LockFeeUpdated(lockFee);
    }
    
    function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        require(maxTxAmount >= 500000e9 , 'Autonomy: maxTxAmount should be greater than 500000e9');
        _maxTxAmount = maxTxAmount;
        emit MaxTxAmountUpdated(maxTxAmount);
    }
    
    function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
        require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Autonomy: minTokenBeforeSwap should be in 50e9 - 25000e9');
        require(minTokensBeforeSwap > _autoSwapCallerFee , 'Autonomy: minTokenBeforeSwap should be greater than autoSwapCallerFee');
        _minTokensBeforeSwap = minTokensBeforeSwap;
        emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
    }
    
    function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
        require(autoSwapCallerFee >= 1e9, 'Autonomy: autoSwapCallerFee should be greater than 1e9');
        _autoSwapCallerFee = autoSwapCallerFee;
        emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
    }
    
    function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
        _minInterestForReward = minInterestForReward;
        emit MinInterestForRewardUpdated(minInterestForReward);
    }
    
    function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
        require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Autonomy: liquidityRemoveFee should be in 1 - 10');
        _liquidityRemoveFee = liquidityRemoveFee;
        emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
    }
    
    function _setAlchemyCallerFee(uint256 alchemyCallerFee) external onlyOwner() {
        require(alchemyCallerFee >= 1 && alchemyCallerFee <= 15 , 'Autonomy: alchemyCallerFee should be in 1 - 15');
        _alchemyCallerFee = alchemyCallerFee;
        emit AlchemyCallerFeeUpdated(alchemyCallerFee);
    }
    
    function _setMinTokenForAlchemy(uint256 minTokenForAlchemy) external onlyOwner() {
        _minTokenForAlchemy = minTokenForAlchemy;
        emit MinTokenForAlchemyUpdated(minTokenForAlchemy);
    }
    
    function _setAlchemyInterval(uint256 alchemyInterval) external onlyOwner() {
        _alchemyInterval = alchemyInterval;
        emit AlchemyIntervalUpdated(alchemyInterval);
    }
    
    function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    
    function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
        require(poolAddress != address(0), "Autonomy: Pool address is zero.");
        require(pairTokenAddress != address(0), "Autonomy: Pair token address is zero.");
        require(pairTokenAddress != address(this), "Autonomy: Pair token address self address.");
        require(pairTokenAddress != currentPairTokenAddress, "Autonomy: Pair token address is same as current one.");
        
        currentPoolAddress = poolAddress;
        currentPairTokenAddress = pairTokenAddress;
        
        emit WhitelistUpdated(pairTokenAddress);
    }

    function _enableTrading() external onlyOwner() {
        tradingEnabled = true;
        TradingEnabled();
    }
}