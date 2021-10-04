// Dependency file: @openzeppelin/contracts/GSN/Context.sol

// pragma solidity ^0.6.0;

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


// Dependency file: @openzeppelin/contracts/access/Ownable.sol

// pragma solidity ^0.6.0;

// import "@openzeppelin/contracts/GSN/Context.sol";
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


// Root file: src/SelfMintManager.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;
// import "@openzeppelin/contracts/access/Ownable.sol";

interface IListRegistry {
    function isAdmin(address) external returns (bool);
    function isInBlacklist(address) external returns (bool);
}

interface MintableERC20 {
    function mint(address account, uint256 amount) external;
}


/**
#     #                                           
##   ##   ##   #####   ##   #####   ##   #    # # 
# # # #  #  #    #    #  #    #    #  #  #   #  # 
#  #  # #    #   #   #    #   #   #    # ####   # 
#     # ######   #   ######   #   ###### #  #   # 
#     # #    #   #   #    #   #   #    # #   #  # 
#     # #    #   #   #    #   #   #    # #    # # 
                                                  
######                                        #######               ######                    ## #######                             ##   
#     # ######  ####   ####  ###### #####     #         ##   #    # #     # #   ##    ####   #      #     ####  #    # ###### #    #   #  
#     # #      #    # #    # #      #    #    #        #  #  ##   # #     # #  #  #  #    # #       #    #    # #   #  #      ##   #    # 
######  #####  #      #      #####  #    #    #####   #    # # #  # ######  # #    # #    # #       #    #    # ####   #####  # #  #    # 
#       #      #  ### #  ### #      #    #    #       ###### #  # # #       # ###### #    # #       #    #    # #  #   #      #  # #    # 
#       #      #    # #    # #      #    #    #       #    # #   ## #       # #    # #    #  #      #    #    # #   #  #      #   ##   #  
#       ######  ####   ####  ###### #####     #       #    # #    # #       # #    #  ####    ##    #     ####  #    # ###### #    # ##   
                                                                                                                                          
#######           ######                                           #####                                 #####                         
#     # #    #    #     # # #    #   ##   #    #  ####  ######    #     # #    #   ##   #####  #####    #     # #    #   ##   # #    # 
#     # ##   #    #     # # ##   #  #  #  ##   # #    # #         #       ##  ##  #  #  #    #   #      #       #    #  #  #  # ##   # 
#     # # #  #    ######  # # #  # #    # # #  # #      #####      #####  # ## # #    # #    #   #      #       ###### #    # # # #  # 
#     # #  # #    #     # # #  # # ###### #  # # #      #               # #    # ###### #####    #      #       #    # ###### # #  # # 
#     # #   ##    #     # # #   ## #    # #   ## #    # #         #     # #    # #    # #   #    #      #     # #    # #    # # #   ## 
####### #    #    ######  # #    # #    # #    #  ####  ######     #####  #    # #    # #    #   #       #####  #    # #    # # #    # 
Developed by Frank Wei                                                                                                          */

contract PeggedTokenMinter is Ownable {
    bytes32 public DOMAIN_SEPARATOR;
    address public managerRegistry;
    // Token => To Wallet => Sequence Number, we just use nonces to avoid replay attack
    mapping(address => mapping(address => uint256)) nonces;
    bytes32
        public constant
        PERMIT_TYPEHASH = keccak256("Permit(address token,address to,uint256 value,uint256 nonce,uint256 deadline)");

    event MintWithPermit(address indexed token, address indexed to, uint256 nonce, uint256 amount);

    constructor(address _managerRegistry) public {
        managerRegistry = _managerRegistry;
        uint256 _chainId;
        assembly {
            _chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("PeggedTokenMinter")),
                keccak256(bytes("1")),
                _chainId,
                address(this)
            )
        );
    }

    function updateManagerRegistry(address _managerRegistry) public onlyOwner() {
        managerRegistry = _managerRegistry;
    }

    function mintPeggedTokenWithPermit(
        address token,
        address to,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(deadline >= block.timestamp, "SelfMintManager::Permit: Permit EXPIRED");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        PERMIT_TYPEHASH,
                        token,
                        to,
                        value,
                        nonces[token][to],
                        deadline
                    )
                )
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        bool isPermitSignerAdmin = IListRegistry(managerRegistry).isAdmin(recoveredAddress);
        require(
            // Mint Permit signer must be the admin in the manager Registry
            recoveredAddress != address(0) && isPermitSignerAdmin,
            "SelfMintManager::INVALID_SIGNATURE: Please request new permit or contact us."
        );
        // Mint if call successfully
        MintableERC20(token).mint(to, value);
        emit MintWithPermit(token, to, nonces[token][to], value);
        // Increment on nonces
        nonces[token][to] += 1;
    }

    function getNoncesOf(address tokenToMint, address who) public view returns (uint256) {
        return nonces[tokenToMint][who];
    }
}