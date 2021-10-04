pragma solidity ^0.4.13;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract Locker {
    address owner;
    
    address tokenAddress = 0x567e2B16f8Ef147ae62F5d958397eB08974680C1; // This PancakeSwap Liquidity Provider (LP) token represents the bUNDB and BNB pairing.
    uint256 unlockUnix = now + (31 days) * 2; // 6 months
    
    _ERC20Basic token = _ERC20Basic(tokenAddress);
    
    constructor() public {
        owner = msg.sender;
    }
    
    function unlockTeamTokens() public {
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