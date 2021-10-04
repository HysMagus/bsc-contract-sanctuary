// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity >=0.6.0 <0.8.0;

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
abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor() internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view virtual returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

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

// File: @openzeppelin/contracts/math/SafeMath.sol

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

// File: @openzeppelin/contracts/utils/Address.sol

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
    (bool success, bytes memory returndata) = target.call{ value: value }(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
   * but performing a static call.
   *
   * _Available since v3.3._
   */
  function functionStaticCall(address target, bytes memory data)
    internal
    view
    returns (bytes memory)
  {
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

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
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

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
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

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
  event PairCreated(address indexed token0, address indexed token1, address pair, uint256);

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address tokenA, address tokenB) external view returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address tokenA, address tokenB) external returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;
}

// File: contracts/interfaces/IAscensionStrategy.sol

pragma solidity 0.6.8;

interface IAscensionStrategy {
  function validateProposal(address[] calldata targets, uint256[] calldata values)
    external
    returns (bool);

  function executeStrategy(address[] calldata targets, uint256[] calldata values)
    external
    returns (bool);
}

// File: contracts/interfaces/IAscension.sol

pragma solidity 0.6.8;

interface IAscension {
  //ASCEND FUNCTIONS

  function getPriorValue(address account, uint256 blockNumber) external view returns (uint256);

  function getLevel(address account) external view returns (uint256);

  function distributeShares(uint256 tAmount) external;

  function ascensionEvent(
    address payable strategy,
    address[] calldata targets,
    uint256[] calldata values
  ) external;
}

// File: contracts/ASCENSION.sol

pragma solidity 0.6.8;
pragma experimental ABIEncoderV2;

contract ASCENSION is Context, IERC20, IAscension, Ownable {
  using SafeMath for uint256;
  using Address for address;

  struct Checkpoint {
    uint256 fromBlock;
    uint256 value;
  }
  //checkpoints tracks previous balances updated on every transaction
  mapping(address => mapping(uint256 => Checkpoint)) private checkpoints;
  //numCheckpoints tracks the number of checkpoints for each account
  mapping(address => uint256) private numCheckpoints;
  //_shares tracks the total shares of each user, multiplied by rate to calculate token balance
  mapping(address => uint256) private _shares;
  //_tokens tracks balance directly for excluded accounts
  mapping(address => uint256) private _tokens;
  mapping(address => mapping(address => uint256)) private _allowances;

  //excluded addresses dont accumulate or pay fees
  mapping(address => bool) private isExcluded;
  address[] private _excluded;

  //token state variables
  uint256 private constant MAX = ~uint256(0);
  uint256 private constant totalTokens = 14400000 ether;
  uint256 private totalShares = (MAX - (MAX % totalTokens));
  uint256 private tFeeTotal;

  //treasury state variables
  address public uniswapV2Router;
  address public pairToken;
  address public daoAddress;
  uint256 public totalAscensions;
  uint256 public previousAscensionEth;
  uint256 public previousAscensionTimestamp;
  uint256 public ascensionInterval;
  uint256 public ascensionDivisor; //the divisor used to calculate the price increase required for ascension
  uint256 public pullDivisor; //the divisor used to calculate the amount of liquidity called for ascension
  bool public ascensionActive;

  //ERC-20 standard state variables
  string private _name = "Ascension Protocol";
  string private _symbol = "ASCEND";
  uint8 private _decimals = 18;

  //EVENTS-------------------------------------------------------------------------------------------
  event AccountCheckpointUpdated(address account, uint256 oldValue, uint256 newValue);
  event AscensionEvent(
    address strategy,
    uint256 amountETH,
    address[] targets,
    uint256[] values,
    uint256 timestamp
  );
  event AscensionIntervalSet(uint256 interval, uint256 timestamp);
  event DaoAddressSet(address dao, uint256 timestamp);
  event pairTokenSet(address token, uint256 timestamp);
  event RouterSet(address router, uint256 timestamp);
  event SwapAndLiquify(address WETH, uint256 amount, uint256 ethAmount, uint256 otherAmount);

  //CONSTRUCTOR--------------------------------------------------------------------------------------
  constructor(address _uniswapV2Router) public {
    //set router
    uniswapV2Router = _uniswapV2Router;

    pairToken = IUniswapV2Factory(IUniswapV2Router02(uniswapV2Router).factory()).createPair(
      address(this),
      IUniswapV2Router02(uniswapV2Router).WETH()
    );

    address owner = _msgSender();
    _shares[owner] = sharesFromToken(totalTokens, false);
    _addValue(owner, totalTokens);
    emit Transfer(address(this), owner, totalTokens);

    //default values
    ascensionDivisor = 10;
    pullDivisor = 50;
  }

  //RECEIVE ETH FOR LIQUIDITY-------------------------------------------------------------------------
  receive() external payable {}

  //ERC20 BASIC FUNCTIONS-----------------------------------------------------------------------------
  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return totalTokens;
  }

  function balanceOf(address account) public view override returns (uint256) {
    if (isExcluded[account]) return _tokens[account];
    return tokenFromShares(_shares[account]);
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address owner, address spender) public view override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      _msgSender(),
      _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
    );
    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    virtual
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender].sub(
        subtractedValue,
        "ERC20: decreased allowance below zero"
      )
    );
    return true;
  }

  //ASCENSION EXTERNAL FUNCTIONS---------------------------------------------------
  function checkExcluded(address account) external view returns (bool) {
    return isExcluded[account];
  }

  function totalFees() external view returns (uint256) {
    return tFeeTotal;
  }

  function getNumCheckpoints(address account) external view returns (uint256) {
    return numCheckpoints[account];
  }

  function getPriorValue(address account, uint256 blockNumber)
    external
    view
    override
    returns (uint256)
  {
    require(blockNumber < block.number, "ASCENSION:getPriorValue: not yet determined");

    uint256 nCheckpoints = numCheckpoints[account];
    if (nCheckpoints == 0) {
      return 0;
    }

    // First check most recent balance
    if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
      return checkpoints[account][nCheckpoints - 1].value;
    }

    // Next check implicit zero balance
    if (checkpoints[account][0].fromBlock > blockNumber) {
      return 0;
    }

    uint256 lower = 0;
    uint256 upper = nCheckpoints - 1;
    while (upper > lower) {
      uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
      Checkpoint memory cp = checkpoints[account][center];
      if (cp.fromBlock == blockNumber) {
        return cp.value;
      } else if (cp.fromBlock < blockNumber) {
        lower = center;
      } else {
        upper = center - 1;
      }
    }
    return checkpoints[account][lower].value;
  }

  function getLevel(address account) external view override returns (uint256) {
    if (balanceOf(account) >= 1000000 * (10**18)) {
      return 9;
    } else if (balanceOf(account) >= 500000 * (10**18)) {
      return 8;
    } else if (balanceOf(account) >= 320000 * (10**18)) {
      return 7;
    } else if (balanceOf(account) >= 160000 * (10**18)) {
      return 6;
    } else if (balanceOf(account) >= 80000 * (10**18)) {
      return 5;
    } else if (balanceOf(account) >= 40000 * (10**18)) {
      return 4;
    } else if (balanceOf(account) >= 20000 * (10**18)) {
      return 3;
    } else if (balanceOf(account) >= 10000 * (10**18)) {
      return 2;
    } else if (balanceOf(account) >= 1000 * (10**18)) {
      return 1;
    } else {
      return 0;
    }
  }

  function distributeShares(uint256 tAmount) external override {
    address sender = _msgSender();
    require(
      !isExcluded[sender],
      "ASCENSION:distributeShares: Excluded addresses cannot call this function"
    );
    (uint256 sAmount, , , , ) = _getValues(sender, tAmount);
    //subtract shares from sender
    _shares[sender] = _shares[sender].sub(sAmount);
    //update checkpoint
    _subValue(sender, tAmount);
    //subtract shares from total to distribute
    totalShares = totalShares.sub(sAmount);
    //add tAmount to total fees tFeeTotal
    tFeeTotal = tFeeTotal.add(tAmount);
  }

  function sharesFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
    require(tAmount <= totalTokens, "ASCENSION:sharesFromToken: Amount must be less than supply");
    address sender = _msgSender();
    if (!deductTransferFee) {
      (uint256 sAmount, , , , ) = _getValues(sender, tAmount);
      return sAmount;
    } else {
      (, uint256 sTransferAmount, , , ) = _getValues(sender, tAmount);
      return sTransferAmount;
    }
  }

  function tokenFromShares(uint256 sAmount) public view returns (uint256) {
    require(
      sAmount <= totalShares,
      "ASCENSION:tokenFromShares: Amount must be less than total reflections"
    );
    uint256 currentRate = _getRate();
    return sAmount.div(currentRate);
  }

  function includeAccount(address account) external onlyOwner() {
    require(isExcluded[account], "ASCENSION:includeAccount: Account is already included");
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_excluded[i] == account) {
        _excluded[i] = _excluded[_excluded.length - 1];
        _tokens[account] = 0;
        isExcluded[account] = false;
        _excluded.pop();
        break;
      }
    }
  }

  function excludeAccount(address account) external onlyOwner() {
    require(!isExcluded[account], "ASCENSION:excludeAccount: Account is already excluded");
    if (_shares[account] > 0) {
      _tokens[account] = tokenFromShares(_shares[account]);
    }
    isExcluded[account] = true;
    _excluded.push(account);
  }

  //ASCENSION INTERNAL FUNCTIONS---------------------------------------------------
  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) private {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) private {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    require(sender != recipient, "ERC20: transfer to self disallowed");
    require(amount > 0, "Transfer amount must be greater than zero");

    if (isExcluded[sender] && !isExcluded[recipient]) {
      _transferFromExcluded(sender, recipient, amount);
    } else if (!isExcluded[sender] && isExcluded[recipient]) {
      _transferToExcluded(sender, recipient, amount);
    } else if (!isExcluded[sender] && !isExcluded[recipient]) {
      _transferStandard(sender, recipient, amount);
    } else if (isExcluded[sender] && isExcluded[recipient]) {
      _transferBothExcluded(sender, recipient, amount);
    } else {
      _transferStandard(sender, recipient, amount);
    }
  }

  function _transferStandard(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 sAmount,
      uint256 sTransferAmount,
      uint256 sFee,
      uint256 tTransferAmount,
      uint256 tFee
    ) = _getValues(sender, tAmount);
    //update shares balances
    _shares[sender] = _shares[sender].sub(sAmount);
    _shares[recipient] = _shares[recipient].add(sTransferAmount);
    //update checkpoints
    _subValue(sender, tAmount);
    _addValue(recipient, tTransferAmount);
    //distribute fee to all users
    _distributeFee(sFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _transferToExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 sAmount,
      uint256 sTransferAmount,
      uint256 sFee,
      uint256 tTransferAmount,
      uint256 tFee
    ) = _getValues(sender, tAmount);
    //update token balance for excluded account
    _tokens[recipient] = _tokens[recipient].add(tTransferAmount);
    //update shares balance
    _shares[sender] = _shares[sender].sub(sAmount);
    _shares[recipient] = _shares[recipient].add(sTransferAmount);
    //update checkpoints
    _subValue(sender, tAmount);
    _addValue(recipient, tTransferAmount);
    //distribute fee to all users
    _distributeFee(sFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _transferFromExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (uint256 sAmount, , , , ) = _getValues(sender, tAmount);
    //update token balance for excluded account
    _tokens[sender] = _tokens[sender].sub(tAmount);
    //update shares balance
    _shares[sender] = _shares[sender].sub(sAmount);
    _shares[recipient] = _shares[recipient].add(sAmount);
    //update checkpoints
    _subValue(sender, tAmount);
    _addValue(recipient, tAmount);

    emit Transfer(sender, recipient, tAmount);
  }

  function _transferBothExcluded(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (uint256 sAmount, , , , ) = _getValues(sender, tAmount);
    //update token balances for excluded accounts
    _tokens[sender] = _tokens[sender].sub(tAmount);
    _tokens[recipient] = _tokens[recipient].add(tAmount);
    //update shares balances
    _shares[sender] = _shares[sender].sub(sAmount);
    _shares[recipient] = _shares[recipient].add(sAmount);
    //update checkpoints
    _subValue(sender, tAmount);
    _addValue(recipient, tAmount);
    emit Transfer(sender, recipient, tAmount);
  }

  function _subValue(address account, uint256 value) private {
    uint256 nCheckpoints = numCheckpoints[account];
    uint256 OldValue = nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].value : 0;
    uint256 NewValue = OldValue.sub(value);
    _writeCheckpoint(account, nCheckpoints, OldValue, NewValue);
  }

  function _addValue(address account, uint256 value) private {
    uint256 nCheckpoints = numCheckpoints[account];
    uint256 OldValue = nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].value : 0;
    uint256 NewValue = OldValue.add(value);
    _writeCheckpoint(account, nCheckpoints, OldValue, NewValue);
  }

  function _writeCheckpoint(
    address account,
    uint256 nCheckpoints,
    uint256 oldValue,
    uint256 newValue
  ) internal {
    if (nCheckpoints > 0 && checkpoints[account][nCheckpoints - 1].fromBlock == block.number) {
      checkpoints[account][nCheckpoints - 1].value = newValue;
    } else {
      checkpoints[account][nCheckpoints] = Checkpoint(block.number, newValue);
      numCheckpoints[account] = nCheckpoints + 1;
    }

    emit AccountCheckpointUpdated(account, oldValue, newValue);
  }

  function _distributeFee(uint256 sFee, uint256 tFee) private {
    //send half of fee to this contract for liquidity generation
    uint256 lockedFee = sFee.div(2);
    _shares[address(this)] = _shares[address(this)].add(lockedFee);

    //distribute the remainder among token holders
    totalShares = totalShares.sub(sFee.sub(lockedFee));

    //update total fee variable
    tFeeTotal = tFeeTotal.add(tFee);
  }

  function _getValues(address sender, uint256 tAmount)
    private
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    (uint256 tTransferAmount, uint256 tFee) = _getTValues(sender, tAmount);
    uint256 currentRate = _getRate();
    (uint256 sAmount, uint256 sTransferAmount, uint256 sFee) =
      _getSValues(tAmount, tFee, currentRate);
    return (sAmount, sTransferAmount, sFee, tTransferAmount, tFee);
  }

  function _getTValues(address sender, uint256 tAmount) private view returns (uint256, uint256) {
    uint256 tFee = _getFee(sender, tAmount);
    uint256 tTransferAmount = tAmount.sub(tFee);
    return (tTransferAmount, tFee);
  }

  function _getSValues(
    uint256 tAmount,
    uint256 tFee,
    uint256 currentRate
  )
    private
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 sAmount = tAmount.mul(currentRate);
    uint256 sFee = tFee.mul(currentRate);
    uint256 sTransferAmount = sAmount.sub(sFee);
    return (sAmount, sTransferAmount, sFee);
  }

  function _getFee(address account, uint256 tAmount) private view returns (uint256) {
    uint256 fee = 0;
    if (balanceOf(account) >= 1000000 * (10**18)) {
      return fee;
    } else if (balanceOf(account) >= 500000 * (10**18)) {
      fee = tAmount.div(100);
      return fee;
    } else if (balanceOf(account) >= 320000 * (10**18)) {
      fee = tAmount.div(60);
      return fee;
    } else if (balanceOf(account) >= 160000 * (10**18)) {
      fee = tAmount.div(50);
      return fee;
    } else if (balanceOf(account) >= 80000 * (10**18)) {
      fee = tAmount.div(40);
      return fee;
    } else if (balanceOf(account) >= 40000 * (10**18)) {
      fee = tAmount.div(30);
      return fee;
    } else if (balanceOf(account) >= 20000 * (10**18)) {
      fee = tAmount.div(22);
      return 3;
    } else if (balanceOf(account) >= 10000 * (10**18)) {
      fee = tAmount.div(20);
      return fee;
    } else if (balanceOf(account) >= 1000 * (10**18)) {
      fee = tAmount.div(18);
      return fee;
    } else {
      fee = tAmount.div(15);
      return fee;
    }
  }

  function _getRate() private view returns (uint256) {
    (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
    return rSupply.div(tSupply);
  }

  function _getCurrentSupply() private view returns (uint256, uint256) {
    uint256 rSupply = totalShares;
    uint256 tSupply = totalTokens;
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_shares[_excluded[i]] > rSupply || _tokens[_excluded[i]] > tSupply)
        return (totalShares, totalTokens);
      rSupply = rSupply.sub(_shares[_excluded[i]]);
      tSupply = tSupply.sub(_tokens[_excluded[i]]);
    }
    if (rSupply < totalShares.div(totalTokens)) return (totalShares, totalTokens);
    return (rSupply, tSupply);
  }

  //TREASURY EXTERNAL FUNCTIONS--------------------------------------------------------------------------------------
  function setUniswapRouter(address _newAddr) external onlyOwner() {
    require(_newAddr != address(0));
    uniswapV2Router = _newAddr;

    emit RouterSet(_newAddr, block.timestamp);
  }

  function setDao(address _newAddr) external onlyOwner() {
    require(_newAddr != address(0));
    daoAddress = _newAddr;

    emit DaoAddressSet(_newAddr, block.timestamp);
  }

  function setPairToken(address _pair) external onlyOwner() {
    require(_pair != address(0));
    pairToken = _pair;
  }

  function setAscensionInterval(uint256 _interval) external onlyOwner() {
    ascensionInterval = _interval;

    emit AscensionIntervalSet(_interval, block.timestamp);
  }

  function setAscensionActive(bool _active) external onlyOwner() {
    ascensionActive = _active;
  }

  function setAscensionDivisor(uint256 _divisor) external onlyOwner() {
    require(_divisor > 0 && _divisor <= 25);
    ascensionDivisor = _divisor;
  }

  function setPullDivisor(uint256 _divisor) external onlyOwner() {
    require(_divisor > 0 && _divisor <= 75);
    pullDivisor = _divisor;
  }

  function ascensionEvent(
    address payable _strategy,
    address[] calldata _targets,
    uint256[] calldata _values
  ) external override {
    require(ascensionActive, "ASCENSION:ascensionEvent: Ascension are currently inactive!");
    require(_msgSender() == daoAddress, "ASCENSION:ascensionEvent: Sender must be DAO address!");
    require(
      block.timestamp > previousAscensionTimestamp + ascensionInterval,
      "ASCENSION:ascensionEvent: Too soon to call Ascension Event!"
    );
    require(pairToken != address(0), "ASCENSION:ascensionEvent: Liquidity pair token not yet set!");
    require(
      uniswapV2Router != address(0),
      "ASCENSION:_removeLiquidity: Router address not yet set!"
    );
    require(
      IERC20(pairToken).balanceOf(address(this)) > 0,
      "ASCENSION:ascensionEvent: No liquidity to remove!"
    );

    //+1 total Ascension events
    totalAscensions++;
    //set ascension timestamp
    previousAscensionTimestamp = block.timestamp;
    //set amount liquidity to be pulled
    uint256 pullAmount = IERC20(pairToken).balanceOf(address(this)).div(pullDivisor);
    //aprove router contract
    IERC20(pairToken).approve(uniswapV2Router, pullAmount);
    //pull liquidity
    uint256 amountETH =
      IUniswapV2Router02(uniswapV2Router).removeLiquidityETHSupportingFeeOnTransferTokens(
        address(this),
        pullAmount,
        0,
        0,
        _strategy,
        block.timestamp
      );
    //require amountETH is greater than previous ascension event by at least x
    require(
      amountETH >= previousAscensionEth.add(previousAscensionEth.div(ascensionDivisor)),
      "ASCENSION:ascensionEvent: price has not ascended!"
    );
    //set ascension ETH
    previousAscensionEth = amountETH;

    //execute strategy
    IAscensionStrategy(_strategy).executeStrategy(_targets, _values);

    emit AscensionEvent(_strategy, amountETH, _targets, _values, block.timestamp);
  }

  function generateLiquidity() external {
    require(
      balanceOf(address(this)) > 0,
      "ASCENSION:generateLiquidity: No available tokens to liquidate!"
    );
    //amount given to caller to incentivize gas spending
    uint256 callerReward = balanceOf(address(this)).div(50);
    // split the contract balance except callerReward into halves
    uint256 lockedForSwap = balanceOf(address(this)).sub(callerReward);
    uint256 half = lockedForSwap.div(2);
    uint256 otherHalf = lockedForSwap.sub(half);

    // capture the contract's current ETH balance.
    // this is so that we can capture exactly the amount of ETH that the
    // swap creates, and not make the liquidity event include any ETH that
    // has been manually sent to the contract
    uint256 initialBalance = address(this).balance;

    // swap tokens for ETH
    swapTokensForEth(half);

    // how much ETH did we just swap into?
    uint256 newBalance = address(this).balance.sub(initialBalance);

    // add liquidity to uniswap
    addLiquidityForEth(otherHalf, newBalance);

    emit SwapAndLiquify(IUniswapV2Router02(uniswapV2Router).WETH(), half, newBalance, otherHalf);

    _transfer(address(this), _msgSender(), callerReward);
  }

  function swapTokensForEth(uint256 tokenAmount) private {
    // generate the uniswap pair path of token -> weth
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = IUniswapV2Router02(uniswapV2Router).WETH();

    _approve(address(this), uniswapV2Router, tokenAmount);

    // make the swap
    IUniswapV2Router02(uniswapV2Router).swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0, // accept any amount of ETH
      path,
      address(this),
      block.timestamp
    );
  }

  function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
    // approve token transfer to cover all possible scenarios
    _approve(address(this), uniswapV2Router, tokenAmount);

    // add the liquidity
    IUniswapV2Router02(uniswapV2Router).addLiquidityETH{ value: ethAmount }(
      address(this),
      tokenAmount,
      0, // slippage is unavoidable
      0, // slippage is unavoidable
      address(this),
      block.timestamp
    );
  }
  //--------------------------------------------------------------------------------------------------------------------
}