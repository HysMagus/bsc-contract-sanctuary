pragma solidity ^0.4.13;

interface BnbShare {
    function allShare(uint ShareID, uint ReplyID) returns (address,string,uint,bool,string);
}

// Enable users to reward authors from BnbShare and record the reward
contract BnbShareReward {
    BnbShare BS = BnbShare(0xc32d83ffbfe78673e9c79cce8694cb435893e738);
    
    struct oneReward {
        address from;
        uint value;
    }
    mapping(uint => mapping(uint => oneReward[])) public allRewards;
    
    function Reward(uint ShareID, uint ReplyID) payable public {
        address to;
        (to,,,,) = BS.allShare(ShareID,ReplyID); // get the author
        to.transfer(msg.value);
        allRewards[ShareID][ReplyID].push(oneReward(msg.sender, msg.value)); // record the reward
    }

    function getSum(uint ShareID, uint ReplyID) view public returns (uint) {
        uint sum = 0;
        for (uint i=0; i<allRewards[ShareID][ReplyID].length; ++i)
            sum += allRewards[ShareID][ReplyID][i].value;
        return sum;
    }
}