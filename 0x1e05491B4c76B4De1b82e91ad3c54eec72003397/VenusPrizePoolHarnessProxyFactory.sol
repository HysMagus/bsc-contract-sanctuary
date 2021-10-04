pragma solidity >=0.6.0 <0.7.0;

import "./VenusPrizePoolHarness.sol";
import "../external/openzeppelin/ProxyFactory.sol";

/// @title Venus Prize Pool Proxy Factory
/// @notice Minimal proxy pattern for creating new Venus Prize Pools
contract VenusPrizePoolHarnessProxyFactory is ProxyFactory {
    /// @notice Contract template for deploying proxied Prize Pools
    VenusPrizePoolHarness public instance;

    /// @notice Initializes the Factory with an instance of the Venus Prize Pool
    constructor() public {
        instance = new VenusPrizePoolHarness();
    }

    /// @notice Creates a new Venus Prize Pool as a proxy of the template instance
    /// @return A reference to the new proxied Venus Prize Pool
    function create() external returns (VenusPrizePoolHarness) {
        return VenusPrizePoolHarness(deployMinimal(address(instance), ""));
    }
}
