pragma solidity ^0.6.0;

import './ERC721.sol';
import './Counters.sol';

contract BigProm30 is ERC721{
    
    
    using Counters for Counters.Counter;

    Counters.Counter private id;

    constructor (string memory name,string memory symbol) public ERC721(name,symbol) {
        
    }
    
    function issueToken(address user,string memory tokenURI) public {
        require(msg.sender == admin);
        id.increment();

        uint256 _id = id.current();
        _safeMint(user,_id);
        _setTokenURI(_id,tokenURI);
    }
    

}
