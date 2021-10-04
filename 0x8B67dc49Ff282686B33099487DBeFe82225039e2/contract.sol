// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ITreasury {
    function notifyExternalReward(uint256 _amount) external;
}

contract ProxyTreasury is ITreasury {
    // governance
    address public operator;

    // flags
    bool public initialized = false;

    address public timelock = address(0x92a082Ad5A942140bCC791081F775900d0A514D9); // 24h timelock
    address public dollar = address(0x190b589cf9Fb8DDEabBFeae36a813FFb2A702454); // BDO
    address public uniRouterAddress = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F); // Pancakeswap
    address public treasury = address(0x15A90e6157a870CD335AF03c6df776d0B1ebf94F);

    event Initialized(address indexed executor, uint256 at);

    function initialize() public notInitialized {
        timelock = address(0x92a082Ad5A942140bCC791081F775900d0A514D9);
        dollar = address(0x190b589cf9Fb8DDEabBFeae36a813FFb2A702454);
        uniRouterAddress = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
        treasury = address(0x15A90e6157a870CD335AF03c6df776d0B1ebf94F);
        initialized = true;
        operator = msg.sender;
        emit Initialized(msg.sender, block.number);
    }

    modifier onlyOperator() {
        require(operator == msg.sender, "ProxyTreasury: caller is not the operator");
        _;
    }

    modifier onlyTimelock() {
        require(timelock == msg.sender, "ProxyTreasury: caller is not timelock");
        _;
    }

    modifier notInitialized() {
        require(!initialized, "ProxyTreasury: already initialized");
        _;
    }

    function setOperator(address _operator) external onlyOperator {
        operator = _operator;
    }

    function setUniRouterAddress(address _uniRouterAddress) external onlyOperator {
        uniRouterAddress = _uniRouterAddress;
    }

    function setTreasury(address _treasury) external onlyOperator {
        treasury = _treasury;
    }

    function notifyExternalReward(uint256 _amount) external override {}

    /* ========== EMERGENCY ========== */

    function setTimelock(address _timelock) external onlyTimelock {
        timelock = _timelock;
    }

    function inCaseTokensGetStuck(
        address _token,
        uint256 _amount,
        address _to
    ) external onlyTimelock {
        IERC20(_token).transfer(_to, _amount);
    }

    event ExecuteTransaction(address indexed target, uint256 value, string signature, bytes data);

    /**
     * @dev This is from Timelock contract.
     */
    function executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data
    ) public onlyTimelock returns (bytes memory) {
        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solium-disable-next-line security/no-call-value
        (bool success, bytes memory returnData) = target.call{value: value}(callData);
        require(success, "ProxyTreasury::executeTransaction: Transaction execution reverted.");

        emit ExecuteTransaction(target, value, signature, data);

        return returnData;
    }
}