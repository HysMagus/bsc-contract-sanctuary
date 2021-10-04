// pragma solidity  >=0.4.12 < 0.8.0;
pragma solidity  =0.6.6;
pragma experimental ABIEncoderV2;

// SPDX-License-Identifier: MIT;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
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

    event Mint(address indexed sender, uint amount0, uint amount1);
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
interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IDelfyLocker {
    
    struct Auction {
         address _auctionAddress;
         address auctionOwner;
         address LPTokenAddress;
         uint auctionLockPeriod;
         bool withdrawn;
         bool LPTokenburned;
     }
     
    function addAuctionDetails(address dexRouter,address token, address _owner, address _auctionAddr, uint _lockPeriod,bool _burnLP) external;
    function withdrawLpToken(address _token, uint _amount) external;
    function burnDexLPToken (address _token, uint _amountToBurn) external;
    function getLPAmount(address _auctionAddr) external view returns(uint);

}

interface IAuctionFactory{
    function getAuction(address _token) external view returns(address _auction);
    function createAuction( address _dexRouter, uint256 _salesPeriod, address _token, uint256 _rate, uint256 _roi, uint256 _lockPeriod, bool burnLiquidityToken) external returns(address payable newAuction);
    function getAllAuctions() external view returns(address[] memory);
   
}

contract AuctionFactory  is IAuctionFactory {
     using SafeMath for uint;
     address [] private auctions;
     address public  _feesTo;
     IDelfyLocker public constant DelfyLocker = IDelfyLocker(0x1FC54D5B32BFb1f28359d8ac647572811E7C8520);
     mapping(address => address) public override getAuction;
     event AuctionCreated(address auction,address token, address creator);
     address owner;
   
     

     constructor() public {
         _feesTo = msg.sender;
         owner = msg.sender;
     }
     
     function createAuction(address _dexRouter, uint256 _salesPeriod, address _token, 
     uint256 _rate, uint256 _roi,
     uint256 _lockPeriod, bool _burnLiquidityToken) public override returns(address payable newAuction){
        require(getAuction[_token] == address(0), "AUCTION: auction_exist");
        bytes memory bytecode = type(Auction).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(_token, msg.sender));
        assembly {
            newAuction := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
         Auction(newAuction).initialaize( _dexRouter,  msg.sender, _salesPeriod, _token, 
         _rate, _roi,address(DelfyLocker), _burnLiquidityToken, payable(_feesTo));
         getAuction[_token] = newAuction;
         IDelfyLocker(DelfyLocker).addAuctionDetails(_dexRouter,_token, msg.sender, newAuction, _lockPeriod, _burnLiquidityToken);
         auctions.push(newAuction);
         emit AuctionCreated(newAuction,_token, msg.sender);
     }
     
      
     
     function getAllAuctions() external override view returns(address[] memory) {
         return auctions;
     }
     
     function changeFeesTo(address payable _feeTo) external  {
         require(msg.sender == owner, "Factory_not_owner");
         _feesTo =_feeTo;
     }
     
     
     function changeOwner(address _newOwner ) external {
         require(msg.sender == owner, "not_owner");
         owner = _newOwner;
     }
}


contract Mutex {
    bool isLocked;
    modifier noReentrance() {
        require(!isLocked);
        isLocked = true;
        _;
        isLocked = false;
    }
    
}


interface IAuction {
    
     enum CaseType {refundable, releaseLiquidity}
     
