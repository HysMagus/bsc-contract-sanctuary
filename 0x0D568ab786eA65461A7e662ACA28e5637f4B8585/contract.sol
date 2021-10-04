// SPDX-License-Identifier: MIT
/**
 *Submitted for verification at BscScan.com on 2021-03-08
 * Website : https://minipi.app
 * email   : support@minipi.app
 * Telegram: https://t.me/minipi
 * twitter : https://twitter.com/
 */

pragma solidity ^0.7.4;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Pausable is Ownable {
    event Pause();
    event Unpause();

    bool public paused = false;

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpause();
    }
}

abstract contract ERC20Basic {
    uint256 public totalSupply;

    function balanceOf(address who) public view virtual returns (uint256);
    function transfer(address to, uint256 value) public virtual returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

abstract contract ERC20 is ERC20Basic {

    function allowance(address owner, address spender)
        public
        view
        virtual
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual returns (bool);

    function approve(address spender, uint256 value)
        public
        virtual
        returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    
}

abstract contract StandardToken is ERC20 {
    using SafeMath for uint256;

    mapping(address => mapping(address => uint256)) internal allowed;
    mapping(address => bool) tokenBlacklist;
    event Blacklist(address indexed blackListed, bool value);

    mapping(address => uint256) balances;

    function transfer(address _to, uint256 _value)
        public
        virtual
        override
        returns (bool)
    {
        require(tokenBlacklist[msg.sender] == false);
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[_owner];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual override returns (bool) {
        require(tokenBlacklist[msg.sender] == false);
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        virtual
        override
        returns (bool)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    function increaseApproval(address _spender, uint256 _addedValue)
        public
        virtual
        returns (bool)
    {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(
            _addedValue
        );
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint256 _subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function _blackList(address _address, bool _isBlackListed)
        internal
        returns (bool)
    {
        require(tokenBlacklist[_address] != _isBlackListed);
        tokenBlacklist[_address] = _isBlackListed;
        emit Blacklist(_address, _isBlackListed);
        return true;
    }

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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
        require(account != address(0), "ERC20: mint to the zero address");
        totalSupply = totalSupply.add(amount);
        balances[account] = balances[account].add(amount);
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
    function _burn(address account, uint256 amount) virtual internal {
        require(account != address(0), "ERC20: burn from the zero address");
        balances[account] = balances[account].sub(amount);
        totalSupply = totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
}
/*
**
 * @dev Extension of {BEP20} that implements a basic BEP20 staking
 * with incentive distribution.
 */
contract BEP20Stakes is StandardToken {
    using SafeMath for uint256;

    // TODO change to real
    uint256 private _holdPeriod; // = 2 minutes; 
    uint256 private _dailyPercent; // = 1; // 1%
    uint256 private _basePeriod; // = 30 seconds
    uint256 private _dailyPeriod; // =  // 1 day

    event StakeCreate(address indexed stakeholder, uint256 stake);
    event StakeHold(address indexed stakeholder);
    event StakeWithdraw(address indexed stakeholder, uint256 reward);

    struct Stake {
        uint256 amount;
        uint256 stakedAt;
        uint256 heldAt;
    }
    
   
    /**
     * @dev stakeholders list
     */
    address[] private _stakeholders;

    /**
     * @dev the stakes for each stakeholder.
     */
    mapping(address => Stake) private _stakes;

    modifier onlyStakeExists(address stakeholder) {
        require(_stakes[stakeholder].amount > 0, "Stake: no stake yet");
        require(_stakes[stakeholder].heldAt == 0, "Stake: stake canceled");
        require(_stakes[stakeholder].stakedAt < block.timestamp, "Stake: stake just created");
        _;
    }

    modifier onlyNoStakeYet(address stakeholder) {
        require(_stakes[stakeholder].amount == 0, "Stake: stake exists");
        _;
    }

    modifier onlyStakeUnheld(address stakeholder) {
        require(_stakes[stakeholder].heldAt > _stakes[stakeholder].stakedAt, "Stake: stake not exists or not canceled");
        require(_stakes[stakeholder].heldAt + _holdPeriod <= block.timestamp, "Stake: stake on hold");
        _;
    }

    function initialize(uint256 basePeriod, uint256 holdPeriod, uint256 annualPercent, uint256 annualPeriod) public  {
        _stakeParams(basePeriod, holdPeriod, annualPercent, annualPeriod);
    }


    function _stakeParams(uint256 basePeriod, uint256 holdPeriod, uint256 dailyPercent, uint256 dailyPeriod) internal {
        _holdPeriod = holdPeriod;
        _dailyPercent = dailyPercent;
        _basePeriod = basePeriod;
        _dailyPeriod = dailyPeriod.mul(100);
    }

    function stakeBasePeriod() external view returns (uint256) {
        return _basePeriod;
    }
    function stakeHoldPeriod() external view returns (uint256) {
        return _holdPeriod;
    }
    function stakeAnnualPercent() external view returns (uint256) {
        return _dailyPercent;
    }
    function stakeDailyPeriod() external view returns (uint256) {
        return _dailyPeriod / 100;
    }

    /**
   * @dev A method for a stakeholder to create a stake
   */
    function createStake(uint256 stake) external {
        _createStake(_msgSender(), stake);
    }

    /**
     * @dev A method for a stakeholder to remove a stake
     */
    function cancelStake() external {
        _holdStake(_msgSender());
    }

    /**
    * @dev A method to allow a stakeholder to withdraw his rewards.
    */
    function withdrawStake() external {
        _removeStake(_msgSender());
    }

    /**
     * @dev internal method for a stakeholder to create a stake.
     * @param stakeholder Stakeholder address
     * @param stake The size of the stake to be created.
     */
    function _createStake(address stakeholder, uint256 stake) internal onlyNoStakeYet(stakeholder) {
        _burn(stakeholder, stake);
        _stakes[stakeholder] = Stake({
            amount : stake,
            stakedAt : block.timestamp,
            heldAt : 0
            });
        _addStakeholder(stakeholder);
        emit StakeCreate(stakeholder,  stake);

    }

    /**
     * @dev internal method for a stakeholder to hold a stake.
     * @param stakeholder Stakeholder address
     */
    function _holdStake(address stakeholder) internal onlyStakeExists(stakeholder) {
        _stakes[stakeholder].heldAt = block.timestamp;
        emit StakeHold(stakeholder);
    }

    /**
     * @dev internal method for a stakeholder to remove a stake.
     * @param stakeholder Stakeholder address
     */
    function _removeStake(address stakeholder) internal onlyStakeUnheld(stakeholder) {
        uint256 reward = _reward(stakeholder, _stakes[stakeholder].heldAt);
        uint256 stake = _stakes[stakeholder].amount;
        delete _stakes[stakeholder];
        _removeStakeholder(stakeholder);
        _mint(stakeholder, stake.add(reward));
        emit StakeWithdraw(stakeholder, reward);
    }

    /**
     * @dev A method to retrieve the stake for a stakeholder.
     * @param stakeholder The stakeholder to retrieve the stake for.
     * @return uint256 The amount of wei staked.
     */
    function stakeOf(address stakeholder) public view returns (uint256){
        return _stakes[stakeholder].amount;
    }

    function stakeDetails(address stakeholder) public view returns (uint256, uint256){
        return (_stakes[stakeholder].stakedAt, _stakes[stakeholder].heldAt);
    }

    function rewardOf(address stakeholder) public view returns(uint256) {
        if (_stakes[stakeholder].stakedAt == 0) return 0;
        return _reward(stakeholder, _stakes[stakeholder].heldAt == 0 ? block.timestamp : _stakes[stakeholder].heldAt);
    }

    function _reward(address stakeholder, uint rewardedAt) internal view returns(uint256) {
        // total stake period in days
        uint256 period = ((rewardedAt - _stakes[stakeholder].stakedAt) / _basePeriod) * _basePeriod;
        // reward for period according to daily percent value
        return _stakes[stakeholder].amount.mul(period).mul(_dailyPercent) / _dailyPeriod;
    }

    /**
     * @dev A method to the aggregated stakes from all stakeholders.
     * @return uint256 The aggregated stakes from all stakeholders.
     */
    function totalStakes() public view returns (uint256) {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < _stakeholders.length; s++) {
            _totalStakes = _totalStakes.add(_stakes[_stakeholders[s]].amount);
        }
        return _totalStakes;
    }

    /**
     * @dev A method to check if an address is a stakeholder.
     * @param stakeholder The address to verify.
     * @return bool, uint256 Whether the address is a stakeholder,
     * and if so its position in the stakeholders array.
     */
    function isStakeholder(address stakeholder) public view returns (bool, uint256) {
        for (uint256 s = 0; s < _stakeholders.length; s++) {
            if (stakeholder == _stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    /**
     * @dev A method to add a stakeholder.
     * @param stakeholder The stakeholder to add.
     */
    function _addStakeholder(address stakeholder) internal {
        (bool _isStakeholder,) = isStakeholder(stakeholder);
        if (!_isStakeholder) _stakeholders.push(stakeholder);
    }

    /**
     * @dev A method to remove a stakeholder.
     * @param stakeholder The stakeholder to remove.
     */
    function _removeStakeholder(address stakeholder) internal {
        (bool _isStakeholder, uint256 s) = isStakeholder(stakeholder);
        if (_isStakeholder) {
            _stakeholders[s] = _stakeholders[_stakeholders.length - 1];
            _stakeholders.pop();
        }
    }

    uint256[50] private ______gap;
}

abstract contract PausableToken is BEP20Stakes, Pausable {
    function transfer(address _to, uint256 _value)
        public
        override
        whenNotPaused
        returns (bool)
    {
        return super.transfer(_to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override whenNotPaused returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value)
        public
        override
        whenNotPaused
        returns (bool)
    {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint256 _addedValue)
        public
        override
        whenNotPaused
        returns (bool success)
    {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint256 _subtractedValue)
        public
        override
        whenNotPaused
        returns (bool success)
    {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function blackListAddress(address listAddress, bool isBlackListed)
        public
        whenNotPaused
        onlyOwner
        returns (bool success)
    {
        return super._blackList(listAddress, isBlackListed);
    }
}

contract CoinToken is PausableToken {
    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint256 public decimals;
    event Mint(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _supply,
        address tokenOwner
    ) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _supply * 10**_decimals;
        balances[tokenOwner] = totalSupply;
        owner = tokenOwner;
        emit Transfer(address(0), tokenOwner, totalSupply);
    }

    function burn(uint256 _value) public {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) override internal {
        require(_value <= balances[_who]);
        balances[_who] = balances[_who].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        totalSupply = totalSupply.add(amount);
        balances[account] = balances[account].add(amount);
        emit Mint(address(0), account, amount);
        emit Transfer(address(0), account, amount);
    }
}

contract MiniPi is CoinToken("MiniPi","MINI",18,300000000,0xA3839AE087C645D7Dd8D5c2A077974C3B12cbbEa) {

}