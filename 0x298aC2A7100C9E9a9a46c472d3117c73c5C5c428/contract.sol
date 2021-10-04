// File: contracts/interfaces/IUniswapV2Router02.sol

pragma solidity ^0.5.16;

interface IUniswapV2Router02 {
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts/SLToken.sol

pragma solidity ^0.5.16;

interface SLErc20  {
    function liquidateBorrow(address borrower, uint repayAmount, address slTokenCollateral) external returns (uint);
}

interface SLEther {
    function liquidateBorrow(address borrower, address slTokenCollateral) external payable;
}

contract SLToken{
    address public underlying;
    uint public totalSupply;
    uint public totalBorrows;
    uint public totalReserves;
    function redeem(uint redeemTokens) external returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function balanceOfUnderlying(address owner) external returns (uint);
    function exchangeRateStored() public view returns (uint);
    function getCash() external view returns (uint);
    function earnedCurrent() external returns (uint256, uint256);
    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
    function getSashimiBalanceMetadataExt(address sashimi, address comptroller, address account) external returns (uint, uint, address, uint);
    function getInstantPoolInfo(uint256 _pid)
        external
        returns (
            uint256 _nftPoolId,
            uint256 _accumulativeDividend,
            uint256 _usersTotalWeight,
            uint256 _lpTokenAmount,
            uint256 _oracleWeight,
            address _swapAddress,
            address _relatedSwapAddress
        );
}

// File: contracts/TransferHelper.sol

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.5.16;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }
}

// File: contracts/Comptroller.sol

pragma solidity ^0.5.16;

interface Comptroller {
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
    function claimSashimi(address holder, address[] calldata slTokens) external;
}

// File: contracts/SashimiLendingLiquidation.sol

pragma solidity ^0.5.16;





contract SashimiLendingLiquidation {
    IUniswapV2Router02 public uniswapRouter;
    IUniswapV2Router02 public sashimiswapRouter;
    Comptroller public comptroller;
    mapping(address => bool) public sashimiswapToken;
    mapping(address => address) public route;
    address public slBNB;
    address public WBNB;
    address public owner;

    constructor(IUniswapV2Router02 uniswapRouter_, IUniswapV2Router02 sashimiswapRouter_, Comptroller comptroller_, address slBNB_, address WBNB_) public {
        uniswapRouter = uniswapRouter_;
        sashimiswapRouter = sashimiswapRouter_;
        comptroller = comptroller_;
        slBNB = slBNB_;
        WBNB = WBNB_;
        owner = msg.sender;
    }

    function() external payable {}

    modifier onlyOwner() {
        require(owner == msg.sender, "caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        owner = newOwner;
    }

    function liquidateBorrow(address slTokenBorrowed, address borrower, uint repayAmount, address slTokenCollateral) public payable onlyOwner returns (uint) {
        if(slTokenBorrowed != slBNB){
            address tokenBorrowed = SLToken(slTokenBorrowed).underlying();
            swapBNBForTokenBorrowed(tokenBorrowed, repayAmount); //swap BNB to borrowed token
            TransferHelper.safeApprove(tokenBorrowed, slTokenBorrowed, repayAmount);
            uint err = SLErc20(slTokenBorrowed).liquidateBorrow(borrower, repayAmount, slTokenCollateral);
            require(err == 0,"liquidateBorrow failed");            
        }else{ //no need to swap, if slTokenBorrowed is slBNB
            SLEther(slTokenBorrowed).liquidateBorrow.value(repayAmount)(borrower, slTokenCollateral);
        }
        uint redeemTokens = SLToken(slTokenCollateral).balanceOf(address(this));
        SLToken(slTokenCollateral).redeem(redeemTokens);

        if(slTokenCollateral != slBNB){ //need to swap for bnb, if slTokenCollateral is not slBNB
            address tokenCollateral = SLToken(slTokenCollateral).underlying();
            swapTokenForBNB(tokenCollateral, SLToken(tokenCollateral).balanceOf(address(this))); //swap token to BNB
        }
        uint balance = address(this).balance;
        require(balance > msg.value, "earn failed"); //bnb should be increased
        doTransferOut(msg.sender, balance); //transfer bnb back to sender
    }

    function addRoute(address token, address routeToken) external onlyOwner{
        route[token] = routeToken;
    }

    function setSashimiswapToken(address token, bool flag) external onlyOwner{
        sashimiswapToken[token] = flag;
    }

    function withdraw(address token) external onlyOwner{
        TransferHelper.safeTransfer(token, msg.sender, SLToken(token).balanceOf(address(this)));
    }

    function withdrawBNB() external onlyOwner{
        doTransferOut(msg.sender, address(this).balance);
    }

    function claimSashimi(address[] memory slTokens) public onlyOwner{
        comptroller.claimSashimi(address(this),slTokens);
    } 

    function swapBNBForTokenBorrowed(address token,uint amountOut) internal{
        address[] memory path;
        address routeToken = route[token];
        if(routeToken == address(0)){
            path = new address[](2);
            path[0] = WBNB;
            path[1] = token;
        }else{
            path = new address[](3);
            path[0] = WBNB;
            path[1] = routeToken;
            path[2] = token;
        }        
        IUniswapV2Router02 router = getRouter(token);
        router.swapETHForExactTokens.value(msg.value)(amountOut, path, address(this), block.timestamp + 3);
    }

    function swapTokenForBNB(address token,uint amountIn) internal{
        address[] memory path = new address[](2);
        address routeToken = route[token];
        if(routeToken == address(0)){
            path = new address[](2);
            path[0] = token;
            path[1] = WBNB;
        }else{
            path = new address[](3);
            path[0] = token;
            path[1] = routeToken;
            path[2] = WBNB;
        }        
        IUniswapV2Router02 router = getRouter(token);
        TransferHelper.safeApprove(token, address(router), amountIn);        
        router.swapExactTokensForETH(amountIn, 0, path, address(this), block.timestamp + 3); 
    }

    function getRouter(address token) internal view returns (IUniswapV2Router02){
        if(sashimiswapToken[token]){
            return sashimiswapRouter;
        }else{
            return uniswapRouter;
        }
    }

    function doTransferOut(address payable to, uint amount) internal {
        /* Send the BNB, with minimal gas and revert on failure */
        to.transfer(amount);
    }
}