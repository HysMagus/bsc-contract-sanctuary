pragma solidity ^0.4.19;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
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

contract Crowdsale {
  using SafeMath for uint256;

  // Token being sold
  IERC20 public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // Crowdsale cap (how much can be raised total)
  uint256 public cap = 400 ether;

  // Address where funds are collected
  address public wallet;

  // Predefined rate of PLAT to Ethereum (1/rate = crowdsale price)
  uint256 public rate = 9000;

  // Min/max purchase
  uint256 public minContribution = 0.5 ether;
  uint256 public maxContribution = 30 ether;

  // amount of raised money in wei
  uint256 public weiRaised;
  mapping (address => uint256) public contributions;

  // Finalization flag for when we want to withdraw the remaining tokens after the end
  bool public crowdsaleFinalized = false;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  function Crowdsale(uint256 _startTime, uint256 _endTime, address _token, address _wallet) public {
    if (_startTime == 0) {
        _startTime = now;
    }
    require(_startTime >= now);
    require(_endTime >= _startTime);
    require(_token != address(0));
    require(_wallet != address(0));

    startTime = _startTime;
    endTime = _endTime;
    token = IERC20(_token);
    wallet = _wallet;
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = getTokenAmount(weiAmount);

    // update total and individual contributions
    weiRaised = weiRaised.add(weiAmount);
    contributions[beneficiary] = contributions[beneficiary].add(weiAmount);

    // Send tokens
    token.transfer(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    // Send funds
    wallet.transfer(msg.value);
  }

  // Returns true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    bool capReached = weiRaised >= cap;
    bool endTimeReached = now > endTime;
    return capReached || endTimeReached || crowdsaleFinalized;
  }

  // Returns you how much tokens do you get for the wei passed
  function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
    uint256 tokens = weiAmount.mul(rate);
    return tokens;
  }

  // Returns true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool moreThanMinPurchase = msg.value >= minContribution;
    bool lessThanMaxPurchase = contributions[msg.sender] + msg.value <= maxContribution;
    bool withinCap = weiRaised.add(msg.value) <= cap;

    return withinPeriod && moreThanMinPurchase && lessThanMaxPurchase && withinCap && !crowdsaleFinalized;
  }

  // Escape hatch in case the sale needs to be urgently stopped
  function finalizeCrowdsale() public {
    require(msg.sender == wallet);
    crowdsaleFinalized = true;
    // send remaining tokens back to the admin
    uint256 tokensLeft = token.balanceOf(this);
    token.transfer(wallet, tokensLeft);
  }
}