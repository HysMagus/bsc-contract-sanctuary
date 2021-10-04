// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


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

// File: contracts/IBEP20.sol



pragma solidity >=0.6.0 <0.8.0;


interface IBEP20 is IERC20 {}

// File: openzeppelin-solidity/contracts/GSN/Context.sol



pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: openzeppelin-solidity/contracts/access/Ownable.sol



pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/Swap.sol



pragma solidity >=0.6.0 <0.8.0;



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

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}
interface Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapExactBNBForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapTokensForExactBNB(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForBNB(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapBNBForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface Router02 is Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactBNBForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForBNBSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
contract Swap is Ownable {
    
    address public bank = address(0);
    address public WBNB =0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public currency = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    constructor(){
        bank = address(0);
    } 
    fallback () external payable {
    }
    receive () external payable {
    }

    function _bestTrade(address[] calldata routers,address fromTokenAddress,address toTokenAddress, uint256 amount, bool exactOut)internal view returns(uint256[] memory minMax,address bestRouter){
        address[] memory path;
        minMax = new uint256[](2);
        uint256[] memory returnAmounts;
        for(uint i=0;i<routers.length;i++){
            Router01 router = Router01(routers[i]);
            if(fromTokenAddress ==address(0)){
                path = new address[](2);
                path[0] = WBNB;
                path[1] = currency;
            }
            else if(toTokenAddress == address(0)){
                path = new address[](2);
                path[0] = currency;
                path[1] = WBNB;
            }
            else{
                path = new address[](3);
                if(exactOut){
                    path[0] = fromTokenAddress;
                    path[1] = WBNB;
                    path[2] = currency;
                }
                else{
                    path[0] = currency;
                    path[1] = WBNB;
                    path[2] = toTokenAddress;
                }
            }
            
            if(exactOut){
                returnAmounts=router.getAmountsIn(amount,path);
                if(i==0){
                    minMax[1]=returnAmounts[0];
                    minMax[0]=returnAmounts[0];
                    bestRouter = routers[i];
                }
                if(returnAmounts[0]>minMax[1]){
                    minMax[1]=returnAmounts[0];
                }
                if(returnAmounts[0]<minMax[0]){
                    minMax[0]=returnAmounts[0];
                    bestRouter = routers[i];
                }
            }

            else{
                returnAmounts=router.getAmountsOut(amount,path);
                if(i==0){
                    minMax[1]=returnAmounts[1];
                    minMax[0]=returnAmounts[1];
                    bestRouter = routers[i];
                }
                if(returnAmounts[1]>minMax[1]){
                    minMax[1]=returnAmounts[1];
                    bestRouter = routers[i];
                }
                if(returnAmounts[1]<minMax[0]){
                    minMax[0]=returnAmounts[1];
                }
            }
            
        }
        
    }

    function _swapTokensToCurrency(address routerAddress,uint256 amountOut,uint256 amountInMax, address tokenAddress) internal returns(uint[] memory returnData){
        Router01 router = Router01(routerAddress);
        address[] memory path = new address[](3);
        path[0] = tokenAddress;
        path[1] = WBNB;
        path[2] = currency;
        
        //transfer tokens to the contract
        TransferHelper.safeTransferFrom(tokenAddress,msg.sender,address(this),amountInMax);
        TransferHelper.safeApprove(tokenAddress,routerAddress,amountInMax);
        returnData= router.swapTokensForExactTokens(amountOut,amountInMax,path,msg.sender,block.timestamp+60);
        TransferHelper.safeTransfer(tokenAddress,msg.sender,amountInMax-returnData[0]);
    }

    function _swapCurrencyToTokens(address routerAddress,uint256 amountIn, address tokenAddress) internal returns(uint[] memory returnData){
        Router01 router = Router01(routerAddress);
        address[] memory path = new address[](3);
        path[0] = currency;
        path[1] = WBNB;
        path[2] = tokenAddress;
        
        //transfer tokens to the contract
        TransferHelper.safeTransferFrom(currency,msg.sender,address(this),amountIn);
        TransferHelper.safeApprove(currency,routerAddress,amountIn);
        returnData= router.swapExactTokensForTokens(amountIn,0,path,msg.sender,block.timestamp+60);
    }

    function _swapBNBToCurrency(address[] calldata routers,uint256 amountOut)public payable returns(uint[] memory returnData){
        (uint256[] memory minMax,address bestRouter) = bestTrade(routers,address(0), currency,amountOut,true);
        Router01 router = Router01(bestRouter);
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = currency;
        
        //call swapTokensForExactTokens
        if(bestRouter == 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F){
            returnData= router.swapETHForExactTokens{value:msg.value}(amountOut,path,msg.sender,block.timestamp+60);
        }
        else{
            returnData= router.swapBNBForExactTokens{value:msg.value}(amountOut,path,msg.sender,block.timestamp+60);
        }
        TransferHelper.safeTransferETH(msg.sender, msg.value - returnData[0]);
    }

     function _swapCurrencyToBNB(address[] calldata routers,uint256 amountIn) internal returns(uint[] memory returnData){
        (uint256[] memory minMax,address bestRouter) = bestTrade(routers,currency,address(0), amountIn,false);
        Router01 router = Router01(bestRouter);
        address[] memory path = new address[](2);
        path[0] = currency;
        path[1] = WBNB;
        
         //transfer tokens to the contract
        TransferHelper.safeTransferFrom(currency,msg.sender,address(this),amountIn);
        TransferHelper.safeApprove(currency,bestRouter,amountIn);
        
        
        //call swapTokensForExactTokens
        if(minMax[1]>0){
            if(bestRouter == 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F){
                returnData= router.swapExactTokensForETH(amountIn,0,path,msg.sender,block.timestamp+60);
            }
            else{
                returnData= router.swapExactTokensForBNB(amountIn,0,path,msg.sender,block.timestamp+60);
            }
        }
    }
    
    function _swapTokensToCurrency(address[] calldata routers,address tokenAddress, uint256 amountInMax,uint256 amountOut) internal returns(uint[] memory returnData){
        (uint256[] memory minMax,address bestRouter) = bestTrade(routers,tokenAddress, currency,amountOut,true);
        returnData =  _swapTokensToCurrency(bestRouter,amountOut,amountInMax, tokenAddress);
    }

    function _swapCurrencyToTokens(address[] calldata routers,address tokenAddress, uint256 amountIn) internal returns(uint[] memory returnData){
        (uint256[] memory minMax,address bestRouter) = bestTrade(routers,currency,tokenAddress, amountIn,false);
        returnData =  _swapCurrencyToTokens(bestRouter,amountIn, tokenAddress);
    }

    function _deposit(address[] calldata routers,address tokenAddress, uint256 amountInMax,uint256 amountOut) public payable returns(uint[] memory returnData){
        if(tokenAddress==address(0)){
            returnData = _swapBNBToCurrency(routers,amountOut);
        }
        else{
            returnData = _swapTokensToCurrency(routers,tokenAddress,amountInMax,amountOut);
        }
    }

    function _swap(address[] calldata routers,address tokenAddress, uint256 amountIn) internal returns(uint[] memory returnData){
        if(tokenAddress==address(0)){
            returnData = _swapCurrencyToBNB(routers,amountIn);
        }
        else{
            returnData = _swapCurrencyToTokens(routers,tokenAddress,amountIn);
        }
    }
    function bestTrade(address[] calldata routers,address fromTokenAddress, address toTokenAddress, uint256 amount,bool exactOut)public view returns(uint256[] memory minMax,address bestRouter){
        (minMax,bestRouter)= _bestTrade(routers,fromTokenAddress,toTokenAddress,amount,exactOut);
    }

    function changeBank(address bankAddress) public onlyOwner returns(bool){
        bank = bankAddress;
        return true;
    }

    function changeCurrency(address newCurrency) public onlyOwner returns(bool){
        currency = newCurrency;
        return true;
    }

    function deposit(address[] calldata routers,address tokenAddress, uint256 amountInMax,uint256 amountOut) external payable returns(uint[] memory returnData){
        returnData = _deposit(routers,tokenAddress,amountInMax,amountOut);
    }

    function swap(address[] calldata routers,address tokenAddress, uint256 amountIn) external returns(uint[] memory returnData){
        returnData = _swap(routers,tokenAddress,amountIn);
    }

}

// File: contracts/Giglantis.sol

pragma solidity ^0.7.4;



interface Bank{
    function withdraw(uint256 amount,address buyer,address seller,bool canceled) external  returns (bool);

}

contract Giglantis is Swap{
    using SafeMath for uint256;
    address public resolveAddress;
    address public adminAddress;
    Bank private bankContract;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    event AddOrder(
        uint256 time,
        uint256 orderId,
        address seller,
        address buyer,
        uint256 price
    );
    event CompleteOrder(
        uint256 time,
        uint256 orderId,
        address seller,
        address buyer,
        uint256 price
    );
    event ResolveOrder(
        uint256 time,
        uint256 orderId,
        bool completed,
        address seller,
        address buyer,
        uint256 price
    );

    //////////////////////////////////////////////////////////////////////////////////
    constructor() {
        adminAddress = msg.sender;
        bankContract = Bank(bank);
    }

    //////////////////////////////////////////////////////////////////////////////////

    struct orderData {
        uint256 userId;
        bool completed;
        address seller;
        address buyer;
        uint256 price;
    }
    /////////////////////////////////////////////////////////////////////////////////

    mapping(uint256 => orderData) orders;

    /////////////////////////////////////////////////////////////////////////////////

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Only admin function");
        _;
    }
    modifier onlyResolver() {
        require(msg.sender == resolveAddress, "Only resolver function");
        _;
    }

    ///////////////////////////////////////////////////////////////////////////////

    function placeOrder(
        uint256 orderId,
        uint256 userId,
        uint256 price,
        address seller,
        address buyer,
        address[] calldata routers,
        address tokenAddress,
        uint256 amountInMax
    ) public {
        _deposit(routers,tokenAddress, amountInMax,price);
        orders[orderId] = orderData(userId, false, seller, buyer, price);
        emit AddOrder(block.timestamp, orderId, seller, buyer, price);
    }

    function markCompleted(uint256 orderId) public {
        require(
            orders[orderId].seller == msg.sender,
            "This is not the seller account"
        );
        bankContract.withdraw(orders[orderId].price,orders[orderId].buyer,orders[orderId].seller,false);
        orders[orderId].completed = true;
        emit AddOrder(
            block.timestamp,
            orderId,
            orders[orderId].seller,
            orders[orderId].buyer,
            orders[orderId].price
        );
    }

    function resolveConflict(uint256 orderId, bool status) public onlyResolver {
        if(status){
            bankContract.withdraw(orders[orderId].price,orders[orderId].buyer,orders[orderId].seller,false);
        }
        else{
            bankContract.withdraw(orders[orderId].price,orders[orderId].buyer,orders[orderId].seller,true);
        }
        orders[orderId].completed = status;
        emit ResolveOrder(
            block.timestamp,
            orderId,
            status,
            orders[orderId].seller,
            orders[orderId].buyer,
            orders[orderId].price
        );
    }

    /////////////////////////////////////////////////////////////////////////////
    function setAdminAddress(address admin) public onlyAdmin {
        adminAddress = admin;
    }

    function setResolveAddress(address resolver) public onlyAdmin {
        resolveAddress = resolver;
    }

}

//////////////////////////////////////////////////////////////////////////////