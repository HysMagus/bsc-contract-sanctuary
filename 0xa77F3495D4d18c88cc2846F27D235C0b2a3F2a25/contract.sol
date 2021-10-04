pragma solidity ^0.6.0;

contract Owned {
    address payable public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address payable _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnershipTransferred(msg.sender, _newOwner);
    }
}


contract Mapping is Owned {
 
    mapping(string => address) public addressMap;

    function setAddressMap(string memory _coinaddress, address _address)
        public
        onlyOwner
    {
        addressMap[_coinaddress] = _address;
    }

    struct QueueBlock {
        address userid;
        string coin;
        string addr;
        string msg;
        string sig;
    }

    QueueBlock[] public coinsig;

    function reqSig(string memory _coin, string memory _addr, string memory _msg, string memory _sig) public  returns (uint256 arrayLength) {

        QueueBlock memory m;
        m.userid = msg.sender;
        m.coin = _coin;
        m.addr = _addr;
        m.msg = _msg;
        m.sig = _sig;
        
        coinsig.push(m);
        return coinsig.length;
    }
    
    
    
}