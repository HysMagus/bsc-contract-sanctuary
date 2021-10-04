// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BEP20.sol";
import "./Ownable.sol";

/**
 * @title BurnableBEP20
 * @dev Implementation of the BurnableBEP20. Extension of {BEP20} that adds a burning behaviour.
 */
abstract contract BurnableBEP20 is BEP20, Ownable {
    /**
     * @dev Function to burn tokens from the sender address.
     *
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) public onlyOwner {
        _burn(_msgSender(), amount);
    }
}
