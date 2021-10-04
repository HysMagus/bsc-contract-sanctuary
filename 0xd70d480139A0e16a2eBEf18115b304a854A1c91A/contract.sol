// Dependency file: contracts/libraries/SafeMath.sol

// SPDX-License-Identifier: MIT

// pragma solidity >=0.6.0;

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

// Dependency file: contracts/libraries/TransferHelper.sol


// pragma solidity >=0.6.0;

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}


// Dependency file: contracts/modules/Configable.sol

// pragma solidity >=0.5.16;
pragma experimental ABIEncoderV2;

interface IConfig {
    function developer() external view returns (address);
    function platform() external view returns (address);
    function factory() external view returns (address);
    function mint() external view returns (address);
    function token() external view returns (address);
    function developPercent() external view returns (uint);
    function base() external view returns (address);
    function share() external view returns (address);
    function governor() external view returns (address);
    function poolParams(address pool, bytes32 key) external view returns (uint);
    function params(bytes32 key) external view returns(uint);
    function wallets(bytes32 key) external view returns(address);
    function setParameter(uint[] calldata _keys, uint[] calldata _values) external;
    function setPoolParameter(address _pool, bytes32 _key, uint _value) external;
}

contract Configable {
    address public config;
    address public owner;

    event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);

    constructor() public {
        owner = msg.sender;
    }
    
    function setupConfig(address _config) external onlyOwner {
        config = _config;
        owner = IConfig(config).developer();
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'OWNER FORBIDDEN');
        _;
    }
    
    modifier onlyDeveloper() {
        require(msg.sender == IConfig(config).developer(), 'DEVELOPER FORBIDDEN');
        _;
    }
    
    modifier onlyPlatform() {
        require(msg.sender == IConfig(config).platform(), 'PLATFORM FORBIDDEN');
        _;
    }

    modifier onlyFactory() {
        require(msg.sender == IConfig(config).factory(), 'FACTORY FORBIDDEN');
        _;
    }

    modifier onlyGovernor() {
        require(msg.sender == IConfig(config).governor(), 'Governor FORBIDDEN');
        _;
    }
}

// Root file: contracts/SevenUpMint.sol

pragma solidity >=0.5.16;
// import "contracts/libraries/SafeMath.sol";
// import "contracts/libraries/TransferHelper.sol";
// import "contracts/modules/Configable.sol";

