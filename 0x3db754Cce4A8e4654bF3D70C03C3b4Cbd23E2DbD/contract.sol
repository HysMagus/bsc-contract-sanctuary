// "SPDX-License-Identifier: UNLICENSED"

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

contract Mapping is Owned {
    mapping(string => address) public addressMap;

    address public constant THIRM = 0x21Da60B286BaEfD4725A41Bb50a9237eb836a9Ed;
    uint256 public BURN_AMOUNT = 100000000000000000;

    function setBurnAmount(uint256 _amount) public onlyOwner {
        BURN_AMOUNT = _amount;
    }

    function setAddressMap(string memory _coinaddress) public {
        require(
            addressMap[_coinaddress] == address(0),
            "Address already mapped"
        );
        require(
            BURN_AMOUNT <= ERC20Burnable(THIRM).balanceOf(msg.sender),
            "No balance"
        );
        require(
            BURN_AMOUNT <=
                ERC20Burnable(THIRM).allowance(msg.sender, address(this)),
            "No allowance"
        );

        ERC20Burnable(THIRM).burnFrom(msg.sender, BURN_AMOUNT);
        addressMap[_coinaddress] = msg.sender;
    }
}