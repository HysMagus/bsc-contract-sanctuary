//SPDX-License-Identifier: To The Mars (MARTIAN)

pragma solidity ^0.6.0;

interface IERC20 {
    function balanceOf(address owner) external returns(address);
    function transfer(address to, uint256 value) external returns(bool);
    function decimals() external returns (uint256);
    function allowance(address owner, address spender)external view returns (uint256);
    function transferFrom(address from, address to, uint256 value)external returns (bool);
    function approve(address spender, uint256 value)external returns (bool);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract MartianSwap {
    using SafeMath for uint256;
    IERC20 public token;
    address payable tokenWallet;
    address payable devWallet;
    uint256 public price = 25000;
    address owner;
    uint256 public tokenPurchased;
    
    event TokenPurchased(
    address indexed purchaser,
    uint256 value,
    uint256 amount
    );

    
    constructor (IERC20 _token, address payable _tokenWallet, address payable _devWallet) public {
        require(_tokenWallet != address(0));
        
        owner = msg.sender;
        
        token = _token;
        tokenWallet = _tokenWallet;
        devWallet = _devWallet;
       
    }
    
    function changePrice(uint256 _price) public returns(uint256) {
        require(msg.sender == owner, "Only owner can set Price");
        price = _price;
        return price;
    }
    
    
    receive () external payable {
        buy(msg.sender);
     }

    
    function buy(address _purchaser)public payable {
        
        require(msg.value != 0, "Amount cannot be 0");
        require(_purchaser != address(0), "Purchaser cannot be null address");
        require(_purchaser == msg.sender, "Purchaser must be the same acount as logged in");
       
        
        uint256 totalTokens = msg.value.mul(price);
        tokenPurchased = tokenPurchased.add(totalTokens);
        token.transferFrom(tokenWallet, _purchaser, totalTokens);
        emit TokenPurchased (
             _purchaser,
             price,
             totalTokens);
             
        tokenWallet.transfer((address(this).balance).mul(uint256(95)).div(uint256(100)));
        devWallet.transfer(address(this).balance);
        
    }
    
    function remainingTokens()view public returns(uint256) {
        return token.allowance(tokenWallet, address(this));
    }
    
    
     function approve()public returns (bool) {
         require(msg.sender == owner, "Only owner can call this function");
         IERC20(token).approve(address(this), 10000000*10*18);
         return true;
     }
    
    
    
    
    
    
    
}