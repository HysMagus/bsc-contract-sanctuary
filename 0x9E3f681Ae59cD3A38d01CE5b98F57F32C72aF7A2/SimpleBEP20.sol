// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BEP20.sol";

/**
 * @title SimpleBEP20
 * @dev Implementation of the SimpleBEP20. Extension of {BEP20} that adds an initial supply and with fixed 18 decimals.
 */
abstract contract SimpleBEP20 is BEP20 {

    constructor (
        string memory name,
        string memory symbol,
        uint256 initialSupply
    )
        BEP20(name, symbol, 18)
    {
        require(initialSupply > 0, "SimpleBEP20: initial supply shall be greater than zero");

        _mint(_msgSender(), initialSupply);
    }
}
