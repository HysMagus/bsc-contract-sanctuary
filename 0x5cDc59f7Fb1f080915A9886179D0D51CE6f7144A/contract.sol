pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor()  {
        owner = 0xc28beE3D1bcfF45AC644678aa8Ce51A974b70eE9;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract ERC20 {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping (address=>uint256) balances;
    mapping (address=>mapping (address=>uint256)) allowed;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    function balanceOf(address owner) view public returns (uint256 balance) {return balances[owner];}
    
    function transfer(address _to, uint256 _amount) public returns (bool success) {
        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(msg.sender,_to,_amount);
        return true;
    }
  
    function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
  
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        allowed[msg.sender][_spender]=_amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address owner, address _spender) view public returns (uint256 remaining) {
      return allowed[owner][_spender];
    }
}

contract FlowCoin is Owned,ERC20{
    uint256 public maxSupply;

    constructor(address owner) {
        symbol = "FCN";
        name = "FlowCoin";
        decimals = 18;                        // 18 Decimals 
        totalSupply = 5000000e18;             // 5,000,000 FCN and 18 Decimals
        maxSupply   = 5000000e18;             // 5,000,000 FCN and 18 Decimals
        owner = 0xc28beE3D1bcfF45AC644678aa8Ce51A974b70eE9;
        balances[owner] = totalSupply;
    }
    
    receive() external payable {
        revert();
    }
    
}