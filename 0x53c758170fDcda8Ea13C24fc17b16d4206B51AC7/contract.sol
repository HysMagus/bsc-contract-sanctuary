// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.4;


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

interface IStaking {
    function stake(uint256 _amount) external;
    function unStake() external;
    function claimReward(uint256 _amount) external returns (bool);
    function stats(address _address) external view returns (
        uint256 totalStaked,
        uint256 totalRewards,
        uint256 myShare,
        uint256 myStake,
        uint256 myStakeExpiration,
        uint256 myRewardsTotal,
        uint256 myRewardsAvailable,
        uint256 my24hRewards
    );

    event Staked(address _staker, uint amount, uint startTime, uint endTime);
    event UnStaked(address _staker, uint amount);
    event Rewarded(address _rewardant, uint amount);
}

abstract contract AbstractStakingContract is IStaking {
    using SafeMath for uint;

    // states
    bool public stakingAllowed = true;
    bool public rewardsAllowed = true;
    uint public lockPeriod;
    uint public vestingPeriod;

    uint SECONDS_IN_DAY = 86400;

    // total stakes as per last calculation
    uint256 public totalStakedAmount;
    // total rewards as per last calculation
    uint256 public totalRewardsAmount;
    // total claimed rewards
    uint256 public totalClaimedRewards;

    uint internal calculatedDate;
    uint256 internal nextPeriodStake;

    struct Reward {
        uint256 amount;
        uint date;
    }

    // for addresses
    mapping(address => uint256) internal stakes;
    mapping(address => uint) internal whenStaked;
    mapping(address => Reward[]) internal rewards;
    mapping(address => uint256) internal pendingRewards;
    mapping(address => uint256) internal claimedRewards;

    address[] public stakeholders;

    // rewards
    uint256 public totalRewardsAvailable;
    uint256 public dailyRewards;
    uint public rewardsPeriod = 86400; // in seconds (86400 == 1 day)

    // Tokens
    IERC20 public stakingToken; // The address of the Staking Token Contract
    IERC20 public rewardsToken; // The address of the Rewards Token Contract

    // modifiers
    modifier acceptingNewStakes() {
        require(
            stakingAllowed,
            "not accepting new stakes"
        );

        _;
    }
    modifier stakeholder() {
        (bool ok,) = isStakeholder(msg.sender);
        require(
            ok,
            "unstake - not a stakeholder"
        );

        _;
    }
    modifier canUnstake() {
        require(
            lockedUntil(msg.sender) <= block.timestamp,
            "unstake - unable to unstake. you should wait until stake period is over"
        );

        _;
    }
    modifier canReward(uint256 _amount) {
        (uint256 available,) = calculateReward(msg.sender);
        require(
            available >= _amount,
            "not available rewards amount"
        );

        _;
    }

    // internal functions
    function stake(address _stakeholder, uint256 _amount) internal returns (uint256 _newAmount, uint _startTime, uint _endTime) {
        require(
            _stakeholder != address(0),
            "stake owner can't be 0"
        );
        require(
            _amount > 0,
            "amount must be greater than 0"
        );
        require(
            stakingToken.transferFrom(_stakeholder, address(this), _amount),
            "insufficient allowance"
        );

        totalStakedAmount += _amount;
        stakes[_stakeholder] += _amount;
        if (whenStaked[_stakeholder] == 0) {
            addStakeholder(_stakeholder);
            whenStaked[_stakeholder] = block.timestamp;
        }

        _startTime = whenStaked[_stakeholder];
        _endTime = lockedUntil(_stakeholder);
        _newAmount = stakes[_stakeholder];

        _calculate();
    }

    function unStake(address _stakeholder) internal returns (uint256 _amount) {
        _amount = stakes[_stakeholder];

        require(
            stakingToken.transfer(_stakeholder, _amount),
            "cannot transfer staking token!"
        );

        totalStakedAmount -= _amount;
        stakes[_stakeholder] = 0;
        whenStaked[_stakeholder] = 0;
        removeStakeholder(msg.sender);

        _calculate();
    }

    function claimReward(address _stakeholder, uint256 _amount) internal returns (uint256) {
        require(
            rewardsToken.transfer(_stakeholder, _amount),
            "cannot transfer rewards!"
        );

        claimedRewards[_stakeholder] = claimedRewards[_stakeholder].add(_amount);

        totalClaimedRewards = totalClaimedRewards.add(_amount);

        return _amount;
    }

    // helper functions
    function lockedUntil(address _stakeholder) internal view returns (uint) {
        return whenStaked[_stakeholder] > 0 ? whenStaked[_stakeholder] + lockPeriod : 0;
    }

    function isStakeholder(address _address) internal view returns (bool, uint256) {
        for (uint256 s = 0; s < stakeholders.length; s += 1) {
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    function addStakeholder(address _stakeholder) internal {
        (bool _isStakeholder,) = isStakeholder(_stakeholder);
        if (!_isStakeholder) stakeholders.push(_stakeholder);
    }

    function removeStakeholder(address _stakeholder) internal {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if (_isStakeholder) {
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    function stakeOf(address _stakeholder) internal view returns (uint256) {
        return stakes[_stakeholder];
    }

    function nextPeriod(uint _timestamp) internal view returns (uint) {
        return _timestamp.div(rewardsPeriod).add(1).mul(rewardsPeriod);
    }

    function nextPeriod() internal view returns (uint) {
        return nextPeriod(block.timestamp);
    }

    // calculations...
    function calculateReward(address _stakeholder) internal view returns (uint256 _total, uint256 _available) {
        _total = 0;
        _available = 0;

        Reward[] memory _rewards = rewards[_stakeholder];
        uint256 _rewards_length = _rewards.length;

        for (uint256 r = 0; r < _rewards_length; r += 1) {
            Reward memory _reward = _rewards[r];
            _total = _total.add(_reward.amount);
            if (_reward.date.add(vestingPeriod) <= block.timestamp) {
                _available = _available.add(_reward.amount);
            }
        }

        // calculate period if wasn't calculated
        uint _nextPeriod = nextPeriod();
        uint fromDate = calculatedDate > nextPeriod(whenStaked[_stakeholder]) ? calculatedDate : nextPeriod(whenStaked[_stakeholder]);
        if (totalStakedAmount > 0 && _nextPeriod - fromDate >= rewardsPeriod) {
            uint periodsPassed = _nextPeriod / rewardsPeriod - fromDate / rewardsPeriod;
            uint maxPeriods = (totalRewardsAvailable - totalRewardsAmount) / rewardForPeriod();

            if (periodsPassed > maxPeriods) {
                periodsPassed = maxPeriods;
            }

            uint256 reward = pendingRewards[_stakeholder];

            for (uint256 p = 1; p <= periodsPassed; p += 1) {
                _total = _total.add(reward);
                uint availableDate = _nextPeriod - p * rewardsPeriod + vestingPeriod;
                if (availableDate <= block.timestamp) {
                    _available = _available.add(reward);
                }
            }
        }

        if (claimedRewards[_stakeholder] > 0) {
            _available = _available.sub(claimedRewards[_stakeholder]);
        }
    }

    function _calculate() internal {
        if (!rewardsAllowed || totalStakedAmount == 0) {
            return;
        }

        uint _nextPeriod = nextPeriod();

        if (calculatedDate == 0) {
            calculatedDate = _nextPeriod;
        }

        if (calculatedDate < _nextPeriod) {// distribute rewards
            uint256 _rewardForPeriod = rewardForPeriod();
            uint _stakeholders_length = stakeholders.length;
            uint periodsPassed = _nextPeriod / rewardsPeriod - calculatedDate / rewardsPeriod;

            uint periodsToReward = 0;

            calculatedDate = _nextPeriod;

            for (uint256 p = 1; p <= periodsPassed; p += 1) {
                if (totalRewardsAmount.add(_rewardForPeriod.mul(p)) <= totalRewardsAvailable) {
                    periodsToReward++;
                }
            }

            for (uint256 s = 0; s < _stakeholders_length; s += 1) {
                address _stakeholder = stakeholders[s];
                uint256 reward = pendingRewards[_stakeholder];

                for (uint256 p = 1; p <= periodsToReward; p += 1) {
                    uint rewardDate = _nextPeriod - p * rewardsPeriod;
                    rewards[_stakeholder].push(Reward(reward, rewardDate));
                }

                totalRewardsAmount = totalRewardsAmount.add(reward.mul(periodsToReward));
            }
        }

        _calculatePendingRewards();
    }

    function _calculatePendingRewards() internal {
        uint256 _divider = 100000;
        uint256 _rewardForPeriod = rewardForPeriod();
        uint _stakeholders_length = stakeholders.length;
        rewardsAllowed = totalRewardsAmount.add(_rewardForPeriod) <= totalRewardsAvailable;

        for (uint256 s = 0; s < _stakeholders_length; s += 1) {
            address _stakeholder = stakeholders[s];

            uint256 reward = 0;

            if (rewardsAllowed) {
                uint256 _share = stakes[_stakeholder].mul(_divider).div(totalStakedAmount);
                reward = _rewardForPeriod.mul(_share).div(_divider);
            }

            pendingRewards[_stakeholder] = reward;
        }
    }

    function getTotalStaked() internal view returns (uint256 _total) {
        return totalStakedAmount;
    }

    function getTotalRewards() internal view returns (uint256 _total) {
        _total = totalRewardsAmount;

        uint _nextPeriod = nextPeriod();

        if (calculatedDate > 0 && _nextPeriod.sub(calculatedDate) > rewardsPeriod) {
            uint periodsPassed = _nextPeriod.div(rewardsPeriod).sub(calculatedDate.div(rewardsPeriod)).sub(1);
            _total = _total.add(rewardForPeriod().mul(periodsPassed));
        }
    }

    function rewardForPeriod() internal view returns (uint256) {
        return dailyRewards * rewardsPeriod / SECONDS_IN_DAY;
    }
}

abstract contract OwnersStakingContract is AbstractStakingContract {
    address payable internal owner;

    event SystemUpdated(string key, uint256 value);

    constructor() {
        owner = msg.sender;
    }

    function setDailyRewardsPool(uint256 _rewardPool) external
    {
        dailyRewards = _rewardPool;
        _calculate();

        emit SystemUpdated("dailyRewards", _rewardPool);
    }

    function setRewardsPool(uint256 _totalRewardsAvailable) external
    {
        totalRewardsAvailable = _totalRewardsAvailable;
        _calculate();

        emit SystemUpdated("totalRewardsAvailable", _totalRewardsAvailable);
    }

    function setRewardVestingPeriodInSecs(uint _vestingPeriod) external ownerOnly {
        vestingPeriod = _vestingPeriod;
        _calculate();

        emit SystemUpdated("vestingPeriod", vestingPeriod);
    }

    function setStakingPeriodInSec(uint _lockPeriod) external ownerOnly {
        lockPeriod = _lockPeriod;
        _calculate();

        emit SystemUpdated("lockPeriod", _lockPeriod);
    }

    function setRewardsInterval(uint _rewardsInterval) external ownerOnly {
        rewardsPeriod = _rewardsInterval;
        _calculate();

        emit SystemUpdated("rewardsPeriod", _rewardsInterval);
    }

    function setStakingAllowed(bool _stakingAllowed) external ownerOnly {
        stakingAllowed = _stakingAllowed;
        _calculate();

        emit SystemUpdated("stakingAllowed", _stakingAllowed ? 1 : 0);
    }

    function setRewardsAllowed(bool _rewardsAllowed) external ownerOnly {
        rewardsAllowed = _rewardsAllowed;
        _calculate();

        emit SystemUpdated("rewardsAllowed", _rewardsAllowed ? 1 : 0);
    }

    function unlockStakesAndRewards() external ownerOnly {
        lockPeriod = 0;
        vestingPeriod = 0;
        _calculate();
    }

    function finalize() public ownerOnly {
        require(
            totalStakedAmount <= stakingToken.balanceOf(address(this)),
            "Not enough stacking tokens to distribute"
        );

        uint _stakeholders_length = stakeholders.length;
        for (uint s = 0; s < _stakeholders_length; s += 1) {
            address _stakeholder = stakeholders[s];
            stakingToken.transfer(_stakeholder, stakes[_stakeholder]);
        }

        uint256 stakingTokenBalance = stakingToken.balanceOf(address(this));
        if (stakingTokenBalance > 0) {
            stakingToken.transfer(owner, stakingTokenBalance);
        }

        uint256 rewardsTokenBalance = rewardsToken.balanceOf(address(this));
        if (rewardsTokenBalance > 0) {
            rewardsToken.transfer(owner, rewardsTokenBalance);
        }

        selfdestruct(owner);
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Oops. Not an owner");

        _;
    }
}

contract StakingContract is OwnersStakingContract, ReentrancyGuard {
    using SafeMath for uint;

    constructor(
        uint256 _stakingPeriodInSec,
        uint _rewardVestingPeriodInSecs,
        IERC20 _stakingToken,
        IERC20 _rewardsToken,
        uint256 _rewardsDailyPool,
        uint256 _totalRewardsLimit
    ) {
        require(
            _stakingPeriodInSec > 0,
            "staking period must be greater than 0"
        );
        require(
            address(_stakingToken) != address(0),
            "Staking token must not be 0"
        );
        require(
            address(_rewardsToken) != address(0),
            "Rewards token must not be 0"
        );
        require(
            _rewardsDailyPool > 0,
            "Rewards pool must not be 0"
        );

        lockPeriod = _stakingPeriodInSec;
        vestingPeriod = _rewardVestingPeriodInSecs;
        stakingToken = _stakingToken;
        rewardsToken = _rewardsToken;
        totalRewardsAvailable = _totalRewardsLimit;
        dailyRewards = _rewardsDailyPool;
    }

    function stake(uint256 amount)
    external
    override
    acceptingNewStakes
    nonReentrant
    {
        address stakeholder = msg.sender;
        (uint256 _amount, uint _startTime, uint _endTime) = stake(stakeholder, amount);

        emit Staked(stakeholder, _amount, _startTime, _endTime);
    }

    function unStake()
    external
    canUnstake
    stakeholder
    override
    nonReentrant
    {
        address stakeholder = msg.sender;
        uint256 _amount = unStake(stakeholder);

        emit UnStaked(stakeholder, _amount);
    }

    function claimReward(uint256 amount)
    external
    override
    canReward(amount)
    returns (bool success)
    {
        address stakeholder = msg.sender;
        uint256 _amount = claimReward(stakeholder, amount);

        emit Rewarded(stakeholder, _amount);
        return true;
    }

    function stats(address _address)
    external
    view
    override
    returns (
        uint256 totalStaked,
        uint256 totalRewards,
        uint256 myShare,
        uint256 myStake,
        uint256 myStakeExpiration,
        uint256 myRewardsTotal,
        uint256 myRewardsAvailable,
        uint256 my24hRewards
    )
    {
        myShare = 0;
        my24hRewards = 0;
        myStake = 0;
        myStakeExpiration = 0;
        myRewardsTotal = 0;
        myRewardsAvailable = 0;
        totalStaked = getTotalStaked();
        totalRewards = getTotalRewards();

        if (_address == address(0)) {
            return (totalStaked, totalRewards, myShare, myStake, myStakeExpiration, myRewardsTotal, myRewardsAvailable, my24hRewards);
        }

        myStake = stakes[_address];
        if (totalStaked > 0) {
            myShare = myStake.mul(100).div(totalStaked);
            my24hRewards = dailyRewards.mul(myShare).div(100);
        }

        myStakeExpiration = lockedUntil(_address);

        (myRewardsTotal, myRewardsAvailable) = calculateReward(_address);
    }
}