// SPDX-License-Identifier: MIT
/** 
*                                                                                                                                  
      ██████╗ ███████╗ ██████╗  █████╗ ███████╗██╗   ██╗███████╗
      ██╔══██╗██╔════╝██╔════╝ ██╔══██╗██╔════╝██║   ██║██╔════╝
      ██████╔╝█████╗  ██║  ███╗███████║███████╗██║   ██║███████╗
      ██╔═══╝ ██╔══╝  ██║   ██║██╔══██║╚════██║██║   ██║╚════██║
      ██║     ███████╗╚██████╔╝██║  ██║███████║╚██████╔╝███████║
      ╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝V2.0
                          _                  _                  _   
 ___ _ __ ___   __ _ _ __| |_ ___ ___  _ __ | |_ _ __ __ _  ___| |_ 
/ __| '_ ` _ \ / _` | '__| __/ __/ _ \| '_ \| __| '__/ _` |/ __| __|
\__ \ | | | | | (_| | |  | || (_| (_) | | | | |_| | | (_| | (__| |_ 
|___/_| |_| |_|\__,_|_|   \__\___\___/|_| |_|\__|_|  \__,_|\___|\__|BNB                                                        
*   ┌─────────────────────────────────────────────────────────────┐  
*   │   Website: https://www.olympus.uno                          │
*   │                                                             │  
*   │   🇵🇪 PERÚ.                                                  │
*   │   Grupo: https://t.me/joinchat/Lm5rLRpvtWRqE0Zaaiz9bQ       │
*   │                                                             │
*   │   🇲🇽 MEXICO.                                                │  
*   │   Grupo: https://t.me/joinchat/QAvJCVhC3lt55hHvF3PjNQ       │
*   │                                                             │
*   │   🇻🇪 VENEZUELA.                                             │
*   │   Grupo: https://t.me/joinchat/IHpztkNXJ2WQM2CsHRM1fw       │
*   │                                                             │
*   │   🇨🇴 COLOMBIA.                                              │
*   │   Grupo: https://t.me/joinchat/ORTpvEuAXutsIcv06bE45w       │
*   │                                                             │
*   │   🇪🇸 ESPAÑA.                                                │
*   │   Grupo: https://t.me/joinchat/JwziMx2yUAuqdxsirUJmLw       │
*   │                                                             │
*   │   🇨🇺 CUBA.                                                  │
*   │   Grupo: https://t.me/joinchat/QAvJCRfp8N6oJ9WlfW4Bog       │
*   │                                                             │
*   │   🇦🇷 ARGENTINA.                                             │
*   │   Grupo: https://t.me/joinchat/QAvJCRc__p5jTOZp9GxZ2w       │
*   │                                                             │
*   │   🇳🇮 NICARAGUA.                                             │  
*   │   Grupo: https://t.me/joinchat/OD5CfRZvD5ja79L596OVGg       │
*   │                                                             │  
*   │   🇪🇨 ECUADOR.                                               │  
*   │   Grupo: https://t.me/joinchat/QAvJCR0A-aDZT_neFVccJQ       │
*   │                                                             │          
*   │   🇩🇴 REPÚBLICA DOMINICANA                                   │  
*   │   Grupo: https://t.me/joinchat/QAvJCR1iQdCfhsL66anaqQ       │
*   │                                                             │                                                          
*   │   🇵🇦 PANAMÁ                                                 │  
*   │   Grupo: https://t.me/joinchat/ORTpvBkLaXTfO7GhWBZICA       │
*   │                                                             │
*   │   🇨🇱 CHILE                                                  │ 
*   │   Grupo: https://t.me/joinchat/ORTpvBOAjCNYtbXnxFwQ7A       │
*   │                                                             │  
*   │   🇧🇷 BRASIL                                                 │ 
*   │   Grupo: https://t.me/joinchat/ORTpvBYswSpSoClG9C5Nsg       │
*   │                                                             │  
*   │   🇧🇴 BOLIVIA                                                │  
*   │   Grupo: https://t.me/joinchat/ORTpvByF6SuQBKhoNwxdcA       │ 
*   │                                                             │      
*   │   🇵🇾 PARAGUAY                                               │  
*   │   Grupo: https://t.me/joinchat/ORTpvBgUcni7zlwQuCXxoQ       │ 
*   │                                                             │ 
*   │   >>GRUPO TELEGRAM NOTICIAS [ESPAÑOL]                       │ 
*   │   https://t.me/GlobalBusinessOfficialNews                   │ 
*   │                                                             │ 
*   │                                                             │     
*   │   >>GRUPO TELEGRAM [ESPAÑOL]                                │ 
*   │     http://t.me/olympus_uno_ES                              │        
*   │                                                             │      
*   │   >>FAN PAGE FACEBOOK                                       │ 
*   │     https://www.facebook.com/olympus.uno                    │ 
*   │                                                             │ 
*   │   >>INSTAGRAM                                               │ 
*   │     https://instagram.com/olympus.uno                       │ 
*   │                                                             │ 
*   │   >>TWITTER                                                 │ 
*   │     https://twitter.com/olympus_uno                         │ 
*   │                                                             │ 
*   │   >>CANAL YOUTUBE                                           │ 
*   │     https://www.youtube.com/channel/UCvVpqU1Tz6OUmRK1C5lVdpQ│ 
*   │                                                             │ 
*   │   >>E-mail                                                  │ 
*   │     admin@olympus.uno                                       │ 
*   └─────────────────────────────────────────────────────────────┘ 

* by Global Business
* https://www.globalbusiness.app/
* Get your share, join today!
*/

