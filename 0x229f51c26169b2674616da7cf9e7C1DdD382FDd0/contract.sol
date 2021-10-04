// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

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
        assembly {
            size := extcodesize(account)
        }
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
        (bool success, ) = recipient.call{value: amount}("");
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
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(data);
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
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
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

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
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
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

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

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

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
    constructor(string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
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
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
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
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
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
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
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
     * Requirements:
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
     * Requirements:
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
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
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
    function _setupDecimals(uint8 decimals_) internal virtual {
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
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

interface ISwap {
    // pool data view functions
    function getA() external view returns (uint256);

    function getToken(uint8 index) external view returns (IERC20);

    function getTokenIndex(address tokenAddress) external view returns (uint8);

    function getTokenBalance(uint8 index) external view returns (uint256);

    function getTokenLength() external view returns (uint256);

    function getVirtualPrice() external view returns (uint256);

    function swapStorage()
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        );

    // min return calculation functions
    function calculateSwap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    function calculateTokenAmount(uint256[] calldata amounts, bool deposit) external view returns (uint256);

    function calculateRemoveLiquidity(uint256 amount) external view returns (uint256[] memory);

    function calculateRemoveLiquidityOneToken(uint256 tokenAmount, uint8 tokenIndex) external view returns (uint256 availableTokenAmount);

    // state modifying functions
    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);

    function addLiquidity(
        uint256[] calldata amounts,
        uint256 minToMint,
        uint256 deadline
    ) external returns (uint256);

    function removeLiquidity(
        uint256 amount,
        uint256[] calldata minAmounts,
        uint256 deadline
    ) external returns (uint256[] memory);

    function removeLiquidityOneToken(
        uint256 tokenAmount,
        uint8 tokenIndex,
        uint256 minAmount,
        uint256 deadline
    ) external returns (uint256);

    function removeLiquidityImbalance(
        uint256[] calldata amounts,
        uint256 maxBurnAmount,
        uint256 deadline
    ) external returns (uint256);

    // withdraw fee update function
    function updateUserWithdrawFee(address recipient, uint256 transferAmount) external;

    function calculateRemoveLiquidity(address account, uint256 amount) external view returns (uint256[] memory);

    function calculateTokenAmount(
        address account,
        uint256[] calldata amounts,
        bool deposit
    ) external view returns (uint256);

    function calculateRemoveLiquidityOneToken(
        address account,
        uint256 tokenAmount,
        uint8 tokenIndex
    ) external view returns (uint256 availableTokenAmount);
}

interface IValueLiquidPair {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event PaidProtocolFee(uint112 collectedFee0, uint112 collectedFee1);
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
    event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function getCollectedFees() external view returns (uint112 _collectedFee0, uint112 _collectedFee1);

    function getTokenWeights() external view returns (uint32 tokenWeight0, uint32 tokenWeight1);

    function getSwapFee() external view returns (uint32);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(
        address,
        address,
        uint32,
        uint32
    ) external;
}

interface IValueLiquidRouter {
    event Exchange(address pair, uint256 amountOut, address output);
    struct Swap {
        address pool;
        address tokenIn;
        address tokenOut;
        uint256 swapAmount; // tokenInAmount / tokenOutAmount
        uint256 limitReturnAmount; // minAmountOut / maxAmountIn
        uint256 maxPrice;
    }

    function factory() external view returns (address);

    function controller() external view returns (address);

    function formula() external view returns (address);

    function WETH() external view returns (address);

