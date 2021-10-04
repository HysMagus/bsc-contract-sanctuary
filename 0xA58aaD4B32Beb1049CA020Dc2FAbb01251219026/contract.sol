pragma solidity ^0.5.8;

contract rel{
    address public owner;
    
    mapping(address => bool) public manager;
    address public saleAddr;
    
    mapping(address => address) public plyParent;
    mapping(address => uint256) public sonNumber;
    mapping(address => address[]) public sonList;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function setSaleAddr(address _saleAddr) public{
        require(msg.sender == owner,"only owner");
        saleAddr = _saleAddr;
    }
    
    function setParent(address _ply,address _parent) public {
        require(msg.sender == saleAddr,"only saleAddr");
        if(_parent == address(0)|| _ply == address(1)){
            return;
        }
        if(plyParent[_ply]==address(0)){
            plyParent[_ply] = _parent;
            sonList[_parent].push(_ply);
            sonNumber[_parent] +=1;
        }
    }
    
    function getPlyParent(address _ply) public view returns(address){
        return plyParent[_ply];
    }
    
    
    
    
    
    
}