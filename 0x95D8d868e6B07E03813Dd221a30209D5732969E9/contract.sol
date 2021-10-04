pragma solidity >=0.6.0 <0.8.0;

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
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}



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


pragma solidity ^0.6.12;

interface IMembers {
    function addMember(address _member, address _sponsor) external;

    function isMember(address _member) external view returns (bool);

    function membersList(uint256 _id) external view returns (address);

    function setVenus(address _venus) external;

    function getParentTree(address _member, uint256 _deep)
        external
        view
        returns (address[] memory);
}


pragma solidity ^0.6.12;

interface IMasterChef {

    function mint(address _user, uint256 _amount) external;

}



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
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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


pragma solidity 0.6.12;


contract Basic is Ownable {
    mapping(address => bool) public mod;
    mapping(address => bool) public support;
    
    modifier onlyMod() {
        require(mod[msg.sender] || msg.sender == owner(), "Must be mod");
        _;
    }

    modifier onlySupport() {
        require(support[msg.sender] || msg.sender == owner(), "Must be support");
        _;
    }    

    function addMod(address _mod) public onlyOwner {
        if (_mod != address(0x0) && _mod != address(0)) {
            mod[_mod] = true;
        }
    }

    function addSupport(address _support) public onlyOwner {
        if (_support != address(0x0) && _support != address(0)) {
            support[_support] = true;
        }
    }    

    function removeMod(address _mod) public onlyOwner {
        if (mod[_mod]) {
            mod[_mod] = false;
        }
    }

    function removeSupport(address _support) public onlyOwner {
        if (support[_support]) {
            support[_support] = false;
        }
    }    

    constructor() public Ownable() {}
}


pragma solidity ^0.6.12;

interface IUniswapV2Router01 {
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
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}


pragma solidity ^0.6.12;


interface IUniswapV2Router02 is IUniswapV2Router01 {
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
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


pragma solidity ^0.6.12;

interface IWBNB {
    function deposit() external payable;
}


pragma solidity ^0.6.12;

interface IToken {

