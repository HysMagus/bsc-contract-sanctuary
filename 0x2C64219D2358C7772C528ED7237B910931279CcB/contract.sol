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
*/// File: @openzeppelin/contracts/utils/Address.sol

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

// File: contracts/interface/IERC20.sol

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

// File: contracts/interface/ICocosNFTRuleProxy.sol

pragma solidity ^0.5.0;




interface ICocosNFTRuleProxy  {

    struct Cost721Asset{
        uint256 costErc721Id1;
        uint256 costErc721Id2;
        uint256 costErc721Id3;

        address costErc721Origin;
    }

    struct MintParams{
        address user;
        uint256 amount;
        uint256 ruleId;
    }

    function cost( MintParams calldata params, Cost721Asset calldata costSet1, Cost721Asset calldata costSet2 ) external returns (
        uint256 mintAmount,
        address mintErc20
    ) ;

    function destroy( address owner, ICocosNFT.CocosNFT calldata cocosNFT ) external ;

    function generate( address user,uint256 ruleId ) external view returns (ICocosNFT.CocosNFT memory cocosNFT );

}

// File: contracts/interface/ICocosNFTClaim.sol

pragma solidity ^0.5.0;

interface ICocosNFTClaim {

    function burnWithdrawToken(address erc20, address owner, uint256 amount) external;

}

// File: contracts/nft/CocosNFTClaimProxy.sol

pragma solidity ^0.5.0;








