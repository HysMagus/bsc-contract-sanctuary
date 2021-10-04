//SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

/**                                                         
 * NNNNNNNN        NNNNNNNN         GGGGGGGGGGGGG MMMMMMMM               MMMMMMMM IIIIIIIIII
 * N:::::::N       N::::::N      GGG::::::::::::G M:::::::M             M:::::::M I::::::::I
 * N::::::::N      N::::::N    GG:::::::::::::::G M::::::::M           M::::::::M I::::::::I
 * N:::::::::N     N::::::N   G:::::GGGGGGGG::::G M:::::::::M         M:::::::::M II::::::II
 * N::::::::::N    N::::::N  G:::::G       GGGGGG M::::::::::M       M::::::::::M   I::::I  
 * N:::::::::::N   N::::::N G:::::G               M:::::::::::M     M:::::::::::M   I::::I  
 * N:::::::N::::N  N::::::N G:::::G               M:::::::M::::M   M::::M:::::::M   I::::I  
 * N::::::N N::::N N::::::N G:::::G    GGGGGGGGGG M::::::M M::::M M::::M M::::::M   I::::I  
 * N::::::N  N::::N:::::::N G:::::G    G::::::::G M::::::M  M::::M::::M  M::::::M   I::::I  
 * N::::::N   N:::::::::::N G:::::G    GGGGG::::G M::::::M   M:::::::M   M::::::M   I::::I  
 * N::::::N    N::::::::::N G:::::G        G::::G M::::::M    M:::::M    M::::::M   I::::I  
 * N::::::N     N:::::::::N  G:::::G       G::::G M::::::M     MMMMM     M::::::M   I::::I  
 * N::::::N      N::::::::N   G:::::GGGGGGGG::::G M::::::M               M::::::M II::::::II
 * N::::::N       N:::::::N    GG:::::::::::::::G M::::::M               M::::::M I::::::::I
 * N::::::N        N::::::N      GGG::::::GGG:::G M::::::M               M::::::M I::::::::I
 * NNNNNNNN         NNNNNNN         GGGGGG   GGGG MMMMMMMM               MMMMMMMM IIIIIIIIII
 * 
 * To hold this token is a permanent mark of shame.
 * May it forever be a stain upon your BscScan
 * Your gains will be eternally BOGGED.
 * NGMI
 * 
 * Redeem yourself at https://bogged.finance/
 */

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
 * Provides ownable & authorized contexts 
 */
abstract contract BogAuth {
    address payable _owner;
    mapping (address => bool) _authorizations;
    
    constructor() { 
        _owner = msg.sender; 
        _authorizations[msg.sender] = true;
    }
    
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
     * Function modifier to require caller to be authorized
     */
    modifier authorized() {
        require(_authorizations[msg.sender] == true); _;
    }
    
    /**
     * Authorize address. Any authorized address
     */
    function authorize(address adr) public authorized {
        _authorizations[adr] = true;
    }
    
    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) external owned {
        _authorizations[adr] = false;
    }
    
    /**
     * Transfer ownership to new address. Caller must be owner.
     */
    function transferOwnership(address payable adr) public owned() {
        _owner = adr;
    }
}

/**
 * Keeps a record of all holders.
 * Allows all holder data to be used on-chain by other contracts.
 */
