/*

TTTTTTTTTTTTTTTTTTTTTT IIIIIII LLLLLLL   YYYYYYY           YYYYYYY   GGGGGGGGGGGGGG
TT::::::::::::::::::TT I:::::I L:::::L    Y:::::Y         Y:::::Y  GGG::::::::::::G
TTTTTTTT:::::TTTTTTTTT I:::::I L:::::L     Y:::::Y       Y:::::Y GG:::::::::::::::G
       T:::::T         I:::::I L:::::L      Y:::::Y     Y:::::Y G:::::GGGGGGGG::::G
       T:::::T         I:::::I L:::::L       Y:::::Y   Y:::::Y G:::::G       GGGGGG     ooooooooooo
       T:::::T         I:::::I L:::::L         Y:::::::::::Y  G:::::G                oo:::::::::::oo
       T:::::T         I:::::I L:::::L           Y::::::::Y   G:::::G               o:::::::::::::::o        +++++
       T:::::T         I:::::I L:::::L            Y:::::Y     G:::::G    GGGGGGGGGG o:::::ooooo:::::o        +++++
       T:::::T         I:::::I L:::::L            Y:::::Y     G:::::G    G::::::::G o::::o     o::::o        +++++
       T:::::T         I:::::I L:::::L            Y:::::Y     G:::::G    GGGGG::::G o::::o     o::::o   +++++++++++++++
       T:::::T         I:::::I L:::::L            Y:::::Y     G:::::G        G::::G o::::o     o::::o   +++++++++++++++
       T:::::T         I:::::I L:::::L            Y:::::Y      G:::::G       G::::G o::::o     o::::o        +++++
       T:::::T         I:::::I L:::::LLLLLLLL     Y:::::Y       G:::::GGGGGGGG::::G o:::::ooooo:::::o        +++++
       T:::::T         I:::::I L::::::::::::L     Y:::::Y        GG:::::::::::::::G o:::::::::::::::o        +++++
       T:::::T         I:::::I L::::::::::::L     Y:::::Y          GGG::::::GGG:::G  oo:::::::::::oo
       TTTTTTT         IIIIIII LLLLLLLLLLLLLL     YYYYYYY            GGGGGGGGGGGGG     ooooooooooo

*
* https://smart.Instantily.com [TILY smart Exchange+Staking]
*/
//SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.7;

interface IBEP20 {

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

interface AggregatorV3Interface {

  function decimals()
    external
    view
    returns (
      uint8
    );

  function description()
    external
    view
    returns (
      string memory
    );

  function version()
    external
    view
    returns (
      uint256
    );

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(
    uint80 _roundId
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-block.timestamp/[Learn more].
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
     * - the calling contract must have an BNB balance of at least `value`.
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
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
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

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

/**
 * 
 * Price Feed [BNB/USD]
 * 
 */
 
contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Binance Smart Chain
     * Aggregator: BNB/USD
     * Address: 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE // live
     */
    constructor() {
        // priceFeed = AggregatorV3Interface(0x2514895c72f50D8bd4B4F9b1110F0D6bD2c97526); // testnet
        priceFeed = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE); // mainnet
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() internal view returns (int, uint8) {
        (,int price,,,) = priceFeed.latestRoundData();
        (uint8 decimals_) = priceFeed.decimals();
        return (price, decimals_);
    }
}

interface IPancakeFactory {
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

interface IPancakePair {
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

interface IPancakeRouter01 {
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

interface IPancakeRouter02 is IPancakeRouter01 {
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

library Utils {
    using SafeMath for uint256;

    function random(uint256 from, uint256 to, uint256 salty) private view returns (uint256) {
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp + block.difficulty +
                    ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
                    block.gaslimit +
                    ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
                    block.number +
                    salty
                )
            )
        );
        return seed.mod(to - from) + from;
    }

    function isLotteryWon(uint256 salty, uint256 winningDoubleRewardPercentage) private view returns (bool) {
        uint256 luckyNumber = random(0, 100, salty);
        uint256 winPercentage = winningDoubleRewardPercentage;
        return luckyNumber <= winPercentage;
    }

