/**
 *Submitted for verification at BscScan.com on 2021-03-03
*/

pragma solidity ^ 0.6 .2;
interface IERC20 {
	function totalSupply() external view returns(uint256);

	function balanceOf(address account) external view returns(uint256);

	function transfer(address recipient, uint256 amount) external returns(bool);

	function allowance(address owner, address spender) external view returns(uint256);

	function approve(address spender, uint256 amount) external returns(bool);

	function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}
pragma solidity ^ 0.6 .2;
library SafeMath {
	function add(uint256 a, uint256 b) internal pure returns(uint256) {
		uint256 c = a + b;
		require(c >= a, "SafeMath: addition overflow");
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
		return sub(a, b, "SafeMath: subtraction overflow");
	}

	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
		require(b <= a, errorMessage);
		uint256 c = a - b;
		return c;
	}

	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
		// benefit is lost if 'b' is also tested.
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		require(c / a == b, "SafeMath: multiplication overflow");
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns(uint256) {
		return div(a, b, "SafeMath: division by zero");
	}

	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
		require(b > 0, errorMessage);
		uint256 c = a / b;
		return c;
	}

	function mod(uint256 a, uint256 b) internal pure returns(uint256) {
		return mod(a, b, "SafeMath: modulo by zero");
	}

	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
		require(b != 0, errorMessage);
		return a % b;
	}
}
pragma solidity ^ 0.6 .2;
library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

	function sendValue(address payable recipient, uint256 amount) internal {
		require(address(this).balance >= amount, "Address: insufficient balance");
		(bool success, ) = recipient.call {
			value: amount
		}("");
		require(success, "Address: unable to send value, recipient may have reverted");
	}

	function functionCall(address target, bytes memory data) internal returns(bytes memory) {
		return functionCall(target, data, "Address: low-level call failed");
	}

	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns(bytes memory) {
		return _functionCallWithValue(target, data, 0, errorMessage);
	}

	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns(bytes memory) {
		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
	}

	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns(bytes memory) {
		require(address(this).balance >= value, "Address: insufficient balance for call");
		return _functionCallWithValue(target, data, value, errorMessage);
	}

	function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns(bytes memory) {
		require(isContract(target), "Address: call to non-contract");
		(bool success, bytes memory returndata) = target.call {
			value: weiValue
		}(data);
		 if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {

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
pragma solidity ^ 0.6 .2;
library SafeERC20 {
	using SafeMath
	for uint256;
	using Address
	for address;

	function safeTransfer(IERC20 token, address to, uint256 value) internal {
		_callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
	}

	function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
		_callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
	}

	function safeApprove(IERC20 token, address spender, uint256 value) internal {
		// or when resetting it to zero. To increase and decrease it, use
		// solhint-disable-next-line max-line-length
		require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
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

	function _callOptionalReturn(IERC20 token, bytes memory data) private {
		// we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
		bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
		if (returndata.length > 0) { // Return data is optional
			require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
		}
	}
}
pragma solidity ^ 0.6 .2;
abstract contract Context {
	function _msgSender() internal view virtual returns(address payable) {
		return msg.sender;
	}

	function _msgData() internal view virtual returns(bytes memory) {
		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
		return msg.data;
	}
}
pragma solidity ^ 0.6 .2;
contract Ownable is Context {
	address private _owner;
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
	constructor() internal {
		address msgSender = _msgSender();
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
	}

	function owner() public view returns(address) {
		return _owner;
	}
	modifier onlyOwner() {
		require(_owner == _msgSender(), "Ownable: caller is not the owner");
		_;
	}

	function renounceOwnership() public virtual onlyOwner {
		emit OwnershipTransferred(_owner, address(0));
		_owner = address(0);
	}

	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		emit OwnershipTransferred(_owner, newOwner);
		_owner = newOwner;
	}
}
pragma solidity ^ 0.6 .2;
contract ERC20 is Context, IERC20 {
	using SafeMath
	for uint256;
	using Address
	for address;
	mapping(address => uint256) private _balances;
	mapping(address => mapping(address => uint256)) private _allowances;
	uint256 private _totalSupply;
	string private _name;
	string private _symbol;
	uint8 private _decimals;
	constructor(string memory name, string memory symbol) public {
		_name = name;
		_symbol = symbol;
		_decimals = 8;
		_totalSupply = 1200000 * 10 ** 8;
		_balances[_msgSender()] = _totalSupply;
		emit Transfer(address(0), _msgSender(), _totalSupply);
	}

	function name() public view returns(string memory) {
		return _name;
	}

	function symbol() public view returns(string memory) {
		return _symbol;
	}

	function decimals() public view returns(uint8) {
		return _decimals;
	}

	function totalSupply() public view override returns(uint256) {
		return _totalSupply.sub(_balances[address(0)]);
	}

	function balanceOf(address account) public view override returns(uint256) {
		return _balances[account];
	}

	function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
		_transfer(_msgSender(), recipient, amount);
		return true;
	}

	function allowance(address owner, address spender) public view virtual override returns(uint256) {
		return _allowances[owner][spender];
	}

	function approve(address spender, uint256 amount) public virtual override returns(bool) {
		_approve(_msgSender(), spender, amount);
		return true;
	}

	function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns(bool) {
		_transfer(sender, recipient, amount);
		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
		return true;
	}

	function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
		return true;
	}

	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
		return true;
	}

	function _transfer(address sender, address recipient, uint256 amount) internal virtual {
		require(sender != address(0), "ERC20: transfer from the zero address");
		require(_balances[sender] >= amount, "ERC20: balance sender not enough");
		_beforeTokenTransfer(sender, recipient, amount);
		_balances[sender] = _balances[sender].sub(amount);
		_balances[recipient] = _balances[recipient].add(amount);
		emit Transfer(sender, recipient, amount);
	}

	function _mint(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: mint to the zero address");
		_beforeTokenTransfer(address(0), account, amount);
		_totalSupply = _totalSupply.add(amount);
		_balances[account] = _balances[account].add(amount);
		emit Transfer(address(0), account, amount);
	}

	function _burn(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: burn from the zero address");
		require(_balances[account] >= amount, "ERC20: balance sender not enough");
		_beforeTokenTransfer(account, address(0), amount);
		_balances[account] = _balances[account].sub(amount);
		_totalSupply = _totalSupply.sub(amount);
		emit Transfer(account, address(0), amount);
	}

	function _approve(address owner, address spender, uint256 amount) internal virtual {
		require(owner != address(0), "ERC20: approve from the zero address");
		require(spender != address(0), "ERC20: approve to the zero address");
		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}

	function _setupDecimals(uint8 decimals_) internal {
		_decimals = decimals_;
	}

	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}
