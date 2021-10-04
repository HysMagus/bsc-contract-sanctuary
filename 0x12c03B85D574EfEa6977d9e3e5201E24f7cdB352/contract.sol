// SPDX-License-Identifier: agpl-3.0


// File: contracts/interfaces/ILendingRateOracle.sol

pragma solidity ^0.5.0;

/**
 * @title ILendingRateOracle interface
 * @notice Interface for the Multiplier borrow rate oracle. Provides the average
 * market borrow rate to be used as a base for the stable borrow rate
 * calculations
 **/

interface ILendingRateOracle {
    /**
    @dev returns the market borrow rate in ray
    **/
    function getMarketBorrowRate(address _asset)
        external
        view
        returns (uint256);

    /**
    @dev sets the market borrow rate. Rate value must be in ray
    **/
    function setMarketBorrowRate(address _asset, uint256 _rate) external;
}

// File: contracts/mocks/oracle/LendingRateOracle.sol

pragma solidity ^0.5.0;


contract LendingRateOracle is ILendingRateOracle {
    mapping(address => uint256) borrowRates;
    mapping(address => uint256) liquidityRates;

    function getMarketBorrowRate(address _asset)
        external
        view
        returns (uint256)
    {
        return borrowRates[_asset];
    }

    function setMarketBorrowRate(address _asset, uint256 _rate) external {
        borrowRates[_asset] = _rate;
    }

    function getMarketLiquidityRate(address _asset)
        external
        view
        returns (uint256)
    {
        return liquidityRates[_asset];
    }

    function setMarketLiquidityRate(address _asset, uint256 _rate) external {
        liquidityRates[_asset] = _rate;
    }
}