pragma solidity >=0.6.6;


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

// SPDX-License-Identifier: MIT
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
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
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
     *
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
     *
     * - Subtraction cannot overflow.
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IDemaxPair {
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
    function totalSupply() external view returns (uint);
    function balanceOf(address) external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address from, address to, uint amount) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address tokenA, address tokenB, address platform, address dgas) external;
    function swapFee(uint amount, address token, address to) external ;
    function queryReward() external view returns (uint rewardAmount, uint blockNumber);
    function mintReward() external returns (uint rewardAmount);
    function getDGASReserve() external view returns (uint);
}

interface IDemaxFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function contractCodeHash() external view returns (bytes32);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function isPair(address pair) external view returns (bool);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function playerPairs(address player, uint index) external view returns (address pair);
    function getPlayerPairCount(address player) external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);
    function addPlayerPair(address player, address _pair) external returns (bool);
}

library DemaxSwapLibrary {
    using SafeMath for uint;

    function getPair(address factory, address tokenA, address tokenB) internal view returns (address pair) {
        return IDemaxFactory(factory).getPair(tokenA, tokenB);
    }

    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'DemaxSwapLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'DemaxSwapLibrary: ZERO_ADDRESS');
    }

     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        bytes32 rawAddress = keccak256(
         abi.encodePacked(
            bytes1(0xff),
            factory,
            salt,
            IDemaxFactory(factory).contractCodeHash()
            )
        );
     return address(bytes20(rawAddress << 96));
    }

    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IDemaxPair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }
    
    function quoteEnhance(address factory, address tokenA, address tokenB, uint amountA) internal view returns(uint amountB) {
        (uint reserveA, uint reserveB) = getReserves(factory, tokenA, tokenB);
        return quote(amountA, reserveA, reserveB);
    }

    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'DemaxSwapLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'DemaxSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = amountIn.mul(reserveOut);
        uint denominator = reserveIn.add(amountIn);
        amountOut = numerator / denominator;
    }
    
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut);
        uint denominator = reserveOut.sub(amountOut);
        amountIn = (numerator / denominator).add(1);
    }

}

contract CrossfinSale {
    using SafeMath for uint;

    event OrderEvent(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == OWNER, 'CROSSFI FARM: ONLY_OWNER');
        _;
    }

    uint256 constant PERCENT_DENOMINATOR = 10000;
    uint256 constant DECIMALS = 10**18;

    struct Order {
        address ref;
        address buyer;
        uint256 amountBuy;          // USDT
        uint256 amountReceived;     // CRP
        uint256 amountRefReceived;  // CRP
        uint256 round;
        uint256 time;
        uint256 block;
    }

    address payable public OWNER;
    address public FACTORY;
    address public CRP;
    address public USDT;
    address public WBNB;
    uint256 public CRP_PRICE = 130000000000000000;  // 0.13 USDT/CRP
    uint256 public CURRENT_ROUND = 2;               // round 2
    mapping(address => uint256) public refLevels;   // address => level
    mapping(uint256 => uint256) public refPercents; // level => percent
    mapping(uint256 => uint256) public refLimits;   // level => amountUSDT
    mapping(address => uint256) public refAmounts;  // address => amountUSDT
    mapping(address => address) public refs;        // user => sponsor
    Order[] public orders;

    constructor (address factory, address crp, address usdt, address wbnb) public {
        OWNER = msg.sender;
        FACTORY = factory;
        CRP = crp;
        USDT = usdt;
        WBNB = wbnb;

        refPercents[0] = 5 * PERCENT_DENOMINATOR;
        refLimits[0] = 10000 * DECIMALS;
        refPercents[1] = 8 * PERCENT_DENOMINATOR;
        refLimits[1] = 50000 * DECIMALS;
        refPercents[2] = 10 * PERCENT_DENOMINATOR;
        refLimits[2] = 99999999999999 * DECIMALS;
    }

    function _convertBNBToUSDT(uint256 amountBNB) internal view returns(uint256 amountUSDT) {
        (uint reserve0, uint reserve1) = DemaxSwapLibrary.getReserves(FACTORY, WBNB, USDT);
        return DemaxSwapLibrary.quote(amountBNB, reserve0, reserve1);
    }

    function _convertUSDTToCRP(uint256 amountUSDT) internal view returns(uint256 amountCRP) {
        return amountUSDT.mul(DECIMALS).div(CRP_PRICE);
    }

    function _payRef(address ref, uint256 amountUSDT) internal returns(uint amountCRPWillReceive){
        if(ref == address(0)) return 0;
        // calc Amount will receive
        uint256 percent = refPercents[refLevels[ref]];
        uint256 amountUSDTWillReceive = amountUSDT.mul(percent).div(100 * PERCENT_DENOMINATOR);
        (amountCRPWillReceive) = _convertUSDTToCRP(amountUSDTWillReceive);
        IERC20(CRP).transfer(ref, amountCRPWillReceive);
        refAmounts[ref] += amountUSDT;
        // check up level
        if(refAmounts[ref] >= refLimits[refLevels[ref]]) {
            refLevels[ref] += 1;
            // pay mission amount
            uint256 missingPercent = refPercents[refLevels[ref]] - refPercents[refLevels[ref] - 1];
            uint256 missingAmountUSDT = refAmounts[ref].mul(missingPercent).div(100 * PERCENT_DENOMINATOR);
            IERC20(CRP).transfer(ref, _convertUSDTToCRP(missingAmountUSDT));
        }
    }

    function buy (address ref) external payable {
        require(msg.value > 0, 'CROSSFIN SALE: AMOUNT BNB MUST GREATER THAN ZERO');

        uint256 amountUSDT = _convertBNBToUSDT(msg.value);
        uint256 amountCRP = _convertUSDTToCRP(amountUSDT);

        IERC20(CRP).transfer(msg.sender, amountCRP);

        // set ref
        if(ref == msg.sender) {
            ref = address(0);
        }

        if(refs[msg.sender] == address(0) && ref != address(0)) {
            refs[msg.sender] = ref;
        }

        uint256 amountRefReceived = _payRef(refs[msg.sender], amountUSDT);

        orders.push(Order(
            refs[msg.sender],
            msg.sender,
            amountUSDT,
            amountCRP,
            amountRefReceived,
            CURRENT_ROUND,
            block.timestamp,
            block.number
        ));

        emit OrderEvent(orders.length - 1);
    }

    // ADMIN FUNCTIONS
    function init(address factory, address crp, address usdt, address wbnb) public onlyOwner {
        FACTORY = factory;
        CRP = crp;
        USDT = usdt;
        WBNB = wbnb;
    }

    function startNewRound(uint256 round, uint256 price) public onlyOwner {
        CURRENT_ROUND = round;
        CRP_PRICE = price;
    }

    function setRefPercent (uint256 level, uint256 percent) public onlyOwner {
        refPercents[level] = percent;
    }

    function setRefLimit (uint256 level, uint256 limit) public onlyOwner {
        refLimits[level] = limit;
    }

    function withdraw (uint256 amount) public onlyOwner {
        OWNER.transfer(amount);
    }
}