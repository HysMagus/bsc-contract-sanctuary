// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

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

interface PoolInterface {
    function deposit(uint256 _amount) external;
    function withdraw(uint256 _amount) external;
    function pendingReward(address _user) external view returns (uint256);
}

interface TokenSwap {
    function swapExactTokensForTokens(
        uint256 amountIn, 
        uint256 amountOutMin, 
        address[] calldata path, 
        address to, 
        uint256 deadline) external returns (uint[] memory);
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

contract PancakeStrategy is Ownable{
    using SafeMath for uint256;

    address internal vaultAddress;
    address internal controllerAddress;

    uint256 public balance = 0;

    IBEP20 internal stakeToken;
    IBEP20 internal rewardToken;

    address[] internal exchangePath;

    PoolInterface internal pool;
    TokenSwap internal exchange;

    /// @notice Links the Strategy, the Vault and the Controller together and initialises the pool
    /// @param _vaultAddress Address of the Vault contract
    /// @param _controllerAddress Address of the Controller contract
    /// @param _stakeTokenAddress Address of the staking token
    /// @param _poolAddress Address of the pool
    /// @param _rewardTokenAddress Address of the reward token
    /// @param _exchangeAddress contranct handling the token swap [0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F]
    /// @param _path path of exchange from reward to stake token
    constructor (
        address _vaultAddress, 
        address _controllerAddress,
        address _stakeTokenAddress, 
        address _poolAddress,
        address _rewardTokenAddress,
        address _exchangeAddress,
        address[] memory _path
        ) {
        stakeToken = IBEP20(_stakeTokenAddress);
        rewardToken = IBEP20(_rewardTokenAddress);
        vaultAddress = _vaultAddress;
        controllerAddress = _controllerAddress;
        pool = PoolInterface(_poolAddress);
        exchangePath = _path;
        exchange = TokenSwap(_exchangeAddress);
        stakeToken.approve(_poolAddress, uint256(-1));
        rewardToken.approve(_exchangeAddress, uint256(-1));
    }

    /// @notice Can only be called by the Controller
    modifier onlyController(){
        require(msg.sender == controllerAddress, "Not Controller");
        _;
    }

    /// @notice In case of an error in the exchange contract
    function setExchange(address _newExchangeAddress) external onlyOwner {
       exchange = TokenSwap(_newExchangeAddress);
    }

    /// @notice In case some tokens stuck in the contract
    function saveTokens(address _tokenAddress) external onlyOwner {
         IBEP20(_tokenAddress).transfer(msg.sender, IBEP20(_tokenAddress).balanceOf(address(this)));
    }

    /// @notice Takes the staking tokens approved beforehand, adds the amount to the balance then sends it to the pool
    /// calculateProfitGrowth() can work like this because deposit also transfers the pending reward
    /// @param _amount The amount of tokens to be transferred
    function deposit(uint256 _amount) external onlyController {
        stakeToken.transferFrom(msg.sender, address(this), _amount);
        pool.deposit(_amount);
        balance = balance.add(_amount);
    }

    /// @notice Withdraws a certain amount of staking tokens and sends them to the Controller and the reward is stored for now.
    /// The withdrawn amount is subtracted from the balance
    /// @param _amount The amount of staking tokens to be withdrawn
    function withdraw(uint256 _amount) external onlyController {
        require(balance >= _amount, "There is not enough balance");
        pool.withdraw(_amount);
        stakeToken.transfer(controllerAddress, _amount);
        balance = balance.sub(_amount);
    }
    
    /// @notice Withdraws all of the staking tokens.
    /// The reward is swapped to staking token and all of the staking token is sent to the Controller
    /// balance is set to zero
    function withdrawAll() external onlyController returns (uint256, uint256) {
        pool.withdraw(balance);
        uint256 _reward = rewardToken.balanceOf(address(this));
        exchange.swapExactTokensForTokens(_reward, uint256(0), exchangePath, address(this), block.timestamp.add(1800));
        uint256 _fullAmount = stakeToken.balanceOf(address(this));
        uint256 _amount = _fullAmount;
        _reward = _fullAmount.sub(balance);
        uint256 _fee = 0;

        if(_reward >= 10000){
            _fee = calculateFee(_reward);
            _reward = _reward.sub(_fee);
            _amount = _amount.sub(_fee);
        }
        stakeToken.transfer(controllerAddress, _fullAmount);
        balance = 0;
        return (_amount, _fee);
    }

    /// @notice There is no built in harvest function but the withdraw transfers the profit.
    /// The profit is reinvested in the pool
    function harvest() external onlyController returns (uint256) {
        pool.withdraw(0);
        uint256 _reward = rewardToken.balanceOf(address(this));
        exchange.swapExactTokensForTokens(_reward, uint256(0), exchangePath, address(this), block.timestamp.add(1800));
        _reward = stakeToken.balanceOf(address(this));
        uint256 _fee = 0;

        if(_reward >= 10000){
            _fee = calculateFee(_reward);
            _reward = _reward.sub(_fee);
            stakeToken.transfer(controllerAddress, _fee);
        }

        pool.deposit(_reward);
        balance = balance.add(_reward);

        return _fee;
    }

    /// @return The amount of staking tokens handled by the Strategy
    function getBalance() external view returns (uint256) {
        return balance;
    }

    /// @notice If the reward is less than 10000 the rounding error becomes considerable
    /// @return One percent of the submited amount.
    function calculateFee (uint256 _reward) internal pure returns(uint256){
        _reward = _reward.mul(100).div(10000);
        return _reward;
    }
}