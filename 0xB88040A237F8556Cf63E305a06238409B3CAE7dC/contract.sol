// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


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

// File: @openzeppelin/contracts/math/SafeMath.sol


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

// File: @openzeppelin/contracts/utils/Address.sol


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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol


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

// File: contracts/interfaces/IGoSwapPair.sol

pragma solidity >=0.5.0;

interface IGoSwapPair {
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function isGLP() external pure returns (bool);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external pure returns (address);

    function token0() external pure returns (address);

    function token1() external pure returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function fee() external view returns (uint8);

    function feeTo() external view returns (address);

    function getFeeTo() external view returns (address);

    function creator() external view returns (address);

    function birthday() external view returns (uint256);

    function rootKmul() external view returns (uint8);

    function initialize(address, address) external;

    function setFeeTo(address) external;

    function setrootKmul(uint8) external;

    function setFee(uint8) external;

    function getDeposited()
        external
        view
        returns (uint256 _deposited0, uint256 _deposited1);

    function getDummy()
        external
        view
        returns (uint256 _dummy0, uint256 _dummy1);

    function balanceOfIndex(uint256 tokenIndex)
        external
        view
        returns (uint256 balance);
}

// File: contracts/interfaces/IGoSwapFactory.sol

pragma solidity >=0.5.0;

interface IGoSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function migrator() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
    function setMigrator(address) external;
    function pairCodeHash() external pure returns (bytes32);
}

// File: contracts/interfaces/IGoSwapCompany.sol

pragma solidity >=0.5.0;

interface IGoSwapCompany {
    function factory() external pure returns (address);
    function pairForFactory(address tokenA, address tokenB) external pure returns (address);
    function createPair(address tokenA, address tokenB) external returns (address);
}

// File: contracts/libraries/GoSwapLibrary.sol

pragma solidity >=0.5.0;





/**
 * @title GoSwap库合约
 */