pragma solidity 0.7.4;
interface BRC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
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
contract Context {
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
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
    constructor ()  {
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

}
contract ReentrancyGuard {
    bool private _notEntered;

    constructor ()  {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}
contract PegasusV2 is Ownable, ReentrancyGuard {
    
    struct User {
        uint id;
        address referrer;
        uint partnersCount;
        
        mapping(uint8 => bool) activeX3Levels;
        mapping(uint8 => X3) x3Matrix;
       
    }
    
    struct X3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }

    uint8 public constant LAST_LEVEL = 12;
    
    mapping(address => User) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;
    mapping(address => uint) public balances; 

    uint public lastUserId = 1;
    address public ownerContract;
    BRC20 tokenA;
    bool public modeOnlyTron;
    mapping(uint8 => uint) public levelPrice;
    
    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 level);
    event Upgrade(address indexed user, address indexed referrer, uint8 level);
    event NewUserPlace(address indexed user,uint indexed userId, address indexed referrer,uint referrerId, uint8 level, uint8 place);
    event MissedTronReceive(address indexed receiver,uint receiverId, address indexed from,uint indexed fromId, uint8 level);
    event SentDividends(address indexed from,uint indexed fromId, address indexed receiver,uint receiverId, uint8 level, bool isExtra);
    
    constructor(address ownerAddress,address _tokenaddress) {
        levelPrice[1] = 150*1e9 ;
        levelPrice[2] = 300*1e9 ;
        levelPrice[3] = 600*1e9 ;
        levelPrice[4] = 900*1e9 ;
        levelPrice[5] = 1500*1e9 ;
        levelPrice[6] = 2050*1e9 ;
        levelPrice[7] = 2630*1e9 ;
        levelPrice[8] = 3500*1e9 ;
        levelPrice[9] = 4400*1e9 ;
        levelPrice[10] = 5260*1e9 ;
        levelPrice[11] = 6720*1e9 ;
        levelPrice[12] = 8760*1e9 ;
        modeOnlyTron=false;
        ownerContract = ownerAddress;
        tokenA = BRC20(_tokenaddress);
        users[ownerAddress].id = 1;
        users[ownerAddress].referrer= address(0);
        users[ownerAddress].partnersCount =uint(0);
        idToAddress[1] = ownerAddress;
        
        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            users[ownerAddress].activeX3Levels[i] = true;
        }
        
        userIds[1] = ownerAddress;
        
    }
    

    function registrationExt(uint256 _amount,address referrerAddress) external nonReentrant {
        registration(msg.sender, referrerAddress, _amount);
    }
     
    function buyLevel(uint8 level,uint256 _amount) external nonReentrant {
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(_amount == levelPrice[level], "invalid price");
        require(level > 1 && level <= LAST_LEVEL, "invalid level");

       
            require(!users[msg.sender].activeX3Levels[level], "level already activated");
            require(users[msg.sender].activeX3Levels[level - 1], "previous level should be activated");
            uint256 balanceA = tokenA.balanceOf(msg.sender);
            require(_amount <= balanceA, "insufficient balance");
            TransferHelper.safeTransferFrom(address(tokenA),msg.sender,address(this),_amount);
            if (users[msg.sender].x3Matrix[level-1].blocked) {
                users[msg.sender].x3Matrix[level-1].blocked = false;
            }

            address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
            users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
            users[msg.sender].activeX3Levels[level] = true;
            updateX3Referrer(msg.sender, freeX3Referrer, level);
            
            emit Upgrade(msg.sender, freeX3Referrer, level);

    }    
    
    function registration(address userAddress, address referrerAddress, uint256 _amount) private {
        require(_amount == 150 *1e9, "registration cost 150 000 OLY");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        uint256 balanceA = tokenA.balanceOf(msg.sender);
        require(_amount <= balanceA, "insufficient balance");
        TransferHelper.safeTransferFrom(address(tokenA),msg.sender,address(this),_amount);
        users[userAddress].id = lastUserId;
        users[userAddress].referrer = referrerAddress;
        users[userAddress].partnersCount = 0;
        idToAddress[lastUserId] = userAddress;
        users[userAddress].referrer = referrerAddress;
        users[userAddress].activeX3Levels[1] = true; 
        userIds[lastUserId] = userAddress;
        lastUserId++;
        users[referrerAddress].partnersCount++;
        address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
        users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
        updateX3Referrer(userAddress, freeX3Referrer, 1);
         
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
    
    function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].x3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
            emit NewUserPlace(userAddress,users[userAddress].id, referrerAddress, users[referrerAddress].id, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
            return sendTronDividends(referrerAddress, userAddress, level);
        }
        emit NewUserPlace(userAddress,users[userAddress].id, referrerAddress,users[referrerAddress].id, level, 3);
        users[referrerAddress].x3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].x3Matrix[level].blocked = true;
        }
        if (referrerAddress != ownerContract) {
            //check referrer active level
            address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
            if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
                users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
            }
            
            users[referrerAddress].x3Matrix[level].reinvestCount++;
            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, level);
            updateX3Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            sendTronDividends(ownerContract, userAddress, level);
            users[ownerContract].x3Matrix[level].reinvestCount++;
            emit Reinvest(ownerContract, address(0), userAddress, level);
        }
    }

    function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address ref) {
        while (true) {
            if (users[users[userAddress].referrer].activeX3Levels[level]) {
                ref =users[userAddress].referrer;
                return ref;
            }
            userAddress = users[userAddress].referrer;
        }
    }
    
  
    function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeX3Levels[level];
    }

  
    function get3XMatrix(address userAddress, uint8 level) public view returns(address, address[] memory, uint, bool) {
        return (users[userAddress].x3Matrix[level].currentReferrer,
                users[userAddress].x3Matrix[level].referrals,
                users[userAddress].x3Matrix[level].reinvestCount,
                users[userAddress].x3Matrix[level].blocked);
    }

    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function findTronReceiver(address userAddress, address _from, uint8 level) private returns(address receiver, bool isExtraDividends) {
        receiver = userAddress;
            while (true) {
                if (users[receiver].x3Matrix[level].blocked) {
                    emit MissedTronReceive(receiver,users[receiver].id, _from,users[_from].id, level);
                    isExtraDividends = true;
                    receiver = users[receiver].x3Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        
    }

    function sendTronDividends(address userAddress, address _from, uint8 level) private {
        (address receiver, bool isExtraDividends) = findTronReceiver(userAddress, _from, level);
            tokenA.transfer(receiver,  levelPrice[level]);
        emit SentDividends(_from,users[_from].id, receiver,users[receiver].id, level, isExtraDividends);
    }
   
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

}
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }


}