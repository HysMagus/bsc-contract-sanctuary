// Token Locker for BORG-BNB LP Tokens
// https://assimilate.finance/
// 6 Months for Liquidity Lock

pragma solidity ^0.4.13;

contract _ERC20Basic {
  function balanceOf(address _owner) public returns (uint256 balance);
  function transfer(address to, uint256 value) public returns (bool);
}


contract BORGLPLocker {
    address owner;

    address tokenAddress = 0xc729697e55af427e4bcf5bf2efac5c99b5960bee; // BORG-BNB LP Token Address
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