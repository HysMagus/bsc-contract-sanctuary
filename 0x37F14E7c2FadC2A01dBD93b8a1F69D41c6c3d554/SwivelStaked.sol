// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// SwivelStaked is the coolest bar in town. You come in with some Reward, and leave with more! The longer you stay, the more Reward you get.
//
// This contract handles swapping to and from xReward, AMMSwap's staking token.
contract SwivelStaked is ERC20("xSwivelStaked", "xSVL"){
    using SafeMath for uint256;
    IERC20 public reward;

    // Define the Reward token contract
    constructor(IERC20 _reward) public {
        reward = _reward;
    }

    // Enter the bar. Pay some REWARDs. Earn some shares.
    // Locks Reward and mints xReward
    function enter(uint256 _amount) public {
        // Gets the amount of Reward locked in the contract
        uint256 totalReward = reward.balanceOf(address(this));
        // Gets the amount of xReward in existence
        uint256 totalShares = totalSupply();
        // If no xReward exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalReward == 0) {
            _mint(msg.sender, _amount);
        } 
        // Calculate and mint the amount of xReward the Reward is worth. The ratio will change overtime, as xReward is burned/minted and Reward deposited + gained from fees / withdrawn.
        else {
            uint256 what = _amount.mul(totalShares).div(totalReward);
            _mint(msg.sender, what);
        }
        // Lock the Reward in the contract
        reward.transferFrom(msg.sender, address(this), _amount);
    }

    function getExchangeRate() public view returns (uint256) {
        return (reward.balanceOf(address(this)) * 1e18) / totalSupply();
    }

    function toREWARD(uint256 stakedAmount) public view returns (uint256 rewardAmount) {
        rewardAmount = (stakedAmount * reward.balanceOf(address(this))) / totalSupply();
    }

    function toSTAKED(uint256 rewardAmount) public view returns (uint256 stakedAmount) {
        stakedAmount = (rewardAmount * totalSupply()) / reward.balanceOf(address(this));
    }


    // Leave the bar. Claim back your REWARDs.
    // Unlocks the staked + gained Reward and burns xReward
    function leave(uint256 _share) public {
        // Gets the amount of xReward in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of Reward the xReward is worth
        uint256 what = _share.mul(reward.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        reward.transfer(msg.sender, what);
    }
}
