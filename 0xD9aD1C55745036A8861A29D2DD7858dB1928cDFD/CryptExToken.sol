// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import "./ERC20.sol";

contract CryptExToken is ERC20("CryptEx Token", "CRX") {

    constructor() {
        _mint(address(msg.sender), 1e23);
    }

}