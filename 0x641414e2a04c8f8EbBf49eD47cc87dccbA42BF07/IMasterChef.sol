// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

interface IMasterChef {
    function depositTo(uint256 _pid, uint256 _amount, address _to) external;
}