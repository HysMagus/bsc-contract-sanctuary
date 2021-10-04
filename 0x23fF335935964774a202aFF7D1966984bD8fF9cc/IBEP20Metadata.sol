// SPDX-License-Identifier: MIT
import "./IBEP20.sol";

pragma solidity ^0.8.0;

interface IBEP20Metadata is IBEP20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}
