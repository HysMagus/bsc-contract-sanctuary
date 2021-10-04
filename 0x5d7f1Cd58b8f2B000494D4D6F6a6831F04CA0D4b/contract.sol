// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0

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

// File contracts/LnAdmin.sol

pragma solidity ^0.6.12;

contract LnAdmin {
    address public admin;
    address public candidate;

    constructor(address _admin) public {
        require(_admin != address(0), "admin address cannot be 0");
        admin = _admin;
        emit AdminChanged(address(0), _admin);
    }

    function setCandidate(address _candidate) external onlyAdmin {
        address old = candidate;
        candidate = _candidate;
        emit CandidateChanged(old, candidate);
    }

    function becomeAdmin() external {
        require(msg.sender == candidate, "Only candidate can become admin");
        address old = admin;
        admin = candidate;
        emit AdminChanged(old, admin);
    }

    modifier onlyAdmin {
        require((msg.sender == admin), "Only the contract admin can perform this action");
        _;
    }

    event CandidateChanged(address oldCandidate, address newCandidate);
    event AdminChanged(address oldAdmin, address newAdmin);
}

// File contracts/interfaces/ILnAddressStorage.sol

pragma solidity ^0.6.12;

interface ILnAddressStorage {
    function updateAll(bytes32[] calldata names, address[] calldata destinations) external;

    function update(bytes32 name, address dest) external;

    function getAddress(bytes32 name) external view returns (address);

    function getAddressWithRequire(bytes32 name, string calldata reason) external view returns (address);
}

// File contracts/LnAddressCache.sol

pragma solidity ^0.6.12;

abstract contract LnAddressCache {
    function updateAddressCache(ILnAddressStorage _addressStorage) external virtual;

    event CachedAddressUpdated(bytes32 name, address addr);
}

contract testAddressCache is LnAddressCache, LnAdmin {
    address public addr1;
    address public addr2;

    constructor(address _admin) public LnAdmin(_admin) {}

    function updateAddressCache(ILnAddressStorage _addressStorage) public override onlyAdmin {
        addr1 = _addressStorage.getAddressWithRequire("a", "");
        addr2 = _addressStorage.getAddressWithRequire("b", "");
        emit CachedAddressUpdated("a", addr1);
        emit CachedAddressUpdated("b", addr2);
    }
}

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0

pragma solidity >=0.6.0 <0.8.0;

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

// File contracts/interfaces/ILnAsset.sol

pragma solidity ^0.6.12;

interface ILnAsset is IERC20 {
    function keyName() external view returns (bytes32);

    function mint(address account, uint256 amount) external;

    function burn(address account, uint amount) external;
}

// File contracts/interfaces/ILnPrices.sol

pragma solidity >=0.4.24;

// a facade for prices fetch from oracles
interface ILnPrices {
    // get price for a currency
    function getPrice(bytes32 currencyName) external view returns (uint);

    // get price and updated time for a currency
    function getPriceAndUpdatedTime(bytes32 currencyName) external view returns (uint price, uint time);

    // is the price is stale
    function isStale(bytes32 currencyName) external view returns (bool);

    // the defined stale time
    function stalePeriod() external view returns (uint);

    // exchange amount of source currenty for some dest currency, also get source and dest curreny price
    function exchange(
        bytes32 sourceName,
        uint sourceAmount,
        bytes32 destName
    ) external view returns (uint);

    // exchange amount of source currenty for some dest currency
    function exchangeAndPrices(
        bytes32 sourceName,
        uint sourceAmount,
        bytes32 destName
    )
        external
        view
        returns (
            uint value,
            uint sourcePrice,
            uint destPrice
        );

    // price names
    function LUSD() external view returns (bytes32);

    function LINA() external view returns (bytes32);
}

// File contracts/interfaces/ILnConfig.sol

pragma solidity ^0.6.12;

interface ILnConfig {
    function BUILD_RATIO() external view returns (bytes32);

    function getUint(bytes32 key) external view returns (uint);
}

// File @openzeppelin/contracts-upgradeable/proxy/Initializable.sol@v3.3.0

