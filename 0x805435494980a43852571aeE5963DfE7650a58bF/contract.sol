pragma solidity 0.6.12;

// SPDX-License-Identifier: MIT


contract TimelockUitls {
    

    function addDecorder(
        bytes memory data
    ) public pure returns  (uint256,address,uint16,bool)  {
        return abi.decode(data, (uint256,address,uint16,bool));
    }
    
    function delayDecorder(
        bytes memory data
    ) public pure returns (uint256) {
        return abi.decode(data, (uint256));
    }
    
    function emissionDecorder(
        bytes memory data
    ) public pure returns (uint256) {
        return abi.decode(data, (uint256));
    }

}