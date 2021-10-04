// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "SafeERC20.sol";
import "ERC20.sol";

contract OxbScbFarm {

    struct stakeTracker {
        uint256 lastBlockChecked;
        uint256 rewards;
        uint256 oxbStaked;
    }

    address private owner;
    address private scbPoolAddress;
    address private scbFundAddress;
    address private scbAddress;
    address private oxbPoolAddress;
    address private oxbAddress;
    IERC20 private scbToken;
    IERC20 private oxbToken;
    uint256 private rewardsVar;
    uint256 private multiplier;

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 private _totalOxbStaked;
    mapping(address => stakeTracker) private _stakedBalances;

    constructor() public {
        owner = msg.sender;
        rewardsVar = 1000000;
        multiplier = 100;
    }

    event OxbStaked(address indexed user, uint256 amount, uint256 totalScbStaked);
    event OxbWithdrawn(address indexed user, uint256 amount);
    event Rewards(address indexed user, uint256 reward);

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier updateStakingReward(address account) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            if (_stakedBalances[account].oxbStaked > 0) {
                _stakedBalances[account].rewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].oxbStaked
                    .mul(rewardBlocks)
                    .div(multiplier)
                    / rewardsVar);
            }

            _stakedBalances[account].lastBlockChecked = block.number;
            emit Rewards(account, _stakedBalances[account].rewards);
        }
        _;
    }

    modifier claimRewards() {
        uint256 reward = _stakedBalances[msg.sender].rewards;
        if (reward < 10) {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(scbPoolAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(scbPoolAddress, msg.sender, reward.mul(9).div(10));
            scbToken.safeTransferFrom(scbPoolAddress, scbFundAddress, reward.mul(1).div(10));
        }
        
        emit Rewards(msg.sender, reward);
        _;
    }
    
    function setMultipler(uint256 _multiplier) public _onlyOwner returns (uint256) {
        multiplier = _multiplier;
    }

    function setScbAddress(address _scbAddress) public _onlyOwner returns (uint256) {
        scbAddress = _scbAddress;
        scbToken = IERC20(_scbAddress);
    }
    
    function setOxbAddress(address _oxbAddress) public _onlyOwner returns (uint256) {
        oxbAddress = _oxbAddress;
        oxbToken = IERC20(_oxbAddress);
    }
    
    function setScbPoolAddress(address _scbPoolAddress) public _onlyOwner returns (uint256) {
        scbPoolAddress = _scbPoolAddress;
    }

    function setOxbPoolAddress(address _oxbPoolAddress) public _onlyOwner returns (uint256) {
        oxbPoolAddress = _oxbPoolAddress;
    }

    function setScbFundAddress(address _scbFundAddress) public _onlyOwner returns (uint256) {
        scbFundAddress = _scbFundAddress;
    }

    function setRewardsVar(uint256 _amount) public _onlyOwner {
        rewardsVar = _amount;
    }

    function getBlockNum() public view returns (uint256) {
        return block.number;
    }

    function getLastBlockCheckedNum(address _account) public view returns (uint256) {
        return _stakedBalances[_account].lastBlockChecked;
    }

    function getAddressOxbStakeAmount(address _account) public view returns (uint256) {
        return _stakedBalances[_account].oxbStaked;
    }

    function totalStakedScb() public view returns (uint256) {
        return _totalOxbStaked;
    }

    function getRewardsBalance(address account) public view returns (uint256) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            uint256 rewards = 0;
            if (_stakedBalances[account].oxbStaked > 0) {
                rewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].oxbStaked
                    .mul(rewardBlocks)
                    .mul(multiplier)
                    / rewardsVar);
            }

            return rewards;
        }

        return 0;
    }

    function stakeOxb(uint256 amount) public updateStakingReward(msg.sender) {
        require(oxbToken.balanceOf(msg.sender) > amount, "insufficient balance");
        require(oxbToken.allowance(msg.sender, address(this)) >= amount, "insufficient allowances");
        _totalOxbStaked = _totalOxbStaked.add(amount.mul(98).div(100));
        _stakedBalances[msg.sender].oxbStaked = _stakedBalances[msg.sender].oxbStaked.add(amount.mul(98).div(100));
        oxbToken.safeTransferFrom(msg.sender, oxbPoolAddress, amount);
        emit OxbStaked(msg.sender, amount, _totalOxbStaked);
    }

    function withdrawOxb(uint256 amount) public updateStakingReward(msg.sender) claimRewards() {
        require(amount <= _stakedBalances[msg.sender].oxbStaked, "withdraw amount must not more than staked amount");
        _totalOxbStaked = _totalOxbStaked.sub(amount);
        _stakedBalances[msg.sender].oxbStaked = _stakedBalances[msg.sender].oxbStaked.sub(amount);
        oxbToken.safeTransferFrom(oxbPoolAddress, msg.sender, amount);
        emit OxbWithdrawn(msg.sender, amount);
    }

    function getReward() public updateStakingReward(msg.sender) {
        uint256 reward = _stakedBalances[msg.sender].rewards;
        if (reward < 10) {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(scbPoolAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(scbPoolAddress, msg.sender, reward.mul(9).div(10));
            scbToken.safeTransferFrom(scbPoolAddress, scbFundAddress, reward.mul(1).div(10));
        }
        
        emit Rewards(msg.sender, reward);
    }
}

