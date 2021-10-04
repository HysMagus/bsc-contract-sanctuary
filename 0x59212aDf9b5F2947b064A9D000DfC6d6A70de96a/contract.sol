// File: contracts\@openzeppelin\contracts\token\ERC20\IERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2; 

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

// File: contracts\@interface\IFlaskERC20.sol
interface IFlaskERC20 is IERC20 {
    function cap() external view returns (uint256);
    function mint(address _to, uint256 _amount) external;
    function lock(address _holder, uint256 _amount) external;
    function burn(uint256 amount) external;
}

// File: contracts\FlaskBridgeData.sol
enum EmergencyFlag{
    EMERGENCY_FLAG_NONE,
    EMERGENCY_CAN_WITHDRAW,
    EMERGENCY_DID_WITHDRAW
}
 
struct BridgeTask{
    uint256 taskID;
    address senderAddr;
    address receiverAddr;
    uint256 srcChainID;
    uint256 destChainID;
    uint256 amount; 
    EmergencyFlag   emergencyFlag;
}

enum MintFlag{
    MINT_FLAG_EMPTY_TASK,
    MINT_FLAG_WAIT,
    MINT_FLAG_OK,
    MINT_FLAG_ERROR
}

struct MintTask{
    //BridgeTask Infos
    BridgeTask bridgeTask; 
    //Mint Infos 
    MintFlag mintFlag;
}

// File: contracts\@interface\IFlaskBridgeReceiver.sol
interface IFlaskBridgeReceiver{  
   function lastSyncTaskID() external view returns(uint256);
   function userLastTaskID(address user) external view returns(uint256);
   function mintTasks(uint256 _taskID) external view  returns(MintTask memory);
   function getMintTaskList(uint256 _start,uint256 _maxCount) external view  returns(MintTask[] memory);
   function runTask() external;
   function syncTask(BridgeTask memory _task) external; 
   function setEmergencyFlag(uint256[] memory _taskIDList) external;
}

// File: contracts\@openzeppelin\contracts\GSN\Context.sol
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

// File: contracts\@openzeppelin\contracts\access\Ownable.sol
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

// File: contracts\@libs\Authorizable.sol
contract Authorizable is Ownable {

    mapping(address => bool) public authorized;

    modifier onlyAuthorized() {
        require(authorized[msg.sender] || owner() == msg.sender,"!auth");
        _;
    }

    function addAuthorized(address _toAdd) onlyOwner public {
        authorized[_toAdd] = true;
    }

    function removeAuthorized(address _toRemove) onlyOwner public {
        require(_toRemove != msg.sender);
        authorized[_toRemove] = false;
    }

}

// File: contracts\@openzeppelin\contracts\math\Math.sol
/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: contracts\@openzeppelin\contracts\math\SafeMath.sol
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

// File: contracts\@openzeppelin\contracts\utils\Address.sol
/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: contracts\@openzeppelin\contracts\token\ERC20\SafeERC20.sol
/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts\@interface\IFlaskBridgeRouter.sol
interface IFlaskBridgeRouter{  
   function mintFlask(address _to,uint256 _amount) external;
}

// File: contracts\FlaskBridgeReceiver.sol
contract FlaskBridgeReceiver{ 
  using SafeERC20 for IFlaskERC20; 
  
  address public router;
  uint256 public curChainID;
  uint256 public srcChainID;
  //token
  IFlaskERC20 public flask;
  //last id
  uint256 public lastSyncTaskID;
  uint256 public lastRunIndex;
  //task from sender
  uint256[] public taskIDList;
  //user=>lastTaskID
  mapping(address=>uint256) public userLastTaskID;
  //taskID =>MintTask
  mapping(uint256=>MintTask) public mintTasks;

  event TaskMinted(MintTask task);
  event TaskSynced(MintTask task);
  event EmergencyFlagSet(MintTask task);

  constructor() public{
      router = msg.sender; 
  }

  modifier onlyRouter(){
      require(msg.sender == router,"!router");
      _;
  }
  
  function init(address _flask,uint256 _curChainID,uint256 _srcChainID) public onlyRouter{
      flask = IFlaskERC20(_flask);
      curChainID = _curChainID;
      srcChainID = _srcChainID;
  }
  
  
  function getMintTaskList(uint256 _start,uint256 _maxCount) public view  returns(MintTask[] memory){
      uint256 _total = taskIDList.length;
      uint256 _count = Math.min(_maxCount,_total - _start); 
      MintTask[] memory _tasks = new MintTask[](_count);
      for(uint256 i= 0;i < _count;i++){
          uint256 _taskID = taskIDList[_start + i];
          _tasks[i]  = mintTasks[_taskID];
      }
      return _tasks;
  }
  
  function getTaskIDListLength() public view returns(uint256){
      return taskIDList.length;
  }

 
  function setEmergencyFlag(uint256[] memory _taskIDList) public onlyRouter{
      for(uint256 i=0; i<_taskIDList.length; i++ ){
          uint256 _taskID = _taskIDList[i];
          MintTask storage _task = mintTasks[_taskID];
          EmergencyFlag _emergencyFlag =  _task.bridgeTask.emergencyFlag;
          if(_task.mintFlag == MintFlag.MINT_FLAG_WAIT && _emergencyFlag== EmergencyFlag.EMERGENCY_FLAG_NONE){
             _task.bridgeTask.emergencyFlag = EmergencyFlag.EMERGENCY_CAN_WITHDRAW;
             emit EmergencyFlagSet(_task);
          }
      }
  }

  function runTask() public onlyRouter{
      uint256 _taskCount = taskIDList.length;
      for(uint256 i=lastRunIndex; i < _taskCount; i ++ ){
           uint256 _taskID = taskIDList[i];
           MintTask storage _mintTask = mintTasks[_taskID];
           //check mint flag
           if(_mintTask.mintFlag == MintFlag.MINT_FLAG_WAIT){
               address _to = _mintTask.bridgeTask.receiverAddr;
               uint256 _amount =  _mintTask.bridgeTask.amount;
               IFlaskBridgeRouter(router).mintFlask(_to,_amount);
               _mintTask.mintFlag = MintFlag.MINT_FLAG_OK;
               //event
               emit TaskMinted(_mintTask);
           }
      }
      lastRunIndex = _taskCount;
  }
  

  function syncTask(BridgeTask memory _task) public onlyRouter{
        //check chain id
        if(_task.destChainID != curChainID) return;
        if(_task.srcChainID != srcChainID) return;
        //taskID from srcChain
        uint256 _taskID = _task.taskID;
        MintTask storage _mintTask = mintTasks[_taskID];
        //Mint_Flag_Wait
        if(_mintTask.mintFlag == MintFlag.MINT_FLAG_EMPTY_TASK){
            _mintTask.bridgeTask = _task; 
            _mintTask.mintFlag = MintFlag.MINT_FLAG_WAIT; 
            //saved taskID
            taskIDList.push(_taskID);  
            //remember the last id
            if(_taskID > lastSyncTaskID){
                lastSyncTaskID = _taskID;
            }
            //remember user last id
            address _senderAddr = _task.senderAddr;
            if(_taskID > userLastTaskID[_senderAddr]){
                userLastTaskID[_senderAddr] = _taskID;
            }  
            //event
            emit TaskSynced(_mintTask);
        }
        
  }
 
}

