// SPDX-License-Identifier: UNLICENSED

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
library XSafeMath {
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

    function ceil(uint256 a, uint256 m) internal pure returns (uint256)
    {
        uint256 c = add(a,m);
        uint256 d = sub(c,1);
        return mul(div(d,m),m);
    }

    function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
        require(y != 0, "Div by zero");
        uint256 r = x / y;
        if (x % y != 0) {
            r = r + 1;
        }

        return r;
    }
}

pragma solidity ^0.6.0;

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



pragma solidity ^0.6.0;

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
contract Ownable is Context {
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



pragma solidity ^0.6.0;

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


pragma solidity 0.6.12;


contract Rebasable is Ownable {
  address private _rebaser;

  event TransferredRebasership(address indexed previousRebaser, address indexed newRebaser);

  constructor() internal {
    address msgSender = _msgSender();
    _rebaser = msgSender;
    emit TransferredRebasership(address(0), msgSender);
  }

  function Rebaser() public view returns(address) {
    return _rebaser;
  }

  modifier onlyRebaser() {
    require(_rebaser == _msgSender(), "caller is not rebaser");
    _;
  }

  function transferRebasership(address newRebaser) public virtual onlyOwner {
    require(newRebaser != address(0), "new rebaser is address zero");
    emit TransferredRebasership(_rebaser, newRebaser);
    _rebaser = newRebaser;
  }
}


pragma solidity 0.6.12;
contract XplosiveBNB is Ownable, Pausable, Rebasable
{
    using XSafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);

    event Rebase(uint256 indexed epoch, uint256 scalingFactor);

    event WhitelistFrom(address _addr, bool _whitelisted);
    event WhitelistTo(address _addr, bool _whitelisted);
    event WhitelistRebase(address _addr, bool _whitelisted);

    string public name     = "XplosiveBNB";
    string public symbol   = "xBNB";
    uint8  public decimals = 18;

    // address public rebaser;
    address public rewardAddress;

    /**
     * @notice Internal decimals used to handle scaling factor
     */
    uint256 public constant internalDecimals = 10**24;

    /**
     * @notice Used for percentage maths
     */
    uint256 public constant BASE = 10**18;

    /**
     * @notice Scaling factor that adjusts everyone's balances
     */
    uint256 public xBNBScalingFactor  = BASE;

    mapping (address => uint256) internal _xBNBBalances;
    mapping (address => mapping (address => uint256)) internal _allowedFragments;

    mapping(address => bool) public whitelistFrom;
    mapping(address => bool) public whitelistTo;
    mapping(address => bool) public whitelistRebase;

    address public noRebaseAddress;

    uint256 initSupply = 0;
    uint256 _totalSupply = 0;
    uint16 public SELL_FEE = 25;
    uint16 public TX_FEE = 50;

    constructor( uint256 initialSupply, address initialSupplyAddr )
    public
    Ownable()
    Pausable()
    Rebasable()
    {
        _mint(initialSupplyAddr,initialSupply);
    }

  
    function totalSupply()
    public
    view
    returns (uint256)
    {
        return _totalSupply;
    }

    function getSellBurn(uint256 value)
    public
    view
    whenNotPaused
    returns (uint256)
    {
        uint256 nPercent = value.divRound(SELL_FEE);
        return nPercent;
    }

    function getTxBurn(uint256 value)
    public
    view
    whenNotPaused
    returns (uint256)
    {
        uint256 nPercent = value.divRound(TX_FEE);
        return nPercent;
    }

    function _isWhitelisted(address _from, address _to)
    internal
    view
    returns (bool)
    {
        return whitelistFrom[_from]||whitelistTo[_to];
    }

    function _isRebaseWhitelisted(address _addr)
    internal
    view
    returns (bool)
    {
        return whitelistRebase[_addr];
    }

    function setWhitelistedTo(address _addr, bool _whitelisted)
    external
    onlyOwner
    {
        emit WhitelistTo(_addr, _whitelisted);
        whitelistTo[_addr] = _whitelisted;
    }

    function setTxFee(uint16 fee)
    external
    onlyRebaser
    whenNotPaused
    {
        TX_FEE = fee;
    }

    function setSellFee(uint16 fee)
    external
    onlyRebaser
    whenNotPaused
    {
        SELL_FEE = fee;
    }

    function setWhitelistedFrom(address _addr, bool _whitelisted)
    external
    onlyOwner
    {
        emit WhitelistFrom(_addr, _whitelisted);
        whitelistFrom[_addr] = _whitelisted;
    }

    function setWhitelistedRebase(address _addr, bool _whitelisted)
    external
    onlyOwner
    {
        emit WhitelistRebase(_addr, _whitelisted);
        whitelistRebase[_addr] = _whitelisted;
    }

    function setNoRebaseAddress(address _addr)
    external
    onlyOwner
    {
        noRebaseAddress = _addr;
    }

    /**
    * @notice Computes the current max scaling factor
    */
    function maxScalingFactor()
    external
    view
    whenNotPaused
    returns (uint256)
    {
        return _maxScalingFactor();
    }

    function _maxScalingFactor()
    internal
    view
    returns (uint256)
    {
        // scaling factor can only go up to 2**256-1 = initSupply * xBNBScalingFactor
        // this is used to check if xBNBScalingFactor will be too high to compute balances when rebasing.
        return uint256(-1) / initSupply;
    }

    function _mint(address to, uint256 amount)
    internal
    {
      // increase totalSupply
      _totalSupply = _totalSupply.add(amount);

      // get underlying value
      uint256 xBNBValue = amount.mul(internalDecimals).div(xBNBScalingFactor);

      // increase initSupply
      initSupply = initSupply.add(xBNBValue);

      // make sure the mint didnt push maxScalingFactor too low
      require(xBNBScalingFactor <= _maxScalingFactor(), "max scaling factor too low");

      // add balance
      _xBNBBalances[to] = _xBNBBalances[to].add(xBNBValue);

      emit Transfer(address(0),to,amount);
    }

    /* - ERC20 functionality - */

    /**
    * @dev Transfer tokens to a specified address.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    * @return True on success, false otherwise.
    */
    function transfer(address to, uint256 value)
    external
    whenNotPaused
    returns (bool)
    {
        // underlying balance is stored in xBNB, so divide by current scaling factor

        // note, this means as scaling factor grows, dust will be untransferrable.
        // minimum transfer value == xBNBScalingFactor / 1e24;

        // get amount in underlying
        //from noRebaseWallet
        if(_isRebaseWhitelisted(msg.sender))
        {
            uint256 noReValue = value.mul(internalDecimals).div(BASE);
            uint256 noReNextValue = noReValue.mul(BASE).div(xBNBScalingFactor);
            _xBNBBalances[msg.sender] = _xBNBBalances[msg.sender].sub(noReValue); //value==underlying
            _xBNBBalances[to] = _xBNBBalances[to].add(noReNextValue);
            emit Transfer(msg.sender, to, value);
        }
        else if(_isRebaseWhitelisted(to))
        {
            uint256 fee = getSellBurn(value);
            uint256 tokensToBurn = fee/2;
            uint256 tokensForRewards = fee-tokensToBurn;
            uint256 tokensToTransfer = value-fee;

            uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);
            uint256 xBNBValueKeep = tokensToTransfer.mul(internalDecimals).div(xBNBScalingFactor);
            uint256 xBNBValueReward = tokensForRewards.mul(internalDecimals).div(xBNBScalingFactor);


            uint256 xBNBNextValue = xBNBValueKeep.mul(xBNBScalingFactor).div(BASE);

            _totalSupply = _totalSupply-fee;
            _xBNBBalances[address(0)] = _xBNBBalances[address(0)].add(fee/2);
            _xBNBBalances[msg.sender] = _xBNBBalances[msg.sender].sub(xBNBValue);
            _xBNBBalances[to] = _xBNBBalances[to].add(xBNBNextValue);
            _xBNBBalances[rewardAddress] = _xBNBBalances[rewardAddress].add(xBNBValueReward);
            emit Transfer(msg.sender, to, tokensToTransfer);
            emit Transfer(msg.sender, address(0), tokensToBurn);
            emit Transfer(msg.sender, rewardAddress, tokensForRewards);
        }
        else
        {
            if(!_isWhitelisted(msg.sender, to))
            {
                uint256 fee = getTxBurn(value);
                uint256 tokensToBurn = fee/2;
                uint256 tokensForRewards = fee-tokensToBurn;
                uint256 tokensToTransfer = value-fee;

                uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);
                uint256 xBNBValueKeep = tokensToTransfer.mul(internalDecimals).div(xBNBScalingFactor);
                uint256 xBNBValueReward = tokensForRewards.mul(internalDecimals).div(xBNBScalingFactor);

                _totalSupply = _totalSupply-fee;
                _xBNBBalances[address(0)] = _xBNBBalances[address(0)].add(fee/2);
                _xBNBBalances[msg.sender] = _xBNBBalances[msg.sender].sub(xBNBValue);
                _xBNBBalances[to] = _xBNBBalances[to].add(xBNBValueKeep);
                _xBNBBalances[rewardAddress] = _xBNBBalances[rewardAddress].add(xBNBValueReward);
                emit Transfer(msg.sender, to, tokensToTransfer);
                emit Transfer(msg.sender, address(0), tokensToBurn);
                emit Transfer(msg.sender, rewardAddress, tokensForRewards);
            }
            else
            {
                uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);

                _xBNBBalances[msg.sender] = _xBNBBalances[msg.sender].sub(xBNBValue);
                _xBNBBalances[to] = _xBNBBalances[to].add(xBNBValue);
                emit Transfer(msg.sender, to, xBNBValue);
             }
        }
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another.
    * @param from The address you want to send tokens from.
    * @param to The address you want to transfer to.
    * @param value The amount of tokens to be transferred.
    */
    function transferFrom(address from, address to, uint256 value)
    external
    whenNotPaused
    returns (bool)
    {
        // decrease allowance
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);

        if(_isRebaseWhitelisted(from))
        {
            uint256 noReValue = value.mul(internalDecimals).div(BASE);
            uint256 noReNextValue = noReValue.mul(BASE).div(xBNBScalingFactor);
            _xBNBBalances[from] = _xBNBBalances[from].sub(noReValue); //value==underlying
            _xBNBBalances[to] = _xBNBBalances[to].add(noReNextValue);
            emit Transfer(from, to, value);
        }
        else if(_isRebaseWhitelisted(to))
        {
            uint256 fee = getSellBurn(value);
            uint256 tokensForRewards = fee-(fee/2);
            uint256 tokensToTransfer = value-fee;

            uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);
            uint256 xBNBValueKeep = tokensToTransfer.mul(internalDecimals).div(xBNBScalingFactor);
            uint256 xBNBValueReward = tokensForRewards.mul(internalDecimals).div(xBNBScalingFactor);
            uint256 xBNBNextValue = xBNBValueKeep.mul(xBNBScalingFactor).div(BASE);

            _totalSupply = _totalSupply-fee;

            _xBNBBalances[from] = _xBNBBalances[from].sub(xBNBValue);
            _xBNBBalances[to] = _xBNBBalances[to].add(xBNBNextValue);
            _xBNBBalances[rewardAddress] = _xBNBBalances[rewardAddress].add(xBNBValueReward);
            _xBNBBalances[address(0)] = _xBNBBalances[address(0)].add(fee/2);
            emit Transfer(from, to, tokensToTransfer);
            emit Transfer(from, address(0), fee/2);
            emit Transfer(from, rewardAddress, tokensForRewards);
        }
        else
        {
            if(!_isWhitelisted(from, to))
            {
                uint256 fee = getTxBurn(value);
                uint256 tokensToBurn = fee/2;
                uint256 tokensForRewards = fee-tokensToBurn;
                uint256 tokensToTransfer = value-fee;

                uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);
                uint256 xBNBValueKeep = tokensToTransfer.mul(internalDecimals).div(xBNBScalingFactor);
                uint256 xBNBValueReward = tokensForRewards.mul(internalDecimals).div(xBNBScalingFactor);

                _totalSupply = _totalSupply-fee;
                _xBNBBalances[address(0)] = _xBNBBalances[address(0)].add(fee/2);
                _xBNBBalances[from] = _xBNBBalances[from].sub(xBNBValue);
                _xBNBBalances[to] = _xBNBBalances[to].add(xBNBValueKeep);
                _xBNBBalances[rewardAddress] = _xBNBBalances[rewardAddress].add(xBNBValueReward);
                emit Transfer(from, to, tokensToTransfer);
                emit Transfer(from, address(0), tokensToBurn);
                emit Transfer(from, rewardAddress, tokensForRewards);
            }
            else
            {
                uint256 xBNBValue = value.mul(internalDecimals).div(xBNBScalingFactor);

                _xBNBBalances[from] = _xBNBBalances[from].sub(xBNBValue);
                _xBNBBalances[to] = _xBNBBalances[to].add(xBNBValue);
                emit Transfer(from, to, xBNBValue);
             }
        }
        return true;
    }

    /**
    * @param who The address to query.
    * @return The balance of the specified address.
    */
    function balanceOf(address who)
    external
    view
    returns (uint256)
    {
        if(_isRebaseWhitelisted(who))
        {
            return _xBNBBalances[who].mul(BASE).div(internalDecimals);
        }
        else
        {
            return _xBNBBalances[who].mul(xBNBScalingFactor).div(internalDecimals);
        }
    }

    /** @notice Currently returns the internal storage amount
    * @param who The address to query.
    * @return The underlying balance of the specified address.
    */
    function balanceOfUnderlying(address who)
    external
    view
    returns (uint256)
    {
        return _xBNBBalances[who];
    }

    /**
     * @dev Function to check the amount of tokens that an owner has allowed to a spender.
     * @param owner_ The address which owns the funds.
     * @param spender The address which will spend the funds.
     * @return The number of tokens still available for the spender.
     */
    function allowance(address owner_, address spender)
    external
    view
    whenNotPaused
    returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of
     * msg.sender. This method is included for ERC20 compatibility.
     * increaseAllowance and decreaseAllowance should be used instead.
     * Changing an allowance with this method brings the risk that someone may transfer both
     * the old and the new allowance - if they are both greater than zero - if a transfer
     * transaction is mined before the later approve() call is mined.
     *
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value)
    external
    whenNotPaused
    returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner has allowed to a spender.
     * This method should be used instead of approve() to avoid the double approval vulnerability
     * described above.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue)
    external
    whenNotPaused
    returns (bool)
    {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner has allowed to a spender.
     *
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
    external
    whenNotPaused
    returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue)
        {
            _allowedFragments[msg.sender][spender] = 0;
        }
        else
        {
            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
        }

        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    function _setRewardAddress(address rewards_)
    external
    onlyOwner
    {
        rewardAddress = rewards_;
    }

    /**
    * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
    *
    * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
    *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
    *      and targetRate is CpiOracleRate / baseCpi
    */
    function rebase(uint256 epoch, uint256 indexDelta, bool positive)
    external
    onlyRebaser
    whenNotPaused
    returns (uint256)
    {
        if (indexDelta == 0 || !positive)
        {
            emit Rebase(epoch, xBNBScalingFactor);
            return _totalSupply;
        }

        uint256 newScalingFactor = xBNBScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
        if (newScalingFactor < _maxScalingFactor())
        {
            xBNBScalingFactor = newScalingFactor;
        }
        else
        {
            xBNBScalingFactor = _maxScalingFactor();
        }

        _totalSupply = ((initSupply.sub(_xBNBBalances[address(0)]).sub(_xBNBBalances[noRebaseAddress]))
            .mul(xBNBScalingFactor).div(internalDecimals))
            .add(_xBNBBalances[noRebaseAddress].mul(BASE).div(internalDecimals));

        emit Rebase(epoch, xBNBScalingFactor);
        return _totalSupply;
    }
}