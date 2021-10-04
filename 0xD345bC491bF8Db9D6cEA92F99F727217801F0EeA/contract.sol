// Dependency file: contracts/interface/IERC20.sol

//SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
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

// Dependency file: contracts/7up.sol

// pragma solidity >=0.5.16;
// import "contracts/interface/IERC20.sol";
// import "contracts/libraries/TransferHelper.sol";
// import "contracts/libraries/SafeMath.sol";
// import "contracts/modules/Configable.sol";

contract SevenUpPool is Configable
{
    using SafeMath for uint;

    address public dev;
    address public factory;
    address public supplyToken;
    address public collateralToken;

    struct SupplyStruct {
        uint amountSupply;
        uint interestSettled;
        uint liquidationSettled;

        uint interests;
        uint liquidation;
    }

    struct BorrowStruct {
        uint index;
        uint amountCollateral;
        uint interestSettled;
        uint amountBorrow;
        uint interests;
    }

    struct LiquidationStruct {
        uint amountCollateral;
        uint liquidationAmount;
        uint timestamp;
    }

    address[] public borrowerList;
    uint public numberBorrowers;

    mapping(address => SupplyStruct) public supplys;
    mapping(address => BorrowStruct) public borrows;
    mapping(address => LiquidationStruct []) public liquidationHistory;
    mapping(address => uint) public liquidationHistoryLength;

    uint public interestPerSupply;
    uint public liquidationPerSupply;
    uint public interestPerBorrow;

    uint public totalLiquidation;
    uint public totalLiquidationSupplyAmount;

    uint public totalBorrow;
    uint public totalPledge;

    uint public remainSupply;

    uint public lastInterestUpdate;

    event Deposit(address indexed _user, uint _amount, uint _collateralAmount);
    event Withdraw(address indexed _user, uint _supplyAmount, uint _collateralAmount, uint _interestAmount);
    event Borrow(address indexed _user, uint _supplyAmount, uint _collateralAmount);
    event Repay(address indexed _user, uint _supplyAmount, uint _collateralAmount, uint _interestAmount);
    event Liquidation(address indexed _liquidator, address indexed _user, uint _supplyAmount, uint _collateralAmount);
    event Reinvest(address indexed _user, uint _reinvestAmount);

    constructor() public 
    {
        factory = msg.sender;
    }

    function init(address _supplyToken,  address _collateralToken) external onlyFactory
    {
        supplyToken = _supplyToken;
        collateralToken = _collateralToken;

        IConfig(config).setPoolParameter(address(this), bytes32("baseInterests"), 2 * 1e17);
        IConfig(config).setPoolParameter(address(this), bytes32("marketFrenzy"), 1 * 1e18);
        IConfig(config).setPoolParameter(address(this), bytes32("pledgeRate"), 6 * 1e17);
        IConfig(config).setPoolParameter(address(this), bytes32("pledgePrice"), 2 * 1e16);
        IConfig(config).setPoolParameter(address(this), bytes32("liquidationRate"), 90 * 1e16);

        lastInterestUpdate = block.number;
    }

    function updateInterests() internal
    {
        uint totalSupply = totalBorrow + remainSupply;
        uint interestPerBlock = getInterests();

        interestPerSupply = interestPerSupply.add(totalSupply == 0 ? 0 : interestPerBlock.mul(block.number - lastInterestUpdate).mul(totalBorrow).div(totalSupply));
        interestPerBorrow = interestPerBorrow.add(interestPerBlock.mul(block.number - lastInterestUpdate));
        lastInterestUpdate = block.number;
    }

    function getInterests() public view returns(uint interestPerBlock)
    {
        uint totalSupply = totalBorrow + remainSupply;
        uint baseInterests = IConfig(config).poolParams(address(this), bytes32("baseInterests"));
        uint marketFrenzy = IConfig(config).poolParams(address(this), bytes32("marketFrenzy"));

        interestPerBlock = totalSupply == 0 ? 0 : baseInterests.add(totalBorrow.mul(marketFrenzy).div(totalSupply)).div(365 * 28800);
    }

    function updateLiquidation(uint _liquidation) internal
    {
        uint totalSupply = totalBorrow + remainSupply;
        liquidationPerSupply = liquidationPerSupply.add(totalSupply == 0 ? 0 : _liquidation.mul(1e18).div(totalSupply));
    }

    function deposit(uint amountDeposit, address from) public onlyPlatform
    {
        require(amountDeposit > 0, "7UP: INVALID AMOUNT");
        TransferHelper.safeTransferFrom(supplyToken, from, address(this), amountDeposit);

        updateInterests();

        uint addLiquidation = liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].liquidationSettled);

        supplys[from].interests = supplys[from].interests.add(interestPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].interestSettled));
        supplys[from].liquidation = supplys[from].liquidation.add(addLiquidation);

        supplys[from].amountSupply = supplys[from].amountSupply.add(amountDeposit);
        remainSupply = remainSupply.add(amountDeposit);

        supplys[from].interestSettled = interestPerSupply.mul(supplys[from].amountSupply).div(1e18);
        supplys[from].liquidationSettled = liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18);
        emit Deposit(from, amountDeposit, addLiquidation);
    }

    function reinvest(address from) public onlyPlatform returns(uint reinvestAmount)
    {
        updateInterests();

        uint addLiquidation = liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].liquidationSettled);

        supplys[from].interests = supplys[from].interests.add(interestPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].interestSettled));
        supplys[from].liquidation = supplys[from].liquidation.add(addLiquidation);

        reinvestAmount = supplys[from].interests;

        uint platformShare = reinvestAmount.mul(IConfig(config).params(bytes32("platformShare"))).div(1e18);
        reinvestAmount = reinvestAmount.sub(platformShare);

        supplys[from].amountSupply = supplys[from].amountSupply.add(reinvestAmount);
        supplys[from].interests = 0;

        supplys[from].interestSettled = supplys[from].amountSupply == 0 ? 0 : interestPerSupply.mul(supplys[from].amountSupply).div(1e18);
        supplys[from].liquidationSettled = supplys[from].amountSupply == 0 ? 0 : liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18);

        distributePlatformShare(platformShare);

        emit Reinvest(from, reinvestAmount);
    }

    function getWithdrawAmount(address from) external view returns (uint withdrawAmount, uint interestAmount, uint liquidationAmount)
    {
        uint totalSupply = totalBorrow + remainSupply;
        uint _interestPerSupply = interestPerSupply.add(totalSupply == 0 ? 0 : getInterests().mul(block.number - lastInterestUpdate).mul(totalBorrow).div(totalSupply));
        uint _totalInterest = supplys[from].interests.add(_interestPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].interestSettled));
        liquidationAmount = supplys[from].liquidation.add(liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].liquidationSettled));

        uint platformShare = _totalInterest.mul(IConfig(config).params(bytes32("platformShare"))).div(1e18);
        interestAmount = _totalInterest.sub(platformShare);

        uint withdrawLiquidationSupplyAmount = totalLiquidation == 0 ? 0 : liquidationAmount.mul(totalLiquidationSupplyAmount).div(totalLiquidation);

        if(withdrawLiquidationSupplyAmount > supplys[from].amountSupply.add(interestAmount))
            withdrawAmount = 0;
        else 
            withdrawAmount = supplys[from].amountSupply.add(interestAmount).sub(withdrawLiquidationSupplyAmount);
    }

    function distributePlatformShare(uint platformShare) internal 
    {
        require(platformShare <= remainSupply, "7UP: NOT ENOUGH PLATFORM SHARE");
        if(platformShare > 0) {
            uint buybackShare = IConfig(config).params(bytes32("buybackShare"));
            uint buybackAmount = platformShare.mul(buybackShare).div(1e18);
            uint dividendAmount = platformShare.sub(buybackAmount);
            if(dividendAmount > 0) TransferHelper.safeTransfer(supplyToken, IConfig(config).share(), dividendAmount);
            if(buybackAmount > 0) TransferHelper.safeTransfer(supplyToken, IConfig(config).wallets(bytes32("team")), buybackAmount);
            remainSupply = remainSupply.sub(platformShare);
        }
    }

    function withdraw(uint amountWithdraw, address from) public onlyPlatform
    {
        require(amountWithdraw > 0, "7UP: INVALID AMOUNT");
        require(amountWithdraw <= supplys[from].amountSupply, "7UP: NOT ENOUGH BALANCE");

        updateInterests();

        uint addLiquidation = liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].liquidationSettled);

        supplys[from].interests = supplys[from].interests.add(interestPerSupply.mul(supplys[from].amountSupply).div(1e18).sub(supplys[from].interestSettled));
        supplys[from].liquidation = supplys[from].liquidation.add(addLiquidation);

        uint withdrawLiquidation = supplys[from].liquidation.mul(amountWithdraw).div(supplys[from].amountSupply);
        uint withdrawInterest = supplys[from].interests.mul(amountWithdraw).div(supplys[from].amountSupply);

        uint platformShare = withdrawInterest.mul(IConfig(config).params(bytes32("platformShare"))).div(1e18);
        uint userShare = withdrawInterest.sub(platformShare);

        distributePlatformShare(platformShare);

        uint withdrawLiquidationSupplyAmount = totalLiquidation == 0 ? 0 : withdrawLiquidation.mul(totalLiquidationSupplyAmount).div(totalLiquidation);
        uint withdrawSupplyAmount = 0;
        if(withdrawLiquidationSupplyAmount < amountWithdraw.add(userShare))
            withdrawSupplyAmount = amountWithdraw.add(userShare).sub(withdrawLiquidationSupplyAmount);
        
        require(withdrawSupplyAmount <= remainSupply, "7UP: NOT ENOUGH POOL BALANCE");
        require(withdrawLiquidation <= totalLiquidation, "7UP: NOT ENOUGH LIQUIDATION");

        remainSupply = remainSupply.sub(withdrawSupplyAmount);
        totalLiquidation = totalLiquidation.sub(withdrawLiquidation);
        totalLiquidationSupplyAmount = totalLiquidationSupplyAmount.sub(withdrawLiquidationSupplyAmount);
        totalPledge = totalPledge.sub(withdrawLiquidation);

        supplys[from].interests = supplys[from].interests.sub(withdrawInterest);
        supplys[from].liquidation = supplys[from].liquidation.sub(withdrawLiquidation);
        supplys[from].amountSupply = supplys[from].amountSupply.sub(amountWithdraw);

        supplys[from].interestSettled = supplys[from].amountSupply == 0 ? 0 : interestPerSupply.mul(supplys[from].amountSupply).div(1e18);
        supplys[from].liquidationSettled = supplys[from].amountSupply == 0 ? 0 : liquidationPerSupply.mul(supplys[from].amountSupply).div(1e18);

        if(withdrawSupplyAmount > 0) TransferHelper.safeTransfer(supplyToken, from, withdrawSupplyAmount); 
        if(withdrawLiquidation > 0) TransferHelper.safeTransfer(collateralToken, from, withdrawLiquidation);

        emit Withdraw(from, withdrawSupplyAmount, withdrawLiquidation, withdrawInterest);
    }

    function getMaximumBorrowAmount(uint amountCollateral) external view returns(uint amountBorrow)
    {
        uint pledgePrice = IConfig(config).poolParams(address(this), bytes32("pledgePrice"));
        uint pledgeRate = IConfig(config).poolParams(address(this), bytes32("pledgeRate"));

        amountBorrow = pledgePrice.mul(amountCollateral).mul(pledgeRate).div(1e36);
    }

    function borrow(uint amountCollateral, uint expectBorrow, address from) public onlyPlatform
    {
        if(amountCollateral > 0) TransferHelper.safeTransferFrom(collateralToken, from, address(this), amountCollateral);

        updateInterests();

        uint pledgePrice = IConfig(config).poolParams(address(this), bytes32("pledgePrice"));
        uint pledgeRate = IConfig(config).poolParams(address(this), bytes32("pledgeRate"));

        uint maximumBorrow = pledgePrice.mul(borrows[from].amountCollateral + amountCollateral).mul(pledgeRate).div(1e36);
        uint repayAmount = getRepayAmount(borrows[from].amountCollateral, from);

        require(repayAmount + expectBorrow <= maximumBorrow, "7UP: EXCEED MAX ALLOWED");
        require(expectBorrow <= remainSupply, "7UP: INVALID BORROW");

        totalBorrow = totalBorrow.add(expectBorrow);
        totalPledge = totalPledge.add(amountCollateral);
        remainSupply = remainSupply.sub(expectBorrow);

        if(borrows[from].index == 0)
        {
            borrowerList.push(from);
            borrows[from].index = borrowerList.length;
            numberBorrowers ++;
        }

        borrows[from].interests = borrows[from].interests.add(interestPerBorrow.mul(borrows[from].amountBorrow).div(1e18).sub(borrows[from].interestSettled));
        borrows[from].amountCollateral = borrows[from].amountCollateral.add(amountCollateral);
        borrows[from].amountBorrow = borrows[from].amountBorrow.add(expectBorrow);
        borrows[from].interestSettled = interestPerBorrow.mul(borrows[from].amountBorrow).div(1e18);

        if(expectBorrow > 0) TransferHelper.safeTransfer(supplyToken, from, expectBorrow);

        emit Borrow(from, expectBorrow, amountCollateral);
    }

    function getRepayAmount(uint amountCollateral, address from) public view returns(uint repayAmount)
    {
        uint _interestPerBorrow = interestPerBorrow.add(getInterests().mul(block.number - lastInterestUpdate));
        uint _totalInterest = borrows[from].interests.add(_interestPerBorrow.mul(borrows[from].amountBorrow).div(1e18).sub(borrows[from].interestSettled));

        uint repayInterest = borrows[from].amountCollateral == 0 ? 0 : _totalInterest.mul(amountCollateral).div(borrows[from].amountCollateral);
        repayAmount = borrows[from].amountCollateral == 0 ? 0 : borrows[from].amountBorrow.mul(amountCollateral).div(borrows[from].amountCollateral).add(repayInterest);
    }

    function repay(uint amountCollateral, address from) public onlyPlatform returns(uint repayAmount, uint repayInterest)
    {
        require(amountCollateral <= borrows[from].amountCollateral, "7UP: NOT ENOUGH COLLATERAL");
        require(amountCollateral > 0, "7UP: INVALID AMOUNT");

        updateInterests();

        borrows[from].interests = borrows[from].interests.add(interestPerBorrow.mul(borrows[from].amountBorrow).div(1e18).sub(borrows[from].interestSettled));

        repayAmount = borrows[from].amountBorrow.mul(amountCollateral).div(borrows[from].amountCollateral);
        repayInterest = borrows[from].interests.mul(amountCollateral).div(borrows[from].amountCollateral);

        totalPledge = totalPledge.sub(amountCollateral);
        totalBorrow = totalBorrow.sub(repayAmount);
        
        borrows[from].amountCollateral = borrows[from].amountCollateral.sub(amountCollateral);
        borrows[from].amountBorrow = borrows[from].amountBorrow.sub(repayAmount);
        borrows[from].interests = borrows[from].interests.sub(repayInterest);
        borrows[from].interestSettled = borrows[from].amountBorrow == 0 ? 0 : interestPerBorrow.mul(borrows[from].amountBorrow).div(1e18);

        remainSupply = remainSupply.add(repayAmount.add(repayInterest));

        TransferHelper.safeTransfer(collateralToken, from, amountCollateral);
        TransferHelper.safeTransferFrom(supplyToken, from, address(this), repayAmount + repayInterest);

        emit Repay(from, repayAmount, amountCollateral, repayInterest);
    }

    function liquidation(address _user, address from) public onlyPlatform returns(uint borrowAmount)
    {
        require(supplys[from].amountSupply > 0, "7UP: ONLY SUPPLIER");

        updateInterests();

        borrows[_user].interests = borrows[_user].interests.add(interestPerBorrow.mul(borrows[_user].amountBorrow).div(1e18).sub(borrows[_user].interestSettled));

        uint liquidationRate = IConfig(config).poolParams(address(this), bytes32("liquidationRate"));
        uint pledgePrice = IConfig(config).poolParams(address(this), bytes32("pledgePrice"));

        uint collateralValue = borrows[_user].amountCollateral.mul(pledgePrice).div(1e18);
        uint expectedRepay = borrows[_user].amountBorrow.add(borrows[_user].interests);

        require(expectedRepay >= collateralValue.mul(liquidationRate).div(1e18), '7UP: NOT LIQUIDABLE');

        updateLiquidation(borrows[_user].amountCollateral);

        totalLiquidation = totalLiquidation.add(borrows[_user].amountCollateral);
        totalLiquidationSupplyAmount = totalLiquidationSupplyAmount.add(expectedRepay);
        totalBorrow = totalBorrow.sub(borrows[_user].amountBorrow);

        borrowAmount = borrows[_user].amountBorrow;

        LiquidationStruct memory liq;
        liq.amountCollateral = borrows[_user].amountCollateral;
        liq.liquidationAmount = expectedRepay;
        liq.timestamp = block.timestamp;
        
        liquidationHistory[_user].push(liq);
        liquidationHistoryLength[_user] ++;
        
        emit Liquidation(from, _user, borrows[_user].amountBorrow, borrows[_user].amountCollateral);

        borrows[_user].amountCollateral = 0;
        borrows[_user].amountBorrow = 0;
        borrows[_user].interests = 0;
        borrows[_user].interestSettled = 0;
    }
}