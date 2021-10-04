// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "library.sol";

/**
 * @title Implementation of the {IERC20} interface.
 * @dev defines a dynamically generated ERC20-compliant option contract with given expiry date
 */
contract Option is Context, IOption {
    using SafeMath for uint256;

    /// @dev RoundData always kept for each round
    struct RoundData {
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowances;
        uint256 totalSupply;
        uint expiryDate;
        uint settlePrice; // settle price of this round, and is the strike price for next round.
        
        uint totalPremiums; // total premium in this round
        uint accPremiumShare; // accumulated premium share for a pooler
    }
    
    /// @dev added extra round index to all mapping
    mapping (uint => RoundData) private rounds;

    /// @dev buyer's latest unsettled round
    mapping (address => uint) private unclaimedProfitsRounds;
    
    /// @dev mark pooler's highest settled round for a pooler.
    mapping (address => uint) private settledRounds;
    
    uint private currentRound; // a monotonic increasing round

    uint8 private _decimals;

    /// @dev option related variables;
    uint private _duration; // the duration of this option, cannot be changed

    IOptionPool immutable private _pool; // pool contract address

    modifier onlyPool() {
        require(msg.sender == address(_pool), "Option: access restricted to owner");
        _;
    }

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (uint duration_, uint8 decimals_, IOptionPool poolContract) public {
        _decimals = decimals_;

        // option settings
        _duration = duration_; // set duration once
        _pool = poolContract;
    }

    /*
     * @dev only can reset this option if expiryDate has reached
     */
    function resetOption(uint strikePrice_, uint newSupply) external override onlyPool {
        // create a memory copy of round;
        uint r = currentRound;
        // record settle price
        rounds[r].settlePrice = strikePrice_;
        
        // round changing for each resetting
        r++;
        
        // setting new round parameters
        rounds[r].expiryDate = block.timestamp + _duration;
        rounds[r].totalSupply = newSupply;
        rounds[r].balances[address(_pool)] = newSupply;

        // set back r to round
        currentRound = r;
    }

    /**
     * @dev get total supply from round r
     */
    function getRoundTotalSupply(uint r) external override view returns(uint256) {
        return rounds[r].totalSupply;
    }
    
    /**
     * @dev get expiry date from round r
     */
    function getRoundExpiryDate(uint r) external override view returns(uint) {
        return rounds[r].expiryDate;
    }
    
    /**
     * @dev get strike price from round r
     */
    function getRoundStrikePrice(uint r) external override view returns(uint) {
        // @dev assume uint(-1) or 0xfff...fff(256bit) is also 0
        return rounds[r-1].settlePrice;
    }
    
    /**
     * @dev get settle price from round r
     */
    function getRoundSettlePrice(uint r) external override view returns(uint) {
        return rounds[r].settlePrice;
    }

    /**
     * @dev get total premiums from round r
     */
    function getRoundTotalPremiums(uint r) external override view returns(uint) {
        return rounds[r].totalPremiums;
    }
    
    /**
     * @dev get balance from round r
     */
    function getRoundBalanceOf(uint r, address account) external override view returns (uint256) {
        return rounds[r].balances[account];
    }
    
    /**
     * @dev get round premium share
     */
    function getRoundAccPremiumShare(uint r) external view override returns(uint) {
        return rounds[r].accPremiumShare;
    }
    
    /**
     * @dev set round premium share
     */
    function setRoundAccPremiumShare(uint r, uint accPremiumShare) external override onlyPool {
        rounds[r].accPremiumShare = accPremiumShare;
    }

    /**
     * @dev get all unclaimed profits rounds for account
     */
    function getUnclaimedProfitsRound(address account) external override view returns (uint) {
        return unclaimedProfitsRounds[account];
    }

    /**
     * @dev set unclaimed profits round for account
     */
    function setUnclaimedProfitsRound(uint r, address account) external override onlyPool {
        unclaimedProfitsRounds[account] = r;
    }
    
    /**
     * @dev get highest settled round for a pooler
     */
    function getSettledRound(address account) external override view returns (uint) {
        return settledRounds[account];
    }

    /**
     * @dev set highest settled round for a pooler
     */
    function setSettledRound(uint r, address account) external override onlyPool {
        settledRounds[account] = r;
    }
    
    /**
     * @dev add premium fee to current round in USDT
     */
    function addPremium(uint256 amountUSDT) external override onlyPool {
        rounds[currentRound].totalPremiums += amountUSDT;
    }
    
    /**
     * @dev total premium fee in current round.
     */
    function totalPremiums() external override view returns (uint) {
        return rounds[currentRound].totalPremiums;
    }
    
   /**
     * @dev add premium fee in USDT
     */
    function getRound() external override view returns (uint) {
        return currentRound;
    }
    
    /**
     * @dev returns expiry date for current round
     */
    function expiryDate() external override view returns (uint) {
        return rounds[currentRound].expiryDate;
    }
    
    /**
     * @dev returns strike price for current round
     */
    function strikePrice() external override view returns (uint) {
        // @dev assume uint(-1) or 0xfff...fff(256bit) is also 0
        return rounds[currentRound-1].settlePrice;
    }
    
    /**
     * @dev Returns the name of the token.
     */
    function name() public view override returns (string memory) {
        return string(abi.encodePacked(_pool.name(), "-", Strings.toString(_duration)));
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return name();
    }

    /**
     * @dev Returns the pool of the contract.
     */
    function getPool() public view override returns (address) {
        return address(_pool);
    }

    /**
     * @dev Returns the duration of the contract.
     */
    function getDuration() public view override returns (uint) {
        return _duration;
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
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return rounds[currentRound].totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return rounds[currentRound].balances[account];
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
        return rounds[currentRound].allowances[owner][spender];
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
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), rounds[currentRound].allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
        _approve(_msgSender(), spender, rounds[currentRound].allowances[_msgSender()][spender].add(addedValue));
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
        _approve(_msgSender(), spender, rounds[currentRound].allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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

        rounds[currentRound].balances[sender] = rounds[currentRound].balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        rounds[currentRound].balances[recipient] = rounds[currentRound].balances[recipient].add(amount);

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

        rounds[currentRound].totalSupply = rounds[currentRound].totalSupply.add(amount);
        rounds[currentRound].balances[account] = rounds[currentRound].balances[account].add(amount);
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

        rounds[currentRound].totalSupply = rounds[currentRound].totalSupply.sub(amount);
        rounds[currentRound].balances[account] = rounds[currentRound].balances[account].sub(amount, "ERC20: burn amount exceeds balance");
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
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        rounds[currentRound].allowances[owner][spender] = amount;
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
    function _beforeTokenTransfer(address from, address to, uint256) internal {
        require(block.timestamp < rounds[currentRound].expiryDate, "option expired");

        // settle buyers' profits, omit settlement if it's _pool address.
        if (from != address(0) && from != address(_pool)) {
            _pool.settleBuyer(from);
        }
        
        if (to != address(0) && to != address(_pool)) {
            _pool.settleBuyer(to);
        }
    }
}
