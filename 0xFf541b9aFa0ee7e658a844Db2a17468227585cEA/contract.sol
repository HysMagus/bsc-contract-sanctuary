// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.12;

contract QbitToken {
    string public constant name = "QBIT Cryptocurrency Token";
    string public constant symbol = "QBIT";
    uint8 public constant decimals = 8;
    address owner_;
    uint256 totalSupply_;
    uint256 circulatingSupply_;

    using SafeMath for uint256;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    event Approval(address indexed owner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    // Constructor code is only run when the contract
    // is created
    constructor() public {
        owner_ = msg.sender;
        totalSupply_ = 6307192900000000;
        circulatingSupply_ = 0;
    }

    // Function to see total supply of QBIT token
    function totalSupply() view public returns (uint256) {
        return totalSupply_;
    }

    // Function to see circulating supply of QBIT token
    function circulatingSupply() view public returns (uint256) {
        return circulatingSupply_;
    }

    // Function to see balance of given address
    function balanceOf(address owner) view public returns (uint256) {
        return balances[owner];
    }

    // Function to make transfer
    function transfer(address to, uint256 amount) public returns (bool) {
        require (balances[msg.sender] >= amount);
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // Delegate right to make transfer
    function approve(address delegate, uint256 amount) public returns (bool) {
        allowed[msg.sender][delegate] = amount;
        emit Approval(msg.sender, delegate, amount);
        return true;
    }

    // Get delegated amount
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    // Transfer by delegate
    function transferFrom(address owner, address buyer, uint256 amount) public returns (bool) {
        require(balances[owner] >= amount);
        require(allowed[owner][msg.sender] >= amount);
        balances[owner] = balances[owner].sub(amount);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(amount);
        balances[buyer] = balances[buyer].add(amount);
        emit Transfer(owner, buyer, amount);
        return true;
    }

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == owner_);
        require((circulatingSupply_ + amount) < totalSupply_);
        circulatingSupply_ = circulatingSupply_.add(amount);
        balances[receiver] = balances[receiver].add(amount);
        emit Transfer(owner_, owner_, amount);
    }
}

library SafeMath { 
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