      struct Case {
         string reason;
         uint balanceOfToken;
         uint time;
         bool active;
         bool completed;
         bool passed;
         uint upvotes;
         bytes32 id;
         CaseType typeofCase;
     }
     
   
    function initialaize( address _dexRouter, 
        address payable _owner, uint256 _salesPeriod, address _token, uint256 _rate, uint256 _roi, address _lockerAddr,
        bool _burnLiquidityToken, address payable fees_to) external;
    function deposit(uint256 _initialTokenLiquidity, uint256 _amountForSale, uint256 _reserve, uint256 _deflationFactor) external;
    function getTokenBal()external view returns(uint); // shows balanceOf token in the auction
    function whitelistAddresses(address[] calldata _allowdAddresses) external;
    function addProjectInfo(string calldata _logoLink, string calldata _projectURL) external;
    function setMinMax(uint256 _min, uint256 _max) external;
    function buyTokenWithEth()external payable;
    function launchEthTokenExchange(uint256 deadline) external; // anyone can call
    // available to onlyCommunity balanceOf >= 1% of tokenForSale
    function createTypedCase(string calldata _issue, uint8 _caseType) external payable;
    function upvoteCase(uint8 _caseType)external payable; // avavailable tocommunity and balanceOf > 0.1 % of tokenForSale
    function releaseLiquidity(uint deadeadline) external; // avalable to only community
    function withdrawToken() external; // available to onlyOwner, the auction creator
    function getEthBal()external view  returns(uint);
    function viewCases (uint8 _caseType) external view returns(Case[] memory);
    function burnInitialLiquidity () external;
    function refundBuyers() external;
    function token() external view returns(IERC20);
}

