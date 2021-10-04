
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

// File: browser/ghd_bep20.sol

pragma solidity ^0.7.0;


import "./ERC20.sol";
contract GHD_TOKEN is ERC20{
   address payable Owner;
    constructor(uint256 _Total_Supply,address payable _Owner)  ERC20("GiftedHands","GHD"){
       _mint(msg.sender,_Total_Supply);
        Owner=_Owner;
   } 
   modifier OnlyOwner{
       require(msg.sender==Owner,"unautorized access");
       _;
   }

   function mint(address payable account,uint256 amount) public OnlyOwner{
       _mint(account,amount);
   }
   function burn(address payable account,uint256 amount) public OnlyOwner{
       _burn(account,amount);
   }
   function TransferOwnerShip(address payable NewAddress) public OnlyOwner{
       Owner=NewAddress;
   }
   function ShowOwner()public view returns(address){
       return Owner;
   }
}