// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@pooltogether/fixed-point/contracts/FixedPoint.sol";

import "../../external/venus/VTokenInterface.sol";
import "../PrizePool.sol";

/// @title Prize Pool with Venus's VToken
/// @notice Manages depositing and withdrawing assets from the Prize Pool
contract VenusPrizePool is PrizePool {
    using SafeMathUpgradeable for uint256;

    event VenusPrizePoolInitialized(address indexed VToken);

    /// @notice Interface for the Yield-bearing VToken by Venus
    VTokenInterface public VToken;

    /// @notice Initializes the Prize Pool and Yield Service with the required contract connections
    /// @param _controlledTokens Array of addresses for the Ticket and Sponsorship Tokens controlled by the Prize Pool
    /// @param _maxExitFeeMantissa The maximum exit fee size, relative to the withdrawal amount
    /// @param _maxTimelockDuration The maximum length of time the withdraw timelock could be
    /// @param _vToken Address of the Venus VToken interface
    function initialize(
        RegistryInterface _reserveRegistry,
        ControlledTokenInterface[] memory _controlledTokens,
        uint256 _maxExitFeeMantissa,
        uint256 _maxTimelockDuration,
        VTokenInterface _vToken
    ) public initializer {
        PrizePool.initialize(
            _reserveRegistry,
            _controlledTokens,
            _maxExitFeeMantissa,
            _maxTimelockDuration
        );
        VToken = _vToken;

        emit VenusPrizePoolInitialized(address(VToken));
    }

    /// @dev Gets the balance of the underlying assets held by the Yield Service
    /// @return The underlying balance of asset tokens
    function _balance() internal override returns (uint256) {
        return VToken.balanceOfUnderlying(address(this));
    }

    /// @dev Allows a user to supply asset tokens in exchange for yield-bearing tokens
    /// to be held in escrow by the Yield Service
    /// @param amount The amount of asset tokens to be supplied
    function _supply(uint256 amount) internal override {
        _token().approve(address(VToken), amount);
        require(VToken.mint(amount) == 0, "VenusPrizePool/mint-failed");
    }

    /// @dev Checks with the Prize Pool if a specific token type may be awarded as a prize enhancement
    /// @param _externalToken The address of the token to check
    /// @return True if the token may be awarded, false otherwise
    function _canAwardExternal(address _externalToken)
        internal
        view
        override
        returns (bool)
    {
        return _externalToken != address(VToken);
    }

    /// @dev Allows a user to redeem yield-bearing tokens in exchange for the underlying
    /// asset tokens held in escrow by the Yield Service
    /// @param amount The amount of underlying tokens to be redeemed
    /// @return The actual amount of tokens transferred
    function _redeem(uint256 amount) internal override returns (uint256) {
        IERC20Upgradeable assetToken = _token();
        uint256 before = assetToken.balanceOf(address(this));
        require(
            VToken.redeemUnderlying(amount) == 0,
            "VenusPrizePool/redeem-failed"
        );
        uint256 diff = assetToken.balanceOf(address(this)).sub(before);
        return diff;
    }

    /// @dev Gets the underlying asset token used by the Yield Service
    /// @return A reference to the interface of the underling asset token
    function _token() internal view override returns (IERC20Upgradeable) {
        return IERC20Upgradeable(VToken.underlying());
    }
}
