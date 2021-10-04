// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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

pragma solidity >=0.6.0 <0.8.0;


interface IBEP20 is IERC20 {}


pragma solidity >=0.6.0 <0.8.0;


contract Swap {
    address public pancakeRouter = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
    address public bank = address(0);

    constructor(){
        bank = address(0);
    }

    function swapBNBToBUSD(uint256 amountOut) public payable returns(bytes memory){
        address[] memory path = new address[](2);
        path[0] = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        path[1] = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        bytes memory payload = abi.encodeWithSignature('swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)', amountOut,path,msg.sender,block.timestamp+60);

        //call swapTokensForExactTokens
        (bool success, bytes memory returnData) = pancakeRouter.call{value:msg.value}(payload);
        require(success);
        return returnData;
    }

    /*function swapTokensToBUSD(uint256 amountOut,uint256 amountInMax, address[] calldata path,address token) internal returns(bool){
        IBEP20 token =IBEP20(token);
        bytes memory payload = abi.encodeWithSignature('swapTokensForExactTokens(uint amountOut,uint amountInMax,address[] calldata path,address to,uint deadline)', amountOut,amountInMax,path,bank,block.timestamp+60);
        //transfer tokens to the contract
        token.transferFrom(msg.sender,address(this),amountInMax);
        token.approve(pancakeRouter,amountInMax);
        //call swapTokensForExactTokens
        (bool success, bytes memory returnData) = address(pancakeRouter).call(payload);
        require(success,'Transaction Reverted!');
        return true;
    }*/
}