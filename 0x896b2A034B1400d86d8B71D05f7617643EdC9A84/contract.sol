// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

abstract contract ERC20 {
    function name() external view virtual returns (string memory);
    function symbol() external view virtual returns (string memory);
    function decimals() external view virtual returns (uint8);
    function totalSupply() external view virtual returns (uint256);
    function balanceOf(address _owner) external view virtual returns (uint256);
    function allowance(address _owner, address _spender) external view virtual returns (uint256);
    function transfer(address _to, uint256 _value) external virtual returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external virtual returns (bool);

    function approve(address _spender, uint256 _value) external virtual returns (bool);
}

contract InstantBuy
{
    uint PRICE_CONVERT_DECIMALS = 18;
    uint256 ONE_HUNDRED = 100000000000000000000;

    address public networkcoinaddress;
    address public owner;
    address public feeTo;

    //Instant Buy Price in BUSD
    mapping(address => uint256) public instantbuyprice;

    //Instant Buy: Allow To Buy Token (0/1 = false/true)
    mapping(address => uint) public instantbuyallowtobuytoken;

    //Token Fee Percent
    mapping(address => uint256) public tokenfeepercent;

    event OnBuy(address tokenSource, address tokenDestination, uint256 quotePrice, uint256 txPrice, uint256 buyFee, uint256 amountReceived);

    constructor() {
        owner = msg.sender;
        feeTo = owner;
        networkcoinaddress = address(0x1110000000000000000100000000000000000111);
    }

    function supplyNetworkCoin() payable external {
        require(msg.sender == owner, 'FN'); //Forbidden
        // nothing else to do!
    }

    function transferFund(ERC20 token, address to, uint256 amountInWei) external
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        //Withdraw of deposit value
        if(address(token) != networkcoinaddress)
        {
            //Withdraw token
            token.transfer(to, amountInWei);
        }
        else
        {
            //Withdraw Network Coin
            payable(to).transfer(amountInWei);
        }
    }

    function setOwner(address newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        owner = newValue;
        return true;
    }

    function setFeeTo(address newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        feeTo = newValue;
        return true;
    }

    function setNetworkCoinAddress(address newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        networkcoinaddress = newValue;
        return true;
    }

    function getInstantBuyPrice(address tokenAddress) external view returns (uint256 value)
    {
        return instantbuyprice[tokenAddress];
    }

    function setInstantBuyPrice(address tokenAddress, uint256 newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        instantbuyprice[tokenAddress] = newValue;
        return true;
    }

    function getInstantBuyFee(address tokenAddress) external view returns (uint256 value)
    {
        return tokenfeepercent[tokenAddress];
    }

    function setInstantBuyFee(address tokenAddress, uint256 newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        tokenfeepercent[tokenAddress] = newValue;
        return true;
    }

    function getInstantBuyPriceQuote(address tokenAddressSource, address tokenAddressDestination) public view returns (uint256 value)
    {
        if(instantbuyprice[tokenAddressSource] == 0)
        {
            return 0;
        }

        if(instantbuyprice[tokenAddressDestination] == 0)
        {
            return 0;
        }

        uint256 result = safeDivFloat(instantbuyprice[tokenAddressSource], instantbuyprice[tokenAddressDestination], PRICE_CONVERT_DECIMALS);

        return result;
    }

    function getInstantBuyTokenAllowedToBuy(address tokenAddress) external view returns (bool value)
    {
        return instantbuyallowtobuytoken[tokenAddress] == 1;
    }

    function setInstantBuyTokenAllowedToBuy(address tokenAddress, uint newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'FN'); //Forbidden

        instantbuyallowtobuytoken[tokenAddress] = newValue;
        return true;
    }

    function getBuyForecast(address tokenSource, address tokenDestination, uint256 amountInWei) external view returns (uint256 value)
    {
        uint256 feePercent = tokenfeepercent[tokenDestination]; //Eg 10% (10000000000000000000)
        uint256 fee = 0;
        if(feePercent > 0)
        {
            fee = safeDiv(safeMul(amountInWei, feePercent), ONE_HUNDRED);
            amountInWei = safeSub(amountInWei, fee);
        }

        uint256 quote = getInstantBuyPriceQuote(tokenSource, tokenDestination);
        uint256 result = safeMulFloat( quote, amountInWei, PRICE_CONVERT_DECIMALS);

        return result;
    }

    function instantBuyUsingToken(address tokenSource, address tokenDestination, uint256 amountInWei) external returns (bool success)
    {
        require(ERC20(tokenSource).allowance(msg.sender, address(this)) >= amountInWei, "AL"); //STAKE: Check the token allowance. Use approve function.
        require(instantbuyprice[tokenSource] > 0, "SNI"); //STAKE: Token Source not initialized
        require(instantbuyprice[tokenDestination] > 0, "DNI"); //STAKE: Token Destination not initialized
        require(instantbuyallowtobuytoken[tokenDestination] == 1, "N"); //STAKE: Token not allowed to buy
        require(amountInWei > 0, "ZERO"); //STAKE: Zero Amount

        //Receive payment
        ERC20(tokenSource).transferFrom(msg.sender, feeTo, amountInWei);

        //Reduce admin fee to swap
        uint256 feePercent = tokenfeepercent[tokenDestination]; //Eg 10% (10000000000000000000)
        uint256 fee = 0;
        if(feePercent > 0)
        {
            require(feePercent <= ONE_HUNDRED, "IF"); //STAKE: Invalid percent fee value

            fee = safeDiv(safeMul(amountInWei, feePercent), ONE_HUNDRED);
            amountInWei = safeSub(amountInWei, fee);
        }

        //Send paid token amount
        uint256 quote = getInstantBuyPriceQuote(tokenSource, tokenDestination);
        uint256 result = safeMulFloat( quote, amountInWei, PRICE_CONVERT_DECIMALS);

        uint256 contractBalance = ERC20(tokenDestination).balanceOf(address(this));
        require(contractBalance >= result, "NE"); //STAKE: Not enough balance

        ERC20(tokenDestination).transfer(msg.sender, result);

        //Event Buy Trigger: tokenSource, tokenDestination, quotePrice, txPrice, buyFee, amountReceived
        emit OnBuy(tokenSource, tokenDestination, quote, amountInWei, fee, result);

        return true;
    }

    function instantBuyUsingNetworkCoin(address tokenDestination) external payable returns (bool success)
    {
        require(instantbuyallowtobuytoken[tokenDestination] == 1, "N"); //STAKE: Token not allowed to buy
        require(msg.value > 0, "ZERO"); //STAKE: Zero Amount

        //Receive payment
        payable(feeTo).transfer(msg.value);

        //Reduce admin fee to swap
        uint256 feePercent = tokenfeepercent[tokenDestination]; //Eg 10% (10000000000000000000)
        uint256 fee = 0;
        uint256 amountInWei = msg.value;
        if(feePercent > 0)
        {
            require(feePercent <= ONE_HUNDRED, "IF"); //STAKE: Invalid percent fee value

            fee = safeDiv(safeMul(amountInWei, feePercent), ONE_HUNDRED);
            amountInWei = safeSub(amountInWei, fee);
        }

        //Send paid token amount
        //uint256 quote = safeDivFloat(instantbuyprice[networkcoinaddress], instantbuyprice[tokenDestination], PRICE_CONVERT_DECIMALS);
        uint256 quote = getInstantBuyPriceQuote(networkcoinaddress, tokenDestination);
        uint256 result = safeMulFloat( quote, amountInWei, PRICE_CONVERT_DECIMALS);

        uint256 contractBalance = ERC20(tokenDestination).balanceOf(address(this));
        require(contractBalance >= result, "NE"); //STAKE: Not enough balance

        ERC20(tokenDestination).transfer(msg.sender, result);

        //Event Buy Trigger: tokenSource, tokenDestination, quotePrice, txPrice, buyFee, amountReceived
        emit OnBuy(networkcoinaddress, tokenDestination, quote, amountInWei, fee, result);

        return true;
    }

    //Safe Math Functions
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a + b;
        require(c >= a, "OADD"); //STAKE: SafeMath: addition overflow

        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeSub(a, b, "OSUB"); //STAKE: subtraction overflow
    }

    function safeSub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        if (a == 0) 
        {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "OMUL"); //STAKE: multiplication overflow

        return c;
    }

    function safeMulFloat(uint256 a, uint256 b, uint decimals) internal pure returns(uint256)
    {
        if (a == 0 || decimals == 0)  
        {
            return 0;
        }

        uint result = safeDiv(safeMul(a, b), safePow(10, uint256(decimals)));

        return result;
    }

    function safePow(uint256 n, uint256 e) internal pure returns(uint256)
    {

        if (e == 0) 
        {
            return 1;
        } 
        else if (e == 1) 
        {
            return n;
        } 
        else 
        {
            uint256 p = safePow(n,  safeDiv(e, 2));
            p = safeMul(p, p);

            if (safeMod(e, 2) == 1) 
            {
                p = safeMul(p, n);
            }

            return p;
        }
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeDiv(a, b, "ZDIV"); //STAKE: division by zero
    }

    function safeDivFloat(uint256 a, uint256 b, uint decimals) internal pure returns (uint256) 
    {
        uint _a  = a * safePow(10, uint256(decimals));
        return safeDiv(_a, b, "ZDIV"); //STAKE: division by zero
    }

    function safeDiv(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function safeMod(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeMod(a, b, "ZMOD"); //STAKE: modulo by zero
    }

    function safeMod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b != 0, errorMessage);
        return a % b;
    }
}