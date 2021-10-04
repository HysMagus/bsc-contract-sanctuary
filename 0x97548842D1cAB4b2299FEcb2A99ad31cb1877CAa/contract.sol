// SPDX-License-Identifier: MIT

pragma solidity = 0.6.12;

// File: @openzeppelin/contracts/utils/Context.sol

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
    constructor () internal {
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

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

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

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// File: contracts/libs/IBEP20.sol

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

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
    function allowance(address _owner, address spender) external view returns (uint256);

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
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol

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
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
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


// File: @openzeppelin/contracts/utils/EnumerableSet.sol

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
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
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
            set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex

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

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
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
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
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
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
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
        return address(uint160(uint256(_at(set._inner, index))));
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


// File: contracts/libs/BEP20.sol

/**
 * @dev Implementation of the {IBEP20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {BEP20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of BEP20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IBEP20-approve}.
 */
 
contract BEP20 is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

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
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token name.
     */
    function name() public override view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() public override view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance")
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero")
        );
        return true;
    }
	
	

    /**
     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }
	*/

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
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
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
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

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
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
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
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance")
        );
    }
}

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/libs/IRobustReferral.sol

interface IRobustReferral {
    /**
     * @dev Record referral.
     */
    function recordReferral(address user, address referrer) external;

    /**
     * @dev Record referral commission.
     */
    function recordReferralCommission(address referrer, uint256 commission) external;

    /**
     * @dev Get the referrer address that referred the user.
     */
    function getReferrer(address user) external view returns (address);
}

//File: contracts/libs/SafeBEP20.sol

/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeBEP20: decreased allowance below zero"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}


/*
	RobustSwap by the Robust Protocol team
	Website: https://robustprotocol.fi
	Telegram: https://t.me/robustprotocol
	Twitter: https://twitter.com/robustprotocol
	Medium: https://robustprotocol.medium.com
	GitBook: https://docs.robustprotocol.fi
	GitHub: https://github.com/robustprotocol
	Reddit: https://www.reddit.com/r/robustProtocol
*/

// File: contracts/RobustSwapTest.sol

