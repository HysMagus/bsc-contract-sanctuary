// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BurnableBEP20.sol";
import "./CappedBEP20.sol";
import "./PausableBEP20.sol";
import "./SimpleBEP20.sol";

/**
 * @dev Token for Venture Capital Group.
 */
contract CapitalVentureGroupToken is CappedBEP20, BurnableBEP20, PausableBEP20, SimpleBEP20 {
    uint256 constant INITIAL_SUPPLY = 1000e18;
    uint256 constant MAX_SUPPLY = 5000e18;

    /**
     * @dev Construct the contract with the token name, symbol and supply.
     */
    constructor()
        SimpleBEP20("Capital Venture Group Token (Test)", "CVGTEST", INITIAL_SUPPLY)
        CappedBEP20(MAX_SUPPLY)
    {}

    /**
     * @dev See {BEP20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - Minted tokens must not cause the total supply to go over the cap.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    )
        internal virtual override(BEP20, PausableBEP20)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
