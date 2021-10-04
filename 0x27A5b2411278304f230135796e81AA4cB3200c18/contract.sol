// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

abstract contract minERC20 {
    function transfer(address to, uint256 amount) external virtual returns (bool);
}

contract HoprMultisend {
    uint256 public amountToken = 1000000000000000000; //1e18
    uint256 public amountEth =     25000000000000000; // 0.025e18

    minERC20 public token = minERC20(0x9cf282412730c268f24fe877A3483ed230A3060c); // HOPR token for Titlis testnet on Binance Smart Chain
    address public owner = msg.sender;
    mapping(address=>bool) public isOperator; // stores addresses that are allowed to send
    
    constructor() {
        isOperator[msg.sender] = true;
    }
    
    receive() external payable {
        // nothing to do here, can be spent by operators via sendEth
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only allowed for owner");
        _;
    }
    
    modifier onlyOperator() {
        require(isOperator[msg.sender], "only allowed for operators");
        _;
    }
    
    function addOperator(address newOperator) external onlyOwner {
        isOperator[newOperator] = true;
    }
    
    function removeOperator(address operatorToRemove) external onlyOwner {
        isOperator[operatorToRemove] = false;
    }
    
    function sendToken(address[] calldata recipients) external onlyOperator {
        uint256 numRecipients = recipients.length;
        for (uint256 c = 0; c < numRecipients; c++) {
            require(token.transfer(recipients[c], amountToken), "token transfer failed");
        }
    }
    
    function sendEth(address payable[] calldata recipients) external onlyOperator {
        uint256 numRecipients = recipients.length;
        for (uint256 c = 0; c < numRecipients; c++) {
            recipients[c].transfer(amountEth);
        }
    }
    
    function changeAmountToken(uint256 newAmountToken) external onlyOwner {
        amountToken = newAmountToken;
    }
    
    function changeAmountEth(uint256 newAmountEth) external onlyOwner {
        amountEth = newAmountEth;
    }
    
    function transferOwnership(address newOwner) external onlyOwner { 
        owner = newOwner;
    }
    
}