// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// import "./Crowdsale.sol";
import "./SafeMath.sol";
import "./IERC20.sol";
import "./SafeERC20.sol";
import "./Ownable.sol";

contract SaleBase is Ownable{    
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 private _token;
    IERC20 private _paymentToken;
    IERC20 private _assetToken;
    uint256 private _rateNumerator;
    uint256 private _rateDenominator;
    uint256 private _weiRaised;
    address private  _tokenWallet;
    uint256 private _cap;
    uint256 private _openingTime;
    uint256 private _closingTime;
    address private _vault;
    uint256 private _holdPeriod;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _releaseTime;
    event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
    event ClaimToken(address indexed beneficiary, uint256 amount);

    constructor(
        uint256 rateNumerator,
        uint256 rateDenominator,
        IERC20 token,
        IERC20 paymentToken,
        address tokenWallet,
        uint256 cap,
        uint256 openingTime,
        uint256 closingTime,
        uint256 holdPeriod
    ) public{
        require(rateNumerator > 0, "rateNumerator is 0");
        require(rateDenominator > 0, "rateDenominator is 0");
        require(address(token) != address(0), "token is the zero address");
        require(address(paymentToken) != address(0), "paymentToken is zero address");
        require(tokenWallet != address(0), "token wallet is the zero address");
        require(cap > 0, "cap is 0");
        require(openingTime >= block.timestamp, "opening time is before current time");
        require(closingTime > openingTime, "opening time is not before closing time");
        require(holdPeriod >= 0);
        _rateNumerator = rateNumerator;
        _rateDenominator = rateDenominator;
        _token = token;
        _paymentToken = paymentToken;
        _assetToken = paymentToken;
        _tokenWallet = tokenWallet;
        _cap = cap;
        _openingTime = openingTime;
        _closingTime = closingTime;
        _vault = address(this);
        _holdPeriod = holdPeriod;
    }

    modifier onlyWhileOpen {
        require(isOpen(), "not open");
        _;
    }

    function setToken(IERC20 token) external onlyOwner{
        _token = token;
    }

    function tokenWallet() public view returns (address) {
        return _tokenWallet;
    }

    function setTokenWallet(address tokenWallet) external onlyOwner{
        require(tokenWallet != address(0));
        _tokenWallet = tokenWallet;
    }

    function remainingTokens() public view returns (uint256) {
        return Math.min(_token.balanceOf(_tokenWallet), _token.allowance(_tokenWallet, address(this)));
    }

    function cap() public view returns (uint256) {
        return _cap;
    }

    function capReached() public view returns (bool) {
        return _getTokenAmount(_weiRaised) >= _cap;
    }

    function openingTime() public view returns (uint256) {
        return _openingTime;
    }

    function setOpeningTime(uint openingTime) external onlyOwner{
        _openingTime = openingTime;
    }

    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    function setClosingTime(uint closingTime) external onlyOwner{
        _closingTime = closingTime;
    }

    function isOpen() public view returns (bool) {
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
    }

    function hasClosed() public view returns (bool) {
        return block.timestamp > _closingTime;
    }

    function holdPeriod() public view returns(uint256){
        return _holdPeriod;
    }

    function setHoldPeriod(uint holdPeriod) external onlyOwner{
        _holdPeriod = holdPeriod;
    }

    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    function rateNumerator() public view returns (uint256) {
        return _rateNumerator;
    }

    function setRateNumerator(uint rateNumerator) external onlyOwner{
        _rateNumerator = rateNumerator;
    }

    function rateDenominator() public view returns (uint256) {
        return _rateDenominator;
    }

    function token() public view returns (IERC20) {
        return _token;
    }

    function paymentToken() public view returns (IERC20) {
        return _paymentToken;
    }

    function setPaymentToken(IERC20 token) public onlyOwner{
        _paymentToken = token;
    }

    function setTokenAsset(IERC20 assetToken) external onlyOwner{
        require(address(assetToken) != address(0), "assetToken is 0");
        _assetToken = assetToken;
    }

    function withdrawAsset(address to, uint256 amount) external onlyOwner{
        _assetToken.safeTransfer(to, amount);
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function releaseTimeOf(address account) public view returns (uint256){
        return _releaseTime[account];
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) virtual internal onlyWhileOpen view {
        require(beneficiary != address(0), "beneficiary is the zero address");
        require(weiAmount != 0, "weiAmount is 0");
        require(_paymentToken.balanceOf(_msgSender()) >= weiAmount, "Insufficient balance busd");
        require(_getTokenAmount(_weiRaised.add(weiAmount)) <= _cap, "cap exceeded");
        require(remainingTokens()>= _getTokenAmount(weiAmount), "remain token isn't enough");
    }

    function extendTime(uint256 newClosingTime) public onlyOwner{
        require(!hasClosed(), "already closed");
        require(newClosingTime > _closingTime, "new closing time is before current closing time");
        emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
        _closingTime = newClosingTime;
    }

    function _processPurchase(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
        _paymentToken.safeTransferFrom(_msgSender(), address(this), weiAmount);
        _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
        _token.safeTransferFrom(_tokenWallet, _vault, tokenAmount);
        _releaseTime[_msgSender()] = block.timestamp.add(_holdPeriod);
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rateDenominator).div(_rateNumerator);
    }

    function buyTokens(uint256 weiAmount) public {
        // require(false, "den day");
        address beneficiary = _msgSender();
        _preValidatePurchase(beneficiary, weiAmount);
        uint256 tokenAmount = _getTokenAmount(weiAmount);
        _weiRaised = _weiRaised.add(weiAmount);
        _processPurchase(beneficiary, weiAmount, tokenAmount);
        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokenAmount);
    }

    function claimTokens() virtual public {
        uint256 amount = _balances[_msgSender()];
        require(amount > 0, "this address is not due any tokens");
        // require(block.timestamp > _closingTime, "Not ready for claim");
        require(block.timestamp >= _releaseTime[_msgSender()], "On hold");
        require(_token.transfer(_msgSender(), amount), "transfer fail");
        _balances[_msgSender()] = 0;
        emit ClaimToken(_msgSender(), amount);
    }
}