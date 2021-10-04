/**
 *Submitted for verification at BscScan.com on 2021-09-28
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

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

contract TokenClaim {
  address public admin;

  mapping(address => bool) public processedClaim;
  mapping(address => bool) public userRefunded;
  mapping(address => uint256) public addressToAmount;
  mapping(address => uint256) public addressToRefundAmount;
  uint256 public whitelistCount;

  address public idoToken;
  address public refundToken; // BUSD,...

  uint256 public currentDistributeAmount;

  uint256 public refundBlockNumber;
  
  event EventClaimed(
    address recipient,
    uint amount,
    uint date
  );

  event EventRefunded(
    address recipient,
    uint amount,
    uint date
  );

  constructor(
    address _idoToken, 
    address _refundToken,
    uint256 _refundBlockNumber
  ) 
  {
    admin = msg.sender; 
    refundToken = _refundToken;
    idoToken = _idoToken;
    refundBlockNumber = _refundBlockNumber;
  }

  function setConfig(
    address _newAdmin,
    address _refundTk,
    address _idoToken,
    uint256 _refundBlock
  ) 
    external 
  {
    require(msg.sender == admin, 'only admin');
    if (_newAdmin != address(0)) {
        admin = _newAdmin;   
    }
    
    if (_refundTk != address(0)) {
        refundToken = _refundTk;    
    }
    
    if (_idoToken != address(0)) {
        idoToken = _idoToken;    
    }
    
    if (_refundBlock != 0) {
        refundBlockNumber = _refundBlock;        
    }

  }

  function emergencyWithdraw(
    address _token, 
    address _to, 
    uint256 _amount
  ) 
    external 
  {
    require(msg.sender == admin,'Not allowed');
    IERC20(_token).transfer(_to, _amount);
  }

  function refund() external {
    require(msg.sender != address(0),'Invalid address');
    require(addressToAmount[msg.sender] > 0,'Your are not in whitelist');
    require(block.number < refundBlockNumber, 'Refund is no longer allowed');
    require(refundBlockNumber > 0, 'Not refundable');
    require(userRefunded[msg.sender] == false, 'Already refunded');
    require(processedClaim[msg.sender] == false, 'Already claimed');
    
    if (IERC20(refundToken).balanceOf(address(this)) > 0) {
        userRefunded[msg.sender] = true;
        IERC20(refundToken).transfer(msg.sender, addressToRefundAmount[msg.sender]);
        emit EventRefunded(
          msg.sender,
          addressToRefundAmount[msg.sender],
          block.timestamp
        );   
    }
  }

  function claimTokens() external {
    require(msg.sender != address(0),'Invalid address');
    // must be in whitelist 
    require(addressToAmount[msg.sender] > 0,'Not in whitelist or claimed');
    // already claimed 
    require(processedClaim[msg.sender] == false, 'Distribute already processed');
    // already refunded
    require(userRefunded[msg.sender] == false,'Refunded');

     if (IERC20(idoToken).balanceOf(address(this)) > 0) {
        uint256 amount = addressToAmount[msg.sender];
        currentDistributeAmount += amount;
        processedClaim[msg.sender] = true;
        IERC20(idoToken).transfer(msg.sender, amount);
        emit EventClaimed(
          msg.sender,
          amount,
          block.timestamp
        );
     }
  }
  
  function isUserRefundedOrClaimed() external returns(bool){
      
  }

  function addWhitelistAmount(
    address[] memory addressesToDistribute, 
    uint256[] memory amountsToDistribute,
    uint256[] memory amountsToRefund
  ) 
    external 
  {  
    require(msg.sender == admin,'only admin');

    for(uint i = 0; i < addressesToDistribute.length; i++){
      addressToAmount[addressesToDistribute[i]] = amountsToDistribute[i];
    }
    for(uint j = 0; j < addressesToDistribute.length; j++){
      addressToRefundAmount[addressesToDistribute[j]] = amountsToRefund[j];
    }

  }
  
  function updateWhitelistAmount(
    address addr, 
    uint256 amt, 
    uint256 refundAmt
  ) 
    external 
  {  
    require(msg.sender == admin,'only admin');
    processedClaim[addr] = false;
    userRefunded[addr] = false;
    addressToAmount[addr] = amt;
    addressToRefundAmount[addr] = refundAmt;
    
  }


}