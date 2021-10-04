// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.12;
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }
    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;
    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }
    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            'SafeBEP20: approve from non-zero to non-zero allowance'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            'SafeBEP20: decreased allowance below zero'
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');
        }
    }
}
contract Context {
    constructor() internal {}
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
    function _msgData() internal view returns (bytes memory) {
        this; 
        return msg.data;
    }
}
contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
contract BEP20 is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }
    function getOwner() external override view returns (address) {
        return owner();
    }
    function name() public override view returns (string memory) {
        return _name;
    }
    function decimals() public override view returns (uint8) {
        return _decimals;
    }
    function symbol() public override view returns (string memory) {
        return _symbol;
    }
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
        );
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
        );
        return true;
    }
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
        return true;
    }
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), 'BEP20: transfer from the zero address');
        require(recipient != address(0), 'BEP20: transfer to the zero address');
        _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: burn from the zero address');
        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), 'BEP20: approve from the zero address');
        require(spender != address(0), 'BEP20: approve to the zero address');
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance')
        );
    }
}
contract BerrySwapToken is BEP20('BerrySwapToken', 'BERRY') {
    function mintTo(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }
    mapping(address => address) internal _delegates;
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }
    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
    mapping(address => uint32) public numCheckpoints;
    bytes32 public constant DOMAIN_TYPEHASH = keccak256(
        'EIP712Domain(string name,uint256 chainId,address verifyingContract)'
    );
    bytes32 public constant DELEGATION_TYPEHASH = keccak256(
        'Delegation(address delegatee,uint256 nonce,uint256 expiry)'
    );
    mapping(address => uint256) public nonces;
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
    function delegates(address delegator) external view returns (address) {
        return _delegates[delegator];
    }
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 domainSeparator = keccak256(
            abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), getChainId(), address(this))
        );
        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), 'BERRY::delegateBySig: invalid signature');
        require(nonce == nonces[signatory]++, 'BERRY::delegateBySig: invalid nonce');
        require(now <= expiry, 'BERRY::delegateBySig: signature expired');
        return _delegate(signatory, delegatee);
    }
    function getCurrentVotes(address account) external view returns (uint256) {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }
    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
        require(blockNumber < block.number, 'BERRY::getPriorVotes: not yet determined');
        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }
        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; 
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }
    function _delegate(address delegator, address delegatee) internal {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator); 
        _delegates[delegator] = delegatee;
        emit DelegateChanged(delegator, currentDelegate, delegatee);
        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }
    function _moveDelegates(
        address srcRep,
        address dstRep,
        uint256 amount
    ) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.sub(amount);
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }
            if (dstRep != address(0)) {
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.add(amount);
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }
    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    ) internal {
        uint32 blockNumber = safe32(block.number, 'BERRY::_writeCheckpoint: block number exceeds 32 bits');
        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }
        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }
    function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }
    function getChainId() internal pure returns (uint256) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return chainId;
    }
}
contract BerrySwapMaster is Ownable {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    struct UserInfo {
        uint256 amount; 
        uint256 rewardDebt; 
    }
    struct PoolInfo {
        uint256 allocPoint; 
        uint256 lastRewardBlock; 
        uint256 accBerryPerShare; 
        bool exists; 
    }
    uint256 public berryStartBlock;
    uint256 public totalAllocPoint = 0;
    uint256 public startBlock;
    uint256 public bonusEndBlock;
    uint256 public bonusBeforeBulkBlockSize;
    uint256 public bonusEndBulkBlockSize;
    uint256 public berryBonusEndBlock;
    uint256 public maxRewardBlockNumber;
    uint256 public bonusBeforeCommonDifference;
    uint256 public bonusEndCommonDifference;
    uint256 public accBerryPerShareMultiple = 1E9;
    uint256 public distributeRewardBlock;
    BerrySwapToken public berry;
    address public devAddr;
    address[] public poolAddresses;
    mapping(address => PoolInfo) public poolInfoMap;
    mapping(address => mapping(address => UserInfo)) public poolUserInfoMap;
    event Deposit(address indexed user, address indexed poolAddress, uint256 amount);
    event Withdraw(address indexed user, address indexed poolAddress, uint256 amount);
    event EmergencyWithdraw(address indexed user, address indexed poolAddress, uint256 amount);
    constructor(
        BerrySwapToken _berry,
        address _devAddr,
        uint256 _berryStartBlock,
        uint256 _startBlock,
        uint256 _bonusEndBlock,
        uint256 _bonusBeforeBulkBlockSize,
        uint256 _bonusBeforeCommonDifference,
        uint256 _bonusEndCommonDifference,
        uint256 _distributeRewardBlock
    ) public {
        berry = _berry;
        devAddr = _devAddr;
        berryStartBlock = _berryStartBlock;
        startBlock = _startBlock;
        bonusEndBlock = _bonusEndBlock;
        bonusBeforeBulkBlockSize = _bonusBeforeBulkBlockSize;
        bonusBeforeCommonDifference = _bonusBeforeCommonDifference;
        bonusEndCommonDifference = _bonusEndCommonDifference;
        distributeRewardBlock = _distributeRewardBlock;
        bonusEndBulkBlockSize = bonusEndBlock.sub(startBlock);
        berryBonusEndBlock = berryStartBlock
        .sub(bonusEndBlock.sub(startBlock).div(bonusBeforeBulkBlockSize).sub(1).mul(bonusBeforeCommonDifference))
        .mul(bonusBeforeBulkBlockSize)
        .mul(bonusEndBulkBlockSize.div(bonusBeforeBulkBlockSize))
        .div(bonusEndBulkBlockSize);
        maxRewardBlockNumber = startBlock.add(
            bonusEndBulkBlockSize.mul(berryBonusEndBlock.div(bonusEndCommonDifference).add(1))
        );
    }
    function poolLength() external view returns (uint256) {
        return poolAddresses.length;
    }
    function add(
        uint256 _allocPoint,
        address _pair,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        PoolInfo storage pool = poolInfoMap[_pair];
        require(!pool.exists, 'pool already exists');
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        pool.allocPoint = _allocPoint;
        pool.lastRewardBlock = lastRewardBlock;
        pool.accBerryPerShare = 0;
        pool.exists = true;
        poolAddresses.push(_pair);
    }
    function set(
        address _pair,
        uint256 _allocPoint,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        PoolInfo storage pool = poolInfoMap[_pair];
        require(pool.exists, 'pool not exists');
        totalAllocPoint = totalAllocPoint.sub(pool.allocPoint).add(_allocPoint);
        pool.allocPoint = _allocPoint;
    }
    function existsPool(address _pair) external view returns (bool) {
        return poolInfoMap[_pair].exists;
    }
    function getTotalRewardInfoInSameCommonDifference(
        uint256 _from,
        uint256 _to,
        uint256 _berryInitBlock,
        uint256 _bulkBlockSize,
        uint256 _commonDifference
    ) public view returns (uint256 totalReward) {
        if (_to <= startBlock || maxRewardBlockNumber <= _from) {
            return 0;
        }
        if (_from < startBlock) {
            _from = startBlock;
        }
        if (maxRewardBlockNumber < _to) {
            _to = maxRewardBlockNumber;
        }
        uint256 currentBulkNumber = _to.sub(startBlock).div(_bulkBlockSize).add(
            _to.sub(startBlock).mod(_bulkBlockSize) > 0 ? 1 : 0
        );
        if (currentBulkNumber < 1) {
            currentBulkNumber = 1;
        }
        uint256 fromBulkNumber = _from.sub(startBlock).div(_bulkBlockSize).add(
            _from.sub(startBlock).mod(_bulkBlockSize) > 0 ? 1 : 0
        );
        if (fromBulkNumber < 1) {
            fromBulkNumber = 1;
        }
        if (fromBulkNumber == currentBulkNumber) {
            return _to.sub(_from).mul(_berryInitBlock.sub(currentBulkNumber.sub(1).mul(_commonDifference)));
        }
        uint256 lastRewardBulkLastBlock = startBlock.add(_bulkBlockSize.mul(fromBulkNumber));
        uint256 currentPreviousBulkLastBlock = startBlock.add(_bulkBlockSize.mul(currentBulkNumber.sub(1)));
        {
            uint256 tempFrom = _from;
            uint256 tempTo = _to;
            totalReward = tempTo
            .sub(tempFrom > currentPreviousBulkLastBlock ? tempFrom : currentPreviousBulkLastBlock)
            .mul(_berryInitBlock.sub(currentBulkNumber.sub(1).mul(_commonDifference)));
            if (lastRewardBulkLastBlock > tempFrom && lastRewardBulkLastBlock <= tempTo) {
                totalReward = totalReward.add(
                    lastRewardBulkLastBlock.sub(tempFrom).mul(
                        _berryInitBlock.sub(fromBulkNumber > 0 ? fromBulkNumber.sub(1).mul(_commonDifference) : 0)
                    )
                );
            }
        }
        {
            uint256 tempBerryInitBlock = _berryInitBlock;
            uint256 tempBulkBlockSize = _bulkBlockSize;
            uint256 tempCommonDifference = _commonDifference;
            if (currentPreviousBulkLastBlock > lastRewardBulkLastBlock) {
                uint256 tempCurrentPreviousBulkLastBlock = currentPreviousBulkLastBlock;
                uint256 N = tempCurrentPreviousBulkLastBlock.sub(lastRewardBulkLastBlock).div(tempBulkBlockSize);
                if (N > 1) {
                    uint256 a1 = tempBulkBlockSize.mul(
                        tempBerryInitBlock.sub(
                            lastRewardBulkLastBlock.sub(startBlock).mul(tempCommonDifference).div(tempBulkBlockSize)
                        )
                    );
                    uint256 aN = tempBulkBlockSize.mul(
                        tempBerryInitBlock.sub(
                            tempCurrentPreviousBulkLastBlock.sub(startBlock).div(tempBulkBlockSize).sub(1).mul(
                                tempCommonDifference
                            )
                        )
                    );
                    totalReward = totalReward.add(N.mul(a1.add(aN)).div(2));
                } else {
                    totalReward = totalReward.add(
                        tempBulkBlockSize.mul(tempBerryInitBlock.sub(currentBulkNumber.sub(2).mul(tempCommonDifference)))
                    );
                }
            }
        }
    }
    function getTotalRewardInfo(uint256 _from, uint256 _to) public view returns (uint256 totalReward) {
        if (_to <= bonusEndBlock) {
            totalReward = getTotalRewardInfoInSameCommonDifference(
                _from,
                _to,
                berryStartBlock,
                bonusBeforeBulkBlockSize,
                bonusBeforeCommonDifference
            );
        } else if (_from >= bonusEndBlock) {
            totalReward = getTotalRewardInfoInSameCommonDifference(
                _from,
                _to,
                berryBonusEndBlock,
                bonusEndBulkBlockSize,
                bonusEndCommonDifference
            );
        } else {
            totalReward = getTotalRewardInfoInSameCommonDifference(
                _from,
                bonusEndBlock,
                berryStartBlock,
                bonusBeforeBulkBlockSize,
                bonusBeforeCommonDifference
            )
            .add(
                getTotalRewardInfoInSameCommonDifference(
                    bonusEndBlock,
                    _to,
                    berryBonusEndBlock,
                    bonusEndBulkBlockSize,
                    bonusEndCommonDifference
                )
            );
        }
    }
    function pendingBerry(address _pair, address _user) external view returns (uint256) {
        PoolInfo memory pool = poolInfoMap[_pair];
        if (!pool.exists) {
            return 0;
        }
        UserInfo storage userInfo = poolUserInfoMap[_pair][_user];
        uint256 accBerryPerShare = pool.accBerryPerShare;
        uint256 lpSupply = IBEP20(_pair).balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0 && pool.lastRewardBlock < maxRewardBlockNumber) {
            uint256 totalReward = getTotalRewardInfo(pool.lastRewardBlock, block.number);
            uint256 berryReward = totalReward.mul(pool.allocPoint).div(totalAllocPoint);
            accBerryPerShare = accBerryPerShare.add(berryReward.mul(accBerryPerShareMultiple).div(lpSupply));
        }
        return userInfo.amount.mul(accBerryPerShare).div(accBerryPerShareMultiple).sub(userInfo.rewardDebt);
    }
    function massUpdatePools() public {
        uint256 length = poolAddresses.length;
        for (uint256 i = 0; i < length; ++i) {
            updatePool(poolAddresses[i]);
        }
    }
    function updatePool(address _pair) public {
        PoolInfo storage pool = poolInfoMap[_pair];
        if (!pool.exists || block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = IBEP20(_pair).balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        if (pool.lastRewardBlock >= maxRewardBlockNumber) {
            return;
        }
        uint256 totalReward = getTotalRewardInfo(pool.lastRewardBlock, block.number);
        uint256 berryReward = totalReward.mul(pool.allocPoint).div(totalAllocPoint);
        berry.mintTo(devAddr, berryReward.div(100));
        berry.mintTo(address(this), berryReward);
        pool.accBerryPerShare = pool.accBerryPerShare.add(berryReward.mul(accBerryPerShareMultiple).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }
    function updateDistributeRewardBlock(uint256 _distributeRewardBlock) public onlyOwner {
        distributeRewardBlock = _distributeRewardBlock;
    }
    function deposit(address _pair, uint256 _amount) public {
        PoolInfo storage pool = poolInfoMap[_pair];
        UserInfo storage userInfo = poolUserInfoMap[_pair][msg.sender];
        updatePool(_pair);
        if (userInfo.amount > 0) {
            uint256 pending = userInfo.amount.mul(pool.accBerryPerShare).div(accBerryPerShareMultiple).sub(
                userInfo.rewardDebt
            );
            if (pending > 0) {
                safeBerryTransfer(msg.sender, pending);
            }
        }
        IBEP20(_pair).safeTransferFrom(address(msg.sender), address(this), _amount);
        userInfo.amount = userInfo.amount.add(_amount);
        userInfo.rewardDebt = userInfo.amount.mul(pool.accBerryPerShare).div(accBerryPerShareMultiple);
        emit Deposit(msg.sender, _pair, _amount);
    }
    function withdraw(address _pair, uint256 _amount) public {
        PoolInfo storage pool = poolInfoMap[_pair];
        UserInfo storage userInfo = poolUserInfoMap[_pair][msg.sender];
        require(userInfo.amount >= _amount, 'withdraw: not good');
        require(block.number > distributeRewardBlock, 'not ready for withdraw');
        updatePool(_pair);
        uint256 pending = userInfo.amount.mul(pool.accBerryPerShare).div(accBerryPerShareMultiple).sub(
            userInfo.rewardDebt
        );
        if (pending > 0) {
            safeBerryTransfer(msg.sender, pending);
        }
        if (_amount > 0) {
            userInfo.amount = userInfo.amount.sub(_amount);
            IBEP20(_pair).safeTransfer(address(msg.sender), _amount);
        }
        userInfo.rewardDebt = userInfo.amount.mul(pool.accBerryPerShare).div(accBerryPerShareMultiple);
        emit Withdraw(msg.sender, _pair, _amount);
    }
    function emergencyWithdraw(address _pair) public {
        UserInfo storage userInfo = poolUserInfoMap[_pair][msg.sender];
        IBEP20(_pair).safeTransfer(address(msg.sender), userInfo.amount);
        emit EmergencyWithdraw(msg.sender, _pair, userInfo.amount);
        userInfo.amount = 0;
        userInfo.rewardDebt = 0;
    }
    function transferOwnerBerrySwap(address newOwner) public onlyOwner {
        berry.transferOwnership(newOwner);
    }
    function recoverBerrySwap(address tokenAddress) public onlyOwner {
        IBEP20 tokenContract = IBEP20(tokenAddress);
        uint256 tokenBal = tokenContract.balanceOf(address(this));
        require(
            tokenContract.transfer(msg.sender, tokenBal),
            "BERRY::Master::recoverBerrySwap::TRANSFER_FAILED"
        );
    }
    function safeBerryTransfer(address _to, uint256 _amount) internal {
        uint256 berryBal = berry.balanceOf(address(this));
        if (_amount > berryBal) {
            berry.transfer(_to, berryBal);
        } else {
            berry.transfer(_to, _amount);
        }
    }
    function dev(address _devAddr) public {
        require(msg.sender == devAddr, 'dev: wut?');
        devAddr = _devAddr;
    }
}