contract Auction is IAuction, Mutex {
     using SafeMath for uint;
     
   
     address public locker;
     address payable public owner;
     address public dexWETH; 
     
     address constant deadAddress = 0x000000000000000000000000000000000000dEaD;
     address private factory;
     address payable feesTo;
    //  address public WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab; // ropsten WETH
     
     
     IUniswapV2Router02 public dexRouter; 
     IUniswapV2Factory public dexFactory;
     IERC20 public override token;
     IUniswapV2Pair public tokenPair;
     
     uint256 public amountRaised; // amout raised in wei
     uint256 public hardCap; // total amount to be raised
     uint256 public minimumPurchaseEth; // minimum purchase allowed
     uint256 public maximumPurchaseEth; // max purchase per wallet
     uint256 public rate; // amount of token per ether
     uint256 public initialLiquidity; //amount of token to initialize trade on exchange listing
     uint256 public availableTokenForSale; //amount of tokens to be sold
     uint256 public reserve; // amount of tokens for liquidity should dev attempt to scam, reserve is equal to availableTokenForSale
     uint256 public roi; // percentage roi on exchange listing
     uint256 public exchangeAllocEth; // exchange allocation in ether
     
     uint256 private availableEthToBeWithdrawn; // available eth to be withdrawn 
     uint256 public amountToken; // total amount of tokens deposited
   
    
     uint256 exchangeLaunchedTime;
     uint256 private salesPeriod;    // sales window
     uint256 public salesCompletedTime; // the time the sales was completed
     uint256 public firstRelease;
     uint256 public secondRelease;
     uint256 public thirdRelease;
     uint256 public contributorsCount;
     uint256 public openTill;
     uint256 private deflationFactor;
     
    uint256 amountForSale;

     string public logoLink;
     string public projectURL;
     
     bool public salesStarted;
     bool public salesCompleted; 
     bool public exchangeLaunched; 
     bool public canCreateCase;
     bool public caseCreated;
     bool public auctionClosed;
     bool public burnLiquidityToken;
     bool private whitelistAuction;
     
     bool public isFirstReleased;
     bool public isSecondReleased;
     bool public isThirdReleased;
     bool refundableCaseCreated;
     bool canCreateRefundableCase;
     
     mapping(address => bool) public isContributor;
     mapping(address => uint256) public amountContributed;
     mapping(address=> uint256) public userBalance;
     mapping(address=>uint) public refundClaimed;
     
     mapping(address => uint256) private amountOfTokenBought;
     mapping(address => bool) private isWhitelisted;
     mapping(address => mapping(bytes32 => bool)) private voted;

    
    event Deposited(address _from, address _to, uint _amount);
    event WhiteListed(address[] _whiteListedAddresses);
    event Bought(address _buyer, uint amount);
    event LockerCreated(address _locker);
    event SendToDex(address _sender, uint ethValue, uint tokenValue);
    event Transfer(address _from, address _to, uint _amount);
     
    Case[] private refundableCases;
    Case[] private cases;
    Case[] private passedCases;
     
    uint256 public createCaseFee;
    uint256 public supportCaseFee;
    uint256 public supportRefundCaseFees;
    uint256 public createReFundCaseFees;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "AUCTION: not_owner");
        _;
    }
    
    modifier onlyCommunity () {
              require(msg.sender == owner || isContributor[msg.sender], "AUCTION: not_investor");
        _;
    }
    
    receive()payable external{
       
    }
  
    constructor() public{
        factory = msg.sender;
    }
    
    function initialaize( address _dexRouter, 
        address payable _owner, uint256 _salesPeriod, address _token, uint256 _rate, uint256 _roi, address _lockerAddr,
         bool _burnLiquidityToken, address payable fees_to) external override {
        assert(msg.sender == factory);
        require(_owner != address(0) && _token != address(0) && _dexRouter != address(0)
       && _rate > 0 && _roi <=60,
        "AUCTION: invalid_parameters");
        dexRouter =IUniswapV2Router02(_dexRouter);
        dexFactory = IUniswapV2Factory(dexRouter.factory());
        dexWETH = dexRouter.WETH();
        owner =_owner;
        token = IERC20(_token);
        salesPeriod =_salesPeriod;
        rate = _rate;
        roi = _roi;
        locker = _lockerAddr;
        burnLiquidityToken = _burnLiquidityToken;
        feesTo = fees_to;
        
    }
    
    function getEthBal()external view override returns(uint){
        return address(this).balance;
    }
    
    function getTokenBal()external override view returns(uint) {
      return token.balanceOf(address(this));
    }
  
    
    
     function addProjectInfo(string calldata _logoLink, string calldata _projectURL) external override onlyOwner{
         logoLink = _logoLink;
         projectURL =_projectURL;
     }
     
    
    function whitelistAddresses(address[] calldata _allowdAddresses) external override onlyOwner{
        assert(_allowdAddresses.length>0);
        for(uint index = 0; index < _allowdAddresses.length; index++){
            isWhitelisted[_allowdAddresses[index]] = true;
        }
        whitelistAuction = true;
        emit WhiteListed(_allowdAddresses);
    }
    
    function setMinMax(uint256 _min, uint256 _max) external override onlyOwner {
        require(!salesStarted, "AUCTION: sales_is_on");
        minimumPurchaseEth = _min;
        maximumPurchaseEth = _max;
    }
  
    
    function deposit(uint256 _initialTokenLiquidity, uint256 _amountForSale, uint256 _reserve, uint256 _deflationFactor) external override {
        require(_initialTokenLiquidity >= _calculatePecentage(_amountForSale, 30), "initialLiquidity must >= 30% of availableTokenForSale"); // initial liquidity must be greater than 30% of amount to be sold
        require(!salesStarted, "AUCTION: sales_is_on");
        
        initialLiquidity = _initialTokenLiquidity.sub(_calculatePecentage(_initialTokenLiquidity, _deflationFactor));
        availableTokenForSale=_amountForSale.sub(_calculatePecentage(_amountForSale,_deflationFactor));
        amountForSale = _amountForSale.sub(_calculatePecentage(_amountForSale, _deflationFactor));
        reserve = _reserve.sub(_calculatePecentage(_reserve, _deflationFactor));
        deflationFactor = _deflationFactor;
        uint256 _total = _initialTokenLiquidity.add(_amountForSale).add(_reserve);
        uint256 subAmount = _calculatePecentage(_total, _deflationFactor);
        amountToken = _total.sub(subAmount);
        address _token = address(token);
        
        TransferHelper.safeTransferFrom(_token, msg.sender, address(this),  _total);
        hardCap = amountForSale.div(rate.div(1 ether));
        
        // sales starts after successful deposit and open period starts counting
        openTill = block.timestamp.add(salesPeriod);
        salesStarted =true;
        _approve(); // pre-approve dexRouter to spend total balance of token deposited
        emit Deposited(msg.sender, address(this), amountToken);
        getFeesValueFromUniswap();
    }
   
