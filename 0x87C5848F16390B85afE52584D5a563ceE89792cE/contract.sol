pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

interface BnbShare {
    function count() external view returns (uint);
    function allShare(uint ShareID, uint ReplyID) external view returns (address,string memory,uint,bool,string memory);
}

interface BnbShareLike {
    function allLike(uint ShareID, uint ReplyID) external view returns (uint);
}

interface BnbShareReward {
    function getSum(uint ShareID, uint ReplyID) external view returns (uint);
}



contract BnbShareQuery {
    BnbShare BS = BnbShare(0xC32D83ffbFe78673e9C79ccE8694Cb435893e738);
    BnbShareLike BSL = BnbShareLike(0x4bb56E1ec17e97457cb2736CeE4cD3Cd0e1e184B);
    BnbShareReward BSR = BnbShareReward(0xE200D20b6A242142D9671F4eBc401AE33d491Eeb);

    struct oneQuery {
        address sender;
        string nickname;
        uint timestamp;
        bool AllowUpdated;
        string content;
        uint like;
        uint reward;
    }

    function get(uint ShareID, uint ReplyID) view public returns (oneQuery memory) {
        uint timestamp;
        address sender; 
        string memory nickname;
        string memory content;
        bool AllowUpdated;
        uint like;
        uint reward;
        
        (sender, nickname, timestamp, AllowUpdated, content) = BS.allShare(ShareID, ReplyID);
        like = BSL.allLike(ShareID, ReplyID);
        reward = BSR.getSum(ShareID, ReplyID);
        
        oneQuery memory answer = oneQuery(sender, nickname, timestamp, AllowUpdated, content, like, reward);
        
        return answer;
    }
}