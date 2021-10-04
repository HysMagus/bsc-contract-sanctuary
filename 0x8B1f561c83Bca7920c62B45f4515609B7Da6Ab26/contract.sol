// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

interface IBandOracleAggregator {
    function getReferenceData(string[] memory pairs)
    external
    returns (uint256[] memory);
}

contract BandOracleAggregatorProxy is IBandOracleAggregator{
    IBandOracleAggregator public aggregator;
    
    constructor(IBandOracleAggregator _aggregator) public {
        aggregator = _aggregator;
    }
    
    function setAggregator(IBandOracleAggregator _aggregator) public {
        aggregator = _aggregator;
    }
    
    function getReferenceData(string[] memory pairs)
    external
    override
    returns (uint256[] memory) {
        return aggregator.getReferenceData(pairs);
    }
}