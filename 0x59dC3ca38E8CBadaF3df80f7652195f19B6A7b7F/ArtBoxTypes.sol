// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library ArtBoxTypes {
  /// @dev Main data structure for the token
  struct Box {
    uint256 id;
    bool locked;
    uint16 x;
    uint16 y;
    uint32[16][16] box;
    address minter;
    address locker;
  }
}
