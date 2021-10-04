// Dependency file: contracts/modules/Ownable.sol

//SPDX-License-Identifier: MIT
// pragma solidity >=0.5.16;

contract Ownable {
    address public owner;

    event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'Ownable: FORBIDDEN');
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), 'Ownable: INVALID_ADDRESS');
        emit OwnerChanged(owner, _newOwner);
        owner = _newOwner;
    }

}


// Root file: contracts/AAAAOtherConfig.sol

pragma solidity >=0.5.16;
// import "contracts/modules/Ownable.sol";

contract AAAAOtherConfig is Ownable {
    mapping(address=>bool) public isToken;
    mapping(address=>bool) public disabledToken;

    function setToken(address _token, bool _value) onlyOwner external {
        isToken[_token] = _value;
    }

    function setDisabledToken(address _token, bool _value) onlyOwner external {
        disabledToken[_token] = _value;
    }

}