pragma solidity >=0.5.0;

interface IERC20{
    function transfer(address to, uint value) external returns (bool) ;
}

contract Tranfer {

    address public owner;
    address public token;

    constructor(address _token) public {
        owner = msg.sender;
        token = _token;
    }

    function updateOwner(address _owner) external {
        require(owner == msg.sender,"permission deny");
        owner = _owner;
    }

    function updateToken(address _token) external {
        require(owner == msg.sender,"permission deny");
        token = _token;
    }

    function batchTransfer( address[] calldata _receivers ,  uint256[] calldata _amounts ) external {
        require(owner == msg.sender,"permission deny");
        require(_receivers.length == _amounts.length ,"params length non-uniform");
        require(_receivers.length > 0 ,"empty params");
        for(uint256 i = 0 ; i < _receivers.length;i++) {
            IERC20(token).transfer(_receivers[i], _amounts[i]);
        }
    }
}