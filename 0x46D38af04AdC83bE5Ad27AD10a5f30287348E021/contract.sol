pragma solidity ^0.8.6;
//SPDX-License-Identifier: GNU General Public License v3.0

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BudsLocker {

    address buds;
    address shafinRizvi;
    address ryanDerek;

    uint lastPayDay;
    
    constructor (address budsAddress, address shafinRizviAddress, address ryanDerekAddress) {

        require(budsAddress != address(0));
        require(shafinRizviAddress != address(0));
        require(ryanDerekAddress != address(0));
        
        lastPayDay = block.timestamp;

        buds = budsAddress;
        shafinRizvi = shafinRizviAddress;
        ryanDerek = ryanDerekAddress;
    }

    
       function payDevs() public {

        require(30 days < block.timestamp - lastPayDay, "ERR: Devs are only paid max once every 30 days");
        
        IERC20(buds).transfer(shafinRizvi, 4206900000000000);
        IERC20(buds).transfer(ryanDerek, 4206900000000000);
        
        lastPayDay = block.timestamp;
    }
    
}