/**
 *Submitted for verification at BscScan.com on 2021-02-12
*/

pragma solidity ^0.4.13;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract Beflect_LP_Locker  {
    address owner;

    address tokenPairAddress = 0x2fa76e78cb4d5e31a46d614beaf190f0dc22b47c; 
    uint256 unlockLPTime = now + 15 days; // 1 months

    _ERC20Basic token = _ERC20Basic(tokenPairAddress);

    constructor() public {
        owner = msg.sender;
    }

    function unlockLPTokens() public {
        require(owner == msg.sender, "Get a life!!");
        require( now > unlockLPTime, "Sorry tokens are still locked.");
        token.transfer(owner, token.balanceOf(address(this)));
    }

    //Control
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