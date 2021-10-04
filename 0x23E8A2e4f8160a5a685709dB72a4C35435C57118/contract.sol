// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

interface IMatatakiAddressRegistry {
    function isAdmin(address) external returns (bool);
    function isInBlacklist(address) external returns (bool);
}

contract MatatakiAddressRegistry {
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isInBlacklist;
    event Enlist(
        address indexed operator,
        uint256 indexed datetime,
        address[] list
    );
    event Delist(
        address indexed operator,
        uint256 indexed datetime,
        address[] list
    );
    event HandoverAdmin(address from, address to);

    constructor() public {
        isAdmin[msg.sender] = true;
    }

    modifier onlyAdmins() {
        require(isAdmin[msg.sender], "You're not the admin");
        _;
    }

    function handoverPermission(address to) public onlyAdmins {
        isAdmin[to] = true;
        isAdmin[msg.sender] = false;
        emit HandoverAdmin(msg.sender, to);
    }

    function revoke(address who) public onlyAdmins {
        isAdmin[who] = false;
    }

    function setAdmin(address _new) public onlyAdmins {
        isAdmin[_new] = true;
    }

    function enlistPeoples(address[] memory list) public onlyAdmins {
        for (uint8 i = 0; i < list.length; i++) {
            address who = list[i];
            isInBlacklist[who] = true;
        }
        emit Enlist(msg.sender, block.timestamp, list);
    }

    function delistPeoples(address[] memory list) public onlyAdmins {
        for (uint8 i = 0; i < list.length; i++) {
            address who = list[i];
            isInBlacklist[who] = false;
        }
        emit Delist(msg.sender, block.timestamp, list);
    }
}