    function addLiquidity(
        address pair,
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address pair,
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForTokens(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        address tokenIn,
        address tokenOut,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        address tokenOut,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        address tokenIn,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        address tokenIn,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        address tokenOut,
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        address tokenOut,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        address tokenIn,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function multihopBatchSwapExactIn(
        Swap[][] memory swapSequences,
        address tokenIn,
        address tokenOut,
        uint256 totalAmountIn,
        uint256 minTotalAmountOut,
        uint256 deadline
    ) external payable returns (uint256 totalAmountOut);

    function multihopBatchSwapExactOut(
        Swap[][] memory swapSequences,
        address tokenIn,
        address tokenOut,
        uint256 maxTotalAmountIn,
        uint256 deadline
    ) external payable returns (uint256 totalAmountIn);

    function createPair(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB,
        uint32 tokenWeightA,
        uint32 swapFee,
        address to
    ) external returns (uint256 liquidity);

    function createPairETH(
        address token,
        uint256 amountToken,
        uint32 tokenWeight,
        uint32 swapFee,
        address to
    ) external payable returns (uint256 liquidity);

    function removeLiquidity(
        address pair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address pair,
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address pair,
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address pair,
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address pair,
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address pair,
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);
}

/*
    Bancor Formula interface
*/
interface IValueLiquidFormula {
    function getReserveAndWeights(address pair, address tokenA)
        external
        view
        returns (
            address tokenB,
            uint256 reserveA,
            uint256 reserveB,
            uint32 tokenWeightA,
            uint32 tokenWeightB,
            uint32 swapFee
        );

    function getFactoryReserveAndWeights(
        address factory,
        address pair,
        address tokenA
    )
        external
        view
        returns (
            address tokenB,
            uint256 reserveA,
            uint256 reserveB,
            uint32 tokenWeightA,
            uint32 tokenWeightB,
            uint32 swapFee
        );

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint32 tokenWeightIn,
        uint32 tokenWeightOut,
        uint32 swapFee
    ) external view returns (uint256 amountIn);

    function getPairAmountIn(
        address pair,
        address tokenIn,
        uint256 amountOut
    ) external view returns (uint256 amountIn);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint32 tokenWeightIn,
        uint32 tokenWeightOut,
        uint32 swapFee
    ) external view returns (uint256 amountOut);

    function getPairAmountOut(
        address pair,
        address tokenIn,
        uint256 amountIn
    ) external view returns (uint256 amountOut);

