// SPDX-License-Identifier: MIT


pragma solidity ^0.6.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
}
interface IPancakeERC20 {
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

abstract contract RewardContract {
    function getBalance() external view virtual returns (uint256);
    function giveReward(address recipient, uint256 amount) external virtual returns (bool);
}

contract BLIQLPStaker is Ownable {
    using SafeMath for uint256;

    IPancakeERC20 public immutable _BliqBnbPairContract;  // BLIQ-BNB Pair contract
    RewardContract public _rewardContract;                  // reward contract

    mapping (address => StakerInfo) private _stakeMap;      // map for stakers

    address private _devWallet;                             // dev wallet address
    uint256 private _devLastClaimTimestamp;                 // dev wallet address
    address[] private _stakers;                             // staker's array
    
    uint256 private _totalStakedAmount = 0;                 // total staked amount
    uint256 private _rewardPortion = 10;                    // reward portion 10%
    uint256 private _rewardFee = 98;                        // reward fee 98%, rest for dev 2%
    
    bool private _unstakeAllow;


    struct StakerInfo {
        uint256 stakedAmount;
        uint256 lastClaimTimestamp;
        uint256 rewardAmount;
    }
    
    uint256 public lockTime = 2 days;
    uint256 public unlockCountdownTime = 0;
    
    // Events
    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);
    event Claim(address indexed staker, uint256 amount);
    
    constructor (IPancakeERC20 BliqBnbPairContract, address devWallet) public {
        _BliqBnbPairContract = BliqBnbPairContract;
        _devWallet = devWallet;
    }
    
    function stake(uint256 amount) public {
        updateUnstakeAllow();
        require(
            _BliqBnbPairContract.transferFrom(
                _msgSender(),
                address(this),
                amount
            ),
            "BLIQLPStaker: stake failed."
        );
        
        uint256 currentTimestamp = uint256(now);
        
        if(_stakers.length == 0)
            _devLastClaimTimestamp = currentTimestamp;

        if(_stakeMap[_msgSender()].stakedAmount == 0) {
            _stakers.push(_msgSender());
            _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
        } else {
            _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
            _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
        }
            
        _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.add(amount);
        _totalStakedAmount = _totalStakedAmount.add(amount);
        
        emit Staked(_msgSender(), amount);
    }
    
    function unstake(uint256 amount) public {
        updateUnstakeAllow();
        require(_unstakeAllow, "BLIQLPStaker: unstake not allowed");
        require(
            _stakeMap[_msgSender()].stakedAmount >= amount,
            "BLIQLPStaker: unstake amount exceededs the staked amount."
        );
        
        uint256 currentTimestamp = uint256(now);

        _stakeMap[_msgSender()].rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
        _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
        
        _stakeMap[_msgSender()].stakedAmount = _stakeMap[_msgSender()].stakedAmount.sub(amount);
        _totalStakedAmount = _totalStakedAmount.sub(amount);

        require(
            _BliqBnbPairContract.transfer(
                _msgSender(),
                amount
            ),
            "BLIQLPStaker: unstake failed."
        );
        
        if(_stakeMap[_msgSender()].stakedAmount == 0) {
            for(uint i=0; i<_stakers.length; i++) {
                if(_stakers[i] == _msgSender()) {
                    _stakers[i] = _stakers[_stakers.length-1];
                    _stakers.pop();
                    break;
                }
            }
        }
        emit Unstaked(_msgSender(), amount);
    }
    
    function claim() public {
        updateUnstakeAllow();
        uint256 currentTimestamp = uint256(now);
        uint256 rewardAmount = _stakeMap[_msgSender()].rewardAmount.add(calcReward(_msgSender(), currentTimestamp));
        _stakeMap[_msgSender()].lastClaimTimestamp = currentTimestamp;
        
        require(
            _rewardContract.giveReward(_msgSender(), rewardAmount),
            "BLIQLPStaker: claim failed."
        );
        
        _stakeMap[_msgSender()].rewardAmount = 0;
	    emit Claim(_msgSender(), rewardAmount);
	    
	    if(currentTimestamp.sub(_devLastClaimTimestamp) >= 86400) {
	        rewardAmount = calcDevReward(currentTimestamp);
	        _devLastClaimTimestamp = currentTimestamp;
	        
	         require(
                _rewardContract.giveReward(_devWallet, rewardAmount),
                "BLIQLPStaker: dev reward claim failed."
            );
	        emit Claim(_devWallet, rewardAmount);
	    }
    }
    
    function endStake() external {
        unstake(_stakeMap[_msgSender()].stakedAmount);
        claim();
    }
    
