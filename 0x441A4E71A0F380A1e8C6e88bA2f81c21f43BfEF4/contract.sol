pragma solidity >=0.4.22 <0.8.0;

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    function TokensPurchased(address buyer, uint256 amount) external  returns (bool success);
    function burn(uint256 _value) external returns (bool success);
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

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

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0x922df891eef0d5042298b3abaf63bc460864050807706af0cc3cab556d2802eb;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeBEP20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IBEP20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        
        _notEntered = true;
    }

    
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        
        _notEntered = true;
    }
}

contract REDI_CROWDSALE is Context, ReentrancyGuard{
    
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    address public governance;
    
    uint256 public rate;
    uint256 private _weiRaised;
    uint256 public totalSold;
    IBEP20 public tokenAddress;
    uint256 public startTime = 1614934800; // 05 March 2021 (GMT-09:00)
    uint256 public endTime = 1615010400; // 06 March 2021 (GMT-06:00)
    
    uint256 public minimumBuyAmount = 1 ether;
    uint256 public maximumBuyAmount = 20 ether;
    address payable public walletAddress;
    event TokensPurchased(address indexed to, uint256 amount);
    
    constructor () public {
        governance = tx.origin;
        rate = uint256(800);
        walletAddress =0xD91f909Eb61e54eb86E2F343F72b9159D1d6f2b2; //TEAM
        tokenAddress = IBEP20(0x0);
    }
    
    function () external payable {
        buy();
    }
    
    function changeWallet (address payable _walletAddress) private {
        require(msg.sender == governance, "!governance");
        walletAddress = _walletAddress;
    }
    
    function setToken(IBEP20 _tokenAddress) public {
        require(msg.sender == governance, "!governance");
        tokenAddress = _tokenAddress;
    }
    
    function buy() public payable {
        require((block.timestamp > startTime ) && (block.timestamp < endTime)  , "REDI Token's Crowdsale is not active");
        uint256 weiValue = msg.value;
        require((weiValue >= minimumBuyAmount) &&(weiValue<= maximumBuyAmount), "Minimum amount is 01 BNB and Maximum amount is 20 BNB");
        uint256 amount = weiValue.mul(rate);
        _weiRaised = _weiRaised.add(weiValue);
        IBEP20 token = IBEP20(tokenAddress);
        token.safeTransfer(msg.sender, amount);
        walletAddress.transfer(weiValue);
        //require(walletAddress.send(weiValue)); //_fundRaisingWallet.transfer(msg.value);
        require(token.TokensPurchased(msg.sender, amount));
        totalSold += amount;
        emit TokensPurchased(msg.sender, amount);
    }
    
    function burnUnsold() public {
        require(msg.sender == governance, "!governance");
        require((block.timestamp > endTime), "Crowdsate is still active");
        IBEP20 token = IBEP20(tokenAddress);
        uint256 amount = token.balanceOf(address(this));
        token.burn(amount);
    }
}