pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

contract DfProfits {
    address public controller;

    constructor(address _controller) public {
        controller = _controller;
    }

    function cast(address payable _to, bytes memory _data) public payable {
        require(msg.sender == controller);

        (bool success, bytes memory returndata) = address(_to).call.value(
            msg.value
        )(_data);
        require(success, "low-level call failed");
    }
}

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

//    function min(uint x, uint y) internal pure returns (uint z) {
//        return x <= y ? x : y;
//    }
//    function max(uint x, uint y) internal pure returns (uint z) {
//        return x >= y ? x : y;
//    }
//    function imin(int x, int y) internal pure returns (int z) {
//        return x <= y ? x : y;
//    }
//    function imax(int x, int y) internal pure returns (int z) {
//        return x >= y ? x : y;
//    }

    uint constant WAD = 10 ** 18;
//    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y, uint base) internal pure returns (uint z) {
        z = add(mul(x, y), base / 2) / base;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
//    function rmul(uint x, uint y) internal pure returns (uint z) {
//        z = add(mul(x, y), RAY / 2) / RAY;
//    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
//    function rdiv(uint x, uint y) internal pure returns (uint z) {
//        z = add(mul(x, RAY), y / 2) / y;
//    }

}

// **INTERFACES**

interface IDfDepositToken {

