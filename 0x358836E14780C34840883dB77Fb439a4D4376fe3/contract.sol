/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IChainlink {
    function latestAnswer() external view returns (uint256);
}

contract ChainlinkBNBPriceOracleProxy {
    address public chainlink = 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE;

    function getPrice() external view returns (uint256) {
        return IChainlink(chainlink).latestAnswer() * 10000000000;
    }
}