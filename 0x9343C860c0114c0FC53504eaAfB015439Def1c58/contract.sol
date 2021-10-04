pragma solidity ^0.8.0;

//import "./interfaces/IDemoSwap.sol";

interface IDemoSwap{
    /**
     * @dev Swap token `from` address to one or two other token
     * 
     * @param inAddress Token address want to swap
     * @param inAmount Token amount want to swap
     * @param outAddress1 Token 1 address want to receive
     * @param outAddress2 Token 2 address want to receive
     * @param outPercent1 Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToOtherTokens(address inAddress, uint inAmount, address outAddress1, address outAddress2, uint outPercent1) external returns (bool);
    
    /**
     * @dev Swap native token (ETH, BNB) to one or two other token
     * 
     * @param outAddress1 Token 1 address want to receive
     * @param outAddress2 Token 2 address want to receive
     * @param outPercent1 Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */
    function swapNativeToOtherTokens(address outAddress1, address outAddress2, uint outPercent1) external payable returns (bool);
    
    /**
     * @dev Swap token `from` address to native token (ETH, BNB) and another token
     * 
     * @param inAddress Token address want to swap
     * @param inAmount Token amount want to swap
     * @param otherTokenAddress Token 2 address want to receive
     * @param nativePercent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
    */ 
    function swapTokenToNativeAndOtherToken(address inAddress, uint inAmount, address otherTokenAddress, uint nativePercent) external returns (bool);
}

//import "./interfaces/IPancakeRouter.sol";

