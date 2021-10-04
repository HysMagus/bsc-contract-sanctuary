//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;


interface IERC20 {
  function balanceOf(address _owner) external view returns(uint256);
  function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 value) external returns (bool);
}

interface uTrade {
     function Buy(address who) payable external;
     function Sell(uint256 _tokensSold) external;
     function balanceOf(address _owner) external view returns(uint256);
     function transfer(address dst, uint256 amount) external;
     function transferFrom(address from, address to, uint256 value) external returns(bool);
     function allowance(address owner, address spender) external view returns (uint256);
     function approve(address spender, uint256 value) external returns (bool);
     function ClaimFee() external returns(uint256);
     function DepositSupply() payable external returns(uint256);
     function getPrice() external view returns(uint256);
}


contract uTradeCompounder {
    
    constructor(){}

    address internal constant UNFI_TOKEN_ADDRESS = 0x728C5baC3C3e370E372Fc4671f9ef6916b814d8B;
    address internal constant UNFI_BNB_PAIR_ADDRESS = 0xddc53AA5Bb9Be27b60D11DbF0e27B27172E19e46;
    address internal constant UP_TOKEN_ADDRESS = 0xb4E8D978bFf48c2D8FA241C0F323F71C1457CA81;
    address internal constant UP_BNB_PAIR_ADDRESS = 0xCfAEfCE10CE1f5C2c65B483CE71168070Fd2780C;
    
    uTrade internal constant uUNFI = uTrade(UNFI_BNB_PAIR_ADDRESS);
    uTrade internal constant uUP = uTrade(UP_BNB_PAIR_ADDRESS);
    
    IERC20 internal constant UP_CONTRACT = IERC20(UP_TOKEN_ADDRESS);
    IERC20 internal constant UNFI_CONTRACT = IERC20(UNFI_TOKEN_ADDRESS);
    
    function compoundUNFILP() external {
        //Auto-claim on LP token transfer to caller
        uUNFI.transferFrom(msg.sender, msg.sender, 0);
        
        //Transfer ALL UP tokens from caller to this contract
        //Requires approval of this contract as spender on UP Token contract
        uint256 balanceOfUser = UP_CONTRACT.balanceOf(msg.sender);
        UP_CONTRACT.transferFrom(msg.sender, address(this), balanceOfUser);
        UP_CONTRACT.approve(address(uUP), balanceOfUser);
        //Sell all of the transfered UP
        uUP.Sell(balanceOfUser);

        //Buy 
        uint256 oneHalf = address(this).balance/2;
        uUNFI.Buy{value: oneHalf}(payable(address(this)));
        uint256 minusTradeFee = (oneHalf / 100) * 3; // 1%
        uint256 otherHalf = oneHalf - minusTradeFee;
        
        
        uint256 unfiBalance = UNFI_CONTRACT.balanceOf(address(this));
        UNFI_CONTRACT.approve(UNFI_BNB_PAIR_ADDRESS, unfiBalance);
         
        if(unfiBalance > 0 && UNFI_CONTRACT.allowance(address(this), UNFI_BNB_PAIR_ADDRESS) >= unfiBalance){
            uUNFI.DepositSupply{value: otherHalf}();
            uUNFI.transfer(msg.sender, uUNFI.balanceOf(address(this)));
            //Leftovers
            if(address(this).balance > 0){
                payable(msg.sender).transfer(address(this).balance);
            }
            
            if(UNFI_CONTRACT.balanceOf(address(this))>0){
                UNFI_CONTRACT.approve(address(this), UNFI_CONTRACT.balanceOf(address(this)));
                UNFI_CONTRACT.transferFrom(address(this), msg.sender, UNFI_CONTRACT.balanceOf(address(this)));
            }
            
            if(UP_CONTRACT.balanceOf(address(this))>0){
                UP_CONTRACT.approve(address(this), UP_CONTRACT.balanceOf(address(this)));
                UP_CONTRACT.transferFrom(address(this), msg.sender, UNFI_CONTRACT.balanceOf(address(this)));
            }
            
        } else {
             revert("UNFI/UP: Allowance or Claimable/Balance of UP Not Enough");
        }
        // claimUP();
        // sellUP();
        // buyUNFI();
        // addLiqUNFI();
    }
    
     //Deal with BNB
    fallback() external payable{}
    receive() external payable{}
}