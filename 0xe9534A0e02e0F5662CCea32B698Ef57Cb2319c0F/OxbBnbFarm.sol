// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "SafeERC20.sol";
import "ERC20.sol";

contract OxbBnbFarm {

    struct stakeTracker {
        uint256 lastBlockChecked;
        uint256 rewards;
        uint256 lpStaked;
    }

    address private owner;
    address private farmAddress;
    address private oxbAddress;
    address private lpAddress;
    IERC20 private oxbToken;
    IERC20 private lpToken;
    uint256 private rewardsVar;
    uint256 private multiplier;

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 private _totalLpStaked;
    mapping(address => stakeTracker) private _stakedBalances;

    constructor() public {
        owner = msg.sender;
        rewardsVar = 28800;
        multiplier = 1;
    }

    event LpStaked(address indexed user, uint256 amount, uint256 totalLpStaked);
    event LpWithdrawn(address indexed user, uint256 amount);
    event Rewards(address indexed user, uint256 reward);

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier updateStakingReward(address account) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            if (_stakedBalances[account].lpStaked > 0) {
                _stakedBalances[account].rewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].lpStaked
                    .mul(rewardBlocks)
                    .mul(multiplier)
                    .div(rewardsVar)
                );
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
            oxbToken.safeTransferFrom(farmAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            oxbToken.safeTransferFrom(farmAddress, msg.sender, reward.mul(9).div(10));
        }
        
        emit Rewards(msg.sender, reward);
        _;
    }

    function setOxbAddress(address _oxbAddress) public _onlyOwner returns (uint256) {
        oxbAddress = _oxbAddress;
        oxbToken = IERC20(_oxbAddress);
    }
    
    function setLpAddress(address _lpAddress) public _onlyOwner returns (uint256) {
        lpAddress = _lpAddress;
        lpToken = IERC20(_lpAddress);
    }
    
    function setfarmAddress(address _farmAddress) public _onlyOwner returns (uint256) {
        farmAddress = _farmAddress;
    }

    function setRewardsVar(uint256 _amount) public _onlyOwner {
        rewardsVar = _amount;
    }

    function setMultiplier(uint256 _amount) public _onlyOwner {
        multiplier = _amount;
    }

    function getBlockNum() public view returns (uint256) {
        return block.number;
    }

    function getLastBlockCheckedNum(address _account) public view returns (uint256) {
        return _stakedBalances[_account].lastBlockChecked;
    }

    function getAddressLpStakeAmount(address _account) public view returns (uint256) {
        return _stakedBalances[_account].lpStaked;
    }

    function totalLpStaked() public view returns (uint256) {
        return _totalLpStaked;
    }

    function getRewardsBalance(address account) public view returns (uint256) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            uint256 oxbRewards = 0;
            if (_stakedBalances[account].lpStaked > 0) {
                oxbRewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].lpStaked
                    .mul(rewardBlocks)
                    .mul(multiplier)
                    .div(rewardsVar)
                );
            }

            return oxbRewards;
        }

        return 0;
    }

    function stakeLp(uint256 amount) public updateStakingReward(msg.sender) {
        require(lpToken.balanceOf(msg.sender) > amount, "insufficient balance");
        require(lpToken.allowance(msg.sender, address(this)) >= amount, "insufficient allowances");
        _totalLpStaked = _totalLpStaked.add(amount);
        _stakedBalances[msg.sender].lpStaked = _stakedBalances[msg.sender].lpStaked.add(amount);
        lpToken.safeTransferFrom(msg.sender, farmAddress, amount);
        emit LpStaked(msg.sender, amount, _totalLpStaked);
    }

    function withdrawLp(uint256 amount) public updateStakingReward(msg.sender) claimRewards() {
        require(amount <= _stakedBalances[msg.sender].lpStaked, "withdraw amount must not more than staked amount");
        _totalLpStaked = _totalLpStaked.sub(amount);
        _stakedBalances[msg.sender].lpStaked = _stakedBalances[msg.sender].lpStaked.sub(amount);
        lpToken.safeTransferFrom(farmAddress, msg.sender, amount);
        emit LpWithdrawn(msg.sender, amount);
    }

    function getReward() public updateStakingReward(msg.sender) {
        uint256 reward = _stakedBalances[msg.sender].rewards;
        _stakedBalances[msg.sender].rewards = 0;
        if (reward < 10) {
            oxbToken.safeTransferFrom(farmAddress, msg.sender, reward);
        } else {
            oxbToken.safeTransferFrom(farmAddress, msg.sender, reward.mul(9).div(10));
        }
        
        emit Rewards(msg.sender, reward);
    }
}
