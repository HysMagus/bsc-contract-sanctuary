//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//   ██████╗ ███████╗ ██████╗ ██████╗  ██████╗███████╗    ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗  //
//  ██╔════╝ ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║  //
//  ██║  ███╗█████╗  ██║   ██║██████╔╝██║     █████╗         ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║  //
//  ██║   ██║██╔══╝  ██║   ██║██╔══██╗██║     ██╔══╝         ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║  //
//  ╚██████╔╝██║     ╚██████╔╝██║  ██║╚██████╗███████╗       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║  //
//   ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝  //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
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
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
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
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an BNB balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) =
            target.call{value: weiValue}(data);
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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IPancakeV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IPancakeV2Pair {
    function sync() external;
}

interface IPancakeV2Router01 {
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
}

interface IPancakeV2Router02 is IPancakeV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

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
}

contract Balancer {
    using SafeMath for uint256;
    IPancakeV2Router02 public immutable _pancakeV2Router;
    GFORCE private _tokenContract;

    constructor(GFORCE tokenContract, IPancakeV2Router02 pancakeV2Router)
        public
    {
        _tokenContract = tokenContract;
        _pancakeV2Router = pancakeV2Router;
    }

    receive() external payable {}

    function rebalance() external returns (uint256) {
        swapEthForTokens(address(this).balance);
    }

    function swapEthForTokens(uint256 EthAmount) private {
        address[] memory pancakePairPath = new address[](2);
        pancakePairPath[0] = _pancakeV2Router.WETH();
        pancakePairPath[1] = address(_tokenContract);

        _pancakeV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: EthAmount
        }(0, pancakePairPath, address(this), block.timestamp);
    }
}

contract Swaper {
    using SafeMath for uint256;
    IPancakeV2Router02 public immutable _pancakeV2Router;
    GFORCE private _tokenContract;

    constructor(GFORCE tokenContract, IPancakeV2Router02 pancakeV2Router)
        public
    {
        _tokenContract = tokenContract;
        _pancakeV2Router = pancakeV2Router;
    }

    function swapTokens(address pairTokenAddress, uint256 tokenAmount)
        external
    {
        uint256 initialPairTokenBalance =
            IERC20(pairTokenAddress).balanceOf(address(this));
        swapTokensForTokens(pairTokenAddress, tokenAmount);
        uint256 newPairTokenBalance =
            IERC20(pairTokenAddress).balanceOf(address(this)).sub(
                initialPairTokenBalance
            );
        IERC20(pairTokenAddress).transfer(
            address(_tokenContract),
            newPairTokenBalance
        );
    }

    function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount)
        private
    {
        address[] memory path = new address[](2);
        path[0] = address(_tokenContract);
        path[1] = pairTokenAddress;

        _tokenContract.approve(address(_pancakeV2Router), tokenAmount);

        // make the swap
        _pancakeV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of pair token
            path,
            address(this),
            block.timestamp
        );
    }
}

