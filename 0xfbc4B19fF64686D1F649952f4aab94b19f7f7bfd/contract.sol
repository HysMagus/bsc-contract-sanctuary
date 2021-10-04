// File: contracts\interfaces\ISaffronBase.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.1;

interface ISaffronBase {
  enum Tranche {S, AA, A}
  enum LPTokenType {dsec, principal}

  // Store values (balances, dsec, vdsec) with TrancheUint256
  struct TrancheUint256 {
    uint256 S;
    uint256 AA;
    uint256 A;
  }

  struct epoch_params {
    uint256 start_date;       // Time when the platform launched
    uint256 duration;         // Duration of epoch
  }
}

// File: contracts\interfaces\ISaffronPool.sol

pragma solidity ^0.7.1;

interface ISaffronPool is ISaffronBase {
  function add_liquidity(uint256 amount, Tranche tranche) external;
  function add_liquidity_eth(Tranche tranche) payable external;
  function remove_liquidity(uint256 amount, Tranche tranche) external;
  function remove_liquidity_eth(uint256 amount, Tranche tranche) external;
  function set_governance(address to) external;
  function set_concierge(address to) external;
}

// File: contracts\interfaces\ISaffronAdapter.sol

pragma solidity ^0.7.1;

interface ISaffronAdapter is ISaffronBase {
    function set_pool(address pool) external;
    function deploy_capital(uint256 amount) external;
    function deploy_capital_eth() payable external;
    function return_capital(uint256 base_asset_amount, address to) external;
    function return_capital_eth(uint256 eth_amount, address to) external;
    function get_underlying_exchange_rate() external returns(uint256);
    function set_base_asset(address addr) external;
    function get_holdings() external returns(uint256);
    function get_interest(uint256 principal) external returns(uint256);
    function set_governance(address to) external;
}

// File: contracts\lib\SafeMath.sol

pragma solidity ^0.7.1;

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

// File: contracts\lib\IERC20.sol

pragma solidity ^0.7.1;

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

// File: contracts\lib\Context.sol

pragma solidity ^0.7.1;

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

// File: contracts\lib\Address.sol

pragma solidity ^0.7.1;

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
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
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

// File: contracts\lib\ERC20.sol

pragma solidity ^0.7.1;





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
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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

// File: contracts\lib\SafeERC20.sol

pragma solidity ^0.7.1;




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

// File: contracts\SaffronLPBalanceTokenV2.sol

pragma solidity ^0.7.1;


contract SaffronLPBalanceTokenV2 is ERC20 {
  address public pool_address;

  constructor (string memory name, string memory symbol) ERC20(name, symbol) {
    // Set pool_address to saffron pool that created token
    pool_address = msg.sender;
  }

  // Allow creating new tranche tokens
  function mint(address to, uint256 amount) public {
    require(msg.sender == pool_address, "must be pool");
    _mint(to, amount);
  }

  function burn(address account, uint256 amount) public {
    require(msg.sender == pool_address, "must be pool");
    _burn(account, amount);
  }

}

// File: contracts\SaffronPoolV2.sol

pragma solidity ^0.7.1;








