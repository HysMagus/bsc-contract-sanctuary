// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract BlossToken {
    // map an address to value or amount
    mapping(address => uint256) public balance;
    
    //map address to another address
    mapping(address => mapping(address => uint256)) public allowance;
     
     // cannot change after deployed
    uint256 public totalSupply = 1000000000 * 10 ** 18;
    string public name = "Bloss Hub";
    string public symbol = "BLH";
    uint256 public decimal = 18;
 
 // create events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
   
    //contructor are executed once on run time like setup void loop
    constructor() {
        balance[msg.sender] = totalSupply;
    }
    
    // read the balance pass to owner
    function balanceOf(address owner) public view returns(uint256) {
        return balance[owner];
    }
    
    // function to transfer token from an address to another 
    //msg.sender is the from user
    function transfer(address to, uint256 value) public returns(bool){
     require(balanceOf(msg.sender) >= value, 'Low Balance'); 
     balance[to] += value;
     balance[msg.sender] -= value;
     emit Transfer(msg.sender,to, value);
     return true;
    }
    
    function transferFrom(address from, address to, uint256 value)public returns(bool){
        require(balanceOf(from) >= value, 'Still low balance');
        require(allowance[from][msg.sender] >= value, 'allowance too low');
        balance[to] += value;
        balance[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    // delegate transfer. an address to spend money from its address
    function approve(address spender, uint256 value) public returns(bool){
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    
}