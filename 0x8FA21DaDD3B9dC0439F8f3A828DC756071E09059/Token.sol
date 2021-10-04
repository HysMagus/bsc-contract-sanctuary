// 0.5.1-c8a2
// Enable optimization
pragma solidity ^0.5.0;

import "./BEP20.sol";
import "./BEP20Detailed.sol";

/**
 * @title SimpleToken
 * @dev Very simple BEP20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `BEP20` functions.
 */
contract Centrin is BEP20, BEP20Detailed {

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public BEP20Detailed("Centrin", "CNTR", 8) {
        _mint(msg.sender, 21060000 * (10 ** uint256(decimals())));
    }
}