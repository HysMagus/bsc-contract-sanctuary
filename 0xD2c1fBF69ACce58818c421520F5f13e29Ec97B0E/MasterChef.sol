// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./SafeMath.sol";
import "./IBEP20.sol";
import "./SafeBEP20.sol";
import "./Ownable.sol";

import "./DieselToken.sol";

contract MasterChef is Ownable {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    struct UserInfo {
        uint256 amount;         
        uint256 rewardDebt;     
    }
    struct PoolInfo {
        IBEP20 lpToken;           
        uint256 allocPoint;       
        uint256 lastRewardBlock;  
        uint256 accDislPerShare;   
        uint16 depositFeeBP;      
    }
    DieselToken public disl;
    address public devaddr;
    uint256 public dislPerBlock;
    uint256 public constant BONUS_MULTIPLIER = 1;
    address public feeAddress;

    PoolInfo[] public poolInfo;
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    uint256 public totalAllocPoint = 0;
    uint256 public startBlock;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);

    constructor(
        DieselToken _disl,
        address _devaddr,
        address _feeAddress,
        uint256 _dislPerBlock,
        uint256 _startBlock
    ) public {
        disl = _disl;
        devaddr = _devaddr;
        feeAddress = _feeAddress;
        dislPerBlock = _dislPerBlock;
        startBlock = _startBlock;
    }
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
    function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
        require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: _allocPoint,
            lastRewardBlock: lastRewardBlock,
            accDislPerShare: 0,
            depositFeeBP: _depositFeeBP
        }));
    }
    function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
        require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
        poolInfo[_pid].depositFeeBP = _depositFeeBP;
    }
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        return _to.sub(_from).mul(BONUS_MULTIPLIER);
    }
    function pendingDisl(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accDislPerShare = pool.accDislPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 dislReward = multiplier.mul(dislPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accDislPerShare = accDislPerShare.add(dislReward.mul(1e12).div(lpSupply));
        }
        return user.amount.mul(accDislPerShare).div(1e12).sub(user.rewardDebt);
    }
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0 || pool.allocPoint == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 dislReward = multiplier.mul(dislPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        disl.mint(devaddr, dislReward.div(10));
        disl.mint(address(this), dislReward);
        pool.accDislPerShare = pool.accDislPerShare.add(dislReward.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accDislPerShare).div(1e12).sub(user.rewardDebt);
            if(pending > 0) {
                safeDislTransfer(msg.sender, pending);
            }
        }
        if(_amount > 0) {
            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            if(pool.depositFeeBP > 0){
                uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
                pool.lpToken.safeTransfer(feeAddress, depositFee);
                user.amount = user.amount.add(_amount).sub(depositFee);
            }else{
                user.amount = user.amount.add(_amount);
            }
        }
        user.rewardDebt = user.amount.mul(pool.accDislPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accDislPerShare).div(1e12).sub(user.rewardDebt);
        if(pending > 0) {
            safeDislTransfer(msg.sender, pending);
        }
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.safeTransfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount.mul(pool.accDislPerShare).div(1e12);
        emit Withdraw(msg.sender, _pid, _amount);
    }
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pool.lpToken.safeTransfer(address(msg.sender), amount);
        emit EmergencyWithdraw(msg.sender, _pid, amount);
    }
    function safeDislTransfer(address _to, uint256 _amount) internal {
        uint256 dislBal = disl.balanceOf(address(this));
        if (_amount > dislBal) {
            disl.transfer(_to, dislBal);
        } else {
            disl.transfer(_to, _amount);
        }
    }
    function dev(address _devaddr) public {
        require(msg.sender == devaddr, "dev: wut?");
        devaddr = _devaddr;
    }
    function setFeeAddress(address _feeAddress) public{
        require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
        feeAddress = _feeAddress;
    }
    function updateEmissionRate(uint256 _dislPerBlock) public onlyOwner {
        massUpdatePools();
        dislPerBlock = _dislPerBlock;
    }
}