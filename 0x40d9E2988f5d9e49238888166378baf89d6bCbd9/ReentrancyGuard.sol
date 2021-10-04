//SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;


abstract contract ReentrancyGuard {
    bool private _notEntered;
    
    constructor ()  {
        _notEntered = true;
    }
    
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");
    
        // Any calls to nonReentrant after this point will fail
        _notEntered = false;
    
        _;
    
        _notEntered = true;
    }
}