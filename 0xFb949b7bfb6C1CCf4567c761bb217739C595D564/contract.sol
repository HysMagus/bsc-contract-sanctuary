//SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

/**
 * $$$$$$$\                                                $$\ 
 * $$  __$$\                                               $$ |
 * $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$$ |
 * $$$$$$$\ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$  __$$ |
 * $$  __$$\ $$ /  $$ |$$ /  $$ |$$ /  $$ |$$$$$$$$ |$$ /  $$ |
 * $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |  $$ |
 * $$$$$$$  |\$$$$$$  |\$$$$$$$ |\$$$$$$$ |\$$$$$$$\ \$$$$$$$ |
 * \_______/  \______/  \____$$ | \____$$ | \_______| \_______|
 *                     $$\   $$ |$$\   $$ |                    
 *                     \$$$$$$  |\$$$$$$  |      
 * $$$$$$$$\ $$\        \______/  \______/                        
 * $$  _____|\__|                                                  
 * $$ |      $$\ $$$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$$\  $$$$$$\  
 * $$$$$\    $$ |$$  __$$\  \____$$\ $$  __$$\ $$  _____|$$  __$$\ 
 * $$  __|   $$ |$$ |  $$ | $$$$$$$ |$$ |  $$ |$$ /      $$$$$$$$ |
 * $$ |      $$ |$$ |  $$ |$$  __$$ |$$ |  $$ |$$ |      $$   ____|
 * $$ |      $$ |$$ |  $$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$\ \$$$$$$$\ 
 * \__|      \__|\__|  \__| \_______|\__|  \__| \_______| \_______|
 * 
 * Bogged Finance
 * Website: https://bogged.finance/
 * Telegram: https://t.me/boggedfinance
 */

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
 * Provides ownable context 
 */
abstract contract BogOwnable {
    constructor() { _owner = msg.sender; }
    address payable _owner;
    
    mapping (address => bool) _authorizedAddresses;
    
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
    
    modifier authorized() {
        require(_authorizedAddresses[msg.sender] == true); _;
    }
    
    function authorize(address adr) public authorized {
        _authorizedAddresses[adr] = true;
    }
    
    /**
     * Transfer ownership to new address. Caller must be owner.
     */
    function transferOwnership(address payable adr) public owned() {
        _owner = adr;
    }
}

interface IBogged {
    function getStake(address staker) external view returns (uint256);
}

interface ISminemPool {
    function initialClaim(address claimer, uint256 sminemID) external;
}

/**
 * Calls claim() on an external contract after 48hrs if stake has been maintained
 */
contract SminemSummoner is BogOwnable {
    using SafeMath for uint256;
    
    address bogged;
    
    uint256 release = 1615237200; // mar 8th 9pm utc
    uint256 remaining = 500;
    uint256 nextClaim = 1;
    
    mapping (address => uint256) public summoning;
    mapping (address => uint256) public claimTimes;
    mapping (address => uint256) public stakes;
    
    ISminemPool pool;
    
    constructor (address _bogged) {
        bogged = _bogged;
    }
    
    function timeBeforeSummon() external view returns (uint256) {
        if(block.timestamp >= release){ return 0; }
        return release - block.timestamp;
    }
    
    /**
     * Returns the amount of remaining sminems
     */
    function getRemaining() external view returns (uint256) {
        return remaining;
    }
    
    /**
     * Reserve a Sminem and start the summoning timer
     */
    function summon() external {
        require(block.timestamp >= release, "Not released"); // require sminems to be released
        require(remaining > 0, "None left"); // require there to be some remaining 
        require(summoning[msg.sender] == 0, "Already summoning"); // require summoner to not already be summoning
        require(IBogged(bogged).getStake(msg.sender) > 0, "Not Staking"); // must have staked to summon
        
        summoning[msg.sender] = nextClaim;
        claimTimes[msg.sender] = block.timestamp + 3 days;
        stakes[msg.sender] = IBogged(bogged).getStake(msg.sender);
        
        nextClaim++;
        remaining--;
    }
    
    /**
     * Claim after summoning time has expired
     */
    function claim() external {
        require(summoning[msg.sender] != 0); // must be summoning a sminem to claim
        require(claimTimes[msg.sender] <= block.timestamp); // must be at or after the claim time 
        require(IBogged(bogged).getStake(msg.sender) >= stakes[msg.sender]); // must have maintained stake to claim
        
        pool.initialClaim(msg.sender, summoning[msg.sender]); // call sminem pool with initial claim for user
        
        summoning[msg.sender] = 0; // clear summon so they cant claim multiple times
    }
    
    /**
     * Returns remaining time before claim.
     */
    function getTimeUntilClaim(address adr) external view returns (uint256) {
        uint256 time = claimTimes[adr];
        require(time > 0, "No Sminem Claimed");
        if(time < block.timestamp){ return 0; }
        return time.sub(block.timestamp);
    }
    
    function getSummoning(address adr) external view returns (uint256) {
        return summoning[adr];
    }
    
    /**
     * Set the sminem pool address for calling the claim hook
     */
    function setPool(address adr) external authorized {
        pool = ISminemPool(adr);
    }
}