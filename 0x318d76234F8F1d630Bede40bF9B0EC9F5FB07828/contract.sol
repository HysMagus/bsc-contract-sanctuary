// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface BEP20Interface {

  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);
  
  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    return add(a, b, "SafeMath: addition overflow");
  }


  function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, errorMessage);

    return c;
  }


  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }


  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }


  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

 
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }


  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }


  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }


  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract Presale is Ownable {
    using SafeMath for uint256;
     
    uint256 public presaleCost;
    uint256 public depositMaxAmount;
    
    BEP20Interface public dexf;
    BEP20Interface public usdc;

    address[] public whiteList;
    address public reservior;

    mapping(address => uint256) depositedAmount;
    mapping(address => uint256) paidOut;

    uint256 public totalDepositedAmount; // total deposited USDC amount
    uint256 public totalPaidOut; // total paid out DEXF amount
    uint256 public participants;

    event Deposited(address indexed account, uint256 depositeAmount, uint256 paidOut);
    
    constructor() {
        dexf = BEP20Interface(0x9B2A6Aa222022c455fCfF571d2D26a503B90091b);
        usdc = BEP20Interface(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
        reservior = address(0xb357929b957E3B36204Cc2D02DD52e59Ab762177);

        presaleCost = 111111111111111111111; // 111.111111111 DEXF per 1 USDC
        depositMaxAmount = 250E18;
    }

    // View functions

    function getDepositedAmount(address user) public view returns(uint256) {
      return depositedAmount[user];
    }

    function getPaidOut(address user) public view returns(uint256) {
      return paidOut[user];
    }

    function getExpectedPayOut(uint256 usdcAmount) public view returns(uint256) {
      return presaleCost.mul(usdcAmount).div(10 ** 18);
    }

    function whiteListLength() public view returns(uint256) {
        return whiteList.length;
    }

    function checkWhiteListByAddress(address _one) public view returns(bool) {
        require(_one != address(0), "Invalid address to check");
        
        for (uint256 i = 0; i < whiteListLength(); i++) {
            if (whiteList[i] == _one) {
                return true;
            }
        }
        return false;
    }

    // write functions

    function setPresaleCost(uint256 cost) external onlyOwner {
      presaleCost = cost;
    }

    function setDepositMaxAmount(uint256 amount) external onlyOwner {
      depositMaxAmount = amount;
    }

    function setWhiteList(address[] memory _whiteList) external onlyOwner {
        uint256 length = _whiteList.length;
        
        require(whiteListLength() == 0 && length > 0, "Invalid setting for white list");

        for (uint256 i = 0; i < length; i++) {
            whiteList.push(_whiteList[i]);
        }
    }

    function addOneToWhiteList(address _one) public onlyOwner {
        require(_one != address(0), "Invalid address to add");

        whiteList.push(_one);
    }

    function removeOneFromWhiteList(address _one) external onlyOwner {
        require(_one != address(0), "Invalid address to remove");

        for (uint256 i = 0; i < whiteList.length; i++) {
            if (whiteList[i] == _one) {
                whiteList[i] = whiteList[whiteList.length - 1];
                whiteList.pop();
                break;
            }
        }
    }

    function deposite(uint256 amount) external {
        require(!_isContract(_msgSender()), "Sender could not be a contract");
        require(checkWhiteListByAddress(_msgSender()), "Address not allowed");
        require(depositedAmount[_msgSender()].add(amount) <= depositMaxAmount, "Total eposited amount must be less than 500 USDC");

        usdc.transferFrom(_msgSender(), address(this), amount);
        totalDepositedAmount = totalDepositedAmount.add(amount);
        
        if (depositedAmount[_msgSender()] == 0)
          participants++;
        
        depositedAmount[_msgSender()] = depositedAmount[_msgSender()].add(amount);

        uint256 payOut = getExpectedPayOut(amount);
        dexf.transferFrom(reservior, address(this), payOut);
        totalPaidOut = totalPaidOut.add(payOut);
        paidOut[_msgSender()] = paidOut[_msgSender()].add(payOut);

        // send usdc to reservior
        usdc.transfer(reservior, amount);

        // send dexf to users
        dexf.transfer(_msgSender(), payOut);

        emit Deposited(_msgSender(), amount, payOut);
    }

    // check if address is contract
    function _isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}