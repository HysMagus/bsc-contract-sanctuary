/**
 *Submitted for verification at BscScan.com on 2021-03-02
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

/**
 * More coming to the ecosystem soon, keep an eye out for announcements on the website & telegram
 */

/**
 * @dev Interface of the BOG20 standard
 */
interface IBOG20 {
    function quickRundown(address account) external view returns (uint256);
    function heBought(address account, uint256 amount) external;
    function heSold(address account, uint256 amount) external;
    function fundsAreSafu() external pure returns (bool);
}

/**
 * Standard SafeMath, stripped down to just add/sub/mul/div
 */
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

/**
 * BEP20 standard interface.
 */
interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * Implement the basic BEP20 functions
 */
abstract contract BEP20 is IBEP20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 internal _totalSupply = 0;
    
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals = 18;

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function name() public view override returns (string memory) {
        return _name;
    }
    
    function symbol() public view override returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
}


/**
 * Store contract creation block & timestamp. 
 * Useful for APY calculations
 */
abstract contract RecordsCreation {
    uint256 public creationBlock;
    uint256 public creationTimestamp;
    
    constructor(){
        creationBlock = block.number;
        creationTimestamp = block.timestamp;
    }
}

/**
 * Provides ownable context 
 */
abstract contract Ownable {
    constructor() { _owner = msg.sender; }
    address payable _owner;
    
    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == _owner;
    }
    
    /**
     * Function modifier to require caller to be contract owner
     */
    modifier owned() {
        require(isOwner(msg.sender)); _;
    }
    
    /**
     * Transfer ownership to the zero address. Caller must be owner.
     */
    function renounceOwnership() public owned() {
        transferOwnership(address(0));
    }
    
    /**
     * Transfer ownership to new address. Caller must be owner.
     */
    function transferOwnership(address payable adr) public owned() {
        _owner = adr;
    }
}


/**
 * Bogdabot interface for accepting transfer hooks
 */
interface IBogdabot {
    function txHook(address caller, address sender, address receiver, uint256 amount) external;
}

/* > Ancient Usenet scriptures tell of two angels who will descend upon Pancakeswap and will bring an era of green candles and unprecedented pumps with them */
/* > First designer babies will in all likelihood be Bogdanoff babies */
/* > Used in token generators around the world */

/**
 * Allow external contracts (Bogdabots) to hook into BOG transactions
 */