    function mint(address account, uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;

    function balanceOf(address account) external view returns(uint256);
    function balanceOfAt(address account, uint256 snapshotId) external view returns(uint256);
    function totalSupplyAt(uint256 snapshotId) external view returns(uint256);
    function totalSupply() external view returns(uint256);
    function snapshot() external returns(uint256);
    function snapshot(uint256 price) external returns(uint256);
    function prices(uint256 snapshotId) view external returns(uint256);

    function transferFrom(address from, address to, uint value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

interface IToken {
    function decimals() external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function approve(address spender, uint value) external;
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function deposit() external payable;
    function mint(address, uint256) external;
    function withdraw(uint amount) external;
    function totalSupply() view external returns (uint256);
    function burnFrom(address account, uint256 amount) external;
}

// import "../openzeppelin/upgrades/contracts/Initializable.sol";

contract OwnableUpgradable is Initializable {
    address payable public owner;
    address payable internal newOwnerCandidate;

    function checkAuth() private {
        require(msg.sender == owner, "Permission denied");
    }
    modifier onlyOwner {
        checkAuth();
        _;
    }

    // ** INITIALIZERS – Constructors for Upgradable contracts **

    function initialize() public initializer {
        owner = msg.sender;
    }

    function initialize(address payable newOwner) public initializer {
        owner = newOwner;
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }

    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate);
        owner = newOwnerCandidate;
    }

    uint256[50] private ______gap;
}

// import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
// import "./SafeMath.sol";

// import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";

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
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// import "@openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol";

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {

    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IToken token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IToken token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IToken token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IToken token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IToken token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IToken token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library UniversalERC20 {

    using SafeMath for uint256;
    using SafeERC20 for IToken;

    IToken private constant ZERO_ADDRESS = IToken(0x0000000000000000000000000000000000000000);
    IToken private constant ETH_ADDRESS = IToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    function universalTransfer(IToken token, address to, uint256 amount) internal {
        universalTransfer(token, to, amount, false);
    }

    function universalTransfer(IToken token, address to, uint256 amount, bool mayFail) internal returns(bool) {
        if (amount == 0) {
            return true;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            if (mayFail) {
                return address(uint160(to)).send(amount);
            } else {
                address(uint160(to)).transfer(amount);
                return true;
            }
        } else {
            token.safeTransfer(to, amount);
            return true;
        }
    }

    function universalApprove(IToken token, address to, uint256 amount) internal {
        if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
            token.safeApprove(to, amount);
        }
    }

    function universalTransferFrom(IToken token, address from, address to, uint256 amount) internal {
        if (amount == 0) {
            return;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            require(from == msg.sender && msg.value >= amount, "msg.value is zero");
            if (to != address(this)) {
                address(uint160(to)).transfer(amount);
            }
            if (msg.value > amount) {
                msg.sender.transfer(uint256(msg.value).sub(amount));
            }
        } else {
            token.safeTransferFrom(from, to, amount);
        }
    }

    function universalBalanceOf(IToken token, address who) internal view returns (uint256) {
        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }
}

contract FundsMgrUpgradable is Initializable, OwnableUpgradable {
    using UniversalERC20 for IToken;

    // Initializer – Constructor for Upgradable contracts
    function initialize() public initializer {
        OwnableUpgradable.initialize();  // Initialize Parent Contract
    }

    function initialize(address payable newOwner) public initializer {
        OwnableUpgradable.initialize(newOwner);  // Initialize Parent Contract
    }

    function withdraw(address token, uint256 amount) public onlyOwner {
        if (token == address(0x0)) {
            owner.transfer(amount);
        } else {
            IToken(token).universalTransfer(owner, amount);
        }
    }

    function withdrawAll(address[] memory tokens) public onlyOwner {
        for(uint256 i = 0; i < tokens.length;i++) {
            withdraw(tokens[i], IToken(tokens[i]).universalBalanceOf(address(this)));
        }
    }

    uint256[50] private ______gap;
}

contract DfPool is Initializable, FundsMgrUpgradable, DSMath {
    IERC20 public dai = IERC20(0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3);    // BSC dai

    IERC20 public dDaiWrapper;      // dDai from bridge
    IDfDepositToken public dDai;    // dDai for user

    DfProfits public dfProfits;     // contract that contains only profit funds

    struct ProfitData {
        uint64 blockNumber;
        uint64 daiProfit; // div 1e12 (6 dec)
    }
    ProfitData[] public profits;

    mapping(address => uint64) public lastProfitDistIndex;

    event Profit(address indexed user, uint64 index, uint64 daiProfit);
    event CreateDfProfit(address indexed dfProfit);

    // ** INITIALIZER – Constructor for Upgradable contracts **

    function initialize() public initializer {
        FundsMgrUpgradable.initialize();    // Initialize Parent Contract
    }

    // ** PUBLIC VIEW functions **

    function calcUserProfit(address userAddress, uint256 max) public view returns(
        uint256 totalDaiProfit, uint64 index
    ) {
        (totalDaiProfit, index) = getUserProfitFromCustomIndex(userAddress, lastProfitDistIndex[userAddress], max);
    }

    function getUserProfitFromCustomIndex(address userAddress, uint64 fromIndex, uint256 max) public view returns(
        uint256 totalDaiProfit, uint64 index
    ) {
        if (profits.length < max) max = profits.length;

        for(index = fromIndex; index < max; index++) {
            ProfitData memory p = profits[index];
            (uint256 balanceAtBlock, uint256 totalSupplyAt) = userShare(userAddress, index + 1);

            uint256 profitDai = wdiv(wmul(mul(uint256(p.daiProfit), 1e12), balanceAtBlock), totalSupplyAt);
            totalDaiProfit = add(totalDaiProfit, profitDai);
        }
    }

    function userShare(address userAddress, uint256 snapshotId) view public returns (uint256 totalLiquidity, uint256 totalSupplay) {
        if (snapshotId == uint256(-1)) snapshotId = profits.length;

        totalLiquidity = dDai.balanceOfAt(userAddress, snapshotId);
        totalSupplay = dDai.totalSupplyAt(snapshotId);
    }

    // ** PUBLIC functions **

    // 1 dai == 1 dDai dDai
    function deposit(uint256 _amount) public {
        require(add(dDai.totalSupply(), _amount) <= dDaiWrapper.balanceOf(address(this)), "DfPool: not enough dDai");
        dai.transferFrom(msg.sender, address(this), _amount);
        dDai.mint(msg.sender, _amount);
    }

    // 1 dDai == 1 dai dDai
    function withdraw(uint256 _amount) public {
        dDai.burnFrom(msg.sender, _amount);
        dai.transfer(msg.sender, _amount);
    }

    function userClaimProfit(uint64 max) public {
        require(msg.sender == tx.origin);

        (uint256 totalDaiProfit, uint64 index) = calcUserProfit(msg.sender, max);

        sendRewardToUser(index, totalDaiProfit, false);

        emit Profit(msg.sender, index, uint64(totalDaiProfit));
    }

    function burnDDai(uint256 _amount) public {
        dDai.burnFrom(msg.sender, _amount);
        dDaiWrapper.transfer(msg.sender, _amount);
    }

    function transferToEth(uint256 _amount) public {
        transferToEth(_amount, msg.sender);
    }

    function transferToEth(uint256 _amount, address ethAddress) public {
        dDai.burnFrom(msg.sender, _amount);
        // if - approve to bridge
        // burn of bridge
    }

    // ** ONLY_OWNER functions **
    function addProfit(uint _amount) public onlyOwner {
        ProfitData memory p;
        p.blockNumber = uint64(block.number);

        if (dfProfits == DfProfits(0x0)) {
            dfProfits = new DfProfits(address(this));
            emit CreateDfProfit(address(dfProfits));
        }

        uint256 balance = dai.balanceOf(address(dfProfits));
        dai.transferFrom(msg.sender, address(dfProfits), _amount);
        uint256 reward = sub(dai.balanceOf(address(dfProfits)), balance);
        p.daiProfit = uint64(reward / 1e12); // reduce decimals to 1e6

        // UPD state
        profits.push(p);
        dDai.snapshot();
    }

    function setDaiAddress(IERC20 _newAddress) public onlyOwner {
        dai = _newAddress;
    }

    function setDDaiAddress(IDfDepositToken _newAddress) public onlyOwner {
        dDai = _newAddress;
    }

    function setDDaiWrapperAddress(IERC20 _newAddress) public onlyOwner {
        dDaiWrapper = _newAddress;
    }

    // ** INTERNAL functions **

    function sendRewardToUser(uint64 _index, uint256 _totalDaiProfit, bool _isReinvest) internal {
        lastProfitDistIndex[msg.sender] = _index;

        if (_totalDaiProfit > 0) {
            dfProfits.cast(address(uint160(address(dai))), abi.encodeWithSelector(IERC20(dai).transfer.selector, msg.sender, _totalDaiProfit));
            if (_isReinvest) {
                deposit(_totalDaiProfit);
            }
        }
    }
}