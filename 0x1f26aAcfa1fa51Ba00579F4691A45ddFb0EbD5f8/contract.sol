// Token Locker for  Lev-BNB 
// https://www.leveraged-bnb.com/
// 6 Months for Liquidity Lock

pragma solidity ^0.4.13;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract Locker {
    address owner;

    address tokenAddress = 0x0b3af412c7b37f33a8e123d87dbcc7f26184e3a9; // LevBNB-BNB LP Token Address
    uint256 unlockUnix = now + (30 days) * 6; // 6 months

    _ERC20Basic token = _ERC20Basic(tokenAddress);

    constructor() public {
        owner = msg.sender;
    }

    function unlockLPTokens() public {
        require(owner == msg.sender, "You is not owner");
        require( now > unlockUnix, "Is not unlock time now");
        token.transfer(owner, token.balanceOf(address(this)));
    }

    //Control
    function getLockAmount() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getTokenAddress()  public view returns (address) {
        return tokenAddress;
    }

    function getUnlockTimeLeft() public view returns (uint) {
        return unlockUnix - now;
    }
}