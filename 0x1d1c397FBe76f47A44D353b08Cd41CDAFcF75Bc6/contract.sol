// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @author sirbeefalot
 * @dev useful to fetch BNB balance as part of a multicall next to other BEP20 token balances.
 */ 
contract BalanceProxyBNB {
    function  balanceOf(address _address) external view returns (uint256) {
        return _address.balance;
    }
}