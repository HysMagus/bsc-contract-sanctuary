// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "SafeERC20.sol";
import "ERC20.sol";

contract OxbOxbFarm {

    struct stakeTracker {
        uint256 lastBlockChecked;
        uint256 rewards;
        uint256 oxbStaked;
    }

    address private owner;
    address private oxbPoolAddress;
    address private oxbFundAddress;
    address private oxbAddress;
    IERC20 private oxbToken;
    uint256 private rewardsVar;

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 private _totalOxbStaked;
    mapping(address => stakeTracker) private _stakedBalances;

    constructor() public {
        owner = msg.sender;
        rewardsVar = 250;
    }

    event OxbStaked(address indexed user, uint256 amount, uint256 totalOxbStaked);
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
            oxbToken.safeTransferFrom(oxbPoolAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            oxbToken.safeTransferFrom(oxbPoolAddress, msg.sender, reward.mul(9).div(10));
            oxbToken.safeTransferFrom(oxbPoolAddress, oxbFundAddress, reward.mul(1).div(10));
        }
        
        emit Rewards(msg.sender, reward);
        _;
    }

    function setOxbAddress(address _oxbAddress) public _onlyOwner returns (uint256) {
        oxbAddress = _oxbAddress;
        oxbToken = IERC20(_oxbAddress);
    }
    
    function setOxbPoolAddress(address _oxbPoolAddress) public _onlyOwner returns (uint256) {
        oxbPoolAddress = _oxbPoolAddress;
    }

    function setOxbFundAddress(address _oxbFundAddress) public _onlyOwner returns (uint256) {
        oxbFundAddress = _oxbFundAddress;
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

    function totalStakedOxb() public view returns (uint256) {
        return _totalOxbStaked;
    }

    function getRewardsBalance(address account) public view returns (uint256) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            uint256 oxbRewards = 0;
            if (_stakedBalances[account].oxbStaked > 0) {
                oxbRewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].oxbStaked
                    .mul(rewardBlocks)
                    / rewardsVar);
            }

            return oxbRewards;
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
            oxbToken.safeTransferFrom(oxbPoolAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            oxbToken.safeTransferFrom(oxbPoolAddress, msg.sender, reward.mul(9).div(10));
            oxbToken.safeTransferFrom(oxbPoolAddress, oxbFundAddress, reward.mul(1).div(10));
        }
        
        emit Rewards(msg.sender, reward);
    }
}
