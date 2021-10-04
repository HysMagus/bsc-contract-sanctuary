pragma solidity >=0.8.0;

// SPDX-License-Identifier: BSD-3-Clause

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

library EnumerableSet {

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            bytes32 lastvalue = set._values[lastIndex];

            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner,  bytes32(uint(uint160(value))));
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner,  bytes32(uint(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner,  bytes32(uint(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  constructor()  {
    owner = msg.sender;
  }


  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }



  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

interface Token {
    // bDFS functions
    function transferFrom(address, address, uint) external returns (bool);
    function transfer(address, uint) external returns (bool);
    function balanceOf(address) external returns (uint256);
    
    // NFT functions
    function mapIDsInRange(uint256 _startIndex, uint256 _endIndex, address _dir, uint256 _numUsos) external returns (uint256[] memory res);
    function use(uint256 id, address user) external returns(bool);
    
}

contract Staking_DFSG is Ownable {
    using SafeMath for uint;
    using EnumerableSet for EnumerableSet.AddressSet;
    
    event Staked(address holder, uint amount);
    event Withdrawn(address holder, uint amount);
    event RewardsClaimed(address holder, uint amount);
    event RewardsRestaked(address holder, uint amount);
    
    /* @dev@
    Contracts addresses
    */
    address public DFSG = 0x612C49b95c9121107BE3A2FE1fcF1eFC1C4730AD; 
    address public collectionNFT = 0x1b20833A92387bBCB8D0E69C15124C6462e19869; 
    
    /* @dev@
    Reward rate 20.00% per year
    */
    uint public constant rewardRate = 2000;
    uint public constant rewardInterval = 365 days;
    
    /* @dev@
    Staking fee = 1%
    */
    uint public constant stakingFeeRate = 100;
    uint public emergencyWithdrawFeeRate = 2000;
    
    /* @dev@
    Lock period = 1 month
    */
    uint public constant unstakeTime = 30 days;
    
    /* @dev@
    Max pool size = 2500000 DFSG
    */
    uint public maxPoolSize = 2500000000000000000000000;
    uint public poolSize = 2500000000000000000000000;
    
    /* @dev@
    Total Allocation = 300000 DFSG
    */
    uint public allocation = 300000000000000000000000; 
    
    /* @dev@
    Max individual deposited = 50000 DFSG
    */
    uint public constant maxStake = 50000000000000000000000; 
    
    uint public totalClaimedRewards = 0;
    bool public ended ;
    
    /* @dev@
    NFTs data & bonuses
    */
    uint public current_NFT_index = 0;
    uint public startIndexNFT = 31;
    uint public endIndexNFT = 79;
    uint public bonusNFT = 1000;
    
    EnumerableSet.AddressSet private holders;
    
    EnumerableSet.AddressSet private got_apy;
    
    mapping (address => uint) public depositedTokens;
    mapping (address => uint) public stakingTime;           
    mapping (address => uint) public lastClaimedTime;       
    mapping (address => uint) public totalEarnedTokens;
    
    mapping (address => uint) public rewardEnded;
    mapping (address => uint) public apy;
    mapping (address => mapping(uint => bool)) public usedNFT; 
    
    function addGot_Appy(address[] memory _new) public onlyOwner returns(bool){
        for(uint i = 0; i < _new.length; i = i.add(1)){
            got_apy.add(_new[i]);
        }
        return true;
    }
    function getGot_Apy() public view onlyOwner returns(address[] memory){
        uint _tam = got_apy.length();
        address[] memory _res = new address[](_tam);
        for(uint i = 0; i < _tam; i = i.add(1)){
            _res[i] = got_apy.at(i);
        }
        return _res;
    }
    
    function addNewNFT() public onlyOwner returns(bool){
        current_NFT_index = current_NFT_index.add(1);
        return true;
    }
    
    function setBonusNFT(uint _new) public onlyOwner returns(bool){
        bonusNFT = _new;
        return true;
    }
    
    function setIndexes(uint _start, uint _end) public onlyOwner returns(bool){
        startIndexNFT = _start;
        endIndexNFT = _end;
        return true;
    }
    
    function end() public onlyOwner returns (bool){
        require(!ended, "Staking already ended");
    
        for(uint i = 0; i < holders.length(); i = i.add(1)){
            rewardEnded[holders.at(i)] = getPendingDivs(holders.at(i));
        }
        
        ended = true;
        return true;
    }
    
    function getTotalPending() public view returns (uint){
        uint totalPending;
        for(uint i = 0; i < holders.length(); i = i.add(1)){
            totalPending = totalPending.add(getPendingDivs(holders.at(i)));
        }
        return totalPending;
    }
    
    function getRewardsLeft() public view returns (uint){
       
        uint _res;
        if(ended){
            _res = 0;
        }else{
            uint _totalPending = getTotalPending();
            _res = allocation.sub(totalClaimedRewards).sub(_totalPending);
        }
        
        return _res;
    }
    
    function getTotalDeposited() public view returns (uint){
         uint _res = 0;
         for(uint i = 0; i < holders.length(); i = i.add(1)) {
            _res = _res.add(depositedTokens[holders.at(i)]);
         }
         return _res;
    }
    
    function updateAccount(address account, bool _isStaking) internal {
        uint pendingDivs = getPendingDivs(account);
        if (pendingDivs > 0) {
            if(_isStaking && depositedTokens[account].add(pendingDivs) <= maxStake && poolSize >= pendingDivs){
                depositedTokens[account] = depositedTokens[account].add(pendingDivs);
                poolSize = poolSize.sub(pendingDivs);
                emit RewardsRestaked(account, pendingDivs);
            }else{
                require(Token(DFSG).transfer(account, pendingDivs), "Could not transfer tokens.");
                emit RewardsClaimed(account, pendingDivs);
            }
            
            rewardEnded[account] = 0;
            totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
            totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
            
        }
        lastClaimedTime[account] = block.timestamp;
    }
    
    function getPendingDivs(address _holder) public view returns (uint) {
        if (!holders.contains(_holder) || depositedTokens[_holder] == 0) return 0;
        uint pendingDivs;
        if(!ended){
             uint timeDiff = block.timestamp.sub(lastClaimedTime[_holder]);
             uint stakedAmount = depositedTokens[_holder];
             uint _apy = apy[_holder];
        
             pendingDivs = stakedAmount
                                .mul(_apy) 
                                .mul(timeDiff)
                                .div(rewardInterval)
                                .div(1e4); 
            
        }else{
            pendingDivs = rewardEnded[_holder];
        }
       
        return pendingDivs;
    }
    
    function getNumberOfHolders() public view returns (uint) {
        return holders.length();
    }
    
    function useNFT() public returns(bool){
        require(holders.contains(msg.sender), "Not a staker");
        require(!usedNFT[msg.sender][current_NFT_index],  "NFT already used"); 
        usedNFT[msg.sender][current_NFT_index] = true;
        
        uint _tam = endIndexNFT.sub(startIndexNFT).add(1);
        uint[] memory _nfts = new uint[](_tam);
        _nfts = Token(collectionNFT).mapIDsInRange(startIndexNFT, endIndexNFT, msg.sender, 0);
            
        require(_nfts[0] > 0, "No NFT available.");
        require(Token(collectionNFT).use(_nfts[0], msg.sender));
        apy[msg.sender] = apy[msg.sender].add(bonusNFT);
        
        return true;
        
    }
    
    // nft must be FALSE to enter without boosting the APY
    function deposit(uint amountToStake, bool nft) public returns(bool){
        require(!ended, "Staking has ended");
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(amountToStake.add(depositedTokens[msg.sender]) <= maxStake, "Cannot deposit Tokens");
        require(amountToStake <= poolSize, "No space available");
        
        require(Token(DFSG).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
        
        if (!holders.contains(msg.sender)) {
            holders.add(msg.sender);
            if(apy[msg.sender] == 0 && apy[msg.sender] != rewardRate.add(bonusNFT)){
                apy[msg.sender] = rewardRate;
            }
        }
        
        if(nft){
            require(!usedNFT[msg.sender][current_NFT_index],  "NFT already used"); 
            if(!got_apy.contains(msg.sender)){
                uint _tam = endIndexNFT.sub(startIndexNFT).add(1);
                uint[] memory _nfts = new uint[](_tam);
                _nfts = Token(collectionNFT).mapIDsInRange(startIndexNFT, endIndexNFT, msg.sender, 0);
                require(_nfts[0] > 0, "No NFT available.");
                require(Token(collectionNFT).use(_nfts[0], msg.sender), "Error using the NFT");
            }
            usedNFT[msg.sender][current_NFT_index] = true;
            apy[msg.sender] = apy[msg.sender].add(bonusNFT);
        }
        
        updateAccount(msg.sender, true);
        
        uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
        uint amountAfterFee = amountToStake.sub(fee);
        require(Token(DFSG).transfer(owner, fee), "Could not transfer deposit fee.");
        
        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
        poolSize = poolSize.sub(amountAfterFee);
        
        stakingTime[msg.sender] = block.timestamp;
        emit Staked(msg.sender, amountAfterFee);
        return true;
    }
    
    function getUnlockTime(address _holder) public view returns(uint){
        
        uint _res = 0;
        if(stakingTime[_holder] != 0 && block.timestamp < stakingTime[_holder].add(unstakeTime)){
            _res = stakingTime[_holder].add(unstakeTime);
        }
        return _res;
    }
    
    function withdraw(uint amountToWithdraw) public returns(bool){
        require(depositedTokens[msg.sender] >= amountToWithdraw && depositedTokens[msg.sender] > 0, "Invalid amount to withdraw");
        if(!ended){
            require(block.timestamp.sub(stakingTime[msg.sender]) > unstakeTime, "You recently staked, please wait before withdrawing.");
        }
        updateAccount(msg.sender, false);
        
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
        
        require(Token(DFSG).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
        
        
        poolSize = poolSize.add(amountToWithdraw);
        
        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
            holders.remove(msg.sender);
        }
        emit Withdrawn(msg.sender, amountToWithdraw);
        return true;
    }
    
    /* @dev@ 
    Avoid the lock, 20% fee.
    */
    function emergencyWithdraw(uint amountToWithdraw, bool _claimRewards) public returns(bool){
        require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
        
        if(_claimRewards){
            updateAccount(msg.sender, false);
        }
        
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
        
        uint fee = amountToWithdraw.mul(emergencyWithdrawFeeRate).div(1e4);
        uint amountAfterFee = amountToWithdraw.sub(fee);
        
        if(fee > 0){
            require(Token(DFSG).transfer(owner, fee), "Could not transfer fee.");
        }
        require(Token(DFSG).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
        
        poolSize = poolSize.add(amountToWithdraw);
        
        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
            holders.remove(msg.sender);
        }
        emit Withdrawn(msg.sender, amountToWithdraw);
        return true;
    }
   
    function avoidEmgFee() public onlyOwner returns(bool){
        emergencyWithdrawFeeRate = 0;
        return true;
    }
    
    function claimDivs() public returns(bool){
        updateAccount(msg.sender, false);
        return true;
    }
    
    function getStakersList(uint startIndex, uint endIndex) public view returns (address[] memory stakers, uint[] memory stakingTimestamps, uint[] memory lastClaimedTimeStamps,  uint[] memory stakedTokens) {
        require (startIndex < endIndex && holders.length() > 0 && endIndex < holders.length() , "Error getting data.");
        
        uint length = endIndex.sub(startIndex);
        address[] memory _stakers = new address[](length);
        uint[] memory _stakingTimestamps = new uint[](length);
        uint[] memory _lastClaimedTimeStamps = new uint[](length);
        uint[] memory _stakedTokens = new uint[](length);
        
        for (uint i = startIndex; i < endIndex; i = i.add(1)) {
            address staker = holders.at(i);
            uint listIndex = i.sub(startIndex);
            _stakers[listIndex] = staker;
            _stakingTimestamps[listIndex] = stakingTime[staker];
            _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
            _stakedTokens[listIndex] = depositedTokens[staker];
        }
        
        return (_stakers, _stakingTimestamps, _lastClaimedTimeStamps, _stakedTokens);
    }
    
    function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner returns(bool){
        require (_tokenAddr != DFSG, "Cannot Transfer Out this token");
        Token(_tokenAddr).transfer(_to, _amount);
        return true;
    }
    
    /* @dev@
    Function to get the rewards left in the staking pool once it is finished
    */
    function transferRewardsLeft(address _to) public onlyOwner returns (bool){
        require(ended, "Not available.");
        
        uint contract_balance = Token(DFSG).balanceOf(address(this));
        uint total_deposited = getTotalDeposited();
        uint total_pending = getTotalPending();
        require( contract_balance >= total_deposited.add(total_pending), "Can't get users funds");
        uint _amount = contract_balance.sub(total_pending).sub(total_deposited);
        Token(DFSG).transfer(_to, _amount);
        return true;
    }
    
    function setCollection(address _new) public onlyOwner returns (bool){
        collectionNFT = _new;
        return true;
    }
    
    function setTokenDepositAddress(address _new) public onlyOwner returns (bool){
        DFSG = _new;
        return true;
    }

    function setAllocation(uint _new) public onlyOwner returns(bool){
        allocation = _new;
        return true;
    }
    
    function addSize(uint _new) public onlyOwner returns(bool){
        maxPoolSize = maxPoolSize.add(_new);
        poolSize = poolSize.add(_new);
        return true;
    }
    
     /* For those who already used the NFT - previous pool */
    function updateAPY(address _staker) public onlyOwner returns(bool){
        require(holders.contains(_staker), "Not a staker");
        require(!usedNFT[_staker][current_NFT_index],  "NFT already used"); 
        usedNFT[_staker][current_NFT_index] = true;
        
        apy[msg.sender] = apy[msg.sender].add(bonusNFT);
        
        return true;
    }
    
    
}