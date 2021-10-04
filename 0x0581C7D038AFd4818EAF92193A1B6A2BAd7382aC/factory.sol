// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "library.sol";
import "option.sol";
import "poolerToken.sol";

/**
 * @title A factory for common creation and configuration
 */
contract PandaFactory is IPandaFactory {
    address private _cdfContract; // cdf data contract;
    address private _usdtContract;
    
    constructor(address USDTContract, address CDFContract) public {
        _usdtContract = USDTContract;
        _cdfContract = CDFContract;
    }
    
    function createOption(uint duration_, uint8 decimals_, IOptionPool poolContract) external override
        returns (IOption option) {
        return new Option(duration_, decimals_, poolContract);
    }
    
    function createPoolerToken(uint8 decimals_, IOptionPool poolContract) external override returns (IPoolerToken poolerToken) {
        return new PoolerToken(decimals_, poolContract);
    }
    
    function getCDF() external view override returns(address) {
        return _cdfContract;
    }

    function getUSDTContract() external view override returns(address) {
        return _usdtContract;
    }
}