    function calcReward(address staker, uint256 currentTimestamp) private view returns (uint256) {
        if(_totalStakedAmount == 0)
            return 0;
        uint256 rewardPoolBalance = _rewardContract.getBalance();
        uint256 passTime = currentTimestamp.sub(_stakeMap[staker].lastClaimTimestamp);
        uint256 rewardAmountForStakers = rewardPoolBalance.mul(_rewardPortion).div(100).mul(_rewardFee).div(100);
        uint256 rewardAmount = rewardAmountForStakers.mul(passTime).div(86400).mul(_stakeMap[staker].stakedAmount).div(_totalStakedAmount);
        return rewardAmount;
    }
    
    function calcDevReward(uint256 currentTimestamp) private view returns (uint256) {
        uint256 rewardPoolBalance = _rewardContract.getBalance();
        uint256 passTime = currentTimestamp.sub(_devLastClaimTimestamp);
        uint256 rewardAmount = rewardPoolBalance.mul(_rewardPortion).div(100).mul(uint256(100).sub(_rewardFee)).div(100).mul(passTime).div(86400);
        return rewardAmount;
    }
    
    function updateUnstakeAllow() private {
        if(!_unstakeAllow && 
            unlockCountdownTime > 0 &&
            now >= unlockCountdownTime + lockTime)
            _unstakeAllow = true;
    }
    
    /**
     * Get reward contract
     */
    function getRewardContract() external view returns (address) {
        return address(_rewardContract);
    }
     
    /**
     * Get total staked amount
     */
    function getTotalStakedAmount() external view returns (uint256) {
        return _totalStakedAmount;
    }
    
    /**
     * Get reward amount of staker
     */
    function getReward(address staker) external view returns (uint256) {
        return _stakeMap[staker].rewardAmount.add(calcReward(staker, now));
    }
    
    /**
     * Get reward pool balance (BLIQ-BNB LP)
     */
    function getRewardPoolBalance() external view returns (uint256) {
        return _rewardContract.getBalance();
    }
    
    /**
     * Get last claim timestamp
     */
    function getLastClaimTimestamp(address staker) external view returns (uint256) {
        return _stakeMap[staker].lastClaimTimestamp;
    }
    
    /**
     * Get staked amount of staker
     */
    function getStakedAmount(address staker) external view returns (uint256) {
        return _stakeMap[staker].stakedAmount;
    }
    
    /**
     * Get rewards portion
     */
    function getRewardPortion() external view returns (uint256) {
        return _rewardPortion;
    }
    
    /**
     * Get staker count
     */
    function getStakerCount() external view returns (uint256) {
        return _stakers.length;
    }
    
     /**
     * Get rewards fee
     */
    function getRewardFee() external view returns (uint256) {
        return _rewardFee;
    }
    
    /**
     * Get unstake allow flag
     */
    function getUnstakeAllow() external view returns (bool) {
        return _unstakeAllow;
    }
    
    /**
     * Get staked rank
     */
    function getStakedRank(address staker) external view returns (uint256) {
        uint256 rank = 1;
        uint256 senderStakedAmount = _stakeMap[staker].stakedAmount;
        
        for(uint i=0; i<_stakers.length; i++) {
            if(_stakers[i] != staker && senderStakedAmount < _stakeMap[_stakers[i]].stakedAmount)
                rank = rank.add(1);
        }
        return rank;
    }
    
    /**
     * Set reward contract address
     */
    function setRewardContract(RewardContract rewardContract) external onlyOwner returns (bool) {
        require(address(rewardContract) != address(0), 'BLIQLPStaker: reward contract address should not be zero address.');

        _rewardContract = rewardContract;
        return true;
    }

    /**
     * Set daily rewards portion in store balance. 
     * ex: 10 => 10%
     */
    function setRewardPortion(uint256 rewardPortion) external onlyOwner returns (bool) {
        require(rewardPortion >= 10 && rewardPortion <= 100, 'BLIQLPStaker: reward portion should be in 10 ~ 100.');

        _rewardPortion = rewardPortion;
        return true;
    }
    
    /**
     * Set rewards portion for stakers in rewards amount. 
     * ex: 98 => 98% (2% for dev)
     */
    function setRewardFee(uint256 rewardFee) external onlyOwner returns (bool) {
        require(rewardFee >= 96 && rewardFee <= 100, 'BLIQLPStaker: reward fee should be in 96 ~ 100.' );

        _rewardFee = rewardFee;
        return true;
    }
    
    /**
     * Set unlockCountdownTime. 
     */
    function setLive() external onlyOwner returns (bool) {
        unlockCountdownTime = now;
        return true;
    }
    
    /**
     * Set _unstakeAllow. 
     */
    function setUnstakeAllow() external onlyOwner returns (bool) {
        _unstakeAllow = true;
        return true;
    }
}