// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

interface IGooseIncubatorChef {

    struct PoolInfo {
        address lpToken;                 // Address of LP token contract.
        uint256 allocPoint;             // How many allocation points assigned to this pool. GOOSEs to distribute per block.
        uint256 lastRewardBlock;        // Last block number that GOOSEs distribution occurs.
        uint256 accGoosePerShare;       // Accumulated GOOSEs per share, times 1e12. See below.
        uint256 depositFeeBP;           // Deposit fee in basis points
        uint256 maxDepositAmount;       // Maximum deposit quota (0 means no limit)
        uint256 currentDepositAmount;   // Current total deposit amount in this pool
    }

    struct UserInfo {
        uint256 amount;         // How many LP tokens the user has provided.
        uint256 rewardDebt;     // Reward debt. See explanation below.
    }

    function goose() external view returns (address);

    function poolInfo(uint256 poolId) external view returns (PoolInfo memory);

    function userInfo(uint256 poolId, address user) external view returns (UserInfo memory);

    function pendingGoose(uint256 _pid, address _user) external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

}
