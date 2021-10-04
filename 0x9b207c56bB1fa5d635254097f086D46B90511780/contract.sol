/**
 * SPDX-License-Identifier: MIT
 * Staking contract for 0x000000000061c8326c4f0f5d1515ff78f1ec6a27 (STZ)
 * https://t.me/stakez_chat
 * BETA VERSION & Non-audited. Use with caution and DWYOR.
*/
pragma solidity ^0.6.0;

contract Ownable {

    address payable public owner;
    address payable public newOwner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        _transferOwnership(msg.sender);
    }

    function _transferOwnership(address payable _whom) internal {
        emit OwnershipTransferred(owner,_whom);
        owner = _whom;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner == msg.sender, "ERR_AUTHORIZED_ADDRESS_ONLY");
        _;
    }


    function transferOwnership(address payable _newOwner) external virtual onlyOwner {
        // emit OwnershipTransferred(owner, newOwner);
        newOwner = _newOwner;
    }

    function acceptOwnership() external
    virtual
    returns (bool){
        require(msg.sender == newOwner,"ERR_ONLY_NEW_OWNER");
        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);
        newOwner = address(0);
        return true;
    }
}

contract SafeMath {

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        return safeSub(a, b, "SafeMath: subtraction overflow");
    }


    function safeSub(uint256 a, uint256 b, string memory error) internal pure returns (uint256) {
        require(b <= a, error);
        uint256 c = a - b;
        return c;
    }


    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }


    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return safeDiv(a, b, "SafeMath: division by zero");
    }

    function safeDiv(uint256 a, uint256 b, string memory error) internal pure returns (uint256) {
        require(b > 0, error);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

}

interface ERC20Interface
{
    function totalSupply() external view returns(uint256);
    function balanceOf(address _tokenOwner)external view returns(uint balance );
    function allowance(address _tokenOwner, address _spender)external view returns (uint supply);
    function transfer(address _to,uint _tokens)external returns(bool success);
    function approve(address _spender,uint _tokens)external returns(bool success);
    function transferFrom(address _from,address _to,uint _tokens)external returns(bool success);

    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);
    event Approval(address indexed _owner, address indexed _spender, uint256 _tokens);
}

contract StakeStorage {


    mapping(address => bool) public listedToken;
    address[] public tokens;
    mapping(address => uint256)public tokenIndex;
    mapping(address => mapping(address => uint256)) public stakeBalance;
    mapping(address => mapping(address => uint256)) public lastStakeClaimed;
    mapping(address => uint256)public totalTokens;
    mapping(address => uint256) public annualMintPercentage;
    mapping(address => uint256)public tokenMinimumBalance;
    mapping(address => uint256)public tokenExtraMintForPayNodes;

    event Stake(
        uint256 indexed _stakeTimestamp,
        address indexed _token,
        address indexed _whom,
        uint256 _amount
    );

    event StakeClaimed(
        uint256 indexed _stakeClaimedTimestamp,
        address indexed _token,
        address indexed _whom,
        uint256 _amount
    );

    event UnStake(
        uint256 indexed _unstakeTimestamp,
        address indexed _token,
        address indexed _whom,
        uint256 _amount
    );
}


