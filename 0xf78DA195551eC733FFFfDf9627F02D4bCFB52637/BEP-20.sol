// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract Cucumber is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Cucumber", "CUC") {
        _mint(msg.sender, initialSupply);
    }
}