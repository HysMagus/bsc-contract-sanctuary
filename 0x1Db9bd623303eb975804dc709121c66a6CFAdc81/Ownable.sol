// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
abstract contract Ownable {
    address public owner;

    event TransferOwnership(address indexed previousOwner, address indexed newOwner);

    modifier restricted {
        require(msg.sender == owner, "This function is restricted to owner");
        _;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transferOwnership(address _newOwner) public restricted {
        require(_newOwner != address(0), "Invalid address: should not be 0x0");
        emit TransferOwnership(owner, _newOwner);
        owner = _newOwner;
    }

    constructor() {
        owner = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }
}
