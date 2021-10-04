
pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";


contract Token is ERC20, ERC20Detailed {

  
    constructor () public ERC20Detailed("MUNZE", "MZE", 2) {
        _mint(msg.sender, 168000000000 * (10 ** uint256(decimals())));
    }
}