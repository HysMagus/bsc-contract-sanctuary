// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "library.sol";

contract PandaView {
    using SafeMath for uint256;
    
    struct BuyerData {
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
     */
    function getBuyerRounds(IOption option, address account, uint ago) external view returns(BuyerData[] memory) {
        uint duration = option.getDuration();
        uint maxRounds = ago / duration;
        
        BuyerData[] memory rounds = new BuyerData[](maxRounds);
        
        uint roundCount;
        uint monthAgo = block.timestamp.sub(ago);
        
        for (uint r = option.getRound(); r > 0 ;r--) {
            uint expiryDate = option.getRoundExpiryDate(r);
            if (expiryDate < monthAgo){
                break;
            }
            
            uint256 balance = option.getRoundBalanceOf(r, account);
            if (balance > 0) { // found position
                rounds[roundCount].balance = balance;
                rounds[roundCount].expiryDate = expiryDate;
                rounds[roundCount].strikePrice = option.getRoundStrikePrice(r);
                rounds[roundCount].settlePrice = option.getRoundSettlePrice(r);
                roundCount++;
            }
        }
        
        // copy to a smaller memory array
        if (roundCount < maxRounds) {
            BuyerData[] memory rs = new BuyerData[](roundCount);
            for (uint i = 0; i < roundCount; i++) {
                rs[i] = rounds[i];
            }
            return rs;
        }
        
        return rounds;
    }
    
    /**
     * @dev get a poolers's round data between [now - duration, now]
     */
    function getPoolerRounds(IOption option, uint ago) external view returns(PoolerData[] memory) {
        uint duration = option.getDuration();
        uint maxRounds = ago / duration;
        
        PoolerData[] memory rounds = new PoolerData[](maxRounds);
        
        uint roundCount;
        uint monthAgo = block.timestamp.sub(ago);
        
        for (uint r = option.getRound(); r > 0 ;r--) {
            uint expiryDate = option.getRoundExpiryDate(r);
            if (expiryDate < monthAgo){
                break;
            }
        
            rounds[roundCount].expiryDate = expiryDate;
            rounds[roundCount].totalPremiums = option.getRoundTotalPremiums(r);
            rounds[roundCount].accPremiumShare = option.getRoundAccPremiumShare(r);
            roundCount++;
        }
        
        // copy to a smaller memory array
        if (roundCount < maxRounds) {
            PoolerData[] memory rs = new PoolerData[](roundCount);
            for (uint i = 0; i < roundCount; i++) {
                rs[i] = rounds[i];
            }
            return rs;
        }
        
        return rounds;
    }
}