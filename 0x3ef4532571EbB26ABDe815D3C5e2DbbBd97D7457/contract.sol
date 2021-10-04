/***
*     ██████╗ ██████╗  ██████╗ ██████╗ ███████╗      ██████╗  ██████╗██╗  ██╗
*    ██╔════╝██╔═══██╗██╔════╝██╔═══██╗██╔════╝      ██╔══██╗██╔════╝╚██╗██╔╝
*    ██║     ██║   ██║██║     ██║   ██║███████╗█████╗██████╔╝██║      ╚███╔╝ 
*    ██║     ██║   ██║██║     ██║   ██║╚════██║╚════╝██╔══██╗██║      ██╔██╗ 
*    ╚██████╗╚██████╔╝╚██████╗╚██████╔╝███████║      ██████╔╝╚██████╗██╔╝ ██╗
*     ╚═════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝      ╚═════╝  ╚═════╝╚═╝  ╚═╝
*                                                                            
* https://cocos.finance                                
* MIT License
* ===========
*
* Copyright (c) 2020 cocos-bcx
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/// File: contracts/interface/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
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
    function mint(address account, uint amount) external;
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

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following 
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/library/SafeERC20.sol

pragma solidity ^0.5.0;





/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SafeERC20: TRANSFER_FAILED');
    }
    // function safeTransfer(IERC20 token, address to, uint256 value) internal {
    //     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    // }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @openzeppelin/contracts/introspection/IERC165.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.5.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

// File: contracts/interface/ICocosNFT.sol

pragma solidity ^0.5.0;



contract ICocosNFT is IERC721 {

    struct CocosNFT {
        uint256 id;
        uint256 grade;
        uint256 quality;
        uint256 amount;
        uint256 resBaseId;
        uint256 tLevel;
        uint256 ruleId;
        uint256 nftType;
        address author;
        address erc20;
        uint256 createdTime;
        uint256 blockNum;
    }
    
    function mint(address to, uint256 tokenId) external returns (bool) ;
    function burn(uint256 tokenId) external;
}

// File: contracts/interface/ICocosNFTFactory.sol

pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;


interface ICocosNFTFactory {


    function getCocosNFT(uint256 tokenId)
        external view
        returns (
            uint256 grade,
            uint256 quality,
            uint256 amount,
            uint256 resBaseId,
            uint256 tLevel,
            uint256 ruleId,
            uint256 nftType,
            address author,
            address erc20,
            uint256 createdTime,
            uint256 blockNum
        );

    struct MintData{
        uint256 amount;
        uint256 resBaseId;
        uint256 nftType;
        uint256 ruleId;
        uint256 tLevel;
    }

    struct MintExtraData {
        uint256 cocosNFT_id;
        uint256 grade;
        uint256 quality;
        address author;
    }
    function getCocosNFTStruct(uint256 tokenId)
        external view
        returns (ICocosNFT.CocosNFT memory cocosNFT);

    function burn(uint256 tokenId) external returns ( bool );
    
    function isRulerProxyContract(address proxy) external view returns ( bool );
    
    function gmMint(MintData calldata mintData, MintExtraData calldata extraData) external;
}

// File: contracts/library/ReentrancyGuard.sol

pragma solidity ^0.5.0;

contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() internal {
        _status = _NOT_ENTERED;
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
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    function initReentrancyStatus() internal {
        _status = _NOT_ENTERED;
    }
}

// File: contracts/nft/CocosNFTClaimOx.sol

pragma solidity ^0.5.5;








contract CocosNFTClaimOx is ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    // --- Data ---
    bool private initialized; // Flag of initialize data
    address public _governance;

    bool public _isClaimStart = false;
    mapping(address => bool) public _claimMembers;
    mapping(address => bool) public _whitelist;

    uint256 public _qualityBase   = 10000;
    
    
    ICocosNFTFactory public  _cocosNFTFactory;
    ICocosNFT public  _cocosNFT;
    address public _cocosNFTRuleProxy;
    
    

    IERC20 public  _token;
    uint256 public _fiveBlessingEndTime;
    uint256 public _fiveBlessingReward;

    mapping(uint256=>FiveBlessingInfo) public fiveBlessingInfos;
    mapping(uint256=>uint256) public fiveBlessingTotals;
    mapping(uint256=>uint256) public levelForFaceAmounts;

    mapping(uint256=>uint256) public levelForAmounts;

    uint256 cocosTransferAmount;
    uint256 currCocosTransferAmount;
   
    uint256[] public claimNumbers;
    uint256[] public claimNumberForDedications;
    mapping(uint256=>ClaimMerberDedication) public claimMerberDedications;

    struct ClaimMerberDedication {
        uint256 begin;
        uint256 end;
        uint256 number;
        uint256 amount;
        uint256 currAmount;
    }

    struct FiveBlessingInfo {
        uint256 ruleId;
        uint256 nftType;
        uint256 resBaseId;
        uint256 tLevel;
    }
    uint256 public _cocosNFTId = 10000;
    uint256 public _claimNumber = 0;

    event eveCocosNFTAdded(
        uint256 indexed id,
        uint256 grade,
        uint256 quality,
        uint256 amount,
        uint256 createdTime,
        uint256 blockNum,
        uint256 resId,
        address author,
        uint256 ruleId
    );

    event eveCocosNFTBurnWithdrawToken(
        address owner,
        uint256 amount,
        address erc20
    );

    event NFTReceived(address operator, address from, uint256 tokenId, bytes data);
    event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyGovernance {
        require(msg.sender == _governance, "not governance");
        _;
    }

    modifier checkRuleProxy {
        require(msg.sender == _cocosNFTRuleProxy, "not this cocosNFTRuleProxy");
        _;
    }


    // --- Init ---
    function initialize(
        ICocosNFTFactory cocosNFTFactory, 
        uint256 cocosNFTId, 
        ICocosNFT cocosNFT,
        address cocosNFTRuleProxy,
        address rewardToken,
        uint256 fiveBlessingEndTime,
        uint256 fiveBlessingReward,
        uint256 transferAmount
        ) 
        public 
    {
        require(!initialized, "initialize: Already initialized!");
        _governance = msg.sender;

        levelForAmounts[1] = 0.01 ether;
        levelForAmounts[2] = 0.02 ether;
        levelForAmounts[3] = 0.03 ether;
        levelForAmounts[4] = 0.04 ether;
        levelForAmounts[5] = 0.05 ether;
        levelForAmounts[6] = 1 ether;


        levelForFaceAmounts[1] = 1 ether;
        levelForFaceAmounts[2] = 2 ether;
        levelForFaceAmounts[3] = 3 ether;
        levelForFaceAmounts[4] = 4 ether;
        levelForFaceAmounts[5] = 5 ether;
        levelForFaceAmounts[6] = 100 ether;

        _qualityBase = 10000;

        _token = IERC20(rewardToken);
        _fiveBlessingEndTime = fiveBlessingEndTime;

        uint256 balBefore = _token.balanceOf(address(this));
        _token.safeTransferFrom(msg.sender, address(this), fiveBlessingReward.add(transferAmount));
        uint256 balEnd = _token.balanceOf(address(this));
        _fiveBlessingReward = fiveBlessingReward;
        cocosTransferAmount = balEnd.sub(balBefore).sub(_fiveBlessingReward);

        _cocosNFTFactory = cocosNFTFactory;
        _cocosNFT = cocosNFT;
        _cocosNFTId = cocosNFTId;
        _cocosNFTRuleProxy = cocosNFTRuleProxy;

        initReentrancyStatus();
        initialized = true;
    }

    


    function computerSeed() private view returns (uint256) {
        // from fomo3D
        uint256 seed = uint256(keccak256(abi.encodePacked(
            
            (block.timestamp).add
            (block.difficulty).add
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
            (block.gaslimit).add
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
            (block.number)
            
        )));
        return seed;
    }

    function simpleComputerSeed(uint seed) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, now, seed)));
        return random % 10000;
    }


    function getNFTType(uint256 quality) public view returns (uint256){
        if( quality < _qualityBase.mul(640).div(1000)){
            return 1;
        }else {
            return 2;
        }
    }

    function getGrade(uint256 quality) public view returns (uint256){
        if( quality < _qualityBase.mul(218).div(1000)){
            return 1;
        }else if( _qualityBase.mul(218).div(1000) <= quality && quality <  _qualityBase.mul(687).div(1000)){
            return 2;
        }else if( _qualityBase.mul(687).div(1000) <= quality && quality <  _qualityBase.mul(843).div(1000)){
            return 3;
        }else if( _qualityBase.mul(843).div(1000) <= quality && quality <  _qualityBase.mul(968).div(1000)){
            return 4;
        }else if( _qualityBase.mul(968).div(1000) <= quality && quality <  _qualityBase.mul(996).div(1000)){
            return 5;
        }else{
            return 6;
        }
    }


    function getGradeFiveBlessingEnd(uint256 quality) public view returns (uint256){
        if( quality < _qualityBase.mul(500).div(1000)){
            return 1;
        }else if( _qualityBase.mul(500).div(1000) <= quality && quality <  _qualityBase.mul(800).div(1000)){
            return 2;
        }else if( _qualityBase.mul(800).div(1000) <= quality && quality <  _qualityBase.mul(900).div(1000)){
            return 3;
        }else if( _qualityBase.mul(900).div(1000) <= quality && quality <  _qualityBase.mul(980).div(1000)){
            return 4;
        }else if( _qualityBase.mul(980).div(1000) <= quality && quality <  _qualityBase.mul(998).div(1000)){
            return 5;
        }else{
            return 6;
        }
    }



    function getOxNFTType(uint256 quality) public view returns (uint256){
        if( quality <= _qualityBase.mul(400).div(1000)){
            return 1;
        }else if( _qualityBase.mul(400).div(1000) <= quality && quality <  _qualityBase.mul(650).div(1000)){
            return 2;
        }else if( _qualityBase.mul(650).div(1000) <= quality && quality <  _qualityBase.mul(850).div(1000)){
            return 3;
        }else{
            return 4;
        }
    }

    function getNalmolQuality(uint256 grade,uint256 seed) public pure returns (uint256 unfold){
        uint256 qMod = 0;
        if( grade == 1 ){
            qMod = seed % 4999;
            unfold = 4999-qMod;
        }else if( grade == 2){
            qMod = seed % 3000;
            unfold =7999-qMod;
        }else if( grade == 3){
            qMod = seed % 1000;
            unfold = 8999-qMod;
        }else if( grade == 4){
            qMod = seed % 800;
            unfold = 9799-qMod;
        }else if( grade == 5){
            qMod = seed % 80;
            unfold = 9979-qMod;
        }else{
            qMod = seed % 20;
            unfold = 9999-qMod;
        }
    }

    function getCurrClaimInterregional(uint256 _claimNum) public view returns (uint256){
        for (uint256 i = 0;i< claimNumbers.length-1;i++){
            if (_claimNum >claimNumbers[i] && _claimNum <=claimNumbers[i+1]){
                return i;
            }
        }
        return claimNumbers.length-2;
    }


    function getCurrClaimDedication(uint256 seed,uint256 total,uint amount) public pure returns (bool){
       return seed.mod(total) < amount;
    }

    function claim() public nonReentrant{
        require(_isClaimStart == true, "claim not start"); 
        require(_claimMembers[msg.sender] == false, "has claim");
        require(_whitelist[msg.sender] == true, "not in whitelist");

        _cocosNFTId++;
        _claimNumber = _claimNumber+1;

        uint256 quality = 4999;
        uint256 grade = 1;
        uint256 amount = 0;
        uint256 _fiveBlessingInfoIndex = 0;

        FiveBlessingInfo memory _fiveBlessingInfo;
        uint256 seed = computerSeed();
       

        uint256 index = getCurrClaimInterregional(_claimNumber);

        bool isGotten = false;

        ClaimMerberDedication storage _claimMerberDedication = claimMerberDedications[index];
        uint256 leftAmount = _claimMerberDedication.amount.sub(_claimMerberDedication.currAmount);
        if (leftAmount > 0 && now <= _fiveBlessingEndTime){
            if (_claimMerberDedication.end.sub(leftAmount) == _claimNumber.sub(1)){
                _fiveBlessingInfoIndex = 5;
                isGotten = true;
            }else{
                bool isDedication = getCurrClaimDedication(seed,_claimMerberDedication.number,_claimMerberDedication.amount);
                if (isDedication){
                    _fiveBlessingInfoIndex = 5;
                    isGotten = true;
                }
            }
        }

        if (isGotten){
            _claimMerberDedication.currAmount = _claimMerberDedication.currAmount.add(1); 
        }else{
            uint256 simpleSeed = simpleComputerSeed(seed);
            quality = seed%_qualityBase;

            uint256 nftType = getNFTType(simpleSeed);

            if (now < _fiveBlessingEndTime && nftType == 2){
                _fiveBlessingInfoIndex = getOxNFTType(quality);
                quality = 4999;
            }else{
                if (now < _fiveBlessingEndTime){
                    grade = getGrade(quality);
                }else{
                    grade = getGradeFiveBlessingEnd(quality);
                }
                quality = getNalmolQuality(grade,simpleSeed);
                _fiveBlessingInfoIndex = 0;
            }
        }
        _fiveBlessingInfo = fiveBlessingInfos[_fiveBlessingInfoIndex];
        fiveBlessingTotals[_fiveBlessingInfoIndex] ++;

        amount = levelForFaceAmounts[grade];
        ICocosNFTFactory.MintData memory mintData = ICocosNFTFactory.MintData(amount, _fiveBlessingInfo.resBaseId, _fiveBlessingInfo.nftType, _fiveBlessingInfo.ruleId, _fiveBlessingInfo.tLevel);
        ICocosNFTFactory.MintExtraData memory mintExtraData = ICocosNFTFactory.MintExtraData(_cocosNFTId, grade, quality, msg.sender);
        _cocosNFTFactory.gmMint(mintData, mintExtraData);
        _claimMembers[msg.sender] = true;

        uint256 sendAmount = levelForAmounts[grade];
        require(cocosTransferAmount.sub(currCocosTransferAmount).sub(sendAmount)>=0,"send amount not enough");
        currCocosTransferAmount = currCocosTransferAmount.add(sendAmount);
        _token.safeTransfer(msg.sender, sendAmount);

        uint256 tmpGrade = grade;
        uint256 tmpQuality = quality;
        uint256 tmpAmount = amount;
        uint256 tmpResBaseId = _fiveBlessingInfo.resBaseId;
        uint256 tmpRuleId = _fiveBlessingInfo.ruleId;

        emit eveCocosNFTAdded (
            _cocosNFTId,
            tmpGrade,
            tmpQuality,
            tmpAmount,
            block.timestamp,
            block.number,
            tmpResBaseId,
            msg.sender,
            tmpRuleId
        );
    }



    function getStakeInfo( uint256 cocosNFTId ) public view returns (uint256 ruleId){
        ( , , , , ,ruleId, , , , , ) = _cocosNFTFactory.getCocosNFT(cocosNFTId);
    }

    function mergeFiveBlessing(uint256[] memory cocosNFTIds) public  returns (uint256 gotToken){
        require(cocosNFTIds.length ==5, "cocosNFT not enough");
        require(now > _fiveBlessingEndTime, "mergeFiveBlessing not start");
        require(fiveBlessingTotals[5] >0, "something is error");
        uint256 ruleId;
        for (uint256 i = 0; i < cocosNFTIds.length; i++) {
            ruleId = getStakeInfo(cocosNFTIds[i]);
            require(fiveBlessingInfos[i+1].ruleId == ruleId,"rule id error");
            _cocosNFT.safeTransferFrom(msg.sender, address(this), cocosNFTIds[i]);
        }
        gotToken = _fiveBlessingReward.div(fiveBlessingTotals[5]);
        _token.safeTransfer(msg.sender, gotToken);
    }
    

    function burnWithdrawToken(address erc20, address owner, uint256 amount) public checkRuleProxy nonReentrant {
        require(amount > 0, "the cocosNFT not token");
        IERC20(erc20).safeTransfer(owner, amount);
        emit eveCocosNFTBurnWithdrawToken(owner, amount, erc20);
    }

    function setClaimStart(bool start) public onlyGovernance {
        _isClaimStart = start;
    }


    function addWhitelist(address member) external onlyGovernance {
        _whitelist[member] = true;
    }

    function removeWhitelist(address member) external onlyGovernance {
        _whitelist[member] = false;
    }
    /// @dev batch set quota for user admin
    /// if openTag <=0, removed 
    function setWhitelist(address[] calldata users, bool openTag)
        external
        onlyGovernance
    {
        for (uint256 i = 0; i < users.length; i++) {
            _whitelist[users[i]] = openTag;
        }
    }

    function setClaimMemberForDedication(uint256[] memory claimMerberNumbers_,uint256[] memory claimNumberForDedications_) public  onlyGovernance{
        require(claimMerberNumbers_.length -1 == claimNumberForDedications_.length && claimMerberNumbers_.length -2 >= 0);
        // claimMerberNumbers = [0,1000,3000,6000,10000,12000,16000,22000,30000,32000,36000,42000,50000];
        // claimNumberForDedications = [1,2,1,1,2,2,3,3,1,2,1,1];
        // for (uint256 i = 0;i< claimMerberNumbers_.length;i++){
        //     claimNumbers[i] = claimMerberNumbers_[i];
        // }
        // for (uint256 i = 0;i< claimNumberForDedications_.length;i++){
        //     claimNumberForDedications[i] = claimNumberForDedications[i];
        // }
        claimNumbers = claimMerberNumbers_;
        claimNumberForDedications = claimNumberForDedications_;
        for (uint256 i = 0;i< claimNumberForDedications.length;i++){
            uint256 baseNum = claimNumbers[i+1].sub(claimNumbers[i]);
            claimMerberDedications[i] = ClaimMerberDedication(claimNumbers[i],claimNumbers[i+1],baseNum,claimNumberForDedications[i],0);
        }
    }

    function setRuleProxy(address cocosNFTRuleProxy)  public  onlyGovernance {
        _cocosNFTRuleProxy  = cocosNFTRuleProxy;
    }

    function setCurrentCocosNFTId(uint256 id)  public  onlyGovernance {
        _cocosNFTId = id;
    }

    function setGovernance(address governance)  public  onlyGovernance {
        require(governance != address(0), "new governance the zero address");
        _governance = governance;
        emit GovernanceTransferred(_governance, governance);
    }


    function setFiveBlessingType(uint256 fiveBlessingId,uint256 ruleId, uint256 nftType, uint256 resBaseId, uint256 tLevel) 
    public 
    onlyGovernance 
    {
        FiveBlessingInfo memory fiveBlessingInfo;
        fiveBlessingInfo.ruleId = ruleId;
        fiveBlessingInfo.nftType = nftType;
        fiveBlessingInfo.resBaseId = resBaseId;
        fiveBlessingInfo.tLevel = tLevel;
        fiveBlessingInfos[fiveBlessingId] = fiveBlessingInfo;
    }

    function addTransferAmount(uint256 amount) public  onlyGovernance {
        uint256 balBefore = _token.balanceOf(address(this));
        _token.safeTransferFrom(msg.sender, address(this), amount);
        uint256 balEnd = _token.balanceOf(address(this));
        uint256 addAmount = balEnd.sub(balBefore);
        cocosTransferAmount = cocosTransferAmount.add(addAmount);
    }

    function emergencySeize(IERC20 asset, uint256 amount) public onlyGovernance {
        uint256 balance = asset.balanceOf(address(this));
        require(balance > amount, "less balance");
        asset.safeTransfer(_governance, amount);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
        //only receive the _nft staff
        if(address(this) != operator) {
            //invalid from nft
            return 0;
        }
        //success
        emit NFTReceived(operator, from, tokenId, data);
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

}