//    set fees to $5, $3, $8, and  $4 for case creation 
    function getFeesValueFromUniswap()internal{
       
        
        (uint reserveWeth,uint reserveBUSD) = UniswapV2Library
        .getReserves(0xBCfCcbde45cE874adCB698cC183deBcF17952812, 
        0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c, 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        uint one_dollar_ether = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F).quote(1e18, reserveBUSD, reserveWeth);
         createCaseFee = one_dollar_ether.mul(5);
        supportCaseFee = one_dollar_ether.mul(3);
        createReFundCaseFees =one_dollar_ether.mul(8);
        supportRefundCaseFees =one_dollar_ether.mul(4);
    }
   
    function buyTokenWithEth() external override payable noReentrance{
        require(salesStarted && !salesCompleted, "AUCTION: auction_closed");
   
        
        if(whitelistAuction){
            require(isWhitelisted[msg.sender] == true, "AUCTION: only_whitelisted_address");
        }
        
        // require(!salesCompleted, "AUCTION:: Auction is Completed");
        if(minimumPurchaseEth > 0 && maximumPurchaseEth > 0) {
            require(msg.value >= minimumPurchaseEth && msg.value <= maximumPurchaseEth, "AUCTION: value_out_of_range");
            // require(msg.value <= maximumPurchaseEth, "AUCTION: Greater_than_max_purchase_allowed");
            require(amountContributed[msg.sender] < maximumPurchaseEth, "AUCTION:: You_have_reached_your_allowed_cap");
        }
        
        uint tokenAmount = _getTokenAmount(msg.value);
        require(tokenAmount <= availableTokenForSale, "AUCTION: more_than_available_token_for_sale");
        uint256 bal = address(this).balance;
        bal = address(this).balance.add(msg.value);
        TransferHelper.safeTransfer(address(token), msg.sender, tokenAmount);
        amountRaised= amountRaised.add(msg.value);
        availableTokenForSale = availableTokenForSale.sub(tokenAmount);
        amountContributed[msg.sender] = msg.value;
        userBalance[msg.sender]=userBalance[msg.sender].add(msg.value);
        amountOfTokenBought[msg.sender] = tokenAmount;
        if(!isContributor[msg.sender]){
            contributorsCount +=1;
        }
        isContributor[msg.sender] = true;
        availableEthBalance = address(this).balance;
        closeSales();
        emit Bought(msg.sender, tokenAmount);
    }
    
    
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(rate).div(1e18);
    }
    

    function _approve() internal {
        TransferHelper.safeApprove(address(token), address(dexRouter), token.balanceOf(address(this)));
    }
   
    function _calculatePecentage(uint256 value, uint256 percentage) internal pure returns (uint256) {
        return value.mul(percentage).div(100);
    }
    
    function _calcDexEthAllocationWithInitialROI() internal view returns(uint){
        uint _factor = _calculatePecentage(initialLiquidity.div(rate.div(1e18)), roi);
        return initialLiquidity.div(rate.div(1e18)).add(_factor);
    }


    
    
    
    function launchEthTokenExchange(uint256 deadline) external override onlyCommunity {
        closeSales(); // close sale if aavailableTokenForSale is > 0 or minimum sellable
        require(salesCompleted == true, 'AUCTION: sales is on');
        require(!exchangeLaunched, "AUCTION: Exchange_launched");
        uint256 _amountInEth = _calcDexEthAllocationWithInitialROI();
        uint256 balanz = address(this).balance;
        uint fees = balanz.mul(56).div(10000);
        TransferHelper.safeTransferETH(feesTo, fees);
        emit Transfer(address(this), feesTo, fees);
        uint newBalanz = balanz.sub(fees);
        if(newBalanz < _amountInEth){
            uint _amntToken = _getTokenAmount(address(this).balance)> token.balanceOf(address(this))?
            _getTokenAmount(address(this).balance).div(2):_getTokenAmount(address(this).balance); /*modified*/

            if(burnLiquidityToken == true){
                
                dexRouter.addLiquidityETH { value: newBalanz } (address(token),
                _amntToken,
                0,
                0,
                deadAddress,
                deadline);
            }else {
                dexRouter.addLiquidityETH { value: newBalanz } (address(token),
                 _amntToken,
                0,
               0,
                locker,
                deadline);
            }
                emit SendToDex(msg.sender, newBalanz, _amntToken);
        }else {
            
            if(burnLiquidityToken == true){
                dexRouter.addLiquidityETH { value: _amountInEth }(address(token),
                initialLiquidity,
                0,
               0,
                deadAddress,
                deadline);
            } else {
                dexRouter.addLiquidityETH { value: _amountInEth }(address(token),
                initialLiquidity,
                0,
                0,
                locker,
                deadline);
                
            }
             emit SendToDex(msg.sender, _amountInEth, initialLiquidity);
                
        }
        exchangeLaunched=true;
        initialLiquidity = 0;
        tokenPair = IUniswapV2Pair(dexFactory.getPair(dexWETH, address(token)));
        
         availableEthBalance = address(this).balance;
          // readjust reserve after exchange launch
        reserve = token.balanceOf(address(this));
        exchangeLaunchedTime = block.timestamp;
        firstRelease = block.timestamp.add(72 hours);
        secondRelease = firstRelease.add(48 hours);
        thirdRelease = secondRelease.add(48 hours);
    }
    
    function closeSales() internal returns(bool){
        uint minimumSellable;
        if(minimumPurchaseEth > 0)
            minimumSellable = _getTokenAmount(minimumPurchaseEth);
        if(availableTokenForSale < minimumSellable|| availableTokenForSale ==0 ||  block.timestamp > openTill) {
            salesCompleted = true;
            salesCompletedTime = block.timestamp;
           
        }
        
        return salesCompleted;
    }
    
   
    function changeCaseState () internal { // reset case state
        if(cases.length>0)
        cases[cases.length-1].active =false;
        if(refundableCases.length >0)
        refundableCases[refundableCases.length-1].active =false;
        
        canCreateCase = true;
        caseCreated=false;
        canCreateRefundableCase =true;
        refundableCaseCreated=false;
    }

  function _startCase() internal{
        require(block.timestamp >=  exchangeLaunchedTime.add(24 hours), "AUCTION: can_not_create_case");
        if(block.timestamp >=  exchangeLaunchedTime.add(24 hours) && cases.length==0){
            changeCaseState();
        }else if(block.timestamp >=  firstRelease && cases.length<=1){
            changeCaseState();
        }
        else if(block.timestamp >=  secondRelease && cases.length<=2){
            changeCaseState();
        }
    }
   
  
     
    uint availableEthBalance;
    uint caseFunds;
   
    // @dev Only one case can be created per session
    // @dev others will have to upvote to show their interest to prevent token developer from withdrawing the raised funds 
    // @dev  about $5 (0.00789 ether) is required to create case for sanity sake.
   function createTypedCase (string calldata _issue, uint8 _caseType) external override payable noReentrance onlyCommunity{
       _startCase();
       require(!checkStopRelease(), "AUCTION: auction_progress_ended");
        require(token.balanceOf(msg.sender) > _calculatePecentage(amountForSale, 1), "AUCTION: Only_real_investors");
        require(block.timestamp < thirdRelease, "AUCTION: case_creation_window_closed");
        Case memory _case = Case({
                reason: _issue,
                balanceOfToken: token.balanceOf(msg.sender),
                active: true,
                completed: false,
                time: block.timestamp,
                passed: false,
                typeofCase: CaseType(_caseType),
                upvotes: 0,
                id: keccak256(abi.encodePacked(msg.sender,block.timestamp,block.difficulty))
                // id: ripemd160(abi.encodePacked(msg.sender,block.timestamp,block.difficulty))
            });
        if(CaseType(_caseType)==CaseType.refundable){
            require(msg.value >= createReFundCaseFees, "AUCTION: You_have_to_donate");
            require(canCreateRefundableCase, "AUCTION: Case_already_created");
            refundableCases.push( _case);
            refundableCaseCreated =true;
            canCreateRefundableCase = false;
        }
        else if (CaseType(_caseType)==CaseType.releaseLiquidity){
            require(canCreateCase, "AUCTION: Case_already_created");    
            require(msg.value >= createCaseFee, "AUCTION: You_have_to_donate");
            cases.push(_case);
            caseCreated =true;
            canCreateCase = false;
        }
        amountContributed[msg.sender] = amountContributed[msg.sender].add(msg.value);
        userBalance[msg.sender]= userBalance[msg.sender].add(msg.value);
        caseFunds = caseFunds.add(msg.value);
        availableEthBalance = address(this).balance;

   }
   
   
    function viewCases (uint8 _caseType) external view override returns(Case[] memory) {
        if(CaseType(_caseType)==CaseType.refundable&& refundableCases.length>0)
            return refundableCases;
        if(CaseType(_caseType)==CaseType.releaseLiquidity&& cases.length>0)
            return cases;
    }
    
     
    // @dev about $2 (0.004 ether) is required to upvote a Case for sanity sake 
    function upvoteCase(uint8 _caseType)external override payable noReentrance {
        require(token.balanceOf(msg.sender) > amountForSale.mul(1).div(1000), "AUCTION: Only_real_investors ");
        if(CaseType(_caseType) == CaseType.releaseLiquidity&&cases.length>0){
            require(msg.value >= supportCaseFee, "AUCTION: You_have_to_donate");
            
            require(cases[cases.length-1].active == true,"AUCTION: case_is_not_active");
            require(!voted[msg.sender][cases[cases.length-1].id], "AUCTION: Voted");
           
            voted[msg.sender][cases[cases.length-1].id]=true;
            cases[cases.length-1].upvotes += 1;
        }else if(CaseType(_caseType) == CaseType.refundable && refundableCases.length>0){
            require(msg.value >= supportRefundCaseFees, "AUCTION: You_have_to_donate");
            require(refundableCases[refundableCases.length-1].active == true,"AUCTION: case_is_not_active");
            require(!voted[msg.sender][refundableCases[refundableCases.length-1].id], "AUCTION: Voted");
           
            voted[msg.sender][refundableCases[refundableCases.length-1].id]=true;
            refundableCases[refundableCases.length-1].upvotes += 1;
            
        }
        amountContributed[msg.sender] = amountContributed[msg.sender].add(msg.value);
        userBalance[msg.sender]= userBalance[msg.sender].add(msg.value);
        caseFunds = caseFunds.add(msg.value);
        availableEthBalance = address(this).balance;
    }
    
    function checkStopRelease() private view returns(bool) {
          uint acceptableRUpvotes = _calculatePecentage(contributorsCount, 55); 
          if(refundableCases.length>0)
          return refundableCases[refundableCases.length-1].upvotes>acceptableRUpvotes;
    }
    
    
    function calcWithdrawableEth() private {
      
       if(block.timestamp > firstRelease && !isFirstReleased && block.timestamp < secondRelease){
            availableEthToBeWithdrawn = availableEthToBeWithdrawn.add(address(this).balance.div(5));
            isFirstReleased =true;
        }else if(block.timestamp > secondRelease && !isSecondReleased && block.timestamp < thirdRelease) {
            availableEthToBeWithdrawn = availableEthToBeWithdrawn.add(address(this).balance.div(2)); 
            isSecondReleased = true;
        }
        else if(block.timestamp > thirdRelease && !isThirdReleased){
            availableEthToBeWithdrawn = availableEthToBeWithdrawn.add(address(this).balance);
            isThirdReleased = true;
        } 
      
    }
    
    
    // if case passes against the developer the liquidity token is sent to address(0) or the swap token is sent to locker where it'd locked forever
    function releaseLiquidity(uint deadline) external override noReentrance onlyCommunity{
        _startCase();
        calcWithdrawableEth();
        require(!checkStopRelease(), "Auction_release_stoped");
        require(availableEthToBeWithdrawn > 0, "AUCTION: insuffient_ether");
        uint acceptableUpvotes = _calculatePecentage(contributorsCount, 40); 
      
        (uint reserveWeth,uint reserveToken) = UniswapV2Library.getReserves(address(dexFactory), dexWETH, address(token));
        
        uint _tokenAmount = dexRouter.quote(availableEthToBeWithdrawn, reserveWeth, reserveToken);
        

        if(cases.length> 0 && cases[cases.length-1].upvotes > acceptableUpvotes && cases[cases.length-1].completed == false){
            
            cases[cases.length-1].passed = true;
            cases[cases.length-1].completed =true;
            passedCases.push(cases[cases.length-1]);
            
            address[] memory path = new address[](2);
            path[0] = dexWETH;
            path[1] = address(token);
            
            
            
            if(token.balanceOf(address(this))< _tokenAmount){
                if(deflationFactor > 0) {
                   
                    dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: availableEthToBeWithdrawn}(0, 
                    path, deadAddress, deadline);
                } else {
                    dexRouter.swapExactETHForTokens{value: availableEthToBeWithdrawn}(0, path, deadAddress, deadline);
                    
                }

            }else {
                dexRouter.addLiquidityETH{value: availableEthToBeWithdrawn}(address(token),
                _tokenAmount,
                0,
                 _calculatePecentage(availableEthToBeWithdrawn, 40), /*allow upto 60% slippage*/
                deadAddress, deadline);
            }
                emit SendToDex(msg.sender, availableEthToBeWithdrawn, _tokenAmount);
        }
        else {
            if(cases.length >0)
            cases[cases.length-1].completed =true;
            TransferHelper.safeTransferETH(owner, availableEthToBeWithdrawn);
            emit Transfer(address(this), owner, availableEthToBeWithdrawn);       
            
        }
        
         availableEthBalance = address(this).balance;
         availableEthToBeWithdrawn = 0;

    }
    
   
    
    // Give community opportunity to burn lpToken if there 2 cases passed against the dev or the third release is sent to dex
    function burnInitialLiquidity () external override{
        require(passedCases.length >= 2||checkIfCaseRelease3Passed(), "AUCTION: require_2_passedCases_or_3rd_case");
        require(token.balanceOf(msg.sender) > _calculatePecentage(amountForSale,1), "AUCTION: Only_real_investors");
        uint amountToBurn = tokenPair.balanceOf(locker);
        IDelfyLocker(locker).burnDexLPToken(address(token), amountToBurn);
        burnLiquidityToken =true;
    }
    
    function checkIfCaseRelease3Passed() private view returns(bool) {
        if(cases[cases.length-1].time>secondRelease)
        return cases[cases.length-1].upvotes>_calculatePecentage(contributorsCount, 40);
    }
    
      
    function getClaimable(address _addr) public view returns(uint){
        uint _amnt = amountRaised.add(caseFunds);
      return availableEthBalance.mul(userBalance[_addr]).div(_amnt);
    }
    
    
    function bailout() private view returns(bool){
        return block.timestamp> salesCompletedTime.add(8 days) &&address(this).balance>0;
    }
    
    //A bail out system if the token contract is not tradeable on exchange contributors can get refunded by calling the refundBuyers function
    // there must be a not completed case that passed
    function refundBuyers() external override noReentrance {
       
        require(block.timestamp > salesCompletedTime.add(8 days) && !isThirdReleased, "AUCTION: not_released" );
        require(checkStopRelease()||bailout(), "AUCTION: only_refundable_case");
        require(userBalance[msg.sender]>0, "Only_real_investors");
        
         
        
            require(getClaimable(msg.sender)>0,"zero_value");
            TransferHelper.safeTransferETH(msg.sender, getClaimable(msg.sender));
            refundClaimed[msg.sender]=getClaimable(msg.sender);
            emit Transfer(address(this), msg.sender, getClaimable(msg.sender)); 
            userBalance[msg.sender]=0;
        
    }
    
    // if there is no case @dev can withdraw the excess tokens 
    function withdrawToken() external override onlyOwner noReentrance{
        require(token.balanceOf(address(this))> 0, "AUCTION: zero_balance");
        require(block.timestamp > salesCompletedTime.add(8 days), "AUCTION: not_released" );
        
        TransferHelper.safeTransfer(address(token), owner, token.balanceOf(address(this)));
        auctionClosed = true;
        emit Transfer(address(this), owner, token.balanceOf(address(this)));   
    }
    
  
}



library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}


// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}