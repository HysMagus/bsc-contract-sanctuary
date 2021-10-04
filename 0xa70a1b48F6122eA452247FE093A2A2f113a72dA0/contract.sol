// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;


contract BlockTimestamp {
    
    function getTimestamp() public view returns (uint256) {
        return block.timestamp + 24 hours + 3 minutes;
    }
    
}