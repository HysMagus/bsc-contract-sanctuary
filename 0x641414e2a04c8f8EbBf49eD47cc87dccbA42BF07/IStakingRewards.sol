// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

interface IStakingRewards {
    function stakeTo(uint256 amount, address _to) external;
}