// solhint-disable-next-line compiler-version
pragma solidity >=0.4.24 <0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            cs := extcodesize(self)
        }
        return cs == 0;
    }
}

// File contracts/upgradeable/LnAdminUpgradeable.sol

pragma solidity >=0.6.12 <0.8.0;

/**
 * @title LnAdminUpgradeable
 *
 * @dev This is an upgradeable version of `LnAdmin` by replacing the constructor with
 * an initializer and reserving storage slots.
 */
contract LnAdminUpgradeable is Initializable {
    event CandidateChanged(address oldCandidate, address newCandidate);
    event AdminChanged(address oldAdmin, address newAdmin);

    address public admin;
    address public candidate;

    function __LnAdminUpgradeable_init(address _admin) public initializer {
        require(_admin != address(0), "LnAdminUpgradeable: zero address");
        admin = _admin;
        emit AdminChanged(address(0), _admin);
    }

    function setCandidate(address _candidate) external onlyAdmin {
        address old = candidate;
        candidate = _candidate;
        emit CandidateChanged(old, candidate);
    }

    function becomeAdmin() external {
        require(msg.sender == candidate, "LnAdminUpgradeable: only candidate can become admin");
        address old = admin;
        admin = candidate;
        emit AdminChanged(old, admin);
    }

    modifier onlyAdmin {
        require((msg.sender == admin), "LnAdminUpgradeable: only the contract admin can perform this action");
        _;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[48] private __gap;
}

// File contracts/SafeDecimalMath.sol

pragma solidity ^0.6.12;

library SafeDecimalMath {
    using SafeMath for uint;

    uint8 public constant decimals = 18;
    uint8 public constant highPrecisionDecimals = 27;

    uint public constant UNIT = 10**uint(decimals);

    uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
    uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);

    function unit() external pure returns (uint) {
        return UNIT;
    }

    function preciseUnit() external pure returns (uint) {
        return PRECISE_UNIT;
    }

    function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
        return x.mul(y) / UNIT;
    }

    function _multiplyDecimalRound(
        uint x,
        uint y,
        uint precisionUnit
    ) private pure returns (uint) {
        uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);

        if (quotientTimesTen % 10 >= 5) {
            quotientTimesTen += 10;
        }

        return quotientTimesTen / 10;
    }

    function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
        return _multiplyDecimalRound(x, y, PRECISE_UNIT);
    }

    function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
        return _multiplyDecimalRound(x, y, UNIT);
    }

    function divideDecimal(uint x, uint y) internal pure returns (uint) {
        return x.mul(UNIT).div(y);
    }

    function _divideDecimalRound(
        uint x,
        uint y,
        uint precisionUnit
    ) private pure returns (uint) {
        uint resultTimesTen = x.mul(precisionUnit * 10).div(y);

        if (resultTimesTen % 10 >= 5) {
            resultTimesTen += 10;
        }

        return resultTimesTen / 10;
    }

    function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
        return _divideDecimalRound(x, y, UNIT);
    }

    function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
        return _divideDecimalRound(x, y, PRECISE_UNIT);
    }

    function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
        return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
    }

    function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
        uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);

        if (quotientTimesTen % 10 >= 5) {
            quotientTimesTen += 10;
        }

        return quotientTimesTen / 10;
    }
}

// File contracts/LnExchangeSystem.sol

pragma solidity ^0.6.12;

