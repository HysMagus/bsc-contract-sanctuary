// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import {Ownable} from "./Ownable.sol";
import {IBEP20} from "./IBEP20.sol";
import {ISyrup} from "./ISyrup.sol";

contract Stacker is Ownable {
  ISyrup internal constant _pool = ISyrup(0xc3693e3cbc3514d5d07EA5b27A721F184F617900);
  IBEP20 internal constant _comp = IBEP20(0x52CE071Bd9b1C4B00A0b92D298c512478CaD67e8);
  IBEP20 internal constant _cake = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
  uint256 internal _amount;

  constructor(uint256 amount_) {
    _amount = amount_;
  }

  function deposit() external onlyOwner {
    _comp.approve(address(_pool), _amount);
    _pool.deposit(_amount);
  }

  function withdraw(address to) external onlyOwner {
    _pool.withdraw(_amount);
    _comp.transfer(to, _comp.balanceOf(address(this)));
    _cake.transfer(to, _cake.balanceOf(address(this)));
  }

  function emergencyWithdraw(address to) external onlyOwner {
    _pool.emergencyWithdraw();
    _comp.transfer(to, _comp.balanceOf(address(this)));
    _cake.transfer(to, _cake.balanceOf(address(this)));
  }

  function claimRewards(address to) external onlyOwner {
    _pool.deposit(0);
    _cake.transfer(to, _cake.balanceOf(address(this)));
  }
}
