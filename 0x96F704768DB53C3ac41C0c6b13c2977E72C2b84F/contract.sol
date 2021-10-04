// File: contracts/libs/IBEP20.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

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
    function allowance(address _owner, address spender) external view returns (uint256);

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

// File: @openzeppelin/contracts/math/SafeMath.sol

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

// File: @openzeppelin/contracts/utils/Address.sol


pragma solidity >=0.6.2 <0.8.0;

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
        // This method relies on extcodesize, which returns 0 for contracts in
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
        return functionCallWithValue(target, data, 0, errorMessage);
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
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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

// File: contracts/libs/SafeBEP20.sol


pragma solidity 0.6.12;




/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol


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

// File: @openzeppelin/contracts/access/Ownable.sol


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

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol


pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/games/TheLastJedi.sol

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;







/**
 * Introduction: TheLastJedi game, where whoever deposits last will win all the rewards
 *          a game will be created with an initial reward, getting from treasury fund of YODA
 * How to play: Once game starts, user can deposit an amount of YODA which >= a specify min amount
 *          whenever someone deposited, the end time will be extended by 20 to 120 seconds
 *          the amount of additional time is generately randomly, however
 *          the higher deposit amount could result in a lower additional time
 *          and help the user to win the game
 * Reward: Once the game ends, the winner will be able to collect his deposited amount,
 *          as well as part of the reward. Some small reward will be burnt.
 *          For example, if instantPercentage is 20% and burnPercentage is 5%
 *          user deposited 100 YODA, total pool is 1000 YODA.
 *          user will be able to claim: 100 + (1000 - 100) * 20% = 280 YODA
 *          YODA to be burnt: (1000 - 100) * 5% = 45 YODA
 *          Locked YODA to be claimed during 4 weeks period: 1000 - 280 - 45 = 675
 *          locked reward will be distributed linearly in 4 weeks, and user can claim any time
 */
