// File: contracts\@openzeppelin\contracts\math\SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: contracts\@openzeppelin\contracts\token\ERC20\IERC20.sol
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
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

// File: contracts\@openzeppelin\contracts\utils\Address.sol

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
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

// File: contracts\@openzeppelin\contracts\token\ERC20\SafeERC20.sol

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts\@openzeppelin\contracts\utils\EnumerableSet.sol

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// File: contracts\@openzeppelin\contracts\GSN\Context.sol

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
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

// File: contracts\@openzeppelin\contracts\access\Ownable.sol

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
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

// File: contracts\@libs\Authorizable.sol

contract Authorizable is Ownable {

    mapping(address => bool) public authorized;

    modifier onlyAuthorized() {
        require(authorized[msg.sender] || owner() == msg.sender);
        _;
    }

    function addAuthorized(address _toAdd) onlyOwner public {
        authorized[_toAdd] = true;
    }

    function removeAuthorized(address _toRemove) onlyOwner public {
        require(_toRemove != msg.sender);
        authorized[_toRemove] = false;
    }

}

// File: contracts\@interface\IFlaskERC20.sol

interface IFlaskERC20 is IERC20 {
    function cap() external view returns (uint256);
    function mint(address _to, uint256 _amount) external;
    function lock(address _holder, uint256 _amount) external;
}

// File: contracts\@interface\IMigratorToflaskSwap.sol

interface IMigratorToFlaskSwap {
    // Perform LP token migration from legacy UniswapV2 to FlaskSwap.
    // Take the current LP token address and return the new LP token address.
    // Migrator should have full access to the caller's LP token.
    // Return the new LP token address.
    //
    // XXX Migrator must have allowance access to UniswapV2 LP tokens.
    // FlaskSwap must mint EXACTLY the same amount of FlaskSwap LP tokens or
    // else something bad will happen. Traditional UniswapV2 does not
    // do that so be careful!
    function migrate(IERC20 token) external returns (IERC20);
}