    function getAmountsIn(
        address tokenIn,
        address tokenOut,
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getFactoryAmountsIn(
        address factory,
        address tokenIn,
        address tokenOut,
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsOut(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getFactoryAmountsOut(
        address factory,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function ensureConstantValue(
        uint256 reserve0,
        uint256 reserve1,
        uint256 balance0Adjusted,
        uint256 balance1Adjusted,
        uint32 tokenWeight0
    ) external view returns (bool);

    function getReserves(
        address pair,
        address tokenA,
        address tokenB
    ) external view returns (uint256 reserveA, uint256 reserveB);

    function getOtherToken(address pair, address tokenA) external view returns (address tokenB);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);

    function mintLiquidityFee(
        uint256 totalLiquidity,
        uint112 reserve0,
        uint112 reserve1,
        uint32 tokenWeight0,
        uint32 tokenWeight1,
        uint112 collectedFee0,
        uint112 collectedFee1
    ) external view returns (uint256 amount);
}

interface IRewardPool {
    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

    function pendingReward(uint256 _pid, address _user) external view returns (uint256);

    function userInfo(uint256 _pid, address _user) external view returns (uint256 amount, uint256 rewardDebt);
}

interface IMdgRewardPool {
    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

    function pendingReward(uint256 _pid, address _user) external view returns (uint256);

    function userInfo(uint256 _pid, address _user)
        external
        view
        returns (
            uint256 amount,
            uint256 rewardDebt,
            uint256 mdoDebt,
            uint256 bcashDebt
        );
}

interface IBurnabledERC20 {
    function burn(uint256) external;
}

contract ReserveFund {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    /* ========== STATE VARIABLES ========== */

    // governance
    address public operator;
    address public strategist;

    // flags
    bool public initialized = false;
    bool public publicAllowed; // set to true to allow public to call rebalance()

    // price
    uint256 public mdgPriceToSell; // to rebalance if price is high
    uint256 public mdgPriceToBuy; // to rebalance if price is low

    uint256[] public balancePercents; // MDG, WBNB and BUSD portfolio percentage
    uint256[] public contractionPercents; // MDG, WBNB and BUSD portfolio when buyback MDG

    mapping(address => uint256) public maxAmountToTrade; // MDG, WBNB, BUSD

    address public mdg = address(0xC1eDCc306E6faab9dA629efCa48670BE4678779D);
    address public wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address public busd = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    address public vdollar = address(0x3F6ad3c13E3a6bB5655F09A95cA05B6FF4c3DCd6);

    address[] public vlpPairsToRemove;
    address[] public cakePairsToRemove;

    // Pancakeswap
    IUniswapV2Router public pancakeRouter = IUniswapV2Router(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    mapping(address => mapping(address => address[])) public pancakeswapPaths;

    IValueLiquidRouter public vswapRouter = IValueLiquidRouter(0xb7e19a1188776f32E8C2B790D9ca578F2896Da7C); // vSwapRouter
    IValueLiquidFormula public vswapFormula = IValueLiquidFormula(0x45f24BaEef268BB6d63AEe5129015d69702BCDfa); // vSwap Formula
    mapping(address => mapping(address => address[])) public vswapPaths;

    ISwap public vDollarSwap = ISwap(0x0a7E1964355020F85FED96a6D8eB10baaC457645);

    address public mdgRewardPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);

    address public vswapFarmingPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);
    uint256 public vswapFarmingPoolId = 1;
    address public vswapFarmingPoolLpPairAddress = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB
    address public vbswap = address(0x4f0ed527e8A95ecAA132Af214dFd41F30b361600); // vBSWAP (vSwap farming token)
    address public vbswapToWbnbPair = address(0x8DD39f0a49160cDa5ef1E2a2fA7396EEc7DA8267); // vBSWAP/WBNB 50-50

    address public mdgToWbnbPair = address(0x5D69a0e5E91d1E66459A76Da2a4D8863E97cD90d); // MDG/BUSD 70-30
    address public mdgToBusdPair = address(0xB10C30f83eBb92F5BaEf377168C4bFc9740d903c); // MDG/BUSD 70-30
    address public busdToWbnbPair = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB 50-50

    /* =================== Added variables (need to keep orders for proxy to work) =================== */
    // ....

    /* ========== EVENTS ========== */

    event Initialized(address indexed executor, uint256 at);
    event SwapToken(address inputToken, address outputToken, uint256 amount, uint256 amountReceived);
    event BurnToken(address token, uint256 amount);
    event RemoveLpPair(address pair, uint256 amount);
    event GetBackTokenFromProtocol(address token, uint256 amount);
    event ExecuteTransaction(address indexed target, uint256 value, string signature, bytes data);

    /* ========== Modifiers =============== */

    modifier onlyOperator() {
        require(operator == msg.sender, "!operator");
        _;
    }

    modifier onlyStrategist() {
        require(strategist == msg.sender || operator == msg.sender, "!strategist");
        _;
    }

    modifier notInitialized() {
        require(!initialized, "initialized");
        _;
    }

    modifier checkPublicAllow() {
        require(publicAllowed || msg.sender == operator, "!operator nor !publicAllowed");
        _;
    }

    /* ========== GOVERNANCE ========== */

    function initialize(
        address _mdg,
        address _wbnb,
        address _busd,
        address _vdollar,
        IUniswapV2Router _pancakeRouter,
        IValueLiquidRouter _vswapRouter,
        IValueLiquidFormula _vswapFormula,
        ISwap _vDollarSwap
    ) public notInitialized {
        mdg = _mdg;
        wbnb = _wbnb;
        busd = _busd;
        vdollar = _vdollar;
        pancakeRouter = _pancakeRouter;
        vswapRouter = _vswapRouter;
        vswapFormula = _vswapFormula;
        vDollarSwap = _vDollarSwap;

        mdg = address(0xC1eDCc306E6faab9dA629efCa48670BE4678779D);
        wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
        busd = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        vdollar = address(0x3F6ad3c13E3a6bB5655F09A95cA05B6FF4c3DCd6);

        vlpPairsToRemove = new address[](2);
        vlpPairsToRemove[0] = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // WBNB-BUSD 50/50 Value LP
        vlpPairsToRemove[1] = address(0xeDD5a7b494abDe6C07B0c36775E3372f940e59b3); // bCash-BUSD 70/30 Value LP

        cakePairsToRemove = new address[](3);
        cakePairsToRemove[0] = address(0xA527a61703D82139F8a06Bc30097cC9CAA2df5A6); // CAKE/BNB
        cakePairsToRemove[1] = address(0x99d865Ed50D2C32c1493896810FA386c1Ce81D91); // ETH/BETH
        cakePairsToRemove[2] = address(0xD65F81878517039E39c359434d8D8bD46CC4531F); // MDO/BUSD

        mdgPriceToSell = 8 ether; // 8 BNB (~$2000)
        mdgPriceToBuy = 2 ether; // 2 BNB (~$500)

        balancePercents = [50, 450, 9500]; // MDG (0.5%), WBNB (90%), BUSD (4.5%) for rebalance target
        contractionPercents = [7000, 10, 2990]; // MDG (60%), WBNB (3.9%), BUSD (1%) for buying back MDG
        maxAmountToTrade[mdg] = 0.5 ether; // sell up to 0.5 MDG each time
        maxAmountToTrade[wbnb] = 10 ether; // sell up to 10 BNB each time
        maxAmountToTrade[busd] = 2500 ether; // sell up to 2500 BUSD each time

        mdgRewardPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);

        vswapFarmingPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);
        vswapFarmingPoolId = 1;
        vswapFarmingPoolLpPairAddress = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB
        vbswap = address(0x4f0ed527e8A95ecAA132Af214dFd41F30b361600); // vBSWAP (vSwap farming token)
        vbswapToWbnbPair = address(0x8DD39f0a49160cDa5ef1E2a2fA7396EEc7DA8267); // vBSWAP/WBNB 50-50

        mdgToWbnbPair = address(0x5D69a0e5E91d1E66459A76Da2a4D8863E97cD90d); // MDG/BUSD 70-30
        mdgToBusdPair = address(0xB10C30f83eBb92F5BaEf377168C4bFc9740d903c); // MDG/BUSD 70-30
        busdToWbnbPair = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB 50-50

        vswapPaths[wbnb][busd] = [busdToWbnbPair];
        vswapPaths[busd][wbnb] = [busdToWbnbPair];

        vswapPaths[mdg][wbnb] = [mdgToWbnbPair];
        vswapPaths[wbnb][mdg] = [mdgToWbnbPair];

        vswapPaths[mdg][busd] = [mdgToBusdPair];
        vswapPaths[busd][mdg] = [mdgToBusdPair];

        vswapPaths[vbswap][wbnb] = [vbswapToWbnbPair];
        vswapPaths[wbnb][vbswap] = [vbswapToWbnbPair];

        publicAllowed = true;
        initialized = true;
        operator = msg.sender;
        emit Initialized(msg.sender, block.number);
    }