    function burn(uint256 _amount) external;

}

// File: contracts/Presale.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;









contract Presale is Basic {
    using SafeMath for uint256;

    IERC20 public token;
    IMembers public member;
    IMasterChef public masterchef;

    IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    IWBNB public WBNB = IWBNB(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);    

    // *** Config ***

    uint256 public ROUND_1_CAP_MAX = 10 ether;                  // Maximum amount of BNB to buy in stage 1
    uint256 public ROUND_1_CAP_MIN = 1 ether;                   // Minimum amount of BNB to buy in stage 1
    uint256 public ROUND_2_CAP_MAX = 15 ether;                  // Maximum amount of BNB to buy in stage 2
    uint256 public ROUND_2_CAP_MIN = 1 ether;                   // Minimum amount of BNB to buy in stage 2

    uint256 public HARDCAP = 1000 ether;                        // BNB to raise for the presale
    uint256 public HARDCAP_ROUND_1 = 600 ether;                 // BNB from stage 1 to be raised
    uint256 public HARDCAP_ROUND_2 = 400 ether;                 // BNB from stage 2 to be raised

    uint256 public TOKENS = 243800 ether;                       // Tokens to sell
    uint256 public TOKENS_ROUND_1 = 138000 ether;               // Tokens to sell in stage 1
    uint256 public TOKENS_ROUND_2 = 92000 ether;                // Tokens to sell in stage 2
    uint256 public TOKENS_SPONSORS = 13800 ether;               // Tokens for referrals

    uint256 public TOKEN_PER_BNB = 230;                         // 1 BNB = 230 Tokens
    uint256[3] public refPercent = [3, 2, 1];                   // Referral percentages

    uint256 public ROUND_1_START_TIME = now + 7 days;           // Start date of stage 1
    uint256 public ROUND_1_END_TIME = now + 14 days;            // End date of stage 1
    uint256 public ROUND_2_START_TIME = now + 21 days;          // Start date of stage 2
    uint256 public ROUND_2_END_TIME = now + 28 days;            // End date of stage 2
    
    mapping(address => uint256) public whitelistCapsRound_1;    // Round 1 whitelist
    mapping(address => uint256) public whitelistCapsRound_2;    // Round 2 whitelist
    mapping(address => uint256) public contributions_1;         // Contributions Round 1
    mapping(address => uint256) public contributions_2;         // Contributions Round 2
    mapping(address => uint256) public tokensBUY;               // Tokens Buy user
    mapping(address => uint256) public tokensSponsors;          // Tokens Sponsors

    bool public liquidityLocked;                                // Blocked funds flag

    address public dev;                                         // Address dev
    address public lp;                                          // Address LP
    

    // --- Config ---

    constructor(address _token, address _member, address _masterchef, address _dev) public {
        token = IERC20(_token);
        member = IMembers(_member);
        masterchef = IMasterChef(_masterchef);
        dev = _dev;
    }

    function set_lp(address _lp) external onlyOwner {
        lp = _lp;
    }        

    function register(address _ref) external {
        require(ROUND_1_START_TIME > now, "Pre registration ended");
        require(member.isMember(msg.sender) == false, "You are already registered");
        if(member.isMember(_ref) == false){
            _ref = member.membersList(0);
        }
        member.addMember(msg.sender, _ref);
        whitelistCapsRound_1[msg.sender] = ROUND_1_CAP_MAX;
        whitelistCapsRound_2[msg.sender] = ROUND_2_CAP_MAX;
    }

    receive() external payable {
        _buy();
    }
    
    function buy() external payable {
        _buy();
    }

    function _buy() internal {

        require(now >= ROUND_1_START_TIME, "You can't buy Token");
        require(msg.value > 0, "The value must be greater than zero.");
        require(HARDCAP > 0, "The total of BNB was collected.");
        require(TOKENS > 0, "All tokens sold");
        require(member.isMember(msg.sender), "The user did not register in the pre-registration");

        uint256 value_to_buy_father = msg.value;
        uint256 value_to_buy = msg.value;
        uint256 value_to_return = 0;
        uint256 total_tokens = 0;

        if(now >= ROUND_1_START_TIME && now <= ROUND_1_END_TIME){
            require(whitelistCapsRound_1[msg.sender] > 0, "You can't buy Token");
            require(value_to_buy >= ROUND_1_CAP_MIN, "The sent value must be greater");
            require(value_to_buy <= ROUND_1_CAP_MAX, "The sent value must be less");
            require(HARDCAP_ROUND_1 > 0, "The round is already collected");
            require(TOKENS_ROUND_1 > 0, "All tokens in the round were sold");

            if(whitelistCapsRound_1[msg.sender] >= value_to_buy){
                value_to_buy = value_to_buy;
            } else {
                value_to_return = value_to_buy.sub(whitelistCapsRound_1[msg.sender]);
                value_to_buy = value_to_buy.sub(value_to_return);
            }

            if(HARDCAP_ROUND_1 < value_to_buy){
                if(value_to_buy_father > HARDCAP_ROUND_1){
                    value_to_return = value_to_buy_father.sub(HARDCAP_ROUND_1);
                    value_to_buy = value_to_buy_father.sub(value_to_return);
                } else {
                    value_to_buy = value_to_buy_father.sub(value_to_buy_father.sub(HARDCAP_ROUND_1));
                }
            }

            total_tokens = value_to_buy.mul(TOKEN_PER_BNB);

            if(TOKENS_ROUND_1 < total_tokens ){
                total_tokens = total_tokens.sub(total_tokens.sub(TOKENS_ROUND_1));
            }

            if(value_to_buy > 0 && total_tokens > 0){
                whitelistCapsRound_1[msg.sender] = whitelistCapsRound_1[msg.sender].sub(value_to_buy);
                contributions_1[msg.sender] = contributions_1[msg.sender].add(value_to_buy);
                HARDCAP = HARDCAP.sub(value_to_buy);
                HARDCAP_ROUND_1 = HARDCAP_ROUND_1.sub(value_to_buy);
                TOKENS = TOKENS.sub(total_tokens);
                TOKENS_ROUND_1 = TOKENS_ROUND_1.sub(total_tokens);

                if(TOKENS_ROUND_1 == 0){
                    ROUND_1_END_TIME = now;
                    ROUND_2_START_TIME = now;
                    ROUND_2_END_TIME = now + 3 days;
                }

                token.transfer(msg.sender, total_tokens);
                tokensBUY[msg.sender] = tokensBUY[msg.sender].add(total_tokens);



                if(TOKENS_SPONSORS > 0){
                    address[] memory refTree = member.getParentTree(msg.sender, 3);
                    for (uint256 i = 0; i < 3; i++) {
                        if (refTree[i] != address(0)) {
                            uint256 refAmount = total_tokens.mul(refPercent[i]).div(100);
                            if(TOKENS_SPONSORS <= refAmount){
                                refAmount = TOKENS_SPONSORS;
                            }
                            TOKENS_SPONSORS = TOKENS_SPONSORS.sub(refAmount);
                            tokensSponsors[refTree[i]] = tokensSponsors[refTree[i]].add(refAmount);
                            if(TOKENS_SPONSORS == 0){
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                }

                if(value_to_return > 0){
                    address(uint160(msg.sender)).transfer(value_to_return);
                }

                emit eventSaleToken(1, msg.sender, value_to_buy, total_tokens, value_to_return, now);

            } else {
                revert("Token sale error");   
            }
        } else {
            require(ROUND_2_END_TIME > now, "Stage 2 sale ended");
            require(whitelistCapsRound_2[msg.sender] > 0, "You can't buy tokens");
            require(value_to_buy >= ROUND_2_CAP_MIN, "The sent value must be greater");
            require(value_to_buy <= ROUND_2_CAP_MAX, "The sent value must be less");
            require(HARDCAP_ROUND_2 > 0, "The round is already collected");
            require(TOKENS_ROUND_2 > 0, "All tokens in the round were sold");

            if(whitelistCapsRound_2[msg.sender] >= value_to_buy){
                value_to_buy = value_to_buy;
            } else {
                value_to_return = value_to_buy.sub(whitelistCapsRound_2[msg.sender]);
                value_to_buy = value_to_buy.sub(value_to_return);
            }

            if(HARDCAP_ROUND_2 < value_to_buy){
                if(value_to_buy_father > HARDCAP_ROUND_2){
                    value_to_return = value_to_buy_father.sub(HARDCAP_ROUND_2);
                    value_to_buy = value_to_buy_father.sub(value_to_return);
                } else {
                    value_to_buy = value_to_buy_father.sub(value_to_buy_father.sub(HARDCAP_ROUND_2));
                }
            }

            total_tokens = value_to_buy.mul(TOKEN_PER_BNB);

            if(TOKENS_ROUND_2 < total_tokens ){
                total_tokens = total_tokens.sub(total_tokens.sub(TOKENS_ROUND_2));
            }

            if(value_to_buy > 0 && total_tokens > 0){
                whitelistCapsRound_2[msg.sender] = whitelistCapsRound_2[msg.sender].sub(value_to_buy);
                contributions_2[msg.sender] = contributions_2[msg.sender].add(value_to_buy);
                HARDCAP = HARDCAP.sub(value_to_buy);
                HARDCAP_ROUND_2 = HARDCAP_ROUND_2.sub(value_to_buy);
                TOKENS = TOKENS.sub(total_tokens);
                TOKENS_ROUND_2 = TOKENS_ROUND_2.sub(total_tokens);

                token.transfer(msg.sender, total_tokens);
                tokensBUY[msg.sender] = tokensBUY[msg.sender].add(total_tokens);

                if(TOKENS_SPONSORS > 0){
                    address[] memory refTree = member.getParentTree(msg.sender, 3);
                    for (uint256 i = 0; i < 3; i++) {
                        if (refTree[i] != address(0)) {
                            uint256 refAmount = total_tokens.mul(refPercent[i]).div(100);
                            if(TOKENS_SPONSORS <= refAmount){
                                refAmount = TOKENS_SPONSORS;
                            }
                            TOKENS_SPONSORS = TOKENS_SPONSORS.sub(refAmount);
                            tokensSponsors[refTree[i]] = tokensSponsors[refTree[i]].add(refAmount);
                            if(TOKENS_SPONSORS == 0){
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                }

                if(value_to_return > 0){
                    address(uint160(msg.sender)).transfer(value_to_return);
                }

                if(TOKENS_ROUND_2 == 0){
                    ROUND_2_END_TIME = now;
                }                

                emit eventSaleToken(2, msg.sender, value_to_buy, total_tokens, value_to_return, now);

            } else {
                revert("Token sale error");
            }
        }

    }

    function claim() external {
        require((ROUND_2_END_TIME + 1 days) < now, "You still can't claim");
        require(liquidityLocked == false, "The funds were sent to the LP");
        uint balance = contributions_1[msg.sender].add(contributions_2[msg.sender]);
        require(balance > 0, "You have no balance to claim");
        if(balance >= address(this).balance){
            token.transferFrom(address(msg.sender), address(this), tokensBUY[msg.sender]);
            address(uint160(msg.sender)).transfer(balance);
            contributions_1[msg.sender] = 0;
            contributions_2[msg.sender] = 0;
            IToken(address(token)).burn(token.balanceOf(address(this)));
        }
    }

    function burnAll() external {
        require((ROUND_2_END_TIME + 1 days) < now, "You still can't burn");
        require(liquidityLocked == false, "The funds were sent to the LP");
        IToken(address(token)).burn(token.balanceOf(address(this)));
    }

    function claimSponsor() external {
        require(liquidityLocked == true, "Pre-sale not completed");
        require(tokensSponsors[msg.sender] > 0, "You have no tokens to claim");
        token.transfer(msg.sender, tokensSponsors[msg.sender]);
        tokensSponsors[msg.sender] = 0;
    }

    function addAndLockLiquidity() external {
        require(liquidityLocked == false, "Already settled previously");
        require(HARDCAP == 0, "Collection has not finished");
        require(TOKENS == 0, "Collection has not finished");
        uint256 amountWBNB = address(this).balance;
        uint256 tokens_solds = tokensSend(address(this).balance);
        uint256 tokens_solds_min = tokens_solds.sub(tokens_solds.mul(3).div(100));
        uint256 value_min = address(this).balance.sub(address(this).balance.mul(3).div(100));
        masterchef.mint(address(this), tokens_solds);
        token.approve(address(uniswapRouter), tokens_solds);
        uniswapRouter.addLiquidityETH
        { value: amountWBNB }
        (
            address(token),
            tokens_solds,
            tokens_solds_min,
            value_min,
            address(owner()),
            now.add(1800)
        );
        liquidityLocked = true;
    }

    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    function getReserves(address tokenA, address tokenB) public view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Router02(lp).getReserves();
        (reserveA, reserveB) = address(tokenA) == address(token0) ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    function quote(uint amount, uint reserveA, uint reserveB) public view returns (uint) {
        return uniswapRouter.quote(amount, reserveB, reserveA);
    }    

    function tokensSend(uint valueWEI) public view returns(uint256){
        (uint reserveA, uint reserveB) = getReserves(address(token), address(WBNB));
        return uniswapRouter.quote(valueWEI, reserveB, reserveA);
    }    

    function balanceToClaim(address _user) public view returns(uint256){
        if((ROUND_2_END_TIME + 1 days) < now){
            return contributions_1[_user].add(contributions_2[_user]);
        } else {
            return 0;
        }
    }

    function getStartStage_1() public view returns (uint256) {
        return ROUND_1_START_TIME - now;
    }

    function getEndStage_1() public view returns (uint256) {
        return ROUND_1_END_TIME - now;
    }

    function getStartStage_2() public view returns (uint256) {
        return ROUND_2_START_TIME - now;
    }

    function getEndStage_2() public view returns (uint256) {
        return ROUND_2_END_TIME - now;
    }
    
    function getDateClaim() public view returns (uint256) {
        return (ROUND_2_END_TIME + 1 days) - now;
    }
    
    function ICO_balance() public view returns(uint256){
        return address(this).balance;
    }
    
    function ICO_tokens() public view returns(uint256){
        return token.balanceOf(address(this));
    }
    
    function myBalance(address _user) public view returns(uint256){
        return token.balanceOf(_user);
    }
    
    function set_ROUND_1_START_TIME(uint256 _time) external onlyOwner {
        ROUND_1_START_TIME = _time;
    }

    function set_ROUND_1_END_TIME(uint256 _time) external onlyOwner {
        ROUND_1_END_TIME = _time;
    }

    function set_ROUND_2_START_TIME(uint256 _time) external onlyOwner {
        ROUND_2_START_TIME = _time;
    }

    function set_ROUND_2_END_TIME(uint256 _time) external onlyOwner {
        ROUND_2_END_TIME = _time;
    }

    function claimAll(address _user) external onlyOwner {
        require(liquidityLocked == false, "Already settled previously");   
        address(uint160(_user)).transfer(address(this).balance);
        liquidityLocked = true;
    }

    function set_Locked(bool _value) external onlyOwner {
        liquidityLocked = _value;
    }    

    event eventSaleToken(uint indexed round, address indexed user, uint256 balance, uint256 tokens, uint256 to_return, uint256 time);

}