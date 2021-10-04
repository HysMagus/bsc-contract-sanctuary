
pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";


contract Token is ERC20, ERC20Detailed {

  
    constructor () public ERC20Detailed("XTHB", "XTHB", 2) {
        _mint(msg.sender, 98956687635976 * (10 ** uint256(decimals())));
    }
}