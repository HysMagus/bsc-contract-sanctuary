// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./BEP20.sol";
import "./Ownable.sol";
import "./Pausable.sol";

/**
 * @dev BEP20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract PausableBEP20 is BEP20, Pausable, Ownable {
    /**
     * @dev Function to pause the contract.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Function to unpause the contract.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev See {BEP20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    )
        internal virtual override
    {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "BEP20Pausable: token transfer while paused");
    }
}
