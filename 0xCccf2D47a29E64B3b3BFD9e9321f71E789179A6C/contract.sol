pragma experimental ABIEncoderV2;
pragma solidity 0.6.4;

contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private initializing;

    /**
     * @dev Modifier to use in the initializer function of a contract.
     */
    modifier initializer() {
        require(
            initializing || isConstructor() || !initialized,
            "Contract instance has already been initialized"
        );

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            initialized = true;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        assembly {
            cs := extcodesize(self)
        }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

contract Oracle is Initializable {
    address public admin;
    address public proposedAdmin;

    address public feeder;

    modifier onlyAdmin {
        require(msg.sender == admin, "OnlyAdmin");
        _;
    }

    modifier onlyFeeder {
        require(msg.sender == feeder, "require feeder");
        _;
    }

    // 初始化，只能初始化一次
    function initialize()
        public
        initializer
    {
        admin = msg.sender;
    }

    function proposeNewAdmin(address admin_) external onlyAdmin {
        proposedAdmin = admin_;
    }

    function claimAdministration() external {
        require(msg.sender == proposedAdmin, "Not proposed admin.");
        admin = proposedAdmin;
        proposedAdmin = address(0);
    }

    function setFeeder(address _feeder) public onlyAdmin {
        feeder = _feeder;
    }

    struct Price {
        uint price;
        uint expiration;
    }

    mapping (address => Price) public prices;

    function getExpiration(address token) external view returns (uint) {
        return prices[token].expiration;
    }

    function getPrice(address token) external view returns (uint) {
        return prices[token].price;
    }

    function get(address token) external view returns (uint, bool) {
        return (prices[token].price, valid(token));
    }

    function valid(address token) public view returns (bool) {
        return now < prices[token].expiration;
    }

    // 设置价格为 @val, 保持有效时间为 @exp second.
    function set(address token, uint val, uint exp) external onlyFeeder {
        prices[token].price = val;
        prices[token].expiration = now + exp;
    }

    //批量设置，减少gas使用
    function batchSet(address[] calldata tokens, uint[] calldata vals, uint[] calldata exps) external onlyFeeder {
        uint nToken = tokens.length;
        require(nToken == vals.length && vals.length == exps.length, "invalid array length");
        for (uint i = 0; i < nToken; ++i) {
            prices[tokens[i]].price = vals[i];
            prices[tokens[i]].expiration = now + exps[i];
        }
    }
}