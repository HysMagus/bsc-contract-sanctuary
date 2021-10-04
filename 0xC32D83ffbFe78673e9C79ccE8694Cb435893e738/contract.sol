pragma solidity ^0.4.13;

contract BnbShare {
    
    uint public count;
    address[] public link; // if there are other BnbShare contracts

    struct oneShare {
        address sender;
        string nickname;
        uint timestamp;
        bool AllowUpdated;
        string content;
    }
    mapping(uint => oneShare[]) public allShare;

    event EVENT(uint ShareID, uint ReplyID);

    function BnbShare() public {
        NewShare("Peilin Zheng", false, "Hello, BnbShare!");
    }

    function NewShare(string nickname, bool AllowUpdated, string content) public {
        allShare[count].push(oneShare(msg.sender, nickname, now, AllowUpdated, content)); // add a new share
        EVENT(count,0);
        count++;
    }

    function ReplyShare(uint ShareID, string nickname, bool AllowUpdated, string content) public {
        require(ShareID<count && ShareID>=0); // reply to a existed share
        allShare[ShareID].push(oneShare(msg.sender, nickname, now, AllowUpdated, content));
        EVENT(ShareID,allShare[ShareID].length-1);
    }

    function Update(uint ShareID, uint ReplyID, string content) public {
        require(msg.sender==allShare[ShareID][ReplyID].sender && allShare[ShareID][ReplyID].AllowUpdated);  // only sender can update the share or reply which is AllowUpdated
        allShare[ShareID][ReplyID].content = content;
        allShare[ShareID][ReplyID].timestamp = now;
        EVENT(ShareID,ReplyID);
    }
    
    function LengthOf(uint ShareID) public returns (uint) {
        return allShare[ShareID].length;
    }
}