contract LnExchangeSystem is LnAdminUpgradeable, LnAddressCache {
    using SafeMath for uint;
    using SafeDecimalMath for uint;

    event ExchangeAsset(
        address fromAddr,
        bytes32 sourceKey,
        uint sourceAmount,
        address destAddr,
        bytes32 destKey,
        uint destRecived,
        uint feeForPool,
        uint feeForFoundation
    );
    event FoundationFeeHolderChanged(address oldHolder, address newHolder);

    ILnAddressStorage mAssets;
    ILnPrices mPrices;
    ILnConfig mConfig;
    address mRewardSys;
    address foundationFeeHolder;

    bytes32 private constant ASSETS_KEY = "LnAssetSystem";
    bytes32 private constant PRICES_KEY = "LnPrices";
    bytes32 private constant CONFIG_KEY = "LnConfig";
    bytes32 private constant REWARD_SYS_KEY = "LnRewardSystem";
    bytes32 private constant CONFIG_FEE_SPLIT = "FoundationFeeSplit";

    function __LnExchangeSystem_init(address _admin) public initializer {
        __LnAdminUpgradeable_init(_admin);
    }

    function updateAddressCache(ILnAddressStorage _addressStorage) public override onlyAdmin {
        mAssets = ILnAddressStorage(_addressStorage.getAddressWithRequire(ASSETS_KEY, ""));
        mPrices = ILnPrices(_addressStorage.getAddressWithRequire(PRICES_KEY, ""));
        mConfig = ILnConfig(_addressStorage.getAddressWithRequire(CONFIG_KEY, ""));
        mRewardSys = _addressStorage.getAddressWithRequire(REWARD_SYS_KEY, "");

        emit CachedAddressUpdated(ASSETS_KEY, address(mAssets));
        emit CachedAddressUpdated(PRICES_KEY, address(mPrices));
        emit CachedAddressUpdated(CONFIG_KEY, address(mConfig));
        emit CachedAddressUpdated(REWARD_SYS_KEY, address(mRewardSys));
    }

    function setFoundationFeeHolder(address _foundationFeeHolder) public onlyAdmin {
        require(_foundationFeeHolder != address(0), "LnExchangeSystem: zero address");
        require(_foundationFeeHolder != foundationFeeHolder, "LnExchangeSystem: foundation fee holder not changed");

        address oldHolder = foundationFeeHolder;
        foundationFeeHolder = _foundationFeeHolder;

        emit FoundationFeeHolderChanged(oldHolder, foundationFeeHolder);
    }

    function exchange(
        bytes32 sourceKey,
        uint sourceAmount,
        address destAddr,
        bytes32 destKey
    ) external {
        return _exchange(msg.sender, sourceKey, sourceAmount, destAddr, destKey);
    }

    function _exchange(
        address fromAddr,
        bytes32 sourceKey,
        uint sourceAmount,
        address destAddr,
        bytes32 destKey
    ) internal {
        ILnAsset source = ILnAsset(mAssets.getAddressWithRequire(sourceKey, ""));
        ILnAsset dest = ILnAsset(mAssets.getAddressWithRequire(destKey, ""));
        uint destAmount = mPrices.exchange(sourceKey, sourceAmount, destKey);
        require(destAmount > 0, "dest amount must > 0");

        uint feeRate = mConfig.getUint(destKey);
        uint destRecived = destAmount.multiplyDecimal(SafeDecimalMath.unit().sub(feeRate));
        uint fee = destAmount.sub(destRecived);

        // Fee going into the pool, to be adjusted based on foundation split
        uint feeForPoolInUsd = mPrices.exchange(destKey, fee, mPrices.LUSD());

        // Split the fee between pool and foundation when both holder and ratio are set
        uint256 foundationSplit;
        if (foundationFeeHolder == address(0)) {
            foundationSplit = 0;
        } else {
            uint256 splitRatio = mConfig.getUint(CONFIG_FEE_SPLIT);

            if (splitRatio == 0) {
                foundationSplit = 0;
            } else {
                foundationSplit = feeForPoolInUsd.multiplyDecimal(splitRatio);
                feeForPoolInUsd = feeForPoolInUsd.sub(foundationSplit);
            }
        }

        ILnAsset lusd =
            ILnAsset(mAssets.getAddressWithRequire(mPrices.LUSD(), "LnExchangeSystem: failed to get lUSD address"));

        if (feeForPoolInUsd > 0) lusd.mint(mRewardSys, feeForPoolInUsd);
        if (foundationSplit > 0) lusd.mint(foundationFeeHolder, foundationSplit);

        // 先不考虑预言机套利的问题
        source.burn(fromAddr, sourceAmount);

        dest.mint(destAddr, destRecived);

        emit ExchangeAsset(
            fromAddr,
            sourceKey,
            sourceAmount,
            destAddr,
            destKey,
            destRecived,
            feeForPoolInUsd,
            foundationSplit
        );
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[45] private __gap;
}