
pragma solidity ^0.6.0;


import "./Ownable.sol";
import "./SafeMath.sol";
/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract PunksMarket is Ownable {
    using SafeMath for uint256;
    PunksInterface punks;
    
 
    struct userDeposits {
        address _owner;
    }
    struct Bid {
        uint256 punkID;
        uint256 bid;
        address payable _bidder;
    }
    struct listing {
        uint256 punk;
        address payable _owner;
        uint256 minBid;
        bool active;
    }
    mapping(uint256 => address) public UserDeposits;
    mapping(address => mapping (uint256 => Bid)) public userBids;
    mapping(uint256 => Bid) public punkBids;
    mapping(uint256 => listing) public punksForSale;
    uint256 public FEE = 500;
    
    function createListing(uint256 _punkID, uint256 _minBid)public returns (bool){
        require(checkOwnership(_punkID) == msg.sender, "You are not the owner");
        UserDeposits[_punkID] = msg.sender;
        punksForSale[_punkID].punk = _punkID;
        punksForSale[_punkID]._owner = msg.sender;
        punksForSale[_punkID].minBid = _minBid;
        punksForSale[_punkID].active = false;
        
    }
    function activateListing(uint256 _punkID) public returns (bool){
        require(checkOwnership(_punkID) == address(this), "Did not transfer punk to marketplace yet");
        require(punksForSale[_punkID]._owner == msg.sender, "invalid ownership");
        require(punksForSale[_punkID].active == false, "already listed for sale");
        punksForSale[_punkID].active = true;
    }
    
    function placeBid(uint256 _punkID, uint256 _Bid)public payable returns (bool) {
        require(punksForSale[_punkID].active == true, "not listed for sale");
        require(msg.value >= _Bid, "Did not send enough funds");
        require(punkBids[_punkID].bid < msg.value, "Bid below current bid");
        require(punksForSale[_punkID].minBid <= msg.value, "Bid below min. bid");
        if(punkBids[_punkID]._bidder != address(0x0)){
             punkBids[_punkID]._bidder.transfer(punkBids[_punkID].bid);
        }
        userBids[msg.sender][_punkID].bid  = msg.value;
        userBids[msg.sender][_punkID].punkID  = _punkID;
        punkBids[_punkID].bid = msg.value;
        punkBids[_punkID].punkID = _punkID;
        punkBids[_punkID]._bidder = msg.sender;
    
    }
    
    function withdrawPunk(uint256 _punkID) public returns (bool) {
        require(checkOwnership(_punkID) == address(this), "Not inside the contract, nothing to withdraw");
        require(UserDeposits[_punkID] == msg.sender, "You didn't deposit this");
        if(punkBids[_punkID]._bidder != address(0x0)){
             punkBids[_punkID]._bidder.transfer(punkBids[_punkID].bid);
        }
        punksForSale[_punkID].punk = 0;
        punksForSale[_punkID]._owner = address(0x0);
        punksForSale[_punkID].minBid = 0;
        punksForSale[_punkID].active = false;
        UserDeposits[_punkID] = address(0x0);
        punkBids[_punkID].bid = 0;
        punkBids[_punkID].punkID = _punkID;
        punkBids[_punkID]._bidder = address(0x0);
        punks.transferPunk(msg.sender, _punkID);
    }
    
    function acceptBid(uint256 _punkID) public returns (bool) {
        require(punksForSale[_punkID]._owner == msg.sender, "You don't own this listing");
        require(punkBids[_punkID].bid >= 0, "No bids to accept");
        require(address(this).balance >= punkBids[_punkID].bid, "Invalid amount");
        require(calculateFee(punkBids[_punkID].bid) > 0, "Invalid math");
        punks.transferPunk(punkBids[_punkID]._bidder,_punkID);
        punksForSale[_punkID]._owner.transfer(calculateFee(punkBids[_punkID].bid));
        punksForSale[_punkID].punk = 0;
        punksForSale[_punkID]._owner = address(0x0);
        punksForSale[_punkID].minBid = 0;
        punksForSale[_punkID].active = false;
        punkBids[_punkID].bid = 0;
        punkBids[_punkID]._bidder = address(0x0);
        UserDeposits[_punkID] = address(0x0);
        userBids[punkBids[_punkID]._bidder][_punkID].bid  = 0;
        userBids[punkBids[_punkID]._bidder][_punkID].punkID  = 0;
        userBids[punkBids[_punkID]._bidder][_punkID]._bidder  = address(0x0);
    }
    
    function calculateFee(uint256 _bid) internal view returns (uint256){
        return _bid.sub(_bid.mul(FEE).div(10000));
    }
    function setPunksContract(address _punks) public onlyOwner returns (bool){
        punks = PunksInterface(_punks);
        return true;
    }
    
    function checkOwnership(uint256 _punksID) internal view returns (address){
        return punks.punkIndexToAddress(_punksID);
    }
    
    function withdrawFees()  public onlyOwner returns (bool){
        msg.sender.transfer(address(this).balance);

    }
}

interface PunksInterface {
    function punkIndexToAddress(uint256 _punkId) external view returns (address);
    function balanceOf(address _account) external view returns (uint256);
    function transferPunk(address to, uint punkIndex) external;
   
}