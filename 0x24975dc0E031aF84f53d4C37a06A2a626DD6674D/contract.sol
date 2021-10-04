// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// ██████   ██████  ███    ███ ███████  ██████  ██████   █████  ███    ██  █████  ████████ ███████ 
// ██   ██ ██    ██ ████  ████ ██      ██       ██   ██ ██   ██ ████   ██ ██   ██    ██    ██      
// ██████  ██    ██ ██ ████ ██ █████   ██   ███ ██████  ███████ ██ ██  ██ ███████    ██    █████   
// ██      ██    ██ ██  ██  ██ ██      ██    ██ ██   ██ ██   ██ ██  ██ ██ ██   ██    ██    ██      
// ██       ██████  ██      ██ ███████  ██████  ██   ██ ██   ██ ██   ████ ██   ██    ██    ███████ 
//                                                                                                 

// Pomegranate Token
// pome.exchange
// 2021

/*
* @title Pomegranate Token
* @dev Oracle contract with all pomegranate functions.
*/

//Slightly modified SafeMath library - includes a min and max function, removes useless div function

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
}

interface ItokenRecipient { 
    
    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external returns (bool); 
}

interface IERC20Token {
    
    function totalSupply() external view returns (uint256 supply);
    function transfer(address _to, uint256 _value) external  returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

contract Pomegranate is IERC20Token {
    
    using SafeMath for uint256;
    
    string public name = "Pomegranate";
    uint8 public decimals = 18;
    string public symbol = "POME";
    uint256 public _totalSupply;
    address public owner;
    address payable public wallet;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed from, uint256 value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    /*
    * @dev The constructor sets the original `owner` of the contract
    */

    constructor() {
        owner = msg.sender;
        wallet = payable(owner);
        emit OwnerSet(address(0), owner);
        _totalSupply = 100000000000000000000000000;
        balances[owner] = _totalSupply;
        emit Transfer(address(0x0), owner, balances[owner]);
    }
    
    /*
    * @dev Burn tokens
    */
    
    function burn(uint256 _value) public onlyOwner returns (bool success) {
        require(balances[msg.sender] >= _value, "Not enough balance");
		require(_value >= 0, "Invalid amount"); 
        balances[msg.sender] = balances[msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Burn(msg.sender, _value);
        return true;
    }
    
    /*
    * @dev Mint tokens
    */
    
    function mint(uint256 _value) public onlyOwner returns (bool) {
        _totalSupply = _totalSupply.add(_value);
        balances[owner] = balances[owner].add(_value);
        emit Mint(msg.sender, _value);
        return true;
    }
    
    /*
    * @dev Change Pomegranate Owner
    */
    
    function changeOwner(address newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
        wallet = payable(owner);
    }
    
    function getOwner() external view returns (address) {
        return owner;
    }
    
    /*
    * @title Pomegranate Transfer
    * @dev Contains the methods related to transfers and ERC20.
    */
    
    function transfer(address _to, uint256 _value) override virtual public returns (bool success) {
        require(_to != address(0x0), "Use burn function instead");                              
		require(_value >= 0, "Invalid amount"); 
		require(balances[msg.sender] >= _value, "Not enough balance");
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    /*
    * @notice Send _amount tokens to _to from _from on the condition it
    * is approved by _from
    * @param _from The address holding the tokens being transferred
    * @param _to The address of the recipient
    * @param _amount The amount of tokens to be transferred
    * @return True if the transfer was successful
    */
    
    function transferFrom(address _from, address _to, uint256 _value) override virtual public returns (bool success) {
        require(_to != address(0x0), "Use burn function instead");                               
		require(_value >= 0, "Invalid amount"); 
		require(balances[_from] >= _value, "Not enough balance");
		require(allowed[_from][msg.sender] >= _value, "You need to increase allowance");
		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(_from, _to, _value);
        return true;
    }
    
    function transferAnyERC20Token(address tokenAddress, uint256 _value) public onlyOwner returns (bool success) {
        return IERC20Token(tokenAddress).transfer(wallet, _value);
    }
    
    function withdrawMoney(uint _amount) public payable onlyOwner {
        wallet.transfer(_amount);
    }
    
    /*
    * @dev Getter for the total_supply of oracle tokens
    * @return uint total supply
    */
    
    function totalSupply() override public view returns (uint256 supply) {
        return _totalSupply;
    }
    
    /*
    * @dev Gets balance of owner specified
    * @param _user is the owner address used to look up the balance
    * @return Returns the balance associated with the passed in _user
    */
    
    function balanceOf(address _owner) override public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    /*
    * @dev This function approves a _spender an _amount of tokens to use
    * @param _spender address
    * @param _amount amount the spender is being approved for
    * @return true if spender appproved successfully
    */
    
    function approve(address _spender, uint256 _value) override public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /*
    * @param _user address of party with the balance
    * @param _spender address of spender of parties said balance
    * @return Returns the remaining allowance of tokens granted to the _spender from the _user
    */
    
    function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    fallback () external payable {
        wallet.transfer(msg.value);
    }
    
    receive() external payable {}
}