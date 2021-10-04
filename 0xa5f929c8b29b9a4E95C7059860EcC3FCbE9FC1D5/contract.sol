/**
 *Submitted for verification at BscScan.com on 2021-01-18
*/

pragma solidity ^0.6.12;
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
interface pancakeInterface {
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
}
contract BBXCTokenApp is ERC20("BBXC", "BBXC"), Ownable {
    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
	function burn(address _to, uint256 _amount) public {
      _burn(_to, _amount);
	}
}
contract BinanceBTCApp {  
	using SafeMath for uint256;
	using SafeERC20 for IERC20;	
	address public contractOwner;
	BBXCTokenApp public PlatformTokenApp;
	uint256 constant public TOKENS_PER_ROUND = 1000000;
	uint256 constant public BURN_RATE_SECONDS_DEVIDER = 86400;
	uint256 private timeDevider = 1000000000000;
	uint256 constant public TOKENS_DECIMAL = 18;		
	address payable public platformAddress;
    uint256 public globalNoOfInvestors;
	uint256 public globalInvested;
	uint256 public globalTokensGiven;
	uint256 public globalTokensBurned;
	uint256 public presentLevelNumber;
	uint256 public donated;
	pancakeInterface pancakeRouter;
	///////////new memebers profitability (nmp) variables///
	uint256  private nmpLastWonCheckPoint;
	uint256  private nmpIdDeposit;
	uint256  public NMP_RANDOM_BASE;
	uint256  public NMP_RANDOM_DEVIDER;
	uint256  public NMP_MIN_DEPOSIT;
	uint256 public NMP_MIN_DONATED;	
	uint256 public NMP_DEPOSIT_PERCENT;
	uint256 public NMP_DONATED_PERCENT;	
	///////////new memebers profitability//////////////////
	struct Investor {
        uint256 trxDeposit;
        uint256 depositTime;
        uint256 profitGained;
        uint256 referralBonus;
        uint256 howmuchPaid;
        address upline;
        uint256 invested;
		uint256 reinvested;
		uint256 tokensIssued;
		uint256 tokensBurned;
		uint256 lastWithdrawTime;		
		uint256 basicUser;
    }
    mapping(address => Investor) private investors;
	event EvtNewbie(address indexed investor, uint256 amount,address indexed _referrer);  
	event EvtNewDeposit(address indexed investor, uint256 amount);  
	event EvtWithdrawn(address indexed investor, uint256 amount);  
	event EvtReinvest(address indexed investor, uint256 amount);
	event EvtReferralBonus(address indexed referrer, address indexed investor, uint256 indexed level, uint256 amount);
	event EvtTokensGiven(address indexed investor, uint256 stake_amount, uint256 amount, uint256 presentLevelNumber, uint256 basicUser);
	event EvtTokensSwapBurn(address indexed investor,uint256 trxToBurn, uint256 amount, uint256 npmGift, uint256 winCheckPoint,uint256 nmpLastWonCheckPoint);
	event EvtTokensBurn(address indexed investor,uint256 amount, uint256 basicUser);    
	address[] public path;
	constructor(BBXCTokenApp _BBXCTokenApp, address payable platformAddr, pancakeInterface _pancakeRouter, address[] memory _path) public { 
		contractOwner=msg.sender;
		presentLevelNumber=1;	
		NMP_RANDOM_BASE = 10;
		NMP_RANDOM_DEVIDER = 10;
		NMP_MIN_DEPOSIT = 100;
		NMP_MIN_DONATED=100;		
		NMP_DEPOSIT_PERCENT=25;
		NMP_DONATED_PERCENT=25;
		PlatformTokenApp = _BBXCTokenApp;
		platformAddress = platformAddr;	
		pancakeRouter = pancakeInterface(_pancakeRouter);
		path = _path;
	}

	fallback() external payable {}
	function setLevel() private {
	    uint256 t  = globalTokensGiven.div(10**TOKENS_DECIMAL).div(TOKENS_PER_ROUND);
		presentLevelNumber = t+1;	
	}
	function setContractOwner(address _contractOwner) public {
		require(msg.sender == contractOwner, "!co");
		contractOwner = _contractOwner;
	} 
	function setNmpRandomDevider(uint256 _NMP_RANDOM_BASE, uint256 _NMP_RANDOM_DEVIDER, uint256 _NMP_MIN_DEPOSIT, uint256 _NMP_MIN_DONATED, uint256 _NMP_DEPOSIT_PERCENT, uint256 _NMP_DONATED_PERCENT ) public {
		require(msg.sender == platformAddress, "!pa");
		NMP_RANDOM_BASE = _NMP_RANDOM_BASE;
		NMP_RANDOM_DEVIDER = _NMP_RANDOM_DEVIDER;
		NMP_MIN_DEPOSIT = _NMP_MIN_DEPOSIT;
		NMP_MIN_DONATED=_NMP_MIN_DONATED;
		NMP_DEPOSIT_PERCENT=_NMP_DEPOSIT_PERCENT;
		NMP_DONATED_PERCENT=_NMP_DONATED_PERCENT;
	} 
    function register(address _addr, address _upline) private{
	  Investor storage investor = investors[_addr];      
	  investor.upline = _upline;
    }
	function issueTokens(address _depositor, uint256 _amount) internal {
		Investor storage investor = investors[_depositor];
		uint256 levelDevider = presentLevelNumber.mul(5);
		levelDevider = levelDevider.add(5);
    	uint256 noOfTokensToGive = _amount.mul(1000).div(levelDevider);
		if(investor.basicUser==1) {
			PlatformTokenApp.mint(_depositor, noOfTokensToGive);
			uint256 toBurnForBasicUser = noOfTokensToGive.mul(9).div(10);
			PlatformTokenApp.burn(_depositor, toBurnForBasicUser);
			investor.tokensBurned = investor.tokensBurned.add(toBurnForBasicUser);			
			emit EvtTokensBurn(msg.sender,toBurnForBasicUser,  investor.basicUser);
		} else {
			PlatformTokenApp.mint(_depositor, noOfTokensToGive);
		}
		PlatformTokenApp.mint(platformAddress, noOfTokensToGive.div(10));
		investor.tokensIssued = investor.tokensIssued + noOfTokensToGive;
		globalTokensGiven = globalTokensGiven + noOfTokensToGive;
		setLevel();
		emit EvtTokensGiven(_depositor, _amount, noOfTokensToGive, presentLevelNumber, investor.basicUser);
    }
	function burnTokensAmount(uint256 _amount) public {	
		Investor storage investor = investors[msg.sender];
		require(investor.basicUser==2, "!aa");
		PlatformTokenApp.burn(msg.sender, _amount);
		investor.tokensBurned = investor.tokensBurned.add(_amount);
		emit EvtTokensBurn(msg.sender,_amount,  investor.basicUser);
    }
    function deposit(address _upline, uint256 _basicUser) public payable {
        require(msg.value >= 10**17, "ma");
		Investor storage investor = investors[msg.sender];
		uint256 depositAmount = msg.value;
		globalInvested = globalInvested.add(depositAmount);
		updateProfits(msg.sender);
		if (investor.depositTime == 0) {
            investor.depositTime = now;	
			investor.basicUser = _basicUser;
            globalNoOfInvestors = globalNoOfInvestors.add(1);
			if(_upline != address(0) && investors[_upline].trxDeposit > 0){
				emit EvtNewbie(msg.sender,depositAmount, _upline);
				register(msg.sender, _upline);
            }
            else{
				emit EvtNewbie(msg.sender,depositAmount,contractOwner);
				register(msg.sender, contractOwner);
            }
			//////////////NPM code/////////////////////
			if(donated > NMP_MIN_DONATED && depositAmount > NMP_MIN_DEPOSIT && nmpIdDeposit < depositAmount) {
				nmpIdDeposit=depositAmount;				
				uint256 minuteRandomizer = block.timestamp.mod(NMP_RANDOM_DEVIDER).add(NMP_RANDOM_BASE);			
				uint256	winCheckPoint = block.timestamp.sub(minuteRandomizer.mul(60));
				if(winCheckPoint >  nmpLastWonCheckPoint) {
					//transfer gift to new depositor and swap the rest with token and burn
					uint256 npmGift = 0;
					npmGift = depositAmount.mul(NMP_DEPOSIT_PERCENT).div(100);
					if (npmGift > donated.mul(NMP_DONATED_PERCENT).div(100)) {
						npmGift = donated.mul(NMP_DONATED_PERCENT).div(100);
					}
					donated = donated.sub(npmGift);
					msg.sender.transfer(npmGift);
					tokenBurn(npmGift, winCheckPoint, nmpLastWonCheckPoint);
					nmpLastWonCheckPoint=block.timestamp;					
					nmpIdDeposit=0;	
				}			
			}			
			//////////////NPM code/////////////////////
        }
		issueTokens(msg.sender, depositAmount);
		investor.lastWithdrawTime = now;
		investor.trxDeposit = investor.trxDeposit.add(depositAmount);
		investor.invested += depositAmount;
		payUplines(msg.value, investor.upline);  
		emit EvtNewDeposit(msg.sender, depositAmount);
		platformAddress.transfer(depositAmount.div(10));
    }
	function tokenBurn(uint256 _npmGift, uint256 _winCheckPoint, uint256 _nmpLastWonCheckPoint) private  {
		uint256 tokenToBurn;
		tokenToBurn = pancakeRouter.swapExactETHForTokens{value: donated}(1,path,address(this),now + 100000000)[1];
		globalTokensBurned = globalTokensBurned + tokenToBurn;
		PlatformTokenApp.burn(address(this), tokenToBurn); 
		emit EvtTokensSwapBurn(msg.sender,donated, tokenToBurn, _npmGift, _winCheckPoint, _nmpLastWonCheckPoint);
		donated = 0;
	}
	function withdraw(uint256 wPercent) public {
		require(wPercent>=1 && wPercent <=100, "pr");
        updateProfits(msg.sender);
        require(investors[msg.sender].profitGained > 0);
		uint256 transferAmount;
		transferAmount = investors[msg.sender].profitGained.mul(wPercent).div(100);
        transferProfitGained(msg.sender, transferAmount);
    }
    function reinvest() public {
	  updateProfits(msg.sender);
	  Investor storage investor = investors[msg.sender];
	  uint256 depositAmount = investor.profitGained;
      require(address(this).balance >= depositAmount);
	  investor.profitGained = 0;
	  investor.trxDeposit = investor.trxDeposit.add(depositAmount/2);
	  investor.reinvested += depositAmount;
	  emit EvtReinvest(msg.sender, depositAmount);
	  payUplines(depositAmount, investor.upline);
      platformAddress.transfer(depositAmount.div(10));
	  issueTokens(msg.sender, depositAmount.div(2).div(10)); 
	  investor.lastWithdrawTime = now;
    }
    function updateProfits(address _addr) internal {
		Investor storage investor = investors[_addr];
		uint256 grm = getRateMultiplier();
        uint256 secPassed = now.sub(investor.depositTime);
		if (secPassed > 0 && investor.depositTime > 0) {
            uint256 calculateProfit = (investor.trxDeposit.mul(secPassed.mul(grm))).div(timeDevider);
            investor.profitGained = investor.profitGained.add(calculateProfit);
            if (investor.profitGained >= investor.trxDeposit.mul(3)){
                investor.profitGained = investor.trxDeposit.mul(3);
            }
            investor.depositTime = investor.depositTime.add(secPassed);
        }
    }
	function transferProfitGained(address _receiver, uint256 _amount) internal {
		if (_amount > 0 && _receiver != address(0)) {
		  uint256 contractBalance = address(this).balance;
			if (contractBalance > 0) {
                uint256 payout = _amount > contractBalance ? contractBalance : _amount;
				Investor storage investor = investors[_receiver];
				if(investor.basicUser==2){
					uint256 systemBurnRate = calculateSystemBurnRate(_receiver);
					uint256 myBurnRate = calculateMyBurnRate(_receiver);
					require(myBurnRate >= systemBurnRate, "!br"); 
				}
				investor.howmuchPaid = investor.howmuchPaid.add(payout);
                investor.profitGained = investor.profitGained.sub(payout);
				investor.trxDeposit = investor.trxDeposit.sub(payout/2);
                investor.trxDeposit = investor.trxDeposit.add(payout.div(4));       
				msg.sender.transfer(payout.mul(3).div(4)); // 75% to user   
				investor.lastWithdrawTime = now;
				donated += payout.div(4); // 25% percent
				emit EvtWithdrawn(msg.sender, payout);
            }
        }
    }
	function calculateSystemBurnRate(address _addr) public view returns (uint256) {
		Investor storage investor = investors[_addr];
		uint256 daysPassed = 0;
		uint256 csbr = 90;
		if(investor.lastWithdrawTime>0) {
			daysPassed = now.sub(investor.lastWithdrawTime).div(BURN_RATE_SECONDS_DEVIDER);
			if (daysPassed > 89) {
				csbr = 0;
			} else {
				csbr = csbr.sub(daysPassed);
			}			
		}
		return csbr;
	}
	function calculateMyBurnRate(address _addr) public view returns (uint256) {
		Investor storage investor = investors[_addr];
		uint256 cmbr = 0;
		if(investor.tokensIssued>0) {
			cmbr = cmbr.add(investor.tokensBurned.mul(100).div(investor.tokensIssued));
		}
		return cmbr;
	}
	function getProfit(address _addr) public view returns (uint256) {
		Investor storage investor = investors[_addr];
		if(investor.depositTime > 0){
			uint256 secPassed = now.sub(investor.depositTime);
			uint256 grm = getRateMultiplier();
			uint256 calculateProfit;
			if (secPassed > 0) {
				calculateProfit = (investor.trxDeposit.mul(secPassed.mul(grm))).div(timeDevider);
			}
			if (calculateProfit.add(investor.profitGained) >= investor.trxDeposit.mul(3)){
				return investor.trxDeposit.mul(3);
			}
			else{
				return calculateProfit.add(investor.profitGained);
			}
		} else {
			return 0;
		}
	}
	function getRateMultiplier() public view returns (uint256) { 
		Investor storage investor = investors[msg.sender];
		uint256 grm = 116000*2 ; // 2% usual secnario		
		if(investor.depositTime > 0){
			if(investor.howmuchPaid.add(investor.profitGained) > investor.trxDeposit){
				grm = 116000 ; //1% after 100% capital achieved scenario
			}
			uint256 secPassed =0;
			if(investor.depositTime > 0){
				secPassed = now.sub(investor.depositTime);
			}
			if ((investor.trxDeposit.mul(secPassed.mul(grm))).div(timeDevider) > investor.trxDeposit ) {
				grm = 116000 ; //1%  very rare scenario where no withdrawals happened for more than 50 days. then convert it to 1%
			}		
		}
		return grm;
	}
	function getterGlobal() public view returns(uint256,   uint256, uint256, uint256) {
		return ( address(this).balance,   globalNoOfInvestors, getRateMultiplier(), globalInvested );
	}
	function getterGlobal1() public view returns( uint256, uint256, uint256, uint256) {
		return ( presentLevelNumber,globalTokensGiven,globalTokensBurned, donated );
	}
	function getterInvestor1(address _addr) public view returns(uint256, uint256, uint256, uint256, uint256) {
		uint256 totalWithdrawAvailable = 0;
		if(investors[_addr].depositTime > 0) {
			totalWithdrawAvailable = getProfit(_addr);
		}
		return ( totalWithdrawAvailable, investors[_addr].trxDeposit, investors[_addr].depositTime, investors[_addr].profitGained,  investors[_addr].howmuchPaid);
	}
	function getterInvestor3(address _addr) public view returns(uint256,  uint256,  uint256, uint256, address, uint256) {
		return ( investors[_addr].invested, investors[_addr].reinvested, investors[_addr].tokensIssued, investors[_addr].tokensBurned, investors[_addr].upline, investors[_addr].referralBonus);
	}
	function getterInvestor31(address _addr) public view returns(uint256, uint256) {
		return ( calculateSystemBurnRate(_addr), calculateMyBurnRate(_addr));
	}
	function getterInvestor4(address _addr) public view returns(uint256, uint256, uint256) {
		return ( investors[_addr].lastWithdrawTime, investors[_addr].depositTime, investors[_addr].basicUser);
	}
	function payUplines(uint256 _amount, address _upline) private{
        uint256 _allbonus = (_amount.mul(10)).div(100);
        address _upline1 = _upline;
        address _upline2 = investors[_upline1].upline;
        address _upline3 = investors[_upline2].upline;
        address _upline4 = investors[_upline3].upline;
        uint256 _referralBonus = 0;
        if (_upline1 != address(0)) {
            _referralBonus = (_amount.mul(5)).div(100);
            _allbonus = _allbonus.sub(_referralBonus);
           updateProfits(_upline1);
            investors[_upline1].referralBonus = _referralBonus.add(investors[_upline1].referralBonus);
            investors[_upline1].trxDeposit = _referralBonus.add(investors[_upline1].trxDeposit);
			emit EvtReferralBonus(_upline1, msg.sender, 1, _referralBonus);
        }
        if (_upline2 != address(0)) {
            _referralBonus = (_amount.mul(3)).div(100);
            _allbonus = _allbonus.sub(_referralBonus);
            updateProfits(_upline2);
            investors[_upline2].referralBonus = _referralBonus.add(investors[_upline2].referralBonus);
            investors[_upline2].trxDeposit = _referralBonus.add(investors[_upline2].trxDeposit);
			emit EvtReferralBonus(_upline2, msg.sender, 2, _referralBonus);
        }
        if (_upline3 != address(0)) {
            _referralBonus = (_amount.mul(1)).div(100);
            _allbonus = _allbonus.sub(_referralBonus);
            updateProfits(_upline3);
            investors[_upline3].referralBonus = _referralBonus.add(investors[_upline3].referralBonus);
            investors[_upline3].trxDeposit = _referralBonus.add(investors[_upline3].trxDeposit);
			emit EvtReferralBonus(_upline3, msg.sender, 3, _referralBonus);
        }
        if (_upline4 != address(0)) {
            _referralBonus = (_amount.mul(1)).div(100);
            _allbonus = _allbonus.sub(_referralBonus);
            updateProfits(_upline4);
            investors[_upline4].referralBonus = _referralBonus.add(investors[_upline4].referralBonus);
            investors[_upline4].trxDeposit = _referralBonus.add(investors[_upline4].trxDeposit);
			emit EvtReferralBonus(_upline4, msg.sender, 4, _referralBonus);
        }
        if(_allbonus > 0 ){
            _referralBonus = _allbonus;
            updateProfits(contractOwner);
            investors[contractOwner].referralBonus = _referralBonus.add(investors[contractOwner].referralBonus);
            investors[contractOwner].trxDeposit = _referralBonus.add(investors[contractOwner].trxDeposit);
        }
    }
}