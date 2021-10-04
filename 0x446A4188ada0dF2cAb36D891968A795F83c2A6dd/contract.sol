// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface cryptoworld {
    function building(uint) external view returns (uint,uint);
    function getApproved(uint) external view returns (address);
    function ownerOf(uint) external view returns (address);
}

contract nftccrypto_attributes {
    
    cryptoworld constant cwu = cryptoworld(0xBAce0feb6051Ebf13bd7DceC7FeA7901783fFf47);
    
    struct building_property {
        uint32 country;
        uint32 city;
        uint32 longitude;
        uint32 latitude;
        uint32 gene;
		string url;
    }
    
    mapping(uint => building_property) public building_properties;
    mapping(uint => bool) public building_created;
    
    event Created(address indexed creator, uint building, uint32 country, uint32 city, uint32 longitude, uint32 latitude, uint32 gene,string url);
    
    function _isApprovedOrOwner(uint _building) internal view returns (bool) {
        return cwu.getApproved(_building) == msg.sender || cwu.ownerOf(_building) == msg.sender;
    }
    
    function building_create(uint _building, uint32 _country, uint32 _city, uint32 _longitude, uint32 _latitude, uint32 _gene, string memory _url) external {
        require(_isApprovedOrOwner(_building));
        require(!building_created[_building]);
        building_created[_building] = true;
        
        building_properties[_building] = building_property(_country, _city, _longitude, _latitude, _gene, _url);
        emit Created(msg.sender, _building, _country, _city, _longitude, _latitude, _gene, _url);
    }
    
    
    function tokenURI(uint256 _building) public view returns (string memory) {
        string memory output;
        {
        string[7] memory parts;
        building_property memory _attr = building_properties[_building];
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = string(abi.encodePacked("country", " ", toString(_attr.country), '</text><text x="10" y="40" class="base">'));

        parts[2] = string(abi.encodePacked("city", " ", toString(_attr.city), '</text><text x="10" y="60" class="base">'));

        parts[3] = string(abi.encodePacked("longitude", " ", toString(_attr.longitude), '</text><text x="10" y="60" class="base">'));

        parts[4] = string(abi.encodePacked("latitude", " ", toString(_attr.latitude),  '</text><text x="10" y="60" class="base">'));

        parts[5] = string(abi.encodePacked("gene", " ", toString(_attr.gene), '</text><text x="10" y="60" class="base">'));

        parts[6] = string(abi.encodePacked("url", " ", _attr.url, '</text></svg>'));
        
        output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
        }
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "building #', toString(_building), '", "description": "Welcome join the crypto universe.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}