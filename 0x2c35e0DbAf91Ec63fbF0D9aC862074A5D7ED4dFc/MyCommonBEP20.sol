// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./Ownable.sol";
import "./BEP20Capped.sol";
import "./BEP20Mintable.sol";
import "./BEP20Burnable.sol";

/**
 * @title CommonBEP20
 * @dev Implementation of the CommonBEP20
 */
contract MyCommonBEP20 is BEP20Capped, BEP20Mintable, BEP20Burnable {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 cap,
        uint256 initialBalance
    ) payable BEP20(name, symbol) BEP20Capped(cap) {
        _setupDecimals(decimals);
        _mint(_msgSender(), initialBalance);
    }

    /**
     * @dev Function to mint tokens.
     *
     * NOTE: restricting access to owner only. See {BEP20Mintable-mint}.
     *
     * @param account The address that will receive the minted tokens
     * @param amount The amount of tokens to mint
     */
    function _mint(address account, uint256 amount)
        internal
        override
        onlyOwner
    {
        super._mint(account, amount);
    }

    /**
     * @dev Function to stop minting new tokens.
     *
     * NOTE: restricting access to owner only. See {BEP20Mintable-finishMinting}.
     */
    function _finishMinting() internal override onlyOwner {
        super._finishMinting();
    }

    /**
     * @dev See {BEP20-_beforeTokenTransfer}. See {BEP20Capped-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(BEP20, BEP20Capped) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