    function setOperator(address _operator) external onlyOperator {
        operator = _operator;
    }

    function setStrategist(address _strategist) external onlyOperator {
        strategist = _strategist;
    }

    function setVswapFarmingPool(
        IValueLiquidRouter _vswapRouter,
        address _vswapFarmingPool,
        uint256 _vswapFarmingPoolId,
        address _vswapFarmingPoolLpPairAddress,
        address _vbswap,
        address _vbswapToWbnbPair
    ) external onlyOperator {
        vswapRouter = _vswapRouter;
        vswapFarmingPool = _vswapFarmingPool;
        vswapFarmingPoolId = _vswapFarmingPoolId;
        vswapFarmingPoolLpPairAddress = _vswapFarmingPoolLpPairAddress;
        vbswap = _vbswap;
        vbswapToWbnbPair = _vbswapToWbnbPair;
    }

    function setMdgFarmingPool(
        address _mdgRewardPool,
        address _mdg,
        address _mdgToWbnbPair
    ) external onlyOperator {
        mdgRewardPool = _mdgRewardPool;
        mdg = _mdg;
        mdgToWbnbPair = _mdgToWbnbPair;
    }

    function setVswapPaths(
        address _inputToken,
        address _outputToken,
        address[] memory _path
    ) external onlyOperator {
        delete vswapPaths[_inputToken][_outputToken];
        vswapPaths[_inputToken][_outputToken] = _path;
    }

    function setVlpPairsToRemove(address[] memory _vlpPairsToRemove) external onlyOperator {
        delete vlpPairsToRemove;
        vlpPairsToRemove = _vlpPairsToRemove;
    }

    function addVlpPairToRemove(address _pair) external onlyOperator {
        vlpPairsToRemove.push(_pair);
    }

    function setCakePairsToRemove(address[] memory _cakePairsToRemove) external onlyOperator {
        delete cakePairsToRemove;
        cakePairsToRemove = _cakePairsToRemove;
    }

    function addCakePairToRemove(address _pair) external onlyOperator {
        cakePairsToRemove.push(_pair);
    }

