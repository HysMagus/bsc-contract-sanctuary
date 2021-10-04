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

interface ERC20Burnable {
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

    function burnFrom(address account, uint256 amount) external;
}

contract Controller is Owned {
    mapping(string => ERC20Burnable) public tokens;
    mapping(string => bool) public transaction;

    struct QueueBlock {
        string coin;
        string addr;
        uint256 amount;
        bool success;
    }

    QueueBlock[] public userWithdraws;

    function setTxn(string memory _txn) public onlyOwner {
        transaction[_txn] = true;
    }

    function registerWithdrawal(
        string memory _coin,
        string memory _address,
        uint256 _amount
    ) public returns (uint256 arrayLength) {
        require(_amount <= tokens[_coin].balanceOf(msg.sender), "no balance");
        require(
            _amount <= tokens[_coin].allowance(msg.sender, address(this)),
            "no allowance"
        );

        tokens[_coin].burnFrom(msg.sender, _amount);

        QueueBlock memory m;
        m.coin = _coin;
        m.addr = _address;
        m.amount = _amount;
        m.success = false;

        userWithdraws.push(m);

        return userWithdraws.length;
    }

    function registerWithdrawalSuccess(uint256 _queue) public onlyOwner {
        userWithdraws[_queue].success = true;
    }

    function tTokenInit(string memory _coin, address _token) public onlyOwner {
        tokens[_coin] = ERC20Burnable(_token);
    }

    function mintCoin(
        string memory _coin,
        address _userAddress,
        uint256 _amount
    ) public onlyOwner {
        tokens[_coin].mint(_userAddress, _amount);
    }
}