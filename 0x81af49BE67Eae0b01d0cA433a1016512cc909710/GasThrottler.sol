// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "./IGasPrice.sol";

abstract contract GasThrottler {
    address public gasprice;

    constructor(address _gasPrice) internal {
        gasprice = _gasPrice;
    }

    modifier gasThrottle() {
        require(tx.gasprice <= IGasPrice(gasprice).maxGasPrice(), "gas is too high!");
        _;
    }
}
