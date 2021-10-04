pragma solidity >=0.5.0 <0.7.0;

import "./IERC20.sol";

interface IMdx is IERC20 {
  function mint(address to, uint256 amount) external returns (bool);
}