contract TheLastJedi is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    uint256 public constant LOWER_BOUND_ADDITIONAL_TIME = 15 seconds;
    uint256 public constant MIN_ADDITIONAL_TIME = 20 seconds;
    uint256 public constant UPER_BOUND_ADDITIONAL_TIME = 120 seconds;
    uint256 public constant DISTRIBUTE_PERIOD = 4 weeks;
    uint256 public constant HUNDRED_PERCENTAGE = 10000;
    address public constant BURN_ADDRESS = address(0x000000000000000000000000000000000000dEaD);
    uint256 public instantPercentage;
    uint256 public burnPercentage;

    IBEP20 public immutable rewardToken;

    uint256 internal seedNumber;

    struct GameRound {
        uint32 id;
        uint64 startTime;
        uint64 finalTime;
        bool isClaimed;

        uint256 totalReward;
        uint256 minAmount;
        address winner;

        uint128 uniquePlayers;
        uint128 numberDeposits;
    }

    struct History {
        address user;
        uint128 amount;
        uint64 additionalTime;
        uint64 timestamp;
    }

    struct LockedReward {
        address user;
        uint256 lastClaimTime;
        uint256 claimedAmount;
        uint256 leftAmount;
        uint256 endTime;
    }

    uint256 public numberRounds;
    mapping (uint256 => GameRound) internal _gameRoundInfo;
    mapping (uint256 => mapping (uint256 => History)) internal _gameHistory;
    mapping (uint256 => mapping (address => uint256)) internal _userDepositedToken;
    mapping (uint256 => LockedReward) internal _lockedRewards;

    event GameRoundCreated(
        uint32 gameId,
        uint64 startTime,
        uint64 endTime,
        uint256 initReward,
        uint256 minAmount,
        uint256 seed
    );
    event UserPlayed(
        uint32 gameId,
        address user,
        uint256 amount,
        uint256 additionalTime
    );
    event ClaimedReward(
        uint32 gameId,
        address user,
        uint256 claimableAmount,
        uint256 timestamp
    );
    event ClaimedLockedReward(
        uint32 gameId,
        address user,
        uint256 amount,
        uint256 timestamp
    );

    constructor(address _rewardToken) public Ownable() {
        rewardToken = IBEP20(_rewardToken);
        instantPercentage = 2000; // 20%
        burnPercentage = 500; // 5%
    }

    receive() external payable {}

    function updatePercentages(
        uint256 _instantPercentage,
        uint256 _burnPercentage
    ) external onlyOwner {
        require(
            _instantPercentage.add(_burnPercentage) <= HUNDRED_PERCENTAGE,
            "high percentage"
        );
        instantPercentage = _instantPercentage;
        burnPercentage = _burnPercentage;
    }

    /**
    * @dev create new game round with configuration
    * @param initReward initialise reward for the new round
    * @param minAmount min amount to deposit for each play
    * @param startTime start time of the new round
    * @param duration init duration of the new round
    * @param seed random number, use to generate random number per play
        this number will be changed every time someone deposited
    */
    function createGameRound(
        uint256 initReward,
        uint256 minAmount,
        uint256 startTime,
        uint256 duration,
        uint256 seed
    ) external payable onlyOwner returns (uint256 roundId) {
        require(seed < 200, "seed too high");
        numberRounds++;
        roundId = numberRounds;

        require(startTime > block.timestamp, "can not start in the past");
        uint256 endTime = startTime.add(duration);
        GameRound memory round = GameRound({
            id: uint32(roundId),
            startTime: uint64(startTime),
            finalTime: uint64(endTime),
            isClaimed: false,
            totalReward: initReward,
            minAmount: minAmount,
            winner: msg.sender,
            uniquePlayers: 0,
            numberDeposits: 0
        });
        _gameRoundInfo[roundId] = round;
        seedNumber = seed;

        _userDepositedToken[roundId][msg.sender] = initReward;

        _checkAndCollectToken(initReward);

        emit GameRoundCreated(
            uint32(roundId),
            uint64(startTime),
            uint64(endTime),
            initReward,
            minAmount,
            seed
        );
    }

    /**
    * @dev play a game by depositing amount of Yoda to the contract
    * @param gameId if of the game that user will play
    * @param amount amount of YODA to deposit, higher deposit amount can
    *       result in a lower additional time, which will help user to
    *       win the game easier.
    */
    function play(uint256 gameId, uint256 amount) external payable nonReentrant {
        require(gameId <= numberRounds, "invalid round id");
        GameRound storage game = _gameRoundInfo[gameId];
        require(game.startTime <= block.timestamp, "not started yet");
        require(game.finalTime >= block.timestamp, "game finalized");
        require(amount >= game.minAmount, "amount too low");

        // collect token
        _checkAndCollectToken(amount);

        game.totalReward += amount;
        game.numberDeposits += 1;

        bool isFirstDeposit = _userDepositedToken[gameId][msg.sender] == 0;
        if (isFirstDeposit) {
            // assume creator is not playing
            game.uniquePlayers += 1;
        }
        _userDepositedToken[gameId][msg.sender] = _userDepositedToken[gameId][msg.sender].add(amount);

        uint256 maxNumber = amount * 100 / game.totalReward;
        if (maxNumber > UPER_BOUND_ADDITIONAL_TIME) {
            maxNumber = MIN_ADDITIONAL_TIME;
        } else {
            maxNumber = MIN_ADDITIONAL_TIME + (UPER_BOUND_ADDITIONAL_TIME - maxNumber);
        }
        assert(maxNumber > LOWER_BOUND_ADDITIONAL_TIME);
        uint256 additionalTime = _getAdditionalTime(maxNumber - LOWER_BOUND_ADDITIONAL_TIME);
        additionalTime += LOWER_BOUND_ADDITIONAL_TIME;

        History memory history = History({
            user: msg.sender,
            amount: uint128(amount),
            additionalTime: uint64(additionalTime),
            timestamp: uint64(block.timestamp)
        });
        _gameHistory[gameId][game.numberDeposits] = history;

        seedNumber = additionalTime;
        game.finalTime += uint64(additionalTime);
        game.winner = msg.sender;

        emit UserPlayed(uint32(gameId), msg.sender, amount, additionalTime);
    }

    /**
    * @dev claim reward, only call by the winner
    *   user will receive his deposited amount + instantPercentage of the remaining reward
    *   burnPercentage of reward will be burnt
    *   the other will go to that is claimable linearly in 4 weeks
    */
    function claimReward(uint256 gameId)
        external nonReentrant
        returns (uint256 claimableAmount)
    {
        require(gameId <= numberRounds, "invalid round id");
        GameRound storage game = _gameRoundInfo[gameId];
        require(game.finalTime < block.timestamp, "game not ended");
        require(game.winner == msg.sender, "not winner");
        require(!game.isClaimed, "already claimed");

        game.isClaimed = true;

        uint256 depositedAmount = _userDepositedToken[gameId][msg.sender];
        uint256 rewardAmount = game.totalReward - depositedAmount;

        claimableAmount = (rewardAmount * instantPercentage / HUNDRED_PERCENTAGE) + depositedAmount;
        uint256 burnAmount = rewardAmount * burnPercentage / HUNDRED_PERCENTAGE;
        uint256 leftAmount = game.totalReward.sub(claimableAmount).sub(burnAmount);

        LockedReward memory lockedReward = LockedReward({
            user: msg.sender,
            lastClaimTime: block.timestamp,
            claimedAmount: claimableAmount,
            leftAmount: leftAmount,
            endTime: block.timestamp + DISTRIBUTE_PERIOD
        });
        _lockedRewards[gameId] = lockedReward;

        if (burnAmount > 0) {
            _safeTransfer(rewardToken, BURN_ADDRESS, burnAmount);
        }
        _safeTransfer(rewardToken, msg.sender, claimableAmount);
        emit ClaimedReward(uint32(gameId), msg.sender, claimableAmount, block.timestamp);
    }

    /**
    * @dev claim locked reward, only call by the winner
    *   lock reward is distributed linearly in 4 weeks
    */
    function claimLockReward(uint256 gameId)
        external nonReentrant
        returns (uint256 amount)
    {
        require(gameId <= numberRounds, "invalid round id");
        LockedReward storage lockReward = _lockedRewards[gameId];
        require(lockReward.user == msg.sender, "only winner");
        if (lockReward.endTime <= block.timestamp) {
            amount = lockReward.leftAmount;
        } else {
            amount = lockReward.leftAmount
                .mul(block.timestamp.sub(lockReward.lastClaimTime))
                .div(lockReward.endTime.sub(lockReward.lastClaimTime));
        }
        if (amount == 0) return amount;
        lockReward.lastClaimTime = block.timestamp;
        lockReward.leftAmount = lockReward.leftAmount.sub(amount);
        lockReward.claimedAmount = lockReward.claimedAmount.add(amount);

        _safeTransfer(rewardToken, msg.sender, amount);
        emit ClaimedLockedReward(uint32(gameId), msg.sender, amount, block.timestamp);
    }

    function emergencyWithdraw(IBEP20 token, uint256 amount) external onlyOwner {
        require(token != rewardToken, "can not withdraw reward token");
        _safeTransfer(token, owner(), amount);
    }

    function roundInfo(uint256 roundId)
        external view
        returns (GameRound memory)
    {
        return _gameRoundInfo[roundId];
    }

    function playHistory(uint256 roundId, uint256 index)
        external view
        returns (History memory)
    {
        return _gameHistory[roundId][index];
    }

    function lockedReward(uint256 gameId)
        external view
        returns (LockedReward memory)
    {
        return _lockedRewards[gameId];
    }

    function _getAdditionalTime(uint256 maxNumber)
        internal view
        returns(uint256 randomNumber)
    {
        bytes32 _structHash;

        // waste some gas fee here
        for (uint i = 0; i < seedNumber; i++) {
            GameRound memory game = _gameRoundInfo[0];
            game; // silent the warning
        }

        uint256 _gasleft = gasleft();
        bytes32 _blockHash = blockhash(block.number - 1);

        _structHash = keccak256(
            abi.encode(
                _blockHash,
                _gasleft,
                seedNumber
            )
        );
        randomNumber  = uint256(_structHash);
        assembly { randomNumber := mod(randomNumber, maxNumber) }
    }

    function _checkAndCollectToken(uint256 amount) internal {
        if (rewardToken == IBEP20(0)) {
            // bnb
            require(msg.value == amount, "wrong amount and msg value");
        } else {
            require(msg.value == 0, "msg value should be 0");
            rewardToken.safeTransferFrom(msg.sender, address(this), amount);
        }
    }

    function _safeTransfer(IBEP20 token, address to, uint256 amount) internal {
        if (token == IBEP20(0)) {
            (bool success, ) = to.call { value: amount }("");
            require(success, "transfer bnb failed");
        } else {
            token.safeTransfer(to, amount);
        }
    }
}