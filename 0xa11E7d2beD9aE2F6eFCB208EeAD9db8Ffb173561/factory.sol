// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "library.sol";
import "option.sol";
import "poolerToken.sol";

/**
 * @title A factory to create new Option
 * OptionFactory
 */
contract PandaFactory is IPandaFactory {
    function createOption(uint duration_, uint8 decimals_, IOptionPool poolContract) external override
        returns (IOption option) {
        return new Option(duration_, decimals_, poolContract);
    }
    
    function createPoolerToken(uint8 decimals_, IOptionPool poolContract) external override returns (IPoolerToken poolerToken) {
        return new PoolerToken(decimals_, poolContract);
    }
}