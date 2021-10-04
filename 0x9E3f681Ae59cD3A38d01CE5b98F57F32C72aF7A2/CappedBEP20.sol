// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MintableBEP20.sol";

/**
 * @dev Extension of {MintableBEP20} that adds a cap to the supply of tokens.
 */
abstract contract CappedBEP20 is MintableBEP20 {
    uint256 private _maxSupply;

    /**
     * @dev Sets the value of the `_maxSupply`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor (uint256 maxSupply_) {
        require(maxSupply_ > 0, "CappedBEP20: maximum supply is 0");
        _maxSupply = maxSupply_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function maxSupply() public view virtual returns (uint256) {
        return _maxSupply;
    }

    /**
     * @dev See {BEP20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - Minted tokens must not cause the total supply to go over the cap.
     */
    function mint(uint256 amount) public virtual override onlyOwner returns (bool) {
        require(totalSupply() + amount <= maxSupply(), "CappedBEP20: maximum supply exceeded");
        super.mint(amount);

        return true;
    }
}
