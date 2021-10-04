// Dependency file: contracts/modules/Configable.sol

// SPDX-License-Identifier: MIT
// pragma solidity >=0.5.16;
pragma experimental ABIEncoderV2;

interface IConfig {
    function developer() external view returns (address);
    function platform() external view returns (address);
    function factory() external view returns (address);
    function mint() external view returns (address);
    function token() external view returns (address);
    function developPercent() external view returns (uint);
    function share() external view returns (address);
    function governor() external view returns (address);
    function getPoolValue(address pool, bytes32 key) external view returns (uint);
    function getValue(bytes32 key) external view returns(uint);
    function getParams(bytes32 key) external view returns(uint, uint, uint, uint); 
    function getPoolParams(address pool, bytes32 key) external view returns(uint, uint, uint, uint); 
    function wallets(bytes32 key) external view returns(address);
    function setValue(bytes32 key, uint value) external;
    function setPoolValue(address pool, bytes32 key, uint value) external;
    function setParams(bytes32 _key, uint _min, uint _max, uint _span, uint _value) external;
    function setPoolParams(bytes32 _key, uint _min, uint _max, uint _span, uint _value) external;
    function initPoolParams(address _pool) external;
    function isMintToken(address _token) external returns (bool); 
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

// Dependency file: contracts/modules/ConfigNames.sol

// pragma solidity >=0.5.16;

library ConfigNames {
    //GOVERNANCE
    bytes32 public constant PROPOSAL_VOTE_DURATION = bytes32('PROPOSAL_VOTE_DURATION');
    bytes32 public constant PROPOSAL_EXECUTE_DURATION = bytes32('PROPOSAL_EXECUTE_DURATION');
    bytes32 public constant PROPOSAL_CREATE_COST = bytes32('PROPOSAL_CREATE_COST');
    bytes32 public constant STAKE_LOCK_TIME = bytes32('STAKE_LOCK_TIME');
    bytes32 public constant MINT_AMOUNT_PER_BLOCK =  bytes32('MINT_AMOUNT_PER_BLOCK');
    bytes32 public constant INTEREST_PLATFORM_SHARE =  bytes32('INTEREST_PLATFORM_SHARE');
    bytes32 public constant CHANGE_PRICE_DURATION =  bytes32('CHANGE_PRICE_DURATION');
    bytes32 public constant CHANGE_PRICE_PERCENT =  bytes32('CHANGE_PRICE_PERCENT');
    bytes32 public constant MINT_BORROW_PERCENT = bytes32('MINT_BORROW_PERCENT');

    // POOL
    bytes32 public constant POOL_BASE_INTERESTS = bytes32('POOL_BASE_INTERESTS');
    bytes32 public constant POOL_MARKET_FRENZY = bytes32('POOL_MARKET_FRENZY');
    bytes32 public constant POOL_PLEDGE_RATE = bytes32('POOL_PLEDGE_RATE');
    bytes32 public constant POOL_LIQUIDATION_RATE = bytes32('POOL_LIQUIDATION_RATE');
    
    //NOT GOVERNANCE
    bytes32 public constant AAAA_MAX_SUPPLY = bytes32('AAAA_MAX_SUPPLY');
    bytes32 public constant AAAA_USER_MINT = bytes32('AAAA_USER_MINT');
    bytes32 public constant AAAA_TEAM_MINT = bytes32('AAAA_TEAM_MINT');
    bytes32 public constant AAAA_REWAED_MINT = bytes32('AAAA_REWAED_MINT');
    bytes32 public constant DEPOSIT_ENABLE = bytes32('DEPOSIT_ENABLE');
    bytes32 public constant WITHDRAW_ENABLE = bytes32('WITHDRAW_ENABLE');
    bytes32 public constant BORROW_ENABLE = bytes32('BORROW_ENABLE');
    bytes32 public constant REPAY_ENABLE = bytes32('REPAY_ENABLE');
    bytes32 public constant LIQUIDATION_ENABLE = bytes32('LIQUIDATION_ENABLE');
    bytes32 public constant REINVEST_ENABLE = bytes32('REINVEST_ENABLE');
    bytes32 public constant INTEREST_BUYBACK_SHARE =  bytes32('INTEREST_BUYBACK_SHARE');

    //POOL
    bytes32 public constant POOL_PRICE = bytes32('POOL_PRICE');

    //wallet
    bytes32 public constant TEAM = bytes32('team'); 
    bytes32 public constant SPARE = bytes32('spare');
    bytes32 public constant REWARD = bytes32('reward');
}

// Dependency file: contracts/libraries/SafeMath.sol


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


// Root file: contracts/AAAAPlatform.sol

pragma solidity >=0.5.16;

// import "contracts/modules/Configable.sol";
// import "contracts/modules/ConfigNames.sol";
// import "contracts/libraries/SafeMath.sol";
// import "contracts/libraries/TransferHelper.sol";

interface IAAAAMint {
    function getBorrowerProductivity(address user) external view returns (uint, uint);
    function getLenderProductivity(address user) external view returns (uint, uint);
    function increaseBorrowerProductivity(address user, uint value) external returns (bool);
    function decreaseBorrowerProductivity(address user, uint value) external returns (bool);
    function increaseLenderProductivity(address user, uint value) external returns (bool);
    function decreaseLenderProductivity(address user, uint value) external returns (bool);
}

interface IAAAAPool {
    function deposit(uint _amountDeposit, address _from) external;
    function withdraw(uint _amountWithdraw, address _from) external;
    function borrow(uint _amountCollateral, uint _expectBorrow, address _from) external;
    function repay(uint _amountCollateral, address _from) external returns(uint, uint);
    function liquidation(address _user, address _from) external returns (uint);
    function reinvest(address _from) external returns(uint);
    function updatePledgeRate(uint _pledgeRate) external;
    function updatePledgePrice(uint _pledgePrice) external;
    function updateLiquidationRate(uint _liquidationRate) external;
    function switchStrategy(address _collateralStrategy) external;
    function supplys(address user) external view returns(uint,uint,uint,uint,uint);
    function borrows(address user) external view returns(uint,uint,uint,uint,uint);
}

interface IAAAAFactory {
    function getPool(address _lendToken, address _collateralToken) external view returns (address);
    function allPools() external returns (address[] memory);
}

contract AAAAPlatform is Configable {

    using SafeMath for uint;

    function deposit(address _lendToken, address _collateralToken, uint _amountDeposit) external {
        require(IConfig(config).getValue(ConfigNames.DEPOSIT_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IAAAAPool(pool).deposit(_amountDeposit, msg.sender);
        if(_amountDeposit > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).increaseLenderProductivity(msg.sender, _amountDeposit);
        }
    }
    
    function withdraw(address _lendToken, address _collateralToken, uint _amountWithdraw) external {
        require(IConfig(config).getValue(ConfigNames.WITHDRAW_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IAAAAPool(pool).withdraw(_amountWithdraw, msg.sender);
        if(_amountWithdraw > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).decreaseLenderProductivity(msg.sender, _amountWithdraw);
        }
    }
    
    function borrow(address _lendToken, address _collateralToken, uint _amountCollateral, uint _expectBorrow) external {
        require(IConfig(config).getValue(ConfigNames.BORROW_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IAAAAPool(pool).borrow(_amountCollateral, _expectBorrow, msg.sender);
        if(_expectBorrow > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).increaseBorrowerProductivity(msg.sender, _expectBorrow);
        }
    }
    
    function repay(address _lendToken, address _collateralToken, uint _amountCollateral) external {
        require(IConfig(config).getValue(ConfigNames.REPAY_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        (uint repayAmount, ) = IAAAAPool(pool).repay(_amountCollateral, msg.sender);
        if(repayAmount > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).decreaseBorrowerProductivity(msg.sender, repayAmount);
        }
    }
    
    function liquidation(address _lendToken, address _collateralToken, address _user) external {
        require(IConfig(config).getValue(ConfigNames.LIQUIDATION_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        uint borrowAmount = IAAAAPool(pool).liquidation(_user, msg.sender);
        if(borrowAmount > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).decreaseBorrowerProductivity(_user, borrowAmount);
        }
    }

    function reinvest(address _lendToken, address _collateralToken) external {
        require(IConfig(config).getValue(ConfigNames.REINVEST_ENABLE) == 1, "NOT ENABLE NOW");
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        uint reinvestAmount = IAAAAPool(pool).reinvest(msg.sender);

        if(reinvestAmount > 0 && IConfig(config).isMintToken(_lendToken)) {
            IAAAAMint(IConfig(config).mint()).increaseLenderProductivity(msg.sender, reinvestAmount);
        }
    } 

    function recalculteProdutivity(address[] calldata _users) external onlyDeveloper {
        for(uint i = 0;i < _users.length;i++) {
            address _user = _users[i];
            address[] memory pools = IAAAAFactory(IConfig(config).factory()).allPools();
            (uint oldLendProdutivity, ) = IAAAAMint(IConfig(config).mint()).getLenderProductivity(_user);
            (uint oldBorrowProdutivity, ) = IAAAAMint(IConfig(config).mint()).getBorrowerProductivity(_user);
            uint newLendProdutivity;
            uint newBorrowProdutivity;
            for(uint j = 0;j < pools.length;j++) {
                (uint amountSupply, , , , ) = IAAAAPool(pools[i]).supplys(_user);
                (, , , uint amountBorrow, ) = IAAAAPool(pools[i]).borrows(_user);

                newLendProdutivity = newLendProdutivity.add(amountSupply);
                newBorrowProdutivity = newBorrowProdutivity.add(amountBorrow);
            }

            if(oldLendProdutivity > 0) {
                IAAAAMint(IConfig(config).mint()).decreaseLenderProductivity(_user, oldLendProdutivity);
            }

            if(oldBorrowProdutivity > 0) {
                IAAAAMint(IConfig(config).mint()).decreaseBorrowerProductivity(_user, oldBorrowProdutivity);
            }

            if(newLendProdutivity > 0) {
                IAAAAMint(IConfig(config).mint()).increaseLenderProductivity(_user, newLendProdutivity);
            }

            if(newBorrowProdutivity > 0) {
                IAAAAMint(IConfig(config).mint()).increaseBorrowerProductivity(_user, newBorrowProdutivity);
            }
        }
    }

    function switchStrategy(address _lendToken, address _collateralToken, address _collateralStrategy) external onlyDeveloper
    {
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IAAAAPool(pool).switchStrategy(_collateralStrategy);
    }

    function updatePoolParameter(address _lendToken, address _collateralToken, bytes32 _key, uint _value) external onlyDeveloper
    {
        address pool = IAAAAFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IConfig(config).setPoolValue(pool, _key, _value);
    }
}