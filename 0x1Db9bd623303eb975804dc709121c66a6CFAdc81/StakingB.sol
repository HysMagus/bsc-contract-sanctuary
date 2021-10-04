// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "./Ownable.sol";

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
contract Staking is Ownable {
    IERC20 public TKN;

    uint256[3] public periods = [30 days, 90 days, 150 days];
    uint8[3] public rates = [106, 121, 140];
    uint256[2][3] public amounts = [[100 ether, 300 ether], [300 ether, 500 ether], [500 ether, 1000 ether + 1]];
    uint256 public limit = 1500000 ether;
    uint256 public MAX_STAKES = 3;
    uint256 public finish_timestamp = 1648155600; // 2022 Mar 25 00:00 UTC

    bool public DEPRECATED = false;

    mapping(address => address) public refererOf;
    uint256[3] public _refererShares = [10, 5, 3];
    mapping(address => uint256[3]) public refCumulativeRewards;
    mapping(address => uint256[3]) public refCumulativeStaked;
    mapping(address => address[]) public referalsOf;
    event RefRewardDistributed(address indexed referer, address indexed staker, uint8 indexed level, uint256 amount, uint256 timestamp);
    event RefererSet(address indexed staker, address indexed referer, uint256 timestamp);

    struct Stake {
        uint8 tier;
        uint256 amount;
        uint256 finalAmount;
        uint32 timestamp;
        uint32 finalTimestamp;
        bool unstaked;
    }

    Stake[] public stakes;
    mapping(address => uint256[]) public stakesOf;
    mapping(uint256 => address) public ownerOf;

    event Staked(address indexed sender, uint8 indexed tier, uint256 amount, uint256 finalAmount);
    event Prolonged(address indexed sender, uint8 indexed tier, uint256 newAmount, uint256 newFinalAmount);
    event Unstaked(address indexed sender, uint8 indexed tier, uint256 amount);

    function stakesInfo(uint256 _from, uint256 _to) public view returns (Stake[] memory s) {
        s = new Stake[](_to - _from + 1);
        for (uint256 i = _from; i <= _to; i++) s[i - _from] = stakes[i];
    }

    function stakesInfoAll() public view returns (Stake[] memory s) {
        s = new Stake[](stakes.length);
        for (uint256 i = 0; i < stakes.length; i++) s[i] = stakes[i];
    }

    function stakesLength() public view returns (uint256) {
        return stakes.length;
    }

    function myStakes(address _me) public view returns (Stake[] memory s, uint256[] memory indexes) {
        s = new Stake[](stakesOf[_me].length);
        indexes = new uint256[](stakesOf[_me].length);
        for (uint256 i = 0; i < stakesOf[_me].length; i++) {
            indexes[i] = stakesOf[_me][i];
            s[i] = stakes[indexes[i]];
        }
    }

    function myActiveStakesCount(address _me) public view returns (uint256 l) {
        uint256[] storage _s = stakesOf[_me];
        for (uint256 i = 0; i < _s.length; i++) if (!stakes[_s[i]].unstaked) l++;
    }

    function myPendingStakesCount(address _me) public view returns (uint256 l) {
        uint256[] storage _s = stakesOf[_me];
        for (uint256 i = 0; i < _s.length; i++) if (block.timestamp < stakes[_s[i]].finalTimestamp) l++;
    }

    function stake(uint8 _tier, uint256 _amount, address _referer) public {
        require(!DEPRECATED, "Contract is deprecated, your stakes were moved to new contract");
        require((_tier < 3) && (_amount >= amounts[_tier][0]) && (_amount < amounts[_tier][1]), "Wrong amount"); // data valid
        require(myActiveStakesCount(msg.sender) < MAX_STAKES, "MAX_STAKES overflow"); // has space for new active stake
        require(finish_timestamp > block.timestamp + periods[_tier], "Program will finish before this stake does"); // not staking in the end of program
        uint256 _finalAmount = (_amount * rates[_tier]) / 100;
        uint256 _reward = _finalAmount - _amount;
        limit -= _reward;
        if (stakesOf[msg.sender].length == 0 && _referer != address(0) && myPendingStakesCount(_referer) > 0) {
            referalsOf[_referer].push(msg.sender);
            refererOf[msg.sender] = _referer;
            emit RefererSet(msg.sender, _referer, block.timestamp);
            _distributeRefStaked(_amount, msg.sender);
            _distributeRefRewards(_reward, msg.sender);
        }
        else if (stakesOf[msg.sender].length > 0 && refererOf[msg.sender] != address(0)) {
            _distributeRefStaked(_amount, msg.sender);
            _distributeRefRewards(_reward, msg.sender);
        }
        require(TKN.transferFrom(msg.sender, address(this), _amount));
        uint256 _index = stakes.length;
        stakesOf[msg.sender].push(_index);
        stakes.push(Stake({
            tier: _tier,
            amount: _amount,
            finalAmount: _finalAmount,
            timestamp: uint32(block.timestamp),
            finalTimestamp: uint32(block.timestamp + periods[_tier]),
            unstaked: false
        }));
        ownerOf[_index] = msg.sender;
        emit Staked(msg.sender, _tier, _amount, _finalAmount);
    }

    function getStakes() public view returns (Stake[] memory) {
        return stakes;
    }

    function getStakesLength() public view returns (uint256) {
        return stakes.length;
    }

    function getStakesOf(address _staker) public view returns (Stake[] memory s, uint256[] memory indexes) {
        indexes = stakesOf[_staker];
        s = new Stake[](indexes.length);
        for (uint256 i = 0; i < s.length; i++) s[i] = stakes[indexes[i]];
    }

    function getReferalsOf(address _referer) public view returns (address[] memory refTree1) {
        refTree1 = referalsOf[_referer];
    }

    function refInfoBundleMin(address _referer) public view returns (uint256[3] memory cumulativeRewards, uint256[3] memory cumulativeStaked, address[] memory refTree1) {
        cumulativeRewards = refCumulativeRewards[_referer];
        cumulativeStaked = refCumulativeStaked[_referer];
        refTree1 = referalsOf[_referer];
    }

    function _distributeRefStaked(uint256 _staked, address _staker) internal {
        address _referer = _staker;
        for (uint8 i = 0; i < 3; i++) {
            _referer = refererOf[_referer];
            if (_referer == address(0)) break;
            refCumulativeStaked[_referer][i] += _staked;
        }
    }

    function _distributeRefRewards(uint256 _reward, address _staker) internal {
        address _referer = _staker;
        for (uint8 i = 0; i < 3; i++) {
            _referer = refererOf[_referer];
            if (_referer == address(0)) break;
            if (myPendingStakesCount(_referer) == 0) continue;
            uint256 _refReward = (_reward * _refererShares[i]) / 100;
            TKN.transfer(_referer, _refReward);
            emit RefRewardDistributed(_referer, _staker, i, _refReward, block.timestamp);
            refCumulativeRewards[_referer][i] += _refReward;
        }
    }

    function prolong(uint256 _index) public {
        require(!DEPRECATED, "Contract is deprecated, your stakes were moved to new contract");
        require(msg.sender == ownerOf[_index]);
        Stake storage _s = stakes[_index];
        require(!_s.unstaked); // not unstaked yet
        require(block.timestamp >= _s.timestamp + periods[_s.tier]); // staking period finished
        require(finish_timestamp > _s.finalTimestamp); // not prolonging in the end of program
        uint256 _newAmount = _s.finalAmount;
        uint256 _newFinalAmount = (_newAmount * rates[_s.tier]) / 100;
        uint256 _reward = _newFinalAmount - _newAmount;
        limit -= _reward;
        if (refererOf[msg.sender] != address(0)) {
            _distributeRefStaked(_newAmount - _s.amount, msg.sender);
            _distributeRefRewards(_reward, msg.sender);
        }
        _s.amount = _newAmount;
        _s.finalAmount = _newFinalAmount;
        _s.timestamp = uint32(block.timestamp);
        _s.finalTimestamp = uint32(block.timestamp + periods[_s.tier]);
        emit Prolonged(msg.sender, _s.tier, _newAmount, _newFinalAmount);
    }

    function unstake(uint256 _index) public {
        require(!DEPRECATED, "Contract is deprecated, your stakes were moved to new contract");
        require(msg.sender == ownerOf[_index]);
        Stake storage _s = stakes[_index];
        require(!_s.unstaked); // not unstaked yet
        require(block.timestamp >= _s.timestamp + periods[_s.tier]); // staking period finished
        require(TKN.transfer(msg.sender, _s.finalAmount));
        _s.unstaked = true;
        emit Unstaked(msg.sender, _s.tier, _s.finalAmount);
    }

    function drain(address _recipient) public restricted {
        require(DEPRECATED || block.timestamp > finish_timestamp); // 2022 Apr 25 00:00 UTC
        require(TKN.transfer(_recipient, limit));
        limit = 0;
    }

    function drainFull(address _recipient) public restricted {
        require(DEPRECATED || block.timestamp > finish_timestamp + 30 days); // 2022 May 25 00:00 UTC
        uint256 _amount = TKN.balanceOf(address(this));
        require(TKN.transfer(_recipient, _amount));
        limit = 0;
    }

    function returnAccidentallySent(IERC20 _TKN) public restricted {
        require(address(_TKN) != address(TKN));
        uint256 _amount = _TKN.balanceOf(address(this));
        require(TKN.transfer(msg.sender, _amount));
    }

    function updateMax(uint256 _max) public restricted {
        MAX_STAKES = _max;
    }

    function DEPRECATE() public restricted {
        MAX_STAKES = 0;
        DEPRECATED = true;
    }

    constructor(IERC20 _TKN) {
        TKN = _TKN;
    }
}