    function setPublicAllowed(bool _publicAllowed) external onlyStrategist {
        publicAllowed = _publicAllowed;
    }

    function setBalancePercents(
        uint256 _mdgPercent,
        uint256 _wbnbPercent,
        uint256 _busdPercent
    ) external onlyStrategist {
        require(_mdgPercent.add(_wbnbPercent).add(_busdPercent) == 10000, "!100%");
        balancePercents[0] = _mdgPercent;
        balancePercents[1] = _wbnbPercent;
        balancePercents[2] = _busdPercent;
    }

    function setContractionPercents(
        uint256 _mdgPercent,
        uint256 _wbnbPercent,
        uint256 _busdPercent
    ) external onlyStrategist {
        require(_mdgPercent.add(_wbnbPercent).add(_busdPercent) == 10000, "!100%");
        contractionPercents[0] = _mdgPercent;
        contractionPercents[1] = _wbnbPercent;
        contractionPercents[2] = _busdPercent;
    }

    function setMaxAmountToTrade(
        uint256 _mdgAmount,
        uint256 _wbnbAmount,
        uint256 _busdAmount
    ) external onlyStrategist {
        maxAmountToTrade[mdg] = _mdgAmount;
        maxAmountToTrade[wbnb] = _wbnbAmount;
        maxAmountToTrade[busd] = _busdAmount;
    }

    function setMdgPriceToSell(uint256 _mdgPriceToSell) external onlyStrategist {
        require(_mdgPriceToSell >= 2 ether && _mdgPriceToSell <= 100 ether, "out of range"); // [2, 100] BNB
        mdgPriceToSell = _mdgPriceToSell;
    }

    function setMdgPriceToBuy(uint256 _mdgPriceToBuy) external onlyStrategist {
        require(_mdgPriceToBuy >= 0.5 ether && _mdgPriceToBuy <= 10 ether, "out of range"); // [0.5, 10] BNB
        mdgPriceToBuy = _mdgPriceToBuy;
    }

    function setPancakeswapPath(
        address _input,
        address _output,
        address[] memory _path
    ) external onlyStrategist {
        pancakeswapPaths[_input][_output] = _path;
    }

    function grandFund(
        address _token,
        uint256 _amount,
        address _to
    ) external onlyOperator {
        IERC20(_token).transfer(_to, _amount);
    }

    /* ========== VIEW FUNCTIONS ========== */

    function tokenBalances()
        public
        view
        returns (
            uint256 _mdgBal,
            uint256 _wbnbBal,
            uint256 _busdBal,
            uint256 _totalBal
        )
    {
        _mdgBal = IERC20(mdg).balanceOf(address(this));
        _wbnbBal = IERC20(wbnb).balanceOf(address(this));
        _busdBal = IERC20(busd).balanceOf(address(this));
        _totalBal = _mdgBal.add(_wbnbBal).add(_busdBal);
    }

