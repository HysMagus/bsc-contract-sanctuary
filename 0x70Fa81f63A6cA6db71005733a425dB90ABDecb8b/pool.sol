// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "library.sol";

contract PausablePool is Context{
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);
    
    bool private _poolerPaused;
    bool private _buyerPaused;
    
    /**
     * @dev Modifier to make a function callable only when the pooler is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenPoolerNotPaused() {
        require(!_poolerPaused, "paused");
        _;
    }
   
   /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPoolerPaused() {
        require(_poolerPaused, "not paused");
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only when the buyer is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenBuyerNotPaused() {
        require(!_buyerPaused, "paused");
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenBuyerPaused() {
        require(_buyerPaused, "not paused");
        _;
    }
    
    /**
     * @dev Returns true if the pooler is paused, and false otherwise.
     */
    function poolerPaused() public view returns (bool) {
        return _poolerPaused;
    }
    
    /**
     * @dev Returns true if the buyer is paused, and false otherwise.
     */
    function buyerPaused() public view returns (bool) {
        return _buyerPaused;
    }
    
   /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The pooler must not be paused.
     */
    function _pausePooler() internal whenPoolerNotPaused {
        _poolerPaused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The pooler must be paused.
     */
    function _unpausePooler() internal whenPoolerPaused {
        _poolerPaused = false;
        emit Unpaused(_msgSender());
    }
    
   /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The buyer must not be paused.
     */
    function _pauseBuyer() internal whenBuyerNotPaused {
        _buyerPaused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The buyer must be paused.
     */
    function _unpauseBuyer() internal whenBuyerPaused {
        _buyerPaused = false;
        emit Unpaused(_msgSender());
    }
}

/**
 * @title base contract for option pool
 */
abstract contract PandaBase is IOptionPool, PausablePool{
    using SafeERC20 for IERC20;
    using SafeERC20 for IOption;
    using SafeMath for uint;
    using Address for address payable;
    
    // initialization once
    bool private inited;
    
    // pool direction enum
    enum PoolDirection{ CALL, PUT }
    
    /// @dev pool direction
    PoolDirection public immutable _direction;
    
    // option durations
    uint16 [] private _durations = [300,900,1800,2700,3600];
    
    /**
     * @dev option creation factory, set this based on blockchain,
     * constructor will fail if the address is illegal.
     */
    // rinkeby
    //IPandaFactory internal constant pandaFactory = IPandaFactory(0xb3Bc91A86ED4828Ebce841D1D364f21A0cee4c9F);
    
    // BSC
    IPandaFactory internal constant pandaFactory = IPandaFactory(0x0581C7D038AFd4818EAF92193A1B6A2BAd7382aC); 
    
    uint256 public collateral; // collaterals in this pool
    
    uint256 internal constant SHARE_MULTIPLIER = 1e18; // share multiplier to avert division underflow
    uint256 internal constant SIGMA_UPDATE_PERIOD = 3600; // sigma update period

    mapping (address => uint256) internal _premiumBalance; // tracking pooler's claimable premium
    mapping (address => uint256) internal _opaBalance; // tracking pooler's claimable OPA tokens
    mapping (address => uint256) internal _profitsBalance; // tracking buyer's claimable profits

    IOption [] internal _options; // all option contracts
    address internal _owner; // owner of this contract

    IERC20 public USDTContract; // USDT asset contract address
    AggregatorV3Interface public priceFeed; // chainlink price feed
    uint8 assetDecimal; // asset decimal
    CDFDataInterface public cdfDataContract; // cdf data contract;

    uint8 public utilizationRate = 50; // utilization rate of the pool in percent
    uint8 public maxUtilizationRate = 75; // max utilization rate of the pool in percent
    uint16 public sigma = 70; // current sigma
    
    uint256 private _sigmaSoldOptions;  // sum total options sold in a period
    uint256 private _sigmaTotalOptions; // sum total options issued
    uint256 private _nextSigmaUpdate = block.timestamp + SIGMA_UPDATE_PERIOD; // expected next sigma updating time;
    
    // tracking pooler's collateral with
    // the token contract of the pooler;
    IPoolerToken public poolerTokenContract;
    address public poolManager;     // platform contract
    
    IERC20 public OPAToken;  // OPA token contract

    /**
     * OPA Rewarding
     */
    /// @dev block reward for this pool
    uint256 public OPABlockReward = 10 * 1e18; 
    // @dev update period in secs for OPA distribution.
    uint256 public constant opaRewardUpdatePeriod = 3600;
    
    /// @dev round index mapping to accumulate share.
    mapping (uint => uint) private _opaAccShares;
    /// @dev mark pooler's highest settled OPA round.
    mapping (address => uint) private _settledOPARounds;
    /// @dev a monotonic increasing OPA round index, STARTS FROM 1
    uint256 private _currentOPARound = 1;
    /// @dev expected next OPA distribute time
    uint256 private _nextOPARewardUpdate = block.timestamp + opaRewardUpdatePeriod;
    // @dev last OPA reward block
    uint256 private _lastRewardBlock = block.number;

    /**
     * @dev Modifier to make a function callable only by owner
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "restricted");
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only by poolerTokenContract
     */
    modifier onlyPoolerTokenContract() {
        require(msg.sender == address(poolerTokenContract), "restricted");
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only by pool manager
     */
    modifier onlyPoolManager() {
        require(msg.sender == address(poolManager), "restricted");
        _;
    }
    
    /**
     * @dev Modifier to make a function callable only by options
     */
    modifier onlyOptions() {
        // privilege check
        bool isFromOption;
        for (uint i = 0; i < _options.length; i++) {
            if (address(_options[i]) == msg.sender) {
                isFromOption = true;
                break;
            }
        }
        require(isFromOption);
        _;
    }
    
    /**
     * @dev buyers try to update
     */
    modifier tryUpdate() {
        if (block.timestamp > getNextUpdateTime()) {
            update();
        }
        _;
    }

    /**
     * @dev abstract function for current option supply per slot
     */
    function _slotSupply(uint assetPrice) internal view virtual returns(uint);
    
    /**
     * @dev abstract function to calculate option profits
     */
    function _calcProfits(uint settlePrice, uint strikePrice, uint optionAmount) internal view virtual returns(uint256);
    
    /**
     * @dev abstract function to send back option profits
     */
    function _sendProfits(address payable account, uint256 amount) internal virtual;
    
    /**
     * @dev abstract function to get total pledged collateral
     */
    function _totalPledged() internal view virtual returns (uint);

    constructor(AggregatorV3Interface priceFeed_, uint8 assetDecimal_, PoolDirection direction_) public {
        _owner = msg.sender;
        priceFeed = priceFeed_;
        assetDecimal = assetDecimal_;
        _direction = direction_;
             
        // contract references
        USDTContract = IERC20(pandaFactory.getUSDTContract());
        cdfDataContract = CDFDataInterface(pandaFactory.getCDF());

        // set default poolManager
        poolManager = msg.sender;
    }
    
    /**
     * @dev Option initialization function.
     */
    function init() public onlyOwner {
        require(!inited, "inited");
        inited = true;

        // creation of options
        for (uint i=0;i<_durations.length;i++) {
            _options.push(pandaFactory.createOption(_durations[i], assetDecimal, IOptionPool(this)));
        }

        // first update;
        update();
    }

    /**
     * @dev Returns the owner of this contract
     */
    function owner() external override view returns (address) {
        return _owner;
    }
    
    /**
     * @dev transfer ownership
     */
    function transferOwnership(address newOwner) external override onlyOwner {
        require(newOwner != address(0), "zero");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    
    /**
     *@dev pooler & buyer pausing
     */
    function pausePooler() external override onlyOwner { _pausePooler(); }
    function unpausePooler() external override onlyOwner { _unpausePooler(); }
    function pauseBuyer() external override onlyOwner { _pauseBuyer(); }
    function unpauseBuyer() external override onlyOwner { _unpauseBuyer(); } 

    /**
     * @notice check remaining options for the option contract
     */
    function optionsLeft(IOption optionContract) external override view returns (uint256 optionsleft, uint round) {
        return (optionContract.balanceOf(address(this)), optionContract.getRound());
    }

    /**
     * @notice buy options via USDT, pool receive premium
     */
    function buy(uint amount, IOption optionContract, uint round) external override whenBuyerNotPaused tryUpdate {
        // check option expiry
        require(block.timestamp < optionContract.expiryDate(), "expired");
        // check if option current round is the given round
        require (optionContract.getRound() == round, "mismatch");
        // check remaing options
        require(optionContract.balanceOf(address(this)) >= amount, "soldout");

        // calculate premium cost
        uint premium = premiumCost(amount, optionContract);
        require(premium > 0, "too less");

        // transfer premium USDTs to this pool
        USDTContract.safeTransferFrom(msg.sender, address(this), premium);

        // transfer options to msg.sender
        optionContract.safeTransfer(msg.sender, amount);

        // credit premium to option contract
        optionContract.addPremium(premium);
        
        // sigma: count sold options
        _sigmaSoldOptions = _sigmaSoldOptions.add(amount);
        
        // log
        emit Buy(msg.sender, address(optionContract), round, amount, premium);
    }
    
    /**
     * @dev set OPA reward per height
     */
    function setOPAReward(uint256 amount) external onlyOwner {
        OPABlockReward = amount;
    }
    
    /**
     * @dev convert sigma to index, sigma will be rounded to nearest index
     */
    function _sigmaToIndex() private view returns(uint) {
        // sigma to index
        require(sigma >=15 && sigma <=145, "[15,145]");
        uint sigmaIndex = sigma / 5;
        return sigmaIndex;
    }

    /**
     * @notice check option cost for given amount of option
     */
    function premiumCost(uint amount, IOption optionContract) public override view returns(uint) {
        // expiry check
        if (block.timestamp >= optionContract.expiryDate()) {
            return 0;
        }
        
        // rounding to nearest duration
        uint timediff = optionContract.expiryDate().sub(block.timestamp).add(60);
        uint duration = timediff.div(120).mul(120); // round to 2min
        
        // align duration to [120, 3600]
        if (duration < 120) {
            duration = 120;
        } else if (duration > 3600) {
            duration = 3600;
        }

        // notice the CDF is already multiplied by cdfDataContract.Amplifier()
        uint cdf = cdfDataContract.CDF(duration, _sigmaToIndex());
        
        // calculate premium for option
        uint currentPrice = getAssetPrice();
        uint strikePrice = optionContract.strikePrice();

        // calculate USDT profits based on current price
        uint realtimeProfits;
        if (_direction == PoolDirection.CALL) {
            // @dev convert asset profits to USDT at current price
            realtimeProfits = _calcProfits(currentPrice, strikePrice, amount)
                                .mul(currentPrice)
                                .div(10 ** uint(optionContract.decimals()));
        } else {
            realtimeProfits = _calcProfits(currentPrice, strikePrice, amount);
        }
        
        // price in the realtime profits to avoid arbitrage.
        // @dev note the price is for 10 ** option decimals
        return realtimeProfits + amount * currentPrice * cdf  / (10 ** uint(optionContract.decimals())) / cdfDataContract.Amplifier();
    }

    /**
     * @notice list all options
     */
    function listOptions() external override view returns (IOption []memory) {
        return _options;
    }
    
    /**
     * @notice get current utilization rate
     */
    function currentUtilizationRate() external override view returns (uint256) {
        if (collateral > 0) {
            return _totalPledged().mul(100).div(collateral);
        }
        return 0;
    }
    
    /**
     * @notice get next update time
     */
    function getNextUpdateTime() public override view returns (uint) {
        uint nextUpdateTime =_nextSigmaUpdate;
        
        for (uint i = 0;i< _options.length;i++) {
            if (_options[i].expiryDate() < nextUpdateTime) {
                nextUpdateTime = _options[i].expiryDate();
            }
        }

        return nextUpdateTime;
    }

    /**
     * @notice update of options, triggered by anyone periodically
     */
    function update() public override {
        // load chainlink price
        uint assetPrice = getAssetPrice();

        // create a memory copy of array
        IOption [] memory options = _options;
        
        // accumulated manager's revenue
        uint256 accManagerRevenue;
        
        // settle all options
        for (uint i = 0;i< options.length;i++) {
            if (block.timestamp >= options[i].expiryDate()) { // expired
                accManagerRevenue += _settleOption(options[i], assetPrice);
            } else { // mark unexpired by clearning 0
                options[i] = IOption(0);
            }
        }
        
        // calculate supply for a slot after settlement,
        // notice we must settle options before option reset, otherwise
        // we cannot get a correct slot supply due to COLLATERAL WRITE DOWN
        // when multiple options settles at once.
        uint slotSupply = _slotSupply(assetPrice);
        for (uint i = 0;i < options.length;i++) {
            if (options[i] != IOption(0)) { // we only check expiryDate once, it's expensive.
                // reset option with new slot supply
                options[i].resetOption(assetPrice, slotSupply);

                // sigma: count newly issued options
                _sigmaTotalOptions = _sigmaTotalOptions.add(options[i].totalSupply());
            }
        }

        // should update sigma while sigma period expires
        if (block.timestamp > _nextSigmaUpdate) {
            updateSigma();
        }

        // OPA Reward Update
        if (block.timestamp > _nextOPARewardUpdate) {
            updateOPAReward();
        }
        
        // transfer manager's USDT premium at last
        if (accManagerRevenue > 0) {
            USDTContract.safeTransfer(poolManager, accManagerRevenue);
        }
    }
    
    /**
     * @dev settle option contract
     * 
     * ASSUMPTION:
     *  if one pooler's token amount keeps unchanged after settlement, then
     *  accmulated premiumShare * (pooler token) 
     *  is the share for one pooler.
     */
    function _settleOption(IOption option, uint settlePrice) internal returns (uint256 managerRevenue) {
        uint totalSupply = option.totalSupply();
        uint strikePrice = option.strikePrice();
        
        // count total sold options
        uint totalOptionSold = totalSupply.sub(option.balanceOf(address(this)));
        
        // calculate total profits
        uint totalProfits = _calcProfits(settlePrice, strikePrice, totalOptionSold);

        // substract collateral
        // buyer's profits is pooler's loss
        collateral = collateral.sub(totalProfits);

        // settle preimum dividends
        uint poolerTotalSupply = poolerTokenContract.totalSupply();
        uint totalPremiums = option.totalPremiums();
        uint round = option.getRound();
        
        // settle premium share
        uint roundPremiumShare;
        if (poolerTotalSupply > 0) {
            // 1% belongs to platform
            managerRevenue = totalPremiums.div(100);

            // 99% belongs to all pooler
            roundPremiumShare = totalPremiums.sub(managerRevenue)
                                .mul(SHARE_MULTIPLIER)      // mul share with SHARE_MULTIPLIER to avert from underflow
                                .div(poolerTotalSupply);
        }

        // set the accumulated premiumShare
        // @dev even if round == 0, and round - 1 underflows to 0xfff....fff, the return value wil be 0;
        uint accPremiumShare = roundPremiumShare.add(option.getRoundAccPremiumShare(round-1));
        option.setRoundAccPremiumShare(round, accPremiumShare);
    }
    
    /**
     * @dev update OPA reward
     */
    function updateOPAReward() internal {
        uint poolerTotalSupply = poolerTokenContract.totalSupply();

        // settle OPA share for this round
        uint roundOPAShare;
        if (poolerTotalSupply > 0) {
            uint blocksToReward = block.number.sub(_lastRewardBlock);
            uint mintedOPA = OPABlockReward.mul(blocksToReward);
    
            // OPA share per pooler token
            roundOPAShare = mintedOPA.mul(SHARE_MULTIPLIER)
                                        .div(poolerTotalSupply);
                                    
            // mark block rewarded;
            _lastRewardBlock = block.number;
        }
                
        // accumulate OPA share
       _opaAccShares[_currentOPARound] = roundOPAShare.add(_opaAccShares[_currentOPARound-1]);
       
        // next round setting                                 
        _currentOPARound++;
        _nextOPARewardUpdate += opaRewardUpdatePeriod;
    }

    /**
     * @dev function to update sigma value periodically
     */
    function updateSigma() internal {
        // sigma: metrics updates hourly
        if (_sigmaTotalOptions > 0) {
            uint16 s = sigma;
            // update sigma
            uint rate = _sigmaSoldOptions.mul(100).div(_sigmaTotalOptions);
            
            // sigma range [15, 145]
            if (rate > 90 && s < 145) {
                s += 5;
            } else if (rate < 50 && s > 15) {
                s -= 5;
            }
            
            sigma = s;
            
            // log sigma update 
            emit SigmaUpdate(s, rate);
        }
        
        // new metrics
        uint sigmaTotalOptions;
        uint sigmaSoldOptions;

        // create a memory copy of array
        IOption [] memory options = _options;
        
        // rebuild sold/total metrics
        for (uint i = 0;i< options.length;i++) {
            // sum all issued options and sold options
            uint supply = options[i].totalSupply();
            uint sold = supply.sub(options[i].balanceOf(address(this)));
            
            sigmaTotalOptions = sigmaTotalOptions.add(supply);
            sigmaSoldOptions = sigmaSoldOptions.add(sold);
        }
        
        // set back to contract storage
        _sigmaTotalOptions = sigmaTotalOptions;
        _sigmaSoldOptions = sigmaSoldOptions;
        
        // set next update time to one hour later
        _nextSigmaUpdate = block.timestamp + SIGMA_UPDATE_PERIOD;
    }
    
    /**
     * @notice adjust sigma manually
     */
    function adjustSigma(uint16 newSigma) external override onlyOwner {
        require (newSigma % 5 == 0, "needs 5*N");
        require (newSigma >= 15 && newSigma <= 145, "[15,145]");
        
        sigma = newSigma;
        
        emit SigmaSet(sigma);
    }

    /**
     * @notice poolers sum premium USDTs;
     */
    function checkPremium(address account) external override view returns(uint256 premium) {
        uint accountCollateral = poolerTokenContract.balanceOf(account);

        premium = _premiumBalance[account];

        for (uint i = 0; i < _options.length; i++) {
            IOption option = _options[i];
            uint currentRound = option.getRound();
            uint lastSettledRound = option.getSettledRound(account);
            
            uint roundPremium = option.getRoundAccPremiumShare(currentRound-1).sub(option.getRoundAccPremiumShare(lastSettledRound))
                                    .mul(accountCollateral)
                                    .div(SHARE_MULTIPLIER);  // remember to div by SHARE_MULTIPLIER    
            
            premium = premium.add(roundPremium);
        }
        
        return (premium);
    }
    
    /**
     * @notice poolers claim premium USDTs;
     */
    function claimPremium() external override whenPoolerNotPaused {
        // settle un-distributed premiums in rounds to _premiumBalance;
        _settlePooler(msg.sender);

        // premium balance modification
        uint amountUSDTPremium = _premiumBalance[msg.sender];
        _premiumBalance[msg.sender] = 0; // zero premium balance
        
        // transfer premium
        USDTContract.safeTransfer(msg.sender, amountUSDTPremium);
        
        // log
        emit PremiumClaim(msg.sender, amountUSDTPremium);
    }
    
     /**
     * @notice poolers sum unclaimed OPA;
     */
    function checkOPA(address account) external override view returns(uint256 opa) {
        uint accountCollateral = poolerTokenContract.balanceOf(account);
        uint lastSettledOPARound = _settledOPARounds[account];
        uint roundOPA = _opaAccShares[_currentOPARound-1].sub(_opaAccShares[lastSettledOPARound])
                                .mul(accountCollateral)
                                .div(SHARE_MULTIPLIER);  // remember to div by SHARE_MULTIPLIER    
                                
        return _opaBalance[account] + roundOPA;
    }
    
    /**
     * @notice claim OPA;
     */
    function claimOPA() external override whenPoolerNotPaused {
        // settle un-distributed OPA in rounds to _opaBalance;
        _settlePooler(msg.sender);

        // OPA balance modification
        uint amountOPA = _opaBalance[msg.sender];
        _opaBalance[msg.sender] = 0; // zero OPA balance
        
        // transfer OPA
        OPAToken.safeTransfer(msg.sender, amountOPA);
    }

    /**
     * @notice settle premium in rounds while pooler token transfers.
     */
    function settlePooler(address account) external override onlyPoolerTokenContract {
        _settlePooler(account);
    }

    /**
     * @notice settle premium in rounds to _premiumBalance, 
     * settle premium happens before any pooler token exchange such as ERC20-transfer,mint,burn,
     * and manually claimPremium;
     * 
     */
    function _settlePooler(address account) internal {
        uint accountCollateral = poolerTokenContract.balanceOf(account);
        
        // premium settlement
        uint premiumBalance = _premiumBalance[account];
        
        for (uint i = 0; i < _options.length; i++) {
            IOption option = _options[i];
            
            uint lastSettledRound = option.getSettledRound(account);
            uint newSettledRound = option.getRound() - 1;
            
            // premium
            uint roundPremium = option.getRoundAccPremiumShare(newSettledRound).sub(option.getRoundAccPremiumShare(lastSettledRound))
                                        .mul(accountCollateral)
                                        .div(SHARE_MULTIPLIER);  // remember to div by SHARE_MULTIPLIER
                                        
            premiumBalance = premiumBalance.add(roundPremium);

            // mark new settled round
            option.setSettledRound(newSettledRound, account);
        }
                        
        // log settled premium
        emit PremiumSettled(msg.sender, accountCollateral, premiumBalance.sub(_premiumBalance[account]));
        // set back balance to storage
        _premiumBalance[account] = premiumBalance;
        
        // OPA settlement
        {
            uint lastSettledOPARound = _settledOPARounds[account];
            uint newSettledOPARound = _currentOPARound - 1;
            
            // round OPA
            uint roundOPA = _opaAccShares[newSettledOPARound].sub(_opaAccShares[lastSettledOPARound])
                                    .mul(accountCollateral)
                                    .div(SHARE_MULTIPLIER);  // remember to div by SHARE_MULTIPLIER    
            
            // update OPA balance
            _opaBalance[account] += roundOPA;
            // mark new settled OPA round
            _settledOPARounds[account] = newSettledOPARound;
        }
    }
    
    /**
     * @notice net-withdraw amount;
     */
    function NWA() public view override returns (uint) {
        // get minimum collateral
        uint minCollateral = _totalPledged() * 100 / maxUtilizationRate;
        if (minCollateral > collateral) {
            return 0;
        }

        // net withdrawable amount
        return collateral.sub(minCollateral);
    }
    
    /**
     * @notice check claimable buyer's profits
     */
    function checkProfits(address account) external override view returns (uint256 profits) {
        // load from profits balance
        profits = _profitsBalance[account];
        // sum all profits from all options
        for (uint i = 0; i < _options.length; i++) {
            profits += checkOptionProfits(_options[i], account);
        }
        return profits;
    }
    
    /**
     * @notice check profits in an option
     */
    function checkOptionProfits(IOption option, address account) internal view returns (uint256 amount) {
        uint unclaimedRound = option.getUnclaimedProfitsRound(account);
        if (unclaimedRound == option.getRound()) {
            return 0;
        }

        // accumulate profits in _profitsBalance
        uint settlePrice = option.getRoundSettlePrice(unclaimedRound);
        uint strikePrice = option.getRoundStrikePrice(unclaimedRound);
        uint optionAmount = option.getRoundBalanceOf(unclaimedRound, account);
        
        return _calcProfits(settlePrice, strikePrice, optionAmount);
    }
        
    /**
     * @notice buyers claim option profits
     */   
    function claimProfits() external override whenBuyerNotPaused {
        // settle profits in options
        for (uint i = 0; i < _options.length; i++) {
            _settleBuyer(_options[i], msg.sender);
        }
    
        // load and clean profits
        uint256 accountProfits = _profitsBalance[msg.sender];
        _profitsBalance[msg.sender] = 0;
        
        // send profits
        _sendProfits(msg.sender, accountProfits);
        
        // log
        emit ProfitsClaim(msg.sender, accountProfits);
    }
    
    /**
     * @notice settle profits while option token transfers.
     */
    function settleBuyer(address account) external override onlyOptions {
        _settleBuyer(IOption(msg.sender), account);
    }

    /**
     * @notice settle profits in rounds to _profitsBalance, 
     * settle buyer happens before any option token exchange such as ERC20-transfer,mint,burn,
     * and manually claimProfits;
     * 
     */
    function _settleBuyer(IOption option, address account) internal {
        uint unclaimedRound = option.getUnclaimedProfitsRound(account);
        uint currentRound = option.getRound();
        
        // current round is always unsettled
        if (unclaimedRound == currentRound) {
            return;
        }

        // accumulate profits in _profitsBalance
        uint settlePrice = option.getRoundSettlePrice(unclaimedRound);
        uint strikePrice = option.getRoundStrikePrice(unclaimedRound);
        uint256 optionAmount = option.getRoundBalanceOf(unclaimedRound, account);
        uint256 profits = _calcProfits(settlePrice, strikePrice, optionAmount);
        
        // add profits to balance;
        _profitsBalance[account] += profits;
        
        // set current round unclaimed
        option.setUnclaimedProfitsRound(currentRound, account);
        
        // log settled profits
        emit ProfitsSettled(msg.sender, address(option), unclaimedRound, profits);
    }

    /**
     * @notice set pool manager
     */
    function setPoolManager(address poolManager_) external override onlyOwner {
        poolManager = poolManager_;
    }
    
    /**
     * @notice set OPA token
     */
    function setOPAToken(IERC20 OPAToken_) external override onlyOwner {
        OPAToken = OPAToken_;
    }
    
    /**
     * @notice set utilization rate by owner
     */
    function setUtilizationRate(uint8 rate) external override onlyOwner {
        require(rate >=0 && rate <= 100, "[0,100]");
        utilizationRate = rate;
    }
    
    /**
     * @notice set max utilization rate by owner
     */
    function setMaxUtilizationRate(uint8 maxrate) external override onlyOwner {
        require(maxrate >=0 && maxrate <= 100, "[0,100]");
        require(maxrate > utilizationRate, "less than rate");
        maxUtilizationRate = maxrate;
    }
    
        
    /**
     * @dev get the price for asset with regarding to asset decimals
     * Example:
     *  for ETH price oracle, this function returns the USDT price for 1 ETH
     */
    function getAssetPrice() public view returns(uint) {
        (, int latestPrice, , , ) = priceFeed.latestRoundData();

        if (latestPrice > 0) { // convert to USDT decimal
            return uint(latestPrice).mul(10 ** uint256(USDTContract.decimals()))
                                    .div(10 ** uint256(priceFeed.decimals()));
        }
        return 0;
    }
}

/**
 * @title Implementation of Native Call Option Pool
 * NativeCallOptionPool Call Option Pool use native currency as collateral and bets
 * on Chainlink Oracle Price Feed.
 */
contract NativeCallOptionPool is PandaBase {
    string private _name;
    /**
     * @param priceFeed Chainlink contract for asset price
     */
    constructor(string memory name_, AggregatorV3Interface priceFeed)
        PandaBase(priceFeed, 18, PoolDirection.CALL)
        public {
            _name = name_;
            // creation of pooler token
            poolerTokenContract = pandaFactory.createPoolerToken(18, IOptionPool(this));
        }

    /**
     * @dev Returns the pool of the contract.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @notice deposit ethers to this pool directly.
     */
    function deposit() external whenPoolerNotPaused payable {
        require(msg.value > 0, "0 value");
        poolerTokenContract.mint(msg.sender, msg.value);
        collateral = collateral.add(msg.value);
        
        // log
        emit Deposit(msg.sender, msg.value);
    }
    
    /**
     * @notice withdraw the pooled ethers;
     */
    function withdraw(uint amount) external whenPoolerNotPaused {
        require (amount <= poolerTokenContract.balanceOf(msg.sender), "balance exceeded");
        require (amount <= NWA(), "collateral exceeded");

        // burn pooler token
        poolerTokenContract.burn(msg.sender, amount);
        // substract collateral
        collateral = collateral.sub(amount);
  
        // transfer ETH to msg.sender
        msg.sender.sendValue(amount);
        
        // log 
        emit Withdraw(msg.sender, amount);
    }
        
    /**
     * @notice sum total collaterals pledged
     */
    function _totalPledged() internal view override returns (uint amount) {
        for (uint i = 0;i< _options.length;i++) {
            amount += _options[i].totalSupply();
        }
    }
    
    /**
     * @dev function to calculate option profits
     */
    function _calcProfits(uint settlePrice, uint strikePrice, uint optionAmount) internal view override returns(uint256 profits) {
        // call options get profits due to price rising.
        if (settlePrice > strikePrice && strikePrice > 0) { 
            // calculate ratio
            uint ratio = settlePrice.sub(strikePrice)
                                        .mul(1e12)              // mul by 1e12 here to avoid underflow
                                        .div(strikePrice);
            
            // calculate ETH profits of this amount
            uint holderETHProfit = ratio.mul(optionAmount)
                                        .div(1e12);         // remember to div by 1e12 previous mul-ed
            
            return holderETHProfit;
        }
    }

    /**
     * @dev send profits back to sender's address
     */
    function _sendProfits(address payable account, uint256 amount) internal override {
        account.sendValue(amount);
    }
    
    /**
     * @dev get current new option supply
     */
    function _slotSupply(uint) internal view override returns(uint) {
        return collateral.mul(utilizationRate)
                            .div(100)
                            .div(_options.length);
    }
}

/**
 * @title Implementation of ERC20 Asset Call Option Pool
 * ERC20 Asset Call Option Pool use ERC20 asset as collateral and bets
 * on Chainlink Oracle Price Feed.
 */
contract ERC20CallOptionPool is PandaBase {
    string private _name;
    IERC20 public assetContract;

    /**
     * @param priceFeed Chainlink contract for asset price
     * @param assetContract_ ERC20 asset contract address
     */
    constructor(string memory name_, IERC20 assetContract_, AggregatorV3Interface priceFeed)
        PandaBase(priceFeed, assetContract_.decimals(), PoolDirection.CALL)
        public { 
            _name = name_;
            assetContract = assetContract_;
            poolerTokenContract = pandaFactory.createPoolerToken(assetContract.decimals(), IOptionPool(this));
        }

    /**
     * @dev Returns the pool of the contract.
     */
    function name() public view override returns (string memory) {
        return _name;
    }
    
    /**
     * @notice deposit asset to this pool directly.
     */
    function depositAsset(uint256 amountAsset) external whenPoolerNotPaused {
        require(amountAsset > 0, "0 value");
        assetContract.safeTransferFrom(msg.sender, address(this), amountAsset);
        poolerTokenContract.mint(msg.sender, amountAsset);
        collateral = collateral.add(amountAsset);
        
        // log
        emit Deposit(msg.sender, amountAsset);
    }

    /**
     * @notice withdraw the pooled ethers;
     */
    function withdrawAsset(uint amountAsset) external whenPoolerNotPaused {
        require (amountAsset <= poolerTokenContract.balanceOf(msg.sender), "balance exceeded");
        require (amountAsset <= NWA(), "collateral exceeded");

        // burn pooler token
        poolerTokenContract.burn(msg.sender, amountAsset);
        // substract collateral
        collateral = collateral.sub(amountAsset);

        // transfer asset back to msg.sender
        assetContract.safeTransfer(msg.sender, amountAsset);
        
        // log 
        emit Withdraw(msg.sender, amountAsset);
    }
        
    /**
     * @notice sum total collaterals pledged
     */
    function _totalPledged() internal view override returns (uint amount) {
        for (uint i = 0;i< _options.length;i++) {   
            amount += _options[i].totalSupply();
        }
    }

    /**
     * @dev send profits back to account
     */
    function _sendProfits(address payable account, uint256 amount) internal override {
        assetContract.safeTransfer(account, amount);
    }

    /**
     * @dev function to calculate option profits
     */
    function _calcProfits(uint settlePrice, uint strikePrice, uint optionAmount) internal view override returns(uint256 profits) {
        // call options get profits due to price rising.
        if (settlePrice > strikePrice && strikePrice > 0) { 
            // calculate ratio
            uint ratio = settlePrice.sub(strikePrice)
                                    .mul(1e12)          // mul by 1e12 here to avoid from underflow
                                    .div(strikePrice);
            
            // calculate asset profits of this amount
            uint holderAssetProfit = ratio.mul(optionAmount)
                                    .div(1e12);         // remember to div by 1e12 previous mul-ed
            
            return holderAssetProfit;
        }
    }

    /**
     * @notice get current new option supply
     */
    function _slotSupply(uint) internal view override returns(uint) {
        return collateral.mul(utilizationRate)
                            .div(100)
                            .div(_options.length);
    }
}

/**
 * @title Implementation of Put Option Pool
 * Put Option Pool requires USDT as collateral and 
 * bets on Chainlink Oracle Price Feed of one asset.
 */
contract PutOptionPool is PandaBase {
    string private _name;
    uint private immutable assetPriceUnit;
    
    /**
     * @param priceFeed Chainlink contract for asset price
     * @param assetDecimal the decimal of the price
     */
    constructor(string memory name_, uint8 assetDecimal, AggregatorV3Interface priceFeed)
        PandaBase(priceFeed, assetDecimal, PoolDirection.PUT)
        public { 
            _name = name_;
            assetPriceUnit = 10 ** uint(assetDecimal);
            poolerTokenContract = pandaFactory.createPoolerToken(USDTContract.decimals(), IOptionPool(this));
        }

    /**
     * @dev Returns the pool of the contract.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @notice deposit of Tether USDTS, user needs
     * to approve() to this contract address first,
     * and call with the given amount.
     */
    function depositUSDT(uint256 amountUSDT) external whenPoolerNotPaused {
        require(amountUSDT > 0, "0 value");
        USDTContract.safeTransferFrom(msg.sender, address(this), amountUSDT);
        poolerTokenContract.mint(msg.sender, amountUSDT);
        collateral = collateral.add(amountUSDT);
        
        // log
        emit Deposit(msg.sender, amountUSDT);
    }
    
    /**
     * @notice withdraw the pooled USDT;
     */
    function withdrawUSDT(uint amountUSDT) external whenPoolerNotPaused {
        require (amountUSDT <= poolerTokenContract.balanceOf(msg.sender), "balance exceeded");
        require (amountUSDT <= NWA(), "collateral exceeded");

        // burn pooler token
        poolerTokenContract.burn(msg.sender, amountUSDT);
        // substract collateral
        collateral = collateral.sub(amountUSDT);

        // transfer USDT to msg.sender
        USDTContract.safeTransfer(msg.sender, amountUSDT);
        
        // log 
        emit Withdraw(msg.sender, amountUSDT);
    }
    
    /**
     * @notice sum total collaterals pledged
     */
    function _totalPledged() internal view override returns (uint) {
        // sum total collateral in USDT
        uint total;
        for (uint i = 0;i< _options.length;i++) {
            // derive collaterals at issue time
            total = total.add(_options[i].totalSupply() * _options[i].strikePrice());
        }
        
        // @dev remember to div with asset price unit
        total /= assetPriceUnit;        
        return total;
    }

    /**
     * @dev send profits back to account
     */
    function _sendProfits(address payable account, uint256 amount) internal override {
        USDTContract.safeTransfer(account, amount);
    }

    /**
     * @dev function to calculate option profits
     */
    function _calcProfits(uint settlePrice, uint strikePrice, uint optionAmount) internal view override returns(uint256 profits) {
        if (settlePrice < strikePrice && strikePrice > 0) {  // put option get profits at this round
            // calculate ratio
            uint ratio = strikePrice.sub(settlePrice)
                                    .mul(1e12)                  // mul 1e12 to avoid from underflow
                                    .div(strikePrice);

            // holder share
            uint holderShare = ratio.mul(optionAmount);

         
            // convert to USDT profits
            uint holderUSDTProfit = holderShare.mul(strikePrice)
                                    .div(1e12)                  // remember to div 1e12 previous multipied
                                    .div(assetPriceUnit);       // remember to div price unit

            return holderUSDTProfit;
        }
    }

    /**
     * @notice get current new option supply
     */
    function _slotSupply(uint assetPrice) internal view override returns(uint) {
        // Formula : (collateral / numOptions) * utilizationRate / 100 / (assetPrice/ price unit)
       return collateral.mul(utilizationRate)
                            .mul(assetPriceUnit)
                            .div(100)
                            .div(_options.length)
                            .div(assetPrice);
    }
}