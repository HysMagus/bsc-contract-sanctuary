// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import {Ownable} from "./Ownable.sol";
import {Stacker} from "./Stacker.sol";
import {IBEP20} from "./IBEP20.sol";
import {ISyrup} from "./ISyrup.sol";

contract CStack is Ownable {
  ISyrup internal constant _pool = ISyrup(0xc3693e3cbc3514d5d07EA5b27A721F184F617900);
  IBEP20 internal constant _comp = IBEP20(0x52CE071Bd9b1C4B00A0b92D298c512478CaD67e8);

  uint256 public amount = 10**18;
  address[] public pools;

  function deposit(uint256 _amount) external onlyOwner {
    for (uint256 index = 0; index < _amount; index++) {
      address stacker = address(new Stacker(amount));
      _comp.transferFrom(_msgSender(), stacker, 10**18);
      pools.push(stacker);
      Stacker(stacker).deposit();
    }
  }

  function withdraw() external onlyOwner {
    for (uint256 index = 0; index < pools.length; index++) {
      Stacker(pools[index]).withdraw(_msgSender());
    }

    pools = new address[](0);
  }

  function emergencyWithdraw() external onlyOwner {
    for (uint256 index = 0; index < pools.length; index++) {
      Stacker(pools[index]).emergencyWithdraw(_msgSender());
    }

    pools = new address[](0);
  }

  function claimRewards() external onlyOwner {
    for (uint256 index = 0; index < pools.length; index++) {
      Stacker(pools[index]).claimRewards(_msgSender());
    }
  }

  function setAmount(uint256 newAmount) external onlyOwner {
    amount = newAmount;
  }

  function getClaim() external view returns (uint256 claim) {
    for (uint256 index = 0; index < pools.length; index++) {
      claim = claim + _pool.pendingReward(pools[index]);
    }
  }

  function getAmount() external view returns (uint256 totalAmount) {
    for (uint256 index = 0; index < pools.length; index++) {
      totalAmount = totalAmount + _pool.userInfo(pools[index]).amount;
    }
  }

  function totalPools() external view returns (uint256) {
    return pools.length;
  }
}
