// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

abstract contract ERC20 {
    function name() external view virtual returns (string memory);
    function symbol() external view virtual returns (string memory);
    function decimals() external view virtual returns (uint8);
    function totalSupply() external view virtual returns (uint256);
    function balanceOf(address _owner) external view virtual returns (uint256);
    function allowance(address _owner, address _spender) external view virtual returns (uint256);
    function transfer(address _to, uint256 _value) external virtual returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external virtual returns (bool);

    function approve(address _spender, uint256 _value) external virtual returns (bool);
}

contract StakeContract
{
    uint256 ONE_HUNDRED = 100000000000000000000;
    
    address public networkcoinaddress;
    ERC20 public networkcointoken;
    string public networkcoinsymbol;
    bool public stakeRewardByAmount; //By amount or by share

    struct Player{
        address id;
    }

    struct Balance {
        uint256 total;
        uint256 accumulatedEarning;
        uint256 playerIndex;
    }

    struct StakedBalance {
        uint256 total;
        uint playerIndex;
    }

    struct StakeRecord {
        uint256 total;
        uint time;
    }

    struct StakeFee {
        uint256 amount;
        uint time;
        address player;
    }

    event OnDeposit(address from, address token, address tokenreceiving, uint256 total);
    event OnWithdraw(address to, address token, address tokenreceiving, uint256 total);
    event OnClaimEarnings(address to, address token, address tokenreceiving, uint256 total);
    event OnStake(address from, address token, address tokenreceiving, uint256 total);
    event OnUnstake(address from, address token, address tokenreceiving, uint256 total);

    address public owner;
    address public feeTo;

    //Stake Players of Token/TokenReceive
    mapping(address => mapping(address => Player[])) public players;

    //Deposit Players of Token/TokenReceive
    mapping(address => mapping(address => Player[])) public depositplayers;

    //Earnings per Seconds per Share or Amount for each TokenStake/TokenReceive
    mapping(address => mapping(address => uint256)) earningspersecondspershareoramount;

    //Fee percent on stake action
    mapping(address => mapping(address => uint256)) feepercentonstake;

    //Stake Fee Records of Token/TokenReceive
    mapping(address => mapping(address => StakeFee[])) feeonstakerecords;
    
    //Max and Min Deposit for each TokenStake/TokenReceive
    mapping(address => mapping(address => uint256)) maxDeposit;
    mapping(address => mapping(address => uint256)) minDeposit;

    //Max and Min Withdrawal for each TokenStake/TokenReceive
    mapping(address => mapping(address => uint256)) maxWithdraw;
    mapping(address => mapping(address => uint256)) minWithdraw;

    //Active Stake for each TokenStake/TokenReceive
    mapping(address => mapping(address => bool)) activeStake;

    //Total staked for all users
    mapping(address => mapping(address => uint256)) totalStaked;

    //Total deposited for all users
    mapping(address => mapping(address => uint256)) totalDeposited;

    //User lists (1st mapping user, 2nd mapping token, 3rd mapping receiving token)
    mapping(address => mapping(address => mapping(address => Balance))) balances;
    mapping(address => mapping(address => mapping(address => StakedBalance))) stakedbalances;
    mapping(address => mapping(address => mapping(address => StakeRecord[]))) stakerecords;

    constructor() {
        owner = msg.sender;
        feeTo = owner;
        networkcoinaddress = address(0x1110000000000000000100000000000000000111);
        networkcointoken = ERC20(networkcoinaddress);
        networkcoinsymbol = "ETH";
        stakeRewardByAmount = true;
    }

    function setup(ERC20 token, ERC20 tokenReceiving, uint256 maxDepositAllowed, uint256 minDepositAllowed, uint256 maxWithdrawAllowed, uint256 minWithdrawAllowed, uint256 earningsPerSecondsPerShareOrAmount, uint256 feePercentOnStake, string memory networkCoinSymbol) external
    {
        require(msg.sender == owner, 'Forbidden');
        
        setMaxDepositTokenInWei(token, tokenReceiving, maxDepositAllowed);
        setMinDepositTokenInWei(token, tokenReceiving, minDepositAllowed);

        setMaxWithdrawTokenInWei(token, tokenReceiving, maxWithdrawAllowed);
        setMinWithdrawTokenInWei(token, tokenReceiving, minWithdrawAllowed);

        setEarningsPerSecondPerShareOrAmountInWei(token, tokenReceiving, earningsPerSecondsPerShareOrAmount);
        setFeePercentOnStake(token, tokenReceiving, feePercentOnStake);
        setNetworkCoinSymbol(networkCoinSymbol);
        setActiveStake(token, tokenReceiving, true);
    }

    function depositToken(ERC20 token, ERC20 tokenReceiving, uint256 amountInWei, bool enterStaked) external 
    {
        require(getActiveStake(token, tokenReceiving) == true, "STAKE: Inactive stake");

        address receiver = address(this);
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        //Approve (outside): allowed[msg.sender][spender] (sender = my account, spender = stake token address)
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amountInWei, "STAKE: Check the token allowance. Use approve function.");

        uint256 maxDepositAllowed = getMaxDepositTokenInWei(token, tokenReceiving);
        require(amountInWei <= maxDepositAllowed, "STAKE: Deposit value is too high.");

        uint256 minDepositAllowed = getMinDepositTokenInWei(token, tokenReceiving);
        require(amountInWei >= minDepositAllowed, "STAKE: Deposit value is too low.");

        token.transferFrom(msg.sender, receiver, amountInWei);

        uint256 currentTotal = balances[msg.sender][tokenAddress][tokenReceivingAddress].total;

        //If is a new player for deposit, register
        if(balances[msg.sender][tokenAddress][tokenReceivingAddress].total == 0)
        {
            depositplayers[tokenAddress][tokenReceivingAddress].push(Player({
                id: msg.sender
            }));

            balances[msg.sender][tokenAddress][tokenReceivingAddress].playerIndex = depositplayers[tokenAddress][tokenReceivingAddress].length -1;
        }

        //Increase/register deposit balance
        balances[msg.sender][tokenAddress][tokenReceivingAddress].total = safeAdd(currentTotal, amountInWei);

        //Increase general deposit amount
        totalDeposited[tokenAddress][tokenReceivingAddress] = safeAdd(totalDeposited[tokenAddress][tokenReceivingAddress], amountInWei);

        emit OnDeposit(msg.sender, tokenAddress, tokenReceivingAddress, amountInWei);

        if(enterStaked == true)
        {
            stakeToken(token, tokenReceiving, amountInWei);
        }
    }

    function depositNetworkCoin(ERC20 tokenReceiving, bool enterStaked) external payable 
    {
        require(msg.value > 0, "STAKE: Deposit value too low");

        ERC20 token = networkcointoken;
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        require(getActiveStake(token, tokenReceiving) == true, "STAKE: Inactive stake");

        uint256 amountInWei = msg.value;

        uint256 maxDepositAllowed = getMaxDepositTokenInWei(token, tokenReceiving);
        require(amountInWei <= maxDepositAllowed, "STAKE: Deposit value is too high.");

        uint256 minDepositAllowed = getMinDepositTokenInWei(token, tokenReceiving);
        require(amountInWei >= minDepositAllowed, "STAKE: Deposit value is too low.");

        uint256 currentTotal = balances[msg.sender][tokenAddress][tokenReceivingAddress].total;

        //If is a new player for deposit, register
        if(balances[msg.sender][tokenAddress][tokenReceivingAddress].total == 0)
        {
            depositplayers[tokenAddress][tokenReceivingAddress].push(Player({
                id: msg.sender
            }));

            balances[msg.sender][tokenAddress][tokenReceivingAddress].playerIndex = depositplayers[tokenAddress][tokenReceivingAddress].length -1;
        }

        //Increase/register deposit balance
        balances[msg.sender][tokenAddress][tokenReceivingAddress].total = safeAdd(currentTotal, amountInWei);

        //Increase general deposit amount
        totalDeposited[tokenAddress][tokenReceivingAddress] = safeAdd(totalDeposited[tokenAddress][tokenReceivingAddress], amountInWei);

        emit OnDeposit(msg.sender, tokenAddress, tokenReceivingAddress, amountInWei);

        if(enterStaked == true)
        {
            stakeToken(token, tokenReceiving, amountInWei);
        }
    }

    function getDepositBalance(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        return getDepositBalanceForPlayer(msg.sender, token, tokenReceiving);
    }

    function getDepositBalanceForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        return balances[playerAddress][tokenAddress][tokenReceivingAddress].total;
    }


    //Amount of deposit at all - for all users
    function getDepositTotalAmount(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 totalDepositForToken = totalDeposited[tokenAddress][tokenReceivingAddress];
        return totalDepositForToken;
    }

    function getDepositAccumulatedEarnings(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        //Value when unstake earning token is different from stake token
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        return balances[msg.sender][tokenAddress][tokenReceivingAddress].accumulatedEarning;
    }
    
    function withdrawToken(ERC20 token, ERC20 tokenReceiving, uint256 amountInWei, bool doClaimEarnings) external {
        withdrawTokenForPlayer(msg.sender, token, tokenReceiving, amountInWei, doClaimEarnings);
    }

    function withdrawTokenForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving, uint256 amountInWei, bool doClaimEarnings) private {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 maxWithdrawAllowed = getMaxWithdrawTokenInWei(token, tokenReceiving);
        require(amountInWei <= maxWithdrawAllowed, "STAKE: Withdraw value is too high.");

        uint256 minWithdrawAllowed = getMinWithdrawTokenInWei(token, tokenReceiving);
        require(amountInWei >= minWithdrawAllowed, "STAKE: Withdraw value is too low.");

        uint256 depositBalance = getDepositBalanceForPlayer(playerAddress, token, tokenReceiving);

        require(depositBalance >= amountInWei, "STAKE: There is not enough deposit balance to withdraw the requested amount");

        address sourceAddress = address(this);
        uint sourceBalance;

        if(tokenAddress != networkcoinaddress)
        {
            //Balance in Token
            sourceBalance = token.balanceOf(sourceAddress);
        }
        else
        {
            //Balance in Network Coin
            sourceBalance = sourceAddress.balance;
        }

        require(sourceBalance >= amountInWei, "STAKE: Too low reserve to withdraw the requested amount");

        if(doClaimEarnings == true)
        {
            claimEarnings(token, tokenReceiving);
        }

        //Withdraw of deposit value
        if(tokenAddress != networkcoinaddress)
        {
            //Withdraw token
            token.transfer(playerAddress, amountInWei);
        }
        else
        {
            //Withdraw Network Coin
            payable(playerAddress).transfer(amountInWei);
        }

        uint256 currentTotal = balances[playerAddress][tokenAddress][tokenReceivingAddress].total;
        balances[playerAddress][tokenAddress][tokenReceivingAddress].total = safeSub(currentTotal, amountInWei);

        //Reduce general deposit amount
        totalDeposited[tokenAddress][tokenReceivingAddress] = safeSub(totalDeposited[tokenAddress][tokenReceivingAddress], amountInWei);

        //If has no more deposit balances for this token, remove player
        if(balances[playerAddress][tokenAddress][tokenReceivingAddress].total == 0)
        {
            uint playerIndex = balances[playerAddress][tokenAddress][tokenReceivingAddress].playerIndex;

            //Swap index to last
            uint playersCount = depositplayers[tokenAddress][tokenReceivingAddress].length;
            if(playersCount > 1)
            {
                depositplayers[tokenAddress][tokenReceivingAddress][playerIndex] = depositplayers[tokenAddress][tokenReceivingAddress][playersCount - 1];
            }

            //Delete dirty last
            if(playersCount > 0)
            {
                depositplayers[tokenAddress][tokenReceivingAddress].pop();
            }

            //Reindex players
            if(depositplayers[tokenAddress][tokenReceivingAddress].length > 0)
            {
                for(uint ix = 0; ix < depositplayers[tokenAddress][tokenReceivingAddress].length; ix++)
                {
                    balances[  depositplayers[tokenAddress][tokenReceivingAddress][ix].id  ][tokenAddress][tokenReceivingAddress].playerIndex = ix;
                }
            }
        }

        emit OnWithdraw(playerAddress, tokenAddress, tokenReceivingAddress, amountInWei);
    }

    function claimEarnings(ERC20 token, ERC20 tokenReceiving) public {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        address sourceAddress = address(this);

        uint256 accumulatedEarning = balances[msg.sender][tokenAddress][tokenReceivingAddress].accumulatedEarning;
        if(tokenAddress != tokenReceivingAddress)
        {
            uint sourceReceivingBalance;

            if(tokenReceivingAddress != networkcoinaddress)
            {
                //Balance in Token
                sourceReceivingBalance = tokenReceiving.balanceOf(sourceAddress);
            }
            else
            {
                //Balance in Network Coin
                sourceReceivingBalance = sourceAddress.balance;
            }

            require(sourceReceivingBalance >= accumulatedEarning, "STAKE: Too low reserve to send earning");
        }

        //Check accumulated earning when receiving token is different from stake token
        if(tokenAddress != tokenReceivingAddress)
        {
            if(accumulatedEarning > 0)
            {
                balances[msg.sender][tokenAddress][tokenReceivingAddress].accumulatedEarning = 0;

                //Withdraw bonus
                if(tokenReceivingAddress != networkcoinaddress)
                {
                    //Withdraw bonus token
                    tokenReceiving.transfer(msg.sender, accumulatedEarning);
                }
                else
                {
                    //Withdraw bonus network coin
                    payable(msg.sender).transfer(accumulatedEarning);
                }

                emit OnClaimEarnings(msg.sender, tokenAddress, tokenReceivingAddress, accumulatedEarning);
            }
        }
    }

    function stakeToken(ERC20 token, ERC20 tokenReceiving, uint256 amountInWei) public {
        
        require(getActiveStake(token, tokenReceiving) == true, "STAKE: Inactive stake");

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        require(balances[msg.sender][tokenAddress][tokenReceivingAddress].total >= amountInWei, 'STAKE: There is not enough deposit balance to stake the requested amount');

        uint256 currentTotalStaked = stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].total;
        uint256 currentTotal = balances[msg.sender][tokenAddress][tokenReceivingAddress].total;

        //If is a new player (no staked balance for this token), register him/her
        if(stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].total == 0)
        {
            players[tokenAddress][tokenReceivingAddress].push(Player({
                id: msg.sender
            }));

            stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].playerIndex = players[tokenAddress][tokenReceivingAddress].length -1;
        }

        //Pay admin fee on stake
        uint256 feePercent = feepercentonstake[tokenAddress][tokenReceivingAddress]; //Eg 10 (10000000000000000000)

        uint256 fee = 0;

        if(feePercent > 0)
        {
            require(feePercent <= ONE_HUNDRED, "STAKE: Invalid percent fee value");

            fee = safeDiv(safeMul(amountInWei, feePercent), ONE_HUNDRED);

            amountInWei = safeSub(amountInWei, fee);

            feeonstakerecords[tokenAddress][tokenReceivingAddress].push(StakeFee({
                player: msg.sender,
                time: block.timestamp,
                amount: fee
            }));

            if(tokenAddress != networkcoinaddress)
            {
                //Withdraw token
                token.transfer(feeTo, fee);
            }
            else
            {
                //Withdraw Network Coin
                payable(feeTo).transfer(fee);
            }
        }

        //Reduce from deposit balance amount and fee
        balances[msg.sender][tokenAddress][tokenReceivingAddress].total = safeSub(currentTotal, safeAdd(amountInWei, fee));
        
        //Reduce from general deposit amount and fee
        totalDeposited[tokenAddress][tokenReceivingAddress] = safeSub(totalDeposited[tokenAddress][tokenReceivingAddress], safeAdd(amountInWei, fee));
        
        //Increse staked balance with amount
        stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].total = safeAdd(currentTotalStaked, amountInWei);
        //stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].symbol = symbol;

        //Increase total staked for token with amount
        totalStaked[tokenAddress][tokenReceivingAddress] = safeAdd(totalStaked[tokenAddress][tokenReceivingAddress], amountInWei);

        //Register stake
        stakerecords[msg.sender][tokenAddress][tokenReceivingAddress].push(
            StakeRecord({
                total: amountInWei,
                //symbol: symbol,
                time: block.timestamp
            })
        );

        emit OnStake(msg.sender, tokenAddress, tokenReceivingAddress, amountInWei);
    }

    function getStakeBalance(ERC20 token, ERC20 tokenReceiving) external view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return stakedbalances[msg.sender][tokenAddress][tokenReceivingAddress].total;
    }

    function getStakeBonus(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 totalStakes = getStakeCount(token, tokenReceiving);

        uint256 earningsPerSecond = earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress];

        uint256 totalBonus = 0;

        if(earningsPerSecond > 0)
        {
            for (uint i = 0; i < totalStakes; i++) 
            {
                uint256 itemBonus = getStakeBonusByIndex(token, tokenReceiving, i);
                totalBonus = safeAdd(totalBonus, itemBonus);
            }
        }

        return totalBonus;
    }

    function getStakeBonusByIndex(ERC20 token, ERC20 tokenReceiving, uint i) public view returns(uint256 result) 
    {
        uint256 itemBonus = 0;

        if(i >= 0)
        {
            address tokenAddress = address(token);
            address tokenReceivingAddress = address(tokenReceiving);

            StakeRecord[] memory stakeList = stakerecords[msg.sender][tokenAddress][tokenReceivingAddress];

            if(stakeList.length > i)
            {
                uint256 earningsPerSecond = earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress];

                if(earningsPerSecond > 0)
                {
                    StakeRecord memory stakeItem = stakeList[i];
                    uint256 stakeSeconds = safeSub(block.timestamp, stakeItem.time);

                    if(stakeRewardByAmount == false)
                    {
                        //Pay per share participation
                        uint256 share = getStakeShareFromStakeRecord(stakeItem, tokenAddress, tokenReceivingAddress);
                        itemBonus = safeMul(earningsPerSecond, stakeSeconds);
                        itemBonus = safeMul(itemBonus, share);
                        itemBonus = safeDiv(itemBonus, ONE_HUNDRED); //getStakeShareFromStakeRecord function uses 100% scale, transform to 1 using div ONE_HUNDRED
                    }
                    else
                    {
                        //Pay per staked amount
                        uint decimals = 18;
                        if(tokenAddress != networkcoinaddress)
                        {
                            decimals = getTokenDecimals(token);
                        }
                        
                        itemBonus = safeMul(earningsPerSecond, stakeSeconds);
                        itemBonus = safeMulFloat(itemBonus, stakeItem.total, decimals);
                    }
                }
            }
        }

        return itemBonus;
    }

    function getStakeBonusForecast(ERC20 token, ERC20 tokenReceiving, uint256 stakeAmount, uint256 stakeSecondsForecast) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 earningsPerSecond = earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress];

        uint256 itemBonus = 0;

        if(earningsPerSecond > 0)
        {
            if(stakeRewardByAmount == false)
            {
                //Pay per share participation
                uint256 share = getStakeShareForecast(stakeAmount, tokenAddress, tokenReceivingAddress);
                itemBonus = safeMul(earningsPerSecond, stakeSecondsForecast);
                itemBonus = safeMul(itemBonus, share);
                itemBonus = safeDiv(itemBonus, ONE_HUNDRED); //getStakeShareForecast function uses 100% scale, transform to 1 using div ONE_HUNDRED
            }
            else
            {
                //Pay per staked amount
                uint decimals = 18;
                if(tokenAddress != networkcoinaddress)
                {
                    decimals = getTokenDecimals(token);
                }

                itemBonus = safeMul(earningsPerSecond, stakeSecondsForecast);
                itemBonus = safeMulFloat(itemBonus, stakeAmount, decimals);
            }
        }

        return itemBonus;
    }

    function getStakeCount(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        return getStakeCountForPlayer(msg.sender, token, tokenReceiving);
    }

    function getStakeCountForPlayer(address player, ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        StakeRecord[] memory stakeList = stakerecords[player][tokenAddress][tokenReceivingAddress];
        return stakeList.length;
    }

    //Amount of stake at all - for all users
    function getStakeTotalAmount(ERC20 token, ERC20 tokenReceiving) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 totalStakedForToken = totalStaked[tokenAddress][tokenReceivingAddress];
        return totalStakedForToken;
    }

    function getStakeRecord(ERC20 token, ERC20 tokenReceiving, uint stakeIndex) external view returns(StakeRecord memory result) 
    {
        return getStakeRecordForPlayer(msg.sender, token, tokenReceiving, stakeIndex);
    }

    function getStakeRecordForPlayer(address player, ERC20 token, ERC20 tokenReceiving, uint stakeIndex) public view returns(StakeRecord memory result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        StakeRecord[] memory stakeList = stakerecords[player][tokenAddress][tokenReceivingAddress];

        require(stakeList.length > stakeIndex, 'STAKE: Invalid stake index record');

        StakeRecord memory stakeItem = stakeList[stakeIndex];

        return stakeItem;
    }

    function getStakeShare(ERC20 token, ERC20 tokenReceiving, uint stakeIndex) public view returns(uint256 result) 
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        StakeRecord[] memory stakeList = stakerecords[msg.sender][tokenAddress][tokenReceivingAddress];

        require(stakeList.length > stakeIndex, 'STAKE: Invalid stake index record');

        StakeRecord memory stakeItem = stakeList[stakeIndex];

        uint share = getStakeShareFromStakeRecord(stakeItem, tokenAddress, tokenReceivingAddress);

        return share;
    }

    function getStakeShareFromStakeRecord(StakeRecord memory stakeItem, address tokenAddress, address tokenReceivingAddress) private view returns(uint256 result)
    {
        uint256 stakeItemAmount = stakeItem.total;

        uint256 totalStakedForToken = totalStaked[tokenAddress][tokenReceivingAddress];

        uint256 share = 0;
        if(totalStakedForToken > 0)
        {
            uint256 sharePercentPart = safeMul(stakeItemAmount, ONE_HUNDRED);
            share = safeDiv(sharePercentPart, totalStakedForToken);
        }

        return share;
    }

    function getStakeShareForecast(uint256 stakeAmount, address tokenAddress, address tokenReceivingAddress) public view returns(uint256 result)
    {
        uint256 totalStakedSimulationForToken = safeAdd(totalStaked[tokenAddress][tokenReceivingAddress], stakeAmount);

        uint256 share = 0;
        uint256 sharePercentPart = safeMul(stakeAmount, ONE_HUNDRED);
        share = safeDiv(sharePercentPart, totalStakedSimulationForToken);

        return share;
    }

    function unstakeToken(ERC20 token, ERC20 tokenReceiving, uint stakeIndex) external {
        unstakeTokenForPlayer(msg.sender, token, tokenReceiving, stakeIndex);
    }

    function unstakeTokenForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving, uint stakeIndex) private {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        StakeRecord[] memory stakeList = stakerecords[playerAddress][tokenAddress][tokenReceivingAddress];
        StakedBalance memory stakeBalance = stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress];

        require(stakeList.length > stakeIndex, 'STAKE: Invalid stake index record');

        StakeRecord memory stakeItem = stakeList[stakeIndex];

        require(stakeBalance.total >= stakeItem.total, 'STAKE: Invalid stake balance');

        uint256 currentTotal = balances[playerAddress][tokenAddress][tokenReceivingAddress].total;
        uint256 currentTotalStaked = stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total;

        uint256 stakeBonus = 0;

        if(getStakeCount(token, tokenReceiving) > stakeIndex)
        {
            stakeBonus = getStakeBonusByIndex(token, tokenReceiving, stakeIndex);
        }

        //Reduce stake balance
        stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total = safeSub(currentTotalStaked, stakeItem.total);

        //Increase deposit balance with STAKE + BONUS when stake and profit is the same, otherwise separate increase for STAKE and BONUS as accumulated Earning
        if(tokenAddress == tokenReceivingAddress)
        {
            balances[playerAddress][tokenAddress][tokenReceivingAddress].total = safeAdd(currentTotal, safeAdd(stakeItem.total, stakeBonus) );

            //Increase general deposit amount + BONUS
            totalDeposited[tokenAddress][tokenReceivingAddress] = safeAdd(totalDeposited[tokenAddress][tokenReceivingAddress], safeAdd(stakeItem.total, stakeBonus) );
        }
        else
        {
            balances[playerAddress][tokenAddress][tokenReceivingAddress].total = safeAdd(currentTotal, stakeItem.total );

            //Increase general deposit amount
            totalDeposited[tokenAddress][tokenReceivingAddress] = safeAdd(totalDeposited[tokenAddress][tokenReceivingAddress], stakeItem.total );

            uint256 accumulatedEarning = balances[playerAddress][tokenAddress][tokenReceivingAddress].accumulatedEarning;
            if(stakeBonus > 0)
            {
                accumulatedEarning = safeAdd(accumulatedEarning, stakeBonus);
            }

            balances[playerAddress][tokenAddress][tokenReceivingAddress].accumulatedEarning = accumulatedEarning;
        }

        //Reduce total staked for token
        totalStaked[tokenAddress][tokenReceivingAddress] = safeSub(totalStaked[tokenAddress][tokenReceivingAddress], stakeItem.total);

        //Remove stake record
        uint stakesCount = stakerecords[playerAddress][tokenAddress][tokenReceivingAddress].length;

        //Swap last to index
        if(stakesCount > 1)
        {
            stakerecords[playerAddress][tokenAddress][tokenReceivingAddress][stakeIndex] = stakerecords[playerAddress][tokenAddress][tokenReceivingAddress][stakesCount - 1];
        }

        //Delete dirty last
        if(stakesCount > 0)
        {
            stakerecords[playerAddress][tokenAddress][tokenReceivingAddress].pop();
        }

        //If has no more staked balances for this token, remove player
        if(stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total == 0)
        {
            uint playerIndex = stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].playerIndex;

            //Swap index to last
            if(players[tokenAddress][tokenReceivingAddress].length > 1)
            {
                players[tokenAddress][tokenReceivingAddress][playerIndex] = players[tokenAddress][tokenReceivingAddress][   players[tokenAddress][tokenReceivingAddress].length - 1  ];
            }

            //Delete dirty last
            if(players[tokenAddress][tokenReceivingAddress].length > 0)
            {
                players[tokenAddress][tokenReceivingAddress].pop();
            }

            //Reindex players
            if(players[tokenAddress][tokenReceivingAddress].length > 0)
            {
                for(uint ix = 0; ix < players[tokenAddress][tokenReceivingAddress].length; ix++)
                {
                    stakedbalances[  players[tokenAddress][tokenReceivingAddress][ix].id  ][tokenAddress][tokenReceivingAddress].playerIndex = ix;
                }
            }
        }
        
        emit OnUnstake(playerAddress, tokenAddress, tokenReceivingAddress, stakeItem.total);
    }

    function getEarningsPerSecondPerShareOrAmountInWei(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress];
    }

    function setEarningsPerSecondPerShareOrAmountInWei(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getFeePercentOnStake(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return feepercentonstake[tokenAddress][tokenReceivingAddress];
    }

    function setFeePercentOnStake(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        
        require(value <= ONE_HUNDRED, "STAKE: Invalid percent fee value");

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        feepercentonstake[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getMaxDepositTokenInWei(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return maxDeposit[tokenAddress][tokenReceivingAddress];
    }

    function setMaxDepositTokenInWei(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        maxDeposit[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getMinDepositTokenInWei(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return minDeposit[tokenAddress][tokenReceivingAddress];
    }

    function setMinDepositTokenInWei(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        minDeposit[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getMaxWithdrawTokenInWei(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return maxWithdraw[tokenAddress][tokenReceivingAddress];
    }

    function setMaxWithdrawTokenInWei(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        maxWithdraw[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getMinWithdrawTokenInWei(ERC20 token, ERC20 tokenReceiving) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return minWithdraw[tokenAddress][tokenReceivingAddress];
    }

    function setMinWithdrawTokenInWei(ERC20 token, ERC20 tokenReceiving, uint256 value) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        minWithdraw[tokenAddress][tokenReceivingAddress] = value;

        return true;
    }

    function getDepositAccumulatedEarningsForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving) external view returns(uint256 result) 
    {
        //Value when unstake earning token is different from stake token

        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        return balances[playerAddress][tokenAddress][tokenReceivingAddress].accumulatedEarning;
    }

    function getStakeBalanceForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving) external view returns(uint256 result) 
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total;
    }

    function getStakeBonusByIndexForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving, uint i) public view returns(uint256 result) 
    {
        uint256 itemBonus = 0;

        if(i >= 0)
        {
            address tokenAddress = address(token);
            address tokenReceivingAddress = address(tokenReceiving);

            StakeRecord[] memory stakeList = stakerecords[playerAddress][tokenAddress][tokenReceivingAddress];

            if(stakeList.length > i)
            {
                uint256 earningsPerSecond = earningspersecondspershareoramount[tokenAddress][tokenReceivingAddress];

                if(earningsPerSecond > 0)
                {
                    StakeRecord memory stakeItem = stakeList[i];
                    uint256 stakeSeconds = safeSub(block.timestamp, stakeItem.time);

                    if(stakeRewardByAmount == false)
                    {
                        //Pay per share participation
                        uint256 share = getStakeShareFromStakeRecord(stakeItem, tokenAddress, tokenReceivingAddress);
                        itemBonus = safeMul(earningsPerSecond, stakeSeconds);
                        itemBonus = safeMul(itemBonus, share);
                        itemBonus = safeDiv(itemBonus, ONE_HUNDRED); //getStakeShareFromStakeRecord function uses 100% scale, transform to 1 using div ONE_HUNDRED
                    }
                    else
                    {
                        //Pay per staked amount
                        uint decimals = 18;
                        if(tokenAddress != networkcoinaddress)
                        {
                            decimals = getTokenDecimals(token);
                        }

                        itemBonus = safeMul(earningsPerSecond, stakeSeconds);
                        itemBonus = safeMulFloat(itemBonus, stakeItem.total, decimals);
                    }
                }
            }
        }

        return itemBonus;
    }

    function clearDepositBalanceForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving) public
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 currentTotal = balances[playerAddress][tokenAddress][tokenReceivingAddress].total;

        //Reduce general deposit amount
        totalDeposited[tokenAddress][tokenReceivingAddress] = safeSub(totalDeposited[tokenAddress][tokenReceivingAddress], currentTotal);

        //Set user balance to Zero
        balances[playerAddress][tokenAddress][tokenReceivingAddress].total = 0;

        //remove player
        uint playerIndex = balances[playerAddress][tokenAddress][tokenReceivingAddress].playerIndex;

        //Swap index to last
        uint playersCount = depositplayers[tokenAddress][tokenReceivingAddress].length;
        if(playersCount > 1)
        {
            depositplayers[tokenAddress][tokenReceivingAddress][playerIndex] = depositplayers[tokenAddress][tokenReceivingAddress][playersCount - 1];
        }

        //Delete dirty last
        if(playersCount > 0)
        {
            depositplayers[tokenAddress][tokenReceivingAddress].pop();
        }
        
        //Reindex players
        if(depositplayers[tokenAddress][tokenReceivingAddress].length > 0)
        {
            for(uint ix = 0; ix < depositplayers[tokenAddress][tokenReceivingAddress].length; ix++)
            {
                balances[  depositplayers[tokenAddress][tokenReceivingAddress][ix].id  ][tokenAddress][tokenReceivingAddress].playerIndex = ix;
            }
        }
    }

    function clearStakeBalanceForPlayer(address playerAddress, ERC20 token, ERC20 tokenReceiving) public
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 amount = stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total;

        //Set Stake Balance to Zero
        stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].total = 0;

        //Reduce total staked for token
        totalStaked[tokenAddress][tokenReceivingAddress] = safeSub(totalStaked[tokenAddress][tokenReceivingAddress], amount);

        //Clear stake records of user
        uint stakesCount = stakerecords[playerAddress][tokenAddress][tokenReceivingAddress].length;
        if(stakesCount > 0)
        {
            delete stakerecords[playerAddress][tokenAddress][tokenReceivingAddress];
        }

        //Remove player
        uint playerIndex = stakedbalances[playerAddress][tokenAddress][tokenReceivingAddress].playerIndex;

        //Swap index to last
        uint playersCount = players[tokenAddress][tokenReceivingAddress].length;
        if(playersCount > 1)
        {
            players[tokenAddress][tokenReceivingAddress][playerIndex] = players[tokenAddress][tokenReceivingAddress][playersCount - 1];
        }

        //Delete dirty last
        if(playersCount > 0)
        {
            players[tokenAddress][tokenReceivingAddress].pop();
        }

        //Reindex players
        if(players[tokenAddress][tokenReceivingAddress].length > 0)
        {
            for(uint ix = 0; ix < players[tokenAddress][tokenReceivingAddress].length; ix++)
            {
                stakedbalances[  players[tokenAddress][tokenReceivingAddress][ix].id  ][tokenAddress][tokenReceivingAddress].playerIndex = ix;
            }
        }
    }

    function forcePlayerToUnstake(address playerAddress, ERC20 token, ERC20 tokenReceiving, uint stakeIndex) public
    {
        require(msg.sender == owner, 'Forbidden');
        unstakeTokenForPlayer(playerAddress, token, tokenReceiving, stakeIndex);
    }

    function forceAllToUnstake(ERC20 token, ERC20 tokenReceiving) public
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        Player[] memory currentPlayers = players[tokenAddress][tokenReceivingAddress];
        uint totalPlayers = currentPlayers.length;

        for(uint ix = 0; ix < totalPlayers; ix++)
        {
            address currentPlayerInStake = currentPlayers[ix].id;
            StakeRecord[] memory playerStakeList = stakerecords[currentPlayerInStake][tokenAddress][tokenReceivingAddress];
            uint totalStakesOfPlayer = playerStakeList.length;

            for(uint ixSt = 0; ixSt < totalStakesOfPlayer; ixSt++)
            {
                uint indexToUnstake = 0; //After unstake next item always remains at zero position
                unstakeTokenForPlayer(currentPlayerInStake, token, tokenReceiving, indexToUnstake);
            }
        }
    }

    function forcePlayerToClaimAndWithdraw(address playerAddress, ERC20 token, ERC20 tokenReceiving) public
    {
        require(msg.sender == owner, 'Forbidden');
        
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        uint256 amountInDeposit = balances[playerAddress][tokenAddress][tokenReceivingAddress].total;
                                                
        if(amountInDeposit > 0)
        {
            withdrawTokenForPlayer(playerAddress, token, tokenReceiving, amountInDeposit, true);                
        }
    }

    function forceAllToClaimAndWithdraw(ERC20 token, ERC20 tokenReceiving) public
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        Player[] memory currentPlayers = depositplayers[tokenAddress][tokenReceivingAddress];
        uint totalPlayers = currentPlayers.length;

        for(uint ix = 0; ix < totalPlayers; ix++)
        {
            address currentPlayerInDeposit = currentPlayers[ix].id;
            uint256 amountInDeposit = balances[currentPlayerInDeposit][tokenAddress][tokenReceivingAddress].total;
                                                   
            if(amountInDeposit > 0)
            {
                withdrawTokenForPlayer(currentPlayerInDeposit, token, tokenReceiving, amountInDeposit, true);
            }
        }
    }

    function transferFund(ERC20 token, address to, uint256 amountInWei) external
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);

        //Withdraw of deposit value
        if(tokenAddress != networkcoinaddress)
        {
            //Withdraw token
            token.transfer(to, amountInWei);
        }
        else
        {
            //Withdraw Network Coin
            payable(to).transfer(amountInWei);
        }
    }

    function supplyNetworkCoin() payable external {
        require(msg.sender == owner, 'Forbidden');
        // nothing else to do!
    }

    function setActiveStake(ERC20 token, ERC20 tokenReceiving, bool value) public
    {
        require(msg.sender == owner, 'Forbidden');

        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);
        activeStake[tokenAddress][tokenReceivingAddress] = value;

        if(value == false)
        {
            forceAllToUnstake(token, tokenReceiving);
        }
    }

    function getActiveStake(ERC20 token, ERC20 tokenReceiving) public view returns (bool result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return activeStake[tokenAddress][tokenReceivingAddress];
    }

    function getStakeFeeCount(ERC20 token, ERC20 tokenReceiving) external view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return feeonstakerecords[tokenAddress][tokenReceivingAddress].length;
    }

    function getStakeFeeByIndex(ERC20 token, ERC20 tokenReceiving, uint256 index) external view returns (StakeFee memory result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        return feeonstakerecords[tokenAddress][tokenReceivingAddress][index];
    }

    function getStakePlayersCount(ERC20 token, ERC20 tokenReceiving) external view returns (uint256 result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        Player[] memory currentPlayers = players[tokenAddress][tokenReceivingAddress];
        uint totalPlayers = currentPlayers.length;

        return totalPlayers;
    }

    function getStakePlayersByIndex(ERC20 token, ERC20 tokenReceiving, uint256 index) external view returns (address result)
    {
        address tokenAddress = address(token);
        address tokenReceivingAddress = address(tokenReceiving);

        Player[] memory currentPlayers = players[tokenAddress][tokenReceivingAddress];

        require(currentPlayers.length > index, 'STAKE: Index out of bounds');

        address playerAddress = currentPlayers[index].id;

        return playerAddress;
    }

    function getApprovedAllowance(ERC20 token) public view returns (uint256 result)
    {
        address tokenAddress = address(token);
        require(tokenAddress != networkcoinaddress, 'STAKE: Network Coin could not be used with allowance.');
        uint256 allowance = token.allowance(msg.sender, address(this));
        return allowance;
    }

    function getUserTokenBalance(ERC20 token) public view returns(uint256 result)
    {
        uint256 value;
        address tokenAddress = address(token);
        if(tokenAddress != networkcoinaddress)
        {
            value = token.balanceOf(msg.sender);
        }
        else
        {
            value = msg.sender.balance;
        }
        
        return value;
    }

    function getTokenBalanceOf(ERC20 token) public view returns(uint256 result)
    {
        uint256 value;
        address tokenAddress = address(token);
        if(tokenAddress != networkcoinaddress)
        {
            value = token.balanceOf(address(this));
        }
        else
        {
            value = address(this).balance;
        }
        
        return value;
    }

    function getTokenDecimals(ERC20 token) public view returns(uint8 result)
    {
        uint8 defaultDecimals = 18;

        try token.decimals() returns (uint8 v) 
        {
            return (v);
        } 
        catch (bytes memory /*lowLevelData*/) 
        {
            return (defaultDecimals);
        }
    }

    function getMe() public view returns(address result)
    {
        return msg.sender;
    }

    function setOwner(address newValue) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');

        owner = newValue;
        return true;
    }

    function setFeeTo(address newValue) external returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');

        feeTo = newValue;
        return true;
    }

    function setNetworkCoinAddress(address newValue) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');

        networkcoinaddress = newValue;
        return true;
    }

    function setNetworkCoinSymbol(string memory newValue) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');

        networkcoinsymbol = newValue;
        return true;
    }

    function setStakeRewardByAmount(bool newValue) public returns (bool success)
    {
        require(msg.sender == owner, 'Forbidden');

        stakeRewardByAmount = newValue;
        return true;
    }

    /*
    function simulateEarnings(ERC20 token, uint256 earningsPerSecond, uint256 stakeSeconds, uint256 totalStakedInWei) public view returns (uint256 result)
    {
        uint decimals = 18;
        if(address(token) != networkcoinaddress)
        {
            decimals = token.decimals();
        }
        uint256 itemBonus = safeMul(earningsPerSecond, stakeSeconds);
        itemBonus = safeMulFloat(itemBonus, totalStakedInWei, decimals);
        return itemBonus;
    }

    function simulateEarningsByTS(ERC20 token, uint256 earningsPerSecond, uint256 totalStakedInWei, uint256 startTS) public view returns (uint256 result)
    {
        uint decimals = 18;
        if(address(token) != networkcoinaddress)
        {
            decimals = token.decimals();
        }

        uint256 stakeSeconds = getTSDiffFrom(startTS);

        uint256 itemBonus = safeMul(earningsPerSecond, stakeSeconds);
        itemBonus = safeMulFloat(itemBonus, totalStakedInWei, decimals);
        return itemBonus;
    }

    function getTSDiffFrom(uint256 startTS) public view returns (uint256 result)
    {
        uint256 stakeSeconds = safeSub(block.timestamp, startTS);
        return stakeSeconds;
    }
    */

    //Safe Math Functions
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a + b;
        require(c >= a, "STAKE: SafeMath: addition overflow");

        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeSub(a, b, "STAKE: subtraction overflow");
    }

    function safeSub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        if (a == 0) 
        {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "STAKE: multiplication overflow");

        return c;
    }

    function safeMulFloat(uint256 a, uint256 b, uint decimals) internal pure returns(uint256)
    {
        if (a == 0 || decimals == 0)  
        {
            return 0;
        }

        uint result = safeDiv(safeMul(a, b), safePow(10, uint256(decimals)));

        return result;
    }

    function safePow(uint256 n, uint256 e) internal pure returns(uint256)
    {

        if (e == 0) 
        {
            return 1;
        } 
        else if (e == 1) 
        {
            return n;
        } 
        else 
        {
            uint256 p = safePow(n,  safeDiv(e, 2));
            p = safeMul(p, p);

            if (safeMod(e, 2) == 1) 
            {
                p = safeMul(p, n);
            }

            return p;
        }
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeDiv(a, b, "STAKE: division by zero");
    }

    function safeDiv(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function safeMod(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        return safeMod(a, b, "STAKE: modulo by zero");
    }

    function safeMod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b != 0, errorMessage);
        return a % b;
    }
}