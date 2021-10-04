//SPDX-License-Identifier: MIT 
//Most credit goes to Team Finance for the base contract and Chainsulting for the audit report on that base contract.
//Updated by The Audit Institute to provide free token locking on BSC - https://audit.institute
pragma solidity ^0.7.6;
//Changes: Update solidity version and clean up code; no key logic has been changed.

interface Token {
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }
}

contract TokenLocker{
    using SafeMath for uint256;

    address public owner;

    /*
     * deposit vars
    */
    struct Items {
        address tokenAddress;
        address withdrawalAddress;
        uint256 tokenAmount;
        uint256 unlockTime;
        bool withdrawn;
    }
    
    uint256 public depositId;
    uint256[] public allDepositIds;
    mapping (address => uint256[]) public depositsByWithdrawalAddress;
    mapping (uint256 => Items) public lockedToken;
    mapping (address => mapping(address => uint256)) public walletTokenBalance;
    
    event LogWithdrawal(address SentToAddress, uint256 AmountTransferred);

    function lockTokens(address _tokenAddress, uint256 _amount, uint256 _unlockTime) public returns (uint256 _newDepositID) {
        require(_amount > 0);
        require(Token(_tokenAddress).transferFrom(msg.sender, address(this), _amount));
        walletTokenBalance[_tokenAddress][msg.sender] = walletTokenBalance[_tokenAddress][msg.sender].add(_amount);
        address _withdrawalAddress = msg.sender;
        _newDepositID = ++depositId;
        lockedToken[_newDepositID].tokenAddress = _tokenAddress;
        lockedToken[_newDepositID].withdrawalAddress = _withdrawalAddress;
        lockedToken[_newDepositID].tokenAmount = _amount;
        lockedToken[_newDepositID].unlockTime = _unlockTime;
        lockedToken[_newDepositID].withdrawn = false;
        allDepositIds.push(_newDepositID);
        depositsByWithdrawalAddress[_withdrawalAddress].push(_newDepositID);
    }
    
    function transferLocks(uint256 _id, address _receiverAddress) public {
        require(block.timestamp < lockedToken[_id].unlockTime);
        require(msg.sender == lockedToken[_id].withdrawalAddress);
        lockedToken[_id].withdrawalAddress = _receiverAddress;
        walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
        walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress] = walletTokenBalance[lockedToken[_id].tokenAddress][_receiverAddress].add(lockedToken[_id].tokenAmount);
    }

    function withdrawTokens(uint256 _id) public {
        require(block.timestamp >= lockedToken[_id].unlockTime);
        require(msg.sender == lockedToken[_id].withdrawalAddress);
        require(!lockedToken[_id].withdrawn);
        require(Token(lockedToken[_id].tokenAddress).transfer(msg.sender, lockedToken[_id].tokenAmount));
        lockedToken[_id].withdrawn = true;
        walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender] = walletTokenBalance[lockedToken[_id].tokenAddress][msg.sender].sub(lockedToken[_id].tokenAmount);
        emit LogWithdrawal(msg.sender, lockedToken[_id].tokenAmount);
    }

    function getTotalTokenBalance(address _tokenAddress) view public returns (uint256)
    {
       return Token(_tokenAddress).balanceOf(address(this));
    }
    
    function getTokenBalanceByAddress(address _tokenAddress, address _walletAddress) view public returns (uint256)
    {
       return walletTokenBalance[_tokenAddress][_walletAddress];
    }
    
    function getAllDepositIds() view public returns (uint256[] memory)
    {
        return allDepositIds;
    }
    
    function getDepositDetails(uint256 _id) view public returns (address tokenAddress, address withdrawalAddress, uint256 tokenAmount, uint256 unlockTime, bool withdrawn)
    {
        return(lockedToken[_id].tokenAddress,lockedToken[_id].withdrawalAddress,lockedToken[_id].tokenAmount,
        lockedToken[_id].unlockTime,lockedToken[_id].withdrawn);
    }
    
    function numOfActiveDeposits(address _withdrawalAddress) public view returns (uint256) {
        uint256 staked = 0;
        for (uint i = 0; i < depositsByWithdrawalAddress[_withdrawalAddress].length; i++) {
            if (!lockedToken[depositsByWithdrawalAddress[_withdrawalAddress][i]].withdrawn) {
                staked++;
            }
        }
        return staked;
    }
    
    function getWithdrawableDepositsByAddress(address _withdrawalAddress) view public returns (uint256[] memory)
    {
        uint256[] memory deposits = new uint256[](numOfActiveDeposits(_withdrawalAddress));
        uint256 tempIdx = 0;
        for(uint256 i = 0; i < depositsByWithdrawalAddress[_withdrawalAddress].length; i++) {
            if(!lockedToken[depositsByWithdrawalAddress[_withdrawalAddress][i]].withdrawn) {
                deposits[tempIdx] =  depositsByWithdrawalAddress[_withdrawalAddress][i];
                tempIdx ++;
            }
        }
        return deposits;
    }
    
    function getAllDepositsByAddress(address _withdrawalAddress) view public returns (uint256[] memory)
    {
        return depositsByWithdrawalAddress[_withdrawalAddress];
    }
    
}