contract CocosNFTClaimProxy is ICocosNFTRuleProxy{
    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // --- Data ---
    bool private initialized; // Flag of initialize data
    address public _governance;

    uint256 public _qualityBase = 10000;
    uint256 public _maxGrade = 6;
    uint256 public _maxGradeLong = 20;
    uint256 public _maxTLevel = 6;

    bool public _canAirdrop = false;
    uint256 public _airdopMintAmount = 5 * (10**15);
    IERC20 public _airdropToken = IERC20(0x0);
    ICocosNFTClaim public _cocosNFTClaim = ICocosNFTClaim(0x0);

    struct RuleData{
        uint256 minMintAmount;
        uint256 maxMintAmount;
        uint256 costErc20Amount;
        address mintErc20;
        address costErc20;
        uint256 minBurnTime;
        uint256 tLevel;
        bool canMintMaxGrade;
        bool canMintMaxTLevel;
    }

    address public _costErc20Pool = address(0x0);
    ICocosNFTFactory public _factory = ICocosNFTFactory(0x0);

    event eSetRuleData(uint256 ruleId, uint256 minMintAmount, uint256 maxMintAmount, uint256 costErc20Amount, address mintErc20, address costErc20, bool canMintMaxGrade,bool canMintMaxTLevel,uint256 minBurnTime);
    event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);

    mapping(uint256 => RuleData) public _ruleData;
    mapping(uint256 => bool) public _ruleSwitch;
    
    modifier onlyGovernance {
        require(msg.sender == _governance, "not governance");
        _;
    }

    

    // --- Init ---
    function initialize(
        address costErc20Pool, 
        address airdropToken, 
        address cocosNFTClaim) 
        public 
    {
        require(!initialized, "initialize: Already initialized!");
        _governance = msg.sender;
        _costErc20Pool = costErc20Pool;
        _airdropToken = IERC20(airdropToken);
        _cocosNFTClaim = ICocosNFTClaim(cocosNFTClaim);

        _qualityBase = 10000;
        _maxGrade = 6;
        _maxGradeLong = 20;
        _maxTLevel = 6;
        _canAirdrop = false;
        _airdopMintAmount = 5 * (10**15);
        initialized = true;
    }

    function setGovernance(address governance)  public  onlyGovernance {
        require(governance != address(0), "new governance the zero address");
        _governance = governance;
        emit GovernanceTransferred(_governance, governance);
    }

    function setAirdropAmount(uint256 value) public onlyGovernance{
        _airdopMintAmount =  value;
    }

    function enableAirdrop(bool b) public onlyGovernance{
        _canAirdrop =  b;
    }


    function setQualityBase(uint256 val) public onlyGovernance{
        _qualityBase =  val;
    }

    function setMaxGrade(uint256 val) public onlyGovernance{
        _maxGrade =  val;
    }

    function setMaxTLevel(uint256 val) public onlyGovernance{
        _maxTLevel =  val;
    }

    function setMaxGradeLong(uint256 val) public onlyGovernance{
        _maxGradeLong =  val;
    }


    function setAirdropContract(address airdropToken)  public  
        onlyGovernance{
        _airdropToken = IERC20(airdropToken);
    }

    function setRuleData(
        uint256 ruleId, 
        uint256 minMintAmount, 
        uint256 maxMintAmount, 
        uint256 costErc20Amount, 
        address mintErc20, 
        address costErc20,
        uint256 minBurnTime,
        uint256 tLevel,
        bool canMintMaxGrade,
        bool canMintMaxTLevel
         )
        public
        onlyGovernance
    {
        _ruleData[ruleId].minMintAmount = minMintAmount;
        _ruleData[ruleId].maxMintAmount = maxMintAmount;
        _ruleData[ruleId].costErc20Amount = costErc20Amount;
        _ruleData[ruleId].mintErc20 = mintErc20;
        _ruleData[ruleId].costErc20 = costErc20;
        _ruleData[ruleId].minBurnTime = minBurnTime;
        _ruleData[ruleId].canMintMaxGrade = canMintMaxGrade;
        _ruleData[ruleId].canMintMaxTLevel = canMintMaxTLevel;
        _ruleData[ruleId].tLevel = tLevel;

        _ruleSwitch[ruleId] = false;

        emit eSetRuleData( ruleId,  minMintAmount,  maxMintAmount,  costErc20Amount,  mintErc20,  costErc20, canMintMaxGrade, canMintMaxTLevel,minBurnTime);
    }


     function enableRule( uint256 ruleId,bool enable )         
        public
        onlyGovernance 
     {
        _ruleSwitch[ruleId] = enable;
     }

     function setFactory( address factory )         
        public
        onlyGovernance 
     {
        _factory = ICocosNFTFactory(factory);
     }

    function cost( MintParams calldata params, Cost721Asset calldata costSet1, Cost721Asset calldata costSet2 ) external returns (  uint256 mintAmount,address mintErc20 ){
        require( _factory == ICocosNFTFactory(msg.sender)," invalid factory caller" );
       (mintAmount,mintErc20) =  _cost(params,costSet1,costSet2);
    } 

    function destroy(  address owner, ICocosNFT.CocosNFT calldata cocosNFT) external {
        require( _factory == ICocosNFTFactory(msg.sender)," invalid factory caller" );
        
        // rule proxy ignore mint time
        if( _factory.isRulerProxyContract(owner) == false){
            uint256 minBurnTime = _ruleData[cocosNFT.ruleId].minBurnTime;
            require( (block.timestamp - cocosNFT.createdTime) >=  minBurnTime, "< minBurnTime"  );
        }

        // IERC20 erc20 = IERC20(cocosNFT.erc20);
        // erc20.safeTransfer(owner, cocosNFT.amount);
        _cocosNFTClaim.burnWithdrawToken(cocosNFT.erc20, owner, cocosNFT.amount);
    } 


    function generate(address user , uint256 ruleId ) external view returns (ICocosNFT.CocosNFT memory cocosNFT ){
        require( _factory == ICocosNFTFactory(msg.sender) ," invalid factory caller" );
        require(_ruleSwitch[ruleId], " rule is closed ");
        require(false, "can't mint");
        user;
        ICocosNFT.CocosNFT memory _cocosNFT;
        return _cocosNFT;
    } 

    function _cost( MintParams memory params, Cost721Asset memory costSet1, Cost721Asset memory costSet2 ) internal returns (  uint256 mintAmount,address mintErc20 ){
        // require( _ruleData[params.ruleId].mintErc20 != address(0x0), "invalid mintErc20 rule !");
        // require( _ruleData[params.ruleId].costErc20 != address(0x0), "invalid costErc20 rule !");
        // require( params.amount >= _ruleData[params.ruleId].minMintAmount && params.amount < _ruleData[params.ruleId].maxMintAmount, "invalid mint amount!");

        // IERC20 mintIErc20 = IERC20(_ruleData[params.ruleId].mintErc20);
        // uint256 balanceBefore = mintIErc20.balanceOf(address(this));
        // mintIErc20.safeTransfer(params.user, address(this), params.amount);
        // uint256 balanceEnd = mintIErc20.balanceOf(address(this));

        uint256 costErc20Amount = _ruleData[params.ruleId].costErc20Amount;
        if(costErc20Amount > 0){
            IERC20 costErc20 = IERC20(_ruleData[params.ruleId].costErc20);
            costErc20.safeTransferFrom(params.user, _costErc20Pool, costErc20Amount);
        }

        costSet1;
        costSet2;

        mintAmount = params.amount;
        mintErc20 = _ruleData[params.ruleId].mintErc20;

        _airdrop(params.user);
    } 

    function _airdrop(address user) internal  {
        if(_canAirdrop){
            _airdropToken.mint(user, _airdopMintAmount); 
        }
    }

    function getGrade(uint256 quality) public view returns (uint256){
        
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

    function computerSeed( address user ) internal view returns (uint256) {
        // from fomo3D
        uint256 seed = uint256(keccak256(abi.encodePacked(
            //(user.balance).add
            (block.timestamp).add
            (block.difficulty).add
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
            (block.gaslimit).add
            ((uint256(keccak256(abi.encodePacked(user)))) / (now)).add
            (block.number)
            
        )));
        return seed;
    }


}