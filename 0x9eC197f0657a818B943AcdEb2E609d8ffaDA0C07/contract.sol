// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.4;

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

    constructor () {
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

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

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

interface IFarmingPool {
    function info() external view returns(
        IERC20 _stakingToken,
        IERC20 _rewardsToken,
        uint256 _totalStaked,
        uint256 _totalFarmed,
        uint _createdAtSeconds,
        uint _holdingDelaySeconds,
        uint _rewardsAvailableAtSeconds,
        bool _stakesAllowed
    );
    function myInfo() external view returns(
        uint256 _myStake,
        uint256 _myShare,
        uint256 _myReward,
        uint256 _myHourlyIncome,
        uint256 _myDailyIncome
    );
    function getStakingToken() external view returns(IERC20);
    function getRewardsToken() external view returns(IERC20);
    function getTotalStaked() external view returns(uint256);
    function getTotalFarmed() external view returns(uint256);
    function getDailyRewardPool() external view returns (uint256);
    function getCreatedAt() external view returns(uint);
    function getHoldingDelay() external view returns(uint);
    function getRewardsAvailableAt() external view returns(uint);
    function getStakesAllowed() external view returns(bool);
    function getMyStake(address _address) external view returns(uint256);
    function getMyShare(address _address) external view returns(uint256);
    function getMyReward(address _address) external view returns(uint256);
    function getMyHourlyIncome(address _address) external view returns(uint256);
    function getMyDailyIncome(address _address) external view returns(uint256);

    function stake(uint256 amount) external returns (bool);
    function withdraw(uint256 amount) external returns (bool);
    function claimReward(uint256 amount) external returns (bool);

    function stop() external returns (bool);

    event Staked(address _staker, uint256 amount);
    event Withdrew(address _staker, uint256 amount);
    event Rewarded(address _rewardant, uint256 amount);
    event Stopped();
    event Updated(IERC20 stakingToken, IERC20 rewardsToken, uint256 totalStaked, uint256 totalFarmedd,
        uint createdAtSeconds, uint holdingDelaySeconds, uint rewardsAvailableAtSeconds, bool stakesAllowed);
}


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
    constructor () {
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

    function neg(uint256 a) internal pure returns (uint256) {
        uint256 c = 0 - a;

        return c;
    }
}

abstract contract AbstractFarmingPool is IFarmingPool, Ownable {
    using SafeMath for uint;

    uint internal SECONDS_IN_DAY = 86400;
    uint256 internal MAX_INT = uint256(- 1);

    uint256 DECIMALS = 1000 * 10**18;

    IERC20 internal stakingToken;
    IERC20 internal rewardsToken;
    uint256 internal totalStaked;
    uint256 internal dailyRewardPool;
    uint internal createdAtSeconds;
    uint internal holdingDelaySeconds;
    uint internal rewardsAvailableAtSeconds;

    bool internal stakesAllowed = true;
    uint internal rewardsInterval = 3600;

    mapping(address => uint256) stakes;
    mapping(uint => mapping(address => uint256)) internal rewards;

    uint internal firstStakeStart;
    mapping(address => uint) internal stakeHolders;
    address[] internal stakeHoldersStore;
    mapping(address => uint256) internal claimedRewards;

    mapping(uint => uint256) internal rewardsTotal;
    mapping(uint => uint256) public totalStakeDaily;
    uint[] internal stakeDays;

    // modifiers
    modifier onlyWhenAcceptingNewStakes() {
        require(
            stakesAllowed,
            "not accepting new stakes"
        );

        _;
    }

    modifier notHoldingPeriod() {
        require(
            block.timestamp >= rewardsAvailableAtSeconds,
            "Still in holding period"
        );

        _;
    }
    modifier amountAvailable(uint256 amount) {
        require(
            amount <= _myRewards(msg.sender),
            "Amount requested is greater than available"
        );

        _;
    }
    modifier stakeAvailable(uint256 amount) {
        require(
            amount <= stakes[msg.sender],
            "Amount requested is greater than staked"
        );

        _;
    }

    constructor() {
        stakeHoldersStore.push(address(0));
    }

    // internal functions
    function stake(address _stakeHolder, uint256 _amount) internal returns (bool) {
        require(
            _stakeHolder != address(0),
            "stake owner can't be 0"
        );
        require(
            _amount > 0,
            "amount must be greater than 0"
        );

        // Transfer the tokens to the smart contract and update the stake owners list accordingly.
        require(
            stakingToken.transferFrom(_stakeHolder, address(this), _amount),
            "insufficient allowance"
        );

        if (firstStakeStart == 0) {
            firstStakeStart = block.timestamp;
        }

        _addStakeHolder(_stakeHolder);
        _updateStaked(_stakeHolder, _amount);
        _updateRewards(_rewardPeriod());

        return true;
    }

    function reward(address _stakeHolder, uint256 _amount) internal returns (bool) {
        require(rewardsToken.transfer(_stakeHolder, _amount));
        claimedRewards[_stakeHolder] = claimedRewards[_stakeHolder].add(_amount);

        return true;
    }

    function _withdraw(address _stakeHolder, uint256 _amount) internal returns (bool) {
        require(stakingToken.transfer(_stakeHolder, _amount));

        _updateStaked(_stakeHolder, - _amount);
        _updateRewards(_rewardPeriod());

        return true;
    }

    function _updateStaked(address _stakeOwner, uint256 _amount) internal {
        uint _period = _rewardPeriod();

        _updatePeriodStaked(_period, _amount);

        stakes[_stakeOwner] = stakes[_stakeOwner] + _amount;
        totalStaked = totalStaked + _amount;
    }

    function _updatePeriodStaked(uint _period, uint256 _diff) internal returns (uint256) {
        uint256 dailyStaked = totalStakeDaily[_period];
        if (dailyStaked == 0) {
            dailyStaked = _periodStakedVolume(_period);
            stakeDays.push(_period);
        }
        if (dailyStaked == MAX_INT) {
            dailyStaked = 0;
        }

        uint256 _total = dailyStaked + _diff;
        if (_total == 0) {
            _total = MAX_INT;
        }
        return totalStakeDaily[_period] = _total;
    }

    function _periodStakedVolume(uint _period) internal view returns (uint256 _staked) {
        _staked = 0;
        uint _length = stakeDays.length;
        if (_length == 0) {return 0;}

        for (uint idx = _length - 1; idx >= 0; idx--) {
            uint _total;
            uint period = stakeDays[idx];
            if (period <= _period && (_total = totalStakeDaily[period]) > 0) {
                if (_total == MAX_INT) {
                    _total = 0;
                }
                return _total;
            }
        }
    }

    function _updateRewards(uint _period) internal {
        uint _stakeHolders_length = stakeHoldersStore.length;
        uint256 _hourlyIncome = dailyRewardPool.div(SECONDS_IN_DAY.div(rewardsInterval));
        uint256 _total = _hourlyIncome;
        uint rewardsCount = 0;

        for (uint idx = 1; idx < _stakeHolders_length; idx++) {
            rewardsCount++;
            address _stakeHolder = stakeHoldersStore[idx];

            uint256 _myStake = stakes[_stakeHolder];

            uint256 _myShare = totalStaked > 0 ? _myStake.mul(DECIMALS).div(totalStaked) : 0;
            uint256 _myHourlyIncome = _hourlyIncome.mul(_myShare).div(DECIMALS);

            if (_myHourlyIncome == 0) {
                _myHourlyIncome = MAX_INT;
                rewardsCount--;
            }

            rewards[_period][_stakeHolder] = _myHourlyIncome;
        }

        if (rewardsCount == 0) {
            _total = MAX_INT;
        }
        rewardsTotal[_period] = _total;
    }

    function _thisPeriod() internal view returns (uint) {
        return _thisPeriod(block.timestamp);
    }

    function _thisPeriod(uint _timeStamp) internal view returns (uint) {
        return _timeStamp.div(rewardsInterval).mul(rewardsInterval);
    }

    function _rewardPeriod() internal view returns (uint) {
        return _rewardPeriod(block.timestamp);
    }

    function _rewardPeriod(uint _timeStamp) internal view returns (uint) {
        return _timeStamp.div(rewardsInterval).add(1).mul(rewardsInterval);
    }

    function _myStats(address _address) internal view returns (
        uint256 _myStake,
        uint256 _myShare,
        uint256 _myReward,
        uint256 _myHourlyIncome,
        uint256 _myDailyIncome
    ) {
        _myStake = stakes[_address];
        _myShare = totalStaked > 0 ? _myStake.mul(DECIMALS).div(totalStaked) : 0;
        _myReward = _myRewards(_address);

        uint256 _hourlyIncome = dailyRewardPool.div(SECONDS_IN_DAY.div(rewardsInterval));

        _myHourlyIncome = _hourlyIncome.mul(_myShare).div(DECIMALS);
        _myDailyIncome = dailyRewardPool.mul(_myShare).div(DECIMALS);

        _myShare *= 1000000;
        _myShare /= DECIMALS;
    }

    function _myRewards(address _address) internal view returns (uint256) {
        uint256 _availableReward = 0;
        uint256 _reward;
        uint256 _lastPeriod = _thisPeriod();

        for (uint256 _period = _rewardPeriod(max(firstStakeStart, createdAtSeconds)); _period <= _lastPeriod; _period += rewardsInterval) {
            uint _periodReward = rewards[_period][_address];
            if (_periodReward > 0) {
                _reward = _periodReward;
            }
            if (_reward == MAX_INT) {
                _reward = 0;
            }

            _availableReward = _availableReward.add(_reward);
        }

        return _availableReward.sub(claimedRewards[_address]);
    }

    function _getTotalFarmed() internal view returns (uint256) {
        uint256 _total = 0;

        uint256 _rewards;
        uint256 _lastPeriod = _thisPeriod();

        for (uint256 _period = _rewardPeriod(max(firstStakeStart, createdAtSeconds)); _period <= _lastPeriod; _period += rewardsInterval) {
            if (rewardsTotal[_period] > 0) {
                _rewards = rewardsTotal[_period];
            }
            if (_rewards == MAX_INT) {
                _rewards = 0;
            }

            _total = _total.add(_rewards);
        }

        return _total;
    }

    function _addStakeHolder(address _stakeHolder) internal {
        if (!_isStakeHolder(_stakeHolder)) {
            // Append
            stakeHolders[_stakeHolder] = stakeHoldersStore.length;
            stakeHoldersStore.push(_stakeHolder);
        }
    }

    function _isStakeHolder(address _stakeHolder) internal view returns (bool) {
        // address 0x0 is not valid if pos is 0 is not in the array
        if (_stakeHolder != address(0) && stakeHolders[_stakeHolder] > 0) {
            return true;
        }
        return false;
    }

    function setDailyRewardPool(uint256 _rewardPool) external onlyOwner returns(bool) {
        dailyRewardPool = _rewardPool;

        _updateRewards(_rewardPeriod());

        return true;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

contract FarmingPool is AbstractFarmingPool, ReentrancyGuard {
    constructor (IERC20 _stakingToken, IERC20 _rewardsToken, uint _holdingDelaySeconds, uint256 _dailyRewardPool) {
        stakingToken = _stakingToken;
        rewardsToken = _rewardsToken;
        holdingDelaySeconds = _holdingDelaySeconds;
        dailyRewardPool = _dailyRewardPool;
        createdAtSeconds = block.timestamp;
        rewardsAvailableAtSeconds = createdAtSeconds + holdingDelaySeconds;
    }

    function myInfo() override external view returns (
        uint256 _myStake,
        uint256 _myShare,
        uint256 _myReward,
        uint256 _myHourlyIncome,
        uint256 _myDailyIncome
    ) {
        return _myStats(msg.sender);
    }

    function info() override external view returns (
        IERC20 _stakingToken,
        IERC20 _rewardsToken,
        uint256 _totalStaked,
        uint256 _totalFarmed,
        uint _createdAtSeconds,
        uint _holdingDelaySeconds,
        uint _rewardsAvailableAtSeconds,
        bool _stakesAllowed
    ) {
        _totalFarmed = _getTotalFarmed();
        return (stakingToken, rewardsToken, totalStaked, _totalFarmed, createdAtSeconds,
        holdingDelaySeconds, rewardsAvailableAtSeconds, stakesAllowed);
    }

    function getStakingToken() override external view returns (IERC20) {
        return stakingToken;
    }

    function getRewardsToken() override external view returns (IERC20) {
        return rewardsToken;
    }

    function getTotalStaked() override external view returns (uint256) {
        return totalStaked;
    }

    function getTotalFarmed() override external view returns (uint256) {
        return _getTotalFarmed();
    }

    function getDailyRewardPool() override external view returns (uint256) {
        return dailyRewardPool;
    }

    function getCreatedAt() override external view returns (uint) {
        return createdAtSeconds;
    }

    function getHoldingDelay() override external view returns (uint) {
        return holdingDelaySeconds;
    }

    function getRewardsAvailableAt() override external view returns (uint) {
        return rewardsAvailableAtSeconds;
    }

    function getStakesAllowed() override external view returns (bool) {
        return stakesAllowed;
    }

    function getMyStake(address _address) override external view returns (uint256) {
        (uint256 _myStake,,,,) = _myStats(_address);
        return _myStake;
    }

    function getMyShare(address _address) override external view returns (uint256) {
        (,uint256 _myShare,,,) = _myStats(_address);
        return _myShare;
    }

    function getMyReward(address _address) override external view returns (uint256) {
        (,,uint256 _myReward,,) = _myStats(_address);
        return _myReward;
    }

    function getMyHourlyIncome(address _address) override external view returns (uint256) {
        (,,,uint256 _myHourlyIncome,) = _myStats(_address);
        return _myHourlyIncome;
    }

    function getMyDailyIncome(address _address) override external view returns (uint256) {
        (,,,,uint256 _myDailyIncome) = _myStats(_address);
        return _myDailyIncome;
    }

    function stake(uint256 amount) override onlyWhenAcceptingNewStakes nonReentrant external returns (bool) {
        address stakeHolder = msg.sender;
        require(stake(stakeHolder, amount));

        emit Staked(stakeHolder, amount);
        return true;
    }

    function withdraw(uint256 amount) override external stakeAvailable(amount) returns (bool) {
        address stakeHolder = msg.sender;
        require(_withdraw(stakeHolder, amount));
        emit Withdrew(stakeHolder, amount);

        return true;
    }

    function claimReward(uint256 amount) override external notHoldingPeriod amountAvailable(amount) returns (bool) {
        address stakeHolder = msg.sender;
        require(reward(stakeHolder, amount));

        emit Rewarded(stakeHolder, amount);
        return true;
    }

    function stop() override external onlyOwner returns (bool) {
        stakesAllowed = false;
        return true;
    }
}