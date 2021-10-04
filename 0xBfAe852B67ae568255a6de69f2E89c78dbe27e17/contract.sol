//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function ceil(uint a, uint m) internal pure returns (uint r) {
    return (a + m - 1) / m * m;
  }
}

interface BEP20Token {
    function transfer(address to, uint256 tokens) external returns (bool success);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
}

contract Ownable {
    address payable public owner;
    event OwnershipTransferred(address indexed _from, address indexed _to);
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address payable _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnershipTransferred(msg.sender, _newOwner);
    }
}

contract kBTC_Crowdsale is Ownable {
    using SafeMath for uint256;
    address public tokenAddress;
    bool public saleOpen;
    uint256 tokenRatePerBNB = 4; 
    mapping(address => uint256) public userContribution;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function withdrawETH() external onlyOwner{
        require(!saleOpen, "need sale closed");        
        owner.transfer(address(this).balance);
    }    

    function getTokenstoburn() external onlyOwner{
        require(!saleOpen, "need sale closed");
        require(BEP20Token(tokenAddress).balanceOf(address(this)) > 0);
        BEP20Token(tokenAddress).transfer(owner, BEP20Token(tokenAddress).balanceOf(address(this)));
    }
    
    function setTokenAddress(address tokenContract) external onlyOwner{
        require(tokenAddress == address(0), "Token address already set");
        tokenAddress = tokenContract;
    }
    
    receive() external payable{
        require(saleOpen, "ned sale open");
        require(userContribution[msg.sender].add(msg.value) >= 2 ether && userContribution[msg.sender].add(msg.value) <= 10 ether, "Min 2 BNB and max 10 BNB per wallet");
        uint256 tokens = getTokenAmount(msg.value);
        require(BEP20Token(tokenAddress).transfer(msg.sender, tokens), "Not enough tokens left in the sale contract");
        userContribution[msg.sender] = userContribution[msg.sender].add(msg.value);
    }
    
    function getTokenAmount(uint256 amount) internal view returns(uint256){
        return (amount.mul(tokenRatePerBNB));
    }
    
    function startSale() external onlyOwner{
        require(!saleOpen, "need sale open");
        saleOpen = true;
    }
    
    function stopSale() external onlyOwner{
        require(saleOpen, "need sale open");
        saleOpen = false;
    }    
    
}