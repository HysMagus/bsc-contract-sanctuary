// SPDX-License-Identifier: MIT
//
//
//                     ###############                                
//                 ######################                             
//               ((((((((#@@@@@@@@@#(((((((#                          
//              ((((((%@@@@@@@@@@@@@@@(((((((                         
//             /(((((@@@@@@@@@*..@@@@@@@((((//                        
//            //((((@@@@@@@@@...,..@@@@@@(((((/                       
//            /(((((@@@@@@@@@@,..,@@@@@@@((((((                       
//            /(((((@@@@@@@@@@@@@@@@@@@@@/(((/(                       
//            //((((/@@@@@@@@@@@@@@@@@@@(/(((//                       
//            //(((((((@@@@@@@@@@@@@@@((((((///                       
//            //((((((((((&@@@@@@@%((((((((////                       
//            //////(//(%((((((((((&(//////////                       
//            /////////(/(/&@@@@@#/((//////////                       
//            /////////////////////////////////                       
//            /////*  %///////////////* ,//////                       
//            ////*/   /////*   */////   **////                       
//            ////*.   ////**   */////   **////                       
//                     ////*    ,*///                                 
//
//            H   E   N   K   A   N   .   I   O
//           -----------------------------------
//
// Henkan - The Magic Octopus Game. Up to 100% Chance to Win. 0% House Edge. 3,000.00 BNB Prize Pool. WIN IT ALL!! Live! Instant! Automatic! 
//
// Website:  https://Henkan.io
// Telegram: https://t.me/henkanio
//
//           -----------------------------------


pragma solidity >=0.7.0;

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


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
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
    
    function burn(uint256 amount) external;

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


contract BuyHenkan  {
    using SafeMath for uint256;
    
    uint public constant SALE_START = 1614016800;
    bool public SALE_END = false; 
    uint public hardCap = 5950e18; // 5950 BNB
    uint public maximumDeposit = 50e18; // 50 BNB
    uint public minimumDeposit = 1e18;  //  1 BNB
    
    uint public HNK_1BNB = 5882; // HNK amount per 1 BNB
    
    address public HNKToken = 0xE80Ae7d65db179f6E8A4017021759e564284e1e9; 
    
    address private _owner = msg.sender;
    
    mapping(address => uint) public deposited;
    
    uint public totalDepositedBNB;
    
    event OwnershipTransferred( address indexed previousOwner, address indexed newOwner);
    
    constructor()  {  }
    
    
    modifier onlyOwner() {
        require(isOwner(msg.sender));
        _;
    }

    function isOwner(address account) public view returns(bool) {
        return account == _owner;
    }
    
    function viewOwner() public view returns(address) {
    return _owner;
    }
    
    function transferOwnership(address newOwner) public onlyOwner  {
        
    _transferOwnership(newOwner);
    }

  function _transferOwnership(address newOwner)  internal {
      emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
    
  }
  
  function endSale() public onlyOwner {
      SALE_END = true;
  }


    fallback () external payable {
        depositETH();
    }
    
    function depositETH() public payable {
        _deposit(msg.value, msg.sender);
    }
    
    function _deposit(uint _value, address _sender) internal {
        require(_value > 0, 'Cannot deposit 0');
        require(SALE_START <= block.timestamp, 'Presale not started');
        require(SALE_END != true, 'Presale ended');
        
        uint totalDeposit = deposited[_sender].add(_value);
        uint globalDeposit = totalDepositedBNB.add(_value);
        
        require(totalDeposit >= minimumDeposit, 'Minimum deposit not met');
        require(totalDeposit <= maximumDeposit, 'Maximum deposit exceeded');
        require(globalDeposit <= hardCap, 'Hard Cap Reached');
        
        deposited[_sender] = totalDeposit;
        totalDepositedBNB = globalDeposit;
        payable(_owner).transfer(_value);
        IERC20(HNKToken).transfer(_sender, _value.mul(HNK_1BNB));
    }

    function recoverOtherTokens(address _token, address _to, uint _value) public onlyOwner {
        require(_token != HNKToken, 'UNSOLD_SUPPLY_CAN_ONLY_BURN');
        IERC20(_token).transfer(_to, _value);
    }

    function burnRemaining()  public onlyOwner {
        require(SALE_END == true, 'Presale not ended');
        IERC20(HNKToken).burn(IERC20(HNKToken).balanceOf(address(this)));
    }
    
    
}