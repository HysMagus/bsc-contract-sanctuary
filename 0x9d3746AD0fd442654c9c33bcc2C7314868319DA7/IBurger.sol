pragma solidity >=0.6.4;

interface IBurger {
    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
}