// FlaskMasterFarmer is the master of flask. He can make flask and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once flask is sufficiently
// distributed and the community can show to govern itself.
//
contract FlaskMasterFarmer is Ownable, Authorizable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        uint256 rewardDebtAtBlock; // the last block user stake
		uint256 lastWithdrawBlock; // the last block a user withdrew at.
		uint256 firstDepositBlock; // the last block a user deposited at.
		uint256 blockdelta; //time passed since withdrawals
		uint256 lastDepositBlock;
        //
        // We do some fancy math here. Basically, any point in time, the amount of flasks
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accflaskPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accflaskPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    
    struct UserGlobalInfo {
        uint256 globalAmount;
        mapping(address => uint256) referrals;
        uint256 totalReferals;
        uint256 globalRefAmount;
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. flasks to distribute per block.
        uint256 lastRewardBlock;  // Last block number that flasks distribution occurs.
        uint256 accflaskPerShare; // Accumulated flasks per share, times 1e12. See below.
        uint256 rewardPerBlock;   //reward Per Block
    }

    // The TOKEN!
    IFlaskERC20 public flask;
    //An ETH/USDC Oracle (Chainlink)
    address public usdOracle;
    // Dev address.
    address public devaddr;
	// LP address
	address public liquidityaddr;
	// Community Fund Address
	address public comfundaddr;
	// Founder Reward
	address public founderaddr; 
    // Bonus muliplier for early flask makers.
    uint256[] public REWARD_MULTIPLIER =[4096, 2048, 2048, 1024, 1024, 512, 512, 256, 256, 256, 256, 256, 256, 256, 256, 128, 128, 128, 128, 128, 128, 128, 128, 128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 16, 8, 8, 8, 8, 32, 32, 64, 64, 64, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 256, 256, 256, 128, 128, 128, 128, 128, 128, 128, 128, 128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 16, 16, 16, 16, 8, 8, 8, 4, 2, 1, 0];
    uint256[] public HALVING_AT_BLOCK; // init in constructor function
    uint256[] public blockDeltaStartStage;
    uint256[] public blockDeltaEndStage;
    uint256[] public userFeeStage;
    uint256[] public devFeeStage;
    uint256 public FINISH_BONUS_AT_BLOCK;
    uint256 public userDepFee;
    uint256 public devDepFee;

    // The block number when flask mining starts.
    uint256 public START_BLOCK;

    uint256 public PERCENT_LOCK_BONUS_REWARD; // lock xx% of bounus reward in 3 year
    uint256 public PERCENT_FOR_DEV; // dev bounties + partnerships
	uint256 public PERCENT_FOR_LP; // LP fund
	uint256 public PERCENT_FOR_COM; // community fund
	uint256 public PERCENT_FOR_FOUNDERS; // founders fund

    // The migrator contract. It has a lot of power. Can only be set through governance (owner).
    IMigratorToFlaskSwap public migrator;

    // Info of each pool.
    PoolInfo[] public poolInfo;
    mapping(address => uint256) public poolId1; // poolId1 count from 1, subtraction 1 before using with poolInfo
    // Info of each user that stakes LP tokens. pid => user address => info
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    mapping (address => UserGlobalInfo) public userGlobalInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event SendflaskReward(address indexed user, uint256 indexed pid, uint256 amount, uint256 lockAmount);

    constructor(
        address _token,
        address _devaddr,
		address _liquidityaddr,
		address _comfundaddr,
		address _founderaddr, 
        uint256 _startBlock,
        uint256 _halvingAfterBlock,
        uint256 _userDepFee,
        uint256 _devDepFee,
        uint256[] memory _blockDeltaStartStage,
        uint256[] memory _blockDeltaEndStage,
        uint256[] memory _userFeeStage,
        uint256[] memory _devFeeStage
    ) public {
        flask = IFlaskERC20(_token);
        devaddr = _devaddr;
		liquidityaddr = _liquidityaddr;
		comfundaddr = _comfundaddr;
		founderaddr = _founderaddr; 
        START_BLOCK = _startBlock;
	    userDepFee = _userDepFee;
	    devDepFee = _devDepFee;
	    blockDeltaStartStage = _blockDeltaStartStage;
	    blockDeltaEndStage = _blockDeltaEndStage;
	    userFeeStage = _userFeeStage;
	    devFeeStage = _devFeeStage;
        for (uint256 i = 0; i < REWARD_MULTIPLIER.length - 1; i++) {
            uint256 halvingAtBlock = _halvingAfterBlock.add(i + 1).add(_startBlock);
            HALVING_AT_BLOCK.push(halvingAtBlock);
        }
        FINISH_BONUS_AT_BLOCK = _halvingAfterBlock.mul(REWARD_MULTIPLIER.length - 1).add(_startBlock);
        HALVING_AT_BLOCK.push(uint256(-1));
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    

    

    // Add a new lp to the pool. Can only be called by the owner.
    function add(uint256 _allocPoint,uint56 _blockRward, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
        require(poolId1[address(_lpToken)] == 0, "FlaskMasterFarmer::add: lp is already in pool");
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolId1[address(_lpToken)] = poolInfo.length + 1;
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: _allocPoint,
            lastRewardBlock: lastRewardBlock,
            accflaskPerShare: 0,
            rewardPerBlock:_blockRward
        }));
    }

    // Update the given pool's flask allocation point. Can only be called by the owner.
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // Set the migrator contract. Can only be called by the owner.
    function setMigrator(IMigratorToFlaskSwap _migrator) public onlyOwner {
        migrator = _migrator;
    }

    // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
    function migrate(uint256 _pid) public {
        require(address(migrator) != address(0), "migrate: no migrator");
        PoolInfo storage pool = poolInfo[_pid];
        IERC20 lpToken = pool.lpToken;
        uint256 bal = lpToken.balanceOf(address(this));
        lpToken.safeApprove(address(migrator), bal);
        IERC20 newLpToken = migrator.migrate(lpToken);
        require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
        pool.lpToken = newLpToken;
    }

    // Update reward variables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 flaskForDev;
        uint256 flaskForFarmer;
		uint256 flaskForLP;
		uint256 flaskForCom;
		uint256 flaskForFounders;
        (flaskForDev, flaskForFarmer, flaskForLP, flaskForCom, flaskForFounders) = getPoolReward(_pid,pool.lastRewardBlock, block.number, pool.allocPoint);
        flask.mint(address(this), flaskForFarmer);
        pool.accflaskPerShare = pool.accflaskPerShare.add(flaskForFarmer.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
        if (flaskForDev > 0) {
            flask.mint(address(devaddr), flaskForDev);
            //Dev fund has xx% locked during the starting bonus period. After which locked funds drip out linearly each block over 3 years.
            if (block.number <= FINISH_BONUS_AT_BLOCK) {
                flask.lock(address(devaddr), flaskForDev.mul(75).div(100));
            }
        }
		if (flaskForLP > 0) {
            flask.mint(liquidityaddr, flaskForLP);
			//LP + Partnership fund has only xx% locked over time as most of it is needed early on for incentives and listings. The locked amount will drip out linearly each block after the bonus period.
			if (block.number <= FINISH_BONUS_AT_BLOCK) {
                flask.lock(address(liquidityaddr), flaskForLP.mul(45).div(100));
            }
        }
		if (flaskForCom > 0) {
            flask.mint(comfundaddr, flaskForCom);
			//Community Fund has xx% locked during bonus period and then drips out linearly over 3 years.
            if (block.number <= FINISH_BONUS_AT_BLOCK) {
                flask.lock(address(comfundaddr), flaskForCom.mul(85).div(100));
            }
        }
		if (flaskForFounders > 0) {
            flask.mint(founderaddr, flaskForFounders);
			//The Founders reward has xx% of their funds locked during the bonus period which then drip out linearly per block over 3 years.
			if (block.number <= FINISH_BONUS_AT_BLOCK) {
                flask.lock(address(founderaddr), flaskForFounders.mul(95).div(100));
            }
        }
        
    }

    // |--------------------------------------|
    // [20, 30, 40, 50, 60, 70, 80, 99999999]
    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        uint256 result = 0;
        if (_from < START_BLOCK) return 0;

        for (uint256 i = 0; i < HALVING_AT_BLOCK.length; i++) {
            uint256 endBlock = HALVING_AT_BLOCK[i];

            if (_to <= endBlock) {
                uint256 m = _to.sub(_from).mul(REWARD_MULTIPLIER[i]);
                return result.add(m);
            }

            if (_from < endBlock) {
                uint256 m = endBlock.sub(_from).mul(REWARD_MULTIPLIER[i]);
                _from = endBlock;
                result = result.add(m);
            }
        }

        return result;
    }

    function getPoolReward(uint256 _pid,uint256 _from, uint256 _to, uint256 _allocPoint) 
    public view returns (uint256 forDev, uint256 forFarmer, uint256 forLP, uint256 forCom, uint256 forFounders) {
        uint256 multiplier = getMultiplier(_from, _to);
        uint256 blockReward = poolInfo[_pid].rewardPerBlock;
        uint256 amount = multiplier.mul(blockReward).mul(_allocPoint).div(totalAllocPoint);
        uint256 flaskCanMint = flask.cap().sub(flask.totalSupply());

        if (flaskCanMint < amount) {
            forDev = 0;
			forFarmer = flaskCanMint;
			forLP = 0;
			forCom = 0;
			forFounders = 0;
        }
        else {
            forDev = amount.mul(PERCENT_FOR_DEV).div(100);
			forFarmer = amount;
			forLP = amount.mul(PERCENT_FOR_LP).div(100);
			forCom = amount.mul(PERCENT_FOR_COM).div(100);
			forFounders = amount.mul(PERCENT_FOR_FOUNDERS).div(100);
        }
    }

    // View function to see pending flasks on frontend.
    function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accflaskPerShare = pool.accflaskPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply > 0) {
            uint256 flaskForFarmer;
            (, flaskForFarmer, , ,) = getPoolReward(_pid,pool.lastRewardBlock, block.number, pool.allocPoint);
            accflaskPerShare = accflaskPerShare.add(flaskForFarmer.mul(1e12).div(lpSupply));

        }
        return user.amount.mul(accflaskPerShare).div(1e12).sub(user.rewardDebt);
    }

    function claimReward(uint256 _pid) public {
        updatePool(_pid);
        _harvest(_pid);
    }

    // lock 95% of reward if it come from bounus time
    function _harvest(uint256 _pid) internal {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accflaskPerShare).div(1e12).sub(user.rewardDebt);
            uint256 masterBal = flask.balanceOf(address(this));

            if (pending > masterBal) {
                pending = masterBal;
            }
            
            if(pending > 0) {
                flask.transfer(msg.sender, pending);
                uint256 lockAmount = 0;
                if (user.rewardDebtAtBlock <= FINISH_BONUS_AT_BLOCK) {
                    lockAmount = pending.mul(PERCENT_LOCK_BONUS_REWARD).div(100);
                    flask.lock(msg.sender, lockAmount);
                }

                user.rewardDebtAtBlock = block.number;

                emit SendflaskReward(msg.sender, _pid, pending, lockAmount);
            }

            user.rewardDebt = user.amount.mul(pool.accflaskPerShare).div(1e12);
        }
    }


    function getGlobalAmount(address _user) public view returns(uint256) {
        UserGlobalInfo memory current = userGlobalInfo[_user];
        return current.globalAmount;
    }
    
     function getGlobalRefAmount(address _user) public view returns(uint256) {
        UserGlobalInfo memory current = userGlobalInfo[_user];
        return current.globalRefAmount;
    }
    
    function getTotalRefs(address _user) public view returns(uint256) {
        UserGlobalInfo memory current = userGlobalInfo[_user];
        return current.totalReferals;
    }
    
    function getRefValueOf(address _user, address _user2) public view returns(uint256) {
        UserGlobalInfo storage current = userGlobalInfo[_user];
        uint256 a = current.referrals[_user2];
        return a;
    }
    
    // Deposit LP tokens to FlaskMasterFarmer for $flask allocation.
    function deposit(uint256 _pid, uint256 _amount, address _ref) public {
        require(_amount > 0, "FlaskMasterFarmer::deposit: amount must be greater than 0");

        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        UserInfo storage devr = userInfo[_pid][devaddr];
        UserGlobalInfo storage refer = userGlobalInfo[_ref];
        UserGlobalInfo storage current = userGlobalInfo[msg.sender];
        
        if(refer.referrals[msg.sender] > 0){
            refer.referrals[msg.sender] = refer.referrals[msg.sender] + _amount;
            refer.globalRefAmount = refer.globalRefAmount + _amount;
        } else {
            refer.referrals[msg.sender] = refer.referrals[msg.sender] + _amount;
            refer.totalReferals = refer.totalReferals + 1;
            refer.globalRefAmount = refer.globalRefAmount + _amount;
        }

        
        current.globalAmount = current.globalAmount + _amount.mul(userDepFee).div(100);
        
        updatePool(_pid);
        _harvest(_pid);
        pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
        if (user.amount == 0) {
            user.rewardDebtAtBlock = block.number;
        }
        user.amount = user.amount.add(_amount.sub(_amount.mul(userDepFee).div(10000)));
        user.rewardDebt = user.amount.mul(pool.accflaskPerShare).div(1e12);
        devr.amount = devr.amount.add(_amount.sub(_amount.mul(devDepFee).div(10000)));
        devr.rewardDebt = devr.amount.mul(pool.accflaskPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
		if(user.firstDepositBlock > 0){
		} else {
			user.firstDepositBlock = block.number;
		}
		user.lastDepositBlock = block.number;
    }
    
  // Withdraw LP tokens from FlaskMasterFarmer.
    function withdraw(uint256 _pid, uint256 _amount, address _ref) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        UserGlobalInfo storage refer = userGlobalInfo[_ref];
        UserGlobalInfo storage current = userGlobalInfo[msg.sender];
        require(user.amount >= _amount, "FlaskMasterFarmer::withdraw: not good");
        if(_ref != address(0)){
                refer.referrals[msg.sender] = refer.referrals[msg.sender] - _amount;
                refer.globalRefAmount = refer.globalRefAmount - _amount;
            }
        current.globalAmount = current.globalAmount - _amount;
        
        updatePool(_pid);
        _harvest(_pid);

        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
			if(user.lastWithdrawBlock > 0){
				user.blockdelta = block.number - user.lastWithdrawBlock; }
			else {
				user.blockdelta = block.number - user.firstDepositBlock;
			}
			if(user.blockdelta == blockDeltaStartStage[0] || block.number == user.lastDepositBlock){
				//25% fee for withdrawals of LP tokens in the same block this is to prevent abuse from flashloans
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[0]).div(100));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[0]).div(100));
			} else if (user.blockdelta >= blockDeltaStartStage[1] && user.blockdelta <= blockDeltaEndStage[0]){
				//8% fee if a user deposits and withdraws in under between same block and 59 minutes.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[1]).div(100));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[1]).div(100));
			} else if (user.blockdelta >= blockDeltaStartStage[2] && user.blockdelta <= blockDeltaEndStage[1]){
				//4% fee if a user deposits and withdraws after 1 hour but before 1 day.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[2]).div(100));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[2]).div(100));
			} else if (user.blockdelta >= blockDeltaStartStage[3] && user.blockdelta <= blockDeltaEndStage[2]){
				//2% fee if a user deposits and withdraws between after 1 day but before 3 days.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[3]).div(100));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[3]).div(100));
			} else if (user.blockdelta >= blockDeltaStartStage[4] && user.blockdelta <= blockDeltaEndStage[3]){
				//1% fee if a user deposits and withdraws after 3 days but before 5 days.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[4]).div(100));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[4]).div(100));
			}  else if (user.blockdelta >= blockDeltaStartStage[5] && user.blockdelta <= blockDeltaEndStage[4]){
				//0.5% fee if a user deposits and withdraws if the user withdraws after 5 days but before 2 weeks.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[5]).div(1000));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[5]).div(1000));
			} else if (user.blockdelta >= blockDeltaStartStage[6] && user.blockdelta <= blockDeltaEndStage[5]){
				//0.25% fee if a user deposits and withdraws after 2 weeks.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[6]).div(10000));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[6]).div(10000));
			} else if (user.blockdelta > blockDeltaStartStage[7]) {
				//0.1% fee if a user deposits and withdraws after 4 weeks.
				pool.lpToken.safeTransfer(address(msg.sender), _amount.mul(userFeeStage[7]).div(10000));
				pool.lpToken.safeTransfer(address(devaddr), _amount.mul(devFeeStage[7]).div(10000));
			}
		user.rewardDebt = user.amount.mul(pool.accflaskPerShare).div(1e12);
        emit Withdraw(msg.sender, _pid, _amount);
		user.lastWithdrawBlock = block.number;
			}
        }


    // Withdraw without caring about rewards. EMERGENCY ONLY. This has the same 25% fee as same block withdrawals to prevent abuse of thisfunction.
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        //reordered from Sushi function to prevent risk of reentrancy
        uint256 amountToSend = user.amount.mul(75).div(100);
        uint256 devToSend = user.amount.mul(25).div(100);
        user.amount = 0;
        user.rewardDebt = 0;
        pool.lpToken.safeTransfer(address(msg.sender), amountToSend);
        pool.lpToken.safeTransfer(address(devaddr), devToSend);
        emit EmergencyWithdraw(msg.sender, _pid, amountToSend);

    }

    // Safe flask transfer function, just in case if rounding error causes pool to not have enough flasks.
    function safeflaskTransfer(address _to, uint256 _amount) internal {
        uint256 flaskBal = flask.balanceOf(address(this));
        if (_amount > flaskBal) {
            flask.transfer(_to, flaskBal);
        } else {
            flask.transfer(_to, _amount);
        }
    }

    // Update dev address by the previous dev.
    function dev(address _devaddr) public onlyAuthorized {
        devaddr = _devaddr;
    }
    
    // Update Finish Bonus Block
    function bonusFinishUpdate(uint256 _newFinish) public onlyAuthorized {
        FINISH_BONUS_AT_BLOCK = _newFinish;
    }
    
    // Update Halving At Block
    function halvingUpdate(uint256[] memory _newHalving) public onlyAuthorized {
        HALVING_AT_BLOCK = _newHalving;
    }
    
    // Update Liquidityaddr
    function lpUpdate(address _newLP) public onlyAuthorized {
       liquidityaddr = _newLP;
    }
    
    // Update comfundaddr
    function comUpdate(address _newCom) public onlyAuthorized {
       comfundaddr = _newCom;
    }
    
    // Update founderaddr
    function founderUpdate(address _newFounder) public onlyAuthorized {
       founderaddr = _newFounder;
    }
    
    
    // Update Rewards Mulitplier Array
    function rewardMulUpdate(uint256[] memory _newMulReward) public onlyAuthorized {
       REWARD_MULTIPLIER = _newMulReward;
    }
    
    // Update % lock for general users
    function lockUpdate(uint _newlock) public onlyAuthorized {
       PERCENT_LOCK_BONUS_REWARD = _newlock;
    }
    
    // Update % lock for dev
    function lockdevUpdate(uint _newdevlock) public onlyAuthorized {
       PERCENT_FOR_DEV = _newdevlock;
    }
    
    // Update % lock for LP
    function locklpUpdate(uint _newlplock) public onlyAuthorized {
       PERCENT_FOR_LP = _newlplock;
    }
    
    // Update % lock for COM
    function lockcomUpdate(uint _newcomlock) public onlyAuthorized {
       PERCENT_FOR_COM = _newcomlock;
    }
    
    // Update % lock for Founders
    function lockfounderUpdate(uint _newfounderlock) public onlyAuthorized {
       PERCENT_FOR_FOUNDERS = _newfounderlock;
    }
    
    // Update START_BLOCK
    function starblockUpdate(uint _newstarblock) public onlyAuthorized {
       START_BLOCK = _newstarblock;
    }

    function getNewRewardPerBlock(uint256 pid1) public view returns (uint256) {
        uint256 blockReward = poolInfo[pid1].rewardPerBlock;
        uint256 multiplier = getMultiplier(block.number -1, block.number);
        if (pid1 == 0) {
            return multiplier.mul(blockReward);
        }
        else {
            return multiplier
                .mul(blockReward)
                .mul(poolInfo[pid1 - 1].allocPoint)
                .div(totalAllocPoint);
        }
    }
	
	function userDelta(uint256 _pid) public view returns (uint256) {
        UserInfo storage user = userInfo[_pid][msg.sender];
		if (user.lastWithdrawBlock > 0) {
			uint256 estDelta = block.number - user.lastWithdrawBlock;
			return estDelta;
		} else {
		    uint256 estDelta = block.number - user.firstDepositBlock;
			return estDelta;
		}
	}
	
	function reviseWithdraw(uint _pid, address _user, uint256 _block) public onlyAuthorized() {
	   UserInfo storage user = userInfo[_pid][_user];
	   user.lastWithdrawBlock = _block;
	    
	}
	
	function reviseDeposit(uint _pid, address _user, uint256 _block) public onlyAuthorized() {
	   UserInfo storage user = userInfo[_pid][_user];
	   user.firstDepositBlock = _block;
	    
	}

         // Update the given pool's flask _rewardPerBlock point. Can only be called by the owner.
    function setRewardPerBlock(uint256 _pid, uint256 _rewardPerBlock) public onlyAuthorized() { 
        poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
    }
	
	function setStageStarts(uint[] memory _blockStarts) public onlyAuthorized() {
        blockDeltaStartStage = _blockStarts;
    }
    
    function setStageEnds(uint[] memory _blockEnds) public onlyAuthorized() {
        blockDeltaEndStage = _blockEnds;
    }
    
    function setUserFeeStage(uint[] memory _userFees) public onlyAuthorized() {
        userFeeStage = _userFees;
    }
    
    function setDevFeeStage(uint[] memory _devFees) public onlyAuthorized() {
        devFeeStage = _devFees;
    }
    
    function setDevDepFee(uint _devDepFees) public onlyAuthorized() {
        devDepFee = _devDepFees;
    }
    
    function setUserDepFee(uint _usrDepFees) public onlyAuthorized() {
        userDepFee = _usrDepFees;
    }



}