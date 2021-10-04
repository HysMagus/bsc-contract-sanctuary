// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "SafeERC20.sol";
import "ERC20.sol";

interface IERC1155 {
    /**
     * @notice Get the balance of an account's Tokens
     * @param _owner  The address of the token holder
     * @param _id     ID of the Token
     * @return        The _owner's balance of the Token type requested
     */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);
}

contract NftScbFarm {

    struct stakeTracker {
        uint256 lastBlockChecked;
        uint256 rewards;
        mapping(uint256 => uint256) nftStaked;
        uint256 totalNftStaked;
    }

    address private owner;
    address private scbAddress;
    address private nftAddress;
    address private farmAddress;
    IERC20 private scbToken;
    IERC1155 private nftToken;
    uint256 private rewardsVar;
    uint256 private multiplier;

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 private _totalNftStaked;
    mapping(address => stakeTracker) private _stakedBalances;

    constructor() public {
        owner = msg.sender;
        rewardsVar = 84705;
        multiplier = 10 ** 18;
    }

    event NftStaked(address indexed user, uint256 amount, uint256 totalScbStaked);
    event NftWithdrawn(address indexed user, uint256 amount);
    event Rewards(address indexed user, uint256 reward);

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier updateStakingReward(address account) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            if (_stakedBalances[account].totalNftStaked > 0) {
                _stakedBalances[account].rewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].totalNftStaked
                    .mul(rewardBlocks)
                    .mul(multiplier)
                    .div(rewardsVar));
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
            scbToken.safeTransferFrom(farmAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(farmAddress, msg.sender, reward.mul(9).div(10));
        }
        
        emit Rewards(msg.sender, reward);
        _;
    }
    
    function setFarmAddress(address _farmAddress) public _onlyOwner returns (uint256) {
        farmAddress = _farmAddress;
    }
    
    function setMultipler(uint256 _multiplier) public _onlyOwner returns (uint256) {
        multiplier = _multiplier;
    }

    function setScbAddress(address _scbAddress) public _onlyOwner returns (uint256) {
        scbAddress = _scbAddress;
        scbToken = IERC20(_scbAddress);
    }
    
    function setNftAddress(address _nftAddress) public _onlyOwner returns (uint256) {
        nftAddress = _nftAddress;
        nftToken = IERC1155(_nftAddress);
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

    function getAddressNftStakeAmount(address _account, uint256 _cardId) public view returns (uint256) {
        return _stakedBalances[_account].nftStaked[_cardId];
    }

    function totalStakedNft() public view returns (uint256) {
        return _totalNftStaked;
    }

    function getRewardsBalance(address account) public view returns (uint256) {
        if (block.number > _stakedBalances[account].lastBlockChecked) {
            uint256 rewardBlocks = block.number
            .sub(_stakedBalances[account].lastBlockChecked);

            uint256 rewards = 0;
            if (_stakedBalances[account].totalNftStaked > 0) {
                rewards = _stakedBalances[account].rewards
                .add(
                    _stakedBalances[account].totalNftStaked
                    .mul(rewardBlocks)
                    .mul(multiplier)
                    .div(rewardsVar));
            }

            return rewards;
        }

        return 0;
    }

    function stakeNft(uint256 _cardId, uint256 _amount) public updateStakingReward(msg.sender) {
        require(nftToken.balanceOf(msg.sender, _cardId) > 0, "insufficient balance");
        require(_amount <= nftToken.balanceOf(msg.sender, _cardId) - _stakedBalances[msg.sender].nftStaked[_cardId], "insufficient balance");
        _totalNftStaked = _totalNftStaked.add(_amount);
        _stakedBalances[msg.sender].totalNftStaked = _stakedBalances[msg.sender].totalNftStaked.add(_amount);
        _stakedBalances[msg.sender].nftStaked[_cardId] = _stakedBalances[msg.sender].nftStaked[_cardId].add(_amount);
        emit NftStaked(msg.sender, _amount, _totalNftStaked);
    }

    function withdrawNft(uint256 _cardId, uint256 _amount) public updateStakingReward(msg.sender) claimRewards() {
        require(_amount <= _stakedBalances[msg.sender].nftStaked[_cardId], "withdraw amount must not more than staked amount");
        require(nftToken.balanceOf(msg.sender, _cardId) >= _stakedBalances[msg.sender].nftStaked[_cardId], "owned cards less than staked amount");
        _totalNftStaked = _totalNftStaked.sub(_amount);
        _stakedBalances[msg.sender].totalNftStaked = _stakedBalances[msg.sender].totalNftStaked.sub(_amount);
        _stakedBalances[msg.sender].nftStaked[_cardId] = _stakedBalances[msg.sender].nftStaked[_cardId].sub(_amount);
        emit NftWithdrawn(msg.sender, _amount);
    }

    function getReward() public updateStakingReward(msg.sender) {
        uint256 reward = _stakedBalances[msg.sender].rewards;
        if (reward < 10) {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(farmAddress, msg.sender, reward);
        } else {
            _stakedBalances[msg.sender].rewards = 0;
            scbToken.safeTransferFrom(farmAddress, msg.sender, reward.mul(9).div(10));
        }
        
        emit Rewards(msg.sender, reward);
    }
}
