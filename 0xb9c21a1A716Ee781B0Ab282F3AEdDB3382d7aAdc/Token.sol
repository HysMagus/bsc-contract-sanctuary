// Submitted for verification at BscScan.com on 2021-10-01

/*
The Artzeex Ecosystem is a project focused on revolutionizing the art world by adding value to the world of NFT's 
and the metaverse. For more information visit the link bellow:
https://artzeex.com/

200,000,000 Total Supply

Name: Artzeex
Symbol: ZEEX
Decimals: 6
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

import "./BEP20Token.sol";

contract Zeex is BEP20Token {

  struct Wallet {
    address holders;
    address operation;
    address growth;
    address fundation;
  }
  Wallet internal _wallet; 

  struct FeeSplit {
    uint8 holders;
    uint8 operation;
    uint8 growth;
    uint8 fundation; 
  }
  FeeSplit internal _feeSplit;

  struct Lock {
    uint256 amount;
    uint256 start;
    uint256 end;
  }

  mapping (address => Lock) internal _locks;
  mapping (address => bool) internal _noFee;
  mapping (address => uint8) internal _customFee;

  uint8 internal _standartFee = 2;

  event setLockEvent(address indexed wallet, uint256 amount, uint256 start, uint256 end);
  
  constructor() {
    _name = "Artzeex";
    _symbol = "ZEEX";
    _decimals = 6;
    _totalSupply = 200000000 * 10 ** 6;
    _balances[msg.sender] = _totalSupply;

    _wallet.holders   = 0xD73818D26d12dDa5eB449F419bF565700e0B5e01;
    _wallet.operation = 0x72D226c98538815b5Eaf14B79D98F12C5051AF5d;
    _wallet.growth    = 0x45A0b7eB0d29bE41f48fA76d6DE12EA890eA36F7;
    _wallet.fundation = 0x0d4a003C1f98E736814a96b76804c74311994b08;   

    _feeSplit.holders   = 35;
    _feeSplit.operation = 25;
    _feeSplit.growth    = 25;
    _feeSplit.fundation = 15;

    _noFee[msg.sender]        = true;
    _noFee[_wallet.holders]   = true;
    _noFee[_wallet.operation] = true;
    _noFee[_wallet.growth]    = true;
    _noFee[_wallet.fundation] = true;

    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  /**
   * @dev set wallets.
   */
  function setWallet(address holders, address operation, address growth, address fundation) external onlyOwner {
    _wallet.holders   = holders;
    _wallet.operation = operation;
    _wallet.growth    = growth;
    _wallet.fundation = fundation;
  }

  /**
   * @dev returns the addresses of the wallets receiving fees.
   */
  function getWallet() external view returns (address, address, address, address)  {
    return (_wallet.holders, _wallet.operation, _wallet.growth, _wallet.fundation);
  }

  /**
   * @dev sets the default fee for all address
   */
  function setStandartFee(uint8 fee) external onlyOwner {
    _standartFee = fee;
  }

  /**
   * @dev returns the default fee.
   */
  function getStandartFee() external view returns (uint8)  {
    return (_standartFee);
  }

  /**
   * @dev sets a custom fee for a specific address.
   */
  function setCustomFee(address wallet, uint8 fee) external onlyOwner {
    _customFee[wallet] = fee;
  }

  /**
   * @dev return the custom address fee.
   */
  function getCustomFee(address wallet) external view returns (uint8)  {
    return (_customFee[wallet]);
  }

  /**
   * @dev sets the percentages of fee sharing in the wallets.
   */
  function setFeeSplit(uint8 holders, uint8 operation, uint8 growth, uint8 fundation) external onlyOwner {
    require(holders + operation + growth + fundation == 100, "BEP20: split sum has to be 100.");
    _feeSplit.holders   = holders;
    _feeSplit.operation = operation;
    _feeSplit.growth    = growth;
    _feeSplit.fundation = fundation;
  }

  /**
   * @dev returns fee split setting.
   */
  function getFeeSplit() external view returns (uint8, uint8, uint8, uint8)  {
    return (_feeSplit.holders, _feeSplit.operation, _feeSplit.growth, _feeSplit.fundation);
  }

  /**
   * @dev set address without transaction fee implications (true) or with fee (false).
   */
  function setNoFee(address wallet, bool noFee) external onlyOwner {
    _noFee[wallet] = noFee;
  }

  /**
   * @dev returns fee status of an address
   */
  function getNoFee(address wallet) external view returns (bool)  {
    return (_noFee[wallet]);
  }

   /**
   * @dev set lock in a address.
   */
  function setLock(address wallet, uint256 amount, uint256 start, uint256 end) external onlyOwner {
    _locks[wallet].amount = amount;
    _locks[wallet].end    = end;
    _locks[wallet].start  = start;
    emit setLockEvent( wallet, amount, start, end);
  }

  /**
   * @dev Returns the lock info of a address.
   */
  function getLockInfo(address wallet) external view returns (uint256, uint256, uint256) {
    uint256 amount = _locks[wallet].amount;
    uint256 start = _locks[wallet].start;
    uint256 end = _locks[wallet].end;

    return (amount, start, end);
  }
  
   /**
   * @dev token-specific transfer function - considers locked tokens and transaction fee
   */
  function _transfer(address sender, address recipient, uint256 amount) internal override {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");
  
    if (block.timestamp > _locks[sender].end) {
      _locks[sender].amount = 0;
      _locks[sender].start  = 0;
      _locks[sender].end    = 0;
    }
    uint256 balance     = _balances[sender];
    uint256 balanceLock = _locks[sender].amount;
    uint256 balanceFree = balance - balanceLock;
    require(balanceFree >= amount, "BEP20: transfer amount exceeds balance free");
    
    uint256 amountFree = amount;
    if (_noFee[sender] == false) {

      uint8 _realFee = _standartFee;
      if (_customFee[sender] > 0) {
        _realFee = _customFee[sender];
      }

      uint256 _feeAmount = (amount * _realFee * 100) / 10000;

      uint256 amountHolders   = (_feeAmount * _feeSplit.holders   * 100) / 10000;
      uint256 amountOperation = (_feeAmount * _feeSplit.operation * 100) / 10000;
      uint256 amountGrowth    = (_feeAmount * _feeSplit.growth    * 100) / 10000;
      uint256 amountFundation = (_feeAmount * _feeSplit.fundation * 100) / 10000;

      amountFree = amount - amountHolders - amountOperation - amountGrowth - amountFundation;
      _balances[_wallet.holders]   += amountHolders;
      _balances[_wallet.operation] += amountOperation;
      _balances[_wallet.growth]    += amountGrowth;
      _balances[_wallet.fundation] += amountFundation;
    }

    _balances[sender] -= amount;
    _balances[recipient] += amountFree;
    emit Transfer(sender, recipient, amountFree);
  }

}