pragma solidity ^0.6.0;

contract Owned {
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

interface ERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function mint(address to, uint256 amount) external;
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Expand is Owned {
    using SafeMath for uint256;

    uint256 public lastTimeExecuted;
    
    uint256 private constant TIME_OFFSET = 864000;

    address public constant THIRM = 0x21Da60B286BaEfD4725A41Bb50a9237eb836a9Ed;

    constructor() public {
        lastTimeExecuted = block.timestamp - TIME_OFFSET - TIME_OFFSET;
    }

    function kill(address inputcontract) public onlyOwner {
        uint256 inputcontractbal =
            ERC20(inputcontract).balanceOf(address(this));
        ERC20(inputcontract).transfer(owner, inputcontractbal);
    }

    function timeForNextExecution() public view returns (uint256) {
        return lastTimeExecuted.add(TIME_OFFSET);
    }

    function start() public {
        require(
            lastTimeExecuted.add(TIME_OFFSET) < block.timestamp,
            "Cannot execute the start function."
        );

        // update timestamp
        lastTimeExecuted = block.timestamp;

        // Mint Thirm
        uint256 thirmTotalSupply = ERC20(THIRM).totalSupply();
        uint256 minted = thirmTotalSupply.div(1000);
        ERC20(THIRM).mint(address(this), minted);

    }
}