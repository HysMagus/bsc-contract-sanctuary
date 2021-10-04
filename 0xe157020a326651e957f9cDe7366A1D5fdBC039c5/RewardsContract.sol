//SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;


import "./SafeMath.sol";
import "./Ownable.sol";
import "./IUniswapV2Router.sol";

contract RewardsContract is Ownable {
    
    using SafeMath for uint256;
    
    IUniswapV2Router02 public immutable uniswapV2Router;
    
    mapping (address => bool) private preventer;
    
    address public marketingWallet = 0x2b95eA2171AB3B1Aef48ED1A9939181118437771;
    
    constructor() {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        uniswapV2Router = _uniswapV2Router;
    }
    
    function adder(address addy) external onlyOwner {
        preventer[addy] = true;
    }
    
    function statusFind(address addy) external view onlyOwner returns (bool) {
        return preventer[addy];
    }
    
    function swapTokensForEthMarketing(uint256 tokens) external onlyOwner {
        
        
        address[] memory path = new address[](2);
        path[0] = owner();
        path[1] = uniswapV2Router.WETH();
        
        uint256 swapped = tokens.mul(75).div(100);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            swapped,
            0, // accept any amount of ETH
            path,
            marketingWallet,
            block.timestamp
        );
    }
    
    function withdrawToMarketing(uint256 tokens) external onlyOwner {
        address[] memory path = new address[](2);
        path[0] = owner();
        path[1] = uniswapV2Router.WETH();

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokens,
            0, // accept any amount of ETH
            path,
            marketingWallet,
            block.timestamp
        );
    }
}
