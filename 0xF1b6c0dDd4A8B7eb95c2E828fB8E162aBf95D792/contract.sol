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


// Root file: contracts/SevenUpPlatform.sol

pragma solidity >=0.5.16;

// import "contracts/modules/Configable.sol";
// import "contracts/libraries/SafeMath.sol";
// import "contracts/libraries/TransferHelper.sol";

interface ISevenUpMint {
    function increaseBorrowerProductivity(address user, uint value) external returns (bool);
    function decreaseBorrowerProductivity(address user, uint value) external returns (bool);
    function increaseLenderProductivity(address user, uint value) external returns (bool);
    function decreaseLenderProductivity(address user, uint value) external returns (bool);
}

interface ISevenUpPool {
    function deposit(uint _amountDeposit, address _from) external;
    function withdraw(uint _amountWithdraw, address _from) external;
    function borrow(uint _amountCollateral, uint _expectBorrow, address _from) external;
    function repay(uint _amountCollateral, address _from) external returns(uint, uint);
    function liquidation(address _user, address _from) external returns (uint);
    function reinvest(address _from) external returns(uint);
    function updatePledgeRate(uint _pledgeRate) external;
    function updatePledgePrice(uint _pledgePrice) external;
    function updateLiquidationRate(uint _liquidationRate) external;
}

interface ISevenUpFactory {
    function getPool(address _lendToken, address _collateralToken) external view returns (address);
}

contract SevenUpPlatform is Configable {
    function deposit(address _lendToken, address _collateralToken, uint _amountDeposit) external {
        require(IConfig(config).params(bytes32("depositEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        ISevenUpPool(pool).deposit(_amountDeposit, msg.sender);
        if(_amountDeposit > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).increaseLenderProductivity(msg.sender, _amountDeposit);
        }
    }
    
    function withdraw(address _lendToken, address _collateralToken, uint _amountWithdraw) external {
        require(IConfig(config).params(bytes32("withdrawEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        ISevenUpPool(pool).withdraw(_amountWithdraw, msg.sender);
        if(_amountWithdraw > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).decreaseLenderProductivity(msg.sender, _amountWithdraw);
        }
    }
    
    function borrow(address _lendToken, address _collateralToken, uint _amountCollateral, uint _expectBorrow) external {
        require(IConfig(config).params(bytes32("borrowEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        ISevenUpPool(pool).borrow(_amountCollateral, _expectBorrow, msg.sender);
        if(_expectBorrow > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).increaseBorrowerProductivity(msg.sender, _expectBorrow);
        }
    }
    
    function repay(address _lendToken, address _collateralToken, uint _amountCollateral) external {
        require(IConfig(config).params(bytes32("repayEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        (uint repayAmount, ) = ISevenUpPool(pool).repay(_amountCollateral, msg.sender);
        if(repayAmount > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).decreaseBorrowerProductivity(msg.sender, repayAmount);
        }
    }
    
    function liquidation(address _lendToken, address _collateralToken, address _user) external {
        require(IConfig(config).params(bytes32("liquidationEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        uint borrowAmount = ISevenUpPool(pool).liquidation(_user, msg.sender);
        if(borrowAmount > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).decreaseBorrowerProductivity(_user, borrowAmount);
        }
    }

    function reinvest(address _lendToken, address _collateralToken) external {
        require(IConfig(config).params(bytes32("reinvestEnable")) == 1, "NOT ENABLE NOW");
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        uint reinvestAmount = ISevenUpPool(pool).reinvest(msg.sender);

        if(reinvestAmount > 0 && _lendToken == IConfig(config).base()) {
            ISevenUpMint(IConfig(config).mint()).increaseLenderProductivity(msg.sender, reinvestAmount);
        }
    } 

    function updatePoolParameter(address _lendToken, address _collateralToken, bytes32 _key, uint _value) external onlyDeveloper
    {
        address pool = ISevenUpFactory(IConfig(config).factory()).getPool(_lendToken, _collateralToken);
        require(pool != address(0), "POOL NOT EXIST");
        IConfig(config).setPoolParameter(pool, _key, _value);
    }
}