library GoSwapLibrary {
    using SafeMath for uint256;

    /**
     * @dev 排序token地址
     * @notice 返回排序的令牌地址，用于处理按此顺序排序的对中的返回值
     * @param tokenA TokenA
     * @param tokenB TokenB
     * @return token0  Token0
     * @return token1  Token1
     */
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        //确认tokenA不等于tokenB
        require(tokenA != tokenB, 'GoSwapLibrary: IDENTICAL_ADDRESSES');
        //排序token地址
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        //确认token地址不等于0地址
        require(token0 != address(0), 'GoSwapLibrary: ZERO_ADDRESS');
    }

    /**
     * @dev 获取pair合约地址
     * @notice 计算一对的CREATE2地址，而无需进行任何外部调用
     * @param company 配对寻找工厂地址
     * @param tokenA TokenA
     * @param tokenB TokenB
     * @return pair  pair合约地址
     */
    function pairFor(
        address company,
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        // 通过配对寻找工厂合约
        address factory = IGoSwapCompany(company).pairForFactory(tokenA, tokenB);
        //排序token地址
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        // 获取pairCodeHash
        bytes32 pairCodeHash = IGoSwapFactory(factory).pairCodeHash();
        //根据排序的token地址计算create2的pair地址
        pair = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex'ff',
                        factory,
                        keccak256(abi.encodePacked(token0, token1)),
                        pairCodeHash // init code hash
                    )
                )
            )
        );
    }

    /**
     * @dev 获取不含虚流动性的储备量
     * @notice 提取并排序一对的储备金
     * @param company 配对寻找工厂地址
     * @param tokenA TokenA
     * @param tokenB TokenB
     * @return reserveA  储备量A
     * @return reserveB  储备量B
     * @return fee  手续费
     */
    // fetches and sorts the reserves and fee for a pair
    function getReservesWithoutDummy(
        address company,
        address tokenA,
        address tokenB
    )
        internal
        view
        returns (
            uint256 reserveA,
            uint256 reserveB,
            uint8 fee
        )
    {
        //排序token地址
        (address token0, ) = sortTokens(tokenA, tokenB);
        // 实例化配对合约
        IGoSwapPair pair = IGoSwapPair(pairFor(company, tokenA, tokenB));
        // 获取储备量
        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
        // 获取虚流动性
        (uint256 dummy0, uint256 dummy1) = pair.getDummy();
        // 储备量0 - 虚流动性0
        reserve0 -= dummy0;
        // 储备量1 - 虚流动性1
        reserve1 -= dummy1;
        // 排序token
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        // 返回手续费
        fee = pair.fee();
    }

    /**
     * @dev 获取储备量
     * @notice 提取并排序一对的储备金
     * @param company 配对寻找工厂地址
     * @param tokenA TokenA
     * @param tokenB TokenB
     * @return reserveA  储备量A
     * @return reserveB  储备量B
     * @return fee  手续费
     */
    function getReserves(
        address company,
        address tokenA,
        address tokenB
    )
        internal
        view
        returns (
            uint256 reserveA,
            uint256 reserveB,
            uint8 fee
        )
    {
        //排序token地址
        (address token0, ) = sortTokens(tokenA, tokenB);
        //通过排序后的token地址和工厂合约地址获取到pair合约地址,并从pair合约中获取储备量0,1
        (uint256 reserve0, uint256 reserve1, ) = IGoSwapPair(pairFor(company, tokenA, tokenB)).getReserves();
        //根据输入的token顺序返回储备量
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        //获取配对合约中设置的手续费比例
        fee = IGoSwapPair(pairFor(company, tokenA, tokenB)).fee();
    }

    /**
     * @dev 对价计算
     * @notice 给定一定数量的资产和货币对储备金，则返回等值的其他资产
     * @param amountA 数额A
     * @param reserveA 储备量A
     * @param reserveB 储备量B
     * @return amountB  数额B
     */
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        //确认数额A>0
        require(amountA > 0, 'GoSwapLibrary: INSUFFICIENT_AMOUNT');
        //确认储备量A,B大于0
        require(reserveA > 0 && reserveB > 0, 'GoSwapLibrary: INSUFFICIENT_LIQUIDITY');
        //数额B = 数额A * 储备量B / 储备量A
        amountB = amountA.mul(reserveB) / reserveA;
    }

    /**
     * @dev 获取单个输出数额
     * @notice 给定一项资产的输入量和配对的储备，返回另一项资产的最大输出量
     * @param amountIn 输入数额
     * @param reserveIn 储备量In
     * @param reserveOut 储备量Out
     * @param fee 手续费比例
     * @return amountOut  输出数额
     */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) internal pure returns (uint256 amountOut) {
        //确认输入数额大于0
        require(amountIn > 0, 'GoSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        //确认储备量In和储备量Out大于0
        require(reserveIn > 0 && reserveOut > 0, 'GoSwapLibrary: INSUFFICIENT_LIQUIDITY');
        //税后输入数额 = 输入数额 * (1000-fee)
        uint256 amountInWithFee = amountIn.mul(1000 - fee);
        //分子 = 税后输入数额 * 储备量Out
        uint256 numerator = amountInWithFee.mul(reserveOut);
        //分母 = 储备量In * 1000 + 税后输入数额
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        //输出数额 = 分子 / 分母
        amountOut = numerator / denominator;
    }

    /**
     * @dev 获取单个输出数额
     * @notice 给定一项资产的输出量和对储备，返回其他资产的所需输入量
     * @param amountOut 输出数额
     * @param reserveIn 储备量In
     * @param reserveOut 储备量Out
     * @param fee 手续费比例
     * @return amountIn  输入数额
     */
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) internal pure returns (uint256 amountIn) {
        //确认输出数额大于0
        require(amountOut > 0, 'GoSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        //确认储备量In和储备量Out大于0
        require(reserveIn > 0 && reserveOut > 0, 'GoSwapLibrary: INSUFFICIENT_LIQUIDITY');
        //分子 = 储备量In * 储备量Out * 1000
        uint256 numerator = reserveIn.mul(amountOut).mul(1000);
        //分母 = 储备量Out - 输出数额 * (1000-fee)
        uint256 denominator = reserveOut.sub(amountOut).mul(1000 - fee);
        //输入数额 = (分子 / 分母) + 1
        amountIn = (numerator / denominator).add(1);
    }

    /**
     * @dev 获取输出数额
     * @notice 对任意数量的对执行链接的getAmountOut计算
     * @param company 配对寻找工厂合约地址
     * @param amountIn 输入数额
     * @param path 路径数组
     * @return amounts  数额数组
     */
    function getAmountsOut(
        address company,
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        //确认路径数组长度大于2
        require(path.length >= 2, 'GoSwapLibrary: INVALID_PATH');
        //初始化数额数组
        amounts = new uint256[](path.length);
        //数额数组[0] = 输入数额
        amounts[0] = amountIn;
        //遍历路径数组,path长度-1
        for (uint256 i; i < path.length - 1; i++) {
            //(储备量In,储备量Out,手续费比例) = 获取储备(当前路径地址,下一个路径地址)
            (uint256 reserveIn, uint256 reserveOut, uint8 fee) = getReserves(company, path[i], path[i + 1]);
            //下一个数额 = 获取输出数额(当前数额,储备量In,储备量Out)
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, fee);
        }
    }

    /**
     * @dev 获取输出数额
     * @notice 对任意数量的对执行链接的getAmountIn计算
     * @param company 公司合约地址
     * @param amountOut 输出数额
     * @param path 路径数组
     * @return amounts  数额数组
     */
    function getAmountsIn(
        address company,
        uint256 amountOut,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        //确认路径数组长度大于2
        require(path.length >= 2, 'GoSwapLibrary: INVALID_PATH');
        //初始化数额数组
        amounts = new uint256[](path.length);
        //数额数组最后一个元素 = 输出数额
        amounts[amounts.length - 1] = amountOut;
        //从倒数第二个元素倒叙遍历路径数组
        for (uint256 i = path.length - 1; i > 0; i--) {
            //(储备量In,储备量Out,手续费比例) = 获取储备(上一个路径地址,当前路径地址)
            (uint256 reserveIn, uint256 reserveOut, uint8 fee) = getReserves(company, path[i - 1], path[i]);
            //上一个数额 = 获取输入数额(当前数额,储备量In,储备量Out)
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, fee);
        }
    }
}

