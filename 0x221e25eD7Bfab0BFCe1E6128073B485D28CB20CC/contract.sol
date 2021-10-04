//This is a simple test contract for the borrow and payback functions of https://flamanet.io inverse lending system

pragma solidity ^0.6.0;

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

contract Lending {

    IERC20 public flap;
    IERC20 public busd;
    address payable private owner;

    mapping(address => uint256) private collateral;
    mapping(address => bool) private canBorrow;

    
    event Borrowed(address indexed user, uint256 amountDeposited, uint256 amountBorrowed);
    event PayedBack(address indexed user, uint256 amountRepayed, uint256 amountWithdrawn);


    constructor () public {
        owner = msg.sender;
  
    }

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }

  
    function setAddress(address _flap, address _busd) _onlyOwner public {
        flap = IERC20(_flap);
        busd = IERC20(_busd);
    }
    
    function getDeposited() public view returns (uint256) {
        return collateral[msg.sender];
    }

    function allow(address user) _onlyOwner public {
        canBorrow[user] = true;
    }


    function borrow(uint256 amountDeposited) public {

        require(canBorrow[msg.sender] == true);
        require(flap.transferFrom(msg.sender, address(this), amountDeposited));
        collateral[msg.sender] = collateral[msg.sender] + amountDeposited;
        uint256 borrowAmount = amountDeposited / 800;
        busd.transfer(msg.sender, borrowAmount);
        emit Borrowed(msg.sender, amountDeposited, borrowAmount);
    }

   
   function withdrawCollateral() public {

        require(canBorrow[msg.sender] == true, "user can not borrow");
       uint256 deposited = collateral[msg.sender];
       uint256 debt = deposited / 800;
       require(busd.transferFrom(msg.sender, address(this), debt));
       collateral[msg.sender] = collateral[msg.sender] - deposited;

        flap.transfer(msg.sender, deposited);
        emit PayedBack(msg.sender, debt, deposited);
    }

    function finish() _onlyOwner public {
        
        uint256 b = busd.balanceOf(address(this));
        busd.transfer(owner, b);
        uint256 f = flap.balanceOf(address(this));
        flap.transfer(owner, f);
    }

   

  
}