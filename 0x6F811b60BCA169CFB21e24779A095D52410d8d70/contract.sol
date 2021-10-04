// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract Whitelisted is Ownable {
    bool isWhitelistStarted = false;

    mapping(address => uint8) private whitelist;

    modifier onlyWhitelisted {
        require(isWhitelisted(msg.sender), "Not whitelisted");
        _;
    }

    function getWhitelistedZone(address _purchaser) public view returns (uint8) {
        return whitelist[_purchaser] > 0 ? whitelist[_purchaser] : 0;
    }

    function isWhitelisted(address _purchaser) public view returns (bool){
        return whitelist[_purchaser] > 0;
    }

    function joinWhitelist(address _purchaser, uint8 _zone) public {
        require(isWhitelistStarted == true, "Whitelist not started");
        whitelist[_purchaser] = _zone;
    }

    function deleteFromWhitelist(address _purchaser) public onlyOwner {
        whitelist[_purchaser] = 0;
    }

    function addToWhitelist(address[] memory purchasers, uint8 _zone) public onlyOwner {
        for (uint256 i = 0; i < purchasers.length; i++) {
            whitelist[purchasers[i]] = _zone;
        }
    }

    function startWhitelist(bool _status) public onlyOwner {
        isWhitelistStarted = _status;
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Airdrop is Ownable, Whitelisted {
    bool public isPaused = false;

    mapping(address => bool) private claimedList;

    address public rewardToken;
    uint256 public rewardAmount;

    modifier onlyNotClaimed {
        require(!isClaimed(msg.sender), "Claimed");
        _;
    }

    constructor(
        address _token,
        uint256 _amount
    ) {
        require(_token != address(0),"Invalid token");
        require(_amount > 0,"Invalid amount");

        rewardToken = _token;
        rewardAmount = _amount;
    }

    function isClaimed(address _sender) public view returns (bool){
        return claimedList[_sender] == true;
    }

    function _setClaimed(address _sender) private {
        claimedList[_sender] = true;
    }

    function claim() external onlyWhitelisted onlyNotClaimed{
        require(!isPaused, "Airdrop paused");
        
        require(IBEP20(rewardToken).transfer(msg.sender, rewardAmount), "Transfer failed");
        _setClaimed(msg.sender);
    }

    function setPaused(bool _status) external onlyOwner{
        isPaused = _status;
    }

    function setRewardToken(address newAddress) external onlyOwner{
        rewardToken = newAddress;
    }
    
    function setRewardAmount(uint256 newAmount) external onlyOwner{
        rewardAmount = newAmount;
    }

    function retrieveTokens(address token, uint amount) external onlyOwner{
        uint balance = IBEP20(token).balanceOf(address(this));

        if(amount > balance){
            amount = balance;
        }

        require(IBEP20(token).transfer(msg.sender, amount), "Transfer failed");
    }

    function retrieveBNB(uint amount) external onlyOwner{
        uint balance = address(this).balance;

        if(amount > balance){
            amount = balance;
        }

        (bool success,) = payable(msg.sender).call{ value: amount }("");
        require(success, "Failed");
    }
}