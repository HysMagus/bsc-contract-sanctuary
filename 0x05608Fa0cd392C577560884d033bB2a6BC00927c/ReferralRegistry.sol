pragma solidity =0.6.6;

// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/access/Ownable.sol";

contract ReferralRegistry is Ownable {
    event ReferralAnchorCreated(address indexed user, address indexed referee);
    event ReferralAnchorUpdated(address indexed user, address indexed referee);
    event anchorManagerUpdated(address account, bool isManager);

    // stores addresses which are allowed to create new anchors
    mapping(address => bool) public isAnchorManager;

    // stores the address that referred a given user
    mapping(address => address) public referralAnchor;

    function createReferralAnchor(address _user, address _referee) external onlyAnchorManager {
        require(referralAnchor[_user] == address(0), "ReferralRegistry: ANCHOR_EXISTS");
        referralAnchor[_user] = _referee;
        emit ReferralAnchorCreated(_user, _referee);
    }

    function updateReferralAnchor(address _user, address _referee) external onlyOwner {
        referralAnchor[_user] = _referee;
        emit ReferralAnchorUpdated(_user, _referee);
    }

    function updateAnchorManager(address _anchorManager, bool _isManager) external onlyOwner {
        isAnchorManager[_anchorManager] = _isManager;
        emit anchorManagerUpdated(_anchorManager, _isManager);
    }

    function getUserReferee(address _user) external view returns (address) {
        return referralAnchor[_user];
    }

    function hasUserReferee(address _user) external view returns (bool) {
        return referralAnchor[_user] != address(0);
    }

    modifier onlyAnchorManager() {
        require(isAnchorManager[msg.sender], "ReferralRegistry: FORBIDDEN");
        _;
    }
}
