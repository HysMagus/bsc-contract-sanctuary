// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// LepGold is the coolest bar in town. You come in with some Sushi, and leave with more! The longer you stay, the more Sushi you get.
//
// This contract handles swapping to and from xSushi, SushiSwap's staking token.
contract LepGold is ERC20("GOLD Treasure", "GOLD"){
    using SafeMath for uint256;
    IERC20 public lep;

    // Define the gold token contract
    constructor(IERC20 _lep) public {
        lep = _lep;
    }

    // Enter the bar. Pay some golds. Earn some shares.
    // Locks gold and mints xgold
    function enter(uint256 _amount) public {
        // Gets the amount of gold locked in the contract
        uint256 totalLep = lep.balanceOf(address(this));
        // Gets the amount of xSushi in existence
        uint256 totalShares = totalSupply();
        // If no xSushi exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalLep == 0) {
            _mint(msg.sender, _amount);
        } 
        // Calculate and mint the amount of xSushi the Sushi is worth. The ratio will change overtime, as xSushi is burned/minted and Sushi deposited + gained from fees / withdrawn.
        else {
            uint256 what = _amount.mul(totalShares).div(totalLep);
            _mint(msg.sender, what);
        }
        // Lock the Sushi in the contract
        lep.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your SUSHIs.
    // Unlocks the staked + gained Sushi and burns xSushi
    function leave(uint256 _share) public {
        // Gets the amount of xSushi in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of Sushi the xSushi is worth
        uint256 what = _share.mul(lep.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        lep.transfer(msg.sender, what);
    }
}
