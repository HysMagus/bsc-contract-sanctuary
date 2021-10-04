// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "library.sol";

contract AggregateUpdater {
    IOptionPool [] public pools;
    address public _owner;
    
    constructor() public {
        _owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "AggregateUpdater: need owner");
        _;
    }
    
    /**
     * @dev return the earliest update time from all pools
     */
    function getNextUpdateTime() external view returns (uint) {
        uint nextUpdateTime = block.timestamp + 3600;
        for (uint i=0;i<pools.length;i++) {
            if (pools[i].getNextUpdateTime() < nextUpdateTime) {
                nextUpdateTime = pools[i].getNextUpdateTime();
            }
        }
        return nextUpdateTime;
    }
    
    /**
     * @dev update the expired pools
     */
    function update() external {
        IOptionPool [] memory mempools = pools;
        for (uint i=0;i<mempools.length;i++) {
            if (mempools[i].getNextUpdateTime() < block.timestamp) {
                mempools[i].update();  
            }
        }
    }
    
    function addPools(IOptionPool [] memory newPools) external onlyOwner {
        for (uint i=0;i<newPools.length;i++) {
            removePool(newPools[i]);
            pools.push(newPools[i]);
        }
    }

    function removePool(IOptionPool pool) public onlyOwner {
        for (uint i=0;i<pools.length;i++) {
            if (pools[i] == pool) {
                pools[i] = pools[pools.length - 1];
                pools.pop();
                return;
            }
        }
    }
    
    function clearPools() public onlyOwner {
        delete pools;
    }
}