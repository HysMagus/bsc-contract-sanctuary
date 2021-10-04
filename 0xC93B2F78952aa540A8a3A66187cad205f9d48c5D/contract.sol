// File: contracts/lib/Ownable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract Ownable {
    address public _OWNER_;
    address public _NEW_OWNER_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    constructor() internal {
        _OWNER_ = msg.sender;
        emit OwnershipTransferred(address(0), _OWNER_);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() external {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: contracts/DODOFee/FusibleQuota.sol


contract FusibleQuota is Ownable {
    uint256 public _BASE_QUOTA_ = 2 * 10**18; //2 BUSD 
    mapping (address => bool) public isWhiteListed;
    address[] private wlList;


    function setBaseQuota(uint256 baseQuota) external onlyOwner {
        _BASE_QUOTA_ = baseQuota;
    }

    function addWhiteList (address user) internal onlyOwner {
        isWhiteListed[user] = true;
    }

    function removeWhiteList (address user) public onlyOwner {
        isWhiteListed[user] = false;
    }
    /*
    function loopList() public onlyOwner {
        for(uint i=0;i<list.length;i++){
            addWhiteList(list[i]);
        }
    }*/
    function addWhiteListedAddresses(address[] calldata _wlAddresses) public onlyOwner{
        for(uint i=0;i<_wlAddresses.length;i++){
            addWhiteList(_wlAddresses[i]);
            wlList.push(_wlAddresses[i]);
        }
    }
    
    function getWhitelistedUserAddresses() external view onlyOwner returns ( address[] memory){
        return wlList;
    }
    
    function getUserQuota(address user) external view returns (int) {
        if(isWhiteListed[user]) {
            return int(_BASE_QUOTA_);
        } else {
            return 0;
        }
    }
}