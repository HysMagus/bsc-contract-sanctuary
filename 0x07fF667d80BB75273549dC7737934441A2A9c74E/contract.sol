pragma solidity 0.6.12;

contract TwitterFUDRetweetWinrar {

    function getWinner(uint256 blockNumber, uint256 nParticipants) external view returns (uint) {
        return uint(blockhash(blockNumber)) % nParticipants;
    }
}