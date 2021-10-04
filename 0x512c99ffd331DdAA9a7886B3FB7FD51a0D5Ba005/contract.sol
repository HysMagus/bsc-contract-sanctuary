// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
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
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
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
     *
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
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) =
            target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IBEP20 {
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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract ContractGuard {
    using Address for address;

    modifier noContract(address account) {
        require(
            Address.isContract(account) == false,
            "Contracts are not allowed to interact with the Offertory"
        );
        _;
    }
}

interface IPancakePair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

contract D100Presale is Ownable, ReentrancyGuard, ContractGuard {
    using SafeMath for uint256;
    using Address for address;

    address public FuelToken = 0x2090c8295769791ab7A3CF1CC6e0AA19F35e441A;
    address public JetsToken = 0xf6488205957f0b4497053d6422F49e27944eE3Dd;
    address public BusdToken = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address public FuelBNBPool = 0x3763A3263CEaca5e7Cc1Bc22A43920bAd9f743Cd;
    address public BnbBusdPool = 0x1B96B92314C44b159149f7E0303511fB2Fc4774f;

    uint256 public bonusFee = 5;
    uint256 public presaleCapInBUSD = 5 * 1e23; // 500k BUSD
    uint256 public maxPurchasableTokenPerWallet = 5250 * 1e9; // 5000 D100 considering 5% JETS bonus

    address public D100Token;
    uint256 public salePrice = 2E18; // 2 BUSD
    uint256 public totalPurchasedBUSD;
    uint256 public unclaimedPurchasedToken;
    bool public isPreSaleOver;
    uint256 public startTime;
    uint256 public endTime;

    mapping(address => uint256) public purchasedToken;
    modifier isNotOver() {
        require(!isPreSaleOver, "D100_PRESALE:presale is over");
        require(block.timestamp >= startTime, "D100_PRESALE:presale is not started yet");
        require(block.timestamp <= endTime, "D100_PRESALE:presale is ended");
        _;
    }
    modifier isOver() {
        require(isPreSaleOver || block.timestamp < startTime || block.timestamp > endTime, "D100_PRESALE:presale not over yet");
        _;
    }

    constructor(address _D100Token, uint256 _startTime, uint256 _endTime) public {
        require(
            _D100Token != address(0x0),
            "D100Presale: D100 address is 0x0."
        );
        D100Token = _D100Token;
        isPreSaleOver = false;
        startTime = _startTime;
        endTime = _endTime;
    }

    function presaleIsOn() public view returns (bool) {
        if(isPreSaleOver || block.timestamp < startTime || block.timestamp > endTime)
            return false;
        return true;
    }

    function setIsOver() public onlyOwner {
        isPreSaleOver = true;
    }

    function setIsOn() public onlyOwner {
        isPreSaleOver = false;
    }

    function setSalePrice(uint256 _salePrice) public onlyOwner {
        salePrice = _salePrice;
    }

    function setStartTime(uint256 _startTime) public onlyOwner {
         startTime = _startTime;
    }

    function setEndTime(uint256 _endTime) public onlyOwner {
        endTime = _endTime;
    }

    function setPresaleCapInBUSD(uint256 _presaleCapInBUSD) public onlyOwner {
        presaleCapInBUSD = _presaleCapInBUSD;
    }    

    function setmaxPurchasableTokenPerWallet(uint256 _maxPurchasableTokenPerWallet) public onlyOwner {
        maxPurchasableTokenPerWallet = _maxPurchasableTokenPerWallet;
    }

    function getBnbPriceInUSD() public view returns (uint256) {
        (uint256 bnbReserve, uint256 busdReserve, ) =
            IPancakePair(BnbBusdPool).getReserves();
        return busdReserve.mul(1e10).div(bnbReserve);
    }

    function getFuelPriceInUSD(uint256 BnbPriceInUSD)
        public
        view
        returns (uint256)
    {
        (uint256 fuelReserve, uint256 bnbReserve, ) =
            IPancakePair(FuelBNBPool).getReserves();
        return
            bnbReserve.mul(1e10).div(fuelReserve).mul(BnbPriceInUSD).div(1e10);
    }

    function getJetsPriceInUSD(uint256 FuelPriceInUSD)
        public
        view
        returns (uint256)
    {
        uint256 fuelBalance = IBEP20(FuelToken).balanceOf(JetsToken);
        uint256 jetsBalance = IBEP20(JetsToken).totalSupply();
        return
            fuelBalance.mul(1e10).div(jetsBalance).mul(FuelPriceInUSD).div(
                1e10
            );
    }

    function getEstimation(address buyer, uint256 purchaseBusdAmount)
        public
        view
        returns (uint256)
    {
        uint256 BnbPriceInUSD = getBnbPriceInUSD();
        uint256 FuelPriceInUSD = getFuelPriceInUSD(BnbPriceInUSD);
        uint256 JetsPriceInUSD = getJetsPriceInUSD(FuelPriceInUSD);

        uint256 puchaserJetsValueInUSD =
            IBEP20(JetsToken).balanceOf(buyer).mul(JetsPriceInUSD);

        uint256 purchaseValueInUSD = purchaseBusdAmount.mul(1e10);

        uint256 purchaseD100Amount;
        if (puchaserJetsValueInUSD > 0) {
            if (puchaserJetsValueInUSD >= purchaseValueInUSD) {
                purchaseD100Amount = purchaseValueInUSD
                    .mul(uint256(100).add(bonusFee))
                    .div(100)
                    .div(1e19);
            } else {
                purchaseD100Amount = puchaserJetsValueInUSD
                    .mul(uint256(100).add(bonusFee))
                    .div(100)
                    .div(1e19);
                purchaseD100Amount = purchaseD100Amount.add(
                    purchaseValueInUSD.sub(puchaserJetsValueInUSD).div(1e19)
                );
            }
        } else {
            purchaseD100Amount = purchaseValueInUSD.div(1e19);
        }
        
        // calculate the token amount to return considering the salePrice
        return purchaseD100Amount.mul(1e18).div(salePrice);
    }

    function purchase(uint256 purchaseBusdAmount)
        external
        nonReentrant
        noContract(msg.sender)
        isNotOver
    {
        require(
            IBEP20(BusdToken).balanceOf(address(this)) <
                presaleCapInBUSD,
            "D100_PRESALE: we already sold all."
        );
        uint256 BnbPriceInUSD = getBnbPriceInUSD();
        uint256 FuelPriceInUSD = getFuelPriceInUSD(BnbPriceInUSD);
        uint256 JetsPriceInUSD = getJetsPriceInUSD(FuelPriceInUSD);

        uint256 puchaserJetsValueInUSD =
            IBEP20(JetsToken).balanceOf(_msgSender()).mul(JetsPriceInUSD);

        uint256 purchaseValueInUSD = purchaseBusdAmount.mul(1e10);

        uint256 purchaseD100Amount;
        if (puchaserJetsValueInUSD > 0) {
            if (puchaserJetsValueInUSD >= purchaseValueInUSD) {
                purchaseD100Amount = purchaseValueInUSD
                    .mul(uint256(100).add(bonusFee))
                    .div(100)
                    .div(1e19);
            } else {
                purchaseD100Amount = puchaserJetsValueInUSD
                    .mul(uint256(100).add(bonusFee))
                    .div(100)
                    .div(1e19);
                purchaseD100Amount = purchaseD100Amount.add(
                    purchaseValueInUSD.sub(puchaserJetsValueInUSD).div(1e19)
                );
            }
        } else {
            purchaseD100Amount = purchaseValueInUSD.div(1e19);
        }

        // calculate the token amount to return considering the salePrice
        purchaseD100Amount = purchaseD100Amount.mul(1e18).div(salePrice);

        totalPurchasedBUSD = totalPurchasedBUSD.add(purchaseBusdAmount);

        IBEP20(BusdToken).transferFrom(
            _msgSender(),
            address(this),
            purchaseBusdAmount
        );
        
        unclaimedPurchasedToken = unclaimedPurchasedToken.add(purchaseD100Amount);
        purchasedToken[_msgSender()] = purchasedToken[_msgSender()].add(
            purchaseD100Amount
        );

        require(purchasedToken[_msgSender()] <= maxPurchasableTokenPerWallet, "D100_PRESALE: exceeded max purchasable D100 amount per wallet.");
        
        //IBEP20(D100Token).transfer(_msgSender(), purchaseD100Amount);
    }

    function claimPurchased()
        external
        nonReentrant
        noContract(msg.sender)
        isOver
    {
        require(
            IBEP20(BusdToken).balanceOf(address(this)) >=
                presaleCapInBUSD ||
                isPreSaleOver,
            "D100_PRESALE: not sold or not over yet."
        );
        uint256 amount = purchasedToken[_msgSender()];
        require(amount > 0, "D100_PRESALE: zero amount");

        purchasedToken[_msgSender()] = 0;
        unclaimedPurchasedToken = unclaimedPurchasedToken.sub(amount);
        IBEP20(D100Token).transfer(_msgSender(), amount);
    }

    function withdrawBUSDAfterPresaleOver() public onlyOwner isOver {
        IBEP20(BusdToken).transfer(
            _msgSender(),
            IBEP20(BusdToken).balanceOf(address(this))
        );
    }

    function withdrawD100AfterPresaleOver() public onlyOwner isOver {
        uint256 amount =
            IBEP20(D100Token).balanceOf(address(this)).sub(
                unclaimedPurchasedToken
            );
        require(amount > 0, "D100_PRESALE: zero amount");
        IBEP20(D100Token).transfer(_msgSender(), amount);
    }
}