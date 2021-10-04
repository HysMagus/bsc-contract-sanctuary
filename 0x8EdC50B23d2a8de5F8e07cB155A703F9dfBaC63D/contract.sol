/*
HABEO - (share around)
----------------------

HABEO is the teoken that will change the way we use crypto.
We'll make it easy to use and easy to understand so everyone can take advantage of it.

This code is fully commented so everyone can learn from it.

The comments are only in english for practical purposes but it should translate very well with Google translate or similar translation 
services. 
If you have questions about the translation, head out to your Discord Server(https://discord.gg/NA8YnT38sn) and the community will help you.

Check our website for more information: https://www.habeotoken.com
Follow us on Twitter: @HabeoToken
Join our Reddit sub: r/HabeoToken
Check our Youtube channel: https://www.youtube.com/channel/UCmZa_90rxRD08rDiSa7Nh2w

**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// All these interfaces and cotracts are here to provide the standard functionality for the BEP-20/ERC-20 tokens.
// To look at HABEO's code, start looking at line 385.
interface IERC20 {

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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
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
        require(_owner == _msgSender(), "Not owner");
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
        require(newOwner != address(0), "Owner is zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "No permission");
        require(block.timestamp > _lockTime , "Locked for 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
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

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    // function removeLiquidity(
    //     address tokenA,
    //     address tokenB,
    //     uint liquidity,
    //     uint amountAMin,
    //     uint amountBMin,
    //     address to,
    //     uint deadline
    // ) external returns (uint amountA, uint amountB);
    // function removeLiquidityETH(
    //     address token,
    //     uint liquidity,
    //     uint amountTokenMin,
    //     uint amountETHMin,
    //     address to,
    //     uint deadline
    // ) external returns (uint amountToken, uint amountETH);
    // function removeLiquidityWithPermit(
    //     address tokenA,
    //     address tokenB,
    //     uint liquidity,
    //     uint amountAMin,
    //     uint amountBMin,
    //     address to,
    //     uint deadline,
    //     bool approveMax, uint8 v, bytes32 r, bytes32 s
    // ) external returns (uint amountA, uint amountB);
    // function removeLiquidityETHWithPermit(
    //     address token,
    //     uint liquidity,
    //     uint amountTokenMin,
    //     uint amountETHMin,
    //     address to,
    //     uint deadline,
    //     bool approveMax, uint8 v, bytes32 r, bytes32 s
    // ) external returns (uint amountToken, uint amountETH);
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
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IUniswapV2Router02 is IUniswapV2Router01 {
      // function removeLiquidityETHSupportingFeeOnTransferTokens(
    //     address token,
    //     uint liquidity,
    //     uint amountTokenMin,
    //     uint amountETHMin,
    //     address to,
    //     uint deadline
    // ) external returns (uint amountETH);
    // function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    //     address token,
    //     uint liquidity,
    //     uint amountTokenMin,
    //     uint amountETHMin,
    //     address to,
    //     uint deadline,
    //     bool approveMax, uint8 v, bytes32 r, bytes32 s
    // ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}



contract Habeo is Context, IERC20, Ownable {
    // Here's where HABEO code starts //
    // For these global variables and structures, we've tried to pack them as much as we could
    // to try to save as much gas as possible.
    // This link explains some of the what, the why and the how: 
    // https://medium.com/@novablitz/storing-structs-is-costing-you-gas-774da988895e
    
    // Contract structure
    struct ContractData{

        // Biggest number possible that can be created with uint256.
        // We'll use it for reflection calculations.
        uint256 MAX;
        // Initial supply of tokens
        uint256 tokensTotal;
        // This does not reflect "the total number of reflections" in a direct way. Instead, it is used
        // in the calculations of values to show the right number for tokens+reflections when users
        // look at wallet balance.
        uint256 reflectionsTotal;
        
        // Maximum transaction size allowed for transfers between wallets.
        uint256 maxTxAmount;
        
        // This sets the threshold for the contract to swap and liquify.
        // It's inefficient to do it on every transaction so the contract collects
        // the liquidity fees and when the contract balance hits numTokensSwapToAddToLiquidity or more, 
        // it goes through the swap and liquify process on the next transaction.
        // This property also sets the number of tokens to swap for BNB.
        uint256 numTokensSwapToAddToLiquidity;

        // Metadata about the token.
        string name;
        string symbol;
        uint8 decimals;

    }

    // Create the contract data instance with all the contract's configuration.
    ContractData public contractData;

    // Wallet structure
    struct WalletData {
        // For regular wallets, we don't count tokens, 
        // we coun't reflections so we can calculate new
        // balances on the fly to save gas.
        uint256 reflectionsOwned;

        // For contracts and other interfaces that are excluded from the reflections,
        // we do count tokens (and reflections).
        uint256 tokensOwned;

        // Throttling the ability to swap too quickly.
        // HABEO only allows one exchange operation (to swap) every 8 hours.
        uint256 lastExchangeOperation;

        // When swapping to create liquidity, we need to provide allowance to the
        // router so we use this map. It is also needed for any "transfer from" operations users may want to do.
        mapping (address => uint256) allowances;
        
        // Accounts marked as true, are not charged taxes nor receive reflections.
        // Typical accounts here (at likely only) are the Contract, the Exchanges 
        // and the burn wallet (after the burn is complete).
        bool isExcludedFromTaxAndReflections;

        // Did this wallet already acquire tokens at the early distribution?
        // Since we only allow for one early distribution per wallet, here's where we set the flag.
        bool walletsThatAcquiredAtEarlyDistro;

        // This indicates whether this is the address of an exchange or not.
        // We need to partiulcarly understand if we are dealing with an Exchange at some points.
        bool walletIsExchange;

    }

    // List of wallets - Anyone having HABEO will have an entry here.
    mapping (address => WalletData) private wallets;

    // This indicates whether we are in the process of swapping and liquifying or not.
    // Basically, this needs to be set to true WHILE we are swapping and liquifying
    // so we do not enter into a recursive loop.
    bool inSwapAndLiquify;

    // Are we still in early distribution mode?
    // This will be set to false at the end of early distribution and won't ever change back to true.
    bool inEarlyDistro = true;
    
    // 97.5% of the tokens will be burnt over time. This will make the burn wallet the largest holder 
    // while the burn process is happening and as such, it will eat up more reflections than any other wallet.
    // Because of this, the growth of the wallet is accellerated over time until the protocol has burnt 97.5%
    // of the circulating tokens. Once this happens and we stop the burning process,
    // The burn wallet is then excluded from future reflections and holders will perceive a noticeable increase in 
    // reflections owned.
    bool keepBurning = true;

    // Initialization of the PancakeSwap interface objects.
    IUniswapV2Router02 public pcsV2Router;
    address public pcsV2Pair;

    // Wallet address for the devteam.
    // This address will be deploying the contract and then, renouncing ownership of it.
    // This account exists for two main reasons.
    // #1 - allows for addition and removal of exchanges.
    // #2 - allows for the dev team to withdraw donations sent to the contract after the early distribution is done.
    address private devteam;

    //EARLY DISTRO Configs

    // Max number of HABEOs to distribute.
    // This is the maximum number of HABEOs that the early distribution can exchange.
    // The early distribution will be closed at the due date or when having distributed 250,000,000,000,000 HABEO (give or take a few), 
    // whichever comes first.
    uint256 public earlyDistroMaxHABEO = 250000000 * 10**6 * 10**9;

    // Expiration time for early distribution: 30 days from contract deployment.
    uint256 public earlyDistroDeadline = block.timestamp + 30 days;

    // During early distribution, this balance will keep track of the received BNB that will be added to liquidity and 
    // will be used to pass the value to the initial liquidity addition right when the early distribution ends.
    uint256 private liquidityBNB;

    // Map to establish # of tokens per BNB at early distribution.
    // This exists with the sole purpose of creating a very fair early distribution process.
    // Instead of allowing any size request of tokens, we only have 7 different packages offered at early distribution:
    // 25, 10, 5, 1, 0.5, 0.2 and 0.1 BNB
    // Each package distributes a specific amount of tokens being slightly more beneficial to acquire the 5 BNB worth of packages.
    // If everyone acquires 5 BNB worth of the token, we would end up with an initial LP of 2500 BNB. Because there will be a 
    // number of people acquiring different amounts of token, it is highly possible the initial LP will be larger than 2500 BNB
    mapping (uint256 => uint256) public earlyDistroPackages;

    // Management

    // When new exchanges are added, we push them to this array so we can loop through it
    // and remove each exchange from the reflections when running reflections calculations.
    // This has to be dynamic because we want to have the ability to add and remove exchanges at any time so
    // we can't have a fixed size array.
    address[] private newExchanges;


    event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);

    // This is the constructor.
    // Constructor code only runs once, at deployment. It basically sets up the contract in the BSC network.
    constructor () {

        // For those trying to understand this math, look at this article:
        // https://weka.medium.com/dividend-bearing-tokens-on-ethereum-42d01c710657
        // Original initial supply of tokens = 1,000,000,000,000,000 (that's 15 0s) but we also account for decimals (9).
        // Because we are working with 9 decimals, we need to add 9 digits since we cannot use fractional numbers.

        // Largest uint256 number that can be created
        // Quick way to reference it is to negate 0. 
        contractData.MAX = ~uint256(0);

        // Maximum number of tokens created by the contract
        contractData.tokensTotal = 1000000000 * 10**6 * 10**9;

        // This is the part of the math that the above mentioned article does a good job at explaining.
        contractData.reflectionsTotal = (contractData.MAX - (contractData.MAX % contractData.tokensTotal));

        // Max tx amount between accounts is 10,000,000,000 tokens at once.
        contractData.maxTxAmount = 10000 * 10**6 * 10**9;

        // Once the early distribution has ended, the contract will continue adding to liquidity.
        // Instead of adding at every transaction (inefficient), we wait to collect a certain number of tokens 
        // and then we swap.
        // In this case we are waiting to collect 100,000,000 tokens before adding to liquidity.
        contractData.numTokensSwapToAddToLiquidity = 100 * 10**6 * 10**9;

        // Metadata
        contractData.name = "Habeo";
        contractData.symbol = "HABEO";
        contractData.decimals = 9;

        // Set the dev team address variable to the sender address.
        // Since we are creating the contract, we are the sender.
        // We are also the owner, but this way it is clearer.
        // We will be renouncing ownership a few lines below.
        devteam = _msgSender();


        // Give all the tokens to the contract so the contract can send them to the 
        // the wallets when the BNB is received.
        wallets[address(this)].tokensOwned = contractData.tokensTotal;
        wallets[address(this)].reflectionsOwned = contractData.reflectionsTotal; 


        // Instanciate the router with the valid address
        // We keep all of the addresses here or informational purposes but the one used at the time
        // of deployment must be the Mainnet V2 (probably in the future, PCS will have more versions).

        //0xD99D1c33F9fC3444f8101754aBC46c52416550D1 - Testnet
        //0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 - Testnet alternate and currently working well with https://pancake.kiemtienonline360.com/
        //0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F - Mainnet V1 router - do not use - here for reference
        //0x10ED43C718714eb63d5aA57B78B54704E256024E - Mainnet V2 router - this is the one we deploy with.
        pcsV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); 

        // Try to create the pair HABEO/BNB. If it exists, the address for the pair is returned here, if it does not exist
        // it is created AND the address returned here.
        pcsV2Pair = IUniswapV2Factory(pcsV2Router.factory()).createPair(address(this), pcsV2Router.WETH());

        // Remove this contract from fees and reflections.
        wallets[address(this)].isExcludedFromTaxAndReflections = true;
        // Leave the burn address with fees and reflections. Not needed at this point but 
        // it helps with understanding how it works. We'll include it when the burn has 
        // reached the maximum burn expected.
        wallets[address(0)].isExcludedFromTaxAndReflections = false;

        // Remove original exchange from the reflections.
        // We set the address as exchange too.
        wallets[pcsV2Pair].isExcludedFromTaxAndReflections = true;
        wallets[pcsV2Pair].walletIsExchange = true;

        // For those unfamiliar with the way BNB (and most cryptos for that matter) works, 
        // some quick hints are shared here.
        // Please get yourself familiar with these concepts before any other step.
        // The units in which operations happen are not 1 BNB. They happen in much smaller fractions.
        // The name for the smallest possible unit in BNB is wei.
        // 1 BNB = 1 * 10**18 wei (thats 10 to the power of 18).
        // When we deal with the coin (BNB in this case) we need to do it in multiples of wei.
        // So, you'll see a lot of 0s or multiplications and exponentiations happening along the code 
        // to make the numbers easier to understand.

        // There are not many instances in the code where we need to calculate 25,10,5,1,0.5,0.2 and 0.1 BNB
        // so we use literals in order to save storage.
        // We are assigning token distribution depending on the value of BNB that is sent at early distribution.
        // For each level down from 5 BNB, you receive 10% fewer tokens, except for 0.5, 0.2 and 0.1 BNB since 
        // percentage does not decrease after 0.5.
        // 0.5 BNB, 0.2 BNB amd 0.1 BNB receive the same proportional number of tokens.
        // For each level above 5 BNB you receive 10% fewer tokens. This way we encourage to acquire a good number
        // of tokens and discourage becoming a whale.

        // For 5 BNB you get 500,000,000,000 tokens - swapping value in BNB per token = 0.00000000001000 BNB
        // At the time of this writing, BNB is around $350 or so FIAT value for each token at this level would be
        // around $0.0000000035

        // For 25 BNB 1,806,250,000,000 tokens - swapping value in BNB per token = 0.000000000013841 BNB (27.75% fewer compared to 5 BNB)
        earlyDistroPackages[25 * 10**18] = 1806250 * 10**6 * 10**9;

        // For 10 BNB you get 850,000,000,000 tokens - swapping value in BNB per token = 0.000000000011765 BNB (15% fewer compared to 5 BNB)
        earlyDistroPackages[10 * 10**18] = 850000 * 10**6 * 10**9;

        // For 5 BNB you get 500,000,000,000 tokens - swapping value in BNB per token = 0.00000000001000 BNB (Sweet spot)
        earlyDistroPackages[5 * 10**18] = 500000 * 10**6 * 10**9;

        // For 1 BNB you get 90,000,000,000 tokens - swapping value in BNB per token = 0.00000000001111 BNB (10% fewer compared to 5 BNB)
        earlyDistroPackages[1 * 10**18] = 90000 * 10**6 * 10**9;

        // For 0.5 BNB you get 40,500,000,000 tokens - swapping value in BNB per token = 0.00000000001234 BNB (19% fewer compared to 5 BNB)
        earlyDistroPackages[5 * 10**17] = 40500 * 10**6 * 10**9;

        // For 0.2 BNB you get 16,200,000,000 tokens - swapping value in BNB per token = 0.00000000001234 BNB (Same proportion to 0.5 BNB)
        earlyDistroPackages[2 * 10**17] = 16200 * 10**6 * 10**9;

        // For 0.1 BNB you get 8,100,000,000 tokens - swapping value in BNB per token = 0.00000000001234 BNB (Same proportion to 0.2 BNB)
        earlyDistroPackages[1 * 10**17] = 8100 * 10**6 * 10**9;

        // For the tokenomics these will present us with the following numbers:
        // If all early distribution tokens are distributed at 5 BNB:
        // 500 operations of 5 BNB each x 500,000,000,000 HABEO each = 2500 BNB collected / 250,000,000,000,000 tokens distributed.
        // 2500 BNB / 250,000,000,000,000 HABEO Liquidity
        // 500,000,000,000,000 Total tokens in circulation at start.
        // 500,000,000,000,000 Total tokens burnt right at the close of early distribution.
        // 475,000,000,000,000 burnt over time to get to 975,000,000,000,000 tokens burnt 
        // and 25,000,000,000,000 total in circulation.

        // If all early distribution tokens are distributed at 0.1 BNB:
        // 30,864 operations of 0.1 BNB each x 8,100,000,000 HABEO each = ~3,086 BNB collected / 250,000,000,000,000 tokens distributed
        // 3,086 BNB / 250,000,000,000,000 HABEO Liquidity
        // 500,000,000,000,000 total tokens in circulation at start
        // 500,000,000,000,000 Total tokens burnt right at the close of early distribution.
        // 475,000,000,000,000 burnt over time to get to 975,000,000,000,000 tokens burnt 
        // and 25,000,000,000,000 total in circulation.

        // If all early distribution tokens are distributed at 25 BNB:
        // 138 operations of 25 BNB each x 1,806,250,000,000 HABEO each = ~3,460 BNB collected / 250,000,000,000,000 tokens distributed
        // 3,460 BNB / 250,000,000,000,000 HABEO Liquidity
        // 500,000,000,000,000 total tokens in circulation at start
        // 500,000,000,000,000 Total tokens burnt right at the close of early distribution.
        // 475,000,000,000,000 burnt over time to get to 975,000,000,000,000 tokens burnt 
        // and 25,000,000,000,000 total in circulation.

        // The difference between all three case scenarios is that in the second and third one, there will be more BNB in the 
        // liquidity pool right after the early distribution ends.
        // The most likely case will be a mixture of all options which will bring the amount of BNB to somewhere in between.

        // This is where we renounce ownership.
        // The function is defined under the Owenable class if you want to see the details.
        renounceOwnership();

        // We emit tokenstotal so we do not need to calculate from reflection. 
        // At construction they are the same so we emit tokensTotal which is cheaper in gas
        emit Transfer(address(0), _msgSender(), contractData.tokensTotal);
    }
    // Constructor ends here. The rest of the code are functions that can be called externally or internally.
    // External functions are ONLY called externally.
    // Public functions are called EITHER internally or externally.
    // Internal functions are only accessible from the contract or any contracts derived from this contract.
    // Private functions can only be called from within the contract.
    // For HABEO, there are no unused functions. All of them are used somehow.

    // The receive() function is called when someone sends BNB to the contract and when the swap and liquify
    // process receives BNB to add to liquidity.
    // The withdrawBNBDonationsToDevTeam() can be called by anyone and it will only execute AFTER early distribution
    // The only thing it does is to withdraw whatever amount of BNB is in the contract (donations) and send it to the dev wallet.
    // The addRemoveExchange() function can only be called by the developeraccount and is used to add / remove
    // exchange addresses. This is needed so we can add exchanges that list HABEO on the fly and remove addresses
    // when exchanges update their contracts.
    // The rest of the functions are explained near the function code.
    
    // This function starts as the receiver of BNB for the early distribution and then 
    // is used for the contract to recieve excess BNB from pcsV2Router when swaping.
    // Once the early distribution is done, donations to the devteam can be sent here too.
    receive() external payable {

        // To save gas, we avoid using require statements every chance we have.
        // For instance, instead of checking if the earlyDistroMaxBNB limit is already reached,
        // we let Solidity detect the overflow and cause an exception.
        // the exception (negative number) will cause a revert.
        // This will generate a generic "revert" fail message for the user but it saves gas to the user too.
        // As all exceptions and requires will eat up the gas anyways, it is better to make it cheaper to the user in gas.

        if (!inEarlyDistro || inSwapAndLiquify) {
            // We only arrive here if early distribution is done and someone donates to the dev team OR
            // if the router sends us swap excess.
            // We emit so the transfer is logged.
            emit Transfer(_msgSender(), address(this), msg.value);

        } else if (_msgSender() != address(pcsV2Router)) {
            // If we are at the due date or earlyDistroMaxBNB is reached,          
            // we honor the last request even if it is after the established date
            // or if the earlyDistroMaxHABEO has been reached.
            // This does not affect the balance of tokens, BNB and burns at all so it's easier to
            // just do it and reward the last person that tried to get tokens at early distribution.
            // worst case scenario we'll be sending an extra 25 BNB in tokens, best case scenario we'll
            // be sending extra 0.1 BNB in tokens.
            // Either way, it should improve pricing at the exchange.

            

            // We do need to check if the value sent aligns with one of the allowed amounts.
            // If we get 0 here, an invalid amount of BNB was sent so we revert.
            uint256 tokensAmount = earlyDistroPackages[msg.value];
            require (tokensAmount > 0 , "Wrong request amount");

            // If someone wants to sneak a second request from a wallet, we revert.
            require (!wallets[_msgSender()].walletsThatAcquiredAtEarlyDistro, "Only 1 per wallet");

            // We do want to use a variable as a temporary holder of the value to prevent re-entry attacks.
            uint256 amountBNB = msg.value;

            // Add the amount to the liquidity holder.
            liquidityBNB += amountBNB;


            // Remove the tokens from the contract.
            wallets[address(this)].tokensOwned -= tokensAmount;
            // Remove the reflections from the contract.            
            // We could be using some of the existing functions to calculate rather than doing the math here.
            // However, it is saving gas to do it this way.
            wallets[address(this)].reflectionsOwned -= tokensAmount * (contractData.reflectionsTotal/contractData.tokensTotal);
            // Add the wallet to the list of wallets that have acquired tokens at the early distribution.
            wallets[_msgSender()].walletsThatAcquiredAtEarlyDistro = true;
            // Give the tokens to the wallet in reflections form.
            wallets[_msgSender()].reflectionsOwned += tokensAmount * (contractData.reflectionsTotal/contractData.tokensTotal);
            // Emit the event so the transfer is logged.
            emit Transfer(address(this), _msgSender(), tokensAmount);


            // Check to see if we have reached the total number of HABEOs at the early distribution or the earlyDistroDeadline.
            if (earlyDistroMaxHABEO > tokensAmount && block.timestamp < earlyDistroDeadline){
                // If not, just deduct the new amount.
                earlyDistroMaxHABEO -= tokensAmount;
            } else if (earlyDistroMaxHABEO <= tokensAmount){
                // If we did, then ensure the value for earlyDistroMaxHABEO is 0 and close the early distribution.
                earlyDistroMaxHABEO = 0;
                closeTheEarlyDistro();
                inEarlyDistro = false;
            }
        } 
    }

    // Here is where we close the early distribution
    function closeTheEarlyDistro() internal {

        // Initial burn number after early distribution. This is the number of tokens to be burnt right after early distribution.
        // both in tokens and in reflections as the wallet is not excluded from reflections until we reach
        // the max burn.
        uint256 tInitialBurn = 500000000 * 10**6 * 10**9;
        uint256 rInitialBurn = tInitialBurn * (contractData.reflectionsTotal/contractData.tokensTotal);

        // We substract the burnt tokens from the contract.
        wallets[address(this)].tokensOwned -= tInitialBurn;
        // We substract the burn reflections from the contract.
        wallets[address(this)].reflectionsOwned -= rInitialBurn;
        // We move the tokens and reflections to the burn wallet.
        wallets[address(0)].tokensOwned = tInitialBurn;
        wallets[address(0)].reflectionsOwned = rInitialBurn;
        // We emit the transfer so it is logged.
        emit Transfer(address(this), address(0), tInitialBurn);

        //We need to set the flag on so we can process the liquification
        inSwapAndLiquify = true;

        // Add all the tokens in the contract and all the BNBs as a pair.
        // Instead of calling swap and liquify, we can call addLiquidity directly because, 
        // we already have the BNB so there's no need for swapping.
        // We provide all the remaining tokens in the contract and all the liquidity collected.
        addLiquidity(wallets[address(this)].tokensOwned, liquidityBNB, true);

    }

 
    
    // All these are the functions that show metadata upon request.
    // they are all external because they are usually called by wallets 
    // and exchanges to show token data.
    function name() external view returns (string memory) {
        return contractData.name;
    }
    function symbol() external view returns (string memory) {
        return contractData.symbol;
    }
    function decimals() external view returns (uint8) {
        return contractData.decimals;
    }
    function totalSupply() external view override returns (uint256) {
        return contractData.tokensTotal;
    }
    // Simply returns the value in tTokens for the requested account
    // If the account is excluded, it simply returns the value.
    // If the account is not excluded, then we need to calculate the token value from the reflections value.
    function balanceOf(address account) external view override returns (uint256) { 
        if (wallets[account].isExcludedFromTaxAndReflections) return wallets[account].tokensOwned;
        return tokensFromReflections(wallets[account].reflectionsOwned);
        
    }    
    // This function shows what the allowance is for a certain pair of addresses.
    function allowance(address owner, address spender) external view override returns (uint256) {
        return wallets[owner].allowances[spender];
    }


    // Transfer and approve are called by wallets/exchanges to initiate a transfer.
    // The approve function is the one that provides allowance to the exchanges to operate
    // on the user's behalf.
    // It can also be called manually by an experienced user to set up someone else to spend
    // tokens on the original user's behalf.
    // Of course the only account that can allow an approve call is the user allowing someone 
    // else to spend on their behalf.

    // This is the point of entry for the transfer requests.
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // This is the entry point for the approve function.
    // This enables an address to spend a certain amount of tokens on behalf of another address.
    // Basically, provides allowances to addresses.
    // This is used quite a bit at swap time and gives users the chance to allow others to spend on their behalf.
    // This is a requirement for DeFi exchanges like Pancakeswap. They ask for your approval to do this before you can swap.
    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount,true);
        return true;
    }
    
    // User may want to decrease the allowance provided to another account.
    // This is the point of entry for that.
    // This is not a common function to have. We provide it because we've seen some exchanges
    // (like PancakeSwap for instance) that sometimes try to get a wide range approval all at once.
    // If the user decides later that wants to lower this allowance, this is the function to call.
    // For a user to call this, the user needs to have a little bit more advanced knowledge.
    function decreaseAllowance(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount,false);
        return true;
    }
    
    // This is the actual worker for the approve function.
    // This can only be called from this contract.
    function _approve(address allower, address spender, uint256 amount, bool incrementDecrement) private {

        // incrementDecrement determines if this is an increase or a decrease request.
        // If we are incrementing the allowance, we add to it.
        // If we are decrementing, we decrement and if we don't have enough, we set to 0.
        if(incrementDecrement){
            if (amount >= contractData.MAX - wallets[allower].allowances[spender]){
                wallets[allower].allowances[spender] = contractData.MAX;
            } else {
                wallets[allower].allowances[spender] += amount;
            }
        } else if (wallets[allower].allowances[spender] >= amount){
            wallets[allower].allowances[spender] -= amount;
        } else {
            wallets[allower].allowances[spender] = 0;
        }

        // We emit the event to log it.
        emit Approval(allower, spender, amount);
    }
    
    // General transfer function to send from one account to another.
    // This is what the allowance is for when a user authorizes another user to spend on behalf.
    // This is a standard BEP-20/ERC-20 function.
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        // First we try to decrease the allowance.
        // If we do not have enough allowance we revert through the exception.
        wallets[sender].allowances[_msgSender()] -= amount;
        // If we have the allowance, we transfer.
        _transfer(sender, recipient, amount);
        return true;
    }
    
    // This function returns the number of tokens owned by providing the current number of reflections
    // it is only used internally a couple of times but one of those is the balanceOf function which is
    // called continuously by the exchanges and wallets.
    function tokensFromReflections(uint256 reflectionsAmount) private view returns(uint256) {
        // First we get the current rate of reflections vs tokens.
        // Then we divide by the rate.
        // The getRate function spins up the currentsupply calculation which is complex and spends gas.
        uint256 currentRate =  getRate();
        return reflectionsAmount / currentRate;
    }

    // This is the function used at transfer time that returns various values that are needed for a correct
    // distribution of tokens.
    // The amount to provide is the number of real tokens and the function returns values in both reflection and token.
    // We need this translation because of reflection.
    // This is a very gas expensive function.
    function getValues(uint256 tAmount, uint256 tax) private view returns (uint256, uint256, uint256, uint256, uint256) {
        // We need to find out the t values.
        (uint256 tTransferAmount, uint256 tFee) = getTValues(tAmount, tax);
        // And we need to out the r values.
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
    }

    // This is a spinoff from the getValues function and it returns the token part of the values
    function getTValues(uint256 tAmount, uint256 tax) private pure returns (uint256, uint256) {
        // Tax is a percentage so we calculate the t value of the fees.
        uint256 tFee = tAmount * tax / 10**2;
        // transferAmount is tokenAmount minus tax minus liq (to save gas we use the same 
        // variable since rate for tax = liq rate)
        uint256 tTransferAmount = tAmount - tFee - tFee;
        return (tTransferAmount, tFee);
    }

    // This is a spinoff from the getValues function and it returns the reflections part of the values
    function getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        // convert tokens to reflections
        uint256 rAmount = tAmount * currentRate;
        // do the same for the fees
        uint256 rFee = tFee * currentRate;
        // now calculate the transfer amount in reflections too.
        // substract fee two times because of liq AND reflections.
        uint256 rTransferAmount = rAmount - rFee - rFee;
        return (rAmount, rTransferAmount, rFee);
    }
    
    // This function calculates and returns the rate of conversion between reflections and tokens.
    // Notice that it calls getCurrentSupply which is an expensive function.
    function getRate() private view returns(uint256) {
        (uint256 reflectionsSupply, uint256 tokensSupply) = getCurrentSupply();
        return reflectionsSupply / tokensSupply;
    }

    // We calculate supply as follows:
    //    - We start with the total for tokens and reflections 
    //      (maximum number of tokens and reflections minus reflections fees that 
    //      have been removed over time because of the reflection distribution process)
    //    - We remove any tokens and reflections that are owned by the excluded accounts from that supply.
    //    - We then return those totals which are the current supply for tokens and reflecions
    function getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = contractData.reflectionsTotal;
        uint256 tSupply = contractData.tokensTotal;    

        // We do need to check if we are in early distribution because we do not apply reflections at early distribution.
        // In this case we return totals.
        // If this was not here, then it would mess balances because the contract still owns all of the 
        // tokens that have yet to be acquired.
        if (inEarlyDistro){ 
            return (contractData.reflectionsTotal, contractData.tokensTotal);
        }

        // This is exclusively for precaution. If for whatever reason the numbers don't add up,
        // go back to the basics. This is the least invasive thing to do.
        if (rSupply < contractData.reflectionsTotal / contractData.tokensTotal) return (contractData.reflectionsTotal, contractData.tokensTotal);
        
        // This is expensive.
        // This loop goes through all of the added exchanges and, as they are excluded, 
        // removes the r and t values belonging to them.
        for (uint256 i = 0; i < newExchanges.length; i++) {
            rSupply -= wallets[newExchanges[i]].reflectionsOwned;
            tSupply -= wallets[newExchanges[i]].tokensOwned;
        }

        // We know these are already excluded so we make the above loop shorter.
        tSupply = tSupply - wallets[pcsV2Pair].tokensOwned - wallets[address(this)].tokensOwned;
        rSupply = rSupply - wallets[pcsV2Pair].reflectionsOwned - wallets[address(this)].reflectionsOwned;

        // Once we are done burning, we start excluding the burning address form the supply.
        if (!keepBurning){
            tSupply -= wallets[address(0)].tokensOwned;
            rSupply -= wallets[address(0)].reflectionsOwned;
        }

        return (rSupply, tSupply);
    }
    
    // This is the worker transfer function
    // It is a wrapper for the transfer functions that are specific for each scenario
    // General calculations happen here.
    function _transfer(address from, address to, uint256 amount) private {
        uint256 contractTokenBalance = 0;

        // During early distribution, only transactions from the contract are allowed.
        // This is so the contract can distribute the tokens and add to the liquidity pool WHILE 
        // no reflections or taxing happens.
        if (inEarlyDistro){
            if(from != address(this)){
                revert("Cannot transfer during early distribution");
            }
        } else {
            // We only check this if we are not in early distribution anymore.
            // Is the token balance of this contract address over the min number of
            // tokens that we need to initiate a swap + liquidity lock?
            contractTokenBalance = wallets[address(this)].tokensOwned;
        }
        
        // Between regular accounts, there's a max transfer size. 
        // However, anyone can swap as much as they want. Swapping large numbers pays higher taxes.
        // Also the contract and the burn wallet can transfer as much as they want.
        if((!wallets[from].walletIsExchange && !wallets[to].walletIsExchange) 
        || (!wallets[from].isExcludedFromTaxAndReflections 
        && !wallets[to].isExcludedFromTaxAndReflections)){
            require(amount <= contractData.maxTxAmount, "Above Transfer Limit");
        }


        
        // Make sure the request is not coming from PCS so we prevent a circular event.
        // Saving some variable declaration by setting the contractBalance to the numTokensSwapToAddToLiquidity
        // so we can swap a fixed ammount of tokens.
        if (from != pcsV2Pair && (contractTokenBalance >= contractData.numTokensSwapToAddToLiquidity) 
        && !inSwapAndLiquify) {
            contractTokenBalance = contractData.numTokensSwapToAddToLiquidity;

            // Swap and add liquidity
            swapAndLiquify(contractTokenBalance);
        }

        // If we are still burning it's because we did not hit 975,000,000,000,000 burnt yet,
        // check and see if we did hit that mark. If we did, we stop burning, convert the 
        // reflections into tokens and move the
        // 0x address to excluded so it does not receive any more reflections.
        if (keepBurning){
            // We need to check the burn wallet balance.
            // Lifetime max number of tokens to burn. 
            // Amazingly, it is cheaper to run the math here than to have a stored global with the value. 
            // Both for deployment and exec.
            // Max lifetime burn = 975,000,000,000,000
            if (wallets[address(0)].tokensOwned >= (975000000 * 10**6 * 10**9)){
                // Stop the burn
                keepBurning = false;

                // Convert 0x wallet into an excluded address so it does not receive any more reflections
                wallets[address(0)].isExcludedFromTaxAndReflections = true;
            }
        }
        
        // Initiate transfer. Tax will be charged later.
        tokenTransfer(from,to,amount);
    }

    // This is where we start the process to provide liquidity on a regular basis.
    // We first swap half of the tokens for BNB.
    // Then, we add liquidity putting together the remaining half of the tokens and the swapped BNB as pair.
    // There will be a very small leftover that goes into the contract address.
    // The reason to do it like this is that liquidity needs to be added in a balanced way.
    // If the new liquidity was not balanced, then if would affect swap value noticeably 
    // (the exchange does not allow this anyways).
    // So, we see how much BNB we can obtain with half of the tokens. Then, we have the remaining half of the tokens 
    // that evidently are worth pretty much the amount of BNB that we've received for the initial half.
    // Putting these two together to add liquidity gives us a huge chance of having a pretty accurate calculation.
    // Nevertheless, as the amounts will not be perfect, the small leftovers are returned to the contract.
    function swapAndLiquify(uint256 contractTokenBalance) private {

        // We must raise a flag to recognize that we have started a swap.
        inSwapAndLiquify = true;

        // If we are still burning, this is where we take some tokens to burn them
        if (keepBurning){
            // We liquify 90% of the fees
            // We burn 10% of the fees

            // We divide contractTokenBalance by 10 so we can burn 10%
            uint256 burnPile = contractTokenBalance / 10;

            // If we substract 10% from 100%, we have 90%.
            // we'll use this 90% to liquify.
            contractTokenBalance -= burnPile;

            // What's the reflections amount for the burned tokens?
            (uint256 rAmount, , , , ) = getValues(burnPile, 0);
            // Burn the tokens.
            wallets[address(0)].reflectionsOwned += rAmount;
            // even though the burn wallet is not excluded from reflections yet,
            // we still add the tokens to keep it up to date.
            wallets[address(0)].tokensOwned += burnPile;

            //Emit a transfer to show the movement.
            emit Transfer(address(this), address(0), burnPile);
        }

        // Now that we have the 90% to work with, we split the contract balance into halves.
        uint256 half = contractTokenBalance / 2;

        // Capture the contract's current BNB balance.
        // This is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // had been left over or manually sent to the contract.
        uint256 initialBalance = address(this).balance;


        // Swap half of the tokens for BNB.
        swapTokensForBNB(half);

        // How much BNB did we just swap into?
        // We have to do this so we can maintain the balance as close as possible in the LP.
        uint256 bnbSwapAmmount = address(this).balance - initialBalance;

        // Get the contract to add liquidity to PCS
        addLiquidity(half, bnbSwapAmmount,false);

        emit SwapAndLiquify(half, bnbSwapAmmount, half);

    }
    
    // This is where we get the tokens swapped for BNB.
    function swapTokensForBNB(uint256 tokenAmount) private {
        // Create the array to pass as the pair token/weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pcsV2Router.WETH();

        // Since the router will be using tokens on behalf of the contract,
        // we need to get an allowance.
        _approve(address(this), address(pcsV2Router), tokenAmount,true);

        // Make the swap happen and set the contract as the receiver of any leftover.
        pcsV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp + 10 seconds
        );
    }

    // This is where we add the liquidity
    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount, bool fromEarlyDistro) private {

        // Again, we need to make sure the router can spend the tokens on behalf of the contract.
        // We save some gas by adding allowance directly instead of going through approve.
        // _approve(address(this), address(pcsV2Router), tokenAmount, true);
        wallets[address(this)].allowances[address(pcsV2Router)] += tokenAmount;

        // We need to check whether we arrived here through the swapandliquify function or directly
        // from the early distribution end event.
        if(fromEarlyDistro){

            // If we got here from the early distribution, we clear the variable containing the liquidity amount
            // since we have passed it now as tokenAmount with the call.
            liquidityBNB = 0;
        }

        // We add the liquidity and lock the CAKE-LP forever.
        pcsV2Router.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            // Sending the CAKE tokens to the burn wallet means 
            // they are not recoverable and the liquidity is locked forever
            address(0), 
            block.timestamp + 10 seconds
        );
        
        // Turn the flag off for swapping.
        inSwapAndLiquify = false;
    }

    // This method is responsible for deciding what route to take with regards to fees
    function tokenTransfer(address sender, address recipient, uint256 amount) private {

        if (wallets[sender].walletIsExchange) {
            // This should only take the basic tax ammount since it's someone obtaining HABEO
            // it should not however take fees if recipient is excluded.
            transferFromExchange(sender, recipient, amount);
        } else if (wallets[recipient].walletIsExchange) {
            // We need to check if the owner or contract are sending to LP, in which case we do not take fees.
            // If it is not the case, then this is a regular account swapping. take taxes accordingly
            transferToExchange(sender, recipient, amount);
        } else if (wallets[sender].isExcludedFromTaxAndReflections || wallets[recipient].isExcludedFromTaxAndReflections) {
            // This is excluded/excluded transactions and not exchanges are involved, no fees.
            transferWithExcluded(sender, recipient, amount);
        } else {
            // If nothing else, default to standard.
            // These are two regular accounts transferring tokens from one to the other.
            // Low fees.
            transferStandard(sender, recipient, amount);
        }

    }
    
    // This method is a helper to calculate the tax rate that an operation incurs.
    // This is only triggered when the TO is an exchange since that's a swapping out operation.
    // The rate is based on the percentage of account balance being transferred.
    function calculateTaxAndLiquidityBasedOnTxPercentage(uint256 senderBalance,uint256 amount) private pure returns (uint256){

        // Minimum tax.
        uint256 tax = 1;
        // Percentage of amount over senderBalance.
        uint256 pctSwappedOut = amount * 100 / senderBalance;

        // Remember that this only calculates the rate.
        // This rate applies to both charges, the reflection fee and the liquidity.
        // So, percentages taken from the txs are 2,4,6,8,10,20,30,40,50,60 respectively.
        if (pctSwappedOut <= 1) {
            tax = 1;
        } else if (pctSwappedOut <= 2) {
            tax = 2;
        } else if (pctSwappedOut <= 3) {
            tax = 3;
        } else if (pctSwappedOut <= 4) {
            tax = 4;
        } else if (pctSwappedOut <= 5) {
            tax = 5;
        } else if (pctSwappedOut <= 10) {
            tax = 10;
        } else if (pctSwappedOut <= 20) {
            tax = 15;
        } else if (pctSwappedOut <= 40) {
            tax = 20;
        } else if (pctSwappedOut <= 75) {
            tax = 25;
        } else if (pctSwappedOut <= 100) {
            tax = 30;
        }
        return (tax);
    }

    // Standard transactions are the easiest.
    // Two regular wallets trading tokens.
    // Very low fee. 2% total. (1% tax rate)
    function transferStandard(address sender, address recipient, uint256 tAmount) private {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
        uint256 tTransferAmount;
        uint256 tFee;

        // Standard transfers have a tax rate of 1 so we hardcode it to save gas.
        (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, 1);

        // Remove the reflections from the sender
        wallets[sender].reflectionsOwned -= rAmount;
        // Add the reflections (minus taxes) to the recipient.
        wallets[recipient].reflectionsOwned += rTransferAmount;

        // Now, take care of the liquidity and fees
        takeCareOfLiquidityAndFees(rFee, tFee);

        // Show the transaction to the world.
        emit Transfer(sender, recipient, tTransferAmount);
    }

    // This other route means we are sending tokens to an exchange
    // This could be either a swap or liquidity provision.
    // If it's a swap, high tax. if it is LP, no tax.
    function transferToExchange(address sender, address recipient,  uint256 tAmount) private {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
        uint256 tTransferAmount;
        uint256 tFee;
        
        // We have to do this (getValues) two times, the first one is to get the ramount so we can 
        // understand what percentage of the wallet is being affected. We do this with a tax of 0 so
        // no fees are deducted.
        // We do it outside the "If then" so we can use the resulting values as the first instance of the if or at the else.
        // We do the second one, after we've calculated the taxes for this transaction.
        // This time around, taxes are charged.
        (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, 0);

        // Is this a regular wallet?
        if (!wallets[sender].isExcludedFromTaxAndReflections){

            // Regular accounts can't swap more often than once every 8 hours.
            require (wallets[sender].lastExchangeOperation <= block.timestamp - 8 hours, "Too soon");

            // Calculate the tax rate
            (uint256 taxRate) = calculateTaxAndLiquidityBasedOnTxPercentage(wallets[sender].reflectionsOwned, rAmount);

            // Now we need to calculate the transfer and fees/liqs with the updated tax values
            (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, taxRate);
            // We remove the reflections from the sender. All of the amount.
            wallets[sender].reflectionsOwned -= rAmount;
            // We add the reflections to the exchange. Just the transfer amount.
            wallets[recipient].reflectionsOwned += rTransferAmount;  
            // We add the tokens to the exchange. Just the transfer amount.
            wallets[recipient].tokensOwned += tTransferAmount;  
            // We update the timestamp so the wallet cannot operate until the next window.
            wallets[sender].lastExchangeOperation = block.timestamp;

        } else {
            // If this is an excluded wallet, then it's simpler as they are not charged taxes.
            // Take tokens from sender.
            wallets[sender].tokensOwned -= tAmount;
            // Take tokens from sender.
            wallets[sender].reflectionsOwned -= rAmount;
            // Add the tokens to the exchange.
            wallets[recipient].tokensOwned += tTransferAmount;  
            // We add the reflections to the exchange. Just the transfer amount.
            wallets[recipient].reflectionsOwned += rTransferAmount;  
        }

        // Now, take care of the liquidity and fees
        takeCareOfLiquidityAndFees(rFee, tFee);

        // Show the transaction to the world.
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    // If an excluded address is reciving tokens from PCS then, no fees.
    // This could be being done to manage LP or something to that extent.
    // If the recipient is a regular account, then they are obtaining tokens so, low fees.
    function transferFromExchange(address sender, address recipient, uint256 tAmount) private {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
        uint256 tTransferAmount;
        uint256 tFee;

        // Is this an excluded account?
        if (wallets[recipient].isExcludedFromTaxAndReflections){
            // No tax so 0 passed.
            (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, 0);
            // Remove the tokens from the exchange wallet.
            wallets[sender].tokensOwned -= tAmount;
            // Remove the reflections from the exchange wallet.
            wallets[sender].reflectionsOwned -= rAmount;
            // Add the tokens to the recipient.
            wallets[recipient].tokensOwned += tTransferAmount;
            // Add the reflections to the recipient.
            wallets[recipient].reflectionsOwned += rTransferAmount;
        } else {

            // This is a regular account getting tokens.
            // Regular accounts can't swap more often than once every 8 hours.
            require (wallets[recipient].lastExchangeOperation <= block.timestamp - 8 hours, "Too soon");
            // Minimal tax of 1%.
            (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, 1);
            // Remove the tokens from the exchange.
            wallets[sender].tokensOwned -= tAmount;
            // Remove the tokens from the exchange.
            wallets[sender].reflectionsOwned -= rAmount;
            // Add the reflections to the recipient's wallet.
            wallets[recipient].reflectionsOwned += rTransferAmount;

            // We update the timestamp so the wallet cannot operate until the next window.
            wallets[recipient].lastExchangeOperation = block.timestamp;
        }
        
        // Now, take care of the liquidity and fees
        takeCareOfLiquidityAndFees(rFee, tFee);
            
        // Show the transaction to the world.
        emit Transfer(sender, recipient, tTransferAmount);
    }

    // We are dealing with either, or both accounts being excluded but with no exanches involved.
    function transferWithExcluded(address sender, address recipient, uint256 tAmount) private {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rFee;
        uint256 tTransferAmount;
        uint256 tFee;

        // No taxes when working with excluded accounts 
        (rAmount, rTransferAmount, rFee, tTransferAmount, tFee) = getValues(tAmount, 0);

        //These apply to all cases
        // Remove reflections from sender.
        wallets[sender].reflectionsOwned -= rAmount;
        // Add reflections to recipient.
        wallets[recipient].reflectionsOwned += rTransferAmount;   


        // If both are excluded.
        if (wallets[sender].isExcludedFromTaxAndReflections && wallets[recipient].isExcludedFromTaxAndReflections){
            // Remove tokens from sender.
            wallets[sender].tokensOwned -= tAmount;
            // Add tokens to recipient.
            wallets[recipient].tokensOwned += tTransferAmount;  

        } else if(wallets[sender].isExcludedFromTaxAndReflections){
            // Only the sender is excluded so, take tokens from sender.
            wallets[sender].tokensOwned -= tAmount;  

        } else {
            // Add tokens to recipient.
            wallets[recipient].tokensOwned += tTransferAmount;  
        }
        
        // Now, take care of the liquidity and fees
        takeCareOfLiquidityAndFees(rFee, tFee);
            
        // Show the transaction to the world.
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function takeCareOfLiquidityAndFees(uint256 refFee, uint256 tokFee) private {
        // Add the liquidity tokens to the tokens owned by the contract.
        // Liquidity and fees have the same value so we only use a generic fee that we can apply both for 
        // liquidity and tax/reflections.
        wallets[address(this)].tokensOwned += tokFee;
        wallets[address(this)].reflectionsOwned += refFee;

        // Remove the fee from the reflections totals (this is how distribution happens).
        contractData.reflectionsTotal -= refFee;
    }

    // We are opening anyone to donate BNB to the dev team by sending it to the contract.
    // Together with the donations, there will be a very small amount of leftover BNB from 
    // the swaps that will accumulate over time.
    // The reason this leftover is in the contract is that after swap and liq, there's always a small
    // rounding amount because the exchange could never be exact.
    // This keeps accummulating in the contract address and it is inevitable because of the way liquidity pools work.
    // The ammount each time is minimal (a few dollar cents at current BNB value) so it does not
    // affect trading or liq at all.
    // However, it is a waste to leave this in the contract accumulating over time.
    // So, we've added a function that when called by anyone, sends the accummulated BNB to the devteam's wallet.
    // As ownership is renounced, the BNB would get locked and lost forever if this function did not exist.
    // This function does not work until the early distribution is done so devs can't collect BNB from it.

    function withdrawBNBDonationsToDevTeam() external{

        // If we are in early distribution or swapping, leave.
        if (!inEarlyDistro && !inSwapAndLiquify){
            // Get the balance.
            uint256 amount = address(this).balance;
            // Send the BNB to the devs wallet.
            payable(devteam).transfer(amount);

            // Let everyone know this happened.
            emit Transfer(address(this), address(devteam), amount);
        }
    }

    // This function is only callable by dev team.
    // The use for this is to add or remove an exchange account.
    // To add, we simply append at the end of the array.
    // To remove, we need to go through a loop, find the account, remove it, 
    // move the last account into the slot of the removed one and then, shorten the array by 1.
    // We also set the right flags on the account and convert/remove tokens.
    function addRemoveExchange(address account, bool addRemove) external {
        // If the devteam did not call this, leave.
        if (msg.sender == devteam){
            // If this flag is true then, we are adding an exchange.
            if (addRemove){
                // if it has any reflections on it we get the token value for them.
                wallets[account].tokensOwned = tokensFromReflections(wallets[account].reflectionsOwned);
                // This wallet is now an exchange.
                wallets[account].walletIsExchange = true;
                // Exclude the wallet from taxes and reflections.
                wallets[account].isExcludedFromTaxAndReflections = true;
                // Add the account to the newExchanges array for later looping when needed.
                newExchanges.push(account);
            } else {
                // We are removing an exchange.
                // We need to loop through the array until we find the affected account.
                for (uint256 i = 0; i < newExchanges.length; i++) {
                    // If we find it, we remove it.
                    if (newExchanges[i] == account) {
                        // We move the last address into the affected account spot.
                        newExchanges[i] = newExchanges[newExchanges.length - 1];
                        // Remove all tokens.
                        wallets[newExchanges[i]].tokensOwned = 0;
                        // Set the flag off. No longer an exchange.
                        wallets[newExchanges[i]].walletIsExchange = false;
                        // Let it experience taxes and reflections again.
                        wallets[newExchanges[i]].isExcludedFromTaxAndReflections = false;
                        // Remove the last entry from the array.
                        newExchanges.pop();
                        // Break once found. No need to finish.
                        break;
                    }
                }
            }
        }
        return;
    }
}