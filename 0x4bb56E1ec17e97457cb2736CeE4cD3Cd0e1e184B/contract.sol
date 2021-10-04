pragma solidity ^0.4.13;

// Record the thumbs up for BnbShare
contract BnbShareLike {

    address public link = 0xc32d83ffbfe78673e9c79cce8694cb435893e738;  

    mapping(uint => mapping(uint => uint)) public allLike;

    function like(uint ShareID, uint ReplyID) public {
        allLike[ShareID][ReplyID]++;
    }
}