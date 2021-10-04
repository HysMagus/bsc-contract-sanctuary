// File: openzeppelin-solidity/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/Utils.sol

/// @dev Helper utility library for calculating Merkle proof and managing bytes.
library Utils {
    /// @dev Returns the hash of a Merkle leaf node.
    function merkleLeafHash(bytes memory _value)
        internal
        pure
        returns (bytes32)
    {
        return sha256(abi.encodePacked(uint8(0), _value));
    }

    /// @dev Returns the hash of internal node, calculated from child nodes.
    function merkleInnerHash(bytes32 _left, bytes32 _right)
        internal
        pure
        returns (bytes32)
    {
        return sha256(abi.encodePacked(uint8(1), _left, _right));
    }

    /// @dev Returns the encoded bytes using signed varint encoding of the given input.
    function encodeVarintSigned(uint256 _value)
        internal
        pure
        returns (bytes memory)
    {
        return encodeVarintUnsigned(_value * 2);
    }

    /// @dev Returns the encoded bytes using unsigned varint encoding of the given input.
    function encodeVarintUnsigned(uint256 _value)
        internal
        pure
        returns (bytes memory)
    {
        // Computes the size of the encoded value.
        uint256 tempValue = _value;
        uint256 size = 0;
        while (tempValue > 0) {
            ++size;
            tempValue >>= 7;
        }
        // Allocates the memory buffer and fills in the encoded value.
        bytes memory result = new bytes(size);
        tempValue = _value;
        for (uint256 idx = 0; idx < size; ++idx) {
            result[idx] = bytes1(uint8(128) | uint8(tempValue & 127));
            tempValue >>= 7;
        }
        result[size - 1] &= bytes1(uint8(127)); // Drop the first bit of the last byte.
        return result;
    }
}

// File: contracts/IBridge.sol


interface IBridge {
    /// Request packet struct is similar packet on Bandchain using to re-calculate result hash.
    struct RequestPacket {
        string clientId;
        uint64 oracleScriptId;
        bytes params;
        uint64 askCount;
        uint64 minCount;
    }

    /// Response packet struct is similar packet on Bandchain using to re-calculate result hash.
    struct ResponsePacket {
        string clientId;
        uint64 requestId;
        uint64 ansCount;
        uint64 requestTime;
        uint64 resolveTime;
        uint8 resolveStatus;
        bytes result;
    }


    /// Performs oracle state relay and oracle data verification in one go. The caller submits
    /// the encoded proof and receives back the decoded data, ready to be validated and used.
    /// @param _data The encoded data for oracle state relay and data verification.
    function relayAndVerify(bytes calldata _data)
        external
        returns (RequestPacket memory, ResponsePacket memory);
}

// File: contracts/Packets.sol

library Packets {
    function encodeRequestPacket(IBridge.RequestPacket memory _self)
        internal
        pure
        returns (bytes memory)
    {
        return
            abi.encodePacked(
                uint32(bytes(_self.clientId).length),
                _self.clientId,
                _self.oracleScriptId,
                uint32(_self.params.length),
                _self.params,
                _self.askCount,
                _self.minCount
            );
    }

    function encodeResponsePacket(IBridge.ResponsePacket memory _self)
        internal
        pure
        returns (bytes memory)
    {
        return
            abi.encodePacked(
                uint32(bytes(_self.clientId).length),
                _self.clientId,
                _self.requestId,
                _self.ansCount,
                _self.requestTime,
                _self.resolveTime,
                uint32(_self.resolveStatus),
                uint32(bytes(_self.result).length),
                _self.result
            );
    }

    function getEncodedResult(
        IBridge.RequestPacket memory _req,
        IBridge.ResponsePacket memory _res
    ) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                encodeRequestPacket(_req),
                encodeResponsePacket(_res)
            );
    }
}

// File: contracts/ICacheBridge.sol

interface ICacheBridge is IBridge {
    /// Returns the ResponsePacket for a given RequestPacket.
    /// @param _request The tuple that represents RequestPacket struct.
    function getLatestResponse(IBridge.RequestPacket calldata _request)
        external
        view
        returns (IBridge.ResponsePacket memory);

    /// Performs oracle state relay and oracle data verification in one go.
    /// After that, the results will be recorded to the state by using the hash of RequestPacket as key.
    /// @param _data The encoded data for oracle state relay and data verification.
    function relay(bytes calldata _data) external;
}

// File: contracts/ProxyBridge.sol

contract ProxyBridge is IBridge, ICacheBridge, Ownable {
    ICacheBridge public bridge;


    /// @notice Contract constructor
    /// @dev Initializes a new Bridge instance.
    /// @param _bridge Band's Bridge contract address
    constructor(ICacheBridge _bridge) public {
        bridge = _bridge;
    }

    /// Set the address of the bridge contract to use
    /// @param _bridge The address of the bridge to use
    function setBridge(ICacheBridge _bridge) external onlyOwner {
        bridge = _bridge;
    }
    
    /// Returns the ResponsePacket for a given RequestPacket.
    /// Reverts if can't find the related response in the mapping.
    /// @param _request A tuple that represents RequestPacket struct.
    function getLatestResponse(RequestPacket memory _request)
        external
        view
        override
        returns (ResponsePacket memory)
    {
        return bridge.getLatestResponse(_request);
    }

    /// Performs oracle state relay and oracle data verification in one go. The caller submits
    /// the encoded proof and receives back the decoded data, ready to be validated and used.
    /// @param _data The encoded data for oracle state relay and data verification.
    function relayAndVerify(bytes calldata _data)
        external
        override
        returns (RequestPacket memory, ResponsePacket memory)
    {
        return bridge.relayAndVerify(_data);
    }

    /// Performs oracle state relay and oracle data verification in one go.
    /// After that, the results will be recorded to the state by using the hash of RequestPacket as key.
    /// @param _data The encoded data for oracle state relay and data verification.
    function relay(bytes calldata _data)
        external
        override
    {
        return bridge.relay(_data);
    }
}