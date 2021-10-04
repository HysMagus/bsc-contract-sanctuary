// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/token/ERC20/IERC20.sol

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/GSN/Context.sol

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/access/Ownable.sol

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

// File: browser/vaultprofiter.sol

pragma solidity 0.6.12;



interface Vault  is IERC20 {
    function withdraw(uint256 maxShares,address recepient,uint256 maxloss) external;
}
interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint) external;
}
interface IUniswapV2Router02 {
    function WETH() external view returns (address);
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
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface ISushiswapV2Pair is IERC20 {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function sync() external;
    function token0() external view returns (address);
    function token1() external view returns (address);
    function skim(address to) external;
}


// SPDX-License-Identifier: MIT
contract VaultProfiter is Ownable {

    mapping(address => bool) public allowed;

    //Vault addresses
    address internal smokeVault = 0x005Ad6Db36161526100711fE2F359e9Ed9893aae;
    address internal tacoVault  = 0x825fa148Fc45e6A79441746d4dD5379272EEdb8c;
    
    //Taco strategy
    address internal tacoStrat  = 0x33aC5a9d27b99D5030f484cfC7143f6974A07ebe;

    //Pair addresses
    address tacobnbpair         = 0x5590d45592C846DD820D360dd5Ba6b2610cDeeFB;

    //Shitcoin addresses
    address SMOKE               = 0x5239fE1A8c0b6ece6AD6009D15315e02B1E7c4Ea;
    address TACO                = 0x9066e87Bac891409D690cfEfA41379b34af06391;

    //Core addresses
    address ETH                 = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
    address WBNB                = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address BUSD                = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address USDT                = 0x55d398326f99059fF775485246999027B3197955;

    //Vault interfaces
    Vault ismokeVault           = Vault(smokeVault);
    Vault itacoVault            = Vault(tacoVault);

    //Pair interfaces
    ISushiswapV2Pair iTACOBNBPair         = ISushiswapV2Pair(tacobnbpair);

    //Token interfaces
    IERC20 iETH                 = IERC20(ETH);
    IERC20 iTACO                = IERC20(TACO);
    IWETH  iWBNB                = IWETH(WBNB);

    IUniswapV2Router02 router   = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    
    constructor() public {
        require(iTACO.approve(address(router),uint256(-1)));
        require(IERC20(SMOKE).approve(address(router),uint256(-1)));
    }

    modifier onlyWhitelisted() {
        require(_msgSender() == owner() || allowed[_msgSender()],"Unauthourized unpool");
        _;
    }

    function getTokenBalance(address tokenAddress) internal view returns (uint256){
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function recoverERC20(address tokenAddress,address receiver) public onlyOwner {
        IERC20(tokenAddress).transfer(receiver, getTokenBalance(tokenAddress));
    }

    function addWhitelisted(address _addr) external onlyOwner {
        allowed[_addr] = true;
    }
    function revokeWhitelisted(address _addr) external onlyOwner {
        allowed[_addr] = false;
    }

    //To receive BNB
    receive() external payable {}

    function pullVaultTokens(Vault _vault) internal {
        require(_vault.transferFrom(owner(),address(this),_vault.balanceOf(owner())),"Pulling vault fee share tokens failed");
    }

    function unpool() public onlyWhitelisted {
        //Pull smoke vault tokens
        pullVaultTokens(ismokeVault);
        //Pull taco vault tokens from owner 
        pullVaultTokens(itacoVault);
        //Pull taco vault rewards from strategy
        require(itacoVault.transferFrom(tacoStrat,address(this),itacoVault.balanceOf(tacoStrat)),"pulling strategy rewards failed for taco");
        if(itacoVault.balanceOf(address(this)) > 0)     unpoolTaco();
        if(ismokeVault.balanceOf(address(this)) > 0)     unpoolSmoke();
        //Assuming we had some stuff done,we withdraw WBNB
        uint wbnbbal = iWBNB.balanceOf(address(this));
        if(wbnbbal > 0) iWBNB.withdraw(wbnbbal);
        //Send out bnb
        payable(owner()).transfer(address(this).balance);
    }

    function unpoolTaco() public onlyWhitelisted {
        itacoVault.withdraw(uint256(-1),address(this),1);
        iTACOBNBPair.transfer(tacobnbpair,iTACOBNBPair.balanceOf(address(this)));
        iTACOBNBPair.burn(address(this));
        address[] memory sellpath = new address[](2);
        sellpath[0] = TACO;
        sellpath[1] = WBNB;
        //Swap to WBNB to this address
        router.swapExactTokensForTokens(
            iTACO.balanceOf(address(this)),
            0,
            sellpath,
            address(this),
            now
        );
    }

    function unpoolSmoke() public onlyWhitelisted {
        ismokeVault.withdraw(uint256(-1),address(this),1);
        address[] memory sellpath = new address[](2);
        sellpath[0] = SMOKE;
        sellpath[1] = WBNB;
        //Swap to WBNB to this address
        router.swapExactTokensForTokens(
            getTokenBalance(SMOKE),
            0,
            sellpath,
            address(this),
            now
        );
    }
}