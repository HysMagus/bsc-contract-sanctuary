// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import {IBEP20} from "./IBEP20.sol";

struct UserInfo {
  uint256 amount;
  uint256 rewardDebt;
}

struct PoolInfo {
  IBEP20 lpToken;
  uint256 allocPoint;
  uint256 lastRewardBlock;
  uint256 accCakePerShare;
}

interface ISyrup {
  event Deposit(address indexed user, uint256 amount);
  event Withdraw(address indexed user, uint256 amount);
  event EmergencyWithdraw(address indexed user, uint256 amount);

  function stopReward() external;

  function getMultiplier(uint256 _from, uint256 _to) external view returns (uint256);

  // View function to see pending Reward on frontend.
  function pendingReward(address _user) external view returns (uint256);

  // Update reward variables of the given pool to be up-to-date.
  function updatePool(uint256 _pid) external;

  // Update reward variables for all pools. Be careful of gas spending!
  function massUpdatePools() external;

  // Stake SYRUP tokens to SmartChef
  function deposit(uint256 _amount) external;

  // Withdraw SYRUP tokens from STAKING.
  function withdraw(uint256 _amount) external;

  // Withdraw without caring about rewards. EMERGENCY ONLY.
  function emergencyWithdraw() external;

  // Withdraw reward. EMERGENCY ONLY.
  function emergencyRewardWithdraw(uint256 _amount) external;

  function userInfo(address user) external view returns (UserInfo memory);
}
