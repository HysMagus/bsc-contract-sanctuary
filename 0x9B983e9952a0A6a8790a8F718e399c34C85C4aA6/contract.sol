pragma solidity ^0.8.0;

//import "./interfaces/IABCSwap.sol";

interface IABCSwap{
    /**
     * @dev Swap token `from` address to one or two other token
     * 
     * @param fromAddress Token address want to swap
     * @param fromAmount Token amount want to swap
     * @param to1Address Token 1 address want to receive
     * @param to2Address Token 2 address want to receive
     * @param to1Percent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToOtherTokens(address fromAddress, uint fromAmount, address to1Address, address to2Address, uint to1Percent) external returns (bool);
    
    /**
     * @dev Swap native token (ETH, BNB) to one or two other token
     * 
     * @param fromAmount Token amount want to swap
     * @param to1Address Token 1 address want to receive
     * @param to2Address Token 2 address want to receive
     * @param to1Percent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */
    function swapNativeToOtherTokens(uint fromAmount, address to1Address, address to2Address, uint to1Percent) external payable returns (bool);
    
    /**
     * @dev Swap token `from` address to native token (ETH, BNB) and another token
     * 
     * @param fromAddress Token address want to swap
     * @param fromAmount Token amount want to swap
     * @param otherTokenAddress Token 2 address want to receive
     * @param nativePercent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
    */ 
    function swapTokenToNativeAndOtherToken(address fromAddress, uint fromAmount, address otherTokenAddress, uint nativePercent) external returns (bool);
}

//import "./interfaces/IPancakeRouter.sol";
interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

//import "./interfaces/IBEP20.sol";
interface IBEP20 {
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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

//import "./libraries/SafeMath.sol";
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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
//import "./core/Ownable.sol";
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    
    function _now() internal view virtual returns(uint){
        return block.timestamp;
    }
}

