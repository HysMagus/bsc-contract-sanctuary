// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IVBNB {
    function balanceOfUnderlying(address _account) external returns (uint);
    function borrowBalanceCurrent(address _account) external returns (uint);
}

contract Audit {
    uint public borrowCurrent;
    uint public underlyingCurrent;
    
    address public vbnb = address(0xA07c5b74C9B40447a954e1466938b865b6BBea36);
    address public strat = address(0x3B5b3640096a5381e7378a013069C4ef925D78ec);
    
    function getBorrowCurrent() public {
        borrowCurrent = IVBNB(vbnb).borrowBalanceCurrent(strat);
    }
    
    function getBalanceOfUnderlying() public {
        underlyingCurrent = IVBNB(vbnb).balanceOfUnderlying(strat);
    }
}