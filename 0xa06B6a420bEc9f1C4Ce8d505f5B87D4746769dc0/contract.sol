/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


interface IBandOracleAggregator {
    function getReferenceData(string[] memory pairs) external view returns (uint256[] memory);
}


contract BandBNBBUSDPriceOracleProxy {
    IBandOracleAggregator public aggregator;

    constructor(IBandOracleAggregator _aggregator) public {
        aggregator = _aggregator;
    }

    function getPrice() public view returns (uint256) {
        uint256[] memory rates;
        string[] memory pairs = new string[](1);
        pairs[0] = "BNB/USD";
        rates = aggregator.getReferenceData(pairs);
        return rates[0];
    }
}