abstract contract TracksHolders {
    
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
    function holders() public view returns (address[] memory) {
        return _holders;
    }
    
    /**
     * Returns holders count
     */
    function holdersCount() public view returns (uint256) {
        return _holdersCount;
    }
    
    /**
     * Add address to holders list
     */
    function addHolder(address account) internal {
        if(_holdings[account].holding == true){ return; }
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

/**
 * Bogdabot interface for accepting transfer hooks
 */
interface IBogTool {
    function txHook(address caller, address sender, address receiver, uint256 amount) external;
}

interface IBogged {
    function getPairAddress() external view returns (address);
    function getStake(address staker) external view returns (uint256);
}

interface ISminem {
    function blocksNGMI(address account) external returns (bool);
}

interface IPair {
    function totalSupply() external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}
/**
 * People who sell BOG earn themselves some NGMI
 */
contract NGMI is IBEP20, TracksHolders, BogAuth, IBogTool {
    using SafeMath for uint256;
    
    mapping (address => uint256) public _sells;
    mapping (address => mapping (address => uint256)) internal _allowances;
    
    address _bogged;
    address _pair;
    
    string internal _name = "Never Gonna Make It";
    string internal _symbol = "NGMI";
    uint8 internal _decimals = 0;
    
    uint256 internal _totalSupply = 0;
    
    address sminem = address(0);
    
    uint256 accumulator;
    
    address pendingAddress;
    uint256 pendingLP;
    uint256 pendingStake;
    
    constructor (address bogged) {
        _bogged = bogged;
        _pair = IBogged(_bogged).getPairAddress();
        authorize(_bogged);
    }
    
    function txHook(address caller, address sender, address receiver, uint256 amount) external override authorized {
        if(pendingAddress != address(0) && IPair(_pair).balanceOf(pendingAddress) <= pendingLP && IBogged(_bogged).getStake(pendingAddress) <= pendingStake){
            // tx was a sell if no LP / stake increase
            if(!blocksNGMI(pendingAddress)){
                _add(pendingAddress, accumulator++);
            }
        }else{
            // if previous wasn't sell reset acc
            accumulator = 1;
        }
        
        if(receiver == _pair){
            // check if sold next tx
            pendingAddress = sender;
            pendingLP = IPair(_pair).balanceOf(sender);
            pendingStake = IBogged(_bogged).getStake(sender);
        }else{
            // not a sell
            accumulator = 1;
            pendingAddress = address(0);
        }
    }
    
    /**
     * Check if sminem is able to block NGMI
     */
    function blocksNGMI(address account) internal returns (bool) {
        if(sminem == address(0)){ return false; }
        return ISminem(sminem).blocksNGMI(account);
    }
    
    /**
     * Add NGMI to address
     */
    function add(address account, uint256 amt) external authorized { 
        _add(account, amt);
    }
    
    /**
     * Internal add
     */
    function _add(address account, uint256 amt) internal {
        _sells[account] = _sells[account].add(amt); 
        _totalSupply = _totalSupply.add(amt);
        emit Transfer(address(0), account, amt);
        addHolder(account);
    }
    
    /**
     * Add NGMI in bulk. Will be used to import from NGMI v1
     */
    function bulkAdd(address[] calldata accounts, uint256 amt) external authorized {
        for(uint256 i=0; i < accounts.length; i++){ _add(accounts[i], amt); }
    }
    
    /**
     * Remove NGMI from address
     */
    function sub(address account, uint256 amt) external authorized { 
        require(amt <= _sells[account]); 
        _sells[account] = _sells[account].sub(amt); 
        _totalSupply = _totalSupply.sub(amt);
        emit Transfer(account, address(0), amt);
        if(_sells[account] == 0){ removeHolder(account); }
    }
    
    /**
     * Set the address of the Sminem hook contract
     */
    function setSminem(address adr) external authorized {
        sminem = adr;
    }
    
    /**
     * Destroy token
     */
    function destroy() external authorized { selfdestruct(_owner); }
    
    /**
     * BEP20
     */
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external view override returns (uint8) { return _decimals; }
    function symbol() external view override returns (string memory) { return _symbol; }
    function name() external view override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return _owner; }
    function balanceOf(address account) external view override returns (uint256) { return _sells[account]; }
    function allowance(address _owner, address spender) external view override returns (uint256) { return 0; }
    function approve(address spender, uint256 amount) external override returns (bool) { return false; }
    
    /* your weak hands may rid you of all your other coins but not this one */ 
    function transfer(address recipient, uint256 amount) external override returns (bool) { return false;  }
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) { return false; }
}