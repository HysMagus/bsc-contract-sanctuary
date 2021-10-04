// SPDX-License-Identifier: UNLICENSED
/*

██╗███╗░░██╗██████╗░███████╗██╗░░██╗  ░█████╗░░█████╗░░█████╗░██████╗░
██║████╗░██║██╔══██╗██╔════╝╚██╗██╔╝  ██╔══██╗██╔══██╗██╔══██╗██╔══██╗
██║██╔██╗██║██║░░██║█████╗░░░╚███╔╝░  ██║░░╚═╝██║░░██║██║░░██║██████╔╝
██║██║╚████║██║░░██║██╔══╝░░░██╔██╗░  ██║░░██╗██║░░██║██║░░██║██╔═══╝░
██║██║░╚███║██████╔╝███████╗██╔╝╚██╗  ╚█████╔╝╚█████╔╝╚█████╔╝██║░░░░░
╚═╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═╝░░╚═╝  ░╚════╝░░╚════╝░░╚════╝░╚═╝░░░░░

🔶The Index Coop🔶 is a community-led initiative focused on making crypto investing simple, accessible,
and safe 🦉 $DPI $FLI $MVI $BED $DATA $INDEX
a Decentralized and Autonomous Asset Manager governed
maintained, and upgraded by INDEX token holders.

🔱 Supply = 50,000,000,000,000
🔥 50%  BURN 50,000,000,000,000
🎁-3% back to holders
🤝‍-1% back to Ecosystem Development
💧-3% back to LP Liquidity for a healthy pool
😸-4% to Marketing Charity .
🤝-2% Buyback
✅ Audit Done & Passed 💯 Link to be post shortly
🔐 Locked LP for 25 years Link to be post shortly

🚀 Telegram https://t.me/IndexCoopBSC
*/
pragma solidity ^0.8.4;

interface IBEP20 {
  // @dev Returns the amount of tokens in existence.
  function totalSupply() external view returns (uint256);

  // @dev Returns the token decimals.
  function decimals() external view returns (uint8);

  // @dev Returns the token symbol.
  function symbol() external view returns (string memory);

  //@dev Returns the token name.
  function name() external view returns (string memory);

  //@dev Returns the bep token owner.
  function getOwner() external view returns (address);

  //@dev Returns the amount of tokens owned by `account`.
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
  function allowance(address _owner, address spender) external view returns (uint256);

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

  //@dev Emitted when `value` tokens are moved from one account (`from`) to  another (`to`). Note that `value` may be zero.
  event Transfer(address indexed from, address indexed to, uint256 value);

  //@dev Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}. `value` is the new allowance.
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