abstract contract Ownable is Context {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ABCSwap is IABCSwap, Ownable{
    using SafeMath for uint;
    
    uint internal _fee = 0;                 //Fee for platform, multipled by 1000
    uint internal _feeMultiplier = 1000;
    
    address internal _pancakeRouterAddress;
    address internal _wbnbAddress;
    address[] internal _swapPath;
    
    mapping(address => mapping(address => address[])) internal _swapPaths;
    
    constructor(){
        _pancakeRouterAddress = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
        _wbnbAddress = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    }
    
    function getFee() external view returns(uint){
        return _fee;
    }
    
    function getFeeMultiplier() external view returns(uint){
        return _feeMultiplier;
    }
    
    function getPancakeRouterAddress() external view returns(address){
        return _pancakeRouterAddress;
    }
    
    function getSwapPath(address from, address to) external view returns(address[] memory){
        return _getSwapPath(from, to);
    }
    
    function getWbnbAddress() external view returns(address){
        return _wbnbAddress;
    }
    
    function setFee(uint fee) external onlyOwner returns(bool){
        _fee = fee;
        return true;
    }
    
    function setPancakeRouterAddress(address newAddress) external onlyOwner returns(bool){
        require(newAddress != address(0),"EasySwap.setPancakeRouterAddress: pancakeRouterAddress is zero address");
        _pancakeRouterAddress = newAddress;
        return true;
    }
    
    function setSwapPath(address from, address to, address[] memory path) external onlyOwner returns(bool){
        _swapPaths[from][to] = path;
        return true;
    }
    
    function setWbnbAddress(address newAddress) external onlyOwner returns(bool){
        require(newAddress != address(0),"EasySwap.setWbnbAddress: wbnbAddress is zero address");
        _wbnbAddress = newAddress;
        return true;
    }
    
    /**
     * @dev Swap native token (ETH, BNB) to one or two other token
     * 
     * @param fromAmount Token amount want to swap
     * @param to1Address Token 1 address want to receive
     * @param to2Address Token 2 address want to receive
     * @param to1Percent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */
    function swapNativeToOtherTokens(uint fromAmount, address to1Address, address to2Address, uint to1Percent) external override payable returns (bool){
        return _swapNativeToOtherTokens(fromAmount, to1Address, to2Address, to1Percent);
    }
    
    /**
     * @dev Swap token `from` address to native token (ETH, BNB) and another token
     * 
     * @param fromAddress Token address want to swap
     * @param fromAmount Token amount want to swap
     * @param otherTokenAddress Token 2 address want to receive
     * @param nativePercent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToNativeAndOtherToken(address fromAddress, uint fromAmount, address otherTokenAddress, uint nativePercent) external override returns (bool){
        return _swapTokenToNativeAndOtherToken(fromAddress, fromAmount, otherTokenAddress, nativePercent);
    }
    
    /**
     * @dev Swap token `from` address to one or two other token
     * 
     * @param fromAddress Token address want to swap
     * @param fromAmount Token amount want to swap
     * @param to1Address Token 1 address want to receive
     * @param to2Address Token 2 address want to receive
     * @param to1Percent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToOtherTokens(address fromAddress, uint fromAmount, address to1Address, address to2Address, uint to1Percent) external override returns (bool){
       return _swapTokenToOtherTokens(fromAddress, fromAmount, to1Address, to2Address, to1Percent);
    }
    
    function _calculateFromAmountAfterFee(uint amount) internal virtual returns(uint){
        if(_fee == 0)
            return amount;
            
        return amount.mul(_fee).div(100).div(_feeMultiplier);
    }
    
    function _calculateToGetSwapPath(address from, address to) internal view returns(address[]memory){
        address[] memory paths = _getSwapPath(from, to);
        if(paths.length < 2){
            paths = new address[](3);
            paths[0] = from;
            paths[1] = _wbnbAddress;
            paths[2] = to;
        }
        return paths;
    }
    
    function _getSwapPath(address from, address to) internal view returns(address[]memory){
        return _swapPaths[from][to];
    }
    
    function _swapNativeToOtherTokens(uint fromAmount, address to1Address, address to2Address, uint to1Percent) internal returns (bool){
        return true; 
    }
    
    function _swapTokenToNativeAndOtherToken(address fromAddress, uint fromAmount, address otherTokenAddress, uint nativePercent) internal returns (bool){
        return true; 
    }
    
    function _swapTokenToOtherTokens(address fromAddress, uint fromAmount, address to1Address, address to2Address, uint to1Percent) internal returns (bool){
        require(fromAddress != address(0),"EasySwap.swapTokenToOtherTokens: fromAddress is zero address");
        require(to1Address != address(0) || to2Address != address(0),"EasySwap.swapTokenToOtherTokens: At least 1 to address is not zero address");
        require(fromAddress != to1Address, "EasySwap.swapTokenToOtherTokens: Can not swap to the same token1");
        require(fromAddress != to2Address, "EasySwap.swapTokenToOtherTokens: Can not swap to the same token2");
        require(fromAmount > uint(0), "EasySwap.swapTokenToOtherTokens: fromAmount should be greater than zero");
        
        //Transfer token balance from user's address to EasySwap address
        require(IBEP20(fromAddress).transferFrom(msg.sender, address(this), fromAmount),"EasySwap.swapTokenToOtherTokens: Can not transfer token to EasySwap");
        
        fromAmount = _calculateFromAmountAfterFee(fromAmount);
        
        //Calculate from token to swap to other token
        uint from1Amount = 0;       //From token amount used to swap to to token 1
        uint from2Amount = 0;       //From token amount used to swap to to token 2
        if(to1Address == address(0)){
            from2Amount = fromAmount;
        }else if(to2Address == address(0)){
            from1Amount = fromAmount;
        }else{
            from1Amount = fromAmount.mul(to1Percent).div(100);
            from2Amount = fromAmount - from1Amount;
        }
        
        //Approve PancakeRouter to transfer fromAmount token of EasySwap
        require(IBEP20(to1Address).approve(_pancakeRouterAddress, fromAmount),
            "EasySwap.swapTokenToOtherTokens: Can not approve PancakeRouter to transfer token from EasySwap");
        
        if(from1Amount > 0){
            _swapPath = _calculateToGetSwapPath(fromAddress, to1Address);
            IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
                from1Amount,
                0,
                _swapPath,
                _msgSender(),
                _now() + 60);
        }
        
        if(from2Amount > 0){
            _swapPath = _calculateToGetSwapPath(fromAddress, to2Address);
            IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
                from2Amount,
                0,
                _swapPath,
                _msgSender(),
                _now() + 60);
        }
        
        return true;
    }
}

// SPDX-License-Identifier: MIT