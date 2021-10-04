// SPDX-License-Identifier: MIT



pragma solidity ^0.6.12;

contract Keep3rbKeeperRegistry {
    /// @notice governance address for the governance contract
    address public governance;
    address public pendingGovernance;

    struct _keeper {
        uint _id;
        address _address;
        string _telegram;
        string _jobname;
        string _bond;
        string _twitter;
        uint _added;
    }

    mapping(address => bool) public keeperAdded;
    mapping(address => _keeper) public keeperData;
    address[] public keeperList;

    constructor() public {
        governance = msg.sender;
    }

    uint public length;

    function keepers() external view returns (address[] memory) {
        return keeperList;
    }

    function keeper(address _address) external view returns (uint, address, string memory, string memory, string memory, string memory, uint) {
        _keeper memory __keeper = keeperData[_address];
        return (__keeper._id, __keeper._address, __keeper._telegram, __keeper._jobname, __keeper._bond, __keeper._twitter, __keeper._added);
    }

    function set(address _address, string calldata _telegram, string calldata _jobname, string calldata _bond, string calldata _twitter) external {
        require(msg.sender == governance, "Keep3rbJobRegistry::add: !gov");
        require(keeperAdded[_address], "Keep3rbJobRegistry::add: no job");
        _keeper storage __keeper = keeperData[_address];

        __keeper._telegram = _telegram;
        __keeper._jobname = _jobname;
        __keeper._bond = _bond;
        __keeper._twitter = _twitter;

    }

    function add(address _address, string calldata _telegram, string calldata _jobname, string calldata _bond, string calldata _twitter) external {
        require(msg.sender == governance, "Keep3rbJobRegistry::add: !gov");
        require(!keeperAdded[_address], "Keep3rbJobRegistry::add: job exists");
        keeperAdded[_address] = true;
        keeperList.push(_address);
        keeperData[_address] = _keeper(length++, _address, _telegram, _jobname, _bond, _twitter, now);
    }

    /**
     * @notice Allows governance to change governance (for future upgradability)
     * @param _governance new governance address to set
     */
    function setGovernance(address _governance) external {
        require(msg.sender == governance, "setGovernance: !gov");
        pendingGovernance = _governance;
    }

    /**
     * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
     */
    function acceptGovernance() external {
        require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
        governance = pendingGovernance;
    }
}