contract StakezStaking is Ownable, SafeMath, StakeStorage {

    constructor(address[] memory _token, uint256 _percent) public {
        for (uint8 i = 0; i < _token.length; i++) {
            listedToken[_token[i]] = true;
            annualMintPercentage[_token[i]] = _percent;
            tokens.push(_token[i]);
            tokenIndex[_token[i]] = i;
        }
    }

    /**
    * @dev stake token
    **/
    function stake(address _token, uint256 _amount) external returns (bool){

        require(listedToken[_token], "ERR_TOKEN_IS_NOT_LISTED");

        ERC20Interface(_token).transferFrom(msg.sender, address(this), _amount);

        if (lastStakeClaimed[_token][msg.sender] == 0) {
            lastStakeClaimed[_token][msg.sender] = now;
        } else {
            uint256 _stakeReward = _calculateStake(_token, msg.sender);
            lastStakeClaimed[_token][msg.sender] = now;
            stakeBalance[_token][msg.sender] = safeAdd(stakeBalance[_token][msg.sender], _stakeReward);
        }

        totalTokens[_token] = safeAdd(totalTokens[_token], _amount);
        stakeBalance[_token][msg.sender] = safeAdd(stakeBalance[_token][msg.sender], _amount);
        emit Stake(now, _token, msg.sender, _amount);
        return true;
    }

    /**
     * @dev stake token
     **/
    function unStake(address _token) external returns (bool){

        require(listedToken[_token], "ERR_TOKEN_IS_NOT_LISTED");

        uint256 userTokenBalance = stakeBalance[_token][msg.sender];
        uint256 _stakeReward = _calculateStake(_token, msg.sender);
        ERC20Interface(_token).transfer(msg.sender, safeAdd(userTokenBalance, _stakeReward));
        emit UnStake(now, _token, msg.sender, safeAdd(userTokenBalance, _stakeReward));
        totalTokens[_token] = safeSub(totalTokens[_token], userTokenBalance);
        stakeBalance[_token][msg.sender] = 0;
        lastStakeClaimed[_token][msg.sender] = 0;
        return true;
    }

    /**
     * @dev withdraw token
     **/
    function withdrawToken(address _token) external returns (bool){
        require(listedToken[_token], "ERR_TOKEN_IS_NOT_LISTED");
        uint256 userTokenBalance = stakeBalance[_token][msg.sender];
        stakeBalance[_token][msg.sender] = 0;
        lastStakeClaimed[_token][msg.sender] = 0;
        ERC20Interface(_token).transfer(msg.sender, userTokenBalance);
        return true;
    }

    /**
     * @dev withdraw token by owner
     * disabled for now
     
    function withdrawToken(address _token, uint256 _amount) external onlyOwner() returns (bool) {
        require(listedToken[_token], "ERR_TOKEN_IS_NOT_LISTED");
        require(totalTokens[_token] == 0, "ERR_TOTAL_TOKENS_NEEDS_TO_BE_0_FOR_WITHDRAWL");
        ERC20Interface(_token).transfer(msg.sender, _amount);
        return true;
    }
**/

    // we calculate daily basis stake amount
    function _calculateStake(address _token, address _whom) internal view returns (uint256) {
        uint256 _lastRound = lastStakeClaimed[_token][_whom];
        uint256 totalStakeDays = safeDiv(safeSub(now, _lastRound), 86400);
        uint256 userTokenBalance = stakeBalance[_token][_whom];
        uint256 tokenPercentage = annualMintPercentage[_token];
        if (totalStakeDays > 0) {
            uint256 stakeAmount = safeDiv(safeMul(safeMul(userTokenBalance, tokenPercentage), totalStakeDays), 3650000);
            return stakeAmount;
        }
        return 0;

    }

    // show stake balance with what user get
    function balanceOf(address _token, address _whom) external view returns (uint256) {
        uint256 _stakeReward = _calculateStake(_token, _whom);
        return safeAdd(stakeBalance[_token][_whom], _stakeReward);
    }

    // show stake balance with what user get
    function getOnlyRewards(address _token, address _whom) external view returns (uint256) {
        return _calculateStake(_token, _whom);
    }

    // claim only rewards and withdraw it
    function claimRewardsOnlyAndWithDraw(address _token) external returns (bool) {
        require(lastStakeClaimed[_token][msg.sender] != 0, "ERR_TOKEN_IS_NOT_STAKED");
        uint256 _stakeReward = _calculateStake(_token, msg.sender);
        ERC20Interface(_token).transfer(msg.sender, _stakeReward);
        lastStakeClaimed[_token][msg.sender] = now;
        emit StakeClaimed(now, _token, msg.sender, _stakeReward);
        return true;
    }

    // claim only rewards and restake it
    function claimRewardsOnlyAndStake(address _token) external returns (bool) {
        require(lastStakeClaimed[_token][msg.sender] != 0, "ERR_TOKEN_IS_NOT_STAKED");
        uint256 _stakeReward = _calculateStake(_token, msg.sender);

        lastStakeClaimed[_token][msg.sender] = now;
        stakeBalance[_token][msg.sender] = safeAdd(stakeBalance[_token][msg.sender], _stakeReward);
        emit StakeClaimed(now, _token, msg.sender, _stakeReward);
        emit Stake(now, _token, msg.sender, stakeBalance[_token][msg.sender]);
        return true;
    }

    // _percent should be mulitplied by 100
    function setAnnualMintPercentage(address _token, uint256 _percent) external onlyOwner() returns (bool) {
        require(listedToken[_token], "ERR_TOKEN_IS_NOT_LISTED");
        annualMintPercentage[_token] = _percent;
        return true;
    }

    // to add new token
    function addToken(address _token) external onlyOwner() {
        require(!listedToken[_token], "ERR_TOKEN_ALREADY_EXISTS");
        tokens.push(_token);
        listedToken[_token] = true;
        tokenIndex[_token] = tokens.length;
    }

    // to remove the token
    function removeToken(address _token) external onlyOwner() {
        require(listedToken[_token], "ERR_TOKEN_DOESNOT_EXISTS");
        uint256 _lastindex = tokenIndex[_token];
        address _lastaddress = tokens[safeSub(tokens.length, 1)];
        tokenIndex[_lastaddress] = _lastindex;
        tokens[_lastindex] = _lastaddress;
        tokens.pop();
        delete tokenIndex[_lastaddress];
        listedToken[_token] = false;
    }

    function availabletokens() public view returns (uint){
        return tokens.length;
    }
    
    // kill contract for new update/contract
    function kill() public onlyOwner {
         selfdestruct(msg.sender);
    }

}