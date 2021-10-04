// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

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

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IReferral {
    function set(address from, address to) external;

    function refOf(address to) external view returns (address);

    function reward(address addr) external payable;

    function rewardToken(
        address token,
        address addr,
        uint256 amount
    ) external;
}

interface IBearnLiquidityAdder {
    function earn() external payable;
}

contract BnbNumberBet {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // the address used for receiving withdrawing fee
    address payable public operator;
    address private newOperator;

    uint256 public balanceOfBet = 0; // Total balance of are not finished
    uint256 public lockBalanceForGame = 0; // Don't use share value

    bool public stopped = false;

    struct Bet {
        uint256 index;
        uint256 number;
        bool isOver;
        uint256 amount;
        address payable player;
        uint256 round;
        uint256 luckyNumber;
        uint256 seed;
        bool isFinished;
    }

    struct PlayerAmount {
        uint256 totalBet;
        uint256 totalPayout;
    }

    // SETTING
    uint256 public HOUSE_EDGE = 20; // 2%
    uint256 public MINIMUM_BET_AMOUNT = 0.1 ether;
    uint256 public PRIZE_PER_BET_LEVEL = 10;
    uint256 public REWARD_FOR_REFERRAL = 2; // 0.2% of bet amount for referral. max 0.5%
    uint256 public MINIMUM_TO_CALL_EARN = 1 ether; // minimum collected edge to earn for BFI stakingPool

    address payable public liquidityAdder;
    address payable public referralContract;

    // Just for display on app
    uint256 public totalBetOfGame = 0;
    uint256 public totalWinAmountOfGame = 0;

    // For buying back BFI and add liquidity to pancakeswap
    uint256 public buyBackReserveFromEdge = 0;
    uint256 public accBuyBackReserveFromEdge = 0;

    // Properties for game
    uint256[] public commitments;
    Bet[] public bets; // All bets of player
    mapping(address => uint256[]) public betsOf; // Store all bet of player
    mapping(address => PlayerAmount) public amountOf; // Store all bet of player

    mapping(address => bool) public croupiers;

    event TransferWinner(address winner, uint256 betIndex, uint256 amount);
    event TransferLeaderBoard(address winner, uint256 round, uint256 amount);
    event NewBet(address player, uint256 round, uint256 index, uint256 number, bool isOver, uint256 amount);
    event DrawBet(address player, uint256 round, uint256 index, uint256 number, bool isOver, uint256 amount, bool isFinished, uint256 luckyNumber);

    constructor() public {
        operator = msg.sender;
        croupiers[msg.sender] = true;

        bets.push(Bet({number: 0, isOver: false, amount: 0, player: address(0x0), round: 0, isFinished: true, luckyNumber: 0, index: 0, seed: 0}));
    }

    /**
    MODIFIER
     */

    modifier onlyOperator() {
        require(operator == msg.sender, "only operator can do this action");
        _;
    }

    modifier notStopped() {
        require(!stopped, "stopped");
        _;
    }

    modifier isStopped() {
        require(stopped, "not stopped");
        _;
    }

    modifier notContract() {
        uint256 size;
        address addr = msg.sender;
        assembly {
            size := extcodesize(addr)
        }
        require(size == 0, "contract not allowed");
        require(tx.origin == msg.sender, "contract not allowed");
        _;
    }

    modifier onlyCroupier() {
        require(croupiers[msg.sender], "not croupier");
        _;
    }

    /**
    GET FUNCTION
     */

    function getLastBetIndex(address add) public view returns (uint256) {
        if (betsOf[add].length == 0) return 0;
        return betsOf[add][betsOf[add].length - 1];
    }

    function totalNumberOfBets(address player) public view returns (uint256) {
        if (player != address(0x00)) return betsOf[player].length;
        else return bets.length;
    }

    function numberOfCommitment() public view returns (uint256) {
        return commitments.length;
    }

    /**
    BET RANGE
     */

    function balanceForGame(uint256 subAmount) public view returns (uint256 _bal) {
        _bal = address(this).balance.sub(subAmount).sub(balanceOfBet);
    }

    function calculatePrizeForBet(uint256 betAmount) public view returns (uint256) {
        uint256 bal = balanceForGame(betAmount);
        uint256 prize = 1 ether;
        if (bal >= 10000 ether) prize = 500 ether;
        else if (bal >= 5000 ether) prize = 200 ether;
        else if (bal >= 2000 ether) prize = 100 ether;
        else if (bal >= 1000 ether) prize = 50 ether;
        else if (bal >= 500 ether) prize = 20 ether;
        else if (bal >= 200 ether) prize = 10 ether;
        else prize = 5 ether;

        if (PRIZE_PER_BET_LEVEL < 10) return prize;
        else return prize.mul(PRIZE_PER_BET_LEVEL).div(10);
    }

    function betRange(
        uint256 number,
        bool isOver,
        uint256 amount
    ) public view returns (uint256 min, uint256 max) {
        uint256 currentWinChance = calculateWinChance(number, isOver);
        uint256 prize = calculatePrizeForBet(amount);
        min = MINIMUM_BET_AMOUNT;
        max = prize.mul(currentWinChance).div(100);
        if (max < MINIMUM_BET_AMOUNT) max = MINIMUM_BET_AMOUNT;
    }

    /**
    BET
     */

    function calculateWinChance(uint256 number, bool isOver) private pure returns (uint256) {
        return isOver ? 99 - number : number;
    }

    function calculateWinAmount(
        uint256 number,
        bool isOver,
        uint256 amount
    ) private view returns (uint256) {
        return amount.mul(1000 - HOUSE_EDGE).div(10).div(calculateWinChance(number, isOver));
    }

    /**
    DRAW WINNER
    */

    function checkWin(
        uint256 number,
        bool isOver,
        uint256 luckyNumber
    ) private pure returns (bool) {
        return (isOver && number < luckyNumber) || (!isOver && number > luckyNumber);
    }

    function getLuckyNumber(uint256 betIndex, uint256 secret) private view returns (uint256) {
        Bet memory bet = bets[betIndex];

        if (bet.round >= block.number) return 0;
        if (secret == 0) {
            if (block.number - bet.round < 1000) return 0;
        } else {
            uint256 commitment = commitments[betIndex];
            if (uint256(keccak256(abi.encodePacked((secret)))) != commitment) {
                return 0;
            }
        }

        uint256 blockHash = uint256(blockhash(bet.round));
        if (blockHash == 0) {
            blockHash = uint256(blockhash(block.number - 1));
        }
        return 100 + ((secret ^ bet.seed ^ blockHash) % 100);
    }

    /**
    WRITE & PUBLIC FUNCTION
     */

    function _login(address ref) internal {
        if (referralContract != address(0x0)) {
            IReferral(referralContract).set(ref, msg.sender);
        }
    }

    function _newBet(uint256 betAmount, uint256 winAmount) internal {
        require(lockBalanceForGame.add(winAmount) < balanceForGame(betAmount), "Balance is not enough for game");
        lockBalanceForGame = lockBalanceForGame.add(winAmount);
        balanceOfBet = balanceOfBet.add(betAmount);
    }

    function _finishBet(uint256 betAmount, uint256 winAmount) internal {
        lockBalanceForGame = lockBalanceForGame.sub(winAmount);
        balanceOfBet = balanceOfBet.sub(betAmount);
    }

    function placeBet(
        uint256 number,
        bool isOver,
        uint256 seed,
        address ref
    ) public payable notStopped notContract {
        if (ref != address(0)) {
            _login(ref);
        }
        (uint256 minAmount, uint256 maxAmount) = betRange(number, isOver, msg.value);
        uint256 index = bets.length;
        require(commitments.length > index, "not enough commitments");
        require(minAmount > 0 && maxAmount > 0, "invalid minAmount or maxAmount");
        require(isOver ? number >= 4 && number <= 98 : number >= 1 && number <= 95, "bet number not in range");
        require(minAmount <= msg.value && msg.value <= maxAmount, "bet amount not in range");
        require(bets[getLastBetIndex(msg.sender)].isFinished, "last best not finished");

        uint256 winAmount = calculateWinAmount(number, isOver, msg.value);
        _newBet(msg.value, winAmount);

        totalBetOfGame += msg.value;

        betsOf[msg.sender].push(index);

        bets.push(
            Bet({
            index: index,
            number: number,
            isOver: isOver,
            amount: msg.value,
            player: msg.sender,
            round: block.number,
            isFinished: false,
            luckyNumber: 0,
            seed: seed
            })
        );
        emit NewBet(msg.sender, block.number, index, number, isOver, msg.value);
    }

    function refundBet(address payable add) external onlyOperator {
        uint256 betIndex = getLastBetIndex(add);
        Bet storage bet = bets[betIndex];

        require(!bet.isFinished, "bet is finished");
        require(bet.player == add, "add is not player");
        require(block.number - bet.round > 10000, "refund too early");

        uint256 winAmount = calculateWinAmount(bet.number, bet.isOver, bet.amount);

        add.transfer(bet.amount);
        _finishBet(bet.amount, winAmount);

        bet.isFinished = true;
        bet.amount = 0;
    }

    /**
    FOR OPERATOR
     */
    function settleBet(
        uint256 index,
        uint256 secret,
        uint256 newCommitment
    ) public onlyCroupier {
        require(index < bets.length, "index out of range");

        Bet storage bet = bets[index];

        require(bet.round < block.number, "round is in future");
        require(!bet.isFinished, "bet is finished");

        commit(newCommitment);

        uint256 luckyNum = getLuckyNumber(bet.index, secret);
        require(luckyNum > 0, "!luckyNum");

        luckyNum -= 100;

        uint256 winAmount = calculateWinAmount(bet.number, bet.isOver, bet.amount);

        bet.luckyNumber = luckyNum;
        bet.isFinished = true;
        uint256 buyBackAmount = bet.amount.mul(HOUSE_EDGE).div(2000); // 50% of edge

        if (referralContract != address(0x0)) {
            address ref = IReferral(referralContract).refOf(bet.player);
            if (ref != address(0x0)) {
                uint256 commission = bet.amount.mul(REWARD_FOR_REFERRAL).div(1000);
                IReferral(referralContract).reward{value: commission}(ref);
                buyBackAmount = buyBackAmount.sub(commission);
            }
        }

        buyBackReserveFromEdge = buyBackReserveFromEdge.add(buyBackAmount);
        if (liquidityAdder != address(0x0) && buyBackReserveFromEdge >= MINIMUM_TO_CALL_EARN) {
            callLiquidityAdderEarn();
        }

        if (checkWin(bet.number, bet.isOver, luckyNum)) {
            totalWinAmountOfGame += winAmount;
            bet.player.transfer(winAmount);
            amountOf[bet.player].totalBet += bet.amount;
            amountOf[bet.player].totalPayout += winAmount;
            emit TransferWinner(bet.player, bet.index, winAmount);
        } else {
            amountOf[bet.player].totalBet += bet.amount;
        }

        _finishBet(bet.amount, winAmount);
        emit DrawBet(bet.player, bet.round, bet.index, bet.number, bet.isOver, bet.amount, bet.isFinished, bet.luckyNumber);
    }

    function commit(uint256 _commitment) public onlyCroupier {
        require(0 != _commitment && 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563 != _commitment);
        commitments.push(_commitment);
    }

    function addCroupier(address add) external onlyOperator {
        croupiers[add] = true;
    }

    function removeCroupier(address add) external onlyOperator {
        croupiers[add] = false;
    }

    function setPrizeLevel(uint256 level) external onlyOperator {
        require(PRIZE_PER_BET_LEVEL <= 1000);
        PRIZE_PER_BET_LEVEL = level;
    }

    function setHouseEdge(uint256 value) external onlyOperator {
        require(value >= 5 && value <= 100); // [0.5%, 10%]
        HOUSE_EDGE = value;
    }

    function setMinBet(uint256 value) external onlyOperator {
        require(value >= 0.05 ether && value <= 10 ether);
        MINIMUM_BET_AMOUNT = value;
    }

    function setMinToEarn(uint256 value) external onlyOperator {
        require(value >= 0.05 ether && value <= 10 ether);
        MINIMUM_TO_CALL_EARN = value;
    }

    function setReferral(address payable _referral) external onlyOperator {
        referralContract = _referral;
    }

    function setLiquidityAdder(address payable _liquidityAdder) external onlyOperator {
        liquidityAdder = _liquidityAdder;
    }

    function setReferralReward(uint256 value) external onlyOperator {
        require(value >= 10 && value <= 50); // [0.1%, 0.5%]
        REWARD_FOR_REFERRAL = value;
    }

    function emergencyToken(IERC20 token, uint256 amount) external onlyOperator {
        token.safeTransfer(operator, amount);
    }

    function changeOperator(address add) external onlyOperator {
        newOperator = add;
    }

    function confirmChangeOperator() external {
        require(msg.sender == newOperator, "Invalid sender");
        operator = address(uint160(newOperator));
        newOperator = address(0x00);
    }

    function withdraw(uint256 amount) external onlyOperator {
        require(amount.add(lockBalanceForGame) <= address(this).balance, "over available balance");
        operator.transfer(amount);
    }

    /** FOR EMERGENCY */

    function forceStopGame(uint256 confirm) external onlyOperator {
        require(confirm == 0x1, "Enter confirm code");
        stopped = true;
    }

    function withdrawAllBalance() external onlyOperator isStopped {
        operator.transfer(address(this).balance);
    }

    function callLiquidityAdderEarn() public {
        if (buyBackReserveFromEdge > address(this).balance.div(2)) {
            buyBackReserveFromEdge = address(this).balance.div(2);
        }
        IBearnLiquidityAdder(liquidityAdder).earn{value: buyBackReserveFromEdge}();
        accBuyBackReserveFromEdge = accBuyBackReserveFromEdge.add(buyBackReserveFromEdge);
        buyBackReserveFromEdge = 0;
    }

    receive() external payable {}
}