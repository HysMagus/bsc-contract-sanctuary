// File: @openzeppelin/contracts/math/SafeMath.sol

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

// File: @openzeppelin/contracts/math/Math.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/utils/EnumerableSet.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

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

// File: @openzeppelin/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/access/AccessControl.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;




/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;




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

// File: @openzeppelin/contracts/utils/Pausable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/proxy/Initializable.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24 <0.7.0;


/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 * 
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 * 
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }
}

// File: contracts/libraries/BakerySwapHelper.sol

pragma solidity >=0.6.0;




library BakerySwapHelper {
    using SafeMath for uint256;
    uint256 public constant PRICE_MULTIPLE = 1E8;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'BakerySwapHelper: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'BakerySwapHelper: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(
        address factory,
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex'ff',
                        factory,
                        keccak256(abi.encodePacked(token0, token1)),
                        hex'e2e87433120e32c4738a7d8f3271f3d872cbe16241d67537139158d90bac61d3' // init code hash
                    )
                )
            )
        );
    }

    function getPrice(
        address factory,
        address _baseToken,
        address _quoteToken
    ) internal view returns (uint256 price) {
        if (_baseToken == _quoteToken) {
            price = 1;
        } else {
            address pair = BakerySwapHelper.pairFor(factory, _baseToken, _quoteToken);
            uint256 baseTokenAmount = IERC20(_baseToken).balanceOf(pair);
            uint256 quoteTokenAmount = IERC20(_quoteToken).balanceOf(pair);
            price = quoteTokenAmount
                .mul(PRICE_MULTIPLE)
                .mul(10**uint256(ERC20(_baseToken).decimals()))
                .div(10**uint256(ERC20(_quoteToken).decimals()))
                .div(baseTokenAmount);
        }
    }
}

// File: contracts/BakeBaseMaster.sol

pragma solidity =0.6.6;
pragma experimental ABIEncoderV2;









contract BakeBaseMaster is AccessControl, Pausable, Initializable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    // Info of each user.
    struct UserInfo {
        uint256 amount;
        mapping(address => uint256) otherRewardDebtMap;
        mapping(address => uint256) otherRewardPendingMap;
        uint256 bakeRewardDebt;
        uint256 bakeRewardPending;
        uint256 lastUpdateBlock;
    }

    struct UserInfoView {
        uint256 amount;
        uint256[] otherRewardDebts;
        uint256[] otherRewardPendings;
        uint256 bakeRewardDebt;
        uint256 bakeRewardPending;
        uint256 lastUpdateBlock;
    }

    // Info of each poolInfo.
    struct PoolInfo {
        mapping(address => uint256) otherRoiMap;
        uint256 bakeRoi;
        uint256 rewardStartBlock;
        uint256 rewardEndBlock;
        uint256 amount;
    }

    struct PoolInfoView {
        uint256[] otherRois;
        uint256 bakeRoi;
        uint256 rewardStartBlock;
        uint256 rewardEndBlock;
        uint256 amount;
    }

    uint256 public constant accTokenPerShareMultiple = 1E12;
    uint256 public constant TEN_THOUSANDTH = 1E4;
    // 3s/block
    uint256 public constant YEARLY_BLOCKS = 365 * 28800;
    // 100 * 1E8
    mapping(address => uint256) public convertToBakePriceMap;
    mapping(address => bool) public convertUseMarketPriceMap;
    ERC20 public bake;
    EnumerableSet.AddressSet private _otherRewardTokens;
    address public bakerySwapFactory;
    EnumerableSet.AddressSet private _poolAddresses;
    mapping(address => PoolInfo) private _poolInfoMap;
    // Info of each user that stakes LP tokens.
    mapping(address => mapping(address => UserInfo)) private _poolUserInfoMap;

    event AddOtherRewardToken(address indexed user, address indexed token);
    event AddPool(address indexed user, address indexed poolAddress, uint256 rewardStartBlock, uint256 rewardEndBlock);
    event SetPoolTokenRoi(address indexed user, address indexed poolAddress, address indexed tokenAddress, uint256 roi);
    event SetPool(address indexed user, address indexed poolAddress, uint256 rewardStartBlock, uint256 rewardEndBlock);
    event RemovePool(
        address indexed user,
        address indexed poolAddress,
        uint256 rewardStartBlock,
        uint256 rewardEndBlock,
        uint256 amount
    );
    event Stake(address indexed user, address indexed poolAddress, uint256 amount);
    event Unstake(address indexed user, address indexed poolAddress, uint256 amount);
    event EmergencyUnstake(address indexed user, address indexed poolAddress, uint256 amount);
    event HarvestToken(
        address indexed user,
        address indexed poolAddress,
        address indexed token,
        uint256 tokenAmount,
        uint256 bakeAmount,
        uint256 price
    );

    constructor() public {}

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), 'Ownable: caller is not the owner');
        _;
    }

    function initialize(address _bake, address _bakerySwapFactory) public initializer {
        bake = ERC20(_bake);
        bakerySwapFactory = _bakerySwapFactory;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function otherRewardTokens() public view returns (address[] memory tokens) {
        tokens = new address[](_otherRewardTokens.length());
        for (uint256 i = 0; i < tokens.length; ++i) {
            tokens[i] = _otherRewardTokens.at(i);
        }
    }

    function addOtherRewardToken(address _token) public onlyOwner {
        require(!_otherRewardTokens.contains(_token), 'token already exists');
        _otherRewardTokens.add(_token);
        emit AddOtherRewardToken(_msgSender(), _token);
    }

    function poolAddresses() public view returns (address[] memory pools) {
        pools = new address[](_poolAddresses.length());
        for (uint256 i = 0; i < pools.length; ++i) {
            pools[i] = _poolAddresses.at(i);
        }
    }

    function pools()
        public
        view
        returns (
            address[] memory addresses,
            address[] memory tokens,
            PoolInfoView[] memory poolInfos
        )
    {
        addresses = poolAddresses();
        tokens = otherRewardTokens();
        poolInfos = new PoolInfoView[](addresses.length);
        for (uint256 i = 0; i < addresses.length; ++i) {
            poolInfos[i] = poolInfoMap(addresses[i]);
        }
    }

    function poolInfoMap(address _pool) public view returns (PoolInfoView memory poolInfoView) {
        uint256[] memory otherRois = new uint256[](_otherRewardTokens.length());
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        for (uint256 i = 0; i < otherRois.length; ++i) {
            otherRois[i] = poolInfo.otherRoiMap[_otherRewardTokens.at(i)];
        }
        poolInfoView = PoolInfoView({
            otherRois: otherRois,
            bakeRoi: poolInfo.bakeRoi,
            rewardStartBlock: poolInfo.rewardStartBlock,
            rewardEndBlock: poolInfo.rewardEndBlock,
            amount: poolInfo.amount
        });
    }

    function addPool(
        uint256[] memory _otherRois,
        uint256 _bakeRoi,
        uint256 _rewardStartBlock,
        uint256 _rewardEndBlock,
        address _pool
    ) public onlyOwner {
        require(!_poolAddresses.contains(_pool), 'pool already exists');
        require(_otherRois.length == _otherRewardTokens.length(), 'otherRois length error');
        _poolInfoMap[_pool].bakeRoi = _bakeRoi;
        _poolInfoMap[_pool].rewardStartBlock = _rewardStartBlock == 0 ? block.number : _rewardStartBlock;
        _poolInfoMap[_pool].rewardEndBlock = _rewardEndBlock;
        _poolAddresses.add(_pool);
        emit AddPool(_msgSender(), _pool, _poolInfoMap[_pool].rewardStartBlock, _poolInfoMap[_pool].rewardEndBlock);
        for (uint256 i = 0; i < _otherRois.length; ++i) {
            _poolInfoMap[_pool].otherRoiMap[_otherRewardTokens.at(i)] = _otherRois[i];
            emit SetPoolTokenRoi(_msgSender(), _pool, _otherRewardTokens.at(i), _otherRois[i]);
        }
        emit SetPoolTokenRoi(_msgSender(), _pool, address(bake), _bakeRoi);
    }

    function setPool(
        address _pool,
        uint256 _rewardStartBlock,
        uint256 _rewardEndBlock
    ) public onlyOwner {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        if (poolInfo.rewardStartBlock != _rewardStartBlock && _rewardStartBlock != 0) {
            poolInfo.rewardStartBlock = _rewardStartBlock;
        }
        if (poolInfo.rewardEndBlock != _rewardEndBlock) {
            poolInfo.rewardEndBlock = _rewardEndBlock;
        }
        emit SetPool(_msgSender(), _pool, poolInfo.rewardStartBlock, poolInfo.rewardEndBlock);
    }

    function setPoolTokenRoi(
        address _pool,
        address[] memory _tokens,
        uint256[] memory _rois
    ) public onlyOwner {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        require(_tokens.length == _rois.length && _tokens.length != 0, 'tokens rois error');
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        for (uint256 i = 0; i < _tokens.length; ++i) {
            if (_tokens[i] == address(bake)) {
                if (poolInfo.bakeRoi != _rois[i]) {
                    poolInfo.bakeRoi = _rois[i];
                }
            } else {
                require(_otherRewardTokens.contains(_tokens[i]), 'token error');
                if (poolInfo.otherRoiMap[_tokens[i]] != _rois[i]) {
                    poolInfo.otherRoiMap[_tokens[i]] = _rois[i];
                }
            }
            emit SetPoolTokenRoi(_msgSender(), _pool, _tokens[i], _rois[i]);
        }
    }

    function removePool(address _pool) public onlyOwner {
        require(_poolAddresses.contains(_pool) && _poolInfoMap[_pool].amount == 0, 'pool not exists or pool has stake');
        delete _poolInfoMap[_pool];
        emit RemovePool(
            _msgSender(),
            _pool,
            _poolInfoMap[_pool].rewardStartBlock,
            _poolInfoMap[_pool].rewardEndBlock,
            _poolInfoMap[_pool].amount
        );
    }

    function setConvertToBakePrice(address _token, uint256 _convertToBakePrice) public onlyOwner {
        require(convertToBakePriceMap[_token] != _convertToBakePrice, 'Not need update');
        convertToBakePriceMap[_token] = _convertToBakePrice;
    }

    function setConvertUseMarketPrice(address _token, bool _convertUseMarketPrice) public onlyOwner {
        require(convertUseMarketPriceMap[_token] != _convertUseMarketPrice, 'Not need update');
        convertUseMarketPriceMap[_token] = _convertUseMarketPrice;
    }

    function poolUserInfoMap(address _pool, address _user) public view returns (UserInfoView memory userInfoView) {
        uint256[] memory otherRewardDebts = new uint256[](_otherRewardTokens.length());
        uint256[] memory otherRewardPendings = new uint256[](otherRewardDebts.length);
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_user];
        for (uint256 i = 0; i < otherRewardDebts.length; ++i) {
            otherRewardDebts[i] = userInfo.otherRewardDebtMap[_otherRewardTokens.at(i)];
            otherRewardPendings[i] = userInfo.otherRewardPendingMap[_otherRewardTokens.at(i)];
        }
        userInfoView = UserInfoView({
            amount: userInfo.amount,
            otherRewardDebts: otherRewardDebts,
            otherRewardPendings: otherRewardPendings,
            bakeRewardDebt: userInfo.bakeRewardDebt,
            bakeRewardPending: userInfo.bakeRewardPending,
            lastUpdateBlock: userInfo.lastUpdateBlock
        });
    }

    function _calculateReward(
        UserInfo storage userInfo,
        PoolInfo storage poolInfo,
        address _pool
    ) internal view returns (uint256 bakeReward, uint256[] memory otherRewards) {
        uint256 endBlock =
            (poolInfo.rewardEndBlock != 0 && block.number > poolInfo.rewardEndBlock)
                ? poolInfo.rewardEndBlock
                : block.number;
        otherRewards = new uint256[](_otherRewardTokens.length());
        if (userInfo.amount == 0 || endBlock <= userInfo.lastUpdateBlock) {
            bakeReward = 0;
        } else {
            uint256 blocks = endBlock.sub(userInfo.lastUpdateBlock == 0 ? block.number : userInfo.lastUpdateBlock);
            uint256 amount = userInfo.amount;
            bakeReward = amount
                .mul(blocks)
                .mul(poolInfo.bakeRoi)
                .mul(10**uint256(ERC20(_pool).decimals()))
                .div(TEN_THOUSANDTH)
                .div(YEARLY_BLOCKS)
                .div(10**uint256(bake.decimals()));
            PoolInfo storage _poolInfo = poolInfo; //  Stack too deep,
            for (uint256 i = 0; i < otherRewards.length; ++i) {
                otherRewards[i] = amount
                    .mul(blocks)
                    .mul(_poolInfo.otherRoiMap[_otherRewardTokens.at(i)])
                    .mul(10**uint256(ERC20(_pool).decimals()))
                    .div(TEN_THOUSANDTH)
                    .div(YEARLY_BLOCKS)
                    .div(10**uint256(ERC20(_otherRewardTokens.at(i)).decimals()));
            }
        }
    }

    function getTokenBakePrice(address _token) public view returns (uint256) {
        return
            convertUseMarketPriceMap[_token]
                ? BakerySwapHelper.getPrice(bakerySwapFactory, _token, address(bake))
                : convertToBakePriceMap[_token];
    }

    // View function to see pending TOKENs on frontend.
    function pendingToken(address _pool, address _user)
        external
        view
        returns (
            uint256 bakeReward,
            uint256[] memory otherRewards,
            uint256[] memory nowOtherRewards,
            uint256[] memory otherConvertToBakeRewards,
            uint256[] memory otherConvertToBakePrices,
            uint256 priceMultiple
        )
    {
        require(_poolAddresses.contains(_pool), 'Unknown pool');
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_user];
        (bakeReward, otherRewards) = _calculateReward(userInfo, poolInfo, _pool);

        nowOtherRewards = new uint256[](otherRewards.length);
        otherConvertToBakeRewards = new uint256[](otherRewards.length);
        otherConvertToBakePrices = new uint256[](otherRewards.length);
        priceMultiple = BakerySwapHelper.PRICE_MULTIPLE;

        bakeReward = bakeReward.add(userInfo.bakeRewardPending.sub(userInfo.bakeRewardDebt));
        for (uint256 i = 0; i < otherRewards.length; ++i) {
            address otherToken = _otherRewardTokens.at(i);
            otherRewards[i] = otherRewards[i].add(
                userInfo.otherRewardPendingMap[otherToken].sub(userInfo.otherRewardDebtMap[otherToken])
            );
            otherConvertToBakePrices[i] = getTokenBakePrice(otherToken);
            nowOtherRewards[i] = ERC20(otherToken).balanceOf(address(this));

            if (otherRewards[i] > nowOtherRewards[i]) {
                uint256 convertOther = otherRewards[i].sub(nowOtherRewards[i]);
                otherConvertToBakeRewards[i] = convertOther
                    .mul(otherConvertToBakePrices[i])
                    .mul(10**uint256(bake.decimals()))
                    .div(10**uint256(ERC20(otherToken).decimals()))
                    .div(priceMultiple);
            } else {
                nowOtherRewards[i] = otherRewards[i];
                otherConvertToBakeRewards[i] = 0;
            }
        }
    }

    function _updateUserInfo(
        UserInfo storage userInfo,
        PoolInfo storage poolInfo,
        address _pool
    ) internal {
        if (userInfo.amount == 0 || poolInfo.rewardStartBlock > block.number) {
            userInfo.lastUpdateBlock = block.number;
            return;
        }
        (uint256 bakeReward, uint256[] memory otherRewards) = _calculateReward(userInfo, poolInfo, _pool);
        userInfo.bakeRewardPending = userInfo.bakeRewardPending.add(bakeReward);
        userInfo.lastUpdateBlock = block.number;
        for (uint256 i = 0; i < otherRewards.length; ++i) {
            userInfo.otherRewardPendingMap[_otherRewardTokens.at(i)] = userInfo.otherRewardPendingMap[
                _otherRewardTokens.at(i)
            ]
                .add(otherRewards[i]);
        }
    }

    function stake(address _pool, uint256 _amount) public whenNotPaused {
        require(
            _poolAddresses.contains(_pool) &&
                (_poolInfoMap[_pool].rewardEndBlock == 0 || block.number < _poolInfoMap[_pool].rewardEndBlock),
            'pool not open'
        );
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        _updateUserInfo(userInfo, poolInfo, _pool);
        if (_amount != 0) {
            ERC20(_pool).safeTransferFrom(_msgSender(), address(this), _amount);
            userInfo.amount = userInfo.amount.add(_amount);
            poolInfo.amount = poolInfo.amount.add(_amount);
        }
        emit Stake(_msgSender(), _pool, _amount);
    }

    function _harvestBake(UserInfo storage userInfo, address _pool) internal {
        uint256 pending = userInfo.bakeRewardPending.sub(userInfo.bakeRewardDebt);
        if (pending != 0) {
            userInfo.bakeRewardDebt = userInfo.bakeRewardPending;
            safeTokenTransfer(bake, _msgSender(), pending);
        }
        emit HarvestToken(_msgSender(), _pool, address(bake), pending, 0, 1);
    }

    function harvestBake(address _pool) public {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        _updateUserInfo(userInfo, poolInfo, _pool);
        _harvestBake(userInfo, _pool);
    }

    function _harvestOther(
        UserInfo storage userInfo,
        address _pool,
        address _token
    ) internal {
        uint256 tokenReward = userInfo.otherRewardPendingMap[_token].sub(userInfo.otherRewardDebtMap[_token]);
        uint256 price = getTokenBakePrice(_token);
        uint256 convertToBakeReward = 0;

        if (tokenReward != 0) {
            userInfo.otherRewardDebtMap[_token] = userInfo.otherRewardPendingMap[_token];
            uint256 otherBal = ERC20(_token).balanceOf(address(this));
            if (tokenReward > otherBal) {
                convertToBakeReward = tokenReward
                    .sub(otherBal)
                    .mul(price)
                    .mul(10**uint256(bake.decimals()))
                    .div(10**uint256(ERC20(_token).decimals()))
                    .div(BakerySwapHelper.PRICE_MULTIPLE);
                tokenReward = otherBal;
                safeTokenTransfer(bake, _msgSender(), convertToBakeReward);
            }
            safeTokenTransfer(ERC20(_token), _msgSender(), tokenReward);
        }
        emit HarvestToken(_msgSender(), _pool, _token, tokenReward, convertToBakeReward, price);
    }

    function harvestOther(address _pool, address _token) public {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        _updateUserInfo(userInfo, poolInfo, _pool);
        _harvestOther(userInfo, _pool, _token);
    }

    function harvestAllOther(address _pool) public {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        _updateUserInfo(userInfo, poolInfo, _pool);
        for (uint256 i = 0; i < _otherRewardTokens.length(); ++i) {
            _harvestOther(userInfo, _pool, _otherRewardTokens.at(i));
        }
    }

    function unstake(address _pool, uint256 _amount) public {
        require(_poolAddresses.contains(_pool), 'pool not exists');
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        require(userInfo.amount >= _amount, 'illegal amount');
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        _updateUserInfo(userInfo, poolInfo, _pool);

        if (_amount != 0) {
            userInfo.amount = userInfo.amount.sub(_amount);
            poolInfo.amount = poolInfo.amount.sub(_amount);
            ERC20(_pool).safeTransfer(_msgSender(), _amount);
        }
        emit Unstake(_msgSender(), _pool, _amount);
        if (userInfo.amount == 0) {
            _harvestBake(userInfo, _pool);
            harvestAllOther(_pool);
        }
    }

    // Unstake without caring about rewards. EMERGENCY ONLY.
    function emergencyUnstake(address _pool, uint256 _amount) public {
        UserInfo storage userInfo = _poolUserInfoMap[_pool][_msgSender()];
        PoolInfo storage poolInfo = _poolInfoMap[_pool];
        if (_amount == 0) {
            _amount = userInfo.amount;
        } else {
            _amount = Math.min(_amount, userInfo.amount);
        }
        require(_amount != 0, 'illegal amount');
        ERC20(_pool).safeTransfer(_msgSender(), _amount);
        if (_amount == userInfo.amount) {
            delete _poolUserInfoMap[_pool][_msgSender()];
        } else {
            userInfo.amount = userInfo.amount.sub(_amount);
            userInfo.bakeRewardDebt = userInfo.bakeRewardPending;
            for (uint256 i = 0; i < _otherRewardTokens.length(); ++i) {
                userInfo.otherRewardDebtMap[_otherRewardTokens.at(i)] = userInfo.otherRewardPendingMap[
                    _otherRewardTokens.at(i)
                ];
            }
        }
        poolInfo.amount = poolInfo.amount.sub(_amount);
        emit EmergencyUnstake(_msgSender(), _pool, _amount);
    }

    function safeTokenTransfer(
        ERC20 token,
        address _to,
        uint256 _amount
    ) internal {
        uint256 tokenBal = token.balanceOf(address(this));
        if (_amount == 0 || tokenBal == 0) {
            return;
        }
        if (_amount > tokenBal) {
            token.transfer(_to, tokenBal);
        } else {
            token.transfer(_to, _amount);
        }
    }

    function pauseStake() public onlyOwner whenNotPaused {
        _pause();
    }

    function unpauseStake() public onlyOwner whenPaused {
        _unpause();
    }
}