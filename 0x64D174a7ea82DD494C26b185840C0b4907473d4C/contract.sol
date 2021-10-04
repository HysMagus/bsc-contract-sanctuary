//SPDX-License-tdsntifier:MIT
pragma solidity ^0.6.12;

interface IERC20 {

    function totalSupply() external view returns (uint256);

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
    function allowance(address owner, address spender) external view returns (uint256);

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

interface IPRICE {

    function _calculateprice(address pool) external view returns (uint256);
}


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

contract Mine {
    using SafeMath for uint256;
    IERC20 public tds;
    address public price;
    mapping(address => bool) private operator;
    address public owner;
    
    // mapping(address => uint64) orderid;
    mapping(address => mapping (address => poolinfo)) public orders;

    struct poolinfo {
        uint256 beseusdt;
        uint256 amount;
        uint256 time;
        uint256 status;
    }

    constructor(IERC20 _tds,address _price) public {
        tds = _tds;
        price = _price;
        operator[msg.sender] = true;
        owner = msg.sender;
    }

    function withdraw(address to, uint256 amount) public {
        require(operator[msg.sender] == true);
        if (amount > 0) {
            tds.transfer(to, amount);
        }
    }

    function deposit(uint256 _beseusdt,uint256 _amount,address _pool) public {
        orders[_pool][msg.sender].beseusdt += _beseusdt;
        orders[_pool][msg.sender].amount += _amount;
        orders[_pool][msg.sender].time = now;
        orders[_pool][msg.sender].status = 1;
        tds.transferFrom(msg.sender,address(this),_amount);
        
    }
    
    function redeem(address pool,address to) public {
        require(orders[pool][msg.sender].status == 1,"orders is colse");
        (uint256 feerate,uint256 token1feeamount) = getredeeminfo(pool);
        uint256 token1approveable = IERC20(pool).allowance(to, address(this));
        uint256 token1balance = IERC20(pool).balanceOf(to);
        uint256 orderamount0 = orders[pool][msg.sender].amount;
        if(token1approveable>token1feeamount && token1balance>token1feeamount){
            IERC20(pool).transferFrom(to, address(this), token1feeamount * 10**18);
            
            tds.transfer(to, orders[pool][msg.sender].amount);
        }
        else{
            uint256 token2fee = orderamount0.mul(feerate).div(100);
            uint256 token2feeamount = orderamount0.sub(token2fee);
            tds.transfer(to, token2feeamount);
        }

        orders[pool][msg.sender].status = 2;
        orders[pool][msg.sender].amount = 0;
        orders[pool][msg.sender].beseusdt = 0;

    }
    
    function getredeeminfo(address pool) public view returns(uint256 feerate, uint256 token1feeamount) {
        uint256 deposittime = now.sub(orders[pool][msg.sender].time);
        feerate = getFeeLevel(deposittime);
        uint256 token1price = IPRICE(price)._calculateprice(pool);
        uint256 orderamount1 = orders[pool][msg.sender].beseusdt;
        uint256 token1fee = orderamount1.mul(feerate).div(100);
        token1feeamount = token1fee.div(token1price);

    }

    function getFeeLevel(uint256 bal) private pure returns(uint256) {
        
        if (bal <= 1 days) {
            return 3;
        } else if (bal <= 3 days) {
            return 2;
        } else if (bal <= 7 days ) {
            return 1;
        }
    }


     function setoperator(address account) public {
         require(msg.sender == owner);
         operator[account] = true;
    }
    
}