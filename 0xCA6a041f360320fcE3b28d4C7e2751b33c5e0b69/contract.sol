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

interface IMasterChef {

    function mint(address _user, uint256 _amount) external;

}

// File: contracts/Lottery.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;





contract Lottery is Basic {

    using SafeMath for uint256;
    IERC20 public token;
    IMasterChef public masterchef;

    uint256 public decimals = 18;
    uint public finishedCount = 1000;
    uint256 public turns = 10;  
    uint public lastRound;
    uint256 public earnings;
    address public payment;
    uint256[6] public gainPercent = [40, 20, 15, 10, 8, 7];
    uint256 public tokensGame = 100 ether;

    struct RoundStruct {
        bool isExist;
        bool turn;
        uint id;
        uint start;
        uint finish;
        uint totalParticipants;
        uint256 amount;
    }
    mapping(uint => RoundStruct) public Rounds;
    mapping(uint => mapping (uint => address)) public RoundsParticipants;
    mapping(uint => mapping (address => uint)) public ParticipantsTurns;
    mapping(address => uint) public unclaimedTokens;
    mapping(uint => mapping (uint => address)) public winners;

    constructor(address _token, address _masterchef, address _payment) public {
        token = IERC20(_token);
        masterchef = IMasterChef(_masterchef);
        payment = _payment;
    }

    function setDecimals(uint256 _count) external onlyMod {
        decimals = _count;
        emit eventDecimals(now, _count);
    }

    function setFinishedCount(uint256 _count) external onlyMod {
        finishedCount = _count;
        emit eventfinishedCount(now, _count);
    }
    
    function setTurns(uint256 _count) external onlyMod {
        turns = _count;
        emit eventTurns(now, _count);
    }
    
    function Game(uint _turns) external returns (bool) {
        require(Rounds[lastRound].turn == false, "The voting is over");
        require(_turns <= turns, "You can't buy so many shifts");
        require((checkTurns() + _turns) <= turns, "You can't buy so many shifts");
        require((_turns + Rounds[lastRound].totalParticipants) <= finishedCount, "Buy fewer shifts");
        require(
            token.balanceOf(msg.sender) >= (_turns * (10 ** decimals)),
            "You do not have the amount of tokens to deposit"
        );
        require(
            token.transferFrom(msg.sender, address(this), (_turns * (10 ** decimals))) == true,
            "You have not approved the deposit"
        );
        if( Rounds[lastRound].isExist == false ){
            RoundStruct memory round_struct;
            round_struct = RoundStruct({
                isExist: true,
                turn: false,
                id: lastRound,
                start: now,
                finish: 0,
                totalParticipants: 0,
                amount: 0
            });
            Rounds[lastRound] = round_struct;
        }
        for(uint i = 1; i<=_turns; i++){
            RoundsParticipants[lastRound][Rounds[lastRound].totalParticipants] = msg.sender;
            Rounds[lastRound].totalParticipants++;
            ParticipantsTurns[lastRound][msg.sender]++;
        }
        if( Rounds[lastRound].totalParticipants >= (finishedCount) ){
            Rounds[lastRound].turn = true;
            finishTurns();
        }
        return true;
    }

    function finishTurns() private {
        require(Rounds[lastRound].turn == true, "The voting is over");
        if( Rounds[lastRound].totalParticipants >= (finishedCount) ){
            finishedGame();
            Rounds[lastRound].finish = now;
            lastRound++;
        }
    }

    function finishedGame() private {
        uint count = 0;
        uint x = 1;
        uint256 balance = tokensGame;
        earnings = earnings.add(balance);
        Rounds[lastRound].amount = balance;
        while(x <= 6){
            count++;
            address _userCheck = RoundsParticipants[lastRound][randomness(count)];
            if(_userCheck != address(0) && _userCheck != address(0x0)){
                winners[lastRound][x] = _userCheck;
                uint256 percentage = getPercentage(x);
                uint256 amount = (balance.mul(percentage)).div(100);
                sendToken(_userCheck, amount);
                x++;
            }
        }
        for(uint i = 0; i<=Rounds[lastRound].totalParticipants; i++){   
            unclaimedTokens[RoundsParticipants[lastRound][i]] = ParticipantsTurns[lastRound][RoundsParticipants[lastRound][i]] * (10 ** 18);
        }
        uint256 amountDevs = balance.div(10);
        sendToken(payment, amountDevs);
    }

    function claim() public {
        require(unclaimedTokens[msg.sender] > 0, "you don't have tokens to claim");
        token.transfer(msg.sender, unclaimedTokens[msg.sender]);
        unclaimedTokens[msg.sender] = 0;
    }

    function setTokensGame(uint256 _tokensGame) public onlyOwner {
        tokensGame = _tokensGame;
    }

    function addressPayment(address _payment) public onlyOwner {
        payment = _payment;
    }

    function setPercent(uint256 r_1, uint256 r_2, uint256 r_3, uint256 r_4, uint256 r_5, uint256 r_6) external onlyOwner {
        gainPercent[0] = r_1;
        gainPercent[1] = r_2;
        gainPercent[2] = r_3;
        gainPercent[3] = r_4;
        gainPercent[4] = r_5;
        gainPercent[5] = r_6;
    }      

    function sendToken(address _user, uint256 _amount) private {
        if( _amount > 0 && (_user != address(0) && _user != address(0x0))){
            masterchef.mint(_user, _amount);
        }
    }

    function checkTurnsUsers(address _user) public view returns(uint){
        return ParticipantsTurns[lastRound][_user];
    }

    function checkTurns() public view returns(uint){
        return ParticipantsTurns[lastRound][msg.sender];
    }

    function randomness(uint nonce) public view returns (uint) {
        return uint(uint(keccak256(abi.encode(block.timestamp, block.difficulty, nonce)))%(Rounds[lastRound].totalParticipants+1));
    }

    function getPercentage(uint x) public view returns (uint256){
        if(x == 1){return gainPercent[0];}
        else if(x == 2){return gainPercent[1];}
        else if(x == 3){return gainPercent[2];}
        else if(x == 4){return gainPercent[3];}
        else if(x == 5){return gainPercent[4];}
        else if(x == 6){return gainPercent[5];}
    }

    event eventDecimals(uint256 indexed _time, uint256 indexed _count);

    event eventfinishedCount(uint256 indexed _time, uint256 indexed _count);

    event eventTurns(uint256 indexed _time, uint256 indexed _count);

}