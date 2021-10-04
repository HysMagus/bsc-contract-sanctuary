/**
 *Submitted for verification at BscScan.com on 2021-02-23
*/

pragma solidity 0.5.8;

contract NutsLPStaking {
    using SafeMath for uint256;

    ERC20 nuts = ERC20(0xbA91F10004856C76aFDBbf80614C80962a02Be66);
    ERC20 nutsLP = ERC20(0xf99A08494ed40Da0C2656101D7DE9fA6395a9132);

    mapping(address => uint256) public balances;
    mapping(address => int256) payoutsTo;

    uint256 public totalDeposits;
    uint256 profitPerShare;
    uint256 constant internal magnitude = 2 ** 64;
    
    uint256 public nutsPerEpoch;
    uint256 public payoutEndTime;
    uint256 public lastDripTime;

    function deposit(uint256 amount) external {
        dripNuts();
        nutsLP.transferFrom(msg.sender, address(this), amount);
        totalDeposits += amount;
        balances[msg.sender] += amount;
        payoutsTo[msg.sender] += (int256) (profitPerShare * amount);
    }

    function cashout(uint256 amount) external {
        address recipient = msg.sender;
        claimYield();
        balances[recipient] = balances[recipient].sub(amount);
        totalDeposits = totalDeposits.sub(amount);
        payoutsTo[recipient] -= (int256) (profitPerShare * amount);
        nutsLP.transfer(recipient, amount);
    }

    function claimYield() public {
        dripNuts();
        address recipient = msg.sender;
        uint256 dividends = (uint256) ((int256)(profitPerShare * balances[recipient]) - payoutsTo[recipient]) / magnitude;
        payoutsTo[recipient] += (int256) (dividends * magnitude);
        nuts.transfer(recipient, dividends);
    }
    
    function setWeeksRewards(uint256 amount) external {
        require(msg.sender == address(0x384C973692fe57c5aDAF6D39CC8C5aDece08a69f));
        dripNuts();
        uint256 remainder;
        if (now < payoutEndTime) {
            remainder = nutsPerEpoch * (payoutEndTime - now);
        }
        nutsPerEpoch = (amount + remainder) / 7 days;
        payoutEndTime = now + 7 days;
    }
    
    function dripNuts() internal {
        uint256 divs;
        if (now < payoutEndTime) {
            divs = nutsPerEpoch * (now - lastDripTime);
        } else if (lastDripTime < payoutEndTime) {
            divs = nutsPerEpoch * (payoutEndTime - lastDripTime);
        }
        lastDripTime = now;

        if (divs > 0) {
            profitPerShare += divs * magnitude / totalDeposits;
        }
    }

    function dividendsOf(address farmer) view public returns (uint256) {
        uint256 totalProfitPerShare = profitPerShare;
        uint256 divs;
        if (now < payoutEndTime) {
            divs = nutsPerEpoch * (now - lastDripTime);
        } else if (lastDripTime < payoutEndTime) {
            divs = nutsPerEpoch * (payoutEndTime - lastDripTime);
        }
        
        if (divs > 0) {
            totalProfitPerShare += divs * magnitude / totalDeposits;
        }
        return (uint256) ((int256)(totalProfitPerShare * balances[farmer]) - payoutsTo[farmer]) / magnitude;
    }
}



interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function burn(uint256 amount) external;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}