// Dependency file: contracts/interfaces/IPartner.sol

/// SPDX-License-Identifier: MIT

// pragma solidity >=0.5.0;

interface IPartner {
    function register(address sender, address affiliate) external;
    function isUser(address _account) external view returns (bool);
}


// Dependency file: @openzeppelin/contracts/utils/Context.sol

// pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// Dependency file: @openzeppelin/contracts/access/Ownable.sol


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Context.sol";

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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// Dependency file: contracts/PartnersManageable.sol

// pragma solidity >=0.5.0;

// import "/mnt/c/Users/piron/Desktop/defi-runners-collectible/node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract PartnersManageable is Ownable {

    mapping (address => bool) public managers;

    event ManagerSet(address, bool);

    function setManager(address _account, bool _status) external onlyOwner {
        managers[_account] = _status;
        emit ManagerSet(_account, _status);
    }

    modifier onlyManager() {
        require(managers[msg.sender], "Only partner manager");
        _;
    }
}

// Root file: contracts/Partners.sol

pragma solidity >=0.5.0;

// import "contracts/interfaces/IPartner.sol";
// import "contracts/PartnersManageable.sol";

contract Partners is IPartner, PartnersManageable {

    mapping (address => address) private _affiliates;
    mapping (address => address[]) private _referrals;
    mapping (address => bool) private _registered;

    event UserRegistered(address indexed account, uint256 amount, address affiliate);

    function register(address _sender, address _affiliate) external virtual override onlyManager {
        _register(_sender, _affiliate);
    }

    function isUser(address _account) public view virtual override returns (bool) {
        return _registered[_account];
    }

    function getAffiliate(address _account) public view returns (address) {
        return _affiliates[_account];
    }

    function getReferrals(address _account) external view returns (address[] memory refs) {
        refs = _referrals[_account];
    }

    function countReferrals(address _account) public view returns (uint256) {
        return _referrals[_account].length;
    }

    function _register(address _sender, address _affiliate) internal {
        require(_affiliate != _sender, "Self referral");
        require(_registered[_sender] == false, "User account registered");

        if (_affiliate != address(0)) {
            require(
                _registered[_affiliate] == true,
                "Affiliate account not registered"
            );
        }

        _registered[_sender] = true;
        _affiliates[_sender] = _affiliate;

        if (_affiliate != address(0)) {
            _referrals[_affiliate].push(_sender);
        }

        emit UserRegistered(_sender, msg.value, _affiliate);
    }
}