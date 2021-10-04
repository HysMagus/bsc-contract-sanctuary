// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

contract TestContract {

    uint256 public openTime;
    
    constructor (uint256 _openTime) public {
        openTime = _openTime;
    }
    
    function setOpenTime(uint256 _openTime) public {
        require(_openTime > 0);
        openTime = _openTime;
    }
    
    function getOpenTime() public view returns (uint256) {
        return openTime;
    }
    
    function invest() public payable {
        require(block.timestamp >= openTime, "Not yet opened");
    }
}