    function calculateBNBReward(
        uint256 currentBalance,
        uint256 currentBNBPool,
        uint256 winningDoubleRewardPercentage,
        uint256 totalSupply) public view returns (uint256) {
        uint256 bnbPool = currentBNBPool;

        // calculate reward to send
        bool isLotteryWonOnClaim = isLotteryWon(currentBalance, winningDoubleRewardPercentage);
        uint256 multiplier = 100;

        if (isLotteryWonOnClaim) {
            multiplier = random(150, 200, currentBalance);
        }

        // block.timestamp calculate reward
        uint256 reward = bnbPool.mul(multiplier).mul(currentBalance).div(100).div(totalSupply);

        return reward;
    }

    function calculateTopUpClaim(
        uint256 currentRecipientBalance,
        uint256 basedRewardCycleBlock,
        uint256 threshHoldTopUpRate,
        uint256 amount
    ) public view returns (uint256) {
        if (currentRecipientBalance == 0) {
            return block.timestamp + basedRewardCycleBlock;
        }
        else {
            uint256 rate = amount.mul(100).div(currentRecipientBalance);

            if (uint256(rate) >= threshHoldTopUpRate) {
                uint256 incurCycleBlock = basedRewardCycleBlock.mul(uint256(rate)).div(100);

                if (incurCycleBlock >= basedRewardCycleBlock) {
                    incurCycleBlock = basedRewardCycleBlock;
                }

                return incurCycleBlock;
            }

            return 0;
        }
    }

    function swapTokensForEth(
        address routerAddress,
        uint256 tokenAmount
    ) public {
        IPancakeRouter02 pancakeRouter = IPancakeRouter02(routerAddress);

        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeRouter.WETH();

        // make the swap
        pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    function swapETHForTokens(
        address routerAddress,
        address recipient,
        uint256 ethAmount
    ) public {
        IPancakeRouter02 pancakeRouter = IPancakeRouter02(routerAddress);

        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = pancakeRouter.WETH();
        path[1] = address(this);

        // make the swap
        pancakeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
            0, // accept any amount of BNB
            path,
            address(recipient),
            block.timestamp + 360
        );
    }

    function addLiquidity(
        address routerAddress,
        address owner,
        uint256 tokenAmount,
        uint256 ethAmount
    ) public {
        IPancakeRouter02 pancakeRouter = IPancakeRouter02(routerAddress);

        // add the liquidity
        pancakeRouter.addLiquidityETH{value : ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner,
            block.timestamp + 360
        );
    }
}

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

    constructor () {
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

    modifier isHuman() {
        require(tx.origin == msg.sender, "sorry humans only");
        _;
    }
}

pragma experimental ABIEncoderV2;

contract InstanTILY is Context, IBEP20, Ownable, PriceConsumerV3, ReentrancyGuard {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => uint256) private _sOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;
    mapping(address => bool) private _isExcludedFromMaxTx;
    
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 475000000 * 10 ** 6 * 10 ** 9;
    uint256 public _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 private _fFeeTotal;
    uint256 private _sRewardTotal; // Staking reward

    string private _name = "InstanTILY";
    string private _symbol = "TILY";
    uint8 private _decimals = 9;
    
    uint256[] private COMM_REWARD;
    
    uint256[] private FARMER_PACKS;
    
    uint256[] private FARMER_POINTS;

    uint256[] private FARMER_RANKS;

    uint256[] private FARMER_REWARDS;

    IPancakeRouter02 public immutable pancakeRouter;
    address public pancakePair;
    
    address public immutable _farmerRewarder;
    address private immutable _devePair;

    bool inSwapAndLiquify = false;

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    
    event FarmingEnabledUpdated(bool enabled);
    
    event CooldownEnabledUpdated(bool enabled);
    
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    event ClaimBNBSuccessfully(
        address recipient,
        uint256 ethReceived,
        uint256 nextAvailableClaimDate
    );

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    modifier onlyFarmer(){
        require(_sOwned[_msgSender()] > 0, 'Error: must stake TILY to claim reward');
        _;
    }
    