abstract contract BogdabotController is Ownable {
    struct BogdabotInfo {
        bool bot;
        uint256 adrIndex;
    }
    
    mapping (address => BogdabotInfo) _botsInfo;
    address[] _bogdabots;
    uint256 _bogdabotsCount;
    
    /**
     * Returns array of bogdabots
     */
    function getBots() public view returns (address[] memory) {
        return _bogdabots;
    }
    
    /**
     * Returns bogdabot count
     */
    function getBotCount() public view returns (uint256) {
        return _bogdabotsCount;
    }
    
    /**
     * Check if address is registered as bogdabot
     */
    function isBot(address account) public view returns (bool) {
        return _botsInfo[account].bot;
    }
    
    /**
     * Add contract to list
     */
    function addBogdabot(address bot) external owned {
        require(isContract(bot));
        _botsInfo[bot].bot = true;
        _botsInfo[bot].adrIndex = _bogdabots.length;
        _bogdabots.push(bot);
        _bogdabotsCount++;
    }
    
    /**
     * Remove bot from list
     */
    function removeBogdabot(address bot) external owned {
        require(isBot(bot));
        _botsInfo[bot].bot = false;
        _bogdabotsCount--; 
        
        uint256 i = _botsInfo[bot].adrIndex; // gas savings
        
        // swap in removed bot with last holder and then pop from end
        _bogdabots[i] = _bogdabots[_bogdabots.length-1];
        _botsInfo[_bogdabots[i]].adrIndex = i;
        _bogdabots.pop();
    }
    
    /**
     * Call all bogdabot hooks
     */
    function bogdabotTxHook(address sender, address receiver, uint256 amount) internal {
        if(getBotCount() == 0){ return; }
        for(uint256 i=0; i<_bogdabots.length; i++){ 
            /* 
             * Using try-catch ensures that any errors / fails in one of the bogdabot contracts will not cancel the overall transaction
             */
            try IBogdabot(_bogdabots[i]).txHook(msg.sender, sender, receiver, amount) {} catch {}
        }
    }
    
    /**
     * Check if address is contract.
     * Credit to OpenZeppelin
     */
    function isContract(address addr) internal view returns (bool) {
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    
        bytes32 codehash;
        assembly {
            codehash := extcodehash(addr)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

/**
 * Keeps a record of all holders.
 * Allows all holder data to be used on-chain by other contracts. ;)
 */
abstract contract TracksHolders is Ownable {
    
    /**
     * Struct for storing holdings data
     */
    struct Holding {
        bool holding; // whether address is currently holding
        uint256 adrIndex; // index of address in holders array
    }
    
    mapping (address => Holding) _holdings;
    address[] _holders;
    uint256 _holdersCount;
    
    /**
     * Returns array of holders
     */
    function getHolders() public view returns (address[] memory) {
        return _holders;
    }
    
    /**
     * Returns holders count
     */
    function getHoldersCount() public view returns (uint256) {
        return _holdersCount;
    }
    
    /**
     * Returns whether address is currently holder
     */
    function isHolder(address holder) public view returns (bool) {
        return _holdings[holder].holding;
    }
    
    /**
     * Add address to holders list
     */
    function addHolder(address account) internal {
        _holdings[account].holding = true;
        _holdings[account].adrIndex = _holders.length;
        _holders.push(account);
        _holdersCount++;
    }
    
    /**
     * Remove address from holders list
     */
    function removeHolder(address account) internal {
        _holdings[account].holding = false;
        
        // saves gas
        uint256 i = _holdings[account].adrIndex;
        
        // remove holder from array by swapping in end holder
        _holders[i] = _holders[_holders.length-1];
        _holders.pop();
        
        // update end holder index
        _holdings[_holders[i]].adrIndex = i;
        
        _holdersCount--;
    }
}


interface IBogDistributive {
    function getTotalStaked() external view returns (uint256);
    function getTotalFees() external view returns (uint256);
    
    function getStake(address staker) external view returns (uint256);
    function getEarnings(address staker) external view returns (uint256);
    
    function stake(uint256 amount) external;
    function unstake(uint256 amount) external;
    
    function getPairAddress() external view returns (address);
    function forceUnstakeAll() external;
    
    event Staked(address account, uint256 amount);
    event Unstaked(address account, uint256 amount);
    
    event FeesDistributed(address account, uint256 amount);
}


/**
 * This is where the fun happens :)
 */
abstract contract BogDistributive is IBogDistributive, BEP20, Ownable, TracksHolders {
    using SafeMath for uint256;
    
    IBEP20 _pair;
    bool _pairInitialized;
    
    /**
     * Struct for holding record of account stakes.
     */
    struct Stake {
        uint256 LP; // Amount of LP tokens staked
        uint256 excludedAmt; // Amount of staking rewards to exclude from returns (if claimed or staked after)
        uint256 realised; // realised rewards
    }
    
    mapping (address => Stake) _stakes;
    
    uint256 _totalLP;
    uint256 _totalFees;
    uint256 _totalRealised;
    
    /**
     * Total LP tokens staked
     */
    function getTotalStaked() external override view returns (uint256) {
        return _totalLP;
    }
    
    /**
     * Total amount of transaction fees reflected to stakers
     */
    function getTotalFees() external override view returns (uint256) {
        return _totalFees;
    }
    
    /**
     * Returns amount of LP that address has staked
     */
    function getStake(address account) public override view returns (uint256) {
        return _stakes[account].LP;
    }
    
    /**
     * Returns total earnings (realised + unrealised)
     */
    function getEarnings(address staker) external override view returns (uint256) {
        return _stakes[staker].realised.add(earnt(staker)); // realised gains plus outstanding earnings
    }
    
    /**
     * Returns unrealised earnings
     */
    function getUnrealisedEarnings(address staker) external view returns (uint256) {
        return earnt(staker);
    }
    
    /**
     * Stake LP tokens to earn a share of the 4% tx fee
     */
    function stake(uint256 amount) external override pairInitialized {
        _stake(msg.sender, amount);
    }
    
    /**
     * Unstake LP tokens
     */
    function unstake(uint256 amount) external override pairInitialized {
        _unstake(msg.sender, amount);
    }
    
    /**
     * Return Cake-LP pair address
     */
    function getPairAddress() external view override returns (address) {
        return address(_pair);
    }
    
    /**
     * Return stakes to all holders
     */
    function forceUnstakeAll() external override owned {
        for(uint256 i=0; i<_holders.length; i++){
            uint256 amt = getStake(_holders[i]); // saves gas
            if(amt > 0){ _unstake(_holders[i], amt); }
        }
    }
    
    /**
     * Add outstanding staking rewards to balance
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account].add(earnt(account));
    }
    
    /**
     * Convert unrealised staking gains into actual balance
     */
    function realise() public {
        _realise(msg.sender);
    }
    
    /**
     * Realises outstanding staking rewards into balance
     */
    function _realise(address account) internal {
        if(getStake(account) != 0){
            uint256 amount = earnt(account);
            _balances[account] = _balances[account].add(amount);
            _stakes[account].realised = _stakes[account].realised.add(amount);
            _totalRealised = _totalRealised.add(amount);
        }
        _stakes[account].excludedAmt = _totalFees;
    }
    
    /**
     * Calculate current outstanding staking gains
     */
    function earnt(address account) internal view returns (uint256) {
        if(_stakes[account].excludedAmt == _totalFees || _stakes[account].LP == 0){ return 0; }
        uint256 availableFees = _totalFees.sub(_stakes[account].excludedAmt);
        uint256 share = availableFees.mul(_stakes[account].LP).div(_totalLP); // won't overflow as even totalsupply^2 is less than uint256 max
        return share;
    }
    
    /**
     * Stake amount LP from account
     */
    function _stake(address account, uint256 amount) internal {
        _pair.transferFrom(account, address(this), amount); // transfer LP tokens from account
        
        // realise staking gains now (also works to set excluded amt to current total rewards)
        _realise(account); 
        
        // add to current address' stake
        _stakes[account].LP = _stakes[account].LP.add(amount);
        _totalLP = _totalLP.add(amount);
        
        // ensure staker is recorded as holder
        updateHoldersStaked(account);
        
        emit Staked(account, amount);
    }
    
    /**
     * Unstake amount for account
     */
    function _unstake(address account, uint256 amount) internal {
        require(_stakes[account].LP >= amount); // ensure sender has staked more than or equal to requested amount
        
        _realise(account); // realise staking gains
        
        // remove stake
        _stakes[account].LP = _stakes[account].LP.sub(amount);
        _totalLP = _totalLP.sub(amount);
        
        // send LP tokens back
        _pair.transfer(account, amount);
        
        // check if sender is no longer a holder
        updateHoldersUnstaked(account);
        
        emit Unstaked(account, amount);
    }
    
    /**
     * Distribute amount to stakers.
     */
    function distribute(uint256 amount) external {
        _realise(msg.sender);
        require(_balances[msg.sender] >= amount);
        
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _distribute(msg.sender, amount);
    }
    
    /**
     * Distribute amount from account as transaction fee
     */
    function _distribute(address account, uint256 amount) internal {
        _totalFees = _totalFees.add(amount);
        emit FeesDistributed(account, amount);
    }
    
    /**
     * Check if account is holding in context of transaction sender
     */
    function updateHoldersTransferSender(address account) internal {
        if(!isStillHolding(account)){ removeHolder(account); }
    }
    
    /**
     * Check if account is still holding in context of transaction recipient
     */
    function updateHoldersTransferRecipient(address account) internal {
        if(!isHolder(account)){ addHolder(account); }
    }
    
    /**
     * Check if account is holding in context of staking tokens
     */
    function updateHoldersStaked(address account) internal {
        if(!isHolder(account)){ addHolder(account); }
    }
    
    /**
     * Check if account is still holding in context of unstaking tokens
     */
    function updateHoldersUnstaked(address account) internal {
        if(!isStillHolding(account)){ removeHolder(account); }
    }
    
    /**
     * Check if account has a balance or a stake
     */
    function isStillHolding(address account) internal view returns (bool) {
        return balanceOf(account) > 0 || getStake(account) > 0;
    }
    
    /**
     * Require pair address to be set
     */
    modifier pairInitialized() { require(_pairInitialized); _; }
    
    /**
     * Set the pair address.
     * Don't allow changing whilst LP is staked (as this would prevent stakers getting their LP back)
     */
    function setPairAddress(address pair) external owned {
        require(_totalLP == 0, "Cannot change pair whilst there is LP staked");
        _pair = IBEP20(pair);
        _pairInitialized = true;
    }
}

/* > In contact with aliens */
/* > They own Nanobot R&D labs around the world */
/* > BOG governs exchanges & pools globally */

/**
 * This contract burns tokens on transactions
 */
abstract contract Burnable is BogDistributive {
    using SafeMath for uint256;
    
    uint256 _burnRate = 50; // 5.0% of tx's to  be split between burn/distribute
    uint256 _distributeRatio = 5; // 1:5 ratio of burn:distribute
    uint256 _totalBurnt;
    
    /**
     * Total amount of tokens burnt
     */
    function getTotalBurnt() external view returns (uint256) {
        return _totalBurnt;
    }
    
    /**
     * Current burn rate
     */
    function getBurnRate() public view returns (uint256) {
        return _burnRate;
    }
    
    /**
     * Current distribution ratio
     */
     function getDistributionRatio() public view returns (uint256) {
         return _distributeRatio;
     }
    
    /**
     * Change to a new burn rate
     */
    function setBurnRate(uint256 newRate) external owned {
        require(newRate < 100);
        _burnRate = newRate;
    }
    
    /**
     * Change the burn:stakers distribution ratio
     */
    function setDistributionRatio(uint256 newRatio) external owned {
        require(newRatio >= 1);
        _distributeRatio = newRatio;
    }
    
    /**
     * Burns transaction amount as per burn rate & returns remaining transfer amount. 
     */
    function _txBurn(address account, uint256 txAmount) internal returns (uint256) {
        uint256 toBurn = txAmount.mul(_burnRate).div(1000); // calculate amount to burn
        
        _distribute(account, toBurn.mul(_distributeRatio-1).div(_distributeRatio));
        _burn(account, toBurn.div(_distributeRatio));
        
        return txAmount.sub(toBurn); // return amount left after burn
    }
    
    /**
     * Burn amount tokens from sender
     */
    function burn(uint256 amount) public {
        require(_balances[msg.sender] >= amount);
        _burn(msg.sender, amount);
    }
    
    /**
     * Burns amount of tokens from account
     */
    function _burn(address account, uint256 amount) internal {
        if(amount == 0){ return; }
        
        _totalSupply = _totalSupply.sub(amount);
        _totalBurnt = _totalBurnt.add(amount);
        _balances[account] = _balances[account].sub(amount);
        
        emit Burn(account, amount);
    }
    
    event Burn(address account, uint256 amount);
}


/**
 * Implements high level functions
 */
abstract contract BOG20 is IBOG20, Burnable, BogdabotController {
    using SafeMath for uint256;
    
    uint32 _maxTxPercent = 50; // max size as % of supply as percentage to 1d.p, eg 50 = 5.0%
    bool _firstTx = true; // flag for first tx (as this will be to provide liquidity so don't want limit)
    
    /**
     * Mint tx sender with initial supply
     */
    constructor(uint256 supply) {
        uint256 amount = supply * (10 ** _decimals);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        _totalSupply = _totalSupply.add(amount);
        updateHoldersTransferRecipient(msg.sender); // ensure receiver is set as sender
        emit Transfer(address(0), msg.sender, amount);
    }
    
    /**
     * >Can I get a quick rundown?
     */
    function quickRundown(address account) external view override returns (uint256) {
        return balanceOf(account);    
    }
    
    /**
     * funds are safu?
     */
    function fundsAreSafu() external pure override returns (bool) {
        return true; // always ;)
    }
    
    /**
     * Return owner address as per BEP20 standard
     */
    function getOwner() external view override returns (address) {
        return _owner;
    }
    
    /**
     * Ensure tx size is within allowed % of supply
     */
    function checkTxAmount(uint256 amount) internal {
        if(_firstTx){ _firstTx = amount == 0 ? true : false; return; } // skip first tx as this will be providing 100% as liquidity
        require(amount <= _totalSupply.mul(_maxTxPercent).div(1000), "Tx size exceeds limit");
    }
    
    /**
     * Change the max tx size percent. Required to be from 1% to 100%
     */
    function setMaxTxPercent(uint32 amount) external owned {
        require(amount > 10 && amount < 1000, "Invalid max tx size"); // ensure > 1% & < 100%
        _maxTxPercent = amount;
    }
    
    /**
     * The transfer function. 
     * Normal transfer is also called through this and a sender==msg.sender check is used to determine whether to use allowance
     */
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(sender != address(0), "Can't transfer from zero");
        require(recipient != address(0), "Can't transfer to zero");
        
        // ensure tx size is below limit
        checkTxAmount(amount); 
        
        // realise staked gains & then check if enough balance to cover
        _realise(sender);
        require(_balances[sender] >= amount, "Not enough balance");
        
        // require allowance if sender is not transaction creator
        if(sender != msg.sender){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Not enough allowance");
        }
        
        // burn & distribute
        uint256 sendAmt = _txBurn(sender, amount); 
        
        // transfer
        _balances[sender] = _balances[sender].sub(sendAmt);
        _balances[recipient] = _balances[recipient].add(sendAmt);
        
        // update holders
        updateHoldersTransferSender(sender);
        updateHoldersTransferRecipient(recipient);
        
        // call any hooks
        bogdabotTxHook(sender, recipient, amount);
        
        emit Transfer(sender, recipient, sendAmt);
        return true;
    }
    
    /**
     * Approve spender to spend amount from msg.sender
     */
    function _approve(address spender, uint256 amount) internal returns (bool) {
        _allowances[msg.sender][spender] = amount;
        return true;
    }
    
    function heBought(address account, uint256 amount) external override { /* just for the IBOG20 meme */}
    function heSold(address account, uint256 amount) external override { /* just for the IBOG20 meme */ }
    
    
    /**
     * Approve spender to spend amount from msg.sender
     */
    function approve(address spender, uint256 amount) external override returns (bool) {
        return _approve(spender, amount);
    }
    
    /**
     * Transfer from msg.sender to recipient for amount
     */
    function transfer(address recipient, uint256 amount) external override returns (bool) {
         return _transferFrom(msg.sender, recipient, amount);
     }

    /**
     * Transfer amount from sender to recipient so long as msg.sender has at least amount allowance
     */
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(sender, recipient, amount);
    }
    
    /**
     * Bulk execute transfers
     */
    function multiTransfer(address[] memory accounts, uint256[] memory amounts) external {
        require(accounts.length == amounts.length, "Accounts & amounts must be same length");
        for(uint256 i=0; i<accounts.length; i++){
            _transferFrom(msg.sender, accounts[i], amounts[i]);
        }
    }
}

/**
 * 
 */
contract Sminem is BOG20, RecordsCreation {
    using SafeMath for uint256;
    
    constructor() BOG20(2500000) {
        _name = "Sminem Finance";
        _symbol = "SMIN";
    }
}