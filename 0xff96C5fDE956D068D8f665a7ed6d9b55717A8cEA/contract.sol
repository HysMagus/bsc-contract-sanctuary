// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: browser/bscswap-buyandaddliq.sol


pragma solidity =0.6.6;
//Import IERC20


interface IThugs is IERC20{
  function bscSwapPair (  ) external view returns ( address );
}

interface IWBNB is IERC20{
  function deposit (  ) external payable;
  function withdraw(uint) external;
}

interface BscSwap{
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function WBNB() external pure returns (address);
}

contract ThugsAutoLiqBuy{
    //define constants
    bool hasApproved = false;
    uint constant public INF = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    address owner = msg.sender;
    address public  bscSwapRouter = address(0xd954551853F55deb4Ae31407c423e67B1621424A);
    address self = address(this);

    IThugs public thugsInterface = IThugs(0xE10e9822A5de22F8761919310DDA35CD997d63c0);
    IERC20 public pairInterface = IERC20(thugsInterface.bscSwapPair());
    BscSwap bscswapInterface = BscSwap(bscSwapRouter);
    IWBNB wbnbInterface = IWBNB(bscswapInterface.WBNB());
    
     function getPathForBNBToToken() private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = bscswapInterface.WBNB();
        path[1] = address(thugsInterface);
        return path;
    }

    function DoApprove() internal {
        thugsInterface.approve(bscSwapRouter, INF); //allow pool to get tokens
        pairInterface.approve(bscSwapRouter, INF); //allow pool to get tokens
        wbnbInterface.approve(bscSwapRouter,INF);//Allow router to use WBNB
    }
    
    function getThugsBalance() public view returns (uint256){
       return getTokenBalance(address(thugsInterface));
    }
    
    function getWBNBBalance() public view returns (uint256){
        return getTokenBalance(bscswapInterface.WBNB());
    }
    
    receive() external payable {
        deposit();
    }

    function deposit() public payable{
        if(!hasApproved){
            DoApprove();
        }
        //Convert bnb to WBNB
        wbnbInterface.deposit{value:msg.value}();
        convertWBNBToThugs();
        addLiq(msg.sender);
        //Send back the bnb dust given from refund
        if(getWBNBBalance() > 0){
            wbnbInterface.transfer(msg.sender,getWBNBBalance());
        }
    }

    function convertWBNBToThugs() internal {
        bscswapInterface.swapExactTokensForTokensSupportingFeeOnTransferTokens(getWBNBBalance() / 2,1,getPathForBNBToToken(),self,INF);
    }

    function getTokenBalance(address tokenAddress) public view returns (uint256){
       return IERC20(tokenAddress).balanceOf(address(this));
    }
    
    function recoverERC20(address tokenAddress) public {
        IERC20(tokenAddress).transfer(owner, getTokenBalance(tokenAddress));
    }

    function addLiq(address dest) internal {
        //finally add liquidity
        bscswapInterface.addLiquidity(address(thugsInterface),bscswapInterface.WBNB(),getThugsBalance(),getWBNBBalance(),1,1,dest,INF);
    }
    
    function withdrawFunds() public {
        recoverERC20(bscswapInterface.WBNB());
        recoverERC20((address(thugsInterface)));
    }
}