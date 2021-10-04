// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BEP20.sol";
import "./Ownable.sol";

/**
 * @title MintableBEP20
 * @dev Implementation of the MintableBEP20. Extension of {BEP20} that adds a minting behaviour.
 */
abstract contract MintableBEP20 is BEP20, Ownable {
    /**
     * @dev Function to mint tokens to the message sender.
     *
     * @param amount The amount of tokens to mint
     */
    function mint(uint256 amount) public virtual onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }
}
