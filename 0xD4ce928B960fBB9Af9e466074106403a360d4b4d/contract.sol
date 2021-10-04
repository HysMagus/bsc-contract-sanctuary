pragma solidity >=0.6.0;

interface TRSRNFTInterface {
    function balanceOf(address account, uint256 id) external returns(uint256);
}
contract xxNFTManager {
    address private owner;
    TRSRNFTInterface private TRSRNFT;
    uint256[] public availableNFTIDs;
    
    struct Node {
        string nodeId;
        string nodeName;
    }
    mapping(uint256 => Node) private nodeMapping;
    
    mapping(address => mapping(uint256 => string)) private nftMapping;
    mapping(address => mapping(uint256 => string)) private memoMapping;
    
    constructor(address _TRSRNFTAddress) public {
        owner = msg.sender;
        TRSRNFT = TRSRNFTInterface(_TRSRNFTAddress);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    function getOwner() external view returns(address) {
        return owner;
    }
    
    function getTRSRNFTAddress() external view returns(TRSRNFTInterface) {
        return TRSRNFT;
    }
    
    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    function changeTRSRNFTAddress(address addr) external onlyOwner {
        TRSRNFT = TRSRNFTInterface(addr);
    }

    function bindXXNode(uint256 id, string calldata nodeId, string calldata nodeName) external onlyOwner {
        nodeMapping[id].nodeId = nodeId;
        nodeMapping[id].nodeName = nodeName;
    }
    
    function getXXNode(uint256 id) external view returns(string memory, string memory) {
        return (nodeMapping[id].nodeId, nodeMapping[id].nodeName);
    }
    
    function setAvailableNFTID(uint256[] calldata nftIds) external onlyOwner {
        availableNFTIDs = nftIds;
    }
    
    function validateNFT(uint256 nftId) external view returns(bool) {
        bool has = false;
        for(uint256 i = 0; i < availableNFTIDs.length; i++) {
            if(availableNFTIDs[i] == nftId) {
                has = true;
                break;
            }
        }
        return has;
    }
    
    function bindXXAccount(uint256 nftId, string calldata xxAddress) external {
        // Check if the msg.sender has NFT
        uint256 balance = TRSRNFT.balanceOf(msg.sender, nftId);
        if(balance > 0) nftMapping[msg.sender][nftId] = xxAddress;
    }
    
    function bindMemo(uint256 nftId, string calldata memo) external {
        uint256 balance = TRSRNFT.balanceOf(msg.sender, nftId);
        if(balance > 0) memoMapping[msg.sender][nftId] = memo;
    }
    
    function getBindingAccount(uint256 nftId) external view returns(string memory) {
        return nftMapping[msg.sender][nftId];
    }
    
    function getMemo(uint256 nftId) external view returns(string memory) {
        return memoMapping[msg.sender][nftId];
    }
    
    function getBindingDetail(uint256 nftId, address addr) external view onlyOwner returns(string memory, string memory) {
        return (nftMapping[addr][nftId], memoMapping[addr][nftId]);
    }
}