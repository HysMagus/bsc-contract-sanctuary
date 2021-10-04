//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

// UNFI-BNB LP YIELD Compounder
// 1. Claims your pending UP tokens.
// 2. Sells all your UP tokens for BNB.
// 3. Uses half of that BNB to buy UNFI on uTrade.
// 4. Joins both halves to add liquidity 50:50 to UNFI-LP
// 5. Returns back the LP Tokens to caller

// -- Aditional Features--
//  -> Transfers UNFI dust balance to UNFI-BNB Pool
//  -> Transfers BNB dust balance to UNFI-BNB Pool
//  -> Redeem leftover UP tokens.
//  -> Transfer received BNB from redeeming back to UP BNB reserve.

//  The aditional features operate on this contract balance and not callers
//  Transfering BNB to UP Token Address increases the redemption value of each token

//  ->No Dev Fee

interface IERC20 {
  function balanceOf(address _owner) external view returns(uint256);
  function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 value) external returns (bool);
  function burn(uint256 _value) external;
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
        uint256 minusTradeFee = (oneHalf / 100) * 2; // 1%
        uint256 otherHalf = oneHalf - minusTradeFee;
        
        
        uint256 unfiBalance = UNFI_CONTRACT.balanceOf(address(this));
        UNFI_CONTRACT.approve(UNFI_BNB_PAIR_ADDRESS, unfiBalance);
         
        if(unfiBalance > 0 && UNFI_CONTRACT.allowance(address(this), UNFI_BNB_PAIR_ADDRESS) >= unfiBalance){
            uUNFI.DepositSupply{value: otherHalf}();
            uUNFI.transfer(msg.sender, uUNFI.balanceOf(address(this)));
            
            //Leftover BNB injected into UNFI-BNB Pair
            if(address(this).balance > 0){
                payable(address(uUNFI)).transfer(address(this).balance);
            }
            
            //Leftover UNFI injected into UNFI-BNB Pair
            if(UNFI_CONTRACT.balanceOf(address(this))>0){
                UNFI_CONTRACT.approve(address(this), UNFI_CONTRACT.balanceOf(address(this)));
                UNFI_CONTRACT.transferFrom(address(this), address(uUNFI), UNFI_CONTRACT.balanceOf(address(this)));
            }

            //Inject UP Leftover Into Redeem Reserve
            uint256 balanceUP = UP_CONTRACT.balanceOf(address(this));
            
            if(balanceUP>0){
                 uint256 balanceBNBBefore = address(this).balance;
                 UP_CONTRACT.approve(address(this), balanceUP);
                 UP_CONTRACT.burn(balanceUP);
                 uint256 balanceBNBAfter = address(this).balance;
                 uint256 difference = balanceBNBAfter - balanceBNBBefore;
                 payable(UP_TOKEN_ADDRESS).transfer(difference);
            }
        } else {
             revert("UNFI/UP: Allowance or Claimable/Balance of UP Not Enough");
        }
    }

     //Deal with BNB
    fallback() external payable{}
    receive() external payable{}
}