// File: contracts\FlaskBridgeRouter.sol

contract FlaskBridgeRouter is Authorizable{ 
  
  uint256 public curChainID;
  //flask
  address public flask;
  mapping(address=>bool) public flaskReceivers;
  
  uint256[] public srcChainIDs;
  mapping(uint256=>address) public bridgeReceivers;
  
  constructor(address _flask,uint256 _curChainID) public{
      flask = _flask;
      curChainID = _curChainID;
  }

  function setFlask(address _flask) public onlyAuthorized{
      flask = _flask;
  }
  
  function createReceiver(uint256 _srcChainID) public onlyAuthorized{
      require(bridgeReceivers[_srcChainID] == address(0),"!exist");
      FlaskBridgeReceiver _receiver = new FlaskBridgeReceiver();
      _receiver.init(flask,curChainID,_srcChainID);
      bridgeReceivers[_srcChainID] = address(_receiver);
      srcChainIDs.push(_srcChainID);
      //Receiver auth
      flaskReceivers[address(_receiver)] = true;
  }
  
  function getSourceChainCount() public view returns(uint256){
      return srcChainIDs.length;
  }

  function getSourceChains() public view returns(uint256[] memory){
      return srcChainIDs;
  }

  function mintFlask(address _to,uint256 _amount) public{
      require(flaskReceivers[msg.sender] == true,"!Receiver");
      IFlaskERC20(flask).mint(_to,_amount);
  }

  function getLastSyncTaskID(uint256 _srcChainID)  public view returns(uint256){
      address _receiver = bridgeReceivers[_srcChainID];
      return IFlaskBridgeReceiver(_receiver).lastSyncTaskID(); 
  }

  function getUserLastTask(uint256 _srcChainID,address _user) public view returns(MintTask memory){
      address _receiver = bridgeReceivers[_srcChainID];
      uint256 _lastID = IFlaskBridgeReceiver(_receiver).userLastTaskID(_user); 
      return IFlaskBridgeReceiver(_receiver).mintTasks(_lastID); 
  }

  function getMintTaskList(uint256 _srcChainID,uint256 _start,uint256 _maxCount) public view  returns(MintTask[] memory){
      address _receiver = bridgeReceivers[_srcChainID];
      return IFlaskBridgeReceiver(_receiver).getMintTaskList(_start,_maxCount); 
  }

  function runTask() public onlyAuthorized{ 
      for(uint256 i=0; i < srcChainIDs.length; i++){
          uint256 _srcChainID = srcChainIDs[i];
          address _receiver = bridgeReceivers[_srcChainID];
          IFlaskBridgeReceiver(_receiver).runTask();         
      }
  }
  
  function setEmergencyFlag(uint256 _srcChainID,uint256[] memory _taskIDList) public onlyAuthorized{
      address _receiver = bridgeReceivers[_srcChainID];
      return IFlaskBridgeReceiver(_receiver).setEmergencyFlag(_taskIDList); 
  }

  function syncTask(BridgeTask[] memory _tasks,bool _run) public onlyAuthorized{
    for(uint256 i= 0; i < _tasks.length; i ++){
        BridgeTask memory _task = _tasks[i];
        //check chainid
        if(_task.destChainID == curChainID){
            uint256 _srcChainID =_task.srcChainID;
            address _receiver = bridgeReceivers[_srcChainID];
            IFlaskBridgeReceiver(_receiver).syncTask(_task);
        } 
    }
    if(_run){
        runTask();
    }
  }
 
}