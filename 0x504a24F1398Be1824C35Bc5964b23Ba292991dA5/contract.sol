// Sources flattened with hardhat v2.0.3 https://hardhat.org

// File @openzeppelin/contracts/introspection/IERC1820Registry.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the global ERC1820 Registry, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
 * implementers for interfaces in this registry, as well as query support.
 *
 * Implementers may be shared by multiple accounts, and can also implement more
 * than a single interface for each account. Contracts can implement interfaces
 * for themselves, but externally-owned accounts (EOA) must delegate this to a
 * contract.
 *
 * {IERC165} interfaces can also be queried via the registry.
 *
 * For an in-depth explanation and source code analysis, see the EIP text.
 */
interface IERC1820Registry {
    /**
     * @dev Sets `newManager` as the manager for `account`. A manager of an
     * account is able to set interface implementers for it.
     *
     * By default, each account is its own manager. Passing a value of `0x0` in
     * `newManager` will reset the manager to this initial state.
     *
     * Emits a {ManagerChanged} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     */
    function setManager(address account, address newManager) external;

    /**
     * @dev Returns the manager for `account`.
     *
     * See {setManager}.
     */
    function getManager(address account) external view returns (address);

    /**
     * @dev Sets the `implementer` contract as ``account``'s implementer for
     * `interfaceHash`.
     *
     * `account` being the zero address is an alias for the caller's address.
     * The zero address can also be used in `implementer` to remove an old one.
     *
     * See {interfaceHash} to learn how these are created.
     *
     * Emits an {InterfaceImplementerSet} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
     * end in 28 zeroes).
     * - `implementer` must implement {IERC1820Implementer} and return true when
     * queried for support, unless `implementer` is the caller. See
     * {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function setInterfaceImplementer(address account, bytes32 _interfaceHash, address implementer) external;

    /**
     * @dev Returns the implementer of `interfaceHash` for `account`. If no such
     * implementer is registered, returns the zero address.
     *
     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
     * zeroes), `account` will be queried for support of it.
     *
     * `account` being the zero address is an alias for the caller's address.
     */
    function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);

    /**
     * @dev Returns the interface hash for an `interfaceName`, as defined in the
     * corresponding
     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
     */
    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

    /**
     *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
     *  @param account Address of the contract for which to update the cache.
     *  @param interfaceId ERC165 interface for which to update the cache.
     */
    function updateERC165Cache(address account, bytes4 interfaceId) external;

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not.
     *  If the result is not cached a direct lookup on the contract address is performed.
     *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
     *  {updateERC165Cache} with the contract address.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

    event ManagerChanged(address indexed account, address indexed newManager);
}


// File @openzeppelin/contracts/introspection/IERC1820Implementer.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface for an ERC1820 implementer, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820#interface-implementation-erc1820implementerinterface[EIP].
 * Used by contracts that will be registered as implementers in the
 * {IERC1820Registry}.
 */
interface IERC1820Implementer {
    /**
     * @dev Returns a special value (`ERC1820_ACCEPT_MAGIC`) if this contract
     * implements `interfaceHash` for `account`.
     *
     * See {IERC1820Registry-setInterfaceImplementer}.
     */
    function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) external view returns (bytes32);
}