    constructor (
        address payable routerAddress, address payable devePair_) {
        _rOwned[_msgSender()] = _rTotal;

        IPancakeRouter02 _pancakeRouter = IPancakeRouter02(routerAddress);
        // Create a pancake pair for this new token
        pancakePair = IPancakeFactory(_pancakeRouter.factory())
        .createPair(address(this), _pancakeRouter.WETH());

        // set the rest of the contract variables
        pancakeRouter = _pancakeRouter;
        _farmerRewarder = _msgSender();
        _devePair = devePair_;
        // RewardProgram
        COMM_REWARD = [500, 300, 250, 200, 150, 100]; // 15%
        
        FARMER_PACKS = [1, 2, 4, 8, 16, 32, 64, 128, 256]; // price * 1e20
        
        FARMER_POINTS = [85, 185, 385, 775, 1580, 3280, 6450, 13200, 27500]; // VOLUME POINTS
        
        FARMER_RANKS = [6, 50, 360, 2000, 17000, 65000]; // POINTS for RankingUP * 1e3
        
        FARMER_REWARDS = [5, 10, 25, 150, 250, 450]; // REWARDS for RankingUP In USD * 1e2
        
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[_msgSender()] = true;
        _isExcludedFromFee[devePair_] = true;
        _isExcludedFromFee[address(this)] = true;

        // exclude from max tx
        _isExcludedFromMaxTx[owner()] = true;
        _isExcludedFromMaxTx[_msgSender()] = true;
        _isExcludedFromMaxTx[devePair_] = true;
        _isExcludedFromMaxTx[address(this)] = true;
        _isExcludedFromMaxTx[address(0x000000000000000000000000000000000000dEaD)] = true;
        _isExcludedFromMaxTx[address(0)] = true;

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

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount, 0);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount, 0);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function totalsFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    // Renounce Tokens owned
    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }
    
    // View Reflection
    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner() {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Pancake router.');
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already excluded");
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

    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _burnToken(tAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    
    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
        _taxFee = taxFee;
    }

    function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
        _liquidityFee = liquidityFee;
    }

    function setFarmFeePercent(uint256 taxFarm) external onlyOwner() {
        _taxFarm = taxFarm;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function setFarmingEnabled(bool _enabled) public onlyOwner {
        farmingEnabled = _enabled;
        emit FarmingEnabledUpdated(_enabled);
    }
    
    function setCooldownEnabled(bool _enabled) public onlyOwner {
        cooldownEnabled = _enabled;
        emit CooldownEnabledUpdated(_enabled);
    }

    //to receive BNB from pancakeRouter when swapping
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }
    
