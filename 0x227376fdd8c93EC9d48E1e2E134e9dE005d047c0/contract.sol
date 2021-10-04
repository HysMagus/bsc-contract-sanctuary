// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

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

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

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
    function allowance(address _owner, address spender) external view returns (uint256);

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

interface PoolInterface {
    function deposit(uint256 _amount) external;
    function withdraw(uint256 _amount) external;
    function pendingReward(address _user) external view returns (uint256);
}

interface CAKEPoolInterface {
    function enterStaking(uint256 _amount) external;
    function leaveStaking(uint256 _amount) external;
    //CAKE Pool: _pid = 0, _user = address(this)
    function pendingCake(uint256 _pid, address _user) external view returns (uint256);
}

contract Strategy is Ownable{

    address private vaultAddress;
    address private strategistAddress;
    address private activePoolAddress;
    address private activeRewardTokenAddress;

    uint256 balance = 0;

    mapping(string => address) pools;
    mapping(string => address) rewardTokens;
    mapping(string => string) tokenOfPool;

    IBEP20 private cakeToken;
    IBEP20 private rewardToken;

    CAKEPoolInterface cakePool;

    /// @notice Összeköti a Straregy-t a Vaultal és a Strategist-el és megad egy kezdő pool-t
    /// @param _vaultAddress A Vault contract address-e
    /// @param _strategistAddress A Strategist contract address-e
    /// @param _poolSymbol A kezdő pool-t beazonosító szimbólum
    /// @param _poolAddress A kezdő pool címe
    /// @param _rewardTokenSymbol A jutalomként kapott tokent beazonosító szimbólum
    /// @param _rewardTokenAddress A jutalomként kapott token address-e
    constructor (
        address _vaultAddress, 
        address _strategistAddress, 
        string memory _poolSymbol, 
        address _poolAddress,
        string memory _rewardTokenSymbol,
        address _rewardTokenAddress
        ) {
        cakeToken = IBEP20(0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
        rewardToken = IBEP20(_rewardTokenAddress);
        vaultAddress = _vaultAddress;
        strategistAddress = _strategistAddress;
        pools[_poolSymbol] = _poolAddress;
        rewardTokens[_rewardTokenSymbol] = _rewardTokenAddress;
        tokenOfPool[_poolSymbol] = _rewardTokenSymbol;
        activePoolAddress = _poolAddress;
        activeRewardTokenAddress = _rewardTokenAddress;
        cakeToken.approve(activePoolAddress, uint256(-1));
        cakePool = CAKEPoolInterface(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
    }

    /// @notice A hívó csak a Vault lehet
    modifier onlyVault(){
        require(msg.sender == vaultAddress);
        _;
    }

    /// @notice A hívó csak a Strategist lehet
    modifier onlyStrategist(){
        require(msg.sender == strategistAddress);
        _;
    }

    /// @notice Approves Vault to manage the tokens it sends to Strategy
    /// @param _wot The address of the BEP20 token to approve
    /// @param _amount The amount of tokens to approve
    function acceptTokens(address _wot, uint256 _amount) external onlyVault {
        IBEP20(_wot).approve(msg.sender, _amount);
    }

    /// @notice lekéri a korábban approve-olt CAKE tokeneket, feljegyzi és elküldi az aktív poolnak
    /// @param _amount Az elküldésre szánt CAKE token mennyisége
    function deposit (uint256 _amount) external onlyVault {
        cakeToken.transferFrom(msg.sender, address(this), _amount);
        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            cakePool.enterStaking(_amount);
        } else {
            PoolInterface(activePoolAddress).deposit(_amount);
        }
        //PoolInterface(activePoolAddress).deposit(_amount);
        balance += _amount;
    }


    /// @notice A Vault számára az aktív pool-ból lekér egy bizonyos összeget és a nyereséget elküldi a Strategist-nek.
    /// A kezelt összeg változását könyveli.
    /// @param _amount A lekérni szándékozott CAKE token mennyisége
    function withdraw (uint256 _amount) external onlyVault {
        require(balance >= _amount, "There isn't enough balance");
        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            uint256 reward = cakePool.pendingCake(0, address(this));
            cakePool.leaveStaking(_amount);
            cakeToken.transfer(vaultAddress, _amount);
            rewardToken.transfer(strategistAddress, reward);
        } else {
            PoolInterface(activePoolAddress).withdraw(_amount);
            cakeToken.transfer(vaultAddress, _amount);
            rewardToken.transfer(strategistAddress, rewardToken.balanceOf(address(this)));
        }
        balance -= _amount;
    }

    /// @notice A Strategist kérésére az aktív pool-ból kivesz minden tokent, a nyereséget elküldi a Strategist-nek,
    /// a többit a Vaultnak. A kezelt összeget 0-ra állítja
    function withdrawAll () external onlyVault returns (uint256) {
        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            uint256 reward = cakePool.pendingCake(0, address(this));
            cakePool.leaveStaking(balance);
            cakeToken.transfer(vaultAddress, balance);
            rewardToken.transfer(strategistAddress, reward);
        } else {
            PoolInterface(activePoolAddress).withdraw(balance);
            cakeToken.transfer(vaultAddress, balance);
            rewardToken.transfer(strategistAddress, rewardToken.balanceOf(address(this)));
        }
        uint256 amount = balance;
        balance = 0;
        return amount;
    }

    /// @notice Nincs harvest függvény de a withdraw elküldi a jutalmat is.
    function harvest () external onlyStrategist {
        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            uint256 reward = cakePool.pendingCake(0, address(this));
            cakePool.leaveStaking(0);
            rewardToken.transfer(strategistAddress, reward);
        } else {
            PoolInterface(activePoolAddress).withdraw(0);
            rewardToken.transfer(strategistAddress, rewardToken.balanceOf(address(this)));
        }
    }

    /// @notice Kivesz mindent az aktív pool-ból, lecseráli az aktív pool-t és reward tokent,
    /// elküldi a nyereséget a Strategist-nek majd mindent berak az új aktív pool-ba
    /// @dev Fontos, hogy a pool és a token összetartozzon és már korábban el legyen tárolva
    /// @param _symbolOfNewPool Az új pool-t beazonosító szimbólum
    function reinvest (string memory _symbolOfNewPool) external onlyStrategist {
        require(pools[_symbolOfNewPool] != address(0x0), "This pool does not exist");
        require(rewardTokens[tokenOfPool[_symbolOfNewPool]] != address(0x0), "This pair is not set");

        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            uint256 reward = cakePool.pendingCake(0, address(this));
            cakePool.leaveStaking(balance);
            rewardToken.transfer(strategistAddress, reward);
        } else {
            PoolInterface(activePoolAddress).withdraw(balance);
            rewardToken.transfer(strategistAddress, rewardToken.balanceOf(address(this)));
        }

        activePoolAddress = pools[_symbolOfNewPool];
        activeRewardTokenAddress = rewardTokens[tokenOfPool[_symbolOfNewPool]];
        rewardToken = IBEP20(activeRewardTokenAddress);

        if(activePoolAddress == 0x73feaa1eE314F8c655E354234017bE2193C9E24E) {
            cakePool.enterStaking(balance);
        } else {
            PoolInterface(activePoolAddress).deposit(balance);
        }
    }

    /// @notice Új pool-t ad a tároltak listájához. Csak az Owner tudja meghívni
    /// @dev A token és a pool összetartozó legyen és a zoken már el legyen tárolva
    /// @param _poolSymbol Az új pool-t beazonosító szimbólum
    /// @param _poolAddress Az új pool címe
    /// @param _rewardTokenSymbol A jutalomként kapott tokent beazonosító szimbólum
    function addPool(string memory _poolSymbol, address _poolAddress, string memory _rewardTokenSymbol) external onlyOwner {
        require(pools[_poolSymbol] == address(0x0), "This pool is already set");
        require(rewardTokens[_rewardTokenSymbol] != address(0x0), "This token does not exist");
        pools[_poolSymbol] = _poolAddress;
        tokenOfPool[_poolSymbol] = _rewardTokenSymbol;
        cakeToken.approve(_poolAddress, uint256(-1));
    }

    /// @notice Új reward tokent ad a tároltak listájához. Csak az Owner tudja meghívni
    /// @param _rewardTokenSymbol Az új jutalomként kapott tokent beazonosító szimbólum
    /// @param _rewardTokenAddress Az új jutalomként kapott token address-e
    function addToken(string memory _rewardTokenSymbol, address _rewardTokenAddress) external onlyOwner {
        require(rewardTokens[_rewardTokenSymbol] == address(0x0), "This token is already set");
        rewardTokens[_rewardTokenSymbol] = _rewardTokenAddress;
    }

    /// @notice Egy már korábban megadott pool és reward token aktívra állítása. Csak az Owner tudja meghívni
    /// @dev A token és a pool összetartozó legyen.
    /// Fontos, hogy a Strategy contractot NE a Strategist deploy-olja biztonsági okokból.
    /// Ennek az a célja, hogy se a Strategist se az Owner ne tudjon visszaélni.
    /// A pool váltáshoz mind a kettő hozzájárulására szükség van.
    /// @param _poolSymbol Az új pool-t beazonosító szimbólum
    function rollback(string memory _poolSymbol) external onlyOwner {
        require(pools[_poolSymbol] != address(0x0), "This pool does not exist");
        require(rewardTokens[tokenOfPool[_poolSymbol]] != address(0x0), "This token does not exist");
        activePoolAddress = pools[_poolSymbol];
        activeRewardTokenAddress = rewardTokens[tokenOfPool[_poolSymbol]];
        rewardToken = IBEP20(activeRewardTokenAddress);
    }

    /// @notice Visszaadja A kezelt tokenek mennyiségét
    /// @return A CAKE tokenek amiért ez a Strategy felel
    function getBalance() public view returns (uint256) {
        return balance;
    }
}