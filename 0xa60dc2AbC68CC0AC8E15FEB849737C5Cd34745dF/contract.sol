// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
pragma abicoder v2;


/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */


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
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}



/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
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
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimal;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_, uint8 decimal_) {
        _name    = name_;
        _symbol  = symbol_;
        _decimal = decimal_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimal;
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

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

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
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
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

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
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

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
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
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
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

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}



// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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
        return a + b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
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
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */

abstract contract IHoldlersRewardComputer {

    uint256 public rewardStartDelay;
    uint256 public minExpectedHoldlPeriod;

    function getReward(address _account) virtual public view returns(uint256);
    function setRewardStartDelay(uint256 _timeInSeconds) virtual public;
    function setMinExpectedHoldlPeriod(uint256 _timeInSeconds) virtual public;
}


/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */

contract StructsDef {

    struct HoldlerInfo {
        uint256 depositCount;
        uint256 initialDepositTimestamp; // initial deposit time stamp
        uint256 totalRewardReleased;
    }

    struct AccountThrottleInfo {
        uint256 txAmountLimitPercent;
        uint256 timeIntervalPerTx;
        uint256 lastTxTime;
    }

    struct FactionInfo {
        address  _address;
        uint256  _totalMembers;
        uint256  _totalPoint;
        uint256  _createdAt;
        uint256  _updatedAt;
        uint8    status;
    }

}


/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */

interface _IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

contract Commons is Ownable {

    /**
     * move tokens on emergency cases
     */
    function emergencyWithdrawTokens(address _contractAddress, address _toAddress, uint256 _amount) public onlyOwner {

        _IERC20 erc20Token  =  _IERC20(_contractAddress);

        uint256 balance = erc20Token.balanceOf(address(this));

        if(balance >= _amount){
            erc20Token.transfer(_toAddress, _amount);
        }
    } //end function

    /**
     * move Ethers on emergency cases
     */
    function emergencyWithdrawEthers(address payable _toAddress,  uint256 _amount) public onlyOwner {

        uint256 balance = address(this).balance;

        if(balance >= _amount){
            _toAddress.transfer(_amount);
        }
    }

}


/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */

abstract contract ISwapEngine {

    bytes32 public TX_TRANSFER;
    bytes32 public TX_SELL;
    bytes32 public TX_BUY;
    bytes32 public TX_ADD_LIQUIDITY;
    bytes32 public TX_REMOVE_LIQUIDITY;

    function swapTokenForETH(uint256 _amountToken, address payable _to) virtual external payable returns(uint256);

    function addLiquidity(uint256 _amountToken, uint256 _amountETH) virtual external payable  returns(uint256, uint256, uint256);
    function swapAndLiquidify(uint256 _amountToken) virtual external payable returns(uint256, uint256, uint256);
    function addInitialLiquidity(uint256 _amountToken ) virtual external;
    function setUniswapRouter(address _uniswapRoter) virtual public;

    function getUniswapPair() virtual public view returns(address);
    function getUniswapRouter() virtual public view returns(address);

    function swapETHForToken(uint256 _amountETH, address _to) virtual public payable returns(uint256);

    function getTxType(address msgSender__, address _from, address _to, uint256  _amount) virtual public  view returns(bytes32);

}


library console {
	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);

	function _sendLogPayload(bytes memory payload) private view {
		uint256 payloadLength = payload.length;
		address consoleAddress = CONSOLE_ADDRESS;
		assembly {
			let payloadStart := add(payload, 32)
			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
		}
	}

	function log() internal view {
		_sendLogPayload(abi.encodeWithSignature("log()"));
	}

	function logInt(int p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
	}

	function logUint(uint p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
	}

	function logString(string memory p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
	}

	function logBool(bool p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
	}

	function logAddress(address p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
	}

	function logBytes(bytes memory p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
	}

	function logBytes1(bytes1 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
	}

	function logBytes2(bytes2 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
	}

	function logBytes3(bytes3 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
	}

	function logBytes4(bytes4 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
	}

	function logBytes5(bytes5 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
	}

	function logBytes6(bytes6 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
	}

	function logBytes7(bytes7 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
	}

	function logBytes8(bytes8 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
	}

	function logBytes9(bytes9 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
	}

	function logBytes10(bytes10 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
	}

	function logBytes11(bytes11 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
	}

	function logBytes12(bytes12 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
	}

	function logBytes13(bytes13 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
	}

	function logBytes14(bytes14 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
	}

	function logBytes15(bytes15 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
	}

	function logBytes16(bytes16 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
	}

	function logBytes17(bytes17 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
	}

	function logBytes18(bytes18 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
	}

	function logBytes19(bytes19 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
	}

	function logBytes20(bytes20 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
	}

	function logBytes21(bytes21 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
	}

	function logBytes22(bytes22 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
	}

	function logBytes23(bytes23 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
	}

	function logBytes24(bytes24 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
	}

	function logBytes25(bytes25 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
	}

	function logBytes26(bytes26 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
	}

	function logBytes27(bytes27 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
	}

	function logBytes28(bytes28 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
	}

	function logBytes29(bytes29 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
	}

	function logBytes30(bytes30 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
	}

	function logBytes31(bytes31 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
	}

	function logBytes32(bytes32 p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
	}

	function log(uint p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
	}

	function log(string memory p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
	}

	function log(bool p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
	}

	function log(address p0) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
	}

	function log(uint p0, uint p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
	}

	function log(uint p0, string memory p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
	}

	function log(uint p0, bool p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
	}

	function log(uint p0, address p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
	}

	function log(string memory p0, uint p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
	}

	function log(string memory p0, string memory p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
	}

	function log(string memory p0, bool p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
	}

	function log(string memory p0, address p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
	}

	function log(bool p0, uint p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
	}

	function log(bool p0, string memory p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
	}

	function log(bool p0, bool p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
	}

	function log(bool p0, address p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
	}

	function log(address p0, uint p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
	}

	function log(address p0, string memory p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
	}

	function log(address p0, bool p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
	}

	function log(address p0, address p1) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
	}

	function log(uint p0, uint p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
	}

	function log(uint p0, uint p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
	}

	function log(uint p0, uint p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
	}

	function log(uint p0, uint p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
	}

	function log(uint p0, string memory p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
	}

	function log(uint p0, string memory p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
	}

	function log(uint p0, string memory p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
	}

	function log(uint p0, string memory p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
	}

	function log(uint p0, bool p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
	}

	function log(uint p0, bool p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
	}

	function log(uint p0, bool p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
	}

	function log(uint p0, bool p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
	}

	function log(uint p0, address p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
	}

	function log(uint p0, address p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
	}

	function log(uint p0, address p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
	}

	function log(uint p0, address p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
	}

	function log(string memory p0, uint p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
	}

	function log(string memory p0, uint p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
	}

	function log(string memory p0, uint p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
	}

	function log(string memory p0, uint p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
	}

	function log(string memory p0, string memory p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
	}

	function log(string memory p0, string memory p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
	}

	function log(string memory p0, string memory p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
	}

	function log(string memory p0, string memory p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
	}

	function log(string memory p0, bool p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
	}

	function log(string memory p0, bool p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
	}

	function log(string memory p0, bool p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
	}

	function log(string memory p0, bool p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
	}

	function log(string memory p0, address p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
	}

	function log(string memory p0, address p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
	}

	function log(string memory p0, address p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
	}

	function log(string memory p0, address p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
	}

	function log(bool p0, uint p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
	}

	function log(bool p0, uint p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
	}

	function log(bool p0, uint p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
	}

	function log(bool p0, uint p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
	}

	function log(bool p0, string memory p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
	}

	function log(bool p0, string memory p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
	}

	function log(bool p0, string memory p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
	}

	function log(bool p0, string memory p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
	}

	function log(bool p0, bool p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
	}

	function log(bool p0, bool p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
	}

	function log(bool p0, bool p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
	}

	function log(bool p0, bool p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
	}

	function log(bool p0, address p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
	}

	function log(bool p0, address p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
	}

	function log(bool p0, address p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
	}

	function log(bool p0, address p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
	}

	function log(address p0, uint p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
	}

	function log(address p0, uint p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
	}

	function log(address p0, uint p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
	}

	function log(address p0, uint p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
	}

	function log(address p0, string memory p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
	}

	function log(address p0, string memory p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
	}

	function log(address p0, string memory p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
	}

	function log(address p0, string memory p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
	}

	function log(address p0, bool p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
	}

	function log(address p0, bool p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
	}

	function log(address p0, bool p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
	}

	function log(address p0, bool p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
	}

	function log(address p0, address p1, uint p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
	}

	function log(address p0, address p1, string memory p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
	}

	function log(address p0, address p1, bool p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
	}

	function log(address p0, address p1, address p2) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
	}

	function log(uint p0, uint p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, uint p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, string memory p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, bool p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
	}

	function log(uint p0, address p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, uint p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, string memory p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, bool p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
	}

	function log(string memory p0, address p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, uint p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, string memory p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, bool p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
	}

	function log(bool p0, address p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
	}

	function log(address p0, uint p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
	}

	function log(address p0, string memory p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
	}

	function log(address p0, bool p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, uint p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, uint p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, uint p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, uint p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, string memory p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, string memory p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, string memory p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, string memory p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, bool p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, bool p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, bool p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, bool p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, address p2, uint p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, address p2, string memory p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, address p2, bool p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
	}

	function log(address p0, address p1, address p2, address p3) internal view {
		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
	}

}



