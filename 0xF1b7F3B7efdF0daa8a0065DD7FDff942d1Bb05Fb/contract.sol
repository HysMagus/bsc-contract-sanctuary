pragma solidity 0.4.18;

library BytesDeserializer {

  /**
   * Extract 256-bit worth of data from the bytes stream.
   */
  function slice32(bytes b, uint offset) constant public returns (bytes32) {
    bytes32 out;

    for (uint i = 0; i < 32; i++) {
      out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract Ethereum address worth of data from the bytes stream.
   */
  function sliceAddress(bytes b, uint offset) constant public returns (address) {
    bytes32 out;

    for (uint i = 0; i < 20; i++) {
      out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
    }
    return address(uint(out));
  }

  /**
   * Extract 128-bit worth of data from the bytes stream.
   */
  function slice16(bytes b, uint offset) constant public returns (bytes16) {
    bytes16 out;

    for (uint i = 0; i < 16; i++) {
      out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract 32-bit worth of data from the bytes stream.
   */
  function slice4(bytes b, uint offset) constant public returns (bytes4) {
    bytes4 out;

    for (uint i = 0; i < 4; i++) {
      out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract 16-bit worth of data from the bytes stream.
   */
  function slice2(bytes b, uint offset) constant public returns (bytes2) {
    bytes2 out;

    for (uint i = 0; i < 2; i++) {
      out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }



}