// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

// pragma solidity ^0.6.0;

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
     * // importANT: Beware that changing an allowance with this method brings the risk
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


// Root file: src/TokenBurner.sol

pragma solidity >=0.4.21 <0.7.0;
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20WithPermit {
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
}

interface Burnable {
    function burn(address account, uint256 amount) external;
}

interface IMatatakiPeggedTokenFactory {
    function allPeggedTokens() external returns(address[] memory);
    function symbolToAddress(string calldata) external returns(address);
    function computeAddress(string calldata _name, string calldata _symbol)
        external
        view
        returns (address predictedAddress);
}

interface IERC20Detailed {
    function name() external returns(string memory);
    function symbol() external returns(string memory);
}

contract MatatakiTokenBurner {
    address public factory;
    event BurnFanPiao(address indexed tokenAddress, uint256 indexed uid, uint256 value);

    constructor(address _factory) public {
        factory = _factory;
    }

    modifier isMatatakiPeggedToken(address _token) {
        IERC20Detailed erc20 = IERC20Detailed(_token);
        string memory name = erc20.name();
        string memory symbol = erc20.symbol();
        address computed = IMatatakiPeggedTokenFactory(factory).computeAddress(name, symbol);
        address registered = IMatatakiPeggedTokenFactory(factory).symbolToAddress(symbol);
        require(registered != address(0) && computed == registered, "MatatakiTokenBurner::BAD_TOKEN: Failed to lookup");
        _;
    }

    function burn(
        address token,
        uint256 uid,
        uint256 value
    ) public isMatatakiPeggedToken(token) {
        IERC20(token).transferFrom(msg.sender, address(this), value); // send value to us
        // burn value in our contract, the contract have to to be admin
        Burnable(token).burn(address(this), value);
        emit BurnFanPiao(token, uid, value);
    }

    function burnWithPermit(
        address token,
        uint256 uid,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        // equal of approve, with offline signature
        IERC20WithPermit(token).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
        burn(token, uid, value);
    }
}