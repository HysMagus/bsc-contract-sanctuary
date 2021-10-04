// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "./ERC20.sol";

contract StandardERC20 is ERC20 {
    constructor () public ERC20("Energy Ball Token", "EBT") {
        _mint(msg.sender, 100000 * (10 ** uint256(decimals())));
    }
}