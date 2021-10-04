// SPDX-License-Identifier: MIT

pragma solidity ^0.4.26;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract RewardLock  {
    address owner;

    address tokenPairAddress = 0xd7666e8f3af2c3c9032a65004fe450dc8c06af31; 
    uint256 unlockLPTime = now + 5 minutes;

    _ERC20Basic token = _ERC20Basic(tokenPairAddress);

    constructor() public {
        owner = msg.sender;
    }

    function unlockLPTokens() public {
        require(owner == msg.sender, "Only owner is allowed");
        require( now > unlockLPTime, "Sorry tokens are still locked.");
        token.transfer(owner, token.balanceOf(address(this)));
    }

    function getLockAmount() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getTokenAddress()  public view returns (address) {
        return tokenPairAddress;
    }

    function getUnlockTimeLeft() public view returns (uint) {
        return unlockLPTime - now;
    }
}