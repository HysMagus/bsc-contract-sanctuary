// SPDX-License-Identifier: MIT

pragma solidity ^0.4.26;

contract BEP20 {
  uint256 public totalSupply;

  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);
}



pragma solidity ^0.4.26;

contract TimeLockedWallet {

    address public creator;
    address public owner;
    uint256 public unlockDate;
    uint256 public createdAt;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function TimeLockedWallet(
        address _creator,
        address _owner,
        uint256 _unlockDate
    ) public {
        creator = _creator;
        owner = _owner;
        unlockDate = _unlockDate;
        createdAt = now;
    }

    // keep all the ether sent to this address
    function() payable public { 
        Received(msg.sender, msg.value);
    }

    // callable by owner only, after specified time
    function withdraw() onlyOwner public {
       require(now >= unlockDate);
       //now send all the balance
       msg.sender.transfer(this.balance);
       Withdrew(msg.sender, this.balance);
    }

    // callable by owner only, after specified time, only for Tokens implementing BEP20
    function withdrawTokens(address _tokenContract) onlyOwner public {
       require(now >= unlockDate);
       BEP20 token = BEP20(_tokenContract);
       //now send all the token balance
       uint256 tokenBalance = token.balanceOf(this);
       token.transfer(owner, tokenBalance);
       WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
    }

    function info() public view returns(address, address, uint256, uint256, uint256) {
        return (creator, owner, unlockDate, createdAt, this.balance);
    }

    event Received(address from, uint256 amount);
    event Withdrew(address to, uint256 amount);
    event WithdrewTokens(address tokenContract, address to, uint256 amount);
}