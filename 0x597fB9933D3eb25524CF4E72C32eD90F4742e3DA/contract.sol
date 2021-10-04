// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

contract CashTree {
    mapping(address => uint) public leaves;
    mapping(address => uint) public acorns;
    mapping(address => uint) public squirrels;
    
    uint public growth = 1;
    uint public totalLeaves = 0;
    address payable public ceo;
    uint public leafPrice = 100000000000000000;
    
    constructor() {
        ceo = msg.sender;
    }
    
    function randomNumber(uint nonce) private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, leafPrice, totalLeaves, nonce)));
    }
    
    function squirrelLogic(address sender) private {
        if (randomNumber(42) % 4 == 0 || squirrels[msg.sender] == 0) {
            squirrels[sender] += 1;
        }
        
        if (squirrels[msg.sender] != 0 && randomNumber(69) % 4 == 0) {
            acorns[sender] += squirrels[sender];
        }
    }
    
    function buyLeaves(uint amount, address ref) public payable {
        require(msg.value >= leafPrice * amount);
        
        if (ref != msg.sender) {
            acorns[ref] += amount;
        }
        
        leaves[msg.sender] += amount;
        
        ceo.transfer(leafPrice * amount / 20);
        
        totalLeaves += amount;
        leafPrice += (leafPrice / 100) * amount * growth;
        
        squirrelLogic(msg.sender);
    }
    
    function exchangeAcorns() public {
        require(acorns[msg.sender] >= 10);
        leaves[msg.sender] += acorns[msg.sender] / 10;
        totalLeaves += acorns[msg.sender] / 10;
        acorns[msg.sender] -= (acorns[msg.sender] / 10) * 10;
    }
    
    function water() public {
        require(leaves[msg.sender] >= growth);
        leaves[msg.sender] -= growth;
        totalLeaves -= growth;
        
        growth += 1;
        
        squirrelLogic(msg.sender);
    }
    
    function sellLeaves() public payable {
        require(msg.value * 10 >= leafPrice);
        
        uint amount = 0;
        uint numLeaves = leaves[msg.sender];
        leaves[msg.sender] = 0;
        totalLeaves -= numLeaves;
        
        if (totalLeaves != 0) {
            amount = (address(this).balance / totalLeaves) * numLeaves;
        } else {
            amount = address(this).balance;
        }
        
        squirrelLogic(msg.sender);
        
        msg.sender.transfer(amount);
    }
    
}