/**
 * PowerBull (https://powerbull.net)
 * @author PowerBull <hello@powerbull.net>
 */

abstract contract ITeams {

    function logTransferTx(
        bytes32 txType,
        address msgSender__,
        address sender,
        address recipient,
        uint256 amount,
        uint256 amountWithFee
    ) virtual public returns(uint256);

}

contract PBull is   Context, Ownable, ERC20, Commons {

    event Receive(address _sender, uint256 _amount);
    event SetUniSwapRouter(address indexed _routerAddress);
    event SetAutoBurnFee(uint256 _value);
    event SetHoldlersRewardFee(uint256 _value);
    event SetLiquidityProvidersIncentiveFee(uint256 _value);
    event SetAutoLiquidityFee(uint256 _value);
    event SetAutoLiquidityOwner(address indexed _account);
    event AddMinter(address indexed _account);
    event RemoveMinter(address indexed _account);
    event SetTokenBurnStrategyContract(address indexed _contractAddress);
    event EnableBurn(bool _option);
    event EnableAutoLiquidity(bool _option);
    event EnableHoldlersReward(bool _option);
    event EnableLiquidityProvidersIncentive(bool _option);
    event SetHoldlersRewardComputer(address indexed _contractAddress);
    event SetMaxTxAmountLimitPercent(uint256  _value);
    event EnableMaxTxAmountLimit(bool _option);
    //event EnableMaxBalanceLimit(bool _option);
    event SetLiquidityProvidersIncentiveWallet(address indexed _account);
    event SetMinAmountBeforeAutoLiquidity(uint256 _amount);
    event ReleaseAccountReward(address indexed _account, uint256 _amount);
    event ExcludeFromFees(address indexed _account, bool _option);
    event SetSwapEngine(address indexed _contractAddress);
    event ExcludeFromRewards(address indexed _account, bool _option);
    event ExcludeFromMaxTxAmountLimit(address indexed _account, bool _option);
    event EnableBuyBack(bool _option);
    event SetBuyBackFee(uint256 _value);
    event SetMinAmountBeforeAutoBurn(uint256 _amount);
    event SetPercentageShareOfHoldlersRewardsForReservedPool(uint256 _valueBps);
    event SetMinPercentageOfholdlersRewardReservedPoolToMainPool(uint256 _valueBps);
    event ThrottleAccount(address indexed _account, uint256 _amountPerTx, uint256 _txIntervals);
    event UnThrottleAccountTx(address indexed _account);
    event EnableSellTax(bool _option);
    event SetSellTaxFee(uint256 _valueBps);
    event EnableTeams(bool _option);
    event SetTeamsContract(address _contractAddress);
    event SetTxTypeForMaxTxAmountLimit(bytes32 _txType);
    event ExcludeFromPaused(address indexed _account, bool _option);
    event PauseContract(bool _option);
    event SetPerAccountExtraTax(address indexed _account, uint256 _valueBps);
    event SetMinAmountBeforeSellingTokenForBuyBack(uint256 _amount);
    event SetMinAmountBeforeSellingETHForBuyBack(uint256 _amount);
    event SetBuyBackETHAmountSplitDivisor(uint256 _value);

    using SafeMath for uint256;

    string  private constant  _tokenName                          =    "PowerBull";
    string  private constant  _tokenSymbol                        =    "PBULL";
    uint8   private constant  _tokenDecimals                      =     18;
    uint256 private constant  _tokenSupply                        =     26_000_000  * (10 ** _tokenDecimals); // 25m

    /////////////////////// This will deposit _initialPercentageOfTokensForRewardPool into the reward pool for the users to split over time /////////////
    /////////////////////// Note this is a one time during contract initialization ///////////////////////////////////////////////////////
    uint256 public constant  _initialPercentOfTokensForHoldlersRewardPool =  100; /// 1% of total supply

    bool public isAutoBurnEnabled                                  =  true;
    bool public isAutoLiquidityEnabled                             =  true;
    bool public isHoldlersRewardEnabled                            =  true;
    bool public isLiquidityProvidersIncentiveEnabled               =  true;
    bool public isBuyBackEnabled                                   =  true;
    bool public isSellTaxEnabled                                   =  true;

    //limits
    bool public isMaxTxAmountLimitEnabled                           = true;

    bool public isTeamsEnabled                                      = true;

    //using basis point, multiple number by 100
    uint256  public  holdlersRewardFee                               =  100;     // 1% for holdlers reward pool
    uint256  public  liquidityProvidersIncentiveFee                  =  100;    //  1% for liquidity providers incentives
    uint256  public  autoLiquidityFee                                =  100;     // 1% fee charged on tx for adding liquidity pool
    uint256  public  autoBurnFee                                     =  50;      //  1% will be burned
    uint256  public  buyBackFee                                      =  100;     // 1% will be used for buyback
    uint256  public  sellTaxFee                                      =  50;    //  1% a sell tax fee, which applies to sell only

    //buyback
    uint256 public minAmountBeforeSellingTokenForBuyBack             =  50_000 * (10 ** _tokenDecimals);
    uint256 public minAmountBeforeSellingETHForBuyBack               =  1 ether;
    uint256 public buyBackETHAmountSplitDivisor                      =  100;

    uint256 public buyBackTokenPool;
    uint256 public buyBackETHPool;

    uint256 public totalBuyBacksAmountInTokens;
    uint256 public totalBuyBacksAmountInETH;

    // funds pool
    uint256  public autoLiquidityPool;
    uint256  public autoBurnPool;
    uint256  public liquidityProvidersIncentivePool;

    //////////////////////////////// START REWARD POOL ///////////////////////////
    uint256  public holdlersRewardMainPool;

    // reward pool reserve  used in replenishing the main pool any time someone withdraw else
    // the others holdlers will see a reduction  in rewards
    uint256  public holdlersRewardReservedPool;

    ////// percentage of reward we should allocate to  reserve pool
    uint256  public percentageShareOfHoldlersRewardsForReservedPool                       =  3000; /// 30% in basis point system

    // The minimum amount required to keep in the holdlersRewardsReservePool
    // this means if the reserve pool goes less than minPercentOfReserveRewardToMainRewardPool  of the main pool, use
    // next collected fee for rewards into the reserve pool till its greater than minPercentOfReserveRewardToMainRewardPool
    uint256 public minPercentageOfholdlersRewardReservedPoolToMainPool                    =  3000; /// 30% in basis point system

    ///////////////////////////////// END  REWARD POOL ////////////////////////////

    // liquidity owner
    address public autoLiquidityOwner;

    //max transfer amount  ( anti whale check ) in BPS (Basis Point System )
    uint256 public maxTxAmountLimitPercent                                  =  1000; //10% of total supply

    //minimum amount before adding auto liquidity
    uint256 public minAmountBeforeAutoLiquidity                             =   60_000 * (10 ** _tokenDecimals);

    // minimum amount before auto burn
    uint256 public minAmountBeforeAutoBurn                                  =   500_000 * (10 ** _tokenDecimals);

    bytes32 public  txTypeForMaxTxAmountLimit                               =   keccak256(abi.encodePacked("TX_SELL"));
    ///////////////////// START  MAPS ///////////////////////

    //accounts excluded from fees
    mapping(address => bool) public excludedFromFees;
    mapping(address => bool) public excludedFromRewards;
    mapping(address => bool) public excludedFromMaxTxAmountLimit;
    mapping(address => bool) public excludedFromPausable;

    //throttle acct tx
    mapping(address => StructsDef.AccountThrottleInfo) public throttledAccounts;

    // extra tax Per account basis
    mapping(address => uint256) public perAccountExtraTax;

    // burn history info
    //BurnInfo[] public  burnHistoryInfo;

    uint256 public totalTokensBurned;

    //permitted minters
    mapping(address => bool)  public  minters;

    // permit nonces
    mapping(address => uint) public nonces;

    //acounts deposit info mapping keeping all user info
    // address => initial Deposit timestamp
    mapping(address => StructsDef.HoldlerInfo) private holdlersInfo;

    ////////////////// END MAPS ////////////////

    uint256 public totalRewardsTaken;

    bool isSwapAndLiquidifyLocked;

    // extending erc20 to support permit
    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    // timestamp the contract was deployed
    uint256 public immutable deploymentTimestamp;

    // isPaused
    bool public isPaused; // if contract is paused

    // total token holders
    uint256 public totalTokenHolders;

    // external contracts
    IHoldlersRewardComputer   public    holdlersRewardComputer;
    ISwapEngine               public    swapEngine;
    ITeams                    public    teamsContract;

    address                   public    uniswapRouter;
    address                   public    uniswapPair;

    uint256                   public    totalLiquidityAdded;

    //////// WETHER the token is initialized or not /////////////
    bool public initialized;

    // token contract
    address public immutable _tokenAddress;

    // constructor
    constructor() ERC20 (_tokenName,_tokenSymbol, _tokenDecimals) {

        // initialize token address
        _tokenAddress = address(this);

        // mint
        _mint(_msgSender(), _tokenSupply);

        //excludes for
        excludedFromFees[address(this)]                 =       true;
        excludedFromRewards[address(this)]              =       true;
        excludedFromMaxTxAmountLimit[address(this)]     =       true;
        excludedFromPausable[address(this)]             =       true;

        //excludes for owner
        excludedFromFees[_msgSender()]                  =       true;
        excludedFromPausable[_msgSender()]              =       true;
        excludedFromMaxTxAmountLimit[_msgSender()]      =       true;

        // set auto liquidity owner
        autoLiquidityOwner                              =       _msgSender();

        // set the deploymenet time
        deploymentTimestamp                             =       block.timestamp;

        // permit domain separator
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name())),
                keccak256(bytes('1')),
                getChainId(),
                address(this)
            )
        );

    } //end constructor

    /**
     * initialize the project
     * @param  _uniswapRouter the uniswap router
     * @param  _holdlersRewardComputer the holdlers reward computer
     *  @param  _swapEngine the swap engine address
     */
    function _initializeContract (
        address  _uniswapRouter,
        address  _swapEngine,
        address  _holdlersRewardComputer
    )  public onlyOwner {

        require(!initialized, "PBULL: ALREADY_INITIALIZED");
        require(_uniswapRouter != address(0), "PBULL: INVALID_UNISWAP_ROUTER");
        require(_swapEngine != address(0), "PBULL: INVALID_SWAP_ENGINE_CONTRACT");
        require(_holdlersRewardComputer != address(0), "PBULL: INVALID_HOLDLERS_REWARD_COMPUTER_CONTRACT");

        // set _uniswapRouter
        uniswapRouter = _uniswapRouter;

        // this will update the uniswap router again
        setSwapEngine(_swapEngine);

        // exclude swap engine from all limits
        excludedFromFees[_swapEngine]                  =  true;
        excludedFromRewards[_swapEngine]               =  true;
        excludedFromMaxTxAmountLimit[_swapEngine]      =  true;
        excludedFromPausable[_swapEngine]              =  true;

        holdlersRewardComputer = IHoldlersRewardComputer(_holdlersRewardComputer);

        // lets deposit holdlers reward pool initial funds
        processHoldlersRewardPoolInitialFunds();

        initialized = true;

    }   //end intialize

    /**
    * @dev processRewardPool Initial Funds
    */
    function processHoldlersRewardPoolInitialFunds() private {

        require(!initialized, "PBULL: ALREADY_INITIALIZED");

         // if no tokens were assign to the rewards dont process
        if(_initialPercentOfTokensForHoldlersRewardPool == 0){
            return;
        }

        //let get the rewardPool initial funds
        uint256 rewardPoolInitialFunds = percentToAmount(_initialPercentOfTokensForHoldlersRewardPool, totalSupply());

        //first of all lets move funds to the contract
        internalTransfer(_msgSender(), _tokenAddress, rewardPoolInitialFunds,"REWARD_POOL_INITIAL_FUNDS_TRANSFER_ERROR", true);

        uint256 rewardsPoolsFundSplit = rewardPoolInitialFunds.sub(2);

         // lets split them 50% 50% into the rewardmainPool and rewards Reserved pool
         holdlersRewardMainPool = holdlersRewardMainPool.add(rewardsPoolsFundSplit);

         // lets put 50% into the reserve pool
         holdlersRewardReservedPool = holdlersRewardReservedPool.add(rewardsPoolsFundSplit);
    } //end function

    receive () external payable { emit Receive(_msgSender(), msg.value ); }

    fallback () external payable {}

    /**
     * lock swap or add liquidity  activity
     */
    modifier lockSwapAndLiquidify {
        isSwapAndLiquidifyLocked = true;
        _;
        isSwapAndLiquidifyLocked = false;
    }

    /**
     * get chain Id
     */
    function getChainId() public view returns (uint256) {
        uint256 id;
        assembly { id := chainid() }
        return id;
    }

    /**
     * @dev erc20 permit
     */
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'PBULL: PERMIT_EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'PBULL: PERMIT_INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }

    /**
     * realBalanceOf - get account real balance
     */
    function realBalanceOf(address _account)  public view returns(uint256) {
        return super.balanceOf(_account);
    }

    /**
     * override balanceOf - This now returns user balance + reward
     */
    function balanceOf(address _account) override public view returns(uint256) {

        uint256 accountBalance = super.balanceOf(_account);

        if(accountBalance <= 0){
            accountBalance = 0;
        }

        uint256 reward = getReward(_account);

        if(reward <= 0){
            return accountBalance;
        }

        return (accountBalance.add(reward));
    } //end fun

    ////////////////////////// HOLDERS REWARD COMPUTER FUNCTIONS ///////////////////
    /**
     * get an account reward
     * @param _account the account to get the reward info
     */
    function getReward(address _account) public view returns(uint256) {

        if(!isHoldlersRewardEnabled || excludedFromRewards[_account]) {
            return 0;
        }

        uint256 reward = holdlersRewardComputer.getReward(_account);

        if(reward <= 0){
            return 0;
        }

        return reward;

    }//end get reward

    /**
     * @dev the delay in seconds before a holdlers starts seeing rewards after initial deposit
     * @return time in seconds
     */
    function rewardStartDelay() public view returns(uint256) {
       return holdlersRewardComputer.rewardStartDelay();
    }

    /**
     * @dev set the number of delay in time before a reward starts showing up
     * @param _delayInSeconds the delay in seconds
     */
    function setRewardStartDelay(uint256 _delayInSeconds) public onlyOwner {
        holdlersRewardComputer.setRewardStartDelay(_delayInSeconds);
    }

    /**
     * @dev the minimum expected holdl period
     * @return time in seconds
     */
     function minExpectedHoldlPeriod() public view returns (uint256) {
        return holdlersRewardComputer.minExpectedHoldlPeriod();
     }

    /**
     * @dev set the minimum expected holdl period
     * @param _timeInSeconds time in seconds
     */
     function setMinExpectedHoldlPeriod(uint256 _timeInSeconds) public onlyOwner  {
         holdlersRewardComputer.setMinExpectedHoldlPeriod(_timeInSeconds);
     }

    ////////////////////////// END HOLDERS REWARD COMPUTER FUNCTIONS ///////////////////

    /**
     * @dev get initial deposit time
     * @param _account the account to get the info
     * @return account tx info
     */
    function getHoldlerInfo(address _account) public view returns (StructsDef.HoldlerInfo memory) {
        return holdlersInfo[_account];
    }

    ///////////////////////// START MINT OPERATIONS ///////////////////

    modifier onlyMinter {
        require(minters[_msgSender()],"PBULL: ONLY_MINTER_PERMITED");
        _;
    }

    /**
     * mint new tokens
     * @param account - the account to mint token to
     * @param amount - total number of tokens to mint
     */
    function mint(address account, uint256 amount) public onlyMinter {

        require(amount > 0,"PBULL: ZERO_AMOUNT");

        // before mint, lets check if the account initial balance is 0, then we have a new holder
        if(balanceOf(account) == 0) {
            totalTokenHolders = totalTokenHolders.add(1);
        }

        _mint(account, amount);
    }

    /**
     * @dev add or remove minter
     * @param _account the account to add or remove minter
     * @param _option  true to enable as minter, false to disable as minter
     */
    function setMinter(address _account, bool _option) public onlyOwner {
        require(_account != address(0),"PBULL: INVALID_ADDRESS");
        minters[_account] = _option;
        emit AddMinter(_account);
    }

    //////////////////////////////// END MINT OPERATIONS //////////////////////

    /**
     * @dev token burn operation override
     * @param account the account to burn token from
     * @param amount the total number of tokens to burn
     */
    function _burn(address account, uint256 amount) override internal virtual {

        super._burn(account,amount);

        //calculate the no of token holders
        if(balanceOf(account) == 0 && totalTokenHolders > 0){
            totalTokenHolders = totalTokenHolders.sub(1);
        }

        //lets check where the burn is from
        if(account == _tokenAddress || account == address(swapEngine)){
            if(autoBurnPool > amount){
                autoBurnPool = autoBurnPool.sub(amount);
            } else {
                autoBurnPool = 0;
            }
        }

        totalTokensBurned = totalTokensBurned.add(amount);
    } //end burn override

    //////////////////////// START OPTION SETTER /////////////////

    /**
     * @dev set auto liquidity owner address
     * @param _account the EOS address for system liquidity
     */
    function setAutoLiquidityOwner(address _account) public onlyOwner {
         autoLiquidityOwner = _account;
         emit SetAutoLiquidityOwner(_account);
    }

    /**
     * @dev enable or disable auto burn
     * @param _option true to enable, false to disable
     */
    function enableAutoBurn(bool _option) public onlyOwner {
        isAutoBurnEnabled = _option;
        emit EnableBurn(_option);
    }

    /**
     * @dev enable or disable auto buyback
     * @param _option true to enable, false to disable
     */
    function enableBuyBack(bool _option) public onlyOwner {
        isBuyBackEnabled = _option;
        emit EnableBuyBack(_option);
    }

    /**
     * @dev enable or disable auto liquidity
     * @param _option true to enable, false to disable
     */
    function enableAutoLiquidity(bool _option) public onlyOwner {
        isAutoLiquidityEnabled = _option;
        emit EnableAutoLiquidity(_option);
    }

    /**
     * @dev enable or disable holdlers reward
     * @param _option true to enable, false to disable
     */
    function enableHoldlersReward(bool _option) public onlyOwner {
        isHoldlersRewardEnabled = _option;
        emit EnableHoldlersReward(_option);
    }

    /**
     *  @dev enable or disable liquidity providers incentives
     *  @param _option true to enable, false to disable
     */
    function enableLiquidityProvidersIncentive(bool _option) public onlyOwner {
        isLiquidityProvidersIncentiveEnabled = _option;
        emit EnableLiquidityProvidersIncentive(_option);
    }

    /**
     *  @dev enable or disable max transaction amount limit
     *  @param _option true to enable, false to disable
     */
    function enableMaxTxAmountLimit(bool _option) public onlyOwner {
        isMaxTxAmountLimitEnabled = _option;
        emit EnableMaxTxAmountLimit(_option);
    }

    /**
     * @dev enable or disable sell Tax
     * @param _option true to enable, false to disable
     */
    function enableSellTax(bool _option) public onlyOwner {
        isSellTaxEnabled = _option;
        emit EnableSellTax(_option);
    }

    /**
     * @dev enable or disable all fees
     * @param _option true to enable, false to disable
     */
    function enableAllFees(bool _option) public onlyOwner {
        isAutoBurnEnabled                       = _option;
        isBuyBackEnabled                        = _option;
        isAutoLiquidityEnabled                  = _option;
        isHoldlersRewardEnabled                 = _option;
        isLiquidityProvidersIncentiveEnabled    = _option;
        isSellTaxEnabled                        = _option;
    }

    // lets enable contingence
    function enableTeams(bool _option) public onlyOwner {
        isTeamsEnabled = _option;
        emit EnableTeams(_option);
    }

    //////////////////// END OPTION SETTER //////////

    ////////////// ACCOUNT TX THROTTLE FOR BOTS //////////////

    /**
     * @dev throttle account tx
     * @param _account an address of the account to throttle
     * @param _txAmountLimitPercent max amount per tx in percentage in relative to totalSupply a throttled account can have
     * @param _txIntervals time interval per transaction
     */
    function throttleAccountTx(
        address _account,
        uint256 _txAmountLimitPercent,
        uint256 _txIntervals
    ) public onlyOwner {

        require(_account != address(0),"PBULL: INVALID_ACCOUNT_ADDRESS");

        // if the _amountPerTx is greater the maxTxAmount, revert
        require(_txAmountLimitPercent <= maxTxAmountLimitPercent, "PBULL: _txAmountLimitPercent exceeds maxTxAmountLimitPercent");

        throttledAccounts[_account] = StructsDef.AccountThrottleInfo(_txAmountLimitPercent, _txIntervals, 0);

        emit ThrottleAccount(_account, _txAmountLimitPercent, _txIntervals);
    } //end function

    /**
     * @dev unthrottle account tx
     * @param _account the account address to unthrottle its tx
     */
    function unThrottleAccountTx(
        address _account
    ) public onlyOwner {

        require(_account != address(0),"PBULL: INVALID_ACCOUNT_ADDRESS");

        delete  throttledAccounts[_account];

        emit UnThrottleAccountTx(_account);
    } //end function

    ////////////////// END THROTTLE BOTS /////////////////////

    ///////////////////// START  SETTER ///////////////

     /**
     * @dev set the auto burn fee
     * @param _valueBps the fee value in basis point system
     */
    function setAutoBurnFee(uint256 _valueBps) public onlyOwner {
        autoBurnFee = _valueBps;
        emit SetAutoBurnFee(_valueBps);
    }

    /**
     * @dev set the auto buyback fee
     * @param _valueBps the fee value in basis point system
     */
    function setBuyBackFee(uint256 _valueBps) public onlyOwner {
        buyBackFee = _valueBps;
        emit SetBuyBackFee(_valueBps);
    }

    /**
     * @dev set holdlers reward fee
     * @param _valueBps the fee value in basis point system
     */
    function setHoldlersRewardFee(uint256 _valueBps) public onlyOwner {
        holdlersRewardFee = _valueBps;
        emit SetHoldlersRewardFee(_valueBps);
    }

    /**
     * @dev set liquidity providers incentive fee
     * @param _valueBps the fee value in basis point system
     */
    function setLiquidityProvidersIncentiveFee(uint256 _valueBps) public onlyOwner {
        liquidityProvidersIncentiveFee = _valueBps;
        emit SetLiquidityProvidersIncentiveFee(_valueBps);
    }

    /**
     * @dev auto liquidity fee
     * @param _valueBps the fee value in basis point system
     */
    function setAutoLiquidityFee(uint256 _valueBps) public onlyOwner {
        autoLiquidityFee = _valueBps;
        emit SetAutoLiquidityFee(_valueBps);
    }

    /**
     * @dev set Sell Tax Fee
     * @param _valueBps the fee value in basis point system
     */
    function setSellTaxFee(uint256 _valueBps) public onlyOwner {
        sellTaxFee = _valueBps;
        emit SetSellTaxFee(_valueBps);
    }

    /**
     * @dev setTeamsContract
     * @param _contractAddress the contract address
     */
    function setTeamsContract(address _contractAddress)  public onlyOwner {
        teamsContract = ITeams(_contractAddress);
        emit SetTeamsContract(_contractAddress);
    }

    /**
     * @dev setPerAccountExtraTax
     * @param _account the account to add the extra tax
     * @param _valueBps the extra tax in basis point system
     */
     function setPerAccountExtraTax(address _account, uint256 _valueBps) public onlyOwner {
        perAccountExtraTax[_account] = _valueBps;
        emit SetPerAccountExtraTax(_account, _valueBps);
     }

    //////////////////////////// END  SETTER /////////////////

    /**
     * @dev get total fee
     * @return the total fee in uint256 number
     */
    function getTotalFee() public view returns(uint256){

        uint256 fee = 0;

        if(isAutoBurnEnabled){ fee += autoBurnFee; }
        if(isBuyBackEnabled){ fee += buyBackFee; }
        if(isAutoLiquidityEnabled){ fee += autoLiquidityFee; }
        if(isHoldlersRewardEnabled){ fee += holdlersRewardFee; }
        if(isLiquidityProvidersIncentiveEnabled){ fee += liquidityProvidersIncentiveFee; }
        if(isSellTaxEnabled) { fee += sellTaxFee; }

        return fee;
    } //end function

    /**
     * get fee by user
     * @param _account user account's address
     */
    function getAccountFee(address _account) public view returns(uint256){
        return (getTotalFee().add(perAccountExtraTax[_account]));
    }

    /**
     * @dev set max transfer limit in percentage
     * @param _valueBps the max transfer limit value in basis point system
     */
    function setMaxTxAmountLimitPercent(uint256 _valueBps) public onlyOwner {
        maxTxAmountLimitPercent = _valueBps;
        emit SetMaxTxAmountLimitPercent(_valueBps);
    }

    /**
     * @dev types of Tx for Tx amount Limit
     * @param _txType the transaction type
     */
    function setTxTypeForMaxTxAmountLimit(bytes32 _txType) public onlyOwner {

        require(

            _txType == swapEngine.TX_SELL() ||
            _txType == swapEngine.TX_BUY() ||
            _txType == swapEngine.TX_ADD_LIQUIDITY() ||
            _txType == swapEngine.TX_REMOVE_LIQUIDITY() ||
            _txType == swapEngine.TX_TRANSFER() ||
            _txType == keccak256(abi.encodePacked("TX_ALL")),
            "PBULL: INVALID_TX_TYPE"
        );

        txTypeForMaxTxAmountLimit = _txType;

        emit SetTxTypeForMaxTxAmountLimit(_txType);
    }

    /**
     * @dev set holders reward computer contract called HoldlEffect
     * @param _contractAddress the contract address
     */
    function setHoldlersRewardComputer(address _contractAddress) public onlyOwner {
        require(_contractAddress != address(0),"PBULL: SET_HOLDLERS_REWARD_COMPUTER_INVALID_ADDRESS");
        holdlersRewardComputer = IHoldlersRewardComputer(_contractAddress);
        emit SetHoldlersRewardComputer(_contractAddress);
    }

    /**
     * @dev set the token swap engine
     * @param _swapEngineContract the contract address of the swap engine
     */
    function setSwapEngine(address _swapEngineContract)  public onlyOwner {

        require(_swapEngineContract != address(0),"PBULL: SET_SWAP_ENGINE_INVALID_ADDRESS");

        swapEngine = ISwapEngine(_swapEngineContract);

        excludedFromFees[_swapEngineContract]                =  true;
        excludedFromRewards[_swapEngineContract]             =  true;
        excludedFromMaxTxAmountLimit[_swapEngineContract]    =  true;
        excludedFromPausable[_swapEngineContract]            =  true;

        // lets reset setUniswapRouter
        setUniswapRouter(uniswapRouter);

        emit SetSwapEngine(_swapEngineContract);
    }

     /**
     * @dev set uniswap router address
     * @param _uniswapRouter uniswap router contract address
     */
    function setUniswapRouter(address _uniswapRouter) public onlyOwner {

        require(_uniswapRouter != address(0), "PBULL: INVALID_ADDRESS");

        uniswapRouter = _uniswapRouter;

        //set uniswap address
        swapEngine.setUniswapRouter(_uniswapRouter);

        uniswapPair = swapEngine.getUniswapPair();

        // lets disable rewards for uniswap pair and router
        excludedFromRewards[_uniswapRouter] = true;
        excludedFromRewards[uniswapPair] = true;

        emit SetUniSwapRouter(_uniswapRouter);
    }

    ////////////////// START EXCLUDES ////////////////

    /**
     * @dev exclude or include  an account from paying fees
     * @param _option true to exclude, false to include
     */
    function excludeFromFees(address _account, bool _option) public onlyOwner {
        excludedFromFees[_account] = _option;
        emit ExcludeFromFees(_account, _option);
    }

    /**
     * @dev exclude or include  an account from getting rewards
     * @param _option true to exclude, false to include
     */
    function excludeFromRewards(address _account, bool _option) public onlyOwner {
        excludedFromRewards[_account] = _option;
        emit ExcludeFromRewards(_account, _option);
    }

    /**
     * @dev exclude or include  an account from max transfer limits
     * @param _option true to exclude, false to include
     */
    function excludeFromMaxTxAmountLimit(address _account, bool _option) public onlyOwner {
        excludedFromMaxTxAmountLimit[_account] = _option;
        emit ExcludeFromMaxTxAmountLimit(_account, _option);
    }

    /**
     * @dev exclude from paused
     * @param _option true to exclude, false to include
     */
    function excludeFromPausable(address _account, bool _option) public onlyOwner {
        excludedFromPausable[_account] = _option;
        emit ExcludeFromPaused(_account, _option);
    }

    //////////////////// END EXCLUDES ///////////////////

    /**
     * @dev minimum amount before adding auto liquidity
     * @param _amount the amount of tokens before executing auto liquidity
     */
    function setMinAmountBeforeAutoLiquidity(uint256 _amount) public onlyOwner {
        minAmountBeforeAutoLiquidity = _amount;
        emit SetMinAmountBeforeAutoLiquidity(_amount);
    }

    /**
     * @dev set min amount before auto burning
     * @param _amount the minimum amount when reached we should auto burn
     */
    function setMinAmountBeforeAutoBurn(uint256 _amount) public onlyOwner {
        minAmountBeforeAutoBurn = _amount;
        emit SetMinAmountBeforeAutoBurn(_amount);
    }

    /**
     * @dev set min amount before selling tokens for buyback
     * @param _amount the minimum amount
     */
    function setMinAmountBeforeSellingETHForBuyBack(uint256 _amount) public onlyOwner {
        minAmountBeforeSellingETHForBuyBack = _amount;
        emit SetMinAmountBeforeSellingETHForBuyBack(_amount);
    }

    /**
     * @dev set min amount before selling tokens for buyback
     * @param _amount the minimum amount
     */
    function setMinAmountBeforeSellingTokenForBuyBack(uint256 _amount) public onlyOwner {
        minAmountBeforeSellingTokenForBuyBack = _amount;
        emit SetMinAmountBeforeSellingTokenForBuyBack(_amount);
    }

    /**
     * @dev set the buyback eth divisor
     * @param _value the no of divisor
     */
    function setBuyBackETHAmountSplitDivisor(uint256 _value) public onlyOwner {
        buyBackETHAmountSplitDivisor = _value;
        emit SetBuyBackETHAmountSplitDivisor(_value);
    }

    /**
     * set the min amount of reserved rewards pool to main rewards pool
     * @param _valueBps the value in basis point system
     */
    function setMinPercentageOfholdlersRewardReservedPoolToMainPool(uint256 _valueBps) public onlyOwner {
        minPercentageOfholdlersRewardReservedPoolToMainPool  = _valueBps;
        emit SetMinPercentageOfholdlersRewardReservedPoolToMainPool(_valueBps);
    }//end fun

    /**
     * set the the percentage share of holdlers rewards to be saved into the reserved pool
     * @param _valueBps the value in basis point system
     */
    function setPercentageShareOfHoldlersRewardsForReservedPool(uint256 _valueBps) public onlyOwner {
        percentageShareOfHoldlersRewardsForReservedPool = _valueBps;
        emit SetPercentageShareOfHoldlersRewardsForReservedPool(_valueBps);
    }//end fun

    ////////// START SWAP AND LIQUIDITY ///////////////

    /**
     * @dev pause contract
     */
    function pauseContract(bool _option) public onlyOwner {
        isPaused = _option;
        emit  PauseContract(_option);
    }

    /**
    * @dev lets swap token for chain's native asset
    * this is bnb for bsc, eth for ethereum and ada for cardanno
    * @param _amountToken the amount of tokens to swap for ETH
    */
    function __swapTokenForETH(uint256 _amountToken) private  lockSwapAndLiquidify returns(uint256) {

        require(address(swapEngine) != address(0), "PBULL: SWAP_ENGINE_NOT_SET_CONTACT_DEVS");

        if( _amountToken > realBalanceOf(_tokenAddress) ) {
            return 0;
        }

        //lets move the token to swap engine first
        internalTransfer(_tokenAddress, address(swapEngine), _amountToken, "SWAP_TOKEN_FOR_ETH_ERROR", false);

        //now swap your tokens
        return swapEngine.swapTokenForETH( _amountToken, payable(_tokenAddress) );
    }

    /**
     * @dev swap and add liquidity
     * @param _amountToken amount of tokens to swap and liquidity
     */
    function swapAndLiquidify(uint256 _amountToken) private lockSwapAndLiquidify {

        require(address(swapEngine) != address(0), "PBULL: SWAP_ENGINE_NOT_SET_CONTACT_DEVS");

        // lets check if we have to that amount else abort operation
        if( _amountToken <= 0 || _amountToken > realBalanceOf(_tokenAddress) ){
            return;
        }

        //lets move the token to swap engine first
        internalTransfer(_tokenAddress, address(swapEngine), _amountToken, "SWAP_AND_LIQUIDIFY_ERROR", false);

        (,,uint256 liquidityAdded) = swapEngine.swapAndLiquidify(_amountToken);

        totalLiquidityAdded = totalLiquidityAdded.add(liquidityAdded);

     } //end function

    /**
     * @dev buyback tokens with the native asset and burn
     * @param _amountETH the total number of native asset to be used for buying back
     * @return the number of tokens bought and burned
     */
    function __swapETHForToken(uint256 _amountETH) private lockSwapAndLiquidify returns(uint256) {

        require(address(swapEngine) != address(0), "PBULL: SWAP_ENGINE_NOT_SET_CONTACT_DEVS");

        // if we do not have enough eth, silently abort
        if( _amountETH == 0 ||  _amountETH > _tokenAddress.balance ){
            return 0;
        }

        // the first param is the amount of native asset to buy token with
       // we want the tokens returned ... no burn address stuff
        return swapEngine.swapETHForToken { value: _amountETH }( _amountETH, address(this) );
    }
    ///////////// END SWAP AND LIQUIDITY ////////////

    /**
     * override _transfer
     * @param sender the token sender
     * @param recipient the token recipient
     * @param amount the number of tokens to transfer
     */
     function _transfer(address sender, address recipient, uint256 amount) override internal virtual {

        // check if the contract has been initialized
        require(initialized, "PBULL: CONTRACT_NOT_INITIALIZED");
        require(amount > 0, "PBULL: ZERO_AMOUNT");
        require(balanceOf(sender) >= amount, "PBULL: INSUFFICIENT_BALANCE");
        require(sender != address(0), "PBULL: INVALID_SENDER");

        // lets check if paused or not
        if(isPaused) {
            if( !excludedFromPausable[sender] ) {
                revert("PBULL: CONTRACT_PAUSED");
            }
        }

        // before we process anything, lets release senders reward
        releaseAccountReward(sender);

        // lets check if we have gain +1 user
        // before transfer if recipient has no tokens, means he or she isnt a token holder
        if(_balances[recipient] == 0) {
            totalTokenHolders = totalTokenHolders.add(1);
        } //end if

        //at this point lets get transaction type
        bytes32 txType = swapEngine.getTxType(_msgSender(), sender, recipient, amount);

        uint256 amountMinusFees = _processBeforeTransfer(sender, recipient, amount, txType);

        //make transfer
        internalTransfer(sender, recipient, amountMinusFees,  "PBULL: TRANSFER_AMOUNT_EXCEEDS_BALANCE", true);

        // lets check i we have lost one holdler
        if(totalTokenHolders > 0) {
            if(_balances[sender] == 0) totalTokenHolders = totalTokenHolders.sub(1);
        } //end if

        // lets update holdlers info
        updateHoldlersInfo(sender, recipient);

        // if faction is enabled, lets log the transfer tx
        if(isTeamsEnabled && address(teamsContract) != address(0)) {
            teamsContract.logTransferTx(txType, _msgSender(), sender, recipient, amount, amountMinusFees);
        }

        //emit Transfer(sender, recipient, amountMinusFees);
    } //end

    /**
     * tx type to string for testing only
     * @param _txType the transaction type
     *
    function txTypeToString(bytes32 _txType) public view returns (string memory) {
        if(_txType == swapEngine.TX_BUY()) { return "BUY_TRANSACTION"; }
        else if(_txType == swapEngine.TX_SELL()){ return "SELL_TRANSACTION"; }
        else if(_txType == swapEngine.TX_ADD_LIQUIDITY()){ return "ADD_LIQUIDITY_TRANSACTION"; }
        else if(_txType == swapEngine.TX_REMOVE_LIQUIDITY()){ return "REMOVE_TRANSACTION"; }
        else { return "TRANSFER_TRANSACTION"; }
    } */

    /**
     * @dev pre process transfer before the main transfer is done
     * @param sender the token sender
     * @param recipient the token recipient
     * @param amount the number of tokens to transfer
     */
     function _processBeforeTransfer(address sender, address recipient, uint256 amount,  bytes32 txType)  private returns(uint256) {

         // dont tax some operations
        if(txType    == swapEngine.TX_REMOVE_LIQUIDITY() ||
           sender    == address(swapEngine)              ||
           recipient == address(swapEngine)              ||
           isSwapAndLiquidifyLocked == true
        ) {
            return amount;
        }

        // max transfer limit
        if( txType == txTypeForMaxTxAmountLimit || txTypeForMaxTxAmountLimit == keccak256(abi.encodePacked("TX_ALL")) ){

            // if max transfer limit is set, if the amount to process exceeds the limit per transfer
            if( isMaxTxAmountLimitEnabled && !excludedFromMaxTxAmountLimit[sender]){

                uint256 _maxTxAmountLimit = _getMaxTxAmountLimit();

                // amount should be less than _maxTxAmountLimit
                require(amount < _maxTxAmountLimit, string(abi.encodePacked("PBULL: AMOUNT_EXCEEDS_TRANSFER_LIMIT"," ", bytes32(_maxTxAmountLimit) )) );
            } // end if max transfer limit is set

        } // end if txType is not sell

        // we shuld throttle all except buys order
        if( txType != swapEngine.TX_BUY() ) {

            // lets check if the account's address has been thorttled
            StructsDef.AccountThrottleInfo storage throttledAccountInfo = throttledAccounts[sender];

            // if the tx is actually throttled
            if(throttledAccountInfo.timeIntervalPerTx > 0) {

                // if the lastTxTime is 0, means its the first tx no need to check
                if(throttledAccountInfo.lastTxTime > 0) {

                    uint256 lastTxDuration = (block.timestamp - throttledAccountInfo.lastTxTime);

                    // lets now check the last tx time is less than the
                    if(lastTxDuration  < throttledAccountInfo.timeIntervalPerTx ) {
                        uint256 nextTxTimeInSecs = (throttledAccountInfo.timeIntervalPerTx.sub(lastTxDuration)).div(1000);
                        revert( string(abi.encodePacked("PBULL:","ACCOUNT_THROTTLED_SEND_AFTER_", nextTxTimeInSecs ,"_SECS")) );
                    } //end if
                } //end if we have last tx

                //lets check the txAmountLimitPercent limit
                if(throttledAccountInfo.txAmountLimitPercent > 0){

                    // we shouldnt match against total supply, but his or her balance
                    uint256 _throttledTxAmountLimit = percentToAmount(throttledAccountInfo.txAmountLimitPercent, balanceOf(sender));

                    if(amount > _throttledTxAmountLimit) {
                        revert( string(abi.encodePacked("PBULL:","ACCOUNT_THROTTLED_AMOUNT_EXCEEDS_", _throttledTxAmountLimit)) );
                    }

                } //end amount limit

                // update last tx time
                throttledAccounts[sender].lastTxTime = block.timestamp;
            } //end if tx is throttled

        } //end if its not buy tx

        // if sender is excluded from fees
        if( excludedFromFees[sender] || // if sender is excluded from fee
            excludedFromFees[recipient] ||  // or recipient is excluded from fee
            excludedFromFees[msg.sender] // if the sender sending n behalf of the user is excluded from fee, dont take, this is used to whitelist dapp contracts
        ){
            return amount;
        }

        uint256 totalTxFee = getTotalFee();

        /// lets check if user has extra tax
        uint256 accountExtraTax = perAccountExtraTax[sender];

        if(accountExtraTax > 0) {
           totalTxFee = totalTxFee.add(accountExtraTax);
        }

        if(txType != swapEngine.TX_SELL()  && sellTaxFee > 0) {
            totalTxFee = totalTxFee.sub(sellTaxFee);
        }

        //lets get totalTax to deduct
        uint256 totalFeeAmount =  percentToAmount(totalTxFee, amount);

        //lets take the fee to system account
        internalTransfer(sender, _tokenAddress, totalFeeAmount, "TOTAL_FEE_AMOUNT_TRANSFER_ERROR", false);

        // take the fee amount from the amount
        uint256 amountMinusFee = amount.sub(totalFeeAmount);

        //process burn , here, the burn is not immediately carried out
        // we provide a strategy to handle the burn from time to time
        if(isAutoBurnEnabled && autoBurnFee > 0) {
            autoBurnPool = autoBurnPool.add(percentToAmount(autoBurnFee, amount) );
        } //end process burn

        //compute amount for liquidity providers fund
        if(isLiquidityProvidersIncentiveEnabled && liquidityProvidersIncentiveFee > 0) {

            //lets burn this as we will auto mint lp rewards for the staking pools
            uint256 lpFeeAmount = percentToAmount( liquidityProvidersIncentiveFee, amount);

            autoBurnPool = autoBurnPool.add(lpFeeAmount);
        } //end if

        //lets do some burn now
        if(minAmountBeforeAutoBurn > 0 && autoBurnPool >= minAmountBeforeAutoBurn) {

            uint256 amountToBurn = autoBurnPool;

            _burn(_tokenAddress, amountToBurn);

            //this part is updated in _burn function
            /*if(autoBurnPool > amountToBurn){
                autoBurnPool = autoBurnPool.sub(amountToBurn);
            } else {
                autoBurnPool = 0;
            }*/

            //totalTokenBurns = totalTokenBurns.add(amountToBurn);
        } //end auto burn

        /////////////////////// START BUY BACK ////////////////////////

        // check and sell tokens for bnb
        if(isBuyBackEnabled && buyBackFee > 0){
            // handle buy back
            handleBuyBack( sender, amount, txType );
        }//end if buyback is enabled

         //////////////////////////// START AUTO LIQUIDITY ////////////////////////
        if(isAutoLiquidityEnabled && autoLiquidityFee > 0){

           // lets set auto liquidity funds
           autoLiquidityPool =  autoLiquidityPool.add( percentToAmount(autoLiquidityFee, amount) );

            //if tx is transfer only, lets do the sell or buy
            if(txType == swapEngine.TX_TRANSFER()) {

                //take snapshot
                uint256 amountToLiquidify = autoLiquidityPool;

                if(amountToLiquidify >= minAmountBeforeAutoLiquidity){

                    //lets swap and provide liquidity
                    swapAndLiquidify(amountToLiquidify);

                    if(autoLiquidityPool > amountToLiquidify) {
                        //lets substract the amount token for liquidity from pool
                        autoLiquidityPool = autoLiquidityPool.sub(amountToLiquidify);
                    } else {
                        autoLiquidityPool = 0;
                    }

                } //end if amounToLiquidify >= minAmountBeforeAutoLiuqidity

            } //end if sender is not uniswap pair

        }//end if auto liquidity is enabled

        uint256 sellTaxAmountSplit;

        // so here lets check if its sell, lets get the sell tax amount
        // burn half and add half to
        if( txType == swapEngine.TX_SELL()  && isSellTaxEnabled && sellTaxFee > 0 ) {

            uint256 sellTaxAmount = percentToAmount(sellTaxFee, amount);

            sellTaxAmountSplit = sellTaxAmount.div(3);

            // lets add to be burned
            autoBurnPool = autoBurnPool.add( sellTaxAmountSplit );

            // lets add to buyback pool
            buyBackTokenPool = buyBackTokenPool.add(sellTaxAmountSplit);
        }

          //compute amount for liquidity providers fund
        if(isHoldlersRewardEnabled && holdlersRewardFee > 0) {

            uint256 holdlersRewardAmount = percentToAmount(holdlersRewardFee, amount);

            // lets add half of the sell tax amount to reward pool
            holdlersRewardAmount  =  holdlersRewardAmount.add(sellTaxAmountSplit);

            //percentageOfRewardToReservedPool

            //if the holdlers rewards reserved pool is below what we want
            // assign all the rewards to the reserve pool, the reserved pool is used for
            // auto adjusting the rewards so that users wont get a decrease in rewards
            if( holdlersRewardReservedPool == 0 ||
                (holdlersRewardMainPool > 0 && getPercentageDiffBetweenReservedAndMainHoldersRewardsPools() <= minPercentageOfholdlersRewardReservedPoolToMainPool)
             ){
                holdlersRewardReservedPool = holdlersRewardReservedPool.add(holdlersRewardAmount);

            } else {

                // lets calculate the share of rewards for the the reserve pool
                uint256 reservedPoolRewardShare = percentToAmount(percentageShareOfHoldlersRewardsForReservedPool, holdlersRewardAmount);

                holdlersRewardReservedPool = holdlersRewardReservedPool.add(reservedPoolRewardShare);

                // set the main pool reward
                holdlersRewardMainPool  = holdlersRewardMainPool.add(holdlersRewardAmount.sub(reservedPoolRewardShare));

            } //end if

            totalRewardsTaken = totalRewardsTaken.add(holdlersRewardAmount);

        } //end if

        return amountMinusFee;
    } //end preprocess

    ////////////////  HandleBuyBack /////////////////
    function handleBuyBack(address sender, uint256 amount, bytes32 _txType) private {

        ////////////////////// DEDUCT THE BUYBACK FEE ///////////////

        uint256 buyBackTokenAmount = percentToAmount( buyBackFee, amount );

        buyBackTokenPool = buyBackTokenPool.add(buyBackTokenAmount);

        // if we have less ether, then sell token to buy more ethers
        if( buyBackETHPool <= minAmountBeforeSellingETHForBuyBack ){
            if( buyBackTokenPool >= minAmountBeforeSellingTokenForBuyBack && _txType == swapEngine.TX_TRANSFER() ) {

                //console.log("in BuyBack Token Sell Zone ===>>>>>>>>>>>>>>>>> ");

                uint256 buyBackTokenSwapAmount = buyBackTokenPool;

                uint256 returnedETHValue = __swapTokenForETH(buyBackTokenSwapAmount);

                buyBackETHPool = buyBackETHPool.add(returnedETHValue);

                if(buyBackTokenPool >= buyBackTokenSwapAmount){
                    buyBackTokenPool = buyBackTokenPool.sub(buyBackTokenSwapAmount);
                } else {
                    buyBackTokenPool = 0;
                }

            } ///end if
        } //end i

        // lets work on the buyback
        // here lets get the amount of bnb to be used for buy back sender != uniswapPair
        if( buyBackETHPool > minAmountBeforeSellingETHForBuyBack  && _txType == swapEngine.TX_TRANSFER() ) {

            //console.log("BuyBackZone Entered ===>>>>>>>>>>>>>>>>> Hurrayyyyyyyyy");
            // use half of minAmountBeforeSellingETHForBuyBack to buy back
            uint256 amountToSellETH = minAmountBeforeSellingETHForBuyBack.div(2);

            // the buyBackETHAmountSplitDivisor
            uint256 amountToBuyBackAndBurn = amountToSellETH.div( buyBackETHAmountSplitDivisor );

            //console.log("amountToSellETH ===>>>>>>>>>>>>>>>>> ", amountToSellETH);
            //console.log("amountToBuyBack ===>>>>>>>>>>>>>>>>> ", amountToBuyBackAndBurn);

            if(buyBackETHPool > amountToSellETH) {
                buyBackETHPool = buyBackETHPool.sub(amountToSellETH);
            } else {
                amountToSellETH = 0;
            }

            //lets buy bnb and burn
            uint256 totalTokensFromBuyBack = __swapETHForToken(amountToBuyBackAndBurn);

            //console.log("totalTokensFromBuyBack ===>>>>>>>>>>>>>>>>> ", totalTokensFromBuyBack);

            // lets add the tokens to burn
            autoBurnPool = autoBurnPool.add(totalTokensFromBuyBack);

            totalBuyBacksAmountInTokens = totalBuyBacksAmountInTokens.add(totalTokensFromBuyBack);

            totalBuyBacksAmountInETH    = totalBuyBacksAmountInETH.add(amountToBuyBackAndBurn);
        }

    } //end handle

    /**
    * @dev update holdlers account info, this info will be used for processing
    * @param sender    the sendin account address
    * @param recipient the receiving account address
    */
    function updateHoldlersInfo(address sender, address recipient) private {

        //v2 we will use firstDepositTime, if the first time, lets set the initial deposit
        if(holdlersInfo[recipient].initialDepositTimestamp == 0){
            holdlersInfo[recipient].initialDepositTimestamp = block.timestamp;
        }

        // increment deposit count lol
        holdlersInfo[recipient].depositCount = holdlersInfo[recipient].depositCount.add(1);

        //if sender has no more tokens, lets remove his or data
        if(_balances[sender] == 0) {
            //user is no more holdling so we remove it
            delete holdlersInfo[sender];
        }//end if

    } //end process holdlEffect

    /**
     *  @dev release the acount rewards, this is called before transfer starts so that user will get the required amount to complete transfer
     *  @param _account the account to release the results to
     */
    function releaseAccountReward(address _account) private returns(bool) {

        //lets release sender's reward
        uint256 reward = getReward(_account);

        //dont bother processing if balance is 0
        if(reward == 0 || reward > holdlersRewardMainPool){
            return false;
        }

        //lets deduct from our reward pool

        // now lets check if our reserve pool can cover that
        if(holdlersRewardReservedPool >= reward) {

            // if the reward pool can cover that, deduct it from reserve
            holdlersRewardReservedPool = holdlersRewardReservedPool.sub(reward);

        } else {

            // at this point, our reserve pool is down, so we deduct it from main pool
            holdlersRewardMainPool = holdlersRewardMainPool.sub(reward);

        }

        // credit user the reward
        _balances[_account] = _balances[_account].add(reward);

        //lets get account info
        holdlersInfo[_account].totalRewardReleased =  holdlersInfo[_account].totalRewardReleased.add(reward);

        emit ReleaseAccountReward(_account, reward);

        return true;
    } //end function

    /**
     * internally transfer amount between two accounts
     * @param _from the sender of the amount
     * @param _to  the recipient of the amount
     * @param emitEvent wether to emit an event on succss or not
     */
    function internalTransfer(address _from, address _to, uint256 _amount, string memory errMsg, bool emitEvent) private {

        //set from balance
        _balances[_from] = _balances[_from].sub(_amount, string(abi.encodePacked("PBULL::INTERNAL_TRANSFER_SUB: ", errMsg)));

        //set _to Balance
        _balances[_to] = _balances[_to].add(_amount);

        if(emitEvent){
            emit Transfer(_from, _to, _amount);
        }
    } //end internal transfer

    /**
     * @dev convert percentage value in Basis Point System to amount or token value
     * @param _percentInBps the percentage calue in basis point system
     * @param _amount the amount to be used for calculation
     * @return final value after calculation in uint256
     */
     function percentToAmount(uint256 _percentInBps, uint256 _amount) private pure returns(uint256) {
        //to get pbs,multiply percentage by 100
        return  (_amount.mul(_percentInBps)).div(10_000);
     }

    /**
     * @dev get max Tx Amount limit
     * @return uint256  processed amount
     */
    function _getMaxTxAmountLimit() public view returns(uint256) {
        return percentToAmount(maxTxAmountLimitPercent, totalSupply());
    } //end fun

    /**
     * @dev getPercentageOfReservedToMainRewardPool
     * @return uint256
     */
     function getPercentageDiffBetweenReservedAndMainHoldersRewardsPools() private view returns(uint256) {

        uint256 resultInPercent = ( holdlersRewardReservedPool.mul(100) ).div(holdlersRewardMainPool);

        // lets multiply by 100 to get the value in basis point system
        return (resultInPercent.mul(100));
     }

} //end contract