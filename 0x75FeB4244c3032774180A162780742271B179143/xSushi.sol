// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "IERC20.sol";
import "Context.sol";
import "SafeMath.sol";
import "Address.sol";
import "ERC20.sol";

contract SushiBar is ERC20("SugarBar", "xSGR"){
    using SafeMath for uint256;
    IERC20 public sgr;

    constructor(IERC20 _sgr) public {
        sgr = _sgr;
    }

    // Enter the bar. Pay some SGRs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalSugar = sgr.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalSugar == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalSugar);
            _mint(msg.sender, what);
        }
        sgr.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your SGRs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(sgr.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        sgr.transfer(msg.sender, what);
    }
}