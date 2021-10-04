// SPDX-License-Identifier: MIT
interface IBEP20 {
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// @dev using 0.8.0.
// Note: If changing this, Safe Math has to be implemented!
pragma solidity 0.8.0;

// File: @openzeppelin/contracts/GSN/Context.sol

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";

contract RGPSaleusdt {
    
    bool    public saleActive;
    address public usdt;
    address public rgp;
    address public owner;
    uint    public price;
    
    uint256 public tokensSold;
    
    
    // Emitted when tokens are sold
    event Sale(address indexed account, uint indexed price, uint tokensGot);
    
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    
    // Only allow the owner to do specific tasks
    modifier onlyOwner() {
        require(_msgSender() == owner,"RGP TOKEN: YOU ARE NOT THE OWNER.");
        _;
    }

    constructor( address _usdt, address _rgp) {
        owner =  _msgSender();
        usdt = _usdt;
        rgp = _rgp;
        saleActive = true;
    }
    
    // Change the token price
    // Note: Set the price respectively considering the decimals of usdt
    // Example: If the intended price is 0.01 per token, call this function with the result of 0.01 * 10**18 (_price = intended price * 10**18; calc this in a calculator).
    function tokenPrice(uint _price) external onlyOwner {
        price = _price;
    }
    
   
    // Buy tokens function
    // Note: This function allows only purchases of "full" tokens, purchases of 0.1 tokens or 1.1 tokens for example are not possible
    function buyTokens(uint256 _tokenAmount) public {
        
        // Check if sale is active and user tries to buy atleast 1 token
        require(saleActive == true, "RGP: SALE HAS ENDED.");
        require(_tokenAmount >= 1, "RGP: BUY ATLEAST 1 TOKEN.");
        
        // Calculate the purchase cost
        uint256 cost = _tokenAmount * price;
        
        // Calculate the tokens _msgSender() will get (with decimals)
        uint256 tokensToGet = _tokenAmount * 10**18;
        
        // Transfer usdt from _msgSender() to the contract
        // If it returns false/didn't work, the
        //  msg.sender may not have allowed the contract to spend usdt or
        //  msg.sender or the contract may be frozen or
        //  msg.sender may not have enough usdt to cover the transfer.
        require(IBEP20(usdt).transferFrom(_msgSender(), address(this), cost), "RGP: TRANSFER OF usdt FAILED!");
        
        // Transfer RGP to msg.sender
        // If it returns false/didn't work, the contract doesn't own enough tokens to cover the transfer
        require(IBEP20(rgp).transfer(_msgSender(), tokensToGet), "RGP: CONTRACT DOES NOT HAVE ENOUGH TOKENS.");
        
        tokensSold += tokensToGet;
        emit Sale(_msgSender(), price, tokensToGet);
    }

    // End the sale, don't allow any purchases anymore and send remaining rgp to the owner
    function disableSale() external onlyOwner{
        
        // End the sale
        saleActive = false;
        
        // Send unsold tokens and remaining usdt to the owner. Only ends the sale when both calls are successful
        IBEP20(rgp).transfer(owner, IBEP20(rgp).balanceOf(address(this)));
    }
    
    // Start the sale again - can be called anytime again
    // To enable the sale, send RGP tokens to this contract
    function enableSale() external onlyOwner{
        
        // Enable the sale
        saleActive = true;
        
        // Check if the contract has any tokens to sell or cancel the enable
        require(IBEP20(rgp).balanceOf(address(this)) >= 1, "RGP: CONTRACT DOES NOT HAVE TOKENS TO SELL.");
    }
    
    // Withdraw usdt to _recipient
    function withdrawusdt() external onlyOwner {
        uint _usdtBalance = IBEP20(usdt).balanceOf(address(this));
        require(_usdtBalance >= 1, "RGP: NO usdt TO WITHDRAW");
        IBEP20(usdt).transfer(owner, _usdtBalance);
    }
    
    // Withdraw (accidentally) to the contract sent BNB
    function withdrawBNB() external payable onlyOwner {
        payable(owner).transfer(payable(address(this)).balance);
    }
    
    // Withdraw (accidentally) to the contract sent BEP20 tokens except rgp
    function withdrawIBEP20(address _token) external onlyOwner {
        uint _tokenBalance = IBEP20(_token).balanceOf(address(this));
        
        // Don't allow RGP to be withdrawn (use endSale() instead)
        require(_tokenBalance >= 1 && _token != rgp, "RGP: CONTRACT DOES NOT OWN THAT TOKEN OR TOKEN IS RGP.");
        IBEP20(_token).transfer(owner, _tokenBalance);
    }
}