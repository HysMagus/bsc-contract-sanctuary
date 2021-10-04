pragma solidity ^0.7.4;

contract SimpleContract {
    string message;
    
    function setMessage(string memory _message) public {
        message = _message;
    }
}