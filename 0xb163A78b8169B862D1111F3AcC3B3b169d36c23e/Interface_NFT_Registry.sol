// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

interface I_NFT_Registry {

    /**
    * @dev Structs
    */
    
    //
    // Contain registered state and settings for each ERC20 token.
    //
    struct ERC20Token {
        address contract_address;
        string symbol;
        bool active;
        string meta;
    }
    
    //
    // Contain registered state and settings for each ERC721 token.
    //
    struct ERC721Token {
        address contract_address;
        string name;
        uint256 max_supply;
        uint256[] max_supply_history;
        address owner;
        address payee;
        bool active;
        string meta;
    }
    
    //
    // Contain mapping for slot
    //
    struct NFTSlots {
        mapping(uint256 => SlotState) slots;
    }

    //
    // Struct for each single slot of a NFT (ERC721 Token)
    //  which contains of 
    //  - serial no. to identify the slot (Work as token ID),
    //  - flexible status of the slot, it normally use
    //      1. [blank] for being unused.
    //      2. "RSV" for being reserved.
    //      3. "CLM_[wallet_address]" for 
    //  - its existence (as indicator of usage)
    //  - create timestamp.
    //  - update timestamp.
    //  - a remark note.
    //  - and meta information (Dynamic string for JSON or compressed format.)
    //
    struct SlotState {
        bool exists;
        uint256 serial_no;
        string status;
        uint256 timestamp;
        string remark; 
        string meta;
        address operator;
    }

    function getERC721token(address erc721_address) external returns (ERC721Token memory);

    function getNFTslotState(address erc721_address, uint256 serial_no) external returns (SlotState memory);
    
    function setNFTslotState(address erc721_address, uint256 serial_no, string memory status, string memory remark, string memory meta) external returns (SlotState memory);
    
    function updateNFTslotState(address erc721_address, uint256 serial_no, string memory status, string memory remark, string memory meta) external payable returns (SlotState memory);
    
    function getExchangeRateForNFTcollection(address erc721_address, address erc20_address) external returns (uint256);
    
    function getExchangeRateForSpecificNFT(address erc721_address, uint256 serial_no, address erc20_address) external returns (uint256);
    
    function getMinimumExchangeRate(address erc20_address) external returns (uint256);
    
    function changeExchangeRateForSingleNFT(address erc721_address, uint256 serial_no, address erc20_address, uint256 rate) external;

}
