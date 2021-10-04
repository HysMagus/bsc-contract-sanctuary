// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;


import "./SafeMath.sol";
import "./IBEP20.sol";
import "./SafeBEP20.sol";
import "./Ownable.sol";

import "./SpiderToken.sol";

// MasterChef is the master of Spider. He can make Spider and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once Spider is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract MasterChef is Ownable {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;         // How many LP tokens the user has provided.
        uint256 rewardDebt;     // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of SPIDERs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accSpiderPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accSpiderPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Info of each pool.
    struct PoolInfo {
        IBEP20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. SPIDER to distribute per block.
        uint256 lastRewardBlock;  // Last block number that SPIDER distribution occurs.
        uint256 accSpiderPerShare;   // Accumulated SPIDER per share, times 1e12. See below.
        uint16 depositFeeBP;      // Deposit fee in basis points
    }
    
    // Info of each phase bonus
    struct BonusInfo {
        uint256 numBlocksBonus;
        uint256 multiplier;
    }

    // The SPIDER TOKEN!
    SpiderToken public spider;
    // Dev address.
    address public devaddr;
    address private devaddrPreventive;
    // Block number when bonus SPIDER period ends.
    uint256 public bonusEndBlock;
    // SPIDER tokens created per block.
    uint256 public spiderPerBlock;
    // Deposit Fee address
    address public feeAddress;

    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each phase bonus.
    BonusInfo[] public bonusInfo;
    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    // Total allocation points. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when SPIDER mining starts.
    uint256 public startBlock;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);

    constructor(
        SpiderToken _spider,
        address _devaddr,
        address _devaddrPreventive,
        address _feeAddress,
        uint256 _spiderPerBlock,
        uint256 _startBlock
    ) public {
        spider = _spider;
        devaddr = _devaddr;
        devaddrPreventive = _devaddrPreventive;
        feeAddress = _feeAddress;
        spiderPerBlock = _spiderPerBlock;
        startBlock = _startBlock;
        bonusEndBlock= _startBlock;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
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
            accSpiderPerShare: 0,
            depositFeeBP: _depositFeeBP
        }));
    }

    // Update the given pool's SPIDER allocation point and deposit fee. Can only be called by the owner.
    function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
        require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
        if (prevAllocPoint != _allocPoint) {
            poolInfo[_pid].allocPoint = _allocPoint;
            totalAllocPoint = totalAllocPoint.sub(prevAllocPoint).add(_allocPoint);
        }
        uint256 prevDepositFeeBP = poolInfo[_pid].depositFeeBP;
        if(prevDepositFeeBP != _depositFeeBP) {
            poolInfo[_pid].depositFeeBP = _depositFeeBP;
        }
    }
    
    // Add phase bonus
    function addPhaseBonus(uint256 _numBlocksBonus, uint256 _multiplier) public onlyOwner {
        bonusInfo.push(BonusInfo({
            numBlocksBonus: _numBlocksBonus,
            multiplier: _multiplier
        }));
        bonusEndBlock += _numBlocksBonus;
    }
    
    // Update phase bonus
    function updatePhaseBonus(uint256 _index, uint256 _numBlocksBonus, uint256 _multiplier) public onlyOwner {
        uint256 prevNumBlocks = bonusInfo[_index].numBlocksBonus;
        if(prevNumBlocks != _numBlocksBonus) {
            bonusInfo[_index].numBlocksBonus = _numBlocksBonus;
            bonusEndBlock = bonusEndBlock.sub(prevNumBlocks).add(_numBlocksBonus);
        }
        
        uint256 prevMultiplier = bonusInfo[_index].multiplier;
        if(prevMultiplier != _multiplier) {
            bonusInfo[_index].multiplier = _multiplier;
        }
       
    }
    
     // Delete phase bonus
    function delPhaseBonus(uint256 _index) public onlyOwner {
        require(bonusInfo.length > 0 && _index < bonusInfo.length, "length bonusInfo must greater than 0");
        require(_index < bonusInfo.length, "_index must be less than length bonusInfo");
            uint256 numBlocksBonus = bonusInfo[_index].numBlocksBonus;
            bonusEndBlock -= numBlocksBonus;
            delete bonusInfo[_index];
    }
    
    // Get length of BonusInfo
    function getLengthBonusInfo() public view returns(uint256) {
        return  bonusInfo.length;
    }
    
    
    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if (bonusInfo.length > 0 ) {
            if(_from > bonusEndBlock) {
                return _to.sub(_from);
            } else if(_to <= bonusEndBlock) {
                uint256 totalBlocks = 0;
                uint256 endBlockDynamic = startBlock; 
                uint256 fromDynamic = _from; 
                for (uint i=0; i< bonusInfo.length; i++) {
                    endBlockDynamic += bonusInfo[i].numBlocksBonus;
                    if(fromDynamic < endBlockDynamic && _to >= endBlockDynamic) {
                        totalBlocks += endBlockDynamic.sub(fromDynamic).mul(bonusInfo[i].multiplier);
                        fromDynamic = endBlockDynamic;
                    } else if(fromDynamic < endBlockDynamic && _to < endBlockDynamic) {
                        totalBlocks += _to.sub(fromDynamic).mul(bonusInfo[i].multiplier);
                        return totalBlocks;
                    }
                }
                return totalBlocks;
            } else {
                uint256 totalBlocks = _to.sub(bonusEndBlock);
                uint256 endBlockDynamic = startBlock; 
                uint256 fromDynamic = _from; 
                for (uint i=0; i< bonusInfo.length; i++) {
                    endBlockDynamic += bonusInfo[i].numBlocksBonus;
                    if(fromDynamic < endBlockDynamic) {
                        totalBlocks += endBlockDynamic.sub(fromDynamic).mul(bonusInfo[i].multiplier);
                        fromDynamic = endBlockDynamic;
                    }
                }
                return totalBlocks;
            }
        } else {
            return _to.sub(_from);
        }
    }

    // View function to see pending SPIDERs on frontend.
    function pendingSpider(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accSpiderPerShare = pool.accSpiderPerShare;
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
            uint256 spiderReward = multiplier.mul(spiderPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
            accSpiderPerShare = accSpiderPerShare.add(spiderReward.mul(1e12).div(lpSupply));
        }
        return user.amount.mul(accSpiderPerShare).div(1e12).sub(user.rewardDebt);
    }

    // Update reward variables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
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
        uint256 spiderReward = multiplier.mul(spiderPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        spider.mint(devaddr, spiderReward.div(5));
        spider.mint(devaddrPreventive, spiderReward.div(5));
        spider.mint(address(this), spiderReward);
        pool.accSpiderPerShare = pool.accSpiderPerShare.add(spiderReward.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to MasterChef for SPIDER allocation.
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accSpiderPerShare).div(1e12).sub(user.rewardDebt);
            if(pending > 0) {
                safeSpiderTransfer(msg.sender, pending);
            }
        }
        if(_amount > 0) {
            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            if(pool.depositFeeBP > 0){
                uint256 depositFee1 = _amount.mul(pool.depositFeeBP).div(2).div(10000);
                uint256 depositFee2 = _amount.mul(pool.depositFeeBP).div(2).div(10000);
                pool.lpToken.safeTransfer(feeAddress, depositFee1);
                pool.lpToken.safeTransfer(devaddrPreventive, depositFee2);
                user.amount = user.amount.add(_amount).sub(depositFee1+depositFee2);
            }else{
                user.amount = user.amount.add(_amount);
            }
        }
        user.rewardDebt = user.amount.mul(pool.accSpiderPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accSpiderPerShare).div(1e12).sub(user.rewardDebt);
        if(pending > 0) {
            safeSpiderTransfer(msg.sender, pending);
        }
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.safeTransfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount.mul(pool.accSpiderPerShare).div(1e12);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        pool.lpToken.safeTransfer(address(msg.sender), amount);
        emit EmergencyWithdraw(msg.sender, _pid, amount);
    }

    // Safe spider transfer function, just in case if rounding error causes pool to not have enough SPIDERs.
    function safeSpiderTransfer(address _to, uint256 _amount) internal {
        uint256 spiderBal = spider.balanceOf(address(this));
        if (_amount > spiderBal) {
            spider.transfer(_to, spiderBal);
        } else {
            spider.transfer(_to, _amount);
        }
    }

    // Update dev address by the previous dev.
    function dev(address _devaddr) public {
        require(msg.sender == devaddr, "dev: wut?");
        devaddr = _devaddr;
    }

    function setFeeAddress(address _feeAddress) public{
        require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
        feeAddress = _feeAddress;
    }

    //Pancake has to add hidden dummy pools inorder to alter the emission, here we make it simple and transparent to all.
    function updateEmissionRate(uint256 _spiderPerBlock) public onlyOwner {
        spiderPerBlock = _spiderPerBlock;
    }
    
    //Update startBlock
    function updateStartBlock(uint256 _blockNumber) public onlyOwner {
        bonusEndBlock = bonusEndBlock.sub(startBlock).add(_blockNumber);
        startBlock = _blockNumber;
    }
}
