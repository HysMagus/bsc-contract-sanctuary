// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IVoteProxy {
    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _voter) external view returns (uint256);
}

interface IPancakePool {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
}

interface IShareRewardPool {
    function userInfo(uint256 pid, address account) external view returns (uint256, uint256);
}

contract bDollarVote is IVoteProxy {
    using SafeMath for uint256;

    IShareRewardPool public shareRewardPool;
    IERC20[10] public stakePools;
    IERC20 sbdoToken;
    address public sbdo;
    uint256 public factorStake;
    uint256 public factorLP;
    uint256 public totalPancakePools;
    uint256 public totalStakePools;
    address public governance;

    struct PancakeLpPool {
        IPancakePool pool;
        uint256 pid;
    }

    PancakeLpPool[10] pancakePools;

    constructor(
        address _sbdo,
        address _shareRewardPool,
        address[] memory _stakePoolAddresses,
        uint256 _factorStake,
        uint256 _factorLP
    ) public {
        require(_stakePoolAddresses.length <= 10, "Max 10 stake pools!");
        _setStakePools(_stakePoolAddresses);
        factorLP = _factorLP;
        factorStake = _factorStake;
        sbdo = _sbdo;
        sbdoToken = IERC20(sbdo);
        shareRewardPool = IShareRewardPool(_shareRewardPool);
        governance = msg.sender;
    }

    function _setStakePools(address[] memory _stakePoolAddresses) internal {
        totalStakePools = _stakePoolAddresses.length;
        for (uint256 i = 0; i < totalStakePools; i++) {
            stakePools[i] = IERC20(_stakePoolAddresses[i]);
        }
    }

    function decimals() public pure virtual override returns (uint8) {
        return uint8(18);
    }

    function totalSupply() public view override returns (uint256) {
        uint256 totalSupplyPool = 0;
        uint256 i;
        for (i = 0; i < totalPancakePools; i++) {
            uint256 lpInPool = pancakePools[i].pool.balanceOf(address(shareRewardPool));
            totalSupplyPool = totalSupplyPool.add(lpInPool.mul(sbdoToken.balanceOf(address(pancakePools[i].pool))).div(pancakePools[i].pool.totalSupply()));
        }
        uint256 totalSupplyStake = 0;
        for (i = 0; i < totalStakePools; i++) {
            totalSupplyStake = totalSupplyStake.add(sbdoToken.balanceOf(address(stakePools[i])));
        }
        return factorLP.mul(totalSupplyPool).add(factorStake.mul(totalSupplyStake)).div(factorLP.add(factorStake));
    }

    function getSbdoAmountInPool(address _voter) public view returns (uint256) {
        uint256 stakeAmount = 0;
        for (uint256 i = 0; i < totalPancakePools; i++) {
            (uint256 _stakeAmountInPool, ) = shareRewardPool.userInfo(pancakePools[i].pid, _voter);
            stakeAmount = stakeAmount.add(_stakeAmountInPool.mul(sbdoToken.balanceOf(address(pancakePools[i].pool))).div(pancakePools[i].pool.totalSupply()));
        }
        return stakeAmount;
    }

    function getSbdoAmountInStakeContracts(address _voter) public view returns (uint256) {
        uint256 stakeAmount = 0;
        for (uint256 i = 0; i < totalStakePools; i++) {
            stakeAmount = stakeAmount.add(stakePools[i].balanceOf(_voter));
        }
        return stakeAmount;
    }

    function balanceOf(address _voter) public view override returns (uint256) {
        uint256 balanceInPool = getSbdoAmountInPool(_voter);
        uint256 balanceInStakeContract = getSbdoAmountInStakeContracts(_voter);
        return factorLP.mul(balanceInPool).add(factorStake.mul(balanceInStakeContract)).div(factorLP.add(factorStake));
    }

    function setFactorLP(uint256 _factorLP) external {
        require(msg.sender == governance, "!governance");
        require(factorStake > 0 && _factorLP > 0, "Total factors must > 0");
        factorLP = _factorLP;
    }

    function setFactorStake(uint256 _factorStake) external {
        require(msg.sender == governance, "!governance");
        require(factorLP > 0 && _factorStake > 0, "Total factors must > 0");
        factorStake = _factorStake;
    }

    function addPancakePools(address _pancakePoolAddress, uint256 pid) external {
        require(msg.sender == governance, "!governance");
        require(totalPancakePools < 10, "Max 10 pancake pools!");
        pancakePools[totalPancakePools].pool = IPancakePool(_pancakePoolAddress);
        pancakePools[totalPancakePools].pid = pid;
        totalPancakePools += 1;
    }

    function clearPancakePool() external {
        require(msg.sender == governance, "!governance");
        totalPancakePools = 0;
    }

    function setStakePools(address[] memory _stakePoolAddresses) external {
        require(msg.sender == governance, "!governance");
        _setStakePools(_stakePoolAddresses);
    }
}