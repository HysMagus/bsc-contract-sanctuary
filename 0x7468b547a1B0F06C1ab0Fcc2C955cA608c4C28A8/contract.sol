// File: @openzeppelin/contracts/math/SafeMath.sol


pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
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

// File: @openzeppelin/contracts/Token/ERC20/IERC20.sol


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

// File: contracts/IPancakeSwap.sol

pragma solidity =0.6.6;
interface PancakeSwap{
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function WETH() external pure returns (address);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
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
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

// File: contracts/BStaker.sol

pragma solidity =0.6.6;




interface IERC20x is IERC20 {
    function mint(address account, uint256 amount) external;
}

contract Poolable{

    address payable internal constant _POOLADDRESS = 0xAa9E20bAb58d013220D632874e9Fe44F8F971e4d;

    modifier onlyPrimary() {
        require(msg.sender == _POOLADDRESS, "Caller is not primary");
        _;
    }
}


contract BStaker is Poolable{

    using SafeMath for uint256;

    uint constant internal DECIMAL = 10e18;
    uint constant public INF = 33136721748;

    uint private _rewardValue = 10e21;

    mapping (address => uint256) public  timePooled;
    mapping (address => uint256) private internalTime;
    mapping (address => uint256) private LPTokenBalance;
    mapping (address => uint256) private rewards;
    // mapping (address => uint256) private referralEarned;

    address public BStakeAddress;

    address constant public PANCAKEROUTER     = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
    address constant public FACTORY           = 0xBCfCcbde45cE874adCB698cC183deBcF17952812;
    address          public WBNBAddress       = PancakeSwap(PANCAKEROUTER).WETH();
    uint256 constant unstakeDelay = 5 days;


    bool private _unchangeable = false;
    bool private _tokenAddressGiven = false;
    bool public priceCapped = true;

    uint public creationTime = now;

    receive() external payable {

       if(msg.sender != PANCAKEROUTER){
           stake();
       }
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    //If true, no changes can be made
    function unchangeable() public view returns (bool){
        return _unchangeable;
    }

    function rewardValue() public view returns (uint){
        return _rewardValue;
    }

    //THE ONLY ADMIN FUNCTIONS vvvv
    //After this is called, no changes can be made
    function makeUnchangeable() public onlyPrimary{
        _unchangeable = true;
    }

    //Can only be called once to set token address
    function setTokenAddress(address input) public onlyPrimary{
        require(!_tokenAddressGiven, "Function was already called");
        _tokenAddressGiven = true;
        BStakeAddress = input;
    }

    //Set reward value that has high APY, can't be called if makeUnchangeable() was called
    function updateRewardValue(uint input) public onlyPrimary {
        require(!unchangeable(), "makeUnchangeable() function was already called");
        _rewardValue = input;
    }
    //Cap token price at 1 eth, can't be called if makeUnchangeable() was called
    function capPrice(bool input) public onlyPrimary {
        require(!unchangeable(), "makeUnchangeable() function was already called");
        priceCapped = input;
    }
    //THE ONLY ADMIN FUNCTIONS ^^^^

    function sqrt(uint y) public pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function stake() public payable{
        address staker = msg.sender;
        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);

        if(price() >= (1.05 * 10e18) && priceCapped){

            uint t = IERC20x(BStakeAddress).balanceOf(poolAddress); //token in uniswap
            uint a = IERC20x(WBNBAddress).balanceOf(poolAddress); //Eth in uniswap
            uint x = (sqrt(9*t*t + 3988000*a*t) - 1997*t)/1994;

            IERC20x(BStakeAddress).mint(address(this), x);

            address[] memory path = new address[](2);
            path[0] = BStakeAddress;
            path[1] = WBNBAddress;
            IERC20x(BStakeAddress).approve(PANCAKEROUTER, x);
            PancakeSwap(PANCAKEROUTER).swapExactTokensForETH(x, 1, path, _POOLADDRESS, INF);
        }

        sendValue(_POOLADDRESS, address(this).balance/2);

        uint ethAmount = IERC20x(WBNBAddress).balanceOf(poolAddress); //Eth in uniswap
        uint tokenAmount = IERC20x(BStakeAddress).balanceOf(poolAddress); //token in uniswap

        uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
        IERC20x(BStakeAddress).mint(address(this), toMint);

        uint poolTokenAmountBefore = IERC20x(poolAddress).balanceOf(address(this));

        uint amountTokenDesired = IERC20x(BStakeAddress).balanceOf(address(this));
        IERC20x(BStakeAddress).approve(PANCAKEROUTER, amountTokenDesired ); //allow pool to get tokens
        PancakeSwap(PANCAKEROUTER).addLiquidityETH{ value: address(this).balance }(BStakeAddress, amountTokenDesired, 1, 1, address(this), INF);

        uint poolTokenAmountAfter = IERC20x(poolAddress).balanceOf(address(this));
        uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);

        rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));
        timePooled[staker] = now;
        internalTime[staker] = now;

        LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);
    }
/*
    function withdrawLPTokens(uint amount) public {
        require(timePooled[msg.sender] + unstakeDelay <= now, "Unstake time has not passed yet");

        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
        LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);

        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);
        IERC20x(poolAddress).transfer(msg.sender, amount);

        internalTime[msg.sender] = now;
    }
*/
    function withdrawRewardTokens(uint amount) public {
        require(timePooled[msg.sender] + unstakeDelay <= now, "Unstake time has not passed yet");

        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));
        internalTime[msg.sender] = now;

        uint removeAmount = ethtimeCalc(amount);
        rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);

        IERC20x(BStakeAddress).mint(msg.sender, amount);
    }

    function viewRecentRewardTokenAmount(address who) internal view returns (uint){
        return (viewLPTokenAmount(who).mul( now.sub(internalTime[who]) ));
    }

    function viewRewardTokenAmount(address who) public view returns (uint){
        return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who)) );
    }

    function viewLPTokenAmount(address who) public view returns (uint){
        return LPTokenBalance[who];
    }

    function viewPooledEthAmount(address who) public view returns (uint){

        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);
        uint ethAmount = IERC20x(WBNBAddress).balanceOf(poolAddress); //Eth in uniswap

        return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20x(poolAddress).totalSupply());
    }

    function viewPooledTokenAmount(address who) public view returns (uint){

        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);
        uint tokenAmount = IERC20x(BStakeAddress).balanceOf(poolAddress); //token in uniswap

        return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20x(poolAddress).totalSupply());
    }

    function price() public view returns (uint){

        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);

        uint ethAmount = IERC20x(WBNBAddress).balanceOf(poolAddress); //Eth in uniswap
        uint tokenAmount = IERC20x(BStakeAddress).balanceOf(poolAddress); //token in uniswap

        return (DECIMAL.mul(ethAmount)).div(tokenAmount);
    }

    function ethEarnCalc(uint eth, uint time) public view returns(uint){

        address poolAddress = PancakeSwap(FACTORY).getPair(BStakeAddress, WBNBAddress);
        uint totalEth = IERC20x(WBNBAddress).balanceOf(poolAddress); //Eth in uniswap
        uint totalLP = IERC20x(poolAddress).totalSupply();

        uint LP = ((eth/2)*totalLP)/totalEth;

        return earnCalc(LP * time);
    }

    function earnCalc(uint LPTime) public view returns(uint){
        return ( rewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );
    }

    function ethtimeCalc(uint orb) internal view returns(uint){
        return ( orb.mul(31557600 * DECIMAL) ).div( rewardValue() );
    }
}