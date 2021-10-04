// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./Library.sol";
import "./Interface_NFT_Registry.sol";


contract NFT_Registry is Ownable, I_NFT_Registry {
    using SafeMath for uint256;


    /**
    * @dev Data Structures and Global Variables
    */

    //
    // Contract owner address.
    //
    address private $owner;

    //
    // Wallet address to receive transfer in of all ERC20.
    //
    address private $payee;

    //
    // Map for store registry of accept ERC20 tokens which contain setting and its meta data.
    //
    mapping(address => ERC20Token) private $ERC20Tokens;

    //
    // Map for store registry of NFTs (ERC721 tokens) which contain setting and its meta data.
    //
    mapping(address => ERC721Token) private $ERC721Tokens;

    //
    // Map for store exchange rate of an ERC20 token for each ERC721 collection. 
    //
    mapping(address => mapping(address => uint256)) private $exchangeRateDefault;

    //
    // Map for store exchange rate of an ERC20 token for each ERC721 token. 
    //
    mapping(address => mapping(uint256 => mapping(address => uint256))) private $exchangeRateNFT;
    
    //
    // Map for store minimum exchange rate of each ERC20 token.
    //
    mapping(address => uint256) private $minExchangeRate;

    //
    // Map for store slot of reserved, used, claimed slot of ERC721 tokens
    //  it's a double map which use contract address of a NFT to access the store
    //  and use serial number (uint256) to access the token slot.
    // 
    mapping(address => NFTSlots) $NFTslots;

    //
    // Map for store permitted operator (e.g. another contract that call this contract).
    // 
    mapping(address => bool) private $permitted_operator;
    

    /**
    * @dev Event Emitters
    */

    //
    // Event for NFT slot update
    //
    event SlotUpdate(
        address indexed erc721_address,
        uint256 serial_no,
        string status,
        uint256 timestamp
    );



    /**
    * @dev Constructor
    */

    // Simply setup contract owner and payee to deployer address
    constructor() {
        $owner = msg.sender;
        $permitted_operator[msg.sender] = true;
    }


    /**
    * @dev Public Functionalities
    */


    /**
    * @dev Contract Setup and Administrations
    */
    
    //
    // Change Contract Owner Address
    //
    function changeOwner(
        address new_address
    ) public onlyOwner {
        require(new_address != $owner && new_address != address(0), "E:[PM02]");
        $owner = new_address;
        transferOwnership($owner);
    }

    //
    // Change Contract Owner Address
    //
    function activateOperator(
        address operator_address
    ) public onlyOwner {
        if ($permitted_operator[operator_address]) {
            $permitted_operator[operator_address] = !$permitted_operator[operator_address];
        } else {
            $permitted_operator[operator_address] = true;
        }
    }

    /**
    * @dev NFT (ERC721 Tokens) Functionalities
    */

    //
    // Change Owner Address for a registered ERC721.
    //
    function changeERC721Owner(
        address erc721_address,
        address new_address
    ) public {
        require(
          ($ERC721Tokens[erc721_address].owner != new_address && new_address != address(0))
          || msg.sender == $owner
        , "E:[PM02]");
        $ERC721Tokens[erc721_address].owner = new_address;
    }

    //
    // Change Payee Address for a registered ERC721.
    //
    function changeERC721Payee(
        address erc721_address,
        address new_address
    ) public {
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        require($ERC721Tokens[erc721_address].payee != new_address && new_address != address(0), "E:[PM03]");
        $ERC721Tokens[erc721_address].payee = new_address;
    }

    //
    // Get details of a registered ERC721 token.
    //
    function getERC721token(
        address erc721_address
    )
        override
        public
        view
        returns (ERC721Token memory)
    {
        return $ERC721Tokens[erc721_address];
    }

    //
    // Register an ERC721 token to be usable with this contract.
    //
    function registerERC721token(
        address erc721_address,
        string memory name,
        uint256 max_supply,
        address erc20_address,
        address erc721_owner_address,
        address erc721_payee_address,
        uint256 exchange_rate
    )
        public
        onlyOwner
    {
        $ERC721Tokens[erc721_address].contract_address = erc721_address;
        $ERC721Tokens[erc721_address].name = name;
        $ERC721Tokens[erc721_address].max_supply = max_supply;
        $ERC721Tokens[erc721_address].owner = erc721_owner_address;
        
        if (erc721_payee_address != address(0)) {
            $ERC721Tokens[erc721_address].payee = erc721_payee_address;
        } else {
            $ERC721Tokens[erc721_address].payee = erc721_owner_address;
        }
        $ERC721Tokens[erc721_address].active = true;
        if (exchange_rate > 0) {
            $exchangeRateDefault[erc721_address][erc20_address] = exchange_rate;
        } else {
            $exchangeRateDefault[erc721_address][erc20_address] = $minExchangeRate[erc20_address];
        }
    }

    //
    // Switch current state of a registered ERC721 token (Activate <> Deactive).
    //
    function activateERC721token(
        address erc721_address
    )
        public
    {
        //
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        $ERC721Tokens[erc721_address].active = !$ERC721Tokens[erc721_address].active;
    }

    //
    // Set max supply for ERC721 (Can be changed only once).
    //
    function setNFTmaxSupply(
        address erc721_address,
        uint256 max_supply
    )
        public
    {
        //
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        require($ERC721Tokens[erc721_address].max_supply == 0, "E:[TK11]");
        $ERC721Tokens[erc721_address].max_supply = max_supply;
    }

    //
    // Set max supply for ERC721 (can be changed only once).
    //
    function overrideNFTmaxSupply(
        address erc721_address,
        uint256 max_supply
    )
        public
    {
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        $ERC721Tokens[erc721_address].max_supply_history.push($ERC721Tokens[erc721_address].max_supply);
        $ERC721Tokens[erc721_address].max_supply = max_supply;
    }

    //
    // Bulk setup reservation states for each NFT. 
    //
    function setNFTreserveList(
        address erc721_address,
        uint256[] memory reserve_list
    )
        public
    {
        require($ERC721Tokens[erc721_address].max_supply > 0, "E:[TK12]");
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        
        for (uint8 i = 0; i < reserve_list.length; i++) {
            uint256 _serial_no = reserve_list[i];
            SlotState memory _slot = $NFTslots[erc721_address].slots[_serial_no];
            if (!_slot.exists && _serial_no <= $ERC721Tokens[erc721_address].max_supply) {
                _slot.status = "RSV";
                _slot.exists = true;
                _slot.serial_no = _serial_no;

                $NFTslots[erc721_address].slots[_serial_no] = _slot;
            }
        }
    }

    //
    // Bulk remove reserved NFT slot.
    //
    function removeNFTreserveList(
        address erc721_address,
        uint256[] memory reserve_list
    )
      public
    {
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");

        for (uint8 i = 0; i < reserve_list.length; i++) {
            uint256 _serial_no = reserve_list[i];
            SlotState memory _slot = $NFTslots[erc721_address].slots[_serial_no];
            if (_compareStrings(_slot.status , "RSV")) {
                $NFTslots[erc721_address].slots[_serial_no].status = "";
            }
        }
    }

    // 
    // Get detail of an NFT slot
    //
    function getNFTslotState(
        address erc721_address,
        uint256 serial_no
    )
        override
        public
        view
        returns (SlotState memory)
    {
        SlotState memory _slot = $NFTslots[erc721_address].slots[serial_no];
        
        return _slot;
    }

    // 
    // Set details for an NFT slot - Can be set only once.
    //
    function setNFTslotState(
        address erc721_address,
        uint256 serial_no,
        string memory status,
        string memory remark,
        string memory meta
    )
        override
        public
        returns (SlotState memory)
    {
        
        require($permitted_operator[msg.sender], "E:[PM04]");
        require($ERC721Tokens[erc721_address].active, "E:[TK10]");

        SlotState memory _slot = $NFTslots[erc721_address].slots[serial_no];
        require(!_slot.exists, "E:[RE01]");

        SlotState memory slot_ = SlotState(
          true,             // bool exists;
          serial_no,        // uint256 serial_no;
          status,           // string status;
          block.timestamp,  // uint256 timestamp;
          remark,           // string remark; 
          meta,             // string meta;
          msg.sender        // address operator;
        );

        $NFTslots[erc721_address].slots[serial_no] = slot_;
    
        emit SlotUpdate(erc721_address, serial_no, status, block.timestamp);

        return slot_;
    }

    //
    // Update details for an NFT slot by
    //
    function updateNFTslotState(
        address erc721_address,
        uint256 serial_no,
        string memory status,
        string memory remark,
        string memory meta
    )
        override
        payable
        public
        returns (SlotState memory)
    {
        require($permitted_operator[msg.sender], "E:[PM04]");
        require($ERC721Tokens[erc721_address].active, "E:[TK10]");

        require($NFTslots[erc721_address].slots[serial_no].exists, "E:[RE01]");
        $NFTslots[erc721_address].slots[serial_no].status = status;
        $NFTslots[erc721_address].slots[serial_no].remark = remark;
        $NFTslots[erc721_address].slots[serial_no].meta = meta;
        $NFTslots[erc721_address].slots[serial_no].timestamp = block.timestamp;

        emit SlotUpdate(erc721_address, serial_no, status, block.timestamp);

        return $NFTslots[erc721_address].slots[serial_no];
    }

    /**
    * @dev ERC20 Tokens (Quote Token) Functionalities
    */

    //
    // Get details of a registered ERC20 token.
    //
    function getERC20token(
        address erc20_address
    )
        public
        view 
        returns (ERC20Token memory)
    {
        return $ERC20Tokens[erc20_address];
    }

    //
    // Register an ERC20 token to be usable with this contract.
    //
    function registerERC20token(
        address erc20_address,
        string memory symbol
    )
        public
    {
        require($permitted_operator[msg.sender], "E:[PM04]");
        $ERC20Tokens[erc20_address].contract_address = erc20_address;
        $ERC20Tokens[erc20_address].symbol = symbol;
        $ERC20Tokens[erc20_address].active = true;
    }

    //
    // Remove an ERC20 token from the registry.
    //
    function removeERC20token(
        address erc20_address
    )
        public
    {
        require($permitted_operator[msg.sender], "E:[PM04]");
        delete $ERC721Tokens[erc20_address];
    }

    //
    // Change exchange rate for an ERC20 with an ERC721 NFT.
    //
    function changeExchangeRate(
        address erc721_address,
        address erc20_address,
        uint256 exchange_rate
    )
        public
    {
        require($ERC721Tokens[erc721_address].active, "E:[TK10]");
        require($ERC20Tokens[erc20_address].active, "E:[TK20]");
        require($ERC721Tokens[erc721_address].owner == msg.sender, "E:[PM01]");
        $exchangeRateDefault[erc721_address][erc20_address] = exchange_rate;
    }
    
    //
    // Set exchange rate for a specific ERC20 token for a specific ERC721 NFT.
    //
    function changeExchangeRateForSingleNFT(
        address erc721_address,
        uint256 serial_no,
        address erc20_address,
        uint256 exchange_rate
    )
        override
        public
    {
        require($ERC721Tokens[erc721_address].active, "E:[TK10]");
        require($ERC20Tokens[erc20_address].active, "E:[TK20]");
        require($permitted_operator[msg.sender], "E:[PM04]");
        $exchangeRateNFT[erc721_address][serial_no][erc20_address] = exchange_rate;
    }
    
    //
    // Get exchange rate for a specific ERC20 token bind with a specific ERC721 collection.
    //
    function getExchangeRateForNFTcollection(
        address erc721_address,
        address erc20_address
    )
        override
        public
        view
        returns (uint256)
    {
        return $exchangeRateDefault[erc721_address][erc20_address];
    }

    //
    // Get exchange rate for a specific ERC20 token bind with a specific ERC721 token.
    //
    function getExchangeRateForSpecificNFT(
        address erc721_address,
        uint256 serial_no,
        address erc20_address
    )
        override
        public
        view
        returns (uint256)
    {
        return $exchangeRateNFT[erc721_address][serial_no][erc20_address];
    }

    //
    // Get exchange rate for a specific ERC20 token bind with a specific ERC721 token.
    //
    function getMinimumExchangeRate(
        address erc20_address
    )
        override
        public
        view
        returns (uint256)
    {
        return $minExchangeRate[erc20_address];
    }


    /**
    * @dev Internal Utilities
    */

    //
    // Simply compare two strings.
    //
    function _compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }


    /**
    * @dev Error Codes
    *
    * E:[0000] Undefined error.
    *
    *** Permissions
    *
    * E:[PM01] Caller must be the owner of the registered ERC721 token.
    *
    * E:[PM02] New owner address must not be the same as the current one.
    *
    * E:[PM03] New payee address must not be the same as the current one.
    *
    * E:[PM04] Caller must be a permitted operator.
    *
    *** Tokens
    *
    * E:[TK10] ERC721 token was not active or registered.
    *
    * E:[TK11] To set max supply of an NFT, it needed to be zero.
    *
    * E:[TK12] NFT max supply was not set.
    *
    * E:[TK20] ERC20 token was not active or registered.
    *
    *** Registry and Entries
    *
    * E:[RE01] NFT slot must be set before.
    *
    ***
    */
}


// Created by Jimmy IsraKhan <me@jimmyis.com>
// Latest update: 2021-09-25
