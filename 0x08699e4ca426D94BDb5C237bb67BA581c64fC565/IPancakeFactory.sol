// SPDX-License-Identifier: GPL-2.0
pragma solidity =0.7.6;

interface IPancakeFactory {
    function getPair(address tokenA, address tokenB) external view returns (address);
}