    function _burnToken(uint256 tAmount) private{
        // if(_burnFee > 0){
            uint256 bFee = calculateBurnFee(tAmount);
            uint256 currentRate = _getRate();
            uint256 rbFee = bFee.mul(currentRate);
            // uint256 rLiquidity = tLiquidity.mul(currentRate);
            _rOwned[address(0x000000000000000000000000000000000000dEaD)] = _rOwned[address(0x000000000000000000000000000000000000dEaD)].add(rbFee);
            if (_isExcluded[address(0x000000000000000000000000000000000000dEaD)])
                _tOwned[address(0x000000000000000000000000000000000000dEaD)] = _tOwned[address(0x000000000000000000000000000000000000dEaD)].add(bFee);
        // }
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 _aFee) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, _aFee, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 hFee = calculateHodlFee(tAmount);
        uint256 bFee = calculateBurnFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 _Fee = tFee.add(hFee).add(bFee).add(tLiquidity);
        tLiquidity = tLiquidity.add(tFee);
        uint256 tTransferAmount = tAmount.sub(_Fee);
        return (tTransferAmount, hFee, tLiquidity, _Fee);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 aFee_, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 raFee = aFee_.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(raFee);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if (_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10 ** 2
        );
    }

    function calculateHodlFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_hodlFee).div(
            10 ** 2
        );
    }

    function calculateBurnFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_burnFee).div(
            10 ** 2
        );
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(
            10 ** 2
        );
    }

    function calculateFarmingFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFarm).div(
            10 ** 2
        );
    }

    function _setTaxFeePercent(uint256 _feePercent, uint256 _liqPercent, uint256 _hodlPercent, uint256 _burnPercent) private {
        _taxFee = _feePercent;
        _liquidityFee = _liqPercent;
        _hodlFee = _hodlPercent;
        _burnFee = _burnPercent;
    }

    function removeAllFee() private {
        if (_taxFee == 0 && _liquidityFee == 0) return;
        _taxFee = 0;
        _liquidityFee = 0;
        _hodlFee = 0;
        _burnFee = 0;
    }

    function restoreAllFee() private {
        _taxFee = 2;
        _liquidityFee = 2;
        _hodlFee = 1;
        _burnFee = 0;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount,
        uint256 value
    ) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        ensureMaxTxAmount(from, to, amount, value);
        
        // if ((from == address(pancakePair) && to != address(pancakeRouter)) || (from != pancakePair && to == address(pancakeRouter))) {
        if (_msgSender() == address(pancakeRouter) || _msgSender() == pancakePair) {
            // Buy || Sell
            _setTaxFeePercent(6, 3, 2, 1);
        
            coolDown(from, to, amount);
        }

        // swap and liquify
        swapAndLiquify(from, to);

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }
 
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);
        restoreAllFee();
    }
    
    // CoolDown [To complete]
    function coolDown(address from, address to, uint256 _amount) private{
        if (from != owner() && to != owner()) {
            if (cooldownEnabled) {
                if (from != address(this) && to != address(this) && from != address(pancakeRouter) && to != address(pancakeRouter)) {
                    require(_msgSender() == address(pancakeRouter) || _msgSender() == pancakePair, "ERR: Uniswap only");
                }
            }
            require(!bots[from] && !bots[to]);
            if (from == pancakePair && to != address(pancakeRouter) && !_isExcludedFromFee[to] && cooldownEnabled) {
                // require(tradingOpen);
                require(_amount <= _maxTxAmount, 'Err. MaxTxAmount Exceeded');
                require(buycooldown[to] < block.timestamp, 'Err. Hey, CoolDown');
                buycooldown[to] = block.timestamp + (30 seconds);
            }  
            if (!inSwapAndLiquify && from != pancakePair) {
                require(_amount <= balanceOf(pancakePair).mul(3).div(100) && _amount <= _maxTxAmount, 'ERR: PriceImpact');
                require(sellcooldown[from] < block.timestamp, 'ERR: Antiwhale/Cooldown');
                if(firstsell[from] + (1 days) < block.timestamp){
                    sellnumber[from] = 0;
                }
                if (sellnumber[from] == 0) {
                    sellnumber[from]++;
                    firstsell[from] = block.timestamp;
                    sellcooldown[from] = block.timestamp + (1 minutes);
                }
                else if (sellnumber[from] == 1) {
                    sellnumber[from]++;
                    sellcooldown[from] = block.timestamp + (2 minutes);
                }
                else if (sellnumber[from] == 2) {
                    sellnumber[from]++;
                    sellcooldown[from] = block.timestamp + (6 minutes);
                }
                else if (sellnumber[from] == 3) {
                    sellnumber[from]++;
                    sellcooldown[from] = firstsell[from] + (12 minutes);
                }
                setFee(sellnumber[from]);
            }
        }
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
        if (!takeFee){
            removeAllFee();
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

        // restoreAllFee();
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _burnToken(tAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _burnToken(tAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        _burnToken(tAmount);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    // Innovation for protocol by MoonRat Team
    uint256 public rewardCycleBlock = 7 days; 
    uint256 public easyRewardCycleBlock = 48 hours;
    uint256 public threshHoldTopUpRate = 2; // 2 percent
    uint256 public _maxTxAmount = _tTotal; // should be 0.01% percent per transaction, will be set again at activateContract() function
    uint256 public disruptiveCoverageFee = 2 ether; // antiwhale
    mapping(address => uint256) public nextAvailableClaimDate;
    bool public swapAndLiquifyEnabled = false; // should be true
    uint256 public disruptiveTransferEnabledFrom = 0;
    uint256 public disableEasyRewardFrom = 0;
    uint256 public winningDoubleRewardPercentage = 5;

    uint256 public _taxFee = 2;
    
    uint256 public _hodlFee = 1;
    
    uint256 public _burnFee = 0;

    uint256 public _liquidityFee = 2; // 1% will be added pool, 1% will be converted to BNB
    
    uint256 public _taxFarm = 15; // 15% charged on farming
    
    uint256 public rewardThreshold = 1 ether;

    uint256 minTokenNumberToSell = _tTotal.div(100000); // 0.001% max tx amount will trigger swap and add liquidity
    
    bool public farmingEnabled = false;
    
    bool public cooldownEnabled = false;
    mapping(address => bool) private bots;
    mapping(address => uint256) private buycooldown;
    mapping(address => uint256) private sellcooldown;
    mapping(address => uint256) private firstsell;
    mapping(address => uint256) private sellnumber;
    
    function setFee(uint256 multiplier) private {
        if(multiplier == 0){
            multiplier = 1;
        }
        _taxFee = _taxFee * multiplier;
    }
    
    function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner() {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10000);
    }

    function setExcludeFromMaxTx(address _address, bool value) public onlyOwner {
        _isExcludedFromMaxTx[_address] = value;
    }

    function calculateBNBReward(address ofAddress) public view returns (uint256) {
        uint256 _totalSupply = uint256(_tTotal)
        .sub(balanceOf(address(0)))
        .sub(balanceOf(0x000000000000000000000000000000000000dEaD))
        .sub(balanceOf(address(pancakePair)));

        return Utils.calculateBNBReward(
            seedOf(address(ofAddress)),
            address(this).balance,
            winningDoubleRewardPercentage,
            _totalSupply
        );
    }

    function getRewardCycleBlock() public view returns (uint256) {
        if (block.timestamp >= disableEasyRewardFrom) return rewardCycleBlock;
        return easyRewardCycleBlock;
    }

    function claimBNBReward() isHuman nonReentrant onlyFarmer public {
        require(nextAvailableClaimDate[msg.sender] <= block.timestamp, 'Error: next available not reached');
        require(seedOf(msg.sender) >= 0, 'Error: must be a TILY Farmer to claim reward');

        uint256 reward = calculateBNBReward(msg.sender);

        // reward threshold
        if (reward >= rewardThreshold) {
            Utils.swapETHForTokens(
                address(pancakeRouter),
                address(0x000000000000000000000000000000000000dEaD),
                reward.div(5)
            );
            reward = reward.sub(reward.div(5));
        }

        // update rewardCycleBlock
        nextAvailableClaimDate[msg.sender] = block.timestamp + getRewardCycleBlock();
        emit ClaimBNBSuccessfully(msg.sender, reward, nextAvailableClaimDate[msg.sender]);

        (bool sent,) = address(msg.sender).call{value : reward}("");
        require(sent, 'Error: Cannot withdraw reward');
    }

    function topUpClaimCycleAfterTransfer(address account, uint256 amount) private {
        uint256 currentRecipientBalance = seedOf(account);
        uint256 basedRewardCycleBlock = getRewardCycleBlock();

        nextAvailableClaimDate[account] = nextAvailableClaimDate[account] + Utils.calculateTopUpClaim(
            currentRecipientBalance,
            basedRewardCycleBlock,
            threshHoldTopUpRate,
            amount
        );
    }

    function ensureMaxTxAmount(
        address from,
        address to,
        uint256 amount,
        uint256 value
    ) private view {
        if (
            _isExcludedFromMaxTx[from] == false && // default will be false
            _isExcludedFromMaxTx[to] == false // default will be false
        ) {
            if (value < disruptiveCoverageFee && block.timestamp >= disruptiveTransferEnabledFrom) {
                require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
            }
        }
    }

    function disruptiveTransfer(address recipient, uint256 amount) public payable returns (bool) {
        _transfer(_msgSender(), recipient, amount, msg.value);
        return true;
    }
    
    /*
    * Staking Module starts here 
    */
    struct FarmerStruck {
        uint id;
        uint pvp; // Personal
        uint tvp; // team
        uint rank;
        address sponsor;
        address[] referral;
    }
    
    uint public lastFarmer = 1;
    
    mapping (address => FarmerStruck) public farmers;
    
    // get token Rate on pancakePair
    function toUSD(uint256 _tokenValueBNB) private view returns(uint256){
        (int bnbPrice, uint8 decimals_) = getLatestPrice(); // 1BNB in USD
        uint256 _tokenValueUSD = _tokenValueBNB.mul(uint256(bnbPrice).div(10 ** decimals_));
        return _tokenValueUSD; // USD value without decimals
    }
    
    function tokenReserves() private view returns(uint112, uint112){
        IPancakePair tokenPair = IPancakePair(pancakePair);
        (uint112 reserve0_, uint112 reserve1_,) = tokenPair.getReserves();
        return (reserve0_, reserve1_);
    }
    
    /**
     *  _tokenAmount should be sent with decimal
     * */
    function calculateTokenValue(uint256 _tokenAmount) public view returns(uint256){
        (uint112 bnbReserve, uint112 tokenReserve) = tokenReserves();
        uint256 rese0_ = uint256(bnbReserve).mul(10 ** _decimals);
        require(tokenReserve > 0, 'No Liquidity');
        uint256 tokenValueBNB_ = _tokenAmount.mul(10 ** 18).mul(rese0_).div(uint256(tokenReserve));
        // uint256 tokenValueBNB = tokenValueBNB_.mul(8765).div(10 ** 4);
        // uint256 tokenValueBNB = _tokenAmount.mul(tokenRateBNB_).div(10 ** _decimals).div(1e18); // value in ether (1e18)
        uint256 _tokenValueUSD = toUSD(tokenValueBNB_.div(10 ** 18)); // value with 18 decimals (divide by 1e18) to get USD value
        return (_tokenValueUSD);
    }
    
    // Calculate Volume Points
    function getVPoints(uint256 _amountUSD) private view returns(uint256){
        uint256 F_VPOINTS = 0; 
        if(_amountUSD < FARMER_PACKS[0] * 1e20){
            F_VPOINTS = 0;
        }
        else if(_amountUSD >= FARMER_PACKS[0] * 1e20 && _amountUSD < FARMER_PACKS[1] * 1e20){
            F_VPOINTS = FARMER_POINTS[0];
        }
        else if(_amountUSD >= FARMER_PACKS[1] * 1e20 && _amountUSD < FARMER_PACKS[2] * 1e20){
            F_VPOINTS=  FARMER_POINTS[1];
        }
        else if(_amountUSD >= FARMER_PACKS[2] * 1e20 && _amountUSD < FARMER_PACKS[3] * 1e20){
            F_VPOINTS = FARMER_POINTS[2];
        }
        else if(_amountUSD >= FARMER_PACKS[3] * 1e20 && _amountUSD < FARMER_PACKS[4] * 1e20){
            F_VPOINTS = FARMER_POINTS[3];
        }
        else if(_amountUSD >= FARMER_PACKS[4] * 1e20 && _amountUSD < FARMER_PACKS[5] * 1e20){
            F_VPOINTS = FARMER_POINTS[4];
        }
        else if(_amountUSD >= FARMER_PACKS[5] * 1e20 && _amountUSD < FARMER_PACKS[6] * 1e20){
            F_VPOINTS = FARMER_POINTS[5];
        }
        else if(_amountUSD >= FARMER_PACKS[6] * 1e20 && _amountUSD < FARMER_PACKS[7] * 1e20){
            F_VPOINTS = FARMER_POINTS[6];
        }
        else if(_amountUSD >= FARMER_PACKS[7] * 1e20 && _amountUSD < FARMER_PACKS[8] * 1e20){
            F_VPOINTS = FARMER_POINTS[7];
        }
        else if(_amountUSD >= FARMER_PACKS[8] * 1e20){
            F_VPOINTS = FARMER_POINTS[8];
        }
        return F_VPOINTS;
    }
    
    // Calculate Rewards [convert USD value to Tokens]
    function calculateRankReward(uint256 _amountUSD) private view returns(uint256){
        (uint256 _tokenValueUSD) = calculateTokenValue(1); // Value with 18 decimals
        uint256 _tokenAmount = _amountUSD.mul(1e2).mul(1e18).div(_tokenValueUSD);
        return _tokenAmount.mul(10 ** _decimals);
    }
    
    // Reward Farmer
    function rewardFarmer(address _farmer, uint256 _rank) private {
        (uint256 _tokenReward) = calculateRankReward(FARMER_REWARDS[_rank]);
        _transferStandard(_farmerRewarder, _farmer, _tokenReward);
    }
        
    // Upgrade Member [Give VP bonus rewards]
    function checkFarmersRankUP(address _farmer) private {
        uint256 _rank = farmers[_farmer].rank;
        uint256 _vPoints = farmers[_farmer].tvp;
        if(_vPoints < FARMER_RANKS[0] * 1e3){
            return;
        }
        else if(_vPoints >= FARMER_RANKS[0] * 1e3 && _vPoints < FARMER_RANKS[1] * 1e3 && _rank < 1){
            // Upgrade to Rank1
            farmers[_farmer].rank = 1;
            // Reward Farmer
            rewardFarmer(_farmer, 0);
        }
        else if(_vPoints >= FARMER_RANKS[1] * 1e3 && _vPoints < FARMER_RANKS[2] * 1e3 && _rank < 2){
            // Upgrade to Rank1
            farmers[_farmer].rank = 2;
            // Reward Farmer
            rewardFarmer(_farmer, 1);
        }
        else if(_vPoints >= FARMER_RANKS[2] * 1e3 && _vPoints < FARMER_RANKS[3] * 1e3 && _rank < 3){
            // Upgrade to Rank1
            farmers[_farmer].rank = 3;
            // Reward Farmer
            rewardFarmer(_farmer, 2);
        }
        else if(_vPoints >= FARMER_RANKS[3] * 1e3 && _vPoints < FARMER_RANKS[4] * 1e3 && _rank < 4){
            // Upgrade to Rank1
            farmers[_farmer].rank = 4;
            // Reward Farmer
            rewardFarmer(_farmer, 3);
        }
        else if(_vPoints >= FARMER_RANKS[4] * 1e3 && _vPoints < FARMER_RANKS[5] * 1e3 && _rank < 5){
            // Upgrade to Rank1
            farmers[_farmer].rank = 5;
            // Reward Farmer
            rewardFarmer(_farmer, 4);
        }
        else if(_vPoints >= FARMER_RANKS[5] * 1e3 && _rank < 6){
            // Upgrade to Rank1
            farmers[_farmer].rank = 6;
            // Reward Farmer
            rewardFarmer(_farmer, 5);
        }
    }
    
    // topUpVolumePoints 
    function topUpVolumePoints(address _farmer, uint256 _vPoints) private{
        farmers[_farmer].pvp = farmers[_farmer].pvp.add(_vPoints);
        farmers[_farmer].tvp = farmers[_farmer].tvp.add(_vPoints);
        checkFarmersRankUP(_farmer);
        address sponsor = farmers[_farmer].sponsor;
        for(uint256 ivp = 0; ivp < 6; ivp ++){
            if(sponsor != address(0) && sponsor != address(0x000000000000000000000000000000000000dEaD) && seedOf(sponsor) > 0){
                farmers[sponsor].tvp = farmers[sponsor].tvp.add(_vPoints);
                checkFarmersRankUP(sponsor);
            }
            sponsor = farmers[sponsor].sponsor;
        }
    }    
    
    // Share Rewards [5 Levels deep]
    function shareFarmRewards(address _from, address _ref, uint256 _amount) private{
        address sponsor = _ref;
        uint _reward;
        uint _farmFees = calculateFarmingFee(_amount);
        for(uint i = 0; i < 6; i++){
            _reward = _amount.mul(COMM_REWARD[i]).div(10000);
            if(sponsor != _from && sponsor != address(0) && sponsor != address(0x000000000000000000000000000000000000dEaD) && _reward > 0){
                (uint256 rAmount,,,,,) = _getValues(_reward);
                _rOwned[sponsor] = _rOwned[sponsor].add(rAmount);
                _rTotal = _rTotal.add(rAmount);
            }
            _farmFees = _farmFees.sub(_reward);
            // _reward = 0;
            sponsor = farmers[sponsor].sponsor;
        }
        if(_farmFees > 0){
            (uint256 rAmount,,,,,) = _getValues(_farmFees);
            // Share to Devs.
            _rOwned[_devePair] = _rOwned[_devePair].add(rAmount);
            _rTotal = _rTotal.add(rAmount);
        }
    }
    
    // Register Farmer
    function registerFarmer(address _ref, address _farmer) private{
        farmers[_farmer].id = lastFarmer;
        if(_ref != _farmer && _ref != address(0) && _ref != address(0x000000000000000000000000000000000000dEaD)){
            farmers[_farmer].sponsor = _ref;
        }
        else{
          farmers[_farmer].sponsor = _devePair;  
        }
        lastFarmer++;
    }
    
    // Sow tokens
    function startTokenFarming(address _ref, uint256 _amount) public{
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        require(farmingEnabled, "Farming Closed");
        // Register Farmer
        if(farmers[sender].id == 0){
            registerFarmer(_ref, sender);
        }
        (uint256 rAmount,,,,,) = _getValues(_amount);
        _rTotal = _rTotal.sub(rAmount);
        // start Farming
        uint _farmFees = calculateFarmingFee(rAmount);
        uint _seed = rAmount.sub(_farmFees);
        _sOwned[sender] = _sOwned[sender].add(_seed);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        shareFarmRewards(sender, _ref, _amount);
        // RankFarmer
        (uint256 _tokenValueUSD) = calculateTokenValue(_amount.div(10 ** _decimals));
        uint256 _vPoints = getVPoints(_tokenValueUSD);
        topUpVolumePoints(sender, _vPoints);
        // top up claim cycle
        topUpClaimCycleAfterTransfer(sender, _amount);
    }
    
    // Aboard Farm [cancel staking without fees] 
    function exitFarm() public onlyFarmer returns(bool){
        uint256 rToken = _sOwned[_msgSender()];
        _rOwned[_msgSender()] = _rOwned[_msgSender()].add(rToken);
        _sOwned[_msgSender()] = 0;
        farmers[_msgSender()].rank = 0;
        farmers[_msgSender()].pvp = 0;
        farmers[_msgSender()].tvp = 0;
        _rTotal = _rTotal.add(rToken);
        return true;
    }
    
    function viewFarmerReferral(address _user) public view returns(address[] memory) {
        return farmers[_user].referral;
    }
    
    function seedOf(address account) public view returns (uint256) {
        return tokenFromReflection(_sOwned[account]);
    }
    
    function datMigration(address _farmer, address _invite, uint256 seed_) public onlyOwner{
        require(_farmer != address(this), "Wrong Address");
        require(!_isExcluded[_farmer], "Excluded addresses cannot call this function");
        require(farmers[_farmer].id == 0, "Double Entry Detected");
        registerFarmer(_invite, _farmer);
        uint256 _amount = seed_.mul(10 ** _decimals);
        (uint256 rAmount, uint256 rTransferAmount,,,,) = _getValues(_amount);
        _transferStandard(_farmerRewarder, _farmer, _amount);
        // start Farming
        uint _farmFees = calculateFarmingFee(rAmount);
        uint _seed = rAmount.sub(_farmFees);
        _sOwned[_farmer] = _sOwned[_farmer].add(_seed);
        _rOwned[_farmer] = _rOwned[_farmer].sub(rTransferAmount);
        _rTotal = _rTotal.sub(rAmount);
        // RankFarmer
        (uint256 _tokenValueUSD) = calculateTokenValue(seed_);
        uint256 _vPoints = getVPoints(_tokenValueUSD);
        topUpVolumePoints(_farmer, _vPoints);
    }
    
    /*
    * Staking Module ends here
    */
    function swapAndLiquify(address from, address to) private {
        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is pancake pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        if (contractTokenBalance >= _maxTxAmount) {
            contractTokenBalance = _maxTxAmount;
        }

        bool shouldSell = contractTokenBalance >= minTokenNumberToSell;

        if (
            !inSwapAndLiquify &&
        shouldSell &&
        from != pancakePair &&
        swapAndLiquifyEnabled &&
        !(from == address(this) && to == address(pancakePair)) // swap 1 time
        ) {
            // only sell for minTokenNumberToSell, decouple from _maxTxAmount
            contractTokenBalance = minTokenNumberToSell;

            // add liquidity
            // split the contract balance into 3 pieces
            uint256 pooledBNB = contractTokenBalance.div(2);
            uint256 piece = contractTokenBalance.sub(pooledBNB).div(2);
            uint256 otherPiece = contractTokenBalance.sub(piece);

            uint256 tokenAmountToBeSwapped = pooledBNB.add(piece);

            uint256 initialBalance = address(this).balance;

            // block.timestamp is to lock into staking pool
            Utils.swapTokensForEth(address(pancakeRouter), tokenAmountToBeSwapped);

            // how much BNB did we just swap into?

            // capture the contract's current BNB balance.
            // this is so that we can capture exactly the amount of BNB that the
            // swap creates, and not make the liquidity event include any BNB that
            // has been manually sent to the contract
            uint256 deltaBalance = address(this).balance.sub(initialBalance);

            uint256 bnbToBeAddedToLiquidity = deltaBalance.div(3);

            // add liquidity to pancake
            Utils.addLiquidity(address(pancakeRouter), owner(), otherPiece, bnbToBeAddedToLiquidity);

            emit SwapAndLiquify(piece, deltaBalance, otherPiece);
        }
    }

    function activateContract() public onlyOwner {
        // reward claim
        disableEasyRewardFrom = block.timestamp + 1 weeks;
        rewardCycleBlock = 1 days;
        easyRewardCycleBlock = 6 hours;

        winningDoubleRewardPercentage = 5;

        // protocol
        disruptiveCoverageFee = 2 ether;
        disruptiveTransferEnabledFrom = block.timestamp;
        setMaxTxPercent(1);
        setSwapAndLiquifyEnabled(true);
        setFarmingEnabled(true);
        setCooldownEnabled(true);
        // approve contract
        _approve(address(this), address(pancakeRouter), 2 ** 256 - 1);
    }
}