pragma solidity 0.6 .2;
contract KindCow is ERC20("Kindcow Finance", "KIND"), Ownable {
	function mint(address _to, uint256 _amount) public onlyOwner {
		_mint(_to, _amount);
	}

	function safe32(uint n, string memory errorMessage) internal pure returns(uint32) {
		require(n < 2 ** 32, errorMessage);
		return uint32(n);
	}

	function getChainId() internal pure returns(uint) {
		uint256 chainId;
		assembly {
			chainId := chainid()
		}
		return chainId;
	}
}
pragma solidity 0.6 .2;
contract Neatherd is Ownable {
	using SafeMath
	for uint256;
	using SafeERC20
	for IERC20;
	struct UserInfo {
		uint256 amount; 
		uint256 rewardDebt;  
	}
	struct PoolInfo {
		IERC20 lpToken;     // Address of LP token contract.
		uint256 allocPoint; // How many allocation points assigned to this pool. KINDs to distribute per block.
		uint256 lastRewardBlock; // Last block number that KINDs distribution occurs.
		uint256 accKindPerShare; // Accumulated KINDs per share, times 1e30. See below.
		uint256 totalLP; //Total LP at Neatherd
	}
	IERC20 MC;
	KindCow public kind;
	address public devaddr;
	address public donation;
	 
	uint256 public kindPerBlock;
	PoolInfo[] public poolInfo;
	mapping(uint256 => mapping(address => UserInfo)) public userInfo;
	mapping(string => bool) private listPool;
	uint256 public totalAllocPoint = 0;
	uint256 public startBlock;
	uint256 public total_Vote_Reward;
	uint256 public total_Donation;
	uint256 public count_to_send_donation = 0;
	
	uint256 private jackpot = 0;
	uint256 private winner  = 0;
	event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
	event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
	event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
	constructor(KindCow _kind, address _devaddr , address donate) public {
		kind = _kind;
		donation = donate;
		devaddr = _devaddr;
		kindPerBlock = 100000000;
	 
		startBlock = 0;
		MC = _kind;
	}

	function poolLength() external view returns(uint256) {
		return poolInfo.length;
	}
	// fee list is 1000 KIND and Minimum vote 10.000 to start Receive reward
	function add(IERC20 _lpToken) public {
		uint256 _allocPoint = 1000;
		uint256 _allocPointToBurn = 1000 * 100000000;
		uint256 kindBal = kind.balanceOf(msg.sender);
		require(kindBal >= _allocPointToBurn, "Not Enough KIND to Listing");
		uint256 notyetadd = 0;
		for (uint256 a = 0; a < poolInfo.length; a++) {
			if (poolInfo[a].lpToken == _lpToken) notyetadd = 1;
		}
		if (notyetadd == 0) {
			MC.safeTransferFrom(address(msg.sender), address(this), _allocPointToBurn);
			safeKindTransfer(address(0), _allocPointToBurn);
			totalAllocPoint = totalAllocPoint.add(_allocPoint);
			poolInfo.push(PoolInfo({
				lpToken: _lpToken,
				allocPoint: _allocPoint,
				lastRewardBlock: 0,
				accKindPerShare: 0,
				totalLP: 0
			}));
		}
	}

 

	function checkPid(IERC20 _lpToken) public view returns(uint256) {
		for (uint256 a = 0; a < poolInfo.length; a++) {
			if (poolInfo[a].lpToken == _lpToken) return a;
		}
		return 1000000;
	}

	function voteUp(uint256 _pid, uint256 _allocPoint) public {
		require(_allocPoint > 0, "voteUp : Minimum 1 KIND");
		uint256 kindBal = kind.balanceOf(msg.sender);
		uint256 kindToBurn = _allocPoint.mul(100000000);
		require(kindBal > kindToBurn, "voteUp : Your KIND Balance Not Enough");
		if (kindBal > kindToBurn) {
			MC.safeTransferFrom(address(msg.sender), address(this), kindToBurn);
			safeKindTransfer(address(0), kindToBurn.div(2));
			total_Vote_Reward = total_Vote_Reward.add(kindToBurn.div(4));
			total_Donation    = total_Donation.add(kindToBurn.div(4));
			_sendReward();
			totalAllocPoint = totalAllocPoint.add(_allocPoint);
			poolInfo[_pid].allocPoint = poolInfo[_pid].allocPoint.add(_allocPoint);
		}
	}

	function voteDown(uint256 _pid, uint256 _allocPoint) public {
		require(_allocPoint > 0, "voteUp : Minimum 1 KIND");
		uint256 kindBal = kind.balanceOf(msg.sender);
		uint256 kindToBurn = _allocPoint.mul(100000000);
		require(kindBal > kindToBurn, "voteDown : Your KIND Balance Not Enough");
		uint256 currentAllocPoint = poolInfo[_pid].allocPoint;
		require(currentAllocPoint >= _allocPoint, "voteDown : _allocPoint too High");
		if (kindBal > kindToBurn) {
			MC.safeTransferFrom(address(msg.sender), address(this), kindToBurn);
			safeKindTransfer(address(0), kindToBurn.div(2));
			total_Vote_Reward = total_Vote_Reward.add(kindToBurn.div(4));
			total_Donation    = total_Donation.add(kindToBurn.div(4));
			_sendReward();
			totalAllocPoint = totalAllocPoint.sub(_allocPoint);
			poolInfo[_pid].allocPoint = poolInfo[_pid].allocPoint.sub(_allocPoint);
			
		}
	}

	function _sendReward() public {
		uint256 _rRandom = total_Vote_Reward.div(10);
		uint256 _randomNumber = _random();
		uint256 _reward = 1;
		if (_randomNumber < winner)   _reward =  _randomNumber.mul(_rRandom.div(20));
		if (_randomNumber < jackpot)  _reward =  total_Vote_Reward;
		 
	 
		if (_reward > 0) {
			total_Vote_Reward = total_Vote_Reward.sub(_reward);
			safeKindTransfer(msg.sender, _reward);
		}
		 count_to_send_donation=count_to_send_donation.add(1);
		 if(count_to_send_donation>20){
		 safeKindTransfer(donation, total_Donation);
		 total_Donation = 0;
		 count_to_send_donation=0;
	     }
		    
	}

	function _random() private view returns(uint32) {
		uint8 r = uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.difficulty))) % 251);
		return r;
	}

	function voteReward() private view returns(uint256) {
		return total_Vote_Reward;
	}

	 
    	
		
	 
	function pendingKind(uint256 _pid, address _user) external view returns(uint256) {
		PoolInfo storage pool = poolInfo[_pid];
		UserInfo storage user = userInfo[_pid][_user];
		uint256 accKindPerShare = pool.accKindPerShare;
		uint256 lpSupply = pool.totalLP; 
		if (pool.allocPoint < 10000) return 0;
		if (block.number > pool.lastRewardBlock && lpSupply != 0) {
			uint256 multiplier =   block.number.sub(pool.lastRewardBlock);
		    uint256 kindReward = multiplier.mul(kindPerBlock).div(totalAllocPoint).mul(pool.allocPoint);
			accKindPerShare    = accKindPerShare.add(kindReward.mul(1e30).div(lpSupply));
		}
		
	    
	   return user.amount.mul(accKindPerShare).div(1e30).sub(user.rewardDebt);
		
	} 
	

	function updatePool(uint256 _pid) public {
		PoolInfo storage pool = poolInfo[_pid];
		if (block.number <= pool.lastRewardBlock) {
			return;
		}
		uint256 lpSupply = pool.totalLP; 
		if (lpSupply == 0) {
			pool.lastRewardBlock = block.number;
			return;
		}
		uint256 multiplier = block.number.sub(pool.lastRewardBlock);
		uint256 kindReward = multiplier.mul(kindPerBlock).div(totalAllocPoint).mul(pool.allocPoint);
		if (pool.allocPoint >= 10000) {
			kind.mint(devaddr, kindReward.div(10));
			kind.mint(address(this), kindReward);
		}
		pool.accKindPerShare = pool.accKindPerShare.add(kindReward.mul(1e30).div(lpSupply));
		pool.lastRewardBlock = block.number;
	}
	
	

 
	function deposit(uint256 _pid, uint256 _amount) public {
		PoolInfo storage pool = poolInfo[_pid];
		UserInfo storage user = userInfo[_pid][msg.sender];
		updatePool(_pid);
		if (user.amount > 0) {
			uint256 pending = user.amount.mul(pool.accKindPerShare).div(1e30).sub(user.rewardDebt);
			safeKindTransfer(msg.sender, pending);
		}
		if (_amount > 0) {
			pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
			user.amount = user.amount.add(_amount);
			pool.totalLP = pool.totalLP.add(_amount);
		}
		user.rewardDebt = user.amount.mul(pool.accKindPerShare).div(1e30);
		emit Deposit(msg.sender, _pid, _amount);
	}

	function withdraw(uint256 _pid, uint256 _amount) public {
		PoolInfo storage pool = poolInfo[_pid];
		UserInfo storage user = userInfo[_pid][msg.sender];
		require(user.amount >= _amount, "withdraw: not good");
		require(_amount > 0, "withdraw: Must > 0");
		updatePool(_pid);
		uint256 pending = user.amount.mul(pool.accKindPerShare).div(1e30).sub(user.rewardDebt);
		safeKindTransfer(msg.sender, pending);
		user.amount = user.amount.sub(_amount);
		user.rewardDebt = user.amount.mul(pool.accKindPerShare).div(1e30);
		pool.lpToken.safeTransfer(address(msg.sender), _amount);
		if (_amount > 0) pool.totalLP = pool.totalLP.sub(_amount);
		emit Withdraw(msg.sender, _pid, _amount);
	}

	function balanceLP(uint256 _pid, address _user) external view returns(uint256) {
		UserInfo storage user = userInfo[_pid][_user];
		return user.amount;
	}

	function massUpdatePools() public {
		uint256 length = poolInfo.length;
		for (uint256 pid = 0; pid < length; ++pid) {
			updatePool(pid);
		}
	}
	
	function emergencyWithdraw(uint256 _pid) public {
		PoolInfo storage pool = poolInfo[_pid];
		UserInfo storage user = userInfo[_pid][msg.sender];
		pool.lpToken.safeTransfer(address(msg.sender), user.amount);
		emit EmergencyWithdraw(msg.sender, _pid, user.amount);
		user.amount = 0;
		user.rewardDebt = 0;
	}
	//transfer from mc
	function safeKindTransfer(address _to, uint256 _amount) internal {
		uint256 kindBal = kind.balanceOf(address(this));
		if (_amount > kindBal) {
			kind.transfer(_to, kindBal);
		} else {
			kind.transfer(_to, _amount);
		}
	}

	function dev_addr(address _devaddr) onlyOwner public {
	  devaddr = _devaddr;
	}
	 function donation_address(address d) onlyOwner public {
	  donation = d;
	}
    function vote_reward(uint256 win,uint256 jak) onlyOwner public {
	  winner = win;
	  jackpot= jak;
	}
	
	function sendnow_donation() onlyOwner public {
	     safeKindTransfer(donation, total_Donation);
		 total_Donation = 0;
		 count_to_send_donation=0;
		 
        }
}