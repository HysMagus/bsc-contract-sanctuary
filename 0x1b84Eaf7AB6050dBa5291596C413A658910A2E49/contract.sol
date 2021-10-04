// Token Locker for BORG-BUSD LP Tokens
// https://assimilate.finance/
// 6 Months for Liquidity Lock

pragma solidity ^0.4.13;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract BORGLPLockerBUSDPair {
    address owner;

    address tokenAddress = 0x8d3a10c1ef09dee12a8a1b8b1644b207816b2709; // BORG-BUSD LP Token Address
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