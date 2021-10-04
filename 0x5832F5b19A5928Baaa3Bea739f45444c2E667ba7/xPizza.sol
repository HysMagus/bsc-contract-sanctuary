// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "IERC20.sol";
import "Context.sol";
import "SafeMath.sol";
import "Address.sol";
import "ERC20.sol";

contract PizzaBar is ERC20("PizzaBar", "xPIZZA"){
    using SafeMath for uint256;
    IERC20 public pizza;

    constructor(IERC20 _pizza) public {
        pizza = _pizza;
    }

    // Enter the bar. Pay some PIZZAs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalPizza = pizza.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalPizza == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalPizza);
            _mint(msg.sender, what);
        }
        pizza.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your PIZZAs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(pizza.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        pizza.transfer(msg.sender, what);
    }
}