pragma solidity ^0.4.26;

/**
 * @title BEP20Basic
 * @dev Simpler version of BEP20 interface
 */
contract BEP20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}