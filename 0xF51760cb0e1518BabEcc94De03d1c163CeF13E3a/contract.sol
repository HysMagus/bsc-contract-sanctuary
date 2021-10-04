// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity ^0.6.0;

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

// File: contracts/bscswap/interfaces/IBSCswapRouter01.sol

pragma solidity >=0.6.2;

interface IBSCswapRouter01 {
    function factory() external pure returns (address);
    function WBNB() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityBNB(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountBNB, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityBNB(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountBNB);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityBNBWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountBNB);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactBNBForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactBNB(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForBNB(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapBNBForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts/bscswap/interfaces/IBSCswapRouter02.sol

pragma solidity >=0.6.2;


interface IBSCswapRouter02 is IBSCswapRouter01 {
    function removeLiquidityBNBSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline
    ) external returns (uint amountBNB);
    function removeLiquidityBNBWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountBNBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountBNB);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactBNBForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForBNBSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// File: contracts/bscswap/interfaces/IBSCswapPair.sol

pragma solidity >=0.5.0;

interface IBSCswapPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: contracts/bscswap/libraries/SafeMath.sol

pragma solidity =0.6.12;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMathBSCswap {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/bscswap/libraries/BSCswapLibrary.sol

pragma solidity >=0.5.0;



library BSCswapLibrary {
    using SafeMathBSCswap for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'BSCswapLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'BSCswapLibrary: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'b1e98e21a5335633815a8cfb3b580071c2e4561c50afd57a8746def9ed890b18' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IBSCswapPair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'BSCswapLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'BSCswapLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'BSCswapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'BSCswapLibrary: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'BSCswapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'BSCswapLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'BSCswapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'BSCswapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// File: contracts/bscswap/interfaces/IBSCswapFactory.sol

pragma solidity >=0.5.0;

interface IBSCswapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function migrator() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
    function setMigrator(address) external;
}

// File: contracts/bscswap/interfaces/IWBNB.sol

pragma solidity >=0.5.0;

interface IWBNB {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

// File: contracts/JulProtocol.sol


pragma solidity 0.6.12;

contract JulProtocol is Ownable {
    // should be changed on mainnet deployment ///////////////////////////////////////////////////////
    // uint256 constant TIME_LIMIT = 86400; //15 minutes for testing , normally 1 days              //
    uint256 constant TIME_LIMIT = 86400; //120 : 2 minutes for testing , normally 1 days   86400    //
    uint256 constant MINIMUM_DEPOSIT_AMOUNT = 5 * 10 ** 18 ;    //0.5 eth for testing    , 5        //
    address public router02Address = 0xbd67d157502A23309Db761c41965600c2Ec788b2;                    //
    address public BSCSWAP_FACTORY = 0x553990F2CBA90272390f62C5BDb1681fFc899675;                    //
    uint256 constant DEPOSIT_WITHDRAWAL_FEE = 100; // 1%                                            //
    uint256 constant LOCKED_TOKEN_AMOUNT = 75000 * 10 ** 18; // 75K                                 //
    uint256 constant INITIAL_INTEREST_RADIO = 40; // 0.4 %                                          //
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    uint256 lockedTokens; 

    IBSCswapRouter02 public bscswapRouter02;
    address private WBNB;

    address TOKEN;
    IERC20 JulToken;
    
    bool public release1 = false;
    bool public release2 = false;
    bool public release3 = false;
    bool public release4 = false;

    uint256 public totalEthFee;
    uint256 public interestRadio; // interest setting 0.0% ~ 0.5 %

    event interestRadioChanged(uint256 newInterestRadio);
    event tokenReleased(uint256 stages, uint256 tokenAmount);
    event withdrawFeeRaised(uint256 withdrawedAmount);

    constructor(address token) public payable {
        TOKEN = token;
        JulToken = IERC20(token);

        bscswapRouter02 = IBSCswapRouter02(router02Address);
        WBNB = bscswapRouter02.WBNB();

        lockedTokens = LOCKED_TOKEN_AMOUNT;
        
        interestRadio = INITIAL_INTEREST_RADIO;
    }

    struct UserDeposits {
        uint256 amountBNB;
        uint256 lastDepositedDate;
        uint256 pendingBNB;
    }

    mapping(address => UserDeposits) public protocolusers;

    function calculatePercent(uint256 _eth, uint256 _percent)
        public
        pure
        returns (uint256 interestAmt)
    {
        return (_eth * _percent) / 10000;
    }
    
    function calculateInterest(address _user) private
    {
        require(protocolusers[_user].lastDepositedDate > 0, "this is first deposite.");
        require(now > protocolusers[_user].lastDepositedDate, "now should be greater than last deposited date");
        uint256 time = now - protocolusers[_user].lastDepositedDate;
        if(now > protocolusers[_user].lastDepositedDate && time >= TIME_LIMIT)
        {
            uint256 nd = time / TIME_LIMIT;
            protocolusers[_user].pendingBNB = protocolusers[_user].pendingBNB + calculatePercent(protocolusers[_user].amountBNB, interestRadio) * nd;
            protocolusers[_user].lastDepositedDate = now;
        }
    }

    function addBNB()
        public
        payable
        returns (
            uint256 amountToken,
            uint256 amountBNB,
            uint256 liquidity
        )
    {
        require(msg.value >= MINIMUM_DEPOSIT_AMOUNT, "Insufficient BNB");  
        
        uint256 txFee = calculatePercent(msg.value, DEPOSIT_WITHDRAWAL_FEE); // 1 % deposit fee
        uint ethAmount = msg.value - txFee;

        uint reserveA;
        uint reserveB;

        (reserveA, reserveB) = BSCswapLibrary.getReserves(
            BSCSWAP_FACTORY,
            WBNB,
            TOKEN
        );

        uint tokenAmount = BSCswapLibrary.quote(ethAmount, reserveA, reserveB); 

        uint256 balance = JulToken.balanceOf(address(this));
        uint256 tokensAvail = balance - lockedTokens;
        if(balance <= lockedTokens || tokensAvail < tokenAmount)
        {
            msg.sender.transfer(msg.value); //refund to user
            return (0,0,0);
        }

        address payable spender = address(this);
        totalEthFee += txFee;
        // spender.transfer(txFee);

        // IERC20 julToken = IERC20(TOKEN);
        JulToken.approve(router02Address, tokenAmount);

        (amountToken, amountBNB, liquidity) = bscswapRouter02.addLiquidityBNB{
            value: ethAmount
        }(TOKEN, tokenAmount, tokenAmount, 1, spender, block.timestamp);

        if(protocolusers[msg.sender].lastDepositedDate == 0) //first deposit
        {
            protocolusers[msg.sender].lastDepositedDate = now;
        }
        else
        {
            calculateInterest(msg.sender);
        }
        protocolusers[msg.sender].amountBNB = protocolusers[msg.sender].amountBNB + ethAmount;
    }

    function readUsersDetails(address _user)
        public
        view
        returns (
            uint256 td,
            uint256 trd,
            uint256 trwi
        )
    {
        if(protocolusers[_user].lastDepositedDate == 0)
        {
            td = 0;
            trd = 0;
            trwi = 0;
        }
        else{
            td = protocolusers[_user].amountBNB;
            uint256 time = now - protocolusers[_user].lastDepositedDate;

            if(now > protocolusers[_user].lastDepositedDate && time >= TIME_LIMIT ){
                uint256 nd = time / TIME_LIMIT;
                uint256 percent = calculatePercent(
                        protocolusers[_user].amountBNB,
                        interestRadio
                    ) * nd;
                trd = protocolusers[_user].pendingBNB + percent;
                trwi = protocolusers[_user].amountBNB + trd ;
            }
            else{
                trd = protocolusers[_user].pendingBNB;
                trwi = protocolusers[_user].pendingBNB;
            }
        }
        return (td, trd, trwi);
    }

    function removeBNB(uint256 _amountBNB)
    public payable returns(uint256 amountToken, uint256 amountBNB)
    {
        (,,uint trwi) = readUsersDetails(msg.sender);

        require(trwi >= _amountBNB, "Insufficient Removable Balance");
        
        address pairAddress = BSCswapLibrary.pairFor(
            BSCSWAP_FACTORY,
            WBNB,
            TOKEN
        );
        IBSCswapPair pair = IBSCswapPair(pairAddress);

        (uint reserveA, ) = BSCswapLibrary.getReserves(
            BSCSWAP_FACTORY,
            WBNB,
            TOKEN
        );
        require(reserveA > 0 , "Pool have no BNB");

        uint totalSupply = pair.totalSupply();
        uint liqAmt = BSCswapLibrary.quote(_amountBNB, reserveA, totalSupply);
        
        uint balance = pair.balanceOf(address(this));
        require(liqAmt <= balance, "Insufficient Liquidity in BSCswap");

        pair.transfer(pairAddress, liqAmt);

        (uint amount0, uint amount1) = pair.burn(address(this));
        (address token0,) = BSCswapLibrary.sortTokens(WBNB, TOKEN);
        (amountBNB, amountToken) = WBNB == token0 ? (amount0, amount1) : (amount1, amount0);
        
        //update deposited data
        calculateInterest(msg.sender);
        if(protocolusers[msg.sender].pendingBNB >= amountBNB)
        {
            protocolusers[msg.sender].pendingBNB = protocolusers[msg.sender].pendingBNB - amountBNB;
        }
        else{
            protocolusers[msg.sender].amountBNB = protocolusers[msg.sender].amountBNB + protocolusers[msg.sender].pendingBNB - amountBNB;
            protocolusers[msg.sender].pendingBNB = 0;
        }
        //end

        IWBNB(WBNB).withdraw(amountBNB);
        uint256 fee = calculatePercent(amountBNB, DEPOSIT_WITHDRAWAL_FEE); //1% withdraw fee
        uint256 user_amount = amountBNB - fee;
        totalEthFee += fee;
        msg.sender.transfer(user_amount);
    }
 
    function getLiquidityBalance() public view returns (uint256 liquidity) {
        address pair = BSCswapLibrary.pairFor(BSCSWAP_FACTORY, WBNB, TOKEN);
        liquidity = IERC20(pair).balanceOf(address(this));
    }

    function withdrawFee(address payable ca, uint256 amount) public onlyOwner{
        require(totalEthFee >= amount , "Insufficient BNB amount!");
        require(address(this).balance >= amount , "Insufficient BNB balance in contract!" );
        ca.transfer(amount);
        totalEthFee = totalEthFee - amount ;
        emit withdrawFeeRaised(amount);
    }

    function tokenRelease() public onlyOwner returns (bool result){
        // total protocol eth balance
        uint256 eth;
        (eth, ) = getBalanceFromBSCswap();
        
        if(eth >= 80000 * 10 ** 18 && !release1) {
            JulToken.transfer(msg.sender, 20000 * 10 ** 18);
            lockedTokens = 55000 * 10 ** 18;
            release1 = true;
            emit tokenReleased(1, 20000 * 10 ** 18);
            return true;
        } else if(eth >= 200000 * 10 ** 18 && !release2) {
            JulToken.transfer(msg.sender, 20000 * 10 ** 18);
            lockedTokens = 35000 * 10 ** 18; 
            release2 = true;
            emit tokenReleased(2, 20000 * 10 ** 18);
            return true;            
        } else if(eth >= 400000 * 10 ** 18 && !release3) {
            JulToken.transfer(msg.sender, 17500 * 10 ** 18);
            lockedTokens = 17500 * 10 ** 18; 
            release3 = true;
            emit tokenReleased(3, 17500 * 10 ** 18);
            return true;
        } else if(eth >= 600000 * 10 ** 18 && !release4) {
            JulToken.transfer(msg.sender, 17500 * 10 ** 18);
            lockedTokens = 0;
            release4 = true;
            emit tokenReleased(4, 17500 * 10 ** 18);
            return true;
        }

        return false;
    }

    /// @return The balance of the contract
    function protocolBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getBalanceFromBSCswap()
        public
        view
        returns (uint256 reserveA, uint256 reserveB)
    {
        (reserveA, reserveB) = BSCswapLibrary.getReserves(
            BSCSWAP_FACTORY,
            WBNB,
            TOKEN
        );
    }

    receive() external payable {}

    fallback() external payable {
        // to get BNB from BSCswap exchanges
    }
    function setInterestRadio(uint256 _interestRadio) public onlyOwner
    {
        require(_interestRadio > 0, "intrest should be greater than zero");
        require(_interestRadio < 50, "intrest should be lesee than 0.5%");
        interestRadio = _interestRadio;
        emit interestRadioChanged(interestRadio);
    }
}