contract SevenUpMint is Configable {
    using SafeMath for uint;
    
    uint public mintCumulation;
    uint public amountPerBlock;
    uint public lastRewardBlock;
    
    uint public totalLendProductivity;
    uint public totalBorrowProducitivity;
    uint public accAmountPerLend;
    uint public accAmountPerBorrow;
    
    uint public totalBorrowSupply;
    uint public totalLendSupply;
    
    uint public borrowPower = 0;

    bytes32 public MaxSupplyKey = bytes32("7upMaxSupply");
    bytes32 public UserMintKey = bytes32("7upTokenUserMint");
    bytes32 public TeamMintKey = bytes32("7upTokenTeamMint");
    bytes32 public TeamWalletKey = bytes32("team");
    bytes32 public SpareWalletKey = bytes32("spare");
    
    struct UserInfo {
        uint amount;     // How many tokens the user has provided.
        uint rewardDebt; // Reward debt. 
        uint rewardEarn; // Reward earn and not minted
        uint index;
    }
    
    mapping(address => UserInfo) public lenders;
    mapping(address => UserInfo) public borrowers;

    address[] public lenderList;
    address[] public borrowerList;

    uint public numberOfLender;
    uint public numberOfBorrower;

    event BorrowPowerChange (uint oldValue, uint newValue);
    event InterestRatePerBlockChanged (uint oldValue, uint newValue);
    event BorrowerProductivityIncreased (address indexed user, uint value);
    event BorrowerProductivityDecreased (address indexed user, uint value);
    event LenderProductivityIncreased (address indexed user, uint value);
    event LenderProductivityDecreased (address indexed user, uint value);
    event Mint(address indexed user, uint userAmount, uint teamAmount, uint spareAmount);
    
    function changeBorrowPower(uint _value) external onlyGovernor {
        uint old = borrowPower;
        require(_value != old, 'POWER_NO_CHANGE');
        require(_value <= 10000, 'INVALID_POWER_VALUE');
        
        _update();
        borrowPower = _value;
        
        emit BorrowPowerChange(old, _value);
    }
    
    // External function call
    // This function adjust how many token will be produced by each block, eg:
    // changeAmountPerBlock(100)
    // will set the produce rate to 100/block.
    function changeInterestRatePerBlock(uint value) external onlyGovernor returns (bool) {
        uint old = amountPerBlock;
        require(value != old, 'AMOUNT_PER_BLOCK_NO_CHANGE');

        _update();
        amountPerBlock = value;

        emit InterestRatePerBlockChanged(old, value);
        return true;
    }

    // Update reward variables of the given pool to be up-to-date.
    function _update() internal virtual {
        if (block.number <= lastRewardBlock) {
            return;
        }

        uint256 reward = _currentReward();
        if (totalLendProductivity.add(totalBorrowProducitivity) == 0 || reward == 0) {
            lastRewardBlock = block.number;
            return;
        }
        
        uint borrowReward = reward.mul(borrowPower).div(10000);
        uint lendReward = reward.sub(borrowReward);

        if(totalLendProductivity != 0 && lendReward > 0) {
            totalLendSupply = totalLendSupply.add(lendReward);
            accAmountPerLend = accAmountPerLend.add(lendReward.mul(1e12).div(totalLendProductivity));
        }

        if(totalBorrowProducitivity != 0 && borrowReward > 0) {
            totalBorrowSupply = totalBorrowSupply.add(borrowReward);
            accAmountPerBorrow = accAmountPerBorrow.add(borrowReward.mul(1e12).div(totalBorrowProducitivity));
        }
        
        lastRewardBlock = block.number;
    }
    
    function _currentReward() internal virtual view returns (uint){
        uint256 multiplier = block.number.sub(lastRewardBlock);
        uint reward = multiplier.mul(amountPerBlock);
        uint maxSupply = IConfig(config).params(MaxSupplyKey);
        if(totalLendSupply.add(totalBorrowSupply).add(reward) > maxSupply) {
            reward = maxSupply.sub(totalLendSupply).sub(totalBorrowSupply);
        }
        
        return reward;
    }
    
    // Audit borrowers's reward to be up-to-date
    function _auditBorrower(address user) internal {
        UserInfo storage userInfo = borrowers[user];
        if (userInfo.amount > 0) {
            uint pending = userInfo.amount.mul(accAmountPerBorrow).div(1e12).sub(userInfo.rewardDebt);
            userInfo.rewardEarn = userInfo.rewardEarn.add(pending);
            mintCumulation = mintCumulation.add(pending);
            userInfo.rewardDebt = userInfo.amount.mul(accAmountPerBorrow).div(1e12);
        }
    }
    
    // Audit lender's reward to be up-to-date
    function _auditLender(address user) internal {
        UserInfo storage userInfo = lenders[user];
        if (userInfo.amount > 0) {
            uint pending = userInfo.amount.mul(accAmountPerLend).div(1e12).sub(userInfo.rewardDebt);
            userInfo.rewardEarn = userInfo.rewardEarn.add(pending);
            mintCumulation = mintCumulation.add(pending);
            userInfo.rewardDebt = userInfo.amount.mul(accAmountPerLend).div(1e12);
        }
    }

    function increaseBorrowerProductivity(address user, uint value) external onlyPlatform returns (bool) {
        require(value > 0, 'PRODUCTIVITY_VALUE_MUST_BE_GREATER_THAN_ZERO');

        UserInfo storage userInfo = borrowers[user];
        _update();
        _auditBorrower(user);

        if(borrowers[user].index == 0)
        {
            borrowerList.push(user);
            numberOfBorrower++;
            borrowers[user].index = numberOfBorrower;
        }

        totalBorrowProducitivity = totalBorrowProducitivity.add(value);

        userInfo.amount = userInfo.amount.add(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerBorrow).div(1e12);
        emit BorrowerProductivityIncreased(user, value);
        return true;
    }

    function decreaseBorrowerProductivity(address user, uint value) external onlyPlatform returns (bool) {
        require(value > 0, 'INSUFFICIENT_PRODUCTIVITY');
        
        UserInfo storage userInfo = borrowers[user];
        require(userInfo.amount >= value, "FORBIDDEN");
        _update();
        _auditBorrower(user);
        
        userInfo.amount = userInfo.amount.sub(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerBorrow).div(1e12);
        totalBorrowProducitivity = totalBorrowProducitivity.sub(value);

        emit BorrowerProductivityDecreased(user, value);
        return true;
    }
    
    function increaseLenderProductivity(address user, uint value) external onlyPlatform returns (bool) {
        require(value > 0, 'PRODUCTIVITY_VALUE_MUST_BE_GREATER_THAN_ZERO');

        UserInfo storage userInfo = lenders[user];
        _update();
        _auditLender(user);

        if(lenders[user].index == 0)
        {
            lenderList.push(user);
            numberOfLender++;
            lenders[user].index = numberOfLender;
        }

        totalLendProductivity = totalLendProductivity.add(value);

        userInfo.amount = userInfo.amount.add(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerLend).div(1e12);
        emit LenderProductivityIncreased(user, value);
        return true;
    }

    // External function call 
    // This function will decreases user's productivity by value, and updates the global productivity
    // it will record which block this is happenning and accumulates the area of (productivity * time)
    function decreaseLenderProductivity(address user, uint value) external onlyPlatform returns (bool) {
        require(value > 0, 'INSUFFICIENT_PRODUCTIVITY');
        
        UserInfo storage userInfo = lenders[user];
        require(userInfo.amount >= value, "FORBIDDEN");
        _update();
        _auditLender(user);
        
        userInfo.amount = userInfo.amount.sub(value);
        userInfo.rewardDebt = userInfo.amount.mul(accAmountPerLend).div(1e12);
        totalLendProductivity = totalLendProductivity.sub(value);

        emit LenderProductivityDecreased(user, value);
        return true;
    }
    
    function takeBorrowWithAddress(address user) public view returns (uint) {
        UserInfo storage userInfo = borrowers[user];
        uint _accAmountPerBorrow = accAmountPerBorrow;
        if (block.number > lastRewardBlock && totalBorrowProducitivity != 0) {
            uint reward = _currentReward();
            uint borrowReward = reward.mul(borrowPower).div(10000);
            
            _accAmountPerBorrow = accAmountPerBorrow.add(borrowReward.mul(1e12).div(totalBorrowProducitivity));
        }

        uint amount = userInfo.amount.mul(_accAmountPerBorrow).div(1e12).sub(userInfo.rewardDebt).add(userInfo.rewardEarn);
        return amount.mul(IConfig(config).params(UserMintKey)).div(10000);
    }
    
    function takeLendWithAddress(address user) public view returns (uint) {
        UserInfo storage userInfo = lenders[user];
        uint _accAmountPerLend = accAmountPerLend;
        if (block.number > lastRewardBlock && totalLendProductivity != 0) {
            uint reward = _currentReward();
            uint lendReward = reward.sub(reward.mul(borrowPower).div(10000)); 
            _accAmountPerLend = accAmountPerLend.add(lendReward.mul(1e12).div(totalLendProductivity));
        }
        uint amount = userInfo.amount.mul(_accAmountPerLend).div(1e12).sub(userInfo.rewardDebt).add(userInfo.rewardEarn);
        return amount.mul(IConfig(config).params(UserMintKey)).div(10000);
    }

    // Returns how much a user could earn plus the giving block number.
    function takeBorrowWithBlock() external view returns (uint, uint) {
        uint earn = takeBorrowWithAddress(msg.sender);
        return (earn, block.number);
    }
    
    function takeLendWithBlock() external view returns (uint, uint) {
        uint earn = takeLendWithAddress(msg.sender);
        return (earn, block.number);
    }

    function takeAll() public view returns (uint) {
        return takeBorrowWithAddress(msg.sender).add(takeLendWithAddress(msg.sender));
    }

    function takeAllWithBlock() external view returns (uint, uint) {
        return (takeAll(), block.number);
    }

    // External function call
    // When user calls this function, it will calculate how many token will mint to user from his productivity * time
    // Also it calculates global token supply from last time the user mint to this time.
    function mintBorrower() external returns (uint) {
        _update();
        _auditBorrower(msg.sender);
        require(borrowers[msg.sender].rewardEarn > 0, "NOTHING TO MINT");
        uint amount = borrowers[msg.sender].rewardEarn;
        _mintDistribution(msg.sender, amount);
        borrowers[msg.sender].rewardEarn = 0;
        return amount;
    }
    
    function mintLender() external returns (uint) {
        _update();
        _auditLender(msg.sender);
        require(lenders[msg.sender].rewardEarn > 0, "NOTHING TO MINT");
        uint amount = lenders[msg.sender].rewardEarn;
        _mintDistribution(msg.sender, amount);
        lenders[msg.sender].rewardEarn = 0;
        return amount;
    }

    function mintAll() external returns (uint) {
        _update();

        _auditBorrower(msg.sender);
        _auditLender(msg.sender);
        uint borrowAmount = borrowers[msg.sender].rewardEarn;
        uint lendAmount = lenders[msg.sender].rewardEarn;
        uint amount = lendAmount.add(borrowAmount);
        require(amount > 0, "NOTHING TO MINT");
        _mintDistribution(msg.sender, amount);
        borrowers[msg.sender].rewardEarn = 0;
        lenders[msg.sender].rewardEarn = 0;

        return amount;
    }

    // Returns how many productivity a user has and global has.
    function getBorrowerProductivity(address user) external view returns (uint, uint) {
        return (borrowers[user].amount, totalBorrowProducitivity);
    }
    
    function getLenderProductivity(address user) external view returns (uint, uint) {
        return (lenders[user].amount, totalLendProductivity);
    }

    // Returns the current gorss product rate.
    function interestsPerBlock() external view returns (uint, uint) {
        return (accAmountPerBorrow, accAmountPerLend);
    }

    function _mintDistribution(address user, uint amount) internal {
        uint userAmount = amount.mul(IConfig(config).params(UserMintKey)).div(10000);
        uint remainAmount = amount.sub(userAmount);
        uint teamAmount = remainAmount.mul(IConfig(config).params(TeamMintKey)).div(10000);
        if(teamAmount > 0) {
            TransferHelper.safeTransfer(IConfig(config).token(), IConfig(config).wallets(TeamWalletKey), teamAmount);
        }
        
        uint spareAmount = remainAmount.sub(teamAmount);
        if(spareAmount > 0) {
            TransferHelper.safeTransfer(IConfig(config).token(), IConfig(config).wallets(SpareWalletKey), spareAmount);
        }
        
        if(userAmount > 0) {
           TransferHelper.safeTransfer(IConfig(config).token(), user, userAmount); 
        }
        emit Mint(user, userAmount, teamAmount, spareAmount);
    }
}