// File: contracts/UyghurConcentraionCamp.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract UyghurConcentraionCamp {
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Burn(address indexed burner, uint256 value);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );

    mapping(address => uint256) public balances;
    mapping(address => uint256) public availableToClaim;

    address public owner;
    uint256 public last_completed_migration;
    uint256 totalSupply_ = 1000000000000000000000000;

    string public name = "Uyghur Concentration Camp";
    string public constant symbol = "Uyghur Concentration Camp";
    uint256 public constant decimals = 18;

    constructor() public {
        totalSupply_ = totalSupply();
        owner = msg.sender;
        balances[owner] = 100000000000000000000;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function transfer(address receiver, uint256 numTokens)
        public
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] -= numTokens;
        balances[receiver] = balances[receiver] += numTokens;
        availableToClaim[msg.sender] += 1;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function mint() public returns (bool) {
        uint256 mintAmount = 100000000000000000000;
        require(availableToClaim[msg.sender] >= 0);
        totalSupply_ += mintAmount;
        balances[msg.sender] += mintAmount;
        availableToClaim[msg.sender] -= 1;
        transfer(msg.sender, mintAmount);
        return true;
    }
}