interface IPancakeRouter02 {
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

//import "./interfaces/IPancakeFactory.sol";
interface IPancakeFactory{
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

//import "./interfaces/IPancakePair.sol";
interface IPancakePair{
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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

//import "./interfaces/IWBNB.sol";
interface IWBNB {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
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

//import "./core/Runable.sol";
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

abstract contract Runable is Ownable {
    bool internal _runable;
    
    modifier runable{
        require(_getRunable(), "Contract is paused");
        _;
    }
    
    constructor(){
        _runable = true;
    }
    
    function getRunable() external view returns(bool){
        return _getRunable();
    }
    
    function _getRunable() internal view returns(bool){
        return _runable;
    }
    
    function setRunable(bool value) external onlyOwner returns(bool){
        _runable = value;
        return true;
    }
}

enum ESwapType{
    NativeToToken,
    TokenToNative,
    TokenToToken
}

contract DemoSwap is IDemoSwap, Runable{
    using SafeMath for uint;
    
    uint internal _fee = 0;                 //Fee for platform, multipled by 1000
    uint internal _feeMultiplier = 1000;
    uint internal _ratioMultiplier = 100;
    
    address internal _pancakeFactoryAddress;
    address internal _pancakeRouterAddress;
    address internal _wbnbAddress;
    
    mapping(address => mapping(address => address[])) internal _swapPaths;
    address[] internal _noAppliedFeeAddresses;
    
    constructor(){
        _pancakeFactoryAddress = 0xBCfCcbde45cE874adCB698cC183deBcF17952812;
        _pancakeRouterAddress = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
        _wbnbAddress = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    }
    
    function addNoAppliedFeeAddress(address account) external onlyOwner runable returns(bool){
        (bool noAppliedFee,) = _isNoAppliedFee(account);
        require(!noAppliedFee, "This account has been added before");
        _noAppliedFeeAddresses.push(account);
        
        return true;
    }
    
    function getFee() external view returns(uint){
        return _fee;
    }
    
    function getFeeMultiplier() external view returns(uint){
        return _feeMultiplier;
    }
    
    function getPancakeFactoryAddress() external view returns(address){
        return _pancakeFactoryAddress;
    }
    
    function getPancakeRouterAddress() external view returns(address){
        return _pancakeRouterAddress;
    }
    
    function getRatioMultiplier() external view returns(uint){
        return _ratioMultiplier;
    }
    
    function getSwapPath(address source, address to) external view returns(address[] memory){
        return _getSwapPath(source, to);
    }
    
    function getWbnbAddress() external view returns(address){
        return _wbnbAddress;
    }
    
    receive() external payable{}
    
    function removeNoAppliedFeeAddress(address account) external onlyOwner runable returns(bool){
        (bool noAppliedFee, uint index) = _isNoAppliedFee(account);
        require(noAppliedFee, "This account has been added before");
        
        delete _noAppliedFeeAddresses[index];
        
        return true;
    }
    
    function setFee(uint fee) external onlyOwner runable returns(bool){
        _fee = fee;
        return true;
    }
    
    function setPancakeRouterAddress(address newAddress) external onlyOwner runable returns(bool){
        require(newAddress != address(0),"pancakeRouterAddress is zero address");
        _pancakeRouterAddress = newAddress;
        return true;
    }
    
    function setPancakeFactoryAddress(address newAddress) external onlyOwner runable returns(bool){
        require(newAddress != address(0),"newAddress is zero address");
        _pancakeFactoryAddress = newAddress;
        return true;
    }
    
    function setRatioMultiplier(uint multiplier) external onlyOwner runable returns(bool){
        _ratioMultiplier = multiplier;
        return true;
    }
    
    function setSwapPath(address source, address to, address[] memory path) external onlyOwner runable returns(bool){
        _swapPaths[source][to] = path;
        return true;
    }
    
    function setWbnbAddress(address newAddress) external onlyOwner runable returns(bool){
        require(newAddress != address(0),"DemoSwap.setWbnbAddress: wbnbAddress is zero address");
        _wbnbAddress = newAddress;
        return true;
    }
    
    /**
     * @dev Swap native token (ETH, BNB) to one or two other token
     * 
     * @param outAddress1 Token 1 address want to receive
     * @param outAddress2 Token 2 address want to receive
     * @param outPercent1 Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */
    function swapNativeToOtherTokens(address outAddress1, address outAddress2, uint outPercent1) 
        external override payable runable returns (bool){
        return _swapNativeToOtherTokens(outAddress1, outAddress2, outPercent1);
    }
    
    /**
     * @dev Swap token `from` address to native token (ETH, BNB) and another token
     * 
     * @param inAddress Token address want to swap
     * @param inAmount Token amount want to swap
     * @param otherTokenAddress Token 2 address want to receive
     * @param nativePercent Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToNativeAndOtherToken(address inAddress, uint inAmount, address otherTokenAddress, uint nativePercent) 
        external override runable returns (bool){
        return _swapTokenToNativeAndOtherToken(inAddress, inAmount, otherTokenAddress, nativePercent);
    }
    
    /**
     * @dev Swap token `from` address to one or two other token
     * 
     * @param inAddress Token address want to swap
     * @param inAmount Token amount want to swap
     * @param outAddress1 Token 1 address want to receive
     * @param outAddress2 Token 2 address want to receive
     * @param outPercent1 Token 1 percent want to receive from total from token. Ex: 50, 10, 5
     * 
     */ 
    function swapTokenToOtherTokens(address inAddress, uint inAmount, address outAddress1, address outAddress2, uint outPercent1) 
        external override runable returns (bool){
       return _swapTokenToOtherTokens(inAddress, inAmount, outAddress1, outAddress2, outPercent1);
    }
    
    /**
     * @dev Withdraw all native coin(ETH, BNB) from this contract, only called by owner 
    */ 
    function withdrawBNB() external onlyOwner{
        _msgSender().transfer(address(this).balance);
    }
    
    /**
     * @dev Withdraw all BEP20 token by `tokenAddress` from this contract, only called by owner 
     */ 
    function withdrawBEP20Token(address tokenAddress) external onlyOwner{
        IBEP20 tokenContract = IBEP20(tokenAddress);
        uint256 balance = tokenContract.balanceOf(address(this));
        tokenContract.transfer(_msgSender(), balance);
    }
    
    /*
    * @dev Calculate to get fee when user deposit basing on `inAmount` and `account`
    */
    function _calculateInAmountAfterFee(uint amount, address account) internal virtual returns(uint){
        uint fee = _getFeeByAddress(account);
        
        if(fee == 0)
            return amount;
            
        return amount.sub(amount.mul(_fee).div(100).div(_feeMultiplier));
    }
    
    /**
     * @dev Calculate from inAddress and outAddress to find the swapPath mapped with PancakeRouter 
     */ 
    function _calculateToGetSwapPath(address source, address to, ESwapType swapType) internal view returns(address[]memory){
        if(swapType == ESwapType.NativeToToken){
            address[] memory result =  new address[](2);
            result[0] = _wbnbAddress;
            result[1] = to;
            return result;
        }else if(swapType == ESwapType.TokenToNative){
            address[] memory result =  new address[](2);
            result[0] = source;
            result[1] = _wbnbAddress;
            return result;
        }else if(swapType == ESwapType.TokenToToken){
            address[] memory paths = _getSwapPath(source, to);
            if(paths.length < 2){
                if(source == _wbnbAddress || to == _wbnbAddress){
                    paths = new address[](2);
                    paths[0] = source;
                    paths[1] = to;
                }else{
                    paths = new address[](3);
                    paths[0] = source;
                    paths[1] = _wbnbAddress;
                    paths[2] = to;
                }
            }
            return paths;
        }
        
        return new address[](0);
    }
    
    /**
     * @dev Get fee percent configuration that will be token when user deposit to swap. multipled by 1000
     */ 
    function _getFee() internal view returns(uint){
        return _fee;
    }
    
    /**
     * @dev Get fee percent configuration that will be token when user deposit to swap. multipled by 1000
     * For address that is not applied fee, this will be zero fee
     */ 
    function _getFeeByAddress(address account) internal view returns(uint){
        (bool isNoAppliedFee,) = _isNoAppliedFee(account);
        if(isNoAppliedFee)
            return 0;
        return _getFee();
    }
    
    /**
     * @dev Calculate amount of inAmount will be divided for token 1 and token 2 based on token address and percent
     */ 
    function _getInAmountForToken1And2(uint inAmount, uint outPercent1) internal view returns(uint, uint){
        uint inAmount1 = 0;       //From token amount used to swap to to token 1
        uint inAmount2 = 0;       //From token amount used to swap to to token 2
        if(outPercent1 == _ratioMultiplier){
            inAmount1 = inAmount;
        }else if(outPercent1 == 0){
            inAmount2 = inAmount;
        }else{
            inAmount1 = inAmount.mul(outPercent1).div(_ratioMultiplier);
            inAmount2 = inAmount.sub(inAmount1);
        }
        
        return (inAmount1, inAmount2);
    }
    
    function _getOutAmountFromPancake(uint amount1, address token1, address token2) internal view returns(uint){
        address pairAddress = IPancakeFactory(_pancakeFactoryAddress).getPair(token1, token2);
        address pairToken1Address = IPancakePair(pairAddress).token0();
        (uint reserve1, uint reserve2,) = IPancakePair(pairAddress).getReserves();
        
        if(token1 == pairToken1Address){
            return amount1.mul(reserve2).sub(reserve1);
        }else{
            return amount1.mul(reserve1).sub(reserve2);
        }
    }
    
    /**
     * @dev Get manual swap path for a token pair
     */ 
    function _getSwapPath(address source, address to) internal view returns(address[]memory){
        return _swapPaths[source][to];
    }
    
    /*
     * @dev Check whether `account` is not applied fee or not
     * If yes, return index of `account` in list of no-applied-fee accounts
     */
    function _isNoAppliedFee(address account) internal view returns(bool, uint){
        for(uint index = 0; index < _noAppliedFeeAddresses.length; index++){
            if(_noAppliedFeeAddresses[index] == account)
                return (true, index);
        }
        
        return (false, 0);
    }
    
     /**
     * @dev Swap from native coin (ETH, BNB) to one or two token based on msg.value and `outPercent1`
     * 
     * Implementations:
     *  1. Validate Requirements
     *  2. Devide out1TokenAmount and out2TokenAmount base on `outPercent1`
     *  3. Call to PancakeRouter to swap tokens
     */
    function _swapNativeToOtherTokens(address outAddress1, address outAddress2, uint outPercent1) internal returns (bool){
        require(outAddress1 != address(0) || outAddress2 != address(0),"At least 1 to address is not zero address");
        require(outPercent1 <= _ratioMultiplier, "Percent is invalid");
        require(outAddress1 != outAddress2, "Destination tokens are the same");
        if(outPercent1 == 0)
            require(outAddress2 != address(0), "None value swapped");
        
        uint inAmount = msg.value;
        require(inAmount > uint(0), "inAmount should be greater than zero");
        
        //Calculate from amount if fee is used
        inAmount = _calculateInAmountAfterFee(inAmount, _msgSender());
        
        if(outAddress1 == address(0))
            outPercent1 = _ratioMultiplier;
        if(outAddress2 == address(0))
            outPercent1 = 0;
        
        //Calculate from token to swap to other token
        (uint inAmount1, uint inAmount2) = _getInAmountForToken1And2(inAmount, outPercent1);
        
        uint outAmount1 = 0;
        if(inAmount1 > 0){
            if(outAddress1 == _wbnbAddress){
                outAmount1 = inAmount1;
                
                //Deposit BNB to WBNB contract
                IWBNB(_wbnbAddress).deposit{value:inAmount1}();
                
                //Transfer WBNB amount to user
                require(IBEP20(_wbnbAddress).transfer(_msgSender(), inAmount1),"Can not transfer WBNB to user");
            }else{
                outAmount1 = _getOutAmountFromPancake(inAmount1, _wbnbAddress, outAddress1);
                address[] memory _swapPath = _calculateToGetSwapPath(_wbnbAddress, outAddress1, ESwapType.NativeToToken);
                    IPancakeRouter02(_pancakeRouterAddress).swapExactETHForTokensSupportingFeeOnTransferTokens{value:inAmount1}(
                        0,
                        _swapPath,
                        _msgSender(),
                        _now() + 60);
            }
        }
        
        uint outAmount2 = 0;
        if(inAmount2 > 0){
             if(outAddress2 == _wbnbAddress){
                //Deposit BNB to WBNB contract
                IWBNB(_wbnbAddress).deposit{value:inAmount2}();
                
                //Transfer WBNB amount to user
                require(IBEP20(_wbnbAddress).transfer(_msgSender(), inAmount2),"Can not transfer WBNB to user");
                outAmount2 = inAmount2;
            }else{
                outAmount2 = _getOutAmountFromPancake(inAmount2, _wbnbAddress, outAddress2);
                
                address[] memory _swapPath = _calculateToGetSwapPath(_wbnbAddress, outAddress2, ESwapType.NativeToToken);
                IPancakeRouter02(_pancakeRouterAddress).swapExactETHForTokensSupportingFeeOnTransferTokens{value:inAmount2}(
                    0,
                    _swapPath,
                    _msgSender(),
                    _now() + 60);
            }
        }
        
        emit SwapNativeToToken(_msgSender(), msg.value, outAddress1, outAmount1, outAddress2, outAmount2);
        
        return true;
    }
    
    /**
     * @dev Swap from token to native and another token based on msg.value and `nativePercent`
     * 
     * Implementations:
     *  1. Validate Requirements
     *  2. Devide out1TokenAmount and out2TokenAmount base on `nativePercent`
     *  3. Call to PancakeRouter to swap tokens
     */
    function _swapTokenToNativeAndOtherToken(address inAddress, uint inAmount, address otherTokenAddress, uint nativePercent) internal returns (bool){
        require(inAddress != address(0),"inAddress is zero address");
        require(inAddress != otherTokenAddress, "Can not swap to the same token");
        require(inAmount > uint(0), "inAmount should be greater than zero");
        require(nativePercent <= _ratioMultiplier, "Percent is invalid");
        if(nativePercent == 0)
            require(otherTokenAddress != address(0), "None value swapped");
        
        //Transfer token balance from user's address to DemoSwap address
        require(IBEP20(inAddress).transferFrom(_msgSender(), address(this), inAmount),"Can not transfer token to DemoSwap");
        
        inAmount = _calculateInAmountAfterFee(inAmount, _msgSender());
        
        if(otherTokenAddress == address(0))
            nativePercent = _ratioMultiplier;
        
        //Calculate from token to swap to other token
        uint fromNativeAmount = 0;       //From token amount used to swap to to token 1
        uint fromOtherAmount = 0;       //From token amount used to swap to to token 2
        if(nativePercent == _ratioMultiplier){
            fromNativeAmount = inAmount;
        }else if(nativePercent == 0){
            fromOtherAmount = inAmount;
        }else{
            fromNativeAmount = inAmount.mul(nativePercent).div(_ratioMultiplier);
            fromOtherAmount = inAmount.sub(fromNativeAmount); 
        }
        
        //Approve PancakeRouter to transfer inAmount token of DemoSwap
        require(IBEP20(inAddress).approve(_pancakeRouterAddress, inAmount),
            "Can not approve PancakeRouter to transfer token from DemoSwap");
        
        uint outAmount1 = 0;
        if(fromNativeAmount > 0){
            if(inAddress == _wbnbAddress){
                outAmount1 = fromNativeAmount;
                
                //Withdraw WBNB from contract to get BNB
                IWBNB(_wbnbAddress).withdraw(fromNativeAmount);
                
                //Send BNB from contract to user
                _msgSender().transfer(fromNativeAmount);
            }
            else{
                outAmount1 = _getOutAmountFromPancake(fromNativeAmount, inAddress, _wbnbAddress);
                address[] memory swapPath = _calculateToGetSwapPath(inAddress, _wbnbAddress, ESwapType.TokenToNative);
                IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForETHSupportingFeeOnTransferTokens(
                    fromNativeAmount,
                    0,
                    swapPath,
                    _msgSender(),
                    _now() + 60);
            }
        }
        
        uint outAmount2 = 0;
        if(fromOtherAmount > 0){
            outAmount2 = _getOutAmountFromPancake(fromOtherAmount, inAddress, otherTokenAddress);
            
            address[] memory swapPath = _calculateToGetSwapPath(inAddress, otherTokenAddress, ESwapType.TokenToToken);
            IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
                fromOtherAmount,
                0,
                swapPath,
                _msgSender(),
                _now() + 60);
        }
        
        emit SwapTokenToNativeAndToken(_msgSender(), inAddress, inAmount, outAmount1, otherTokenAddress, outAmount2);
        
        return true; 
    }
    
