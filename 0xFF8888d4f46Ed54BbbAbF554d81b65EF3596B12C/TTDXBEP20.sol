pragma solidity ^0.4.26;

import "./TTDXBEP20Basic.sol";

/**
 * @title BEP20 interface
 */
contract BEP20 is BEP20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}