contract GFORCE is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    IPancakeV2Router02 public immutable _pancakeV2Router;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcluded;
    mapping(address => bool) public _isWhiteListed;
    address[] private _excluded;
    address public _pancakeBNBPool;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1000000e9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 public _tFeeTotal;
    uint256 public _tBurnTotal;

    string private _name = "TEST";
    string private _symbol = "TEST";
    uint8 private _decimals = 9;

    uint256 public _feeDecimals = 1;
    uint256 public _taxFee = 10;
    uint256 public _lockFee = 10;
    uint256 public _maxTxAmount = 1000000e9;
    uint256 public _minTokensBeforeSwap = 100e9;
    uint256 private _autoSwapCallerFee = 2e9;

    address public _lpStakingPool =
        address(0x305b0eCf72634825f7231058444c65D885E1f327); // should update when LP staking pool deployed
    address public _jetsStakingPool =
        address(0x305b0eCf72634825f7231058444c65D885E1f327); // should update when JETS staking pool deployed

    bool private inSwapAndLiquify;
    bool public swapAndLiquifyEnabled;
    bool public tradingEnabled;

    address private currentPairTokenAddress;
    address private currentPoolAddress;

    event FeeDecimalsUpdated(uint256 taxFeeDecimals);
    event TaxFeeUpdated(uint256 taxFee);
    event LockFeeUpdated(uint256 lockFee);
    event MaxTxAmountUpdated(uint256 maxTxAmount);
    event PoolAndPairTokenUpdated(
        address indexed poolAddress,
        address indexed pairTokenAddress
    );
    event StakingPoolUpdated(
        address indexed lpStakingPool,
        address indexed jetsStakingPool
    );
    event TradingEnabled();
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        address indexed pairTokenAddress,
        uint256 tokensSwapped,
        uint256 pairTokenReceived,
        uint256 tokensIntoLiqudity
    );
    event Rebalance(uint256 tokenBurnt);
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    Balancer public balancer;
    Swaper public swaper;

    constructor(IPancakeV2Router02 pancakeV2Router) public {
        _pancakeV2Router = pancakeV2Router;

        balancer = new Balancer(this, pancakeV2Router);
        swaper = new Swaper(this, pancakeV2Router);

        currentPoolAddress = IPancakeV2Factory(pancakeV2Router.factory())
            .createPair(address(this), pancakeV2Router.WETH());
        currentPairTokenAddress = pancakeV2Router.WETH();
        _pancakeBNBPool = currentPoolAddress;

        updateSwapAndLiquifyEnabled(false);

        _rOwned[_msgSender()] = reflectionFromToken(_tTotal, false);

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

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
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
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
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
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

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function isWhiteListed(address account) public view returns (bool) {
        return _isWhiteListed[account];
    }

    function materialize(uint256 tAmount) public {
        address sender = _msgSender();
        require(
            !_isExcluded[sender],
            "Gforce: Excluded addresses cannot call this function"
        );
        (uint256 rAmount, , , , , ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount, , , , , ) = _getValues(tAmount);
            return rAmount;
        } else {
            (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Gforce: Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeAccount(address account) external onlyOwner() {
        require(
            account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
            "Gforce: We can not exclude Pancake router."
        );
        require(
            account != address(this),
            "Gforce: We can not exclude contract self."
        );
        require(!_isExcluded[account], "Gforce: Account is already excluded");

        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyOwner() {
        require(_isExcluded[account], "Gforce: Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function includeWhiteList(address account) external onlyOwner() {
        require(
            !_isWhiteListed[account],
            "Gforce: Account is already whitelisted"
        );

        _isWhiteListed[account] = true;
    }

    function excludeWhiteList(address account) external onlyOwner() {
        require(
            _isWhiteListed[account],
            "Gforce: Account is not already whitelisted"
        );

        _isWhiteListed[account] = false;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "Gforce: approve from the zero address");
        require(spender != address(0), "Gforce: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), "Gforce: transfer from the zero address");
        require(
            recipient != address(0),
            "Gforce: transfer to the zero address"
        );
        require(
            amount > 0,
            "Gforce: Transfer amount must be greater than zero"
        );

        if (sender != owner() && recipient != owner() && !inSwapAndLiquify) {
            require(
                amount <= _maxTxAmount,
                "Gforce: Transfer amount exceeds the maxTxAmount."
            );
            if (
                (_msgSender() == currentPoolAddress ||
                    _msgSender() == address(_pancakeV2Router)) &&
                !tradingEnabled
            ) require(false, "Gforce: trading is disabled.");
        }

        if (!inSwapAndLiquify) {
            uint256 lockedBalanceForPool = balanceOf(address(this));
            bool overMinTokenBalance =
                lockedBalanceForPool >= _minTokensBeforeSwap;
            if (
                overMinTokenBalance &&
                msg.sender != currentPoolAddress &&
                swapAndLiquifyEnabled
            ) {
                if (currentPairTokenAddress == _pancakeV2Router.WETH())
                    swapAndLiquifyForEth(lockedBalanceForPool);
                else
                    swapAndLiquifyForTokens(
                        currentPairTokenAddress,
                        lockedBalanceForPool
                    );
            }
        }

        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
    }

    receive() external payable {}

    function swapAndLiquifyForEth(uint256 lockedBalanceForPool)
        private
        lockTheSwap
    {
        // split the contract balance except swapCallerFee into halves
        uint256 lockedForSwapAndJetsPool =
            lockedBalanceForPool.sub(_autoSwapCallerFee);

        // 5% is used for jets staking pool reward
        uint256 lockedForJetsPool = lockedForSwapAndJetsPool.mul(5).div(100);
        _transfer(address(this), _jetsStakingPool, lockedForJetsPool);

        // 95% is used for swapping and adding liquidity
        uint256 lockedForSwap = lockedForSwapAndJetsPool.mul(95).div(100);

        uint256 half = lockedForSwap.div(2);
        uint256 otherHalf = lockedForSwap.sub(half);

        // capture the contract's current BNB balance.
        // this is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for BNB
        swapTokensForEth(half);

        // how much BNB did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to pancake
        addLiquidityForEth(otherHalf, newBalance);

        emit SwapAndLiquify(
            _pancakeV2Router.WETH(),
            half,
            newBalance,
            otherHalf
        );

        _transfer(address(this), tx.origin, _autoSwapCallerFee);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _pancakeV2Router.WETH();

        _approve(address(this), address(_pancakeV2Router), tokenAmount);

        // make the swap
        _pancakeV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount)
        private
    {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(_pancakeV2Router), tokenAmount);

        // add the liquidity
        _pancakeV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(_lpStakingPool),
            block.timestamp
        );
    }

    function swapAndLiquifyForTokens(
        address pairTokenAddress,
        uint256 lockedBalanceForPool
    ) private lockTheSwap {
        // split the contract balance except swapCallerFee into halves
        uint256 lockedForSwapAndJetsPool =
            lockedBalanceForPool.sub(_autoSwapCallerFee);

        // 5% is used for jets staking pool reward
        uint256 lockedForJetsPool = lockedForSwapAndJetsPool.mul(5).div(100);
        _transfer(address(this), _jetsStakingPool, lockedForJetsPool);

        // 95% is used for swapping and adding liquidity
        uint256 lockedForSwap = lockedForSwapAndJetsPool.mul(95).div(100);

        uint256 half = lockedForSwap.div(2);
        uint256 otherHalf = lockedForSwap.sub(half);

        _transfer(address(this), address(swaper), half);

        uint256 initialPairTokenBalance =
            IERC20(pairTokenAddress).balanceOf(address(this));

        // swap tokens for pairToken
        swaper.swapTokens(pairTokenAddress, half);

        uint256 newPairTokenBalance =
            IERC20(pairTokenAddress).balanceOf(address(this)).sub(
                initialPairTokenBalance
            );

        // add liquidity to pancake
        addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);

        emit SwapAndLiquify(
            pairTokenAddress,
            half,
            newPairTokenBalance,
            otherHalf
        );

        _transfer(address(this), tx.origin, _autoSwapCallerFee);
    }

    function addLiquidityForTokens(
        address pairTokenAddress,
        uint256 tokenAmount,
        uint256 pairTokenAmount
    ) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(_pancakeV2Router), tokenAmount);
        IERC20(pairTokenAddress).approve(
            address(_pancakeV2Router),
            pairTokenAmount
        );

        // add the liquidity
        _pancakeV2Router.addLiquidity(
            address(this),
            pairTokenAddress,
            tokenAmount,
            pairTokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(_lpStakingPool),
            block.timestamp
        );
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLock
        ) = _getValues(tAmount);
        uint256 rLock = tLock.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if (inSwapAndLiquify) {
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLock
        ) = _getValues(tAmount);
        uint256 rLock = tLock.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if (inSwapAndLiquify) {
            _tOwned[recipient] = _tOwned[recipient].add(tAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLock
        ) = _getValues(tAmount);
        uint256 rLock = tLock.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if (inSwapAndLiquify) {
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLock
        ) = _getValues(tAmount);
        uint256 rLock = tLock.mul(currentRate);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        if (inSwapAndLiquify) {
            _tOwned[recipient] = _tOwned[recipient].add(tAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rAmount);
            emit Transfer(sender, recipient, tAmount);
        } else {
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
            _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
            _reflectFee(rFee, tFee);
            emit Transfer(sender, address(this), tLock);
            emit Transfer(sender, recipient, tTransferAmount);
        }
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        address msgSender = _msgSender();

        if (_isWhiteListed[msgSender] == true) {
            (uint256 tTransferAmount, uint256 tFee, uint256 tLock) =
                _getTValues(tAmount, 0, 0, _feeDecimals);
            uint256 currentRate = _getRate();
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
                _getRValues(tAmount, 0, 0, currentRate);
            return (
                rAmount,
                rTransferAmount,
                rFee,
                tTransferAmount,
                tFee,
                tLock
            );
        } else {
            (uint256 tTransferAmount, uint256 tFee, uint256 tLock) =
                _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
            uint256 currentRate = _getRate();
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
                _getRValues(tAmount, tFee, tLock, currentRate);
            return (
                rAmount,
                rTransferAmount,
                rFee,
                tTransferAmount,
                tFee,
                tLock
            );
        }
    }

    function _getTValues(
        uint256 tAmount,
        uint256 taxFee,
        uint256 lockFee,
        uint256 feeDecimals
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
        uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
        return (tTransferAmount, tFee, tLockFee);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tLock,
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
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLock = tLock.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() public view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() public view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function getCurrentPoolAddress() public view returns (address) {
        return currentPoolAddress;
    }

    function getCurrentPairTokenAddress() public view returns (address) {
        return currentPairTokenAddress;
    }

    function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
        require(
            feeDecimals >= 0 && feeDecimals <= 2,
            "Gforce: fee decimals should be in 0 - 2"
        );
        _feeDecimals = feeDecimals;
        emit FeeDecimalsUpdated(feeDecimals);
    }

    function _setTaxFee(uint256 taxFee) external onlyOwner() {
        require(
            taxFee >= 0 && taxFee <= 5 * 10**_feeDecimals,
            "Gforce: taxFee should be in 0 - 5"
        );
        _taxFee = taxFee;
        emit TaxFeeUpdated(taxFee);
    }

    function _setLockFee(uint256 lockFee) external onlyOwner() {
        require(
            lockFee >= 0 && lockFee <= 5 * 10**_feeDecimals,
            "Gforce: lockFee should be in 0 - 5"
        );
        _lockFee = lockFee;
        emit LockFeeUpdated(lockFee);
    }

    function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        require(
            maxTxAmount >= 500000e9,
            "Gforce: maxTxAmount should be greater than 500000e9"
        );
        _maxTxAmount = maxTxAmount;
        emit MaxTxAmountUpdated(maxTxAmount);
    }

    function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap)
        external
        onlyOwner()
    {
        require(
            minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9,
            "Gforce: minTokenBeforeSwap should be in 50e9 - 25000e9"
        );
        require(
            minTokensBeforeSwap > _autoSwapCallerFee,
            "Gforce: minTokenBeforeSwap should be greater than autoSwapCallerFee"
        );
        _minTokensBeforeSwap = minTokensBeforeSwap;
        emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
    }

    function _setAutoSwapCallerFee(uint256 autoSwapCallerFee)
        external
        onlyOwner()
    {
        require(
            autoSwapCallerFee >= 1e9,
            "Gforce: autoSwapCallerFee should be greater than 1e9"
        );
        _autoSwapCallerFee = autoSwapCallerFee;
        emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
    }

    function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function _updatePoolAndPairToken(
        address poolAddress,
        address pairTokenAddress
    ) public onlyOwner() {
        require(poolAddress != address(0), "Gforce: Pool address is zero.");
        require(
            pairTokenAddress != address(0),
            "Gforce: Pair token address is zero."
        );
        require(
            pairTokenAddress != address(this),
            "Gforce: Pair token address self address."
        );
        require(
            pairTokenAddress != currentPairTokenAddress,
            "Gforce: Pair token address is same as current one."
        );

        currentPoolAddress = poolAddress;
        currentPairTokenAddress = pairTokenAddress;

        emit PoolAndPairTokenUpdated(poolAddress, pairTokenAddress);
    }

    function _updateStakingPool(address lpStakingPool, address jetsStakingPool)
        public
        onlyOwner()
    {
        require(lpStakingPool != address(0), "Gforce: Pool address is zero.");
        require(
            jetsStakingPool != address(0),
            "Gforce: Pair token address is zero."
        );

        _lpStakingPool = lpStakingPool;
        _jetsStakingPool = jetsStakingPool;

        emit StakingPoolUpdated(lpStakingPool, jetsStakingPool);
    }

    function _enableTrading() external onlyOwner() {
        tradingEnabled = true;
        TradingEnabled();
    }
}