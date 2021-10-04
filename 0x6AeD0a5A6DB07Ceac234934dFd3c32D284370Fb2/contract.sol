// SPDX-License-Identifier: MIT

pragma abicoder v2;
pragma solidity 0.7.6;

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

    function pendingCake(uint256 _pid, address _user) external view returns (uint256);

    function pendingReward(uint256 _pid, address _user) external view returns (uint256);

    function userInfo(uint256 _pid, address _user) external view returns (uint256 amount, uint256 rewardDebt);
}

interface IBurnabledERC20 {
    function burn(uint256) external;
}

interface IProtocolFeeRemover {
    function transfer(address _token, uint256 _value) external;

    function remove(address[] calldata pairs) external;
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
    uint256 public vbswapPriceToSell; // to rebalance if price is high
    uint256 public vbswapPriceToBuy; // to rebalance if price is low

    uint256[] public balancePercents; // vBSWAP, WBNB and BUSD portfolio percentage
    uint256[] public contractionPercents; // vBSWAP, WBNB and BUSD portfolio when buyback vBSWAP

    mapping(address => uint256) public maxAmountToTrade; // vBSWAP, WBNB, BUSD

    address public vbswap = address(0x4f0ed527e8A95ecAA132Af214dFd41F30b361600);
    address public wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address public busd = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

    IProtocolFeeRemover public protocolFeeRemover = IProtocolFeeRemover(0x85f94c7c3BA0841Aff76c7539349816B856B3fEA);
    address[] public protocolFeePairsToRemove;

    // Pancakeswap
    IUniswapV2Router public pancakeRouter = IUniswapV2Router(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    mapping(address => mapping(address => address[])) public uniswapPaths;

    IValueLiquidRouter public vswapRouter = IValueLiquidRouter(0xb7e19a1188776f32E8C2B790D9ca578F2896Da7C); // vSwapRouter
    IValueLiquidFormula public vswapFormula = IValueLiquidFormula(0x45f24BaEef268BB6d63AEe5129015d69702BCDfa); // vSwap Formula
    mapping(address => mapping(address => address[])) public vswapPaths;

    address public vswapFarmingPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);
    uint256 public vswapFarmingPoolId = 1;
    address public vswapFarmingPoolLpPairAddress = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB

    address public vbswapToWbnbPair = address(0x8DD39f0a49160cDa5ef1E2a2fA7396EEc7DA8267); // vBSWAP/WBNB 50-50
    address public busdToWbnbPair = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB 50-50

    /* =================== Added variables (need to keep orders for proxy to work) =================== */
    // ....

    /* ========== EVENTS ========== */

    event Initialized(address indexed executor, uint256 at);
    event SwapToken(address inputToken, address outputToken, uint256 amount, uint256 amountReceived);
    event BurnToken(address token, uint256 amount);
    event CollectFeeFromProtocol(address[] pairs);
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
        address _vbswap,
        address _wbnb,
        address _busd,
        IProtocolFeeRemover _protocolFeeRemover,
        IUniswapV2Router _pancakeRouter,
        IValueLiquidRouter _vswapRouter,
        IValueLiquidFormula _vswapFormula
    ) public notInitialized {
        vbswap = _vbswap;
        wbnb = _wbnb;
        busd = _busd;
        protocolFeeRemover = _protocolFeeRemover;
        pancakeRouter = _pancakeRouter;
        vswapRouter = _vswapRouter;
        vswapFormula = _vswapFormula;

        vbswapPriceToSell = 55 ether; // 55 BNB (~$12.5k)
        vbswapPriceToBuy = 45 ether; // 45 BNB (~$10k)

        balancePercents = [50, 9500, 450]; // vbswap (0.5%), WBNB (90%), BUSD (4.5%) for rebalance target
        contractionPercents = [6000, 3900, 100]; // vbswap (60%), WBNB (3.9%), BUSD (1%) for buying back vBSWAP
        maxAmountToTrade[vbswap] = 0.1 ether; // sell up to 0.1 vBSWAP each time
        maxAmountToTrade[wbnb] = 10 ether; // sell up to 10 BNB each time
        maxAmountToTrade[busd] = 1000 ether; // sell up to 1000 BUSD each time

        vswapFarmingPool = address(0xd56339F80586c08B7a4E3a68678d16D37237Bd96);
        vswapFarmingPoolId = 1;
        vswapFarmingPoolLpPairAddress = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB

        vbswapToWbnbPair = address(0x8DD39f0a49160cDa5ef1E2a2fA7396EEc7DA8267); // vBSWAP/WBNB 50-50
        busdToWbnbPair = address(0x522361C3aa0d81D1726Fa7d40aA14505d0e097C9); // BUSD/WBNB 50-50

        vswapPaths[wbnb][busd] = [busdToWbnbPair];
        vswapPaths[busd][wbnb] = [busdToWbnbPair];

        vswapPaths[vbswap][wbnb] = [vbswapToWbnbPair];
        vswapPaths[wbnb][vbswap] = [vbswapToWbnbPair];

        vswapPaths[vbswap][busd] = [vbswapToWbnbPair, busdToWbnbPair];
        vswapPaths[busd][vbswap] = [busdToWbnbPair, vbswapToWbnbPair];

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

    function setVswapPaths(
        address _inputToken,
        address _outputToken,
        address[] memory _path
    ) external onlyOperator {
        delete vswapPaths[_inputToken][_outputToken];
        vswapPaths[_inputToken][_outputToken] = _path;
    }

    function setProtocolFeeRemover(IProtocolFeeRemover _protocolFeeRemover) external onlyOperator {
        protocolFeeRemover = _protocolFeeRemover;
    }

    function setProtocolFeePairsToRemove(address[] memory _protocolFeePairsToRemove) external onlyOperator {
        delete protocolFeePairsToRemove;
        protocolFeePairsToRemove = _protocolFeePairsToRemove;
    }

    function addProtocolFeePairToRemove(address _pair) external onlyOperator {
        protocolFeePairsToRemove.push(_pair);
    }

    function setPublicAllowed(bool _publicAllowed) external onlyStrategist {
        publicAllowed = _publicAllowed;
    }

    function setBalancePercents(
        uint256 _vbswapPercent,
        uint256 _wbnbPercent,
        uint256 _busdPercent
    ) external onlyStrategist {
        require(_vbswapPercent.add(_wbnbPercent).add(_busdPercent) == 10000, "!100%");
        balancePercents[0] = _vbswapPercent;
        balancePercents[1] = _wbnbPercent;
        balancePercents[2] = _busdPercent;
    }

    function setContractionPercents(
        uint256 _vbswapPercent,
        uint256 _wbnbPercent,
        uint256 _busdPercent
    ) external onlyStrategist {
        require(_vbswapPercent.add(_wbnbPercent).add(_busdPercent) == 10000, "!100%");
        contractionPercents[0] = _vbswapPercent;
        contractionPercents[1] = _wbnbPercent;
        contractionPercents[2] = _busdPercent;
    }

    function setMaxAmountToTrade(
        uint256 _vbswapAmount,
        uint256 _wbnbAmount,
        uint256 _busdAmount
    ) external onlyStrategist {
        maxAmountToTrade[vbswap] = _vbswapAmount;
        maxAmountToTrade[wbnb] = _wbnbAmount;
        maxAmountToTrade[busd] = _busdAmount;
    }

    function setVbswapPriceToSell(uint256 _vbswapPriceToSell) external onlyStrategist {
        require(_vbswapPriceToSell >= 20 ether && _vbswapPriceToSell <= 200 ether, "out of range"); // [40, 200] BNB
        vbswapPriceToSell = _vbswapPriceToSell;
    }

    function setVbswapPriceToBuy(uint256 _vbswapPriceToBuy) external onlyStrategist {
        require(_vbswapPriceToBuy >= 10 ether && _vbswapPriceToBuy <= 100 ether, "out of range"); // [10, 100] BNB
        vbswapPriceToBuy = _vbswapPriceToBuy;
    }

    function setUnirouterPath(
        address _input,
        address _output,
        address[] memory _path
    ) external onlyStrategist {
        uniswapPaths[_input][_output] = _path;
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
            uint256 _vbswapBal,
            uint256 _wbnbBal,
            uint256 _busdBal,
            uint256 _totalBal
        )
    {
        _vbswapBal = IERC20(vbswap).balanceOf(address(this));
        _wbnbBal = IERC20(wbnb).balanceOf(address(this));
        _busdBal = IERC20(busd).balanceOf(address(this));
        _totalBal = _vbswapBal.add(_wbnbBal).add(_busdBal);
    }

    function tokenPercents()
        public
        view
        returns (
            uint256 _vbswapPercent,
            uint256 _wbnbPercent,
            uint256 _busdPercent
        )
    {
        (uint256 _vbswapBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
        if (_totalBal > 0) {
            _vbswapPercent = _vbswapBal.mul(10000).div(_totalBal);
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

    function getVbswapToBnbPrice() public view returns (uint256) {
        return exchangeRate(vbswap, wbnb, 1 ether);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function rebalance() public checkPublicAllow {
        uint256 _vbswapPrice = getVbswapToBnbPrice();
        if (_vbswapPrice >= vbswapPriceToSell) {
            // expansion: sell vBSWAP
            (uint256 _vbswapBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
            if (_totalBal > 0) {
                uint256 _vbswapPercent = _vbswapBal.mul(10000).div(_totalBal);
                uint256 _wbnbPercent = _wbnbBal.mul(10000).div(_totalBal);
                uint256 _busdPercent = _busdBal.mul(10000).div(_totalBal);
                if (_vbswapPercent > balancePercents[0]) {
                    uint256 _sellingVbswap = _vbswapBal.mul(_vbswapPercent.sub(balancePercents[0])).div(10000);
                    if (_wbnbPercent >= balancePercents[1]) {
                        // enough WBNB
                        if (_busdPercent < balancePercents[2]) {
                            // short of BUSD: buy BUSD
                            _vswapSwapToken(vbswap, busd, _sellingVbswap);
                        } else {
                            if (_wbnbPercent.sub(balancePercents[1]) <= _busdPercent.sub(balancePercents[2])) {
                                // has more BUSD than WBNB: buy WBNB
                                _vswapSwapToken(vbswap, wbnb, _sellingVbswap);
                            } else {
                                // has more WBNB than BUSD: buy BUSD
                                _vswapSwapToken(vbswap, busd, _sellingVbswap);
                            }
                        }
                    } else {
                        // short of WBNB
                        if (_busdPercent >= balancePercents[2]) {
                            // enough BUSD: buy WBNB
                            _vswapSwapToken(vbswap, wbnb, _sellingVbswap);
                        } else {
                            // short of BUSD
                            uint256 _sellingVbswapToWbnb = _sellingVbswap.mul(95).div(100); // 95% to WBNB
                            _vswapSwapToken(vbswap, wbnb, _sellingVbswapToWbnb);
                            _vswapSwapToken(vbswap, busd, _sellingVbswap.sub(_sellingVbswapToWbnb));
                        }
                    }
                }
            }
        }
    }

    function checkContraction() public checkPublicAllow {
        uint256 _vbswapPrice = getVbswapToBnbPrice();
        if (_vbswapPrice <= vbswapPriceToBuy && (msg.sender == operator || msg.sender == strategist)) {
            // contraction: buy vBSWAP
            (uint256 _vbswapBal, uint256 _wbnbBal, uint256 _busdBal, uint256 _totalBal) = tokenBalances();
            if (_totalBal > 0) {
                uint256 _vbswapPercent = _vbswapBal.mul(10000).div(_totalBal);
                if (_vbswapPercent < contractionPercents[0]) {
                    uint256 _wbnbPercent = _wbnbBal.mul(10000).div(_totalBal);
                    uint256 _busdPercent = _busdBal.mul(10000).div(_totalBal);
                    uint256 _before = IERC20(vbswap).balanceOf(address(this));
                    if (_wbnbPercent >= contractionPercents[1]) {
                        // enough WBNB
                        if (_busdPercent >= contractionPercents[2] && _busdPercent.sub(contractionPercents[2]) > _wbnbPercent.sub(contractionPercents[1])) {
                            // enough BUSD and has more BUSD than WBNB: sell BUSD
                            uint256 _sellingBusd = _busdBal.mul(_busdPercent.sub(contractionPercents[2])).div(10000);
                            _vswapSwapToken(busd, vbswap, _sellingBusd);
                        } else {
                            // not enough BUSD or has less BUSD than WBNB: sell WBNB
                            uint256 _sellingWbnb = _wbnbBal.mul(_wbnbPercent.sub(contractionPercents[1])).div(10000);
                            _vswapSwapToken(wbnb, vbswap, _sellingWbnb);
                        }
                    } else {
                        // short of WBNB
                        if (_busdPercent > contractionPercents[2]) {
                            // enough BUSD: sell BUSD
                            uint256 _sellingBusd = _busdBal.mul(_busdPercent.sub(contractionPercents[2])).div(10000);
                            _vswapSwapToken(busd, vbswap, _sellingBusd);
                        }
                    }
                    uint256 _after = IERC20(vbswap).balanceOf(address(this));
                    uint256 _bought = _after.sub(_before);
                    if (_bought > 0) {
                        IBurnabledERC20(vbswap).burn(_bought);
                        emit BurnToken(vbswap, _bought);
                    }
                }
            }
        }
    }

    function collectFeeFromProtocol() public checkPublicAllow {
        IProtocolFeeRemover(protocolFeeRemover).remove(protocolFeePairsToRemove);
        emit CollectFeeFromProtocol(protocolFeePairsToRemove);
    }

    function workForReserveFund() external checkPublicAllow {
        rebalance();
        checkContraction();
        claimAndBurnVbswapFromVswapPool();
        collectFeeFromProtocol();
    }

    function getBackTokenFromProtocol(address _token, uint256 _amount) public onlyStrategist {
        IProtocolFeeRemover(protocolFeeRemover).transfer(_token, _amount);
        emit GetBackTokenFromProtocol(_token, _amount);
    }

    function buyBackAndBurn(address _token, uint256 _amount) public onlyStrategist {
        uint256 _before = IERC20(vbswap).balanceOf(address(this));
        _vswapSwapToken(_token, vbswap, _amount);
        uint256 _after = IERC20(vbswap).balanceOf(address(this));
        uint256 _bought = _after.sub(_before);
        if (_bought > 0) {
            IBurnabledERC20(vbswap).burn(_bought);
            emit BurnToken(vbswap, _bought);
        }
    }

    function forceSell(address _buyingToken, uint256 _vbswapAmount) external onlyStrategist {
        require(getVbswapToBnbPrice() >= vbswapPriceToBuy, "price is too low to sell");
        _vswapSwapToken(vbswap, _buyingToken, _vbswapAmount);
    }

    function forceBuy(address _sellingToken, uint256 _sellingAmount) external onlyStrategist {
        require(getVbswapToBnbPrice() <= vbswapPriceToSell, "price is too high to buy");
        _vswapSwapToken(_sellingToken, vbswap, _sellingAmount);
    }

    function trimNonCoreToken(address _sellingToken) public onlyStrategist {
        require(_sellingToken != vbswap && _sellingToken != busd && _sellingToken != wbnb, "core");
        uint256 _bal = IERC20(_sellingToken).balanceOf(address(this));
        if (_bal > 0) {
            _vswapSwapToken(_sellingToken, vbswap, _bal);
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
        _vswapRemoveLiquidity(vswapFarmingPoolLpPairAddress, busd, wbnb, _lpAmount);
    }

    function exitVswapPool() public onlyStrategist {
        (uint256 _stakedAmount, ) = IRewardPool(vswapFarmingPool).userInfo(vswapFarmingPoolId, address(this));
        withdrawFromVswapPool(_stakedAmount);
    }

    function claimAndBurnVbswapFromVswapPool() public {
        uint256 _before = IERC20(vbswap).balanceOf(address(this));
        IRewardPool(vswapFarmingPool).withdraw(vswapFarmingPoolId, 0);
        uint256 _after = IERC20(vbswap).balanceOf(address(this));
        uint256 _claimed = _after.sub(_before);
        if (_claimed > 0) {
            IBurnabledERC20(vbswap).burn(_claimed);
            emit BurnToken(vbswap, _claimed);
        }
    }

    function pendingFromVswapPool() public view returns (uint256) {
        return IRewardPool(vswapFarmingPool).pendingReward(vswapFarmingPoolId, address(this));
    }

    function stakeAmountFromVswapPool() public view returns (uint256 _stakedAmount) {
        (_stakedAmount, ) = IRewardPool(vswapFarmingPool).userInfo(vswapFarmingPoolId, address(this));
    }

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

    function _vswapRemoveLiquidity(
        address _pair,
        address _tokenA,
        address _tokenB,
        uint256 _liquidity
    ) internal {
        IERC20(_pair).safeIncreaseAllowance(address(vswapRouter), _liquidity);
        vswapRouter.removeLiquidity(_pair, _tokenA, _tokenB, _liquidity, 1, 1, address(this), block.timestamp.add(60));
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