contract SaffronPoolV2 is ISaffronPool {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  address public base_asset_address;   // Base asset managed by the pool (DAI, USDT, YFI...)
  address public SFI_address;          // SFI ERC20 token
  uint256 public SFI_ratio;            // Ratio of base asset to SFI necessary to join tranche A

  /**** ADAPTER ****/
  ISaffronAdapter public adapter;      // Current best adapter selected by strategy
  uint256 public dist_adapter_val;     // Distributed adapter balance used for calculating interest

  /**** STRATEGY ****/
  address public strategy;

  /**** GOVERNANCE ****/
  address public governance;           // Governance (v3: add off-chain/on-chain governance)
  address public _new_governance;
  address public concierge;
  address public _new_concierge;
  bool public _pause_deposit;
  bool public _pause_removal;
  bool public _freeze_exchange_rate;
  mapping(address => bool) public whitelist;
  uint256 public capital_restriction;

  /**** TRANCHE-INDEXED STORAGE ****/
  uint256[3] public tranche_exchange_rate;          // Tranche exchange rate for SAFF-*/*+T to underlying base asset
  mapping(address => uint256) public A_balance;     // Tranche A LP balance
  mapping(address => uint256) public A_SFI_balance;   // Tranche A SFI balances
  uint256 public A_total_supply;                    // Total outstanding A LP
  uint256 public A_total_sfi;                       // Total SFI held by A
  uint256 public A_weight;                          // Weighting applied to A tranche

  // LP tokens
  SaffronLPBalanceTokenV2 public LP_S;
  SaffronLPBalanceTokenV2 public LP_AA;

  address public immutable LP_S_address;
  address public immutable LP_AA_address;

  event InitExchangeRate(uint256 underlyingRate, uint256 sRate, uint256 aaRate, uint256 aRate);
  constructor(address _base_asset, address _SFI_address, uint256 _SFI_ratio, address _adapter_address) {
    require(_base_asset != address(0x0) && _SFI_address != address(0x0) && _adapter_address != address(0x0), "can't construct with 0x0 address");
    governance = msg.sender;
    concierge = msg.sender;
    whitelist[msg.sender] = true;
    base_asset_address = _base_asset;
    adapter = ISaffronAdapter(_adapter_address);
    SFI_address = _SFI_address;
    SFI_ratio = _SFI_ratio;
    A_weight = 10;
    capital_restriction = 250 ether;

    // initialize exchange rate
    uint256 compRate = adapter.get_underlying_exchange_rate();
    tranche_exchange_rate[uint256(Tranche.S)] = compRate;
    tranche_exchange_rate[uint256(Tranche.AA)] = compRate;
    tranche_exchange_rate[uint256(Tranche.A)] = compRate;
    emit InitExchangeRate(compRate, tranche_exchange_rate[uint256(Tranche.S)], tranche_exchange_rate[uint256(Tranche.AA)], tranche_exchange_rate[uint256(Tranche.A)]);

    LP_S = new SaffronLPBalanceTokenV2("Saffron BUSD/Venus S tranche LP token", "SAFF-BUSD/Venus-S");
    LP_AA = new SaffronLPBalanceTokenV2("Saffron BUSD/Venus AA tranche LP token", "SAFF-BUSD/Venus-AA");

    LP_S_address = address(LP_S);
    LP_AA_address = address(LP_AA);
  }

  function add_liquidity_eth(Tranche tranche) payable external override {
    uint256 amount = msg.value;
    require(amount != 0, "can't add 0");
    require(whitelist[msg.sender], "must be whitelisted");
    require(!_pause_deposit, "deposit paused");

    uint256 user_holdings = _get_base_balance(tranche, msg.sender) + amount;
    require(user_holdings <= capital_restriction, "deposit would exceed limit");

    // Transfer SFI to pool
    if (tranche == Tranche.A) IERC20(SFI_address).safeTransferFrom(msg.sender, address(this), amount / SFI_ratio);

    // Measure LP token amounts based on exchange rate
    uint256 adapter_exchange_rate = adapter.get_underlying_exchange_rate();
    uint256 hardhat_exchange_rate_pre = tranche_exchange_rate[uint256(tranche)];
    update_exchange_rate();

    // Transfer ETH to adapter and deploy
    emit AddLiquidity(dist_adapter_val, amount, 0);
    adapter.deploy_capital_eth{value:msg.value}(); // Send funds to ibETH contract
    // 1e10 * 1e18
    uint256 lp_amount = amount * 1e28 / tranche_exchange_rate[uint256(tranche)];
    dist_adapter_val = adapter.get_holdings();
    emit AddLiquidity(dist_adapter_val, amount, lp_amount);

    if (tranche == Tranche.S) LP_S.mint(msg.sender, lp_amount);
    else if (tranche == Tranche.AA) LP_AA.mint(msg.sender, lp_amount);
    else if (tranche == Tranche.A) {
      uint256 sfi_amount = amount / SFI_ratio;
      A_balance[msg.sender] = A_balance[msg.sender].add(lp_amount);
      A_SFI_balance[msg.sender] = A_SFI_balance[msg.sender].add(sfi_amount);
      A_total_supply = A_total_supply.add(lp_amount);
      A_total_sfi = A_total_sfi.add(sfi_amount);
    }
  }

  // LP user adds liquidity to the pool
  event AddLiquidity(uint256 dist_adapter_val, uint256 base_assets, uint256 lp_amount_minted);

  function add_liquidity(uint256 amount, Tranche tranche) external override {
    require(amount != 0, "can't add 0");
    require(whitelist[msg.sender], "must be whitelisted");
    require(!_pause_deposit, "deposits paused");

    uint256 user_holdings = _get_base_balance(tranche, msg.sender) + amount;
    require(user_holdings <= capital_restriction, "deposit would exceed limit");

    // Transfer base_asset to adapter and SFI to pool
    IERC20(base_asset_address).safeTransferFrom(msg.sender, address(adapter), amount);
    if (tranche == Tranche.A) IERC20(SFI_address).safeTransferFrom(msg.sender, address(this), amount / SFI_ratio);

    // Supply base_asset to platform; give user LP tokens
    uint256 adapter_exchange_rate = adapter.get_underlying_exchange_rate();
    uint256 hardhat_exchange_rate_pre = tranche_exchange_rate[uint256(tranche)];
    update_exchange_rate();

    // 1e10 * 1e18
    uint256 lp_amount = amount * 1e28 / tranche_exchange_rate[uint256(tranche)];
    emit AddLiquidity(dist_adapter_val, amount, lp_amount);
    adapter.deploy_capital(amount);
    dist_adapter_val = adapter.get_holdings();
    emit AddLiquidity(dist_adapter_val, amount, lp_amount);

    if (tranche == Tranche.S) LP_S.mint(msg.sender, lp_amount);
    else if (tranche == Tranche.AA) LP_AA.mint(msg.sender, lp_amount);
    else if (tranche == Tranche.A) {
      uint256 sfi_amount = amount / SFI_ratio;
      A_balance[msg.sender] = A_balance[msg.sender].add(lp_amount);
      A_SFI_balance[msg.sender] = A_SFI_balance[msg.sender].add(sfi_amount);
      A_total_supply = A_total_supply.add(lp_amount);
      A_total_sfi = A_total_sfi.add(sfi_amount);
    }
  }

  function exchange_rate(Tranche tranche) public returns (uint256) {
    update_exchange_rate();
    return tranche_exchange_rate[uint256(tranche)];
  }

  struct UpdateExchangeRateVars {
    uint256 adapter_val;
    uint256 S_supply;
    uint256 AA_supply;
    uint256 A_supply;
    uint256 interest;
    uint256 S_frac;
    uint256 A_frac;
    uint256 S_int;
    uint256 AA_int;
    uint256 A_int;
    uint256 S_inc;
    uint256 AA_inc;
    uint256 A_inc;
    uint256 pool_holdings;
    uint256 S_holdings;
    uint256 AA_holdings;
    uint256 A_holdings;
  }

  event UpdateExchangeRate(uint256 dist_adapter_val, uint256 S_inc, uint256 S_supply, uint256 AA_inc, uint256 AA_supply, uint256 A_inc, uint256 A_supply);
  event NewExchangeRate(uint256 S, uint256 AA, uint256 A);
  event FrozenExchangeRate();

  function update_exchange_rate() public {
    if (_freeze_exchange_rate == true) {
      emit FrozenExchangeRate();
      return;
    }

    UpdateExchangeRateVars memory uv = UpdateExchangeRateVars({interest : 0, adapter_val : 0, A_inc : 0, AA_inc : 0, S_inc : 0, A_int : 0, AA_int : 0, S_int : 0, A_frac : 0, S_frac : 0, AA_supply : 0, A_supply : 0, S_supply : 0, pool_holdings : 0, S_holdings : 0, AA_holdings : 0, A_holdings : 0});
    uv.adapter_val = adapter.get_holdings();
    require(uv.adapter_val >= dist_adapter_val, "adapter balance inconsistent");

    // No interest: exchange rate remains same, return
    if (uv.adapter_val == dist_adapter_val) return;

    uv.S_supply = LP_S.totalSupply();
    uv.AA_supply = LP_AA.totalSupply();
    uv.A_supply = A_total_supply;


    uv.S_holdings = uv.S_supply * tranche_exchange_rate[uint256(Tranche.S)] / 1e28;
    uv.AA_holdings = uv.AA_supply * tranche_exchange_rate[uint256(Tranche.AA)] / 1e28;
    uv.A_holdings = uv.A_supply * tranche_exchange_rate[uint256(Tranche.A)] / 1e28;
    uv.pool_holdings = uv.S_holdings + uv.AA_holdings + uv.A_holdings;

    // No supply: can't update exchange rate, return
    if (uv.pool_holdings == 0) return;


    // Step 1. Calculate interest earned since last dist_adapter_val update
    uv.interest = (uv.adapter_val - dist_adapter_val) * 1e10;
    uint256 hardhat_dist_adapter_val = dist_adapter_val;
    dist_adapter_val = adapter.get_holdings();

    // Step 2. Find fractional value of S
    // TODO: add fees; add S tranche interest / SFI contribution; remove LP tokens and replace with mappings, add token export
    uv.S_frac = uv.S_holdings * 1 ether / uv.pool_holdings;

    // Step 3. Find A fractional value, AA is the remainder
    uv.A_frac = uv.A_holdings * 10 < uv.AA_holdings ? uv.A_holdings * 10 * 1 ether / (uv.AA_holdings + uv.A_holdings) : uint256(10) * uint256(1 ether) / uint256(11);

    // Step 4. Calculate interest owned by each tranche using fractional values
    uv.S_int = (uv.interest * uv.S_frac) / 1 ether;
    uv.A_int = (uv.interest - uv.S_int) * uv.A_frac / 1 ether;
    uv.AA_int = (uv.interest - uv.S_int - uv.A_int);

    // Step 5. Increment exchange rate according to interest
    uv.S_inc = uv.S_supply == 0 ? 0 : uv.S_int * 1 ether / uv.S_supply;
    uv.AA_inc = uv.AA_supply == 0 ? 0 : uv.AA_int * 1 ether / uv.AA_supply;
    uv.A_inc = uv.A_supply == 0 ? 0 : uv.A_int * 1 ether / uv.A_supply;

    // Step 6. Update dist_adapter_val based on interest earned
    emit UpdateExchangeRate(dist_adapter_val, uv.S_inc, uv.S_supply, uv.AA_inc, uv.AA_supply, uv.A_inc, uv.A_supply);
    if ((uv.S_inc != 0 || uv.S_supply == 0) && (uv.AA_inc != 0 || uv.AA_supply == 0) && (uv.A_inc != 0 || uv.A_supply == 0)) {
      // Possible gas savings: check if we will sstore 0 or the same value before setting
      tranche_exchange_rate[uint256(Tranche.S)] = tranche_exchange_rate[uint256(Tranche.S)] + uv.S_inc;
      tranche_exchange_rate[uint256(Tranche.AA)] = tranche_exchange_rate[uint256(Tranche.AA)] + uv.AA_inc;
      tranche_exchange_rate[uint256(Tranche.A)] = tranche_exchange_rate[uint256(Tranche.A)] + uv.A_inc;
      emit UpdateExchangeRate(dist_adapter_val, uv.S_inc, uv.S_supply, uv.AA_inc, uv.AA_supply, uv.A_inc, uv.A_supply);
      emit NewExchangeRate(tranche_exchange_rate[uint256(Tranche.S)], tranche_exchange_rate[uint256(Tranche.AA)], tranche_exchange_rate[uint256(Tranche.A)]);
    }
  }

  event RemoveLiquidity(uint256 dist_adapter_Val, uint256 amount_base, uint256 exchange_rate);

  function remove_liquidity(uint256 amount, Tranche tranche) external override {
    require(amount > 0, "can't remove 0");
    require(!_pause_removal, "removal paused");
    uint256 er = exchange_rate(tranche);
    // 1e10 / 1 ether
    uint256 amount_base = amount * er / 1e28;

    if (tranche == Tranche.S) {
      require(LP_S.balanceOf(msg.sender) >= amount, "insufficient S balance");
      LP_S.burn(msg.sender, amount);
      adapter.return_capital(amount_base, msg.sender);
    }
    else if (tranche == Tranche.A) {
      uint256 aBal = A_balance[msg.sender];
      uint256 sBal = A_SFI_balance[msg.sender];
      require(aBal >= amount, "insufficient A balance");

      uint256 fracRemove = amount * 1 ether / aBal;
      uint256 SFI_return = sBal * fracRemove / 1 ether;

      A_balance[msg.sender] = A_balance[msg.sender].sub(amount);
      A_SFI_balance[msg.sender] = A_SFI_balance[msg.sender].sub(SFI_return);

      adapter.return_capital(amount_base, msg.sender);
      IERC20(SFI_address).safeTransfer(msg.sender, SFI_return);
    }
    else if (tranche == Tranche.AA) {
      require(LP_AA.balanceOf(msg.sender) >= amount, "insufficient AA balance");
      LP_AA.burn(msg.sender, amount);
      adapter.return_capital(amount_base, msg.sender);
    }
    dist_adapter_val = adapter.get_holdings();
  }

  function remove_liquidity_eth(uint256 amount, Tranche tranche) external override {
    require(amount > 0, "can't remove 0");
    require(!_pause_removal, "removal paused");
    uint256 er = exchange_rate(tranche);
    // 1e10 / 1 ether
    uint256 amount_base = amount * er / 1e28;

    if (tranche == Tranche.S) {
      require(LP_S.balanceOf(msg.sender) >= amount, "insufficient S balance");
      LP_S.burn(msg.sender, amount);
      adapter.return_capital_eth(amount_base, msg.sender);
    }
    else if (tranche == Tranche.A) {
      uint256 aBal = A_balance[msg.sender];
      uint256 sBal = A_SFI_balance[msg.sender];
      require(aBal >= amount, "insufficient A balance");

      uint256 fracRemove = amount * 1 ether / aBal;
      uint256 SFI_return = sBal * fracRemove / 1 ether;

      A_balance[msg.sender] = A_balance[msg.sender].sub(amount);
      A_SFI_balance[msg.sender] = A_SFI_balance[msg.sender].sub(SFI_return);

      adapter.return_capital_eth(amount_base, msg.sender);
      IERC20(SFI_address).safeTransfer(msg.sender, SFI_return);
    }
    else if (tranche == Tranche.AA) {
      require(LP_AA.balanceOf(msg.sender) >= amount, "insufficient AA balance");
      LP_AA.burn(msg.sender, amount);
      adapter.return_capital_eth(amount_base, msg.sender);
    }
    dist_adapter_val = adapter.get_holdings();
  }

  event DepositPause(bool pause);

  function pause_deposit(bool pause) public {
    require(msg.sender == governance, "must be governance");
    _pause_deposit = pause;
    emit DepositPause(pause);
  }

  event RemovalPause(bool pause);

  function pause_removal(bool pause) public {
    require(msg.sender == governance, "must be governance");
    _pause_removal = pause;
    emit RemovalPause(pause);
  }

  event FreezeExchangeRate(bool freeze);

  function freeze_exchange_rate(bool freeze) public {
    require(msg.sender == governance, "must be governance");
    _freeze_exchange_rate = freeze;
    pause_deposit(true);
    pause_removal(true);
    emit FreezeExchangeRate(freeze);
  }

  function set_exchange_rate(uint256 S, uint256 AA, uint256 A) public {
    require(msg.sender == governance, "must be governance");
    freeze_exchange_rate(true);
    tranche_exchange_rate[uint256(Tranche.S)] = S;
    tranche_exchange_rate[uint256(Tranche.AA)] = AA;
    tranche_exchange_rate[uint256(Tranche.A)] = A;
    emit NewExchangeRate(S, AA, A);
  }

  /*** GOVERNANCE ***/
  event SetGovernance(address prev, address next);
  event AcceptGovernance(address who);

  function set_governance(address to) external override {
    require(msg.sender == governance, "must be governance");
    _new_governance = to;
    emit SetGovernance(msg.sender, to);
  }

  function accept_governance() external {
    require(msg.sender == _new_governance, "must be new governance");
    governance = msg.sender;
    emit AcceptGovernance(msg.sender);
  }

  event SetConcierge(address prev, address next);
  event AcceptConcierge(address who);

  function set_concierge(address to) external override {
    require(msg.sender == concierge, "must be concierge");
    _new_concierge = to;
    emit SetConcierge(msg.sender, to);
  }

  function accept_concierge() external {
    require(msg.sender == _new_concierge, "must be new concierge");
    concierge = msg.sender;
    emit AcceptConcierge(msg.sender);
  }

  event SetAdapter(address to);

  function set_adapter(address to) external {
    require(msg.sender == governance, "must be governance");
    adapter = ISaffronAdapter(to);
    emit SetAdapter(to);
  }

  event SetSfiRatio(uint256 ratio);

  function set_SFI_ratio(uint256 ratio) external {
    require(msg.sender == governance, "must be governance");
    SFI_ratio = ratio;
    emit SetSfiRatio(ratio);
  }

  event SetAWeight(uint256 weight);

  function set_A_weight(uint256 weight) external {
    require(msg.sender == governance, "must be governance");
    A_weight = weight;
    emit SetAWeight(weight);
  }

  event SetCapitalRestriction(uint256 cap);

  function set_capital_restriction(uint256 cap) external {
    require(msg.sender == governance, "must be governance");
    capital_restriction = cap;
    emit SetCapitalRestriction(cap);
  }

  event ErcSwept(address who, address to, address token, uint256 amount);

  function erc_sweep(address _token, address _to) public {
    require(msg.sender == governance, "must be governance");

    IERC20 tkn = IERC20(_token);
    uint256 tBal = tkn.balanceOf(address(this));
    tkn.safeTransfer(_to, tBal);

    emit ErcSwept(msg.sender, _to, _token, tBal);
  }

  function get_balance(Tranche tranche, address addr) external view returns (uint256) {
    return _get_balance(tranche, addr);
  }

  function _get_balance(Tranche tranche, address addr) internal view returns (uint256) {
    if (tranche == Tranche.A) {
      return A_balance[addr];
    }
    if (tranche == Tranche.AA) {
      return LP_AA.balanceOf(addr);
    }
    if (tranche == Tranche.S) {
      return LP_S.balanceOf(addr);
    }
    revert("bad tranche");
  }

  function get_base_balance(Tranche tranche, address addr) external view returns (uint256) {
    return _get_base_balance(tranche, addr);
  }

  function _get_base_balance(Tranche tranche, address addr) internal view returns (uint256) {
    return _get_balance(tranche, addr) * tranche_exchange_rate[uint256(tranche)] / 1e28;
  }

  function get_sfi_balance(Tranche tranche, address addr) external view returns (uint256) {
    if (tranche == Tranche.A) {
      return A_SFI_balance[addr];
    }
    if (tranche == Tranche.AA) {
      // SFI not staked for AA
      return 0;
    }
    if (tranche == Tranche.S) {
      // SFI not staked for S
      return 0;
    }
    revert("bad tranche");
  }

  event WhitelistAdd(address who);
  event WhitelistRm(address who);

  function whitelist_add(address who) external {
    require(msg.sender == governance, "must be governance");
    whitelist[who] = true;
    emit WhitelistAdd(who);
  }

  function whitelist_rm(address who) external {
    require(msg.sender == governance, "must be governance");
    whitelist[who] = false;
    emit WhitelistRm(who);
  }

  function whitelist_add_arr(address[] memory who) public {
    require(msg.sender == governance, "must be governance");
    if (who.length == 0) return;
    for (uint i = 0; i < who.length; i++) {
      whitelist[who[i]] = true;
      emit WhitelistAdd(who[i]);
    }
  }

  function whitelist_rm_arr(address[] memory who) public {
    require(msg.sender == governance, "must be governance");
    if (who.length == 0) return;
    for (uint i = 0; i < who.length; i++) {
      whitelist[who[i]] = false;
      emit WhitelistRm(who[i]);
    }
  }

  fallback () external payable {}
}