// File: contracts/libraries/TransferHelper.sol

pragma solidity >=0.6.0;

// helper methods for interacting with ERC20 tokens and sending HT that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferHT(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: HT_TRANSFER_FAILED');
    }
}

// File: contracts/interfaces/IGoSwapRouter.sol

pragma solidity >=0.6.2;

interface IGoSwapRouter {
    function factory() external view returns (address);
    function company() external pure returns (address);

    function WHT() external pure returns (address);

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

    function addLiquidityHT(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountHT,
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

    function removeLiquidityHT(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountHT);

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

    function removeLiquidityHTWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountHT);

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

    function swapExactHTForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactHT(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForHT(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapHTForExactTokens(
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
        uint256 reserveOut,
        uint8 fee
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function removeLiquidityHTSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountHT);

    function removeLiquidityHTWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountHT);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactHTForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForHTSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

// File: contracts/interfaces/IERC20GoSwap.sol

pragma solidity >=0.5.0;

interface IERC20GoSwap {
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
}

// File: contracts/interfaces/IWHT.sol

pragma solidity >=0.5.0;

interface IWHT {
    function deposit() external payable;
    function transfer(address, uint) external returns (bool);
    function withdraw(uint) external;
}

// File: contracts/GoSwapRouter.sol

pragma solidity =0.6.12;







/**
 * @title GoSwap 路由合约
 */
contract GoSwapRouter is IGoSwapRouter {
    using SafeMath for uint256;

    /// @notice 布署时定义的常量pairFor地址和WHT地址
    address public immutable override company;
    address public immutable override WHT;

    /**
     * @dev 修饰符:确保最后期限大于当前时间
     */
    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, 'GoSwapRouter: EXPIRED');
        _;
    }

    /**
     * @dev 返回当前在使用的工厂合约地址,兼容旧版
     */
    function factory() public view override returns (address) {
        return IGoSwapCompany(company).factory();
    }

    /**
     * @dev 构造函数
     * @param _company 寻找配对合约地址
     * @param _WHT WHT合约地址 
     */
    constructor(address _company, address _WHT) public {
        company = _company;
        WHT = _WHT;
    }

    /**
     * @dev 收款方法
     */
    receive() external payable {
        //断言调用者为WHT合约地址
        assert(msg.sender == WHT); // only accept HT via fallback from the WHT contract
    }