    function tokenPercents()
        public
        view
        returns (
            uint256 _mdgPercent,
            uint256 _wbnbPercent,
            uint256 _busdPercent
        )
    {
        (uint256 _mdgBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
        if (_totalBal > 0) {
            _mdgPercent = _mdgBal.mul(10000).div(_totalBal);
            _wbnbPercent = _wbnbBal.mul(10000).div(_totalBal);
            _busdPercent = _busdBal.mul(10000).div(_totalBal);
        }
    }

    function exchangeRate(
        address _inputToken,
        address _outputToken,
        uint256 _tokenAmount
    ) public view returns (uint256) {
        uint256[] memory amounts = vswapFormula.getAmountsOut(_inputToken, _outputToken, _tokenAmount, vswapPaths[_inputToken][_outputToken]);
        return amounts[amounts.length - 1];
    }

    function getMdgToBnbPrice() public view returns (uint256) {
        return exchangeRate(mdg, wbnb, 1 ether);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function rebalance() public checkPublicAllow {
        uint256 _mdgPrice = getMdgToBnbPrice();
        if (_mdgPrice >= mdgPriceToSell) {
            // expansion: sell MDG
            (uint256 _mdgBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
            if (_totalBal > 0) {
                uint256 _mdgPercent = _mdgBal.mul(10000).div(_totalBal);
                uint256 _wbnbPercent = _wbnbBal.mul(10000).div(_totalBal);
                uint256 _busdPercent = _busdBal.mul(10000).div(_totalBal);
                if (_mdgPercent > balancePercents[0]) {
                    uint256 _sellingMdg = _mdgBal.mul(_mdgPercent.sub(balancePercents[0])).div(10000);
                    if (_wbnbPercent >= balancePercents[1]) {
                        // enough WBNB
                        if (_busdPercent < balancePercents[2]) {
                            // short of BUSD: buy BUSD
                            _vswapSwapToken(mdg, busd, _sellingMdg);
                        } else {
                            if (_wbnbPercent.sub(balancePercents[1]) <= _busdPercent.sub(balancePercents[2])) {
                                // has more BUSD than WBNB: buy WBNB
                                _vswapSwapToken(mdg, wbnb, _sellingMdg);
                            } else {
                                // has more WBNB than BUSD: buy BUSD
                                _vswapSwapToken(mdg, busd, _sellingMdg);
                            }
                        }
                    } else {
                        // short of WBNB
                        if (_busdPercent >= balancePercents[2]) {
                            // enough BUSD: buy WBNB
                            _vswapSwapToken(mdg, wbnb, _sellingMdg);
                        } else {
                            // short of BUSD
                            uint256 _sellingMdgToWbnb = _sellingMdg.mul(95).div(100); // 95% to WBNB
                            _vswapSwapToken(mdg, wbnb, _sellingMdgToWbnb);
                            _vswapSwapToken(mdg, busd, _sellingMdg.sub(_sellingMdgToWbnb));
                        }
                    }
                }
            }
        }
    }

    function checkContraction() public checkPublicAllow {
        uint256 _mdgPrice = getMdgToBnbPrice();
        if (_mdgPrice <= mdgPriceToBuy && (msg.sender == operator || msg.sender == strategist)) {
            // contraction: buy MDG
            (uint256 _mdgBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
            if (_totalBal > 0) {
                uint256 _mdgPercent = _mdgBal.mul(10000).div(_totalBal);
                if (_mdgPercent < contractionPercents[0]) {
                    uint256 _wbnbPercent = _wbnbBal.mul(10000).div(_totalBal);
                    uint256 _busdPercent = _busdBal.mul(10000).div(_totalBal);
                    uint256 _before = IERC20(mdg).balanceOf(address(this));
                    if (_wbnbPercent >= contractionPercents[1]) {
                        // enough WBNB
                        if (_busdPercent >= contractionPercents[2] && _busdPercent.sub(contractionPercents[2]) > _wbnbPercent.sub(contractionPercents[1])) {
                            // enough BUSD and has more BUSD than WBNB: sell BUSD
                            uint256 _sellingBusd = _busdBal.mul(_busdPercent.sub(contractionPercents[2])).div(10000);
                            _vswapSwapToken(busd, mdg, _sellingBusd);
                        } else {
                            // not enough BUSD or has less BUSD than WBNB: sell WBNB
                            uint256 _sellingWbnb = _wbnbBal.mul(_wbnbPercent.sub(contractionPercents[1])).div(10000);
                            _vswapSwapToken(wbnb, mdg, _sellingWbnb);
                        }
                    } else {
                        // short of WBNB
                        if (_busdPercent > contractionPercents[2]) {
                            // enough BUSD: sell BUSD
                            uint256 _sellingBusd = _busdBal.mul(_busdPercent.sub(contractionPercents[2])).div(10000);
                            _vswapSwapToken(busd, mdg, _sellingBusd);
                        }
                    }
                    uint256 _after = IERC20(mdg).balanceOf(address(this));
                    uint256 _bought = _after.sub(_before);
                    if (_bought > 0) {
                        IBurnabledERC20(mdg).burn(_bought);
                        emit BurnToken(mdg, _bought);
                    }
                }
            }
        }
    }

    function removeVlpPairs() public checkPublicAllow {
        uint256 _length = vlpPairsToRemove.length;
        for (uint256 i = 0; i < _length; i++) {
            address _pair = vlpPairsToRemove[i];
            uint256 _bal = IERC20(_pair).balanceOf(address(this));
            if (_bal > 0) {
                _vswapRemoveLiquidity(_pair, _bal);
                emit RemoveLpPair(_pair, _bal);
            }
        }
    }

    function removeCakePairs() public checkPublicAllow {
        uint256 _length = cakePairsToRemove.length;
        for (uint256 i = 0; i < _length; i++) {
            address _pair = cakePairsToRemove[i];
            uint256 _bal = IERC20(_pair).balanceOf(address(this));
            if (_bal > 0) {
                _cakeRemoveLiquidity(_pair, _bal);
                emit RemoveLpPair(_pair, _bal);
            }
        }
    }

    function workForReserveFund() external checkPublicAllow {
        rebalance();
        checkContraction();
        claimAndBuyBackMdgFromVswapPool();
        removeVlpPairs();
        removeCakePairs();
    }

    function buyBackAndBurn(address _token, uint256 _amount) public onlyStrategist {
        uint256 _before = IERC20(mdg).balanceOf(address(this));
        _vswapSwapToken(_token, mdg, _amount);
        uint256 _after = IERC20(mdg).balanceOf(address(this));
        uint256 _bought = _after.sub(_before);
        if (_bought > 0) {
            IBurnabledERC20(mdg).burn(_bought);
            emit BurnToken(mdg, _bought);
        }
    }

    function forceSell(address _buyingToken, uint256 _mdgAmount) external onlyStrategist {
        require(getMdgToBnbPrice() >= mdgPriceToBuy, "price is too low to sell");
        _vswapSwapToken(mdg, _buyingToken, _mdgAmount);
    }

    function forceBuy(address _sellingToken, uint256 _sellingAmount) external onlyStrategist {
        require(getMdgToBnbPrice() <= mdgPriceToSell, "price is too high to buy");
        _vswapSwapToken(_sellingToken, mdg, _sellingAmount);
    }

    function trimNonCoreToken(address _sellingToken) public onlyStrategist {
        require(_sellingToken != mdg && _sellingToken != busd && _sellingToken != wbnb, "core");
        uint256 _bal = IERC20(_sellingToken).balanceOf(address(this));
        if (_bal > 0) {
            _vswapSwapToken(_sellingToken, mdg, _bal);
        }
    }

    /* ========== FARM VSWAP POOL: STAKE BUSD/WBNB EARN VBSWAP ========== */

    function depositToVswapPool(uint256 _busdAmount, uint256 _wbnbAmount) external onlyStrategist {
        address _lpAdd = vswapFarmingPoolLpPairAddress;
        _vswapAddLiquidity(_lpAdd, busd, wbnb, _busdAmount, _wbnbAmount);
        uint256 _lpBal = IERC20(_lpAdd).balanceOf(address(this));
        require(_lpBal > 0, "!_lpBal");
        address _vswapFarmingPool = vswapFarmingPool;
        IERC20(_lpAdd).safeIncreaseAllowance(_vswapFarmingPool, _lpBal);
        IRewardPool(_vswapFarmingPool).deposit(vswapFarmingPoolId, _lpBal);
    }

    function withdrawFromVswapPool(uint256 _lpAmount) public onlyStrategist {
        IRewardPool(vswapFarmingPool).withdraw(vswapFarmingPoolId, _lpAmount);
    }

    function exitVswapPool() public onlyStrategist {
        (uint256 _stakedAmount, ) = IRewardPool(vswapFarmingPool).userInfo(vswapFarmingPoolId, address(this));
        withdrawFromVswapPool(_stakedAmount);
    }

    function claimAndBuyBackMdgFromVswapPool() public {
        IRewardPool(vswapFarmingPool).withdraw(vswapFarmingPoolId, 0);
        uint256 _vbswapBal = IERC20(vbswap).balanceOf(address(this));
        if (_vbswapBal > 0) {
            uint256 _wbnbBef = IERC20(wbnb).balanceOf(address(this));
            _vswapSwapToken(vbswap, wbnb, _vbswapBal);
            uint256 _wbnbAft = IERC20(wbnb).balanceOf(address(this));
            uint256 _boughtWbnb = _wbnbAft.sub(_wbnbBef);
            if (_boughtWbnb >= 2) {
                _vswapSwapToken(wbnb, mdg, _boughtWbnb);
            }
        }
    }

    /* ========== FARM MDG REWARD POOL: EARN MDG AND BURN ========== */

    function depositToMdgPool(
        uint256 _pid,
        address _lpAdd,
        uint256 _amount
    ) external onlyStrategist {
        IERC20(_lpAdd).safeIncreaseAllowance(mdgRewardPool, _amount);
        IMdgRewardPool(mdgRewardPool).deposit(_pid, _amount);
    }

    function withdrawFromMdgPool(uint256 _pid, uint256 _amount) public onlyStrategist {
        IMdgRewardPool(mdgRewardPool).withdraw(_pid, _amount);
    }

    function exitMdgPool(uint256 _pid) public onlyStrategist {
        (uint256 _stakedAmount, , , ) = IMdgRewardPool(mdgRewardPool).userInfo(_pid, address(this));
        withdrawFromMdgPool(_pid, _stakedAmount);
    }

    function claimAndBurnFromMdgPool(uint256 _pid) public {
        uint256 _mdgBef = IERC20(mdg).balanceOf(address(this));
        IMdgRewardPool(mdgRewardPool).withdraw(_pid, 0);
        uint256 _mdgAft = IERC20(mdg).balanceOf(address(this));
        uint256 _claimedMdg = _mdgAft.sub(_mdgBef);
        if (_claimedMdg > 0) {
            IBurnabledERC20(mdg).burn(_claimedMdg);
            emit BurnToken(mdg, _claimedMdg);
        }
    }

    function pendingFromMdgPool(uint256 _pid) public view returns (uint256) {
        return IMdgRewardPool(mdgRewardPool).pendingReward(_pid, address(this));
    }

    function stakeAmountFromMdgPool(uint256 _pid) public view returns (uint256 _stakedAmount) {
        (_stakedAmount, , , ) = IMdgRewardPool(mdgRewardPool).userInfo(_pid, address(this));
    }

    /* ========== VSWAPROUTER: SWAP & ADD LP & REMOVE LP ========== */

    function _vswapSwapToken(
        address _inputToken,
        address _outputToken,
        uint256 _amount
    ) internal {
        IERC20(_inputToken).safeIncreaseAllowance(address(vswapRouter), _amount);
        uint256[] memory amountReceiveds = vswapRouter.swapExactTokensForTokens(_inputToken, _outputToken, _amount, 1, vswapPaths[_inputToken][_outputToken], address(this), block.timestamp.add(60));
        emit SwapToken(_inputToken, _outputToken, _amount, amountReceiveds[amountReceiveds.length - 1]);
    }

    function _vswapAddLiquidity(
        address _pair,
        address _tokenA,
        address _tokenB,
        uint256 _amountADesired,
        uint256 _amountBDesired
    ) internal {
        IERC20(_tokenA).safeIncreaseAllowance(address(vswapRouter), _amountADesired);
        IERC20(_tokenB).safeIncreaseAllowance(address(vswapRouter), _amountBDesired);
        vswapRouter.addLiquidity(_pair, _tokenA, _tokenB, _amountADesired, _amountBDesired, 0, 0, address(this), block.timestamp.add(60));
    }

    function _vswapRemoveLiquidity(address _pair, uint256 _liquidity) internal {
        address _tokenA = IValueLiquidPair(_pair).token0();
        address _tokenB = IValueLiquidPair(_pair).token1();
        IERC20(_pair).safeIncreaseAllowance(address(vswapRouter), _liquidity);
        vswapRouter.removeLiquidity(_pair, _tokenA, _tokenB, _liquidity, 1, 1, address(this), block.timestamp.add(60));
    }

    function _cakeRemoveLiquidity(address _pair, uint256 _liquidity) internal {
        address _tokenA = IValueLiquidPair(_pair).token0();
        address _tokenB = IValueLiquidPair(_pair).token1();
        IERC20(_pair).safeIncreaseAllowance(address(pancakeRouter), _liquidity);
        pancakeRouter.removeLiquidity(_tokenA, _tokenB, _liquidity, 1, 1, address(this), now.add(60));
    }

    /* ========== EMERGENCY ========== */

    function executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data
    ) public onlyOperator returns (bytes memory) {
        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solium-disable-next-line security/no-call-value
        (bool success, bytes memory returnData) = target.call{value: value}(callData);
        require(success, string("ReserveFund::executeTransaction: Transaction execution reverted."));

        emit ExecuteTransaction(target, value, signature, data);

        return returnData;
    }

    receive() external payable {}
}