    /**
     * @dev Swap from one token to one or two token base on `inAmount` and `outPercent1`
     * 
     * Implementations:
     *  1. Validate Requirements
     *  2. Transfer `inAmount` inAddress of user to contract
     *  3. Devide out1TokenAmount and out2TokenAmount base on `outPercent1`
     *  4. Call to PancakeRouter to swap tokens
     */
    function _swapTokenToOtherTokens(address inAddress, uint inAmount, address outAddress1, address outAddress2, uint outPercent1) internal returns (bool){
        require(inAddress != address(0),"inAddress is zero address");
        require(outAddress1 != address(0) || outAddress2 != address(0),"At least 1 to address is not zero address");
        require(inAddress != outAddress1 && inAddress != outAddress2, "Can not swap to the same token");
        require(outAddress1 != outAddress2, "Destination tokens are the same");
        require(inAmount > uint(0), "inAmount should be greater than zero");
        require(outPercent1 <= _ratioMultiplier, "Percent is invalid");
        if(outPercent1 == 0)
            require(outAddress2 != address(0), "None value swapped");
        
        //Transfer token balance from user's address to DemoSwap address
        require(IBEP20(inAddress).transferFrom(msg.sender, address(this), inAmount),"Can not transfer token to DemoSwap");
        
        inAmount = _calculateInAmountAfterFee(inAmount, _msgSender());
        
        if(outAddress1 == address(0))
            outPercent1 = _ratioMultiplier;
        if(outAddress2 == address(0))
            outPercent1 = 0;
        
        //Calculate from token to swap to other token
        (uint inAmount1, uint inAmount2) = _getInAmountForToken1And2(inAmount, outPercent1);
        
        //Approve PancakeRouter to transfer inAmount token of DemoSwap
        require(IBEP20(inAddress).approve(_pancakeRouterAddress, inAmount),
            "Can not approve PancakeRouter to transfer token from DemoSwap");
        
        uint outAmount1 = 0;
        if(inAmount1 > 0){
            outAmount1 = _getOutAmountFromPancake(inAmount1, inAddress, outAddress1);
            
            address[] memory swapPath = _calculateToGetSwapPath(inAddress, outAddress1, ESwapType.TokenToToken);
            IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
                inAmount1,
                0,
                swapPath,
                _msgSender(),
                _now() + 60);
        }
        
        uint outAmount2 = 0;
        if(inAmount2 > 0){
            outAmount2 = _getOutAmountFromPancake(inAmount2, inAddress, outAddress2);
            
            address[] memory swapPath = _calculateToGetSwapPath(inAddress, outAddress2, ESwapType.TokenToToken);
            IPancakeRouter02(_pancakeRouterAddress).swapExactTokensForTokensSupportingFeeOnTransferTokens(
                inAmount2,
                0,
                swapPath,
                _msgSender(),
                _now() + 60);
        }
        
        emit SwapTokenToToken(_msgSender(), inAddress, inAmount, outAddress1, outAmount1, outAddress2, outAmount2);
        
        return true;
    }
    
    //EVENTS 
    event SwapTokenToToken(address indexed account, address inAddress, uint inAmount, address outAddress1, uint outAmount1, address outAddress2, uint outAmount2);
    event SwapTokenToNativeAndToken(address indexed account, address inAddress, uint inAmount, uint outAmount1, address outAddress2, uint outAmount2);
    event SwapNativeToToken(address indexed account, uint inAmount, address outAddress1, uint outAmount1, address outAddress2, uint outAmount2);
}

// SPDX-License-Identifier: MIT