    // **** 添加流动性 ****
    /**
     * @dev 添加流动性的私有方法
     * @param tokenA tokenA地址
     * @param tokenB tokenB地址
     * @param amountADesired 期望数量A
     * @param amountBDesired 期望数量B
     * @param amountAMin 最小数量A
     * @param amountBMin 最小数量B
     * @return amountA   数量A
     * @return amountB   数量B
     */
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal virtual returns (uint256 amountA, uint256 amountB) {
        // 通过配对寻找工厂合约
        address pairFactory = IGoSwapCompany(company).pairForFactory(tokenA, tokenB);
        //如果工厂合约不存在,则创建配对
        if (pairFactory == address(0)) {
            IGoSwapCompany(company).createPair(tokenA, tokenB);
        }
        //获取不含虚流动性的储备量reserve{A,B}
        (uint256 reserveA, uint256 reserveB, ) = GoSwapLibrary.getReservesWithoutDummy(company, tokenA, tokenB);
        //如果储备reserve{A,B}==0
        if (reserveA == 0 && reserveB == 0) {
            //数量amount{A,B} = 期望数量A,B
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            //最优数量B = 期望数量A * 储备B / 储备A
            uint256 amountBOptimal = GoSwapLibrary.quote(amountADesired, reserveA, reserveB);
            //如果最优数量B <= 期望数量B
            if (amountBOptimal <= amountBDesired) {
                //确认最优数量B >= 最小数量B
                require(amountBOptimal >= amountBMin, 'GoSwapRouter: INSUFFICIENT_B_AMOUNT');
                //数量amount{A,B} = 期望数量A, 最优数量B
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                //最优数量A = 期望数量A * 储备A / 储备B
                uint256 amountAOptimal = GoSwapLibrary.quote(amountBDesired, reserveB, reserveA);
                //断言最优数量A <= 期望数量A
                assert(amountAOptimal <= amountADesired);
                //确认最优数量A >= 最小数量A
                require(amountAOptimal >= amountAMin, 'GoSwapRouter: INSUFFICIENT_A_AMOUNT');
                //数量amount{A,B} = 最优数量A, 期望数量B
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    /**
     * @dev 添加流动性方法*
     * @param tokenA tokenA地址
     * @param tokenB tokenB地址
     * @param amountADesired 期望数量A
     * @param amountBDesired 期望数量B
     * @param amountAMin 最小数量A
     * @param amountBMin 最小数量B
     * @param to to地址
     * @param deadline 最后期限
     * @return amountA   数量A
     * @return amountB   数量B
     * @return liquidity   流动性数量
     */
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
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        //添加流动性,获取数量A,数量B
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        //根据TokenA,TokenB地址,获取`pair合约`地址
        address pair = GoSwapLibrary.pairFor(company, tokenA, tokenB);
        //将数量为amountA的tokenA从msg.sender账户中安全发送到pair合约地址
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        //将数量为amountB的tokenB从msg.sender账户中安全发送到pair合约地址
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        //流动性数量 = pair合约的铸造方法铸造给to地址的返回值
        liquidity = IGoSwapPair(pair).mint(to);
    }

    /**
     * @dev 添加HT流动性方法*
     * @param token token地址
     * @param amountTokenDesired Token期望数量
     * @param amountTokenMin Token最小数量
     * @param amountHTMin HT最小数量
     * @param to to地址
     * @param deadline 最后期限
     * @return amountToken   Token数量
     * @return amountHT   ETH数量
     * @return liquidity   流动性数量
     */
    function addLiquidityHT(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        returns (
            uint256 amountToken,
            uint256 amountHT,
            uint256 liquidity
        )
    {
        //添加流动性,获取Token数量,HT数量
        (amountToken, amountHT) = _addLiquidity(token, WHT, amountTokenDesired, msg.value, amountTokenMin, amountHTMin);
        //根据Token,WHT地址,获取`pair合约`地址
        address pair = GoSwapLibrary.pairFor(company, token, WHT);
        //将`Token数量`的token从msg.sender账户中安全发送到`pair合约`地址
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        //向`HT合约`存款`HT数量`的主币
        IWHT(WHT).deposit{value: amountHT}();
        //将`HT数量`的`HT`token发送到`pair合约`地址
        assert(IWHT(WHT).transfer(pair, amountHT));
        //流动性数量 = pair合约的铸造方法铸造给`to地址`的返回值
        liquidity = IGoSwapPair(pair).mint(to);
        //如果`收到的主币数量`>`HT数量` 则返还`收到的主币数量`-`HT数量`
        if (msg.value > amountHT) TransferHelper.safeTransferHT(msg.sender, msg.value - amountHT);
    }

    // **** 移除流动性 ****
    /**
     * @dev 移除流动性*
     * @param tokenA tokenA地址
     * @param tokenB tokenB地址
     * @param liquidity 流动性数量
     * @param amountAMin 最小数量A
     * @param amountBMin 最小数量B
     * @param to to地址
     * @param deadline 最后期限
     * @return amountA   数量A
     * @return amountB   数量B
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
        //计算TokenA,TokenB的CREATE2地址，而无需进行任何外部调用
        address pair = GoSwapLibrary.pairFor(company, tokenA, tokenB);
        //将流动性数量从用户发送到pair地址(需提前批准)
        IERC20GoSwap(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        //pair合约销毁流动性数量,并将数值0,1的token发送到to地址
        (uint256 amount0, uint256 amount1) = IGoSwapPair(pair).burn(to);
        //排序tokenA,tokenB
        (address token0, ) = GoSwapLibrary.sortTokens(tokenA, tokenB);
        //按排序后的token顺序返回数值AB
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        //确保数值AB大于最小值AB
        require(amountA >= amountAMin, 'GoSwapRouter: INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'GoSwapRouter: INSUFFICIENT_B_AMOUNT');
    }

    /**
     * @dev 移除HT流动性*
     * @param token token地址
     * @param liquidity 流动性数量
     * @param amountTokenMin token最小数量
     * @param amountHTMin HT最小数量
     * @param to to地址
     * @param deadline 最后期限
     * @return amountToken   token数量
     * @return amountHT   HT数量
     */
    function removeLiquidityHT(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256 amountToken, uint256 amountHT) {
        //(token数量,HT数量) = 移除流动性(token地址,WHT地址,流动性数量,token最小数量,HT最小数量,当前合约地址,最后期限)
        (amountToken, amountHT) = removeLiquidity(
            token,
            WHT,
            liquidity,
            amountTokenMin,
            amountHTMin,
            address(this),
            deadline
        );
        //将token数量的token发送到to地址
        TransferHelper.safeTransfer(token, to, amountToken);
        //从WHT取款HT数量的主币
        IWHT(WHT).withdraw(amountHT);
        //将HT数量的HT发送到to地址
        TransferHelper.safeTransferHT(to, amountHT);
    }

    /**
     * @dev 带签名移除流动性*
     * @param tokenA tokenA地址
     * @param tokenB tokenB地址
     * @param liquidity 流动性数量
     * @param amountAMin 最小数量A
     * @param amountBMin 最小数量B
     * @param to to地址
     * @param deadline 最后期限
     * @param approveMax 全部批准
     * @param v v
     * @param r r
     * @param s s
     * @return amountA   数量A
     * @return amountB   数量B
     */
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
    ) external virtual override returns (uint256 amountA, uint256 amountB) {
        //计算TokenA,TokenB的CREATE2地址，而无需进行任何外部调用
        address pair = GoSwapLibrary.pairFor(company, tokenA, tokenB);
        //如果全部批准,value值等于最大uint256,否则等于流动性
        uint256 value = approveMax ? uint256(-1) : liquidity;
        //调用pair合约的许可方法(调用账户,当前合约地址,数值,最后期限,v,r,s)
        IERC20GoSwap(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        //(数量A,数量B) = 移除流动性(tokenA地址,tokenB地址,流动性数量,最小数量A,最小数量B,to地址,最后期限)
        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
    }

    /**
     * @dev 带签名移除HT流动性*
     * @param token token地址
     * @param liquidity 流动性数量
     * @param amountTokenMin token最小数量
     * @param amountHTMin HT最小数量
     * @param to to地址
     * @param deadline 最后期限
     * @param approveMax 全部批准
     * @param v v
     * @param r r
     * @param s s
     * @return amountToken   token数量
     * @return amountHT   HT数量
     */
    function removeLiquidityHTWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountToken, uint256 amountHT) {
        //计算Token,WETH的CREATE2地址，而无需进行任何外部调用
        address pair = GoSwapLibrary.pairFor(company, token, WHT);
        //如果全部批准,value值等于最大uint256,否则等于流动性
        uint256 value = approveMax ? uint256(-1) : liquidity;
        //调用pair合约的许可方法(调用账户,当前合约地址,数值,最后期限,v,r,s)
        IERC20GoSwap(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        //(token数量,HT数量) = 移除HT流动性(token地址,流动性数量,token最小数量,HT最小数量,to地址,最后期限)
        (amountToken, amountHT) = removeLiquidityHT(token, liquidity, amountTokenMin, amountHTMin, to, deadline);
    }

    /**
     * @dev 移除流动性支持Token收转帐税*
     * @param token token地址
     * @param liquidity 流动性数量
     * @param amountTokenMin token最小数量
     * @param amountHTMin HT最小数量
     * @param to to地址
     * @param deadline 最后期限
     * @return amountHT   HT数量
     */
    function removeLiquidityHTSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256 amountHT) {
        //(,HT数量) = 移除流动性(token地址,WHT地址,流动性数量,token最小数量,HT最小数量,当前合约地址,最后期限)
        (, amountHT) = removeLiquidity(token, WHT, liquidity, amountTokenMin, amountHTMin, address(this), deadline);
        //将当前合约中的token数量的token发送到to地址
        TransferHelper.safeTransfer(token, to, IERC20GoSwap(token).balanceOf(address(this)));
        //从WHT取款HT数量的主币
        IWHT(WHT).withdraw(amountHT);
        //将HT数量的HT发送到to地址
        TransferHelper.safeTransferHT(to, amountHT);
    }

    /**
     * @dev 带签名移除流动性,支持Token收转帐税*
     * @param token token地址
     * @param liquidity 流动性数量
     * @param liquidity 流动性数量
     * @param amountTokenMin token最小数量
     * @param amountHTMin HT最小数量
     * @param to to地址
     * @param deadline 最后期限
     * @param approveMax 全部批准
     * @param v v
     * @param r r
     * @param s s
     * @return amountHT   HT数量
     */
    function removeLiquidityHTWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountHTMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override returns (uint256 amountHT) {
        //计算Token,WHT的CREATE2地址，而无需进行任何外部调用
        address pair = GoSwapLibrary.pairFor(company, token, WHT);
        //如果全部批准,value值等于最大uint256,否则等于流动性
        uint256 value = approveMax ? uint256(-1) : liquidity;
        //调用pair合约的许可方法(调用账户,当前合约地址,数值,最后期限,v,r,s)
        IERC20GoSwap(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        //(,HT数量) = 移除流动性支持Token收转帐税(token地址,流动性数量,Token最小数量,HT最小数量,to地址,最后期限)
        amountHT = removeLiquidityHTSupportingFeeOnTransferTokens(
            token,
            liquidity,
            amountTokenMin,
            amountHTMin,
            to,
            deadline
        );
    }

    // **** 交换 ****
    /**
     * @dev 私有交换*
     * @notice 要求初始金额已经发送到第一对
     * @param amounts 数额数组
     * @param path 路径数组
     * @param _to to地址
     */
    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) internal virtual {
        //遍历路径数组
        for (uint256 i; i < path.length - 1; i++) {
            //(输入地址,输出地址) = (当前地址,下一个地址)
            (address input, address output) = (path[i], path[i + 1]);
            //token0 = 排序(输入地址,输出地址)
            (address token0, ) = GoSwapLibrary.sortTokens(input, output);
            //输出数量 = 数额数组下一个数额
            uint256 amountOut = amounts[i + 1];
            //(输出数额0,输出数额1) = 输入地址==token0 ? (0,输出数额) : (输出数额,0)
            (uint256 amount0Out, uint256 amount1Out) =
                input == token0 ? (uint256(0), amountOut) : (amountOut, uint256(0));
            //to地址 = i<路径长度-2 ? (输出地址,路径下下个地址)的pair合约地址 : to地址
            address to = i < path.length - 2 ? GoSwapLibrary.pairFor(company, output, path[i + 2]) : _to;
            //调用(输入地址,输出地址)的pair合约地址的交换方法(输出数额0,输出数额1,to地址,0x00)
            IGoSwapPair(GoSwapLibrary.pairFor(company, input, output)).swap(
                amount0Out,
                amount1Out,
                to,
                new bytes(0)
            );
        }
    }

    /**
     * @dev 根据精确的token交换尽量多的token*
     * @param amountIn 精确输入数额
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //数额数组 ≈ 遍历路径数组(
        //      (输入数额 * (1000-fee) * 储备量Out) /
        //      (储备量In * 1000 + 输入数额 * (1000-fee)))
        amounts = GoSwapLibrary.getAmountsOut(company, amountIn, path);
        //确认数额数组最后一个元素>=最小输出数额
        require(amounts[amounts.length - 1] >= amountOutMin, 'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        //将数量为数额数组[0]的路径[0]的token从调用者账户发送到路径0,1的pair合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amounts[0]
        );
        //私有交换(数额数组,路径数组,to地址)
        _swap(amounts, path, to);
    }

    /**
     * @dev 使用尽量少的token交换精确的token*
     * @param amountOut 精确输出数额
     * @param amountInMax 最大输入数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //数额数组 ≈ 遍历路径数组(
        //      (储备量In * 储备量Out * 1000) /
        //      (储备量Out - 输出数额 * (1000-fee)) + 1)
        amounts = GoSwapLibrary.getAmountsIn(company, amountOut, path);
        //确认数额数组第一个元素<=最大输入数额
        require(amounts[0] <= amountInMax, 'GoSwapRouter: EXCESSIVE_INPUT_AMOUNT');
        //将数量为数额数组[0]的路径[0]的token从调用者账户发送到路径0,1的pair合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amounts[0]
        );
        //私有交换(数额数组,路径数组,to地址)
        _swap(amounts, path, to);
    }

    /**
     * @dev 根据精确的ETH交换尽量多的token*
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapExactHTForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //确认路径第一个地址为WHT
        require(path[0] == WHT, 'GoSwapRouter: INVALID_PATH');
        //数额数组 ≈ 遍历路径数组(
        //      (msg.value * (1000-fee) * 储备量Out) /
        //      (储备量In * 1000 + msg.value * (1000-fee)))
        amounts = GoSwapLibrary.getAmountsOut(company, msg.value, path);
        //确认数额数组最后一个元素>=最小输出数额
        require(amounts[amounts.length - 1] >= amountOutMin, 'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        //将数额数组[0]的数额存款HT到HT合约
        IWHT(WHT).deposit{value: amounts[0]}();
        //断言将数额数组[0]的数额的HT发送到路径(0,1)的pair合约地址
        assert(IWHT(WHT).transfer(GoSwapLibrary.pairFor(company, path[0], path[1]), amounts[0]));
        //私有交换(数额数组,路径数组,to地址)
        _swap(amounts, path, to);
    }

    /**
     * @dev 使用尽量少的token交换精确的HT*
     * @param amountOut 精确输出数额
     * @param amountInMax 最大输入数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapTokensForExactHT(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //确认路径最后一个地址为WHT
        require(path[path.length - 1] == WHT, 'GoSwapRouter: INVALID_PATH');
        //数额数组 ≈ 遍历路径数组(
        //      (储备量In * 储备量Out * 1000) /
        //      (储备量Out - 输出数额 * (1000-fee)) + 1)
        amounts = GoSwapLibrary.getAmountsIn(company, amountOut, path);
        //确认数额数组第一个元素<=最大输入数额
        require(amounts[0] <= amountInMax, 'GoSwapRouter: EXCESSIVE_INPUT_AMOUNT');
        //将数量为数额数组[0]的路径[0]的token从调用者账户发送到路径0,1的pair合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amounts[0]
        );
        //私有交换(数额数组,路径数组,当前合约地址)
        _swap(amounts, path, address(this));
        //从HT合约提款数额数组最后一个数值的HT
        IWHT(WHT).withdraw(amounts[amounts.length - 1]);
        //将数额数组最后一个数值的ETH发送到to地址
        TransferHelper.safeTransferHT(to, amounts[amounts.length - 1]);
    }

    /**
     * @dev 根据精确的token交换尽量多的HT*
     * @param amountIn 精确输入数额
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapExactTokensForHT(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //确认路径最后一个地址为WHT
        require(path[path.length - 1] == WHT, 'GoSwapRouter: INVALID_PATH');
        //数额数组 ≈ 遍历路径数组(
        //      (输入数额 * (1000-fee) * 储备量Out) /
        //      (储备量In * 1000 + 输入数额 * (1000-fee))))
        amounts = GoSwapLibrary.getAmountsOut(company, amountIn, path);
        //确认数额数组最后一个元素>=最小输出数额
        require(amounts[amounts.length - 1] >= amountOutMin, 'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        //将数量为数额数组[0]的路径[0]的token从调用者账户发送到路径0,1的pair合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amounts[0]
        );
        //私有交换(数额数组,路径数组,当前合约地址)
        _swap(amounts, path, address(this));
        //从WHT合约提款数额数组最后一个数值的HT
        IWHT(WHT).withdraw(amounts[amounts.length - 1]);
        //将数额数组最后一个数值的HT发送到to地址
        TransferHelper.safeTransferHT(to, amounts[amounts.length - 1]);
    }

    /**
     * @dev 使用尽量少的HT交换精确的token*
     * @param amountOut 精确输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     * @return amounts  数额数组
     */
    function swapHTForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable virtual override ensure(deadline) returns (uint256[] memory amounts) {
        //确认路径第一个地址为WHT
        require(path[0] == WHT, 'GoSwapRouter: INVALID_PATH');
        //数额数组 ≈ 遍历路径数组(
        //      (储备量In * 储备量Out * 1000) /
        //      (储备量Out - 输出数额 * (1000-fee)) + 1)
        amounts = GoSwapLibrary.getAmountsIn(company, amountOut, path);
        //确认数额数组第一个元素<=msg.value
        require(amounts[0] <= msg.value, 'GoSwapRouter: EXCESSIVE_INPUT_AMOUNT');
        //将数额数组[0]的数额存款ETH到WHT合约
        IWHT(WHT).deposit{value: amounts[0]}();
        //断言将数额数组[0]的数额的WHT发送到路径(0,1)的pair合约地址
        assert(IWHT(WHT).transfer(GoSwapLibrary.pairFor(company, path[0], path[1]), amounts[0]));
        //私有交换(数额数组,路径数组,to地址)
        _swap(amounts, path, to);
        //如果`收到的主币数量`>`数额数组[0]` 则返还`收到的主币数量`-`数额数组[0]`
        if (msg.value > amounts[0]) TransferHelper.safeTransferHT(msg.sender, msg.value - amounts[0]);
    }

    // **** 交换 (支持收取转帐税的Token) ****
    // requires the initial amount to have already been sent to the first pair
    /**
     * @dev 私有交换支持Token收转帐税*
     * @param path 路径数组
     * @param _to to地址
     */
    function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
        //遍历路径数组
        for (uint256 i; i < path.length - 1; i++) {
            //(输入地址,输出地址) = (当前地址,下一个地址)
            (address input, address output) = (path[i], path[i + 1]);
            // 根据输入地址,输出地址找到配对合约
            IGoSwapPair pair = IGoSwapPair(GoSwapLibrary.pairFor(company, input, output));
            //token0 = 排序(输入地址,输出地址)
            (address token0, ) = GoSwapLibrary.sortTokens(input, output);
            // 定义一些数额变量
            uint256 amountInput;
            uint256 amountOutput;
            {
                //避免堆栈太深的错误
                //获取配对的交易手续费
                uint8 fee = pair.fee();
                //获取配对合约的储备量0,储备量1
                (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
                // 排序输入储备量和输出储备量
                (uint256 reserveInput, uint256 reserveOutput) =
                    input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
                // 储备量0,1,配对合约中的余额-储备量
                amountInput = input == token0
                    ? pair.balanceOfIndex(0).sub(reserve0)
                    : pair.balanceOfIndex(1).sub(reserve1);
                //根据输入数额,输入储备量,输出储备量,交易手续费计算输出数额
                amountOutput = GoSwapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput, fee);
            }
            // // 排序输出数额0,输出数额1
            (uint256 amount0Out, uint256 amount1Out) =
                input == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
            //to地址 = i<路径长度-2 ? (输出地址,路径下下个地址)的pair合约地址 : to地址
            address to = i < path.length - 2 ? GoSwapLibrary.pairFor(company, output, path[i + 2]) : _to;
            //调用pair合约的交换方法(输出数额0,输出数额1,to地址,0x00)
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    /**
     * @dev 根据精确的token交换尽量多的token,支持Token收转帐税*
     * @param amountIn 精确输入数额
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     */
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) {
        //将数量为数额数组[0]的路径[0]的token从调用者账户发送到路径0,1的pair合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amountIn
        );
        // 记录to地址在地址路径最后一个token中的余额
        uint256 balanceBefore = IERC20GoSwap(path[path.length - 1]).balanceOf(to);
        // 调用私有交换支持Token收转帐税方法
        _swapSupportingFeeOnTransferTokens(path, to);
        // 确认to地址收到的地址路径中最后一个token数量大于最小输出数量
        require(
            IERC20GoSwap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }

    /**
     * @dev 根据精确的ETH交换尽量多的token,支持Token收转帐税*
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     */
    function swapExactHTForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable virtual override ensure(deadline) {
        //确认路径第一个地址为WHT
        require(path[0] == WHT, 'GoSwapRouter: INVALID_PATH');
        //输入数量=合约收到的主币数量
        uint256 amountIn = msg.value;
        //向WHT合约存款HT
        IWHT(WHT).deposit{value: amountIn}();
        //断言将WHT发送到了地址路径0,1组成的配对合约中
        assert(IWHT(WHT).transfer(GoSwapLibrary.pairFor(company, path[0], path[1]), amountIn));
        // 记录to地址在地址路径最后一个token中的余额
        uint256 balanceBefore = IERC20GoSwap(path[path.length - 1]).balanceOf(to);
        // 调用私有交换支持Token收转帐税方法
        _swapSupportingFeeOnTransferTokens(path, to);
        // 确认to地址收到的地址路径中最后一个token数量大于最小输出数量
        require(
            IERC20GoSwap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }

    /**
     * @dev 根据精确的token交换尽量多的HT,支持Token收转帐税*
     * @param amountIn 精确输入数额
     * @param amountOutMin 最小输出数额
     * @param path 路径数组
     * @param to to地址
     * @param deadline 最后期限
     */
    function swapExactTokensForHTSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) {
        //确认路径最后一个地址为WHT
        require(path[path.length - 1] == WHT, 'GoSwapRouter: INVALID_PATH');
        //将地址路径0的Token发送到地址路径0,1组成的配对合约
        TransferHelper.safeTransferFrom(
            path[0],
            msg.sender,
            GoSwapLibrary.pairFor(company, path[0], path[1]),
            amountIn
        );
        //调用私有交换支持Token收转帐税方法
        _swapSupportingFeeOnTransferTokens(path, address(this));
        //输出金额=当前合约收到的WHT数量
        uint256 amountOut = IERC20GoSwap(WHT).balanceOf(address(this));
        //确认输出金额大于最小输出数额
        require(amountOut >= amountOutMin, 'GoSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        //向WHT合约取款
        IWHT(WHT).withdraw(amountOut);
        //将HT发送到to地址
        TransferHelper.safeTransferHT(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) public pure virtual override returns (uint256 amountB) {
        return GoSwapLibrary.quote(amountA, reserveA, reserveB);
    }

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) public pure virtual override returns (uint256 amountOut) {
        return GoSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut, fee);
    }

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut,
        uint8 fee
    ) public pure virtual override returns (uint256 amountIn) {
        return GoSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut, fee);
    }

    function getAmountsOut(uint256 amountIn, address[] memory path)
        public
        view
        virtual
        override
        returns (uint256[] memory amounts)
    {
        return GoSwapLibrary.getAmountsOut(company, amountIn, path);
    }

    function getAmountsIn(uint256 amountOut, address[] memory path)
        public
        view
        virtual
        override
        returns (uint256[] memory amounts)
    {
        return GoSwapLibrary.getAmountsIn(company, amountOut, path);
    }
}