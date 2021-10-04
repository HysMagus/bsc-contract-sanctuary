//SPDX-License-Identifier:MIT

pragma solidity 0.8.6;

// This is a simple string repository for serverless decentralized apps

contract string_repository{

    string[64] repository;
    
    address public admin;

    constructor() {
        admin = msg.sender;
    }
    
    receive() external payable {
        revert(); // this contract does not accept funds
    }
    
    function store(string memory str,uint i) public {
        if(msg.sender!=admin) revert();
        repository[i]=str;
    }
    
    function get(uint i) public view returns (string memory){
        return repository[i];
    }
    
    function get6(uint startIndex) public view returns (string memory,string memory,string memory,string memory,string memory,string memory){
        return(repository[startIndex],repository[startIndex+1],repository[startIndex+2],repository[startIndex+3],repository[startIndex+4],repository[startIndex+5]);
    }
    
}