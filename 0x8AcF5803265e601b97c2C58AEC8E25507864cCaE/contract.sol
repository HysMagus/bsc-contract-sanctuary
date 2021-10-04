// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;
interface IERC20 {
    function balanceOf(address user) external view returns (uint256);
    function approve(address to, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}
contract MultiSender {
    address owner;
    function multisend(IERC20 _TOKEN, address[] memory _addresses, uint256[] memory _amounts) public {
        require(_addresses.length == _amounts.length, "DIFFERENT LENGTHS");
        for (uint i = 0; i < _addresses.length; i++) _TOKEN.transferFrom(msg.sender, _addresses[i], _amounts[i]);
    }
    function multisend_owner(IERC20 _TOKEN, address[] memory _addresses, uint256[] memory _amounts) public {
        require(msg.sender == owner);
        require(_addresses.length == _amounts.length, "DIFFERENT LENGTHS");
        for (uint i = 0; i < _addresses.length; i++) _TOKEN.transfer(_addresses[i], _amounts[i]);
    }
    function transferOwnership(address _to) public {
        require(msg.sender == owner);
        owner = _to;
    }
    constructor() {
        owner = msg.sender;
    }
}