// File @openzeppelin/contracts/introspection/ERC1820Implementer.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
contract ERC1820Implementer is IERC1820Implementer {
    bytes32 constant private _ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

    mapping(bytes32 => mapping(address => bool)) private _supportedInterfaces;

    /**
     * See {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) public view override returns (bytes32) {
        return _supportedInterfaces[interfaceHash][account] ? _ERC1820_ACCEPT_MAGIC : bytes32(0x00);
    }

    /**
     * @dev Declares the contract as willing to be an implementer of
     * `interfaceHash` for `account`.
     *
     * See {IERC1820Registry-setInterfaceImplementer} and
     * {IERC1820Registry-interfaceHash}.
     */
    function _registerInterfaceForAddress(bytes32 interfaceHash, address account) internal virtual {
        _supportedInterfaces[interfaceHash][account] = true;
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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


// File @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
 *
 * Accounts can be notified of {IERC777} tokens being sent to them by having a
 * contract implement this interface (contract holders can be their own
 * implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Recipient {
    /**
     * @dev Called by an {IERC777} token contract whenever tokens are being
     * moved or created into a registered account (`to`). The type of operation
     * is conveyed by `from` being the zero address or not.
     *
     * This call occurs _after_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}


// File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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


// File @openzeppelin/contracts/utils/Address.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2 <0.8.0;

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
        // This method relies on extcodesize, which returns 0 for contracts in
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
        return functionCallWithValue(target, data, 0, errorMessage);
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
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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


// File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.3.0

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;



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


// File contracts/utils/ECDSA.sol

pragma solidity ^0.6.0;

// SPDX-License-Identifier: LGPL-3.0-only

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    // y^2 = x^3 + 7 mod p, where p is FIELD_ORDER
    uint256 constant FIELD_ORDER = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    uint256 constant CURVE_ORDER = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;
    uint256 constant HALF_CURVE_ORDER = (CURVE_ORDER - 1) / 2;

    /**
     * @dev Computes the Ethereum address from a public key given as an
     * uncompressed EC-point.
     */
    function pubKeyToEthereumAddress(uint256 x, uint256 y) internal pure returns (address) {
        require(validate(x, y), "Point must be on the curve.");
        return address(bytes20(bytes32(keccak256(abi.encodePacked(x, y)) << 96)));
    }

    /**
     * @dev Computes the Ethereum address from a public key given as a
     * compressed EC-point.
     */
    function compressedPubKeyToEthereumAddress(uint256 compressedX, uint8 odd) internal returns (address) {
        (uint256 x, uint256 y) = decompress(compressedX, odd);
        return pubKeyToEthereumAddress(x, y);
    }

    function compress(uint256 x, uint256 y) internal pure returns (uint256, uint8) {
        return (x, uint8(y % 2));
    }

    /**
     * @dev Decompresses a compressed elliptic curve point and
     * returns the uncompressed version.
     * @notice secp256k1: y^2 = x^3 + 7 (mod p)
     * "Converts from (x, 1 / 0) to (x,y)"
     */
    function decompress(uint256 x, uint8 odd) internal returns (uint256, uint256) {
        uint256 sqrY = addmod(7, mulmod(mulmod(x, x, FIELD_ORDER), x, FIELD_ORDER), FIELD_ORDER);

        uint256 sqrtExponent = (FIELD_ORDER + 1) / 4;

        uint256 y;

        /* solhint-disable no-inline-assembly */
        assembly {
            // free memory pointer
            let memPtr := mload(0x40)

            // length of base, exponent, modulus
            mstore(memPtr, 0x20)
            mstore(add(memPtr, 0x20), 0x20)
            mstore(add(memPtr, 0x40), 0x20)

            // assign base, exponent, modulus
            mstore(add(memPtr, 0x60), sqrY)
            mstore(add(memPtr, 0x80), sqrtExponent)
            mstore(add(memPtr, 0xa0), FIELD_ORDER)

            // call the precompiled contract BigModExp (0x05)
            let success := call(gas(), 0x05, 0x0, memPtr, 0xc0, memPtr, 0x20)

            switch success
                case 0 {
                    revert(0x0, 0x0)
                }
                default {
                    y := mload(memPtr)
                }
        }
        /* solhint-enable no-inline-assembly */

        bool isOdd = y % 2 == 1;

        if ((isOdd && odd == 0) || (!isOdd && odd == 1)) {
            y = FIELD_ORDER - y;
        }

        return (x, y);
    }

    function validate(uint256 x, uint256 y) public pure returns (bool) {
        uint256 rightHandSide = addmod(7, mulmod(mulmod(x, x, FIELD_ORDER), x, FIELD_ORDER), FIELD_ORDER);

        uint256 leftHandSide = mulmod(y, y, FIELD_ORDER);

        return leftHandSide == rightHandSide;
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) internal pure returns (address) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > HALF_CURVE_ORDER) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum and HOPRnet Signed Message.
     * Replicates the behavior of the https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method but also includes "HOPRnet" in the message.
     */
    function toEthSignedMessageHash(string memory length, bytes memory message) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", length, "HOPRnet", message));
    }
}


// File contracts/HoprChannels.sol

pragma solidity ^0.6.0;

// SPDX-License-Identifier: LGPL-3.0-only







contract HoprChannels is IERC777Recipient, ERC1820Implementer {
    using SafeMath for uint256;

    // an account has set a new secret hash
    event SecretHashSet(address indexed account, bytes27 secretHash, uint32 counter);

    struct Account {
        uint256 accountX; // second part of account's public key
        bytes27 hashedSecret; // account's hashedSecret
        uint32 counter; // increases everytime 'setHashedSecret' is called by the account
        uint8 oddY;
    }

    enum ChannelStatus {UNINITIALISED, FUNDED, OPEN, PENDING}

    struct Channel {
        uint96 deposit; // tokens in the deposit
        uint96 partyABalance; // tokens that are claimable by party 'A'
        uint40 closureTime; // the time when the channel can be closed by either party
        uint24 stateCounter;
        /* stateCounter mod 10 == 0: uninitialised
         * stateCounter mod 10 == 1: funding
         * stateCounter mod 10 == 2: open
         * stateCounter mod 10 == 3: pending
         */
        bool closureByPartyA; // channel closure was initiated by party A
    }

    // setup ERC1820
    IERC1820Registry internal constant _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    bytes32 public constant TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");

    // @TODO: update this whenever adding / removing states.
    uint8 constant NUMBER_OF_STATES = 4;

    IERC20 public token; // the token that will be used to settle payments
    uint256 public secsClosure; // seconds it takes to allow closing of channel after channel's -
    // initiated channel closure, in case counter-party does not act -
    // within this time period

    // store accounts' state
    mapping(address => Account) public accounts;

    // store channels' state e.g: channels[hash(party_a, party_b)]
    mapping(bytes32 => Channel) public channels;

    mapping(bytes32 => bool) public redeemedTickets;

    constructor(IERC20 _token, uint256 _secsClosure) public {
        token = _token;

        require(_secsClosure < (1 << 40), "HoprChannels: Closure timeout must be strictly smaller than 2**40");

        secsClosure = _secsClosure;

        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
    }

    /**
     * @notice sets caller's hashedSecret
     * @param hashedSecret bytes27 hashedSecret to store
     */
    function setHashedSecret(bytes27 hashedSecret) external {
        require(hashedSecret != bytes27(0), "HoprChannels: hashedSecret is empty");

        Account storage account = accounts[msg.sender];
        require(account.accountX != uint256(0), "HoprChannels: msg.sender must have called init() before");
        require(account.hashedSecret != hashedSecret, "HoprChannels: new and old hashedSecrets are the same");
        require(account.counter + 1 < (1 << 32), "HoprChannels: Preventing account counter overflow");

        account.hashedSecret = hashedSecret;
        account.counter += 1;

        emit SecretHashSet(msg.sender, hashedSecret, account.counter);
    }

    /**
     * Initialize the account's on-chain variables.
     *
     * @param senderX uint256 first component of msg.sender's public key
     * @param senderY uint256 second component of msg.sender's public key
     * @param hashedSecret initial value for hashedSecret
     */
    function init(
        uint256 senderX,
        uint256 senderY,
        bytes27 hashedSecret
    ) external {
        require(senderX != uint256(0), "HoprChannels: first component of public key must not be zero.");
        require(hashedSecret != bytes27(0), "HoprChannels: HashedSecret must not be empty.");

        require(
            ECDSA.pubKeyToEthereumAddress(senderX, senderY) == msg.sender,
            "HoprChannels: Given public key must match 'msg.sender'"
        );

        (, uint8 oddY) = ECDSA.compress(senderX, senderY);

        Account storage account = accounts[msg.sender];

        require(account.accountX == uint256(0), "HoprChannels: Account must not be set");

        accounts[msg.sender] = Account(senderX, hashedSecret, uint32(1), oddY);

        emit SecretHashSet(msg.sender, hashedSecret, uint32(1));
    }

    /**
     * Fund a channel between 'initiator' and 'counterParty' using a signature,
     * specified tokens must be approved beforehand.
     *
     * @notice fund a channel
     * @param additionalDeposit uint256
     * @param partyAAmount uint256
     * @param notAfter uint256
     * @param r bytes32
     * @param s bytes32
     * @param v uint8
     * @param stateCounter uint128
     */
    function fundChannelWithSig(
        uint256 additionalDeposit,
        uint256 partyAAmount,
        uint256 notAfter,
        uint256 stateCounter,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external {
        address initiator = msg.sender;

        // verification
        require(additionalDeposit > 0, "HoprChannels: 'additionalDeposit' must be strictly greater than zero");
        require(additionalDeposit < (1 << 96), "HoprChannels: Invalid amount");
        require(
            partyAAmount <= additionalDeposit,
            "HoprChannels: 'partyAAmount' must be strictly smaller than 'additionalDeposit'"
        );
        // require(partyAAmount < (1 << 96), "Invalid amount");
        require(notAfter >= now, "HoprChannels: signature must not be expired");

        address counterparty = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(
                "167",
                abi.encode(stateCounter, initiator, additionalDeposit, partyAAmount, notAfter)
            ),
            r,
            s,
            uint8(v)
        );

        require(accounts[msg.sender].accountX != uint256(0), "HoprChannels: initiator must have called init before");
        require(
            accounts[counterparty].accountX != uint256(0),
            "HoprChannels: counterparty must have called init before"
        );
        require(initiator != counterparty, "HoprChannels: initiator and counterparty must not be the same");

        (address partyA, , Channel storage channel, ChannelStatus status) = getChannel(initiator, counterparty);

        require(
            channel.stateCounter == stateCounter,
            "HoprChannels: stored stateCounter and signed stateCounter must be the same"
        );

        require(
            status == ChannelStatus.UNINITIALISED || status == ChannelStatus.FUNDED,
            "HoprChannels: channel must be 'UNINITIALISED' or 'FUNDED'"
        );

        uint256 partyBAmount = additionalDeposit - partyAAmount;

        if (initiator == partyA) {
            token.transferFrom(initiator, address(this), partyAAmount);
            token.transferFrom(counterparty, address(this), partyBAmount);
        } else {
            token.transferFrom(initiator, address(this), partyBAmount);
            token.transferFrom(counterparty, address(this), partyAAmount);
        }

        channel.deposit = uint96(additionalDeposit);
        channel.partyABalance = uint96(partyAAmount);

        if (status == ChannelStatus.UNINITIALISED) {
            // The state counter indicates the recycling generation and ensures that both parties are using the correct generation.
            channel.stateCounter += 1;
        }

        if (initiator == partyA) {
            emitFundedChannel(address(0), initiator, counterparty, partyAAmount, partyBAmount);
        } else {
            emitFundedChannel(address(0), counterparty, initiator, partyAAmount, partyBAmount);
        }
    }

    /**
     * @notice open a channel
     * @param counterparty address the counterParty of 'msg.sender'
     */
    function openChannel(address counterparty) public {
        address opener = msg.sender;

        require(opener != counterparty, "HoprChannels: 'opener' and 'counterParty' must not be the same");
        require(counterparty != address(0), "HoprChannels: 'counterParty' address is empty");

        (, , Channel storage channel, ChannelStatus status) = getChannel(opener, counterparty);

        require(status == ChannelStatus.FUNDED, "HoprChannels: channel must be in 'FUNDED' state");

        // The state counter indicates the recycling generation and ensures that both parties are using the correct generation.
        channel.stateCounter += 1;

        emitOpenedChannel(opener, counterparty);
    }

    /**
     * @notice redeem ticket
     * @param preImage bytes32 the value that once hashed produces recipients hashedSecret
     * @param hashedSecretASecretB bytes32 hash of secretA concatenated with secretB
     * @param amount uint256 amount 'msg.sender' will receive
     * @param winProb bytes32 win probability
     * @param r bytes32
     * @param s bytes32
     * @param v uint8
     */
    function redeemTicket(
        bytes32 preImage,
        bytes32 hashedSecretASecretB,
        uint256 amount,
        bytes32 winProb,
        address counterparty,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external {
        require(amount > 0, "HoprChannels: amount must be strictly greater than zero");
        require(amount < (1 << 96), "HoprChannels: Invalid amount");
        require(
            accounts[msg.sender].hashedSecret == bytes27(keccak256(abi.encodePacked(bytes27(preImage)))),
            "HoprChannels: Given value is not a pre-image of the stored on-chain secret"
        );

        (address partyA, , Channel storage channel, ChannelStatus status) = getChannel(
            msg.sender,
            counterparty
        );
        bytes32 challenge = keccak256(abi.encodePacked(hashedSecretASecretB));
        bytes32 hashedTicket = ECDSA.toEthSignedMessageHash(
            "109",
            abi.encodePacked(
                msg.sender,
                challenge,
                uint24(accounts[msg.sender].counter),
                uint96(amount),
                winProb,
                uint24(getChannelIteration(channel))
            )
        );
        require(ECDSA.recover(hashedTicket, r, s, v) == counterparty, "HashedTicket signer does not match our counterparty");
        require(channel.stateCounter != uint24(0), "HoprChannels: Channel does not exist");
        require(!redeemedTickets[hashedTicket], "Ticket must not be used twice");

        bytes32 luck = keccak256(abi.encodePacked(hashedTicket, bytes27(preImage), hashedSecretASecretB));
        require(uint256(luck) <= uint256(winProb), "HoprChannels: ticket must be a win");
        require(
            status == ChannelStatus.OPEN || status == ChannelStatus.PENDING,
            "HoprChannels: channel must be 'OPEN' or 'PENDING'"
        );

        accounts[msg.sender].hashedSecret = bytes27(preImage);
        redeemedTickets[hashedTicket] = true;

        if (msg.sender == partyA) {
            require(channel.partyABalance + amount < (1 << 96), "HoprChannels: Invalid amount");
            channel.partyABalance += uint96(amount);
        } else {
            require(channel.partyABalance >= amount, "HoprChannels: Invalid amount");
            channel.partyABalance -= uint96(amount);
        }

        require(
            channel.partyABalance <= channel.deposit,
            "HoprChannels: partyABalance must be strictly smaller than deposit balance"
        );
    }

    /**
     * A channel's party can initiate channel closure at any time,
     * it starts a timeout.
     *
     * @notice initiate channel's closure
     * @param counterparty address counter party of 'msg.sender'
     */
    function initiateChannelClosure(address counterparty) external {
        address initiator = msg.sender;

        (address partyA, , Channel storage channel, ChannelStatus status) = getChannel(initiator, counterparty);

        require(status == ChannelStatus.OPEN, "HoprChannels: channel must be 'OPEN'");

        require(now + secsClosure < (1 << 40), "HoprChannels: Preventing timestamp overflow");
        channel.closureTime = uint40(now + secsClosure);
        // The state counter indicates the recycling generation and ensures that both parties are using the correct generation.

        require(channel.stateCounter + 1 < (1 << 24), "HoprChannels: Preventing stateCounter overflow");
        channel.stateCounter += 1;

        if (initiator == partyA) {
            channel.closureByPartyA = true;
        }

        emitInitiatedChannelClosure(initiator, counterparty, channel.closureTime);
    }

    /**
     * If the timeout is reached without the 'counterParty' reedeming a ticket,
     * then the tokens can be claimed by 'msg.sender'.
     *
     * @notice claim channel's closure
     * @param counterparty address counter party of 'msg.sender'
     */
    function claimChannelClosure(address counterparty) external {
        address initiator = msg.sender;

        (address partyA, address partyB, Channel storage channel, ChannelStatus status) = getChannel(
            initiator,
            counterparty
        );

        require(channel.stateCounter + 7 < (1 << 24), "Preventing stateCounter overflow");
        require(status == ChannelStatus.PENDING, "HoprChannels: channel must be 'PENDING'");

        if (
            channel.closureByPartyA && (initiator == partyA) ||
            !channel.closureByPartyA && (initiator == partyB)
        ) {
            require(now >= uint256(channel.closureTime), "HoprChannels: 'closureTime' has not passed");
        }

        // settle balances
        if (channel.partyABalance > 0) {
            token.transfer(partyA, channel.partyABalance);
            channel.deposit -= channel.partyABalance;
        }

        if (channel.deposit > 0) {
            token.transfer(partyB, channel.deposit);
        }

        emitClosedChannel(initiator, counterparty, channel.partyABalance, channel.deposit);

        delete channel.deposit; // channel.deposit = 0
        delete channel.partyABalance; // channel.partyABalance = 0
        delete channel.closureTime; // channel.closureTime = 0
        delete channel.closureByPartyA; // channel.closureByPartyA = false

        // The state counter indicates the recycling generation and ensures that both parties are using the correct generation.
        // Increase state counter so that we can re-use the same channel after it has been closed.
        channel.stateCounter += 7;
    }

    /**
     * A hook triggered when HOPR tokens are send to this contract.
     *
     * @param operator address operator requesting the transfer
     * @param from address token holder address
     * @param to address recipient address
     * @param amount uint256 amount of tokens to transfer
     * @param userData bytes extra information provided by the token holder (if any)
     * @param operatorData bytes extra information provided by the operator (if any)
     */
    function tokensReceived(
        address operator,
        address from,
        // solhint-disable-next-line no-unused-vars
        address to,
        uint256 amount,
        bytes calldata userData,
        // solhint-disable-next-line no-unused-vars
        bytes calldata operatorData
    ) external override {
        require(msg.sender == address(token), "HoprChannels: Invalid token");

        // only call 'fundChannel' when the operator is not self
        if (operator != address(this)) {
            (address recipient, address counterParty) = abi.decode(userData, (address, address));

            fundChannel(amount, from, recipient, counterParty);
        }
    }

    /**
     * Fund a channel between 'accountA' and 'accountB',
     * specified tokens must be approved beforehand.
     * Called when HOPR tokens are send to this contract.
     *
     * @notice fund a channel
     * @param additionalDeposit uint256 amount to fund the channel
     * @param funder address account which the funds are for
     * @param recipient address account of first participant of the payment channel
     * @param counterparty address account of the second participant of the payment channel
     */
    function fundChannel(
        uint256 additionalDeposit,
        address funder,
        address recipient,
        address counterparty
    ) internal {
        require(recipient != counterparty, "HoprChannels: 'recipient' and 'counterParty' must not be the same");
        require(recipient != address(0), "HoprChannels: 'recipient' address is empty");
        require(counterparty != address(0), "HoprChannels: 'counterParty' address is empty");
        require(additionalDeposit > 0, "HoprChannels: 'additionalDeposit' must be greater than 0");
        require(additionalDeposit < (1 << 96), "HoprChannels: preventing 'amount' overflow");

        require(accounts[recipient].accountX != uint256(0), "HoprChannels: initiator must have called init() before");
        require(
            accounts[counterparty].accountX != uint256(0),
            "HoprChannels: counterparty must have called init() before"
        );

        (address partyA, , Channel storage channel, ChannelStatus status) = getChannel(recipient, counterparty);

        require(
            status == ChannelStatus.UNINITIALISED || status == ChannelStatus.FUNDED,
            "HoprChannels: channel must be 'UNINITIALISED' or 'FUNDED'"
        );
        require(
            recipient != partyA || channel.partyABalance + additionalDeposit < (1 << 96),
            "HoprChannels: Invalid amount"
        );
        require(channel.deposit + additionalDeposit < (1 << 96), "HoprChannels: Invalid amount");
        require(channel.stateCounter + 1 < (1 << 24), "HoprChannels: Preventing stateCounter overflow");

        channel.deposit += uint96(additionalDeposit);

        if (recipient == partyA) {
            channel.partyABalance += uint96(additionalDeposit);
        }

        if (status == ChannelStatus.UNINITIALISED) {
            // The state counter indicates the recycling generation and ensures that both parties are using the correct generation.
            channel.stateCounter += 1;
        }

        emitFundedChannel(funder, recipient, counterparty, additionalDeposit, 0);
    }

    /**
     * @notice returns channel data
     * @param accountA address of account 'A'
     * @param accountB address of account 'B'
     */
    function getChannel(address accountA, address accountB)
        internal
        view
        returns (
            address,
            address,
            Channel storage,
            ChannelStatus
        )
    {
        (address partyA, address partyB) = getParties(accountA, accountB);
        bytes32 channelId = getChannelId(partyA, partyB);
        Channel storage channel = channels[channelId];

        ChannelStatus status = getChannelStatus(channel);

        return (partyA, partyB, channel, status);
    }

    /**
     * @notice return true if accountA is party_a
     * @param accountA address of account 'A'
     * @param accountB address of account 'B'
     */
    function isPartyA(address accountA, address accountB) internal pure returns (bool) {
        return uint160(accountA) < uint160(accountB);
    }

    /**
     * @notice return party_a and party_b
     * @param accountA address of account 'A'
     * @param accountB address of account 'B'
     */
    function getParties(address accountA, address accountB) internal pure returns (address, address) {
        if (isPartyA(accountA, accountB)) {
            return (accountA, accountB);
        } else {
            return (accountB, accountA);
        }
    }

    /**
     * @notice return channel id
     * @param party_a address of party 'A'
     * @param party_b address of party 'B'
     */
    function getChannelId(address party_a, address party_b) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(party_a, party_b));
    }

    /**
     * @notice returns 'ChannelStatus'
     * @param channel a channel
     */
    function getChannelStatus(Channel memory channel) internal pure returns (ChannelStatus) {
        return ChannelStatus(channel.stateCounter % 10);
    }

    /**
     * @param channel a channel
     * @return channel's iteration
     */
    function getChannelIteration(Channel memory channel) internal pure returns (uint24) {
        return (channel.stateCounter / 10) + 1;
    }

    /**
     * @dev Emits a FundedChannel event that contains the public keys of recipient
     * and counterparty as compressed EC-points.
     */
    function emitFundedChannel(
        address funder,
        address recipient,
        address counterparty,
        uint256 recipientAmount,
        uint256 counterpartyAmount
    ) private {
        /* FundedChannel(
         *   address funder,
         *   uint256 indexed recipient,
         *   uint256 indexed counterParty,
         *   uint256 recipientAmount,
         *   uint256 counterPartyAmount
         * )
         */
        bytes32 FundedChannel = keccak256("FundedChannel(address,uint,uint,uint,uint)");

        Account storage recipientAccount = accounts[recipient];
        Account storage counterpartyAccount = accounts[counterparty];

        uint256 recipientX = recipientAccount.accountX;
        uint8 recipientOddY = recipientAccount.oddY;

        uint256 counterpartyX = counterpartyAccount.accountX;
        uint8 counterpartyOddY = counterpartyAccount.oddY;

        assembly {
            let topic0 := or(or(shl(2, shr(2, FundedChannel)), shl(1, recipientOddY)), counterpartyOddY)

            let memPtr := mload(0x40)

            mstore(memPtr, recipientAmount)
            mstore(add(memPtr, 0x20), counterpartyAmount)
            mstore(add(memPtr, 0x40), funder)

            log3(memPtr, 0x60, topic0, recipientX, counterpartyX)
        }
    }

    /**
     * @dev Emits a OpenedChannel event that contains the public keys of opener
     * and counterparty as compressed EC-points.
     */
    function emitOpenedChannel(address opener, address counterparty) private {
        /* OpenedChannel(
         *   uint256 indexed opener,
         *   uint256 indexed counterParty
         * )
         */
        bytes32 OpenedChannel = keccak256("OpenedChannel(uint,uint)");

        Account storage openerAccount = accounts[opener];
        Account storage counterpartyAccount = accounts[counterparty];

        uint256 openerX = openerAccount.accountX;
        uint8 openerOddY = openerAccount.oddY;

        uint256 counterpartyX = counterpartyAccount.accountX;
        uint8 counterpartyOddY = counterpartyAccount.oddY;
        assembly {
            let topic0 := or(or(shl(2, shr(2, OpenedChannel)), shl(1, openerOddY)), counterpartyOddY)

            log3(0x00, 0x00, topic0, openerX, counterpartyX)
        }
    }

    /**
     * @dev Emits a InitiatedChannelClosure event that contains the public keys of initiator
     * and counterparty as compressed EC-points.
     */
    function emitInitiatedChannelClosure(
        address initiator,
        address counterparty,
        uint256 closureTime
    ) private {
        /* InitiatedChannelClosure(
         *   uint256 indexed initiator,
         *   uint256 indexed counterParty,
         *   uint256 closureTime
         * )
         */
        bytes32 InitiatedChannelClosure = keccak256("InitiatedChannelClosure(uint,uint,uint)");

        Account storage initiatorAccount = accounts[initiator];
        Account storage counterpartyAccount = accounts[counterparty];

        uint256 initiatorX = initiatorAccount.accountX;
        uint8 initiatorOddY = initiatorAccount.oddY;

        uint256 counterpartyX = counterpartyAccount.accountX;
        uint8 counterpartyOddY = counterpartyAccount.oddY;

        assembly {
            let topic0 := or(or(shl(2, shr(2, InitiatedChannelClosure)), shl(1, initiatorOddY)), counterpartyOddY)

            let memPtr := mload(0x40)

            mstore(memPtr, closureTime)

            log3(memPtr, 0x20, topic0, initiatorX, counterpartyX)
        }
    }

    /**
     * @dev Emits a ClosedChannel event that contains the public keys of initiator
     * and counterparty as compressed EC-points.
     */
    function emitClosedChannel(
        address initiator,
        address counterparty,
        uint256 partyAAmount,
        uint256 partyBAmount
    ) private {
        /*
         * ClosedChannel(
         *   uint256 indexed initiator,
         *   uint256 indexed counterParty,
         *   uint256 partyAAmount,
         *   uint256 partyBAmount
         */
        bytes32 ClosedChannel = keccak256("ClosedChannel(uint,uint,uint,uint)");

        Account storage initiatorAccount = accounts[initiator];
        Account storage counterpartyAccount = accounts[counterparty];

        uint256 initiatorX = initiatorAccount.accountX;
        uint8 initiatorOddY = initiatorAccount.oddY;

        uint256 counterpartyX = counterpartyAccount.accountX;
        uint8 counterpartyOddY = counterpartyAccount.oddY;

        assembly {
            let topic0 := or(or(shl(2, shr(2, ClosedChannel)), shl(1, initiatorOddY)), counterpartyOddY)

            let memPtr := mload(0x40)

            mstore(memPtr, partyAAmount)
            mstore(add(0x20, memPtr), partyBAmount)

            log3(memPtr, 0x40, topic0, initiatorX, counterpartyX)
        }
    }
}