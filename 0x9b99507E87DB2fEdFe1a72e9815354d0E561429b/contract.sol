// File: contracts/zeppelin/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/
contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
    * @return the address of the owner.
    */
    function owner() public view returns(address) {
        return _owner;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
    * @return true if `msg.sender` is the owner of the contract.
    */
    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

    /**
    * @dev Allows the current owner to relinquish control of the contract.
    * @notice Renouncing to ownership will leave the contract without an owner.
    * It will not be possible to call the functions with the `onlyOwner`
    * modifier anymore.
    */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
    * @dev Transfers control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/resolvers/ClientRaindrop/StringUtils.sol

pragma solidity ^0.5.0;


// thanks to https://github.com/willitscale/solidity-util and https://github.com/Arachnid/solidity-stringutils
library StringUtils {
    struct slice {
        uint _len;
        uint _ptr;
    }

    /*
     * @dev Returns a slice containing the entire string.
     * @param self The string to make a slice from.
     * @return A newly allocated slice containing the entire string.
     */
    function toSlice(string memory self) internal pure returns (slice memory ) {
        uint ptr;
        assembly { ptr := add(self, 0x20) } // solium-disable-line security/no-inline-assembly
        return slice(bytes(self).length, ptr);
    }

    /*
     * @dev Returns a new slice containing the same data as the current slice.
     * @param self The slice to copy.
     * @return A new slice containing the same data as `self`.
     */
    function copy(slice memory self) internal pure returns (slice memory ) {
        return slice(self._len, self._ptr);
    }

    /*
     * @dev Copies a slice to a new string.
     * @param self The slice to copy.
     * @return A newly allocated string containing the slice's text.
     */
    function toString(slice memory self) internal pure returns (string memory ) {
        string memory ret = new string(self._len);
        uint retptr;
        assembly { retptr := add(ret, 0x20) } // solium-disable-line security/no-inline-assembly

        memcpy(retptr, self._ptr, self._len);
        return ret;
    }

    /**
    * Lower
    *
    * Converts all the values of a string to their corresponding lower case
    * value.
    *
    * @param _base When being used for a data type this is the extended object
    *              otherwise this is the string base to convert to lower case
    * @return string
    */
    function lower(string memory _base) internal pure returns (string memory ) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _lower(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
    * Lower
    *
    * Convert an alphabetic character to lower case and return the original
    * value when not alphabetic
    *
    * @param _b1 The byte to be converted to lower case
    * @return bytes1 The converted value if the passed value was alphabetic
    *                and in a upper case otherwise returns the original value
    */
    function _lower(bytes1 _b1) internal pure returns (bytes1) {
        if (_b1 >= 0x41 && _b1 <= 0x5A) {
            return bytes1(uint8(_b1) + 32);
        }
        return _b1;
    }

    function memcpy(uint dest, uint src, uint len) private pure { // solium-disable-line security/no-assign-params
        // Copy word-length chunks while possible
        for (; len >= 32; len -= 32) {
            assembly { mstore(dest, mload(src)) } // solium-disable-line security/no-inline-assembly
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
}

// File: contracts/interfaces/HydroInterface.sol

pragma solidity ^0.5.0;

interface HydroInterface {
    function balances(address) external view returns (uint);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function allowed(address, address) external view returns (uint);
    function transfer(address _to, uint256 _amount) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function approve(address _spender, uint256 _amount) external returns (bool success);
    function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
        external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    function totalSupply() external view returns (uint);
    
    function authenticate(uint _value, uint _challenge, uint _partnerId) external;
    function burn(address _from, uint _value) external returns(uint burnAmount);
   
    function changeMaxBurn(uint256 _newBurn) external returns(uint256);
    function _whiteListDapp(address _dappAddress) external returns(bool);
    function _blackListDapp(address _dappAddress)external returns(bool);
    function setRaindropAddress(address _raindrop) external;
    
}

// File: contracts/_testing/OldClientRaindrop.sol

pragma solidity ^0.5.0;




contract OldClientRaindrop is Ownable {
    // attach the StringUtils library
    using StringUtils for string;
    using StringUtils for StringUtils.slice;
    // Events for when a user signs up for Raindrop Client and when their account is deleted
    event UserSignUp(string casedUserName, address userAddress);
    event UserDeleted(string casedUserName);

    // Variables allowing this contract to interact with the Hydro token
    address public hydroTokenAddress;
    uint public minimumHydroStakeUser;
    uint public minimumHydroStakeDelegatedUser;

    // User account template
    struct User {
        string casedUserName;
        address userAddress;
    }

    // Mapping from hashed uncased names to users (primary User directory)
    mapping (bytes32 => User) internal userDirectory;
    // Mapping from addresses to hashed uncased names (secondary directory for account recovery based on address)
    mapping (address => bytes32) internal addressDirectory;

    // Requires an address to have a minimum number of Hydro
    modifier requireStake(address _address, uint stake) {
        HydroInterface hydro = HydroInterface(hydroTokenAddress);
        require(hydro.balanceOf(_address) >= stake, "Insufficient HYDRO balance.");
        _;
    }

    // Allows applications to sign up users on their behalf iff users signed their permission
    function signUpDelegatedUser(string memory casedUserName, address userAddress, uint8 v, bytes32 r, bytes32 s)
        public
        requireStake(msg.sender, minimumHydroStakeDelegatedUser)
    {
        require(
            isSigned(userAddress, keccak256(abi.encodePacked("Create RaindropClient Hydro Account")), v, r, s),
            "Permission denied."
        );
        _userSignUp(casedUserName, userAddress);
    }

    // Allows users to sign up with their own address
    function signUpUser(string memory casedUserName) public requireStake(msg.sender, minimumHydroStakeUser) {
        return _userSignUp(casedUserName, msg.sender);
    }

    // Allows users to delete their accounts
    function deleteUser() public {
        bytes32 uncasedUserNameHash = addressDirectory[msg.sender];
        require(initialized(uncasedUserNameHash), "No user associated with the sender address.");

        string memory casedUserName = userDirectory[uncasedUserNameHash].casedUserName;

        delete addressDirectory[msg.sender];
        delete userDirectory[uncasedUserNameHash];

        emit UserDeleted(casedUserName);
    }

    // Allows the Hydro API to link to the Hydro token
    function setHydroTokenAddress(address _hydroTokenAddress) public onlyOwner {
        hydroTokenAddress = _hydroTokenAddress;
    }

    // Allows the Hydro API to set minimum hydro balances required for sign ups
    function setMinimumHydroStakes(uint newMinimumHydroStakeUser, uint newMinimumHydroStakeDelegatedUser)
        public onlyOwner
    {
        HydroInterface hydro = HydroInterface(hydroTokenAddress);
        // <= the airdrop amount
        require(newMinimumHydroStakeUser <= (222222 * 10**18), "Stake is too high.");
        // <= 1% of total supply
        require(newMinimumHydroStakeDelegatedUser <= (hydro.totalSupply() / 100), "Stake is too high.");
        minimumHydroStakeUser = newMinimumHydroStakeUser;
        minimumHydroStakeDelegatedUser = newMinimumHydroStakeDelegatedUser;
    }

    // Returns a bool indicating whether a given userName has been claimed (either exactly or as any case-variant)
    function userNameTaken(string memory userName) public view returns (bool taken) {
        bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(userName.lower()));
        return initialized(uncasedUserNameHash);
    }

    // Returns user details (including cased username) by any cased/uncased user name that maps to a particular user
    function getUserByName(string memory userName) public view returns (string memory casedUserName, address userAddress) {
        bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(userName.lower()));
        require(initialized(uncasedUserNameHash), "User does not exist.");

        return (userDirectory[uncasedUserNameHash].casedUserName, userDirectory[uncasedUserNameHash].userAddress);
    }

    // Returns user details by user address
    function getUserByAddress(address _address) public view returns (string memory casedUserName) {
        bytes32 uncasedUserNameHash = addressDirectory[_address];
        require(initialized(uncasedUserNameHash), "User does not exist.");

        return userDirectory[uncasedUserNameHash].casedUserName;
    }

    // Checks whether the provided (v, r, s) signature was created by the private key associated with _address
    function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
        return (_isSigned(_address, messageHash, v, r, s) || _isSignedPrefixed(_address, messageHash, v, r, s));
    }

    // Checks unprefixed signatures
    function _isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        return ecrecover(messageHash, v, r, s) == _address;
    }

    // Checks prefixed signatures (e.g. those created with web3.eth.sign)
    function _isSignedPrefixed(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedMessageHash = keccak256(abi.encodePacked(prefix, messageHash));

        return ecrecover(prefixedMessageHash, v, r, s) == _address;
    }

    // Common internal logic for all user signups
    function _userSignUp(string memory casedUserName, address userAddress) internal {
        require(!initialized(addressDirectory[userAddress]), "Address already registered.");

        require(bytes(casedUserName).length < 31, "Username too long.");
        require(bytes(casedUserName).length > 3, "Username too short.");

        bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(casedUserName.toSlice().copy().toString().lower()));
        require(!initialized(uncasedUserNameHash), "Username taken.");

        userDirectory[uncasedUserNameHash] = User(casedUserName, userAddress);
        addressDirectory[userAddress] = uncasedUserNameHash;

        emit UserSignUp(casedUserName, userAddress);
    }

    function initialized(bytes32 uncasedUserNameHash) internal view returns (bool) {
        return userDirectory[uncasedUserNameHash].userAddress != address(0); // a sufficient initialization check
    }
}