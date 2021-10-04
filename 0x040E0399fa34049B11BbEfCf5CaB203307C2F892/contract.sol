//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract LearningHashTools {
    function calculatelearnedHash(
        uint256[]   calldata _subRoutes,
        address[]   calldata _correspondentTokens
    )
        external
        pure
        returns (bytes32)
    {
        bytes memory packed = abi.encodePacked(_subRoutes, _correspondentTokens);
        bytes32 learnedHash = keccak256(packed);
        
        return learnedHash;
    }
}