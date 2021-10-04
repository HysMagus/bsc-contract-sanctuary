// Dependency file: contracts/libraries/SafeMath.sol

// SPDX-License-Identifier: MIT

// pragma solidity >=0.6.0;

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

// Root file: contracts/SevenUpConfig.sol

pragma solidity >=0.5.16;
// import "contracts/libraries/SafeMath.sol";

contract SevenUpConfig {
    using SafeMath for uint;
    address public factory;
    address public platform;
    address public developer;
    address public mint;
    address public token;
    address public base;
    address public share;
    address public governor;

    uint public lastPriceBlock;
    
    mapping (address => mapping (bytes32 => uint)) public poolParams;
    mapping (bytes32 => uint) public params;
    mapping (bytes32 => address) public wallets;

    event ParameterChange(bytes32 key, uint value);
    event PoolParameterChange(address pool, bytes32 key, uint value);
    
    constructor() public {
        developer = msg.sender;
    }
    
    function initialize (address _platform, address _factory, address _mint, address _token, address _base, address _share, address _governor) external {
        require(msg.sender == developer, "7UP: Config FORBIDDEN");
        mint        = _mint;
        platform    = _platform;
        factory     = _factory;
        token       = _token;
        base        = _base;
        share       = _share;
        governor    = _governor;
    }

    function changeDeveloper(address _developer) external {
        require(msg.sender == developer, "7UP: Config FORBIDDEN");
        developer = _developer;
    }

    function setWallets(bytes32[] calldata _names, address[] calldata _wallets) external {
        require(msg.sender == developer, "7UP: ONLY DEVELOPER");
        require(_names.length == _wallets.length ,"7UP: WALLETS LENGTH MISMATCH");
        for(uint i = 0; i < _names.length; i ++)
        {
            wallets[_names[i]] = _wallets[i];
        }
    }

    function initParameter() external {
        require(msg.sender == developer, "Config FORBIDDEN");
        params[bytes32("platformShare")] = 1e17;
        params[bytes32("buybackShare")] = 5 * 1e17;
        params[bytes32("7upMaxSupply")] = 100000 * 1e18;
        params[bytes32("7upTokenUserMint")] = 5000;
        params[bytes32("7upTokenTeamMint")] = 4000;

        params[bytes32("changePriceDuration")] = 20;
        params[bytes32("changePricePercent")] = 500;

        params[bytes32("depositEnable")] = 1;
        params[bytes32("withdrawEnable")] = 1;
        params[bytes32("borrowEnable")] = 1;
        params[bytes32("repayEnable")] = 1;
        params[bytes32("liquidationEnable")] = 1;
        params[bytes32("reinvestEnable")] = 1;
    }

    function setParameter(bytes32[] calldata _keys, uint[] calldata _values) external
    {
        require(msg.sender == governor, "7UP: ONLY DEVELOPER");
        require(_keys.length == _values.length ,"7UP: PARAMS LENGTH MISMATCH");
        for(uint i = 0; i < _keys.length; i ++)
        {
            params[_keys[i]] = _values[i];
            emit ParameterChange(_keys[i], _values[i]);
        }
    }

    function setPoolPrice(address[] calldata _pools, uint[] calldata _prices) external {
        require(block.number >= lastPriceBlock.add(params[bytes32("changePriceDuration")]), "7UP: Price FORBIDDEN");
        require(msg.sender == wallets[bytes32("price")], "7UP: Config FORBIDDEN");
        require(_pools.length == _prices.length ,"7UP: PRICES LENGTH MISMATCH");

        for(uint i = 0; i < _pools.length; i ++)
        {
            uint currentPrice = poolParams[_pools[i]][bytes32("pledgePrice")];
            if(_prices[i] > currentPrice) {
                uint maxPrice = currentPrice.add(currentPrice.mul(params[bytes32("changePricePercent")]).div(10000));
                poolParams[_pools[i]][bytes32("pledgePrice")] = _prices[i] > maxPrice ? maxPrice: _prices[i];
            } else {
                uint minPrice = currentPrice.sub(currentPrice.mul(params[bytes32("changePricePercent")]).div(10000));
                poolParams[_pools[i]][bytes32("pledgePrice")] = _prices[i] < minPrice ? minPrice: _prices[i];
            }
            emit PoolParameterChange(_pools[i], bytes32("pledgePrice"), _prices[i]);
        }

        lastPriceBlock = block.number;
    }
    
    function setPoolParameter(address _pool, bytes32 _key, uint _value) external {
        require(msg.sender == governor || msg.sender == _pool || msg.sender == platform, "7UP: FORBIDDEN");
        poolParams[_pool][_key] = _value;
        emit PoolParameterChange(_pool, _key, _value);
    }
}