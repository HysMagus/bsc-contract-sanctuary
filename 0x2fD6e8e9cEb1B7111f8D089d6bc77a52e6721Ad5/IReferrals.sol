pragma solidity =0.6.6;

//SPDX-License-Identifier: Unlicense

interface IReferrals {
    function registerReferral(
        address _referee,
        address _token,
        uint256 _amount
    ) external payable;
}
