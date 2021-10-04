// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "./StratManager.sol";

abstract contract FeeManager is StratManager {
    // Fee Caps
    uint256 public constant WITHDRAWAL_FEE_CAP = 100; // 1%
    uint256 public constant HARVEST_FEE_CAP = 2000; // 20%

    // Denominator for fee calcs
    uint256 public constant MAX_FEE = 10000;

    uint256 public withdrawalFee;
    uint256 public totalHarvestFee;

    // components of harvest fee = strategistFee + callFee + platformFee
    uint256 public strategistFee;
    uint256 public callFee;

    constructor() internal {
        setTotalHarvestFee(1000); // 10%
        setCallFee(2000); // 20% of harvest fee
    }

    function platformFee() public view returns (uint256) {
        return MAX_FEE - strategistFee - callFee;
    }

    function setWithdrawalFee(uint256 _fee) public onlyManager {
        require(_fee <= WITHDRAWAL_FEE_CAP, "!cap");
        withdrawalFee = _fee;
    }

    function setTotalHarvestFee(uint256 _fee) public onlyManager {
        require(_fee <= HARVEST_FEE_CAP, "!cap");
        totalHarvestFee = _fee;
    }

    function setCallFee(uint256 _fee) public onlyManager {
        callFee = _fee;
        require(callFee + strategistFee <= MAX_FEE, "!cap");
    }

    function setStrategistFee(uint256 _fee) public onlyManager {
        strategistFee = _fee;
        require(callFee + strategistFee <= MAX_FEE, "!cap");
    }
}