contract RobustSwapTest is BEP20 {

    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

	// The operator can perform all updates except minting
    address public operator;

    // Operator can be transferred to the pending operator
    address public operatorPending;

    // Operator timelock
    bool public opeatorTimeLocked = false;

    // Max tax rate in basis points (Default: 20% of transaction amount)
    uint16 private constant MAXIMUM_TAX_RATE = 2000;

    // Transfer tax rate in basis points (Default: 6% of transaction amount)
    uint16 public transferTaxRate = 600;

    // Buy tax rate in basis points (Default: 6% of transaction amount)
    uint16 public transferTaxRateBuy = 600;

    // Sell tax rate in basis points (Default: 8% of transaction amount)
    uint16 public transferTaxRateSell = 800;

    // Max burn tax rate (Default: 100% of tax amount)
    uint16 private constant MAXIMUM_BURN_RATE = 100;

    // Burn address
    address private constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;	

    // Transfer burn rate (Default: 0 of transferTaxRate)
    uint16 public burnRateTransfer = 0;

    // Buy burn rate (Default: 0 of transferTaxRateBuy)
    uint16 public burnRateBuy = 0;

    // Sell burn rate (Default: 0 of transferTaxRateSell)
    uint16 public burnRateSell = 0;

	// Max supply of RobustSwap RBS (One-Hundred Ten Thousand, 110K)
	uint256 private constant MAXIMUM_SUPPLY = 110000 ether;

    // Keep track of how many tokens have been minted
    uint256 public mintedSupply;

    // Min tax transfer limit rate in basis points (Default: 0.1% of the total supply)
    uint16 private constant MINIMUM_TRANSFER_LIMIT = 10;

    // Transfer limit rate in basis points (Default: 1% of the total supply)
    uint16 public transferAmountLimitRate = 100;

    // Auto trigger for autoLiquidity and autoSell
    bool public autoTrigger = true;

    // Auto trigger in progress
    bool private _inAutoTrigger;

    // BNB for autoTrigger to occur in basis points (Default: 1 BNB)
    uint256 public autoTriggerAmount = 1 ether;

    // Min BNB for autoTrigger to occur in basis points (Default: 10% of autoTriggerAmount, 0.1 BNB)
    uint16 public autoTriggerAmountRate = 1000;

    // Auto liquidity generation
    bool public autoLiquidityEnabled = true;

    // Auto sell RBS for BNB
    bool public autoSellEnabled = true;

    // Modifiable: Router will be changed when RobustSwap AMM is released
    IUniswapV2Router02 private _robustSwapRouter;

    // The trading pair
    address public robustSwapBNBPair;

	// Addresses excluded from taxes
	EnumerableSet.AddressSet private _taxExcludedList;

    // Addresses excluded from transfer limit
	EnumerableSet.AddressSet private _transferLimitExcluded;

    // LP Pairs excluded from taxes
	EnumerableSet.AddressSet private _robustSwapPairLPList;

    // Enable trading. This can only occur once
    bool private _tradingEnabled = false;

	// Prevent bot transactions
    mapping (address => uint256) private _botGuard;

	// Max bot guard blocks (Default: 10 Blocks)
	uint8 private constant MAXIMUM_BOTGUARD_BLOCKS = 10;

	// Bot guard blocks (Default: 5 Blocks)
	uint8 public botGuardBlocks = 5;

	// Events are necessary to keep track of all updates and changes especially by the operator
    event OperatorSet(address indexed previousOperator, address indexed newOperator);
    event UpdateOperatorSetPending(address indexed currentOperator, address indexed operatorPending);
	event UpdateOperatorAcceptPending(address indexed previousOperator, address indexed newOperator);
	event UpdateOperatorSetTimeLock(address indexed previousOperator, address indexed timeLockedOperator, bool operatorTimeLocked);
    event MintRBS(address indexed operator, address indexed recipient, uint256 amountMinted, uint256 MintedSupply);
    event AutoLiquidityRBS(uint256 amountRBS, uint256 amountBNB);
    event AutoLiquidityBNB(uint256 amountRBS, uint256 amountBNB);
    event AutoSell(uint256 balanceRBS, uint256 soldRBS);
	event EnableTrading(address indexed operator, uint256 timeEnabled);
	event UpdateRateTax(address indexed operator, uint256 previousTaxRate, uint256 newTaxRate, uint256 previousBuyTaxRate, uint256 newBuyTaxRate, uint256 previousSellTaxRate, uint256 newSellTaxRate);
    event UpdateRateBurn(address indexed operator, uint16 previousBurnRate, uint16 newBurnRate, uint16 previousBuyBurnRate, uint16 newBuyBurnRate, uint16 previousSellBurnRate, uint16 newSellBurnRate);
    event UpdateRateTransferLimit(address indexed operator, uint16 previousRate, uint16 newRate);
    event UpdateAutoLiquidityStatus(address indexed operator, bool enabled);
	event UpdateTransferLimitExclusionRemove(address indexed operator, address indexed removedAddress);
	event UpdateTransferLimitExclusionAdd(address indexed operator, address indexed addedAddress);
	event UpdateTaxExclusionAdd(address indexed operator, address indexed addedAddress);
	event UpdateTaxExclusionRemove(address indexed operator, address indexed removedAddress);	
	event UpdatePairListRemove(address indexed operator, address indexed removedLPPair);
	event UpdatePairListAdd(address indexed operator, address indexed addedLPPair);		
	event UpdateBotGuard(address indexed operator, uint8 previousBlocksLock, uint8 newBlocksLock);
	event UpdateAutoTrigger(address indexed operator, bool previousTrigger, bool newTrigger, uint256 previousAmount, uint256 newAmount, uint16 previousRate, uint16 newRate);
    event UpdateAutoSellEnabled(address indexed operator, bool enabled);
	event UpdateRobustSwapRouter(address indexed operator, address indexed router, address indexed pair);
	event BalanceBurnRBS(address indexed operator, uint256 burnedAmount);	
	event BalanceWithdrawToken(address indexed operator, address indexed tokenAddress, uint256 amountTokenTransfered);
    event BalanceWithdrawBNB(address indexed operator, address indexed recipientAddress, uint256 amountBNBTransfered);
	event SwapRBSForBNB(uint256 amountIn, address[] path);
    event AddLiquidity(uint256 addedTokenAmount, uint256 addedBNBAmount);	
	event TransferTaxed(address indexed sender, address indexed recipient, uint256 amountTransaction, uint256 amountSent, uint256 amountTaxed, uint256 amountBurned, uint256 amountLiquidity);
	event TransferNotTaxed(address indexed sender, address indexed recipient, uint256 amountTransaction, bool isAddressTaxExcluded, bool isLiquidityTransfer);
	event Received(address indexed sender, uint amount);

    /**
     * @notice onlyOperator functions can be performed by the operator
	 * Operator can perform all update functions
	 * Timelock the operator with updateOperatorSetTimeLock
     */
	modifier onlyOperator() {
        require(operator == msg.sender, "RobustSwap::onlyOperator:Caller is not the operator");
        _;
    }

    /**
     * @notice timelockedOperator functions can be performed only after the operator is timelocked
	 * balanceWithdrawBNB, balanceWithdrawToken, balanceBurnRBS, updateOperatorSetPending
     */
	modifier timelockedOperator() {
        require(opeatorTimeLocked, "RobustSwap::timelockedOperator:Operator needs to be timelocked");
        _;
    }

    /**
     * @notice Transfer amount limitation
     */
	modifier transferAmountLimit(address sender, address recipient, uint256 amount) {
		
        if (maxTransferLimitAmount() > 0) {
			
			// Exclude transfers between robustSwapRouter and RobustSwap LP pairs
			bool isLPTransfers = ((isRobustSwapPair(sender) && recipient == routerAddress()) || (isRobustSwapPair(recipient) && sender == routerAddress()));

			if (
				!isTransferLimitExcluded(sender)
                && !isTransferLimitExcluded(recipient)
				&& !isLPTransfers
            ) {
                require(amount <= maxTransferLimitAmount(), "RobustSwap::transferAmountLimit:Transfer amount exceeds the maxTransferAmount");
            }
        }
        _;
    }

    /**
     * @notice autoliquidity, autoSell
     */	
    modifier autoTriggerLock {
        _inAutoTrigger = true;
        _;
        _inAutoTrigger = false;
    }

    /**
     * @notice Transfer tax exemption
     */
    modifier noTransferTax {
        uint16 _transferTaxRate = transferTaxRate;
        transferTaxRate = 0;
        _;
        transferTaxRate = _transferTaxRate;
    }

    /**
     * @notice Constructs the RobustSwap (RBS) contract
     */
    constructor() public BEP20("RobustSwapTest", "RBST") {
        // Set initial operator
		operator = _msgSender();
        emit OperatorSet(address(0), operator);

		// Set initial transfer limit exemptions
		_transferLimitExcluded.add(address(this));		
		_transferLimitExcluded.add(msg.sender);
		_transferLimitExcluded.add(address(0));
		_transferLimitExcluded.add(BURN_ADDRESS);

		// Set initial transfer tax exemptions
		_taxExcludedList.add(address(this));	
		_taxExcludedList.add(msg.sender);
		_taxExcludedList.add(address(0));
		_taxExcludedList.add(BURN_ADDRESS);
	}

    /**
     * @notice Creates '_amount' token to '_recipient'
	 * Must only be called by the owner (MasterChef)
	 * No more RBS minting after the maximum supply is minted
     */
    function mint(address _recipient, uint256 _amount) external onlyOwner {
		require(_amount <= mintedBalance(), "RobustSwap::mint:Maximum supply minted");
		require(_recipient != address(0),"RobustSwap::mint:Zero address.");
		require(_amount > 0,"RobustSwap::mint:Zero amount");
		mintedSupply = mintedSupply.add(_amount);
		emit MintRBS(_msgSender(), _recipient, _amount, mintedSupply);
		_mint(_recipient, _amount);
    }

    /**
     * @dev Overrides transfer function to meet tokenomics of RobustSwap (RBS)
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual override transferAmountLimit(sender, recipient, amount) {
		// Manually excluded adresses from transaction tax
        bool isAddressTaxExcluded = (isTaxExcluded(sender) || isTaxExcluded(recipient));

        // Transfers between robustSwapRouter and excluded LP pairs are tax free
        bool isLiquidityTransfer = ((isRobustSwapPair(sender) && recipient == routerAddress()) || (isRobustSwapPair(recipient) && sender == routerAddress()));

        // autoLiquidity, autoSell
        if (autoTrigger && !_inAutoTrigger
			&& isTradingEnabled()
			&& routerAddress() != address(0)
			&& robustSwapBNBPair != address(0)
			&& !isRobustSwapPair(sender)
			&& sender != routerAddress()
			&& sender != owner()) {

					if (autoLiquidityEnabled)
						autoLiquidity();

					if (autoSellEnabled)
						autoSell();
		}

		// Tax free transfers
		if (amount == 0 || isAddressTaxExcluded || isLiquidityTransfer ){

			emit TransferNotTaxed(sender, recipient, amount, isAddressTaxExcluded, isLiquidityTransfer);			

			if (recipient == BURN_ADDRESS) {
					// Burn tokens sent to burn address
					if (amount > 0)
						_burn(sender, amount);

			}else {
				// Tax free transfer
				super._transfer(sender, recipient, amount);
			}

        } else {
			// Trading needs to be enabled. Once enabled, trading cannot be disabled
            require(isTradingEnabled(), "RobustSwap::_transfer:Trading is not yet enabled");

			// Taxed transfers
			taxedTransfers(sender, recipient, amount);
        }
    }

    /**
     * @dev Process taxed transfers
     */	 
	function taxedTransfers(address sender, address recipient, uint256 amount) private {

			// Default transfer tax rate
			uint16 rateTax = transferTaxRate;

			// Default burn rate
			uint16 rateBurn = burnRateTransfer;

			// Burn amount
			uint256 burnAmount = 0;

			// Liquidity amount
			uint256 liquidityAmount = 0;

			// Tax amount
			uint256 taxAmount = 0;

			// Send amount
			uint256 sendAmount = 0;

			// Buy Transaction
			if (isRobustSwapPair(sender) || sender == routerAddress()) {

				//Transaction can only occur afer number of botGuardBlocks
				require(_botGuard[recipient] <= block.number,"RobustSwap::taxedTransfers:Sell only after number of botGuardBlocks");

				//Set a new botGuardBlocks for the recipient
				_botGuard[recipient] = block.number.add(botGuardBlocks);

				// Set buy tax and burn rates
				rateTax = transferTaxRateBuy;
				rateBurn = burnRateBuy;
			}

			// Buy Transaction
			if (isRobustSwapPair(recipient) || recipient == routerAddress()) {

				//Transaction can only occur afer number of botGuardBlocks
				require(_botGuard[sender] <= block.number,"RobustSwap::taxedTransfers:Buy only after number of botGuardBlocks");

				//Set a new botGuardBlocks for the sender
				_botGuard[sender] = block.number.add(botGuardBlocks);

				// Set sell tax and burn rates
				rateTax = transferTaxRateSell;
				rateBurn = burnRateSell;
			}

			// Calculate applicable tax from amount
			if (rateTax > 0)
				taxAmount = amount.mul(rateTax).div(10000);

			// Calculate applicable burn from tax
			if (rateBurn > 0 && rateTax != 0)
				burnAmount = taxAmount.mul(rateBurn).div(100);

			// Amount for liquidity
			liquidityAmount = taxAmount.sub(burnAmount);

			// Amount sent to recipient
			sendAmount = amount.sub(taxAmount);

			emit TransferTaxed(sender, recipient, amount, sendAmount, taxAmount, burnAmount, liquidityAmount);

			// Burn from amount
			if (burnAmount > 0)
				_burn(sender, burnAmount);

			// Liquidity to contract
			if (liquidityAmount > 0)
				super._transfer(sender, address(this), liquidityAmount);

			// Transfer to recipient
			super._transfer(sender, recipient, sendAmount);
	}

    /**
     * @dev Auto generate RBS-BNB liquidity
     */
    function autoLiquidity() private autoTriggerLock noTransferTax {
		// Use RBS balance for liquidity
		uint256 runningBalanceRBS = balanceOf(address(this));		
		uint256 runningBalanceBNB = address(this).balance;	
		uint totalLiquidityAmount = getTotalLiquidityAmount(runningBalanceRBS);

		// Check for sufficient balances
		if(totalLiquidityAmount != 0 && runningBalanceRBS >= totalLiquidityAmount.mul(2)) {

			// Swap RBS for BNB
			swapRBSForBNB(totalLiquidityAmount);

			// Get BNB amount received from swap
			uint256 liquidityBNB = address(this).balance.sub(runningBalanceBNB);

			emit AutoLiquidityRBS(totalLiquidityAmount, liquidityBNB);
			
			// Add liquidity
			addLiquidity(totalLiquidityAmount, liquidityBNB);
			
        }

		// Use BNB balance for liquidity
		runningBalanceBNB = address(this).balance;
		runningBalanceRBS = balanceOf(address(this));
		totalLiquidityAmount = getTotalLiquidityAmount(runningBalanceRBS);

		// Check for sufficient balances
		if(totalLiquidityAmount != 0 && runningBalanceRBS >= totalLiquidityAmount && runningBalanceBNB >= minAutoTriggerAmount()) {

			emit AutoLiquidityBNB(totalLiquidityAmount, minAutoTriggerAmount());

			// Add liquidity
			addLiquidity(totalLiquidityAmount, minAutoTriggerAmount());
		}
    }

    /**
     * @dev Auto sell contract RBS balance for BNB
     */
    function autoSell() private autoTriggerLock noTransferTax {
        uint256 runningBalanceRBS = balanceOf(address(this));

		// Get RBS amount to sell
		uint totalSellAmount = getTotalLiquidityAmount(runningBalanceRBS);

        if (totalSellAmount != 0 && runningBalanceRBS >= totalSellAmount) {
			
			emit AutoSell(runningBalanceRBS, totalSellAmount);
			
			// Sell RBS
			swapRBSForBNB(totalSellAmount);
        }
    }

    /**
     * @dev Swap RBS for BNB
     */
    function swapRBSForBNB(uint256 amountRBS) private {
        // Generate the robustSwap pair path of token -> WBNB
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _robustSwapRouter.WETH();

        _approve(address(this), address(_robustSwapRouter), amountRBS);

        // Execute the swap
        _robustSwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountRBS,
            0, // Accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );

        emit SwapRBSForBNB(amountRBS, path);
    }

    /**
     * @dev Add RBS-BNB liquidity
     */
    function addLiquidity(uint256 amountRBS, uint256 amountBNB) private {
        // Approve token transfer to cover all possible scenarios
        _approve(address(this), address(_robustSwapRouter), amountRBS);

        // Add the liquidity
        _robustSwapRouter.addLiquidityETH{value: amountBNB}(
            address(this),
            amountRBS,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
		
		emit AddLiquidity(amountRBS, amountBNB);
    }

    /**
     * @dev Calculate the amount of RBS required for autoLiquidity and autoSell
     */
   function getTotalLiquidityAmount(uint256 runningBalanceRBS) private view returns(uint)  {
		require(runningBalanceRBS > 0,"RobustSwap::getTotalLiquidityAmount:Invalid runningBalanceRBS");
		uint quoteOutputBNB = quotePriceRBS(runningBalanceRBS);

		if (quoteOutputBNB !=0 && quoteOutputBNB >= autoTriggerAmount) {

			// Calculate RBS price based on the RBS-BNB reserve
			uint amountRBSPerBNB = runningBalanceRBS.div(quoteOutputBNB);

			// Calculate amount of required RBS
			uint totalLiquidityAmount = amountRBSPerBNB.mul(minAutoTriggerAmount());

			return totalLiquidityAmount;

		} else {
			
			return 0;
		}
   }

    /**
     * @dev Calculate RBS price based on RBS-BNB reserve
	 * Required for autoLiquidity and autoSell
     */
   function quotePriceRBS(uint _amountRBS) private view returns(uint) {
	   	require(robustSwapBNBPair != address(0), "RobustSwap::quotePriceRBS:Invalid pair address.");
		require(_amountRBS > 0,"RobustSwap::quotePriceRBS:Invalid input amount");

		IUniswapV2Pair pair = IUniswapV2Pair(robustSwapBNBPair);
		(uint Reserve0, uint Reserve1,) = pair.getReserves();

		//  BNB/RBS LP Pair
		IBEP20 token0 = IBEP20(pair.token0());
		IBEP20 token1 = IBEP20(pair.token1());

		// Check if reserve has funds
		if (Reserve0 > 0 && Reserve1 > 0) {
			if (address(token0) == address(this))
				return (_amountRBS.mul(Reserve1)).div(Reserve0);

			if (address(token1) == address(this))
				return (_amountRBS.mul(Reserve0)).div(Reserve1);
		}else{
			// No funds in reserve
			return 0;
		}
   }

    /**
     * @dev Returns the the trading enabled status
     */
    function isTradingEnabled() public view returns (bool) {
		return _tradingEnabled;
	}

    /**
     * @dev Returns total number of burned tokens
     */
    function mintedBurned() external view returns (uint256) {
        return mintedSupply.sub(totalSupply());
    }

    /**
     * @dev Returns the max transfer limit amount
     */
    function maxTransferLimitAmount() public view returns (uint256) {
        return totalSupply().mul(transferAmountLimitRate).div(10000);
    }

    /**
     * @dev Returns the min BNB autoTrigger amount
     */
    function minAutoTriggerAmount() public view returns (uint256) {
        return autoTriggerAmount.mul(autoTriggerAmountRate).div(10000);
    }

    /**
     * @dev Returns transfer limit status for an address
     */
    function isTransferLimitExcluded(address _transferLimitExemption) public view returns (bool) {
		return _transferLimitExcluded.contains(_transferLimitExemption);
    }

    /**
     * @dev Returns tax status for an address
     */
    function isTaxExcluded(address _taxExcluded) public view returns (bool) {		
		return _taxExcludedList.contains(_taxExcluded);
    }

    /**
     * @dev Returns if an address is added to the RobustSwap LP list
     */
    function isRobustSwapPair(address _RobustSwapPair) public view returns (bool) {		
		return _robustSwapPairLPList.contains(_RobustSwapPair);
    }

    /**
     * @dev Returns the total of unminted RBS
     */
    function mintedBalance() public view returns (uint256) {
		return MAXIMUM_SUPPLY.sub(mintedSupply);
    }

    /**
     * @dev Returns the current RobustSwap router address
     */
    function routerAddress() public view returns (address) {
		return address(_robustSwapRouter);
    }

    /**
     * @dev Receive BNB from robustSwapRouter when swapping
     */
    receive() external payable {
		emit Received(msg.sender, msg.value);
	}

    /**
     * @dev The operator wields an enormous amount of powers
	 * Set the operator to the timelock contract
	 * No pull-over-push validation
	 * Ensure that timelock contract is functional before setting
	 * Once set, only the timelock contract can perform any operator functions
	 * Timelock contract can set a new operator using updateOperatorSetPending
     */
    function updateOperatorSetTimeLock(address _timeLockContract) external onlyOperator {
        require(_timeLockContract != address(0), "RobustSwap::updateOperatorSetTimeLock:Timelock cannot be the zero address");
        require(_timeLockContract != operator, "RobustSwap::updateOperatorSetTimeLock:Current operator address cannot be used");

		opeatorTimeLocked = true;

		emit UpdateOperatorSetTimeLock(operator, _timeLockContract, opeatorTimeLocked);

		operator = _timeLockContract;		
    }

    /**
     * @dev Set a pending operator
	 * Pending operator must accept before the change can be effected
     * Can only be called by the current operator
     */
    function updateOperatorSetPending(address _operatorPending) external onlyOperator timelockedOperator {		
		require(_operatorPending != address(0), "RobustSwap::updateOperatorSetPending:New operator cannot be the zero address");
        require(_operatorPending != operator, "RobustSwap::updateOperatorSetPending:Current operator address cannot be used");

		emit UpdateOperatorSetPending(operator, _operatorPending);

		operatorPending = _operatorPending;
    }

    /**
     * @dev Accept to become the new operator
	 * Can only be called by operatorPending address
     */
    function updateOperatorAcceptPending() external {
        require(msg.sender == operatorPending, "RobustSwap::updateOperatorAcceptPending:Only a pending operator can accept");

		emit UpdateOperatorAcceptPending(operator, operatorPending);

		operator = operatorPending;
		operatorPending = address(0);
		opeatorTimeLocked = false;
    }

    /**
     * @dev Enable trading. This can only occur once
	 * After enabled, trading cannot be disabled
     * Can only be called by the current operator
     */
    function enableTrading() external onlyOperator {
        require(!_tradingEnabled, "RobustSwap::enableTrading:Trading is already enabled");
        require(routerAddress() != address(0), "RobustSwap::enableTrading:Router address is not set");
        require(robustSwapBNBPair != address(0), "RobustSwap::enableTrading:RBS-BNB pair not found");

		emit EnableTrading(operator, block.timestamp);

		_tradingEnabled = true;
    }

    /**
     * @dev Update transaction tax rates (buy, sell and transfer)
	 * Setting rate to 0 disables transaction tax
     * Can only be called by the current operator
     */
    function updateRateTax(uint16 _transferTaxRate, uint16 _transferTaxRateBuy, uint16 _transferTaxRateSell) external onlyOperator {
		require(_transferTaxRate <= MAXIMUM_TAX_RATE, "RobustSwap::updateRateTax:Transfer tax rate must not exceed the maximum rate");
        require(_transferTaxRateBuy <= MAXIMUM_TAX_RATE, "RobustSwap::updateRateTax:Buy transfer tax rate must not exceed the maximum rate");
		require(_transferTaxRateSell <= MAXIMUM_TAX_RATE, "RobustSwap::updateRateTax:Sell transfer tax rate must not exceed the maximum rate");
		
		emit UpdateRateTax(operator, transferTaxRate, _transferTaxRate, transferTaxRateBuy, _transferTaxRateBuy, transferTaxRateSell, _transferTaxRateSell);
		
		if(_transferTaxRate != transferTaxRate)
			transferTaxRate = _transferTaxRate;

 		if(_transferTaxRateBuy != transferTaxRateBuy)
			transferTaxRateBuy = _transferTaxRateBuy;		

		if(_transferTaxRateSell != transferTaxRateSell)
			transferTaxRateSell = _transferTaxRateSell;		
    }

    /**
     * @dev Update transaction tax burn rates
	 * Setting rate to 0 disables burn rate
	 * Disabled - All tax sent to the RBS contract for autoLiquidity and autoSell
     * Can only be called by the current operator
     */
    function updateRateBurn(uint16 _burnRateTransfer, uint16 _burnRateBuy, uint16 _burnRateSell) external onlyOperator {
		require(_burnRateTransfer <= MAXIMUM_BURN_RATE, "RobustSwap::updateRateBurn:Burn rate must not exceed the maximum rate");
        require(_burnRateBuy <= MAXIMUM_BURN_RATE, "RobustSwap::updateRateBurn:Buy burn rate must not exceed the maximum rate");
        require(_burnRateSell <= MAXIMUM_BURN_RATE, "RobustSwap::updateRateBurn:Sell burn rate must not exceed the maximum rate");

		emit UpdateRateBurn(operator, burnRateTransfer, _burnRateTransfer, burnRateBuy, _burnRateBuy, burnRateSell, _burnRateSell);

		if(_burnRateTransfer != burnRateTransfer)
			burnRateTransfer = _burnRateTransfer;

		if(_burnRateBuy != burnRateBuy)
			burnRateBuy = _burnRateBuy;

 		if(_burnRateSell != burnRateSell)
			burnRateSell = _burnRateSell;
    }

    /**
     * @dev Update the single transfer amount limit rate
	 * Transfer limit works with the total supply of RBS
	 * Setting rate to 0 or 10000 and above will disable this feature
     * Can only be called by the current operator
     */
    function updateRateTransferLimit(uint16 _transferAmountLimitRate) external onlyOperator {
		if (_transferAmountLimitRate < MINIMUM_TRANSFER_LIMIT || _transferAmountLimitRate >= 10000)
			_transferAmountLimitRate = 0;

		emit UpdateRateTransferLimit(operator, transferAmountLimitRate, _transferAmountLimitRate);

		if(_transferAmountLimitRate != transferAmountLimitRate)
			transferAmountLimitRate = _transferAmountLimitRate;
    }

    /**
     * @dev Add address exempted from transfer amount limit (eg. CEX, MasterChef)
     * Can only be called by the current operator
     */
    function updateTransferLimitExclusionAdd(address _addTransferLimitExclusion) external onlyOperator {
		require(_addTransferLimitExclusion != address(0),"RobustSwap::updateTransferLimitExclusionAdd:Zero address");
		require(!isTransferLimitExcluded(_addTransferLimitExclusion),"RobustSwap::updateTransferLimitExclusionAdd:Address already excluded from transfer amount limit");
		
		emit UpdateTransferLimitExclusionAdd(operator, _addTransferLimitExclusion);
        
		_transferLimitExcluded.add(_addTransferLimitExclusion);
    }

    /**
     * @dev Remove address exempted from transfer amount limit
     * Can only be called by the current operator
     */
    function updateTransferLimitExclusionRemove(address _removeTransferLimitExclusion) external onlyOperator {
		require(_removeTransferLimitExclusion != address(0),"RobustSwap::updateTransferLimitExclusionRemove:Zero address");
		require(isTransferLimitExcluded(_removeTransferLimitExclusion),"RobustSwap::updateTransferLimitExclusionRemove:Address not excluded from transfer amount limit");
		
		emit UpdateTransferLimitExclusionRemove(operator, _removeTransferLimitExclusion);
        
		_transferLimitExcluded.remove(_removeTransferLimitExclusion);
    }

    /**
     * @dev Add address exempted from transfer tax (eg. CEX, MasterChef)
     * Can only be called by the current operator
     */
    function updateTaxExclusionAdd(address _addTaxExclusion) external onlyOperator {
		require(_addTaxExclusion != address(0),"RobustSwap::updateTaxExclusionAdd:Zero address");
		require(!isTaxExcluded(_addTaxExclusion),"RobustSwap::updateTaxExclusionAdd:Address is already excluded from transfer tax");
		
		emit UpdateTaxExclusionAdd(operator, _addTaxExclusion);
        
		_taxExcludedList.add(_addTaxExclusion);
    }

    /**
     * @dev Remove address exempted from transfer tax
     * Can only be called by the current operator
     */
    function updateTaxExclusionRemove(address _removeTaxExclusion) external onlyOperator {
		require(_removeTaxExclusion != address(0),"RobustSwap::updateTaxExclusionRemove:Zero address");
		require(isTaxExcluded(_removeTaxExclusion),"RobustSwap::updateTaxExclusionRemove:Address is not excluded from transfer tax");
		
		emit UpdateTaxExclusionRemove(operator, _removeTaxExclusion);		
        
		_taxExcludedList.remove(_removeTaxExclusion);
    }

    /**
     * @dev Add LP address to the RobustSwap pair list
	 * Used to determine if a transaction is buy, sell or transfer for applicable tax
     * Can only be called by the current operator
     */
    function updatePairListAdd(address _addRobustSwapPair) external onlyOperator {
		require(_addRobustSwapPair != address(0),"RobustSwap::updatePairListAdd:Zero address");
		require(!isRobustSwapPair(_addRobustSwapPair),"RobustSwap::updatePairListAdd:LP address already included");
		
		emit UpdatePairListAdd(operator, _addRobustSwapPair);
        
		_robustSwapPairLPList.add(_addRobustSwapPair);
    }

    /**
     * @dev Remove LP address from the RobustSwap pair list
	 * Used to determine if a transaction is buy, sell or transfer for applicable tax
     * Can only be called by the current operator
     */
    function updatePairListRemove(address _removeRobustSwapPair) external onlyOperator {
		require(_removeRobustSwapPair != address(0),"RobustSwap::updatePairListRemove:Zero address");
		require(isRobustSwapPair(_removeRobustSwapPair),"RobustSwap::updatePairListRemove:LP address not included");
		require(_removeRobustSwapPair != robustSwapBNBPair,"RobustSwap::updatePairListRemove:robustSwapBNBPair cannot be excluded");
		
		emit UpdatePairListRemove(operator, _removeRobustSwapPair);
        
		_robustSwapPairLPList.remove(_removeRobustSwapPair);
    }

    /**
     * @dev Update the autoTrigger settings
	 * For autoliquidity and autoSell
     * Can only be called by the current operator
     */
    function updateAutoTrigger(bool _autoTrigger, uint256 _autoTriggerAmount, uint16 _autoTriggerAmountRate) external onlyOperator {
		require(_autoTriggerAmount > 0,"RobustSwap::updateAutoTrigger:Amount cannot be 0");
		require(_autoTriggerAmountRate > 0,"RobustSwap::updateAutoTrigger:Trigger amount rate cannot be 0");
		require(_autoTriggerAmountRate <= 10000, "RobustSwap::updateAutoTrigger:Trigger amount rate must not exceed the maximum rate");

		emit UpdateAutoTrigger(operator, autoTrigger, _autoTrigger, autoTriggerAmount, _autoTriggerAmount, autoTriggerAmountRate, _autoTriggerAmountRate);

		if(_autoTrigger != autoTrigger)
			autoTrigger = _autoTrigger;

		if(_autoTriggerAmount != autoTriggerAmount)
			autoTriggerAmount = _autoTriggerAmount;

		if(_autoTriggerAmountRate != autoTriggerAmountRate)
			autoTriggerAmountRate = _autoTriggerAmountRate;
    }

    /**
     * @dev Update the bot guard blocks setting
     * Can only be called by the current operator
	 * Setting the blocks guard to 0 disabled this feature
     */
    function updateBotGuard(uint8 _botGuardBlocks) external onlyOperator {
		require(_botGuardBlocks <= MAXIMUM_BOTGUARD_BLOCKS, "RobustSwap::updateBotGuard:botGuardBlocks cannot exceed maximum blocks");

		emit UpdateBotGuard(operator, botGuardBlocks, _botGuardBlocks);

		if(_botGuardBlocks != botGuardBlocks)
			botGuardBlocks = _botGuardBlocks;
    }

    /**
     * @dev Update autoSell status
     * Can only be called by the current operator
     */
    function updateAutoSellEnabled(bool _autoSellEnabled) external onlyOperator {
		if (!_autoSellEnabled)
			require(autoSellEnabled,"RobustSwap::updateAutoSellEnabled:autoSell is disabled");
		
		if (_autoSellEnabled)
			require(!autoSellEnabled,"RobustSwap::updateAutoSellEnabled:autoSell is enabled");		

        emit UpdateAutoSellEnabled(operator, _autoSellEnabled);
        
		autoSellEnabled = _autoSellEnabled;
    }

    /**
     * @dev Update autoLiquidity status
     * Can only be called by the current operator
     */
    function updateAutoLiquidityStatus(bool _autoLiquidityEnabled) external onlyOperator {
		if (!_autoLiquidityEnabled)
			require(autoLiquidityEnabled,"RobustSwap::updateAutoLiquidityStatus:autoLiquidityEnabled is disabled");

		if (_autoLiquidityEnabled)
			require(!autoLiquidityEnabled,"RobustSwap::updateAutoLiquidityStatus:autoLiquidityEnabled is enabled");		

        emit UpdateAutoLiquidityStatus(operator, _autoLiquidityEnabled);
        
		autoLiquidityEnabled = _autoLiquidityEnabled;
    }

    /**
     * @dev Update the RobustSwap router
     * Can only be called by the current operator
     */
    function updateRobustSwapRouter(address _routerAddress) external onlyOperator {
        require(_routerAddress != address(0),"RobustSwap::updateRobustSwapRouter:Router address cannot be zero address");
        require(_routerAddress != routerAddress(),"RobustSwap::updateRobustSwapRouter:No change, current router address");
        _robustSwapRouter = IUniswapV2Router02(_routerAddress);
        robustSwapBNBPair = IUniswapV2Factory(_robustSwapRouter.factory()).getPair(address(this), _robustSwapRouter.WETH());
        require(robustSwapBNBPair != address(0), "RobustSwap::updateRobustSwapRouter:Invalid pair address.");
        emit UpdateRobustSwapRouter(operator, address(_robustSwapRouter), robustSwapBNBPair);
		_robustSwapPairLPList.add(robustSwapBNBPair);
    }

    /**
     * @dev Burn any or all RBS from the contract balance
	 * Setting amount to 0 will burn the RBS available balance
     * Can only be called by the current operator
     */
	function balanceBurnRBS(uint256 _amount) external onlyOperator timelockedOperator {
        IBEP20 token = IBEP20(address(this));
		uint256 balanceRBS = balanceOf(address(this));		
		require(balanceRBS > 0,"RobustSwap::balanceBurnRBS:Nothing to burn");
		require(_amount <= balanceRBS,"RobustSwap::balanceBurnRBS:Insufficient balance to burn");		
        balanceRBS = _amount > 0 ? _amount : balanceRBS;
		emit BalanceBurnRBS(operator, balanceRBS);		
		token.transfer(BURN_ADDRESS, balanceRBS);
	}

    /**
     * @dev Withdraw any token balance from the RBS contract
	 * Setting amount to 0 will withdraw the token available balance
     * Can only be called by the current operator
     */
	function balanceWithdrawToken(IBEP20 _tokenAddress, address _recipient, uint256 _amount) external onlyOperator timelockedOperator {		
		require(address(_tokenAddress) != address(0),"RobustSwap::balanceWithdrawToken:Token address cannot be zero address");		
		require(_recipient != address(0),"RobustSwap::balanceWithdrawToken:Recipient cannot be zero address");
		uint256 balanceToken = _tokenAddress.balanceOf(address(this));
		require(balanceToken > 0,"RobustSwap::balanceWithdrawToken:Token has no balance to withdraw");
		require(_amount <= balanceToken,"RobustSwap::balanceWithdrawToken:Insufficient token balance to withdraw");
        balanceToken = _amount > 0 ? _amount : balanceToken;		
		emit BalanceWithdrawToken(operator, address(_tokenAddress), balanceToken);
		_tokenAddress.transfer(_recipient, balanceToken);
    }

    /**
     * @dev Withdraw any BNB balance from RBS contract
	 * Setting amount to 0 will withdraw the available BNB balance
     * Can only be called by the current operator
     */
	function balanceWithdrawBNB(address payable _recipient, uint256 _amount) external onlyOperator timelockedOperator {
        require(_recipient != address(0),"RobustSwap::balanceWithdrawBNB:To address cannot be zero address");
		uint256 balanceBNB = address(this).balance;
		require(balanceBNB > 0,"RobustSwap::balanceWithdrawBNB:No BNB balance to withdraw");
		require(_amount <= balanceBNB,"RobustSwap::balanceWithdrawBNB:Insufficient balance to withdraw");
        balanceBNB = _amount > 0 ? _amount : balanceBNB;
		emit BalanceWithdrawBNB(operator, _recipient, balanceBNB);
		_recipient.transfer(balanceBNB);
	}

}

// File: contracts/RobustMasterChef.sol

// RobustMasterChef is the master of RBS. He can make RBS and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once RBS is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract RobustMasterChefTest is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    //Info of each user.
    struct UserInfo {
        uint256 amount;         		// How many LP tokens the user has provided.
        uint256 rewardDebt;				// Reward debt. See explanation below.
        uint256 rewardLockedUp;			// Reward locked up.
        uint256 nextHarvestUntil;		// When can the user harvest again.
        uint256 blockActivityNumber;	// Monitors the block number of user deposits or withdraws
        //
        // We do some fancy math here. Basically, any point in time, the amount of RBS
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accRBSPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accRBSPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    //Info of each pool.
    struct PoolInfo {
        IBEP20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. RBS to distribute per block.
        uint256 lastRewardBlock;  // Last block number that RBS distribution occurs.
        uint256 accRBSPerShare;   // Accumulated RBS per share, times 1e12. See below.
        uint16 depositFeeBP;      // Deposit fee in basis points
        uint256 harvestInterval;  // Harvest interval in seconds
		uint256 lpSupply;		  // Keeps track of the total LP supply
    }

    //RobustSwap
    RobustSwapTest public immutable rbs;
    //Dev address
    address public devAddress;
    //Deposit Fee address
    address public feeAddress;
    //RBS tokens created per block
    uint256 public rbsPerBlock;
    //Bonus muliplier for early rbs makers
    uint256 public constant BONUS_MULTIPLIER = 1;
    //Max harvest interval: 14 days
    uint256 public constant MAXIMUM_HARVEST_INTERVAL = 14 days;

    //Info of each pool
    PoolInfo[] public poolInfo;
    //Info of each user that stakes LP tokens
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    //Total allocation points. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    //The block number when RBS mining starts
    uint256 public startBlock;
    //Total locked up rewards
    uint256 public totalLockedUpRewards;

    //RBS referral contract address
    IRobustReferral public rbsReferralContract;
    //Referral commission rate in basis points
    uint16 public referralCommissionRate = 100;
    // Max referral commission rate: 10%
    uint16 public constant MAXIMUM_REFERRAL_COMMISSION_RATE = 1000;

	//Keep track of already added LP tokens
	mapping(IBEP20 => bool) public poolExistence;

	// Max bot guard blocks (Default: 10 Blocks)
	uint8 private constant MAXIMUM_BOTGUARD_BLOCKS = 10;
	// Bot guard blocks (Default: 5 Blocks)
	uint8 public botGuardBlocks = 5;

	//Prevents duplication of added LP tokens
    modifier nonDuplicated(IBEP20 _lpToken) {
        require(!poolExistence[_lpToken], "RobustMasterChef::nonDuplicated:LP token already added");
        _;
    }

	//Validates pool by pool id
	modifier validatePoolByPid(uint256 _pid) {
		require(_pid <  poolInfo . length, "RobustMasterChef::validatePoolByPid:Pool does not exist");
		_;
	}

    event UpdateStartBlock(uint256 newStartBlock);    
	event PoolAdd(uint256 indexed pid, address lpToken, uint256 allocPoint, uint256 depositFeeBP);
    event PoolSet(uint256 indexed pid, address lpToken, uint256 allocPoint, uint256 depositFeeBP);	
	event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmissionRateUpdated(address indexed caller, uint256 previousAmount, uint256 newAmount);
    event ReferralCommissionPaid(address indexed user, address indexed referrer, uint256 commissionAmount);
    event RewardLockedUp(address indexed user, uint256 indexed pid, uint256 amountLockedUp);
    event DevAddressUpdated(address indexed previousDevAddress, address indexed newDevAddress);
    event FeeAddressUpdated(address indexed previousFeeAddress, address indexed newFeeAddress);
    event RBSReferralContractUpdated(address indexed previousReferralContract, address indexed newReferralContract);
    event ReferralCommissionRateUpdated(uint16 previousRate, uint16 newRate);
	event UpdateBotGuard(uint8 previousBlocksLock, uint8 newBlocksLock);

    constructor(
        RobustSwapTest _rbs,
        uint256 _startBlock,
        uint256 _rbsPerBlock
    ) public {
		rbs = _rbs;
        startBlock = _startBlock;
        rbsPerBlock = _rbsPerBlock;

        devAddress = msg.sender;
        feeAddress = msg.sender;
    }

    /**
     * @dev Returns total number of pools
     */
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    /**
     * @dev Returns the total RBS unminted balance
	 * No more minting or rewards after the maximum supply is reached
     */
    function mintableRBS() public view returns (uint256) {
		return rbs.mintedBalance();
    }

    /**
     * @dev Updates the farming start block
	 * Can only be changed before farming starts
	 * Can only be called by the owner
     */	
    function updateStartBlock(uint256 _newStartBlock) external onlyOwner {
        require(block.number < startBlock, "RobustMasterChef::updateStartBlock:Cannot change start block if farm has already started");
        require(block.number < _newStartBlock, "RobustMasterChef::updateStartBlock:Cannot set start block in the past");
        
		uint256 length = poolInfo.length;
        
		for (uint256 pid = 0; pid < length; ++pid) {
            PoolInfo storage pool = poolInfo[pid];
            pool.lastRewardBlock = _newStartBlock;
        }
		
        startBlock = _newStartBlock;

        emit UpdateStartBlock(startBlock);
    }

    /**
     * @dev Add a new lp to the pool
	 * Can only be called by the owner
     */		
    function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, uint256 _harvestInterval, bool _withUpdate) external onlyOwner nonDuplicated(_lpToken){
        
        // Only valid ERC20 token or fail
        _lpToken.balanceOf(address(this));

		require(_depositFeeBP <= 10000, "RobustMasterChef::add:Invalid deposit fee basis points");
        require(_harvestInterval <= MAXIMUM_HARVEST_INTERVAL, "RobustMasterChef::add:Invalid harvest interval");

		if (_withUpdate) {
            massUpdatePools();
        }
		
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        
		totalAllocPoint = totalAllocPoint.add(_allocPoint);
		poolExistence[_lpToken] = true;
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: _allocPoint,
            lastRewardBlock: lastRewardBlock,
            accRBSPerShare: 0,
            depositFeeBP: _depositFeeBP,
            harvestInterval: _harvestInterval,
			lpSupply: 0
        }));
		
		emit PoolAdd(poolInfo.length.sub(1), address(_lpToken), _allocPoint, _depositFeeBP);
    }

    /**
     * @dev Update the given pool's RBS allocation point and deposit fee
	 * Can only be called by the owner
     */			
    function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, uint256 _harvestInterval, bool _withUpdate) external onlyOwner validatePoolByPid(_pid) {
        require(_depositFeeBP <= 10000, "RobustMasterChef::set:Invalid deposit fee basis points");
        require(_harvestInterval <= MAXIMUM_HARVEST_INTERVAL, "RobustMasterChef::set:Invalid harvest interval");
        
		if (_withUpdate) {
            massUpdatePools();
        }

		totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
        poolInfo[_pid].depositFeeBP = _depositFeeBP;
        poolInfo[_pid].harvestInterval = _harvestInterval;

		emit PoolSet(_pid, address(poolInfo[_pid].lpToken), _allocPoint, _depositFeeBP);
    }

    /**
     * @dev Return reward multiplier over the given _from to _to block
     */		
    function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
        return _to.sub(_from).mul(BONUS_MULTIPLIER);
    }

    /**
     * @dev View function to see pending RBS on frontend
     */		
    function pendingRBS(uint256 _pid, address _user) external view validatePoolByPid(_pid) returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        
		uint256 accRBSPerShare = pool.accRBSPerShare;

		if (block.number > pool.lastRewardBlock && pool.lpSupply != 0 && totalAllocPoint > 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 rbsReward = multiplier.mul(rbsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
			accRBSPerShare = accRBSPerShare.add(rbsReward.mul(1e12).div(pool.lpSupply));
        }
		
        uint256 pending = user.amount.mul(accRBSPerShare).div(1e12).sub(user.rewardDebt);
        
		return pending.add(user.rewardLockedUp);
    }

    /**
     * @dev Checks if user can harvest RBS
     */	
    function canHarvest(uint256 _pid, address _user) public view returns (bool) {
        UserInfo storage user = userInfo[_pid][_user];
        return block.number >= startBlock && block.timestamp >= user.nextHarvestUntil;
    }

    /**
     * @dev Update reward variables for all pools
	 * Be aware of gas cost
     */
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    /**
     * @dev Update reward variables of the given pool
     */		
    function updatePool(uint256 _pid) public validatePoolByPid(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }

        if (pool.lpSupply == 0 || pool.allocPoint == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }

        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 rbsReward = multiplier.mul(rbsPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
 
        //RBS maximum supply minted
		if (rbsReward > mintableRBS()) {
			rbsReward = 0;
			pool.allocPoint = 0;
            pool.lastRewardBlock = block.number;
			rbsPerBlock = 0;
            return;
        }

		if(rbsReward > 0){
			rbs.mint(devAddress, rbsReward.div(10));			
			rbs.mint(address(this), rbsReward);
			pool.accRBSPerShare = pool.accRBSPerShare.add(rbsReward.mul(1e12).div(pool.lpSupply));
			pool.lastRewardBlock = block.number;
		}
    }

    /**
     * @dev Deposit LP tokens to MasterChef for RBS allocation
     */
    function deposit(uint256 _pid, uint256 _amount, address _referrer) external nonReentrant validatePoolByPid(_pid) {
        require(block.number >= startBlock, "RobustMasterChef::deposit:Cannot deposit before farm starts");
		
		PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
		
		require(user.blockActivityNumber <= block.number, "RobustMasterChef::withdraw:Deposit possible only after number of botGuardBlocks");
		
        if (_amount > 0 && address(rbsReferralContract) != address(0) && _referrer != address(0) && _referrer != msg.sender) {
            rbsReferralContract.recordReferral(msg.sender, _referrer);
        }
		
        payOrLockupPendingRBS(_pid);
		
        if (_amount > 0) {
			uint256 balanceBefore = pool.lpToken.balanceOf(address(this));
            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            _amount = pool.lpToken.balanceOf(address(this)).sub(balanceBefore);

            if (pool.depositFeeBP > 0) {
                uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
                pool.lpToken.safeTransfer(feeAddress, depositFee);
                user.amount = user.amount.add(_amount).sub(depositFee);
				pool.lpSupply = pool.lpSupply.add(_amount).sub(depositFee);
            } else {
                user.amount = user.amount.add(_amount);
				pool.lpSupply = pool.lpSupply.add(_amount);
            }
        }

        user.rewardDebt = user.amount.mul(pool.accRBSPerShare).div(1e12);
		user.blockActivityNumber = block.number.add(botGuardBlocks);

		emit Deposit(msg.sender, _pid, _amount);
    }

    /**
     * @dev Withdraw LP tokens from MasterChef
     */
    function withdraw(uint256 _pid, uint256 _amount) external nonReentrant validatePoolByPid(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        
		require(user.blockActivityNumber <= block.number, "RobustMasterChef::withdraw:Withdrawal possible only after number of botGuardBlocks");		
        require(user.amount >= _amount, "RobustMasterChef::withdraw:Invalid amount");

		updatePool(_pid);
        payOrLockupPendingRBS(_pid);
        if (_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.safeTransfer(address(msg.sender), _amount);
			pool.lpSupply = pool.lpSupply.sub(_amount);
        }

        user.rewardDebt = user.amount.mul(pool.accRBSPerShare).div(1e12);
		user.blockActivityNumber = block.number.add(botGuardBlocks);		
        
		emit Withdraw(msg.sender, _pid, _amount);
    }

    /**
     * @dev Withdraw without caring about rewards
	 * EMERGENCY ONLY
     */
    function emergencyWithdraw(uint256 _pid) external nonReentrant validatePoolByPid(_pid) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
		
		require(user.blockActivityNumber <= block.number, "RobustMasterChef::withdraw:Withdrawal possible only after number of botGuardBlocks");		
        
		uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        user.rewardLockedUp = 0;
        user.nextHarvestUntil = 0;
        pool.lpToken.safeTransfer(address(msg.sender), amount);
		
        if (pool.lpSupply >= amount) {
            pool.lpSupply = pool.lpSupply.sub(amount);
        } else {
            pool.lpSupply = 0;
        }

		user.blockActivityNumber = block.number.add(botGuardBlocks);	

        emit EmergencyWithdraw(msg.sender, _pid, amount);
    }

    /**
     * @dev Pay or lockup pending RBS
     */		
    function payOrLockupPendingRBS(uint256 _pid) internal {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        if (user.nextHarvestUntil == 0 && block.number >= startBlock) {
            user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);
        }

        uint256 pending = user.amount.mul(pool.accRBSPerShare).div(1e12).sub(user.rewardDebt);
        if (canHarvest(_pid, msg.sender)) {
            if (pending > 0 || user.rewardLockedUp > 0) {
                uint256 totalRewards = pending.add(user.rewardLockedUp);

                //Reset harvest lockup
                totalLockedUpRewards = totalLockedUpRewards.sub(user.rewardLockedUp);
                user.rewardLockedUp = 0;
                user.nextHarvestUntil = block.timestamp.add(pool.harvestInterval);

                //Send rewards
                safeRBSTransfer(msg.sender, totalRewards);
                payReferralCommission(msg.sender, totalRewards);
            }
        } else if (pending > 0) {
            user.rewardLockedUp = user.rewardLockedUp.add(pending);
            totalLockedUpRewards = totalLockedUpRewards.add(pending);
            emit RewardLockedUp(msg.sender, _pid, pending);
        }
    }

    /**
     * @dev Safe RBS transfer function
     * Just in case if rounding error causes pool to not have enough RBS
     */		
    function safeRBSTransfer(address _to, uint256 _amount) internal {
        uint256 rbsBal = rbs.balanceOf(address(this));
        if (_amount > rbsBal) {
            rbs.transfer(_to, rbsBal);
        } else {
            rbs.transfer(_to, _amount);
        }
    }

    /**
     * @dev Update dev address
     * Can only be called by the current dev address
     */	
    function setDevAddress(address _devAddress) external {
        require(msg.sender == devAddress, "RobustMasterChef::setDevAddress:Only current dev address update this address");
        require(_devAddress != address(0), "RobustMasterChef::setDevAddress: Zero address error");
		
		emit DevAddressUpdated(devAddress, _devAddress);
        
		devAddress = _devAddress;
    }
    /**
     * @dev Update fee address
     * Can only be called by the current fee address 
     */
    function setFeeAddress(address _feeAddress) external {
        require(msg.sender == feeAddress, "RobustMasterChef::setFeeAddress:Only current fee address can update this address");
        require(_feeAddress != address(0), "RobustMasterChef::setFeeAddress:Zero address error");
		
		emit FeeAddressUpdated(feeAddress, _feeAddress);		
        
		feeAddress = _feeAddress;
    }

    /**
     * @dev Update emission rate
     * Can only be called by the owner 
     */		
	function updateEmissionRate(uint256 _rbsPerBlock) external onlyOwner {
        massUpdatePools();
        
		emit EmissionRateUpdated(msg.sender, rbsPerBlock, _rbsPerBlock);
        
		rbsPerBlock = _rbsPerBlock;
    }

    /**
     * @dev Update the RBS referral contract
     * Can only be called by the owner 
     */
    function setRBSReferralContract(IRobustReferral _rbsReferralContract) external onlyOwner {
		require(address(_rbsReferralContract) != address(0),"RobustMasterChef::setRBSReferralContract:Referral contract cannot be zero address");
		
		emit RBSReferralContractUpdated(address(rbsReferralContract), address(_rbsReferralContract));
        
		rbsReferralContract = _rbsReferralContract;
    }

    /**
     * @dev Update the bot guard blocks setting
     * Can only be called by the owner 
     */
    function updateBotGuard(uint8 _botGuardBlocks) external onlyOwner {
		require(_botGuardBlocks <= MAXIMUM_BOTGUARD_BLOCKS, "RobustMasterChef::updateBotGuard:botGuardBlocks cannot exceed maximum blocks");

		emit UpdateBotGuard(botGuardBlocks, _botGuardBlocks);

		botGuardBlocks = _botGuardBlocks;
    }

    /**
     * @dev Update referral commission rate
     * Can only be called by the owner 
     */
    function setReferralCommissionRate(uint16 _referralCommissionRate) external onlyOwner {
        require(_referralCommissionRate <= MAXIMUM_REFERRAL_COMMISSION_RATE, "RobustMasterChef::setReferralCommissionRate:Invalid referral commission rate basis points");
		
		emit ReferralCommissionRateUpdated(referralCommissionRate, _referralCommissionRate);        
		
		referralCommissionRate = _referralCommissionRate;
    }

    /**
     * @dev Pay referral commission to the referrer who referred this user
     */
    function payReferralCommission(address _user, uint256 _pending) internal {
        if (address(rbsReferralContract) != address(0) && referralCommissionRate > 0) {
            address referrer = rbsReferralContract.getReferrer(_user);
            uint256 commissionAmount = _pending.mul(referralCommissionRate).div(10000);

			//RBS maximum supply minted
			if (commissionAmount > mintableRBS()) {
				commissionAmount = 0;
				referralCommissionRate = 0;
				rbsPerBlock = 0;
				return;
			}

            if (referrer != address(0) && commissionAmount > 0) {
                rbs.mint(referrer, commissionAmount);
                rbsReferralContract.recordReferralCommission(referrer, commissionAmount);
                
				emit ReferralCommissionPaid(_user, referrer, commissionAmount);
            }
        }
    }

}