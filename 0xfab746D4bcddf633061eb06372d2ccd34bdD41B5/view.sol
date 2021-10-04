// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "library.sol";

contract PandaView {
    using SafeMath for uint256;
    
    struct BuyerData {
        uint round;
        uint256 balance;
        uint expiryDate;
        uint strikePrice;
        uint settlePrice;
    }
    
    struct PoolerData {
        uint expiryDate;
        uint totalPremiums;
        uint accPremiumShare;
    }
    
    /**
     * @dev get a buyer's rounds data between [now - duration, now]
     * @param option the option contract to collect.
     * @param account collect position information for this account.
     * @param ago collect the information from 'ago' seconds until now.
     */
    function getBuyerRounds(IOption option, address account, uint ago) external view returns(
        uint [] memory rs,
        uint256 [] memory balances, 
        uint [] memory expiryDates, 
        uint [] memory strikePrices,
        uint [] memory settlePrices) 
        {
        uint maxRounds = ago / option.getDuration();
        BuyerData[] memory rounds = new BuyerData[](maxRounds);
        
        uint roundCount;
        ago = block.timestamp.sub(ago);
        
        for (uint r = option.getRound(); r > 0 ;r--) {
            uint expiryDate = option.getRoundExpiryDate(r);
            if (expiryDate < ago){
                break;
            }
            
            uint256 balance = option.getRoundBalanceOf(r, account);
            if (balance > 0) { // found position
                rounds[roundCount].round = r;
                rounds[roundCount].balance = balance;
                rounds[roundCount].expiryDate = expiryDate;
                rounds[roundCount].strikePrice = option.getRoundStrikePrice(r);
                rounds[roundCount].settlePrice = option.getRoundSettlePrice(r);
                roundCount++;
            }
        }
        
        // flatten struct
        rs = new uint256[](roundCount);
        balances = new uint256[](roundCount);
        expiryDates = new uint[](roundCount);
        strikePrices = new uint[](roundCount);
        settlePrices = new uint[](roundCount);
        
        for (uint i = 0; i < roundCount; i++) {
            rs[i] = rounds[i].round;
            balances[i] = rounds[i].balance;
            expiryDates[i] = rounds[i].expiryDate;
            strikePrices[i] = rounds[i].strikePrice;
            settlePrices[i] = rounds[i].settlePrice;
        }
    }
    
    /**
     * @dev get a poolers's round data between [now - duration, now]
     * @param option the option contract to collect.
     * @param ago collect the information from 'ago' seconds until now.
     */
    function getPoolerRounds(IOption option, uint ago) external view returns(
        uint [] memory expiryDates,
        uint [] memory totalPremiums,
        uint [] memory accPremiumShares) 
        {
        uint maxRounds = ago / option.getDuration();
        PoolerData[] memory rounds = new PoolerData[](maxRounds);
        
        uint roundCount;
        ago = block.timestamp.sub(ago);
        
        for (uint r = option.getRound(); r > 0 ;r--) {
            uint expiryDate = option.getRoundExpiryDate(r);
            if (expiryDate < ago){
                break;
            }
        
            rounds[roundCount].expiryDate = expiryDate;
            rounds[roundCount].totalPremiums = option.getRoundTotalPremiums(r);
            rounds[roundCount].accPremiumShare = option.getRoundAccPremiumShare(r);
            roundCount++;
        }
        
        // flatten struct
        expiryDates = new uint[](roundCount);
        totalPremiums = new uint[](roundCount);
        accPremiumShares = new uint[](roundCount);
        
        for (uint i = 0; i < roundCount; i++) {
            expiryDates[i] = rounds[i].expiryDate;
            totalPremiums[i] = rounds[i].totalPremiums;
            accPremiumShares[i] = rounds[i].accPremiumShare;
        }
    }
}