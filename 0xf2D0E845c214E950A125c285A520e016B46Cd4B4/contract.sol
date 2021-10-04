pragma solidity 0.6.12;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


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


contract IdoDFY is Ownable {
    constructor(
        address _DFYToken,
        uint256 _buyMinimum,
        uint256 _buyMaximum,
        uint256 _maxPersonRef,
        uint256 _maxRewardFromRef,
        uint256 _refRewardPercent,
        uint _start,
        uint _end
    ) public {
        DFYToken = IERC20(address(_DFYToken));
        stage = Stage.Unpause;
        buyMinimum = _buyMinimum;
        buyMaximum = _buyMaximum;
        maxPersonRef = _maxPersonRef;
        maxRewardFromRef = _maxRewardFromRef;
        refRewardPercent = _refRewardPercent;
        start = _start;
        end = _end;
        isPublic = false;
    }

    uint256 public buyMinimum;
    uint256 public buyMaximum;
    uint256 public refRewardPercent;
    uint256 public maxPersonRef;
    uint256 public maxRewardFromRef;
    uint public start;
    uint public end;

    using SafeMath for uint256;
    IERC20 private DFYToken;

    struct ExchangePair {
        uint256 output;
        uint256 input;
        bool status;
    }

    mapping(address => address) public beReferred;
    mapping(address => uint256) public referralRewardTotal;
    mapping(address => uint8) public referralUserTotal;

    mapping(address => uint256) public boughtAmountTotals;

    enum Stage {Unpause, Pause}

    Stage public stage;

    mapping(address => bool) public whitelist;
    bool isPublic;

    modifier requireOpen {
        require(stage == Stage.Unpause, "Stage close");
        require(block.timestamp >= start, "IDO time is not started");
        require(block.timestamp <= end, "IDO time was end");

        require(isPublic || whitelist[msg.sender], "Public sale still not open");

        _;
    }

    mapping(address => ExchangePair) public exchangePairs;
    address[] public supportedTokens;

    event UpdateExchangePair(
        address token,
        uint256 input,
        uint256 output,
        uint256 time
    );

    function setStage(Stage _stage) public onlyOwner{
        stage = _stage;
    }

    function setPublic(bool _isPublic) public onlyOwner {
        isPublic = _isPublic;
    }

    function addWhiteList(address _whitelist) public onlyOwner {
        whitelist[_whitelist] = true;
    }

    function updateExchangePair(
        address token,
        uint256 output,
        uint256 input
    ) public onlyOwner {
        require(token != address(0), "Token invalid");
        if (!exchangePairs[token].status) {
            supportedTokens.push(token);
        }
        exchangePairs[token] = ExchangePair(output, input, true);
        emit UpdateExchangePair(token, input, output, block.timestamp);
    }

    event DeleteExchangePair(address token, uint256 time);

    function deleteExchangePair(address token) public onlyOwner {
        require(exchangePairs[token].status, "Status invalid");
        delete exchangePairs[token];

        address[] storage addressTokens;

        for (uint i = 0; i < supportedTokens.length; i++) {
            if(supportedTokens[i] != token) {
                addressTokens.push(supportedTokens[i]);
            }
        }
        supportedTokens = addressTokens;

        emit DeleteExchangePair(token, block.timestamp);
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    event BuyIDO(
        address token,
        address user,
        uint256 amount,
        uint256 dfyAmount,
        address referral,
        uint256 referralAmount,
        uint256 time
    );

    function buyIdo(
        address token,
        uint256 amount,
        address referral
    ) external requireOpen {
        require(exchangePairs[token].status, "Exchange pair is not exist!");

        IERC20 transferToken = IERC20(token);

        require(
            transferToken.balanceOf(msg.sender) >= amount,
            "Token insufficient"
        );

        uint256 outputDFYAmount =
        (exchangePairs[token].output.mul(amount)).div(
            exchangePairs[token].input
        );

        require(
            outputDFYAmount >= buyMinimum*(10 ** 18),
            "Amount DFY request is too low"
        );

        require(
            boughtAmountTotals[msg.sender] + outputDFYAmount <= buyMaximum*(10 ** 18),
            "Request DFY amount is exceeded!"
        );

        boughtAmountTotals[msg.sender] += outputDFYAmount;

        require(
            DFYToken.balanceOf(address(this)) >= outputDFYAmount,
            "DFY insufficient"
        );

        require(
            transferToken.transferFrom(msg.sender, owner(), amount),
            "Token transfer fail"
        );

        require(
            DFYToken.approve(msg.sender, outputDFYAmount),
            "DFY approve failed!"
        );

        require(
            DFYToken.transfer(msg.sender, outputDFYAmount),
            "DFY transfer fail"
        );

        uint256 referralReceiveAmount = 0;
        if (referral != address(0)
        && referral != msg.sender
        && beReferred[msg.sender] == address(0)
        && referralUserTotal[referral] < maxPersonRef) {
            uint256 expectedReferralReceiveAmount = (outputDFYAmount.mul(refRewardPercent)).div(
                100
            );

            if(referralRewardTotal[referral] + expectedReferralReceiveAmount <= maxRewardFromRef*(10 ** 18)) {
                referralReceiveAmount = expectedReferralReceiveAmount;
            } else {
                referralReceiveAmount = maxRewardFromRef*(10 ** 18) - referralRewardTotal[referral];
            }

        }

        if (referralReceiveAmount > 0) {

            referralRewardTotal[referral] += referralReceiveAmount;
            referralUserTotal[referral] += 1;

            beReferred[msg.sender] = referral;

            require(
                DFYToken.approve(referral, referralReceiveAmount),
                "DFY approve ref failed!"
            );

            require(
                DFYToken.transfer(referral, referralReceiveAmount),
                "DFY transfer referral fail"
            );
            emit BuyIDO(
                token,
                msg.sender,
                amount,
                outputDFYAmount,
                referral,
                referralReceiveAmount,
                block.timestamp
            );
        }
        emit BuyIDO(
            token,
            msg.sender,
            amount,
            outputDFYAmount,
            address(0),
            0,
            block.timestamp
        );
    }

    function getTokenSupport() public view returns (address[] memory) {
        return supportedTokens;
    }

    function getExchangePair(address _tokenAddress) public view returns (address tokenAddress, uint256 output, uint256 input, bool status) {
        return (_tokenAddress, exchangePairs[_tokenAddress].output, exchangePairs[_tokenAddress].input, exchangePairs[_tokenAddress].status);
    }

    event WithdrawnToken(
        address token,
        uint256 amount,
        address receiveAddress
    );

    function withdrawnToken(address _tokenAddress, uint256 amount) external onlyOwner {
        IERC20 transferToken = IERC20(_tokenAddress);
        require(
            transferToken.balanceOf(address(this)) >= amount,
            "Token insufficient"
        );

        require(
            transferToken.approve(owner(), amount),
            "Token approve failed!"
        );

        require(
            transferToken.transfer(owner(), amount),
            "Token transfer fail"
        );

        emit WithdrawnToken(
            _tokenAddress,
            amount,
            owner()
        );
    }

}