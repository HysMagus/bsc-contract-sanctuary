// SPDX-License-Identifier: MIT

/*
/⃨*⃨
M⃨I⃨T⃨ L⃨i⃨c⃨e⃨n⃨s⃨e⃨
P⃨e⃨r⃨m⃨i⃨s⃨s⃨i⃨o⃨n⃨ i⃨s⃨ h⃨e⃨r⃨e⃨b⃨y⃨ g⃨r⃨a⃨n⃨t⃨e⃨d⃨,⃨ f⃨r⃨e⃨e⃨ o⃨f⃨ c⃨h⃨a⃨r⃨g⃨e⃨,⃨ t⃨o⃨ a⃨n⃨y⃨ p⃨e⃨r⃨s⃨o⃨n⃨ o⃨b⃨t⃨a⃨i⃨n⃨i⃨n⃨g⃨ a⃨ c⃨o⃨p⃨y⃨
o⃨f⃨ t⃨h⃨i⃨s⃨ s⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨ a⃨n⃨d⃨ a⃨s⃨s⃨o⃨c⃨i⃨a⃨t⃨e⃨d⃨ d⃨o⃨c⃨u⃨m⃨e⃨n⃨t⃨a⃨t⃨i⃨o⃨n⃨ f⃨i⃨l⃨e⃨s⃨ (⃨t⃨h⃨e⃨ "⃨S⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨"⃨)⃨,⃨ t⃨o⃨ d⃨e⃨a⃨l⃨
i⃨n⃨ t⃨h⃨e⃨ S⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨ w⃨i⃨t⃨h⃨o⃨u⃨t⃨ r⃨e⃨s⃨t⃨r⃨i⃨c⃨t⃨i⃨o⃨n⃨,⃨ i⃨n⃨c⃨l⃨u⃨d⃨i⃨n⃨g⃨ w⃨i⃨t⃨h⃨o⃨u⃨t⃨ l⃨i⃨m⃨i⃨t⃨a⃨t⃨i⃨o⃨n⃨ t⃨h⃨e⃨ r⃨i⃨g⃨h⃨t⃨s⃨
t⃨o⃨ u⃨s⃨e⃨,⃨ c⃨o⃨p⃨y⃨,⃨ m⃨o⃨d⃨i⃨f⃨y⃨,⃨ m⃨e⃨r⃨g⃨e⃨,⃨ p⃨u⃨b⃨l⃨i⃨s⃨h⃨,⃨ d⃨i⃨s⃨t⃨r⃨i⃨b⃨u⃨t⃨e⃨,⃨ s⃨u⃨b⃨l⃨i⃨c⃨e⃨n⃨s⃨e⃨,⃨ a⃨n⃨d⃨/⃨o⃨r⃨ s⃨e⃨l⃨l⃨
c⃨o⃨p⃨i⃨e⃨s⃨ o⃨f⃨ t⃨h⃨e⃨ S⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨,⃨ a⃨n⃨d⃨ t⃨o⃨ p⃨e⃨r⃨m⃨i⃨t⃨ p⃨e⃨r⃨s⃨o⃨n⃨s⃨ t⃨o⃨ w⃨h⃨o⃨m⃨ t⃨h⃨e⃨ S⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨ i⃨s⃨
f⃨u⃨r⃨n⃨i⃨s⃨h⃨e⃨d⃨ t⃨o⃨ d⃨o⃨ s⃨o⃨,⃨ s⃨u⃨b⃨j⃨e⃨c⃨t⃨ t⃨o⃨ t⃨h⃨e⃨ f⃨o⃨l⃨l⃨o⃨w⃨i⃨n⃨g⃨ c⃨o⃨n⃨d⃨i⃨t⃨i⃨o⃨n⃨s⃨:⃨

T⃨h⃨e⃨ a⃨b⃨o⃨v⃨e⃨ c⃨o⃨p⃨y⃨r⃨i⃨g⃨h⃨t⃨ n⃨o⃨t⃨i⃨c⃨e⃨ a⃨n⃨d⃨ t⃨h⃨i⃨s⃨ p⃨e⃨r⃨m⃨i⃨s⃨s⃨i⃨o⃨n⃨ n⃨o⃨t⃨i⃨c⃨e⃨ s⃨h⃨a⃨l⃨l⃨ b⃨e⃨ i⃨n⃨c⃨l⃨u⃨d⃨e⃨d⃨ i⃨n⃨ a⃨l⃨l⃨
c⃨o⃨p⃨i⃨e⃨s⃨ o⃨r⃨ s⃨u⃨b⃨s⃨t⃨a⃨n⃨t⃨i⃨a⃨l⃨ p⃨o⃨r⃨t⃨i⃨o⃨n⃨s⃨ o⃨f⃨ t⃨h⃨e⃨ S⃨o⃨f⃨t⃨w⃨a⃨r⃨e⃨.⃨

T⃨H⃨E⃨ S⃨O⃨F⃨T⃨W⃨A⃨R⃨E⃨ I⃨S⃨ P⃨R⃨O⃨V⃨I⃨D⃨E⃨D⃨ "⃨A⃨S⃨ I⃨S⃨"⃨,⃨ W⃨I⃨T⃨H⃨O⃨U⃨T⃨ W⃨A⃨R⃨R⃨A⃨N⃨T⃨Y⃨ O⃨F⃨ A⃨N⃨Y⃨ K⃨I⃨N⃨D⃨,⃨ E⃨X⃨P⃨R⃨E⃨S⃨S⃨ O⃨R⃨
I⃨M⃨P⃨L⃨I⃨E⃨D⃨,⃨ I⃨N⃨C⃨L⃨U⃨D⃨I⃨N⃨G⃨ B⃨U⃨T⃨ N⃨O⃨T⃨ L⃨I⃨M⃨I⃨T⃨E⃨D⃨ T⃨O⃨ T⃨H⃨E⃨ W⃨A⃨R⃨R⃨A⃨N⃨T⃨I⃨E⃨S⃨ O⃨F⃨ M⃨E⃨R⃨C⃨H⃨A⃨N⃨T⃨A⃨B⃨I⃨L⃨I⃨T⃨Y⃨,⃨
F⃨I⃨T⃨N⃨E⃨S⃨S⃨ F⃨O⃨R⃨ A⃨ P⃨A⃨R⃨T⃨I⃨C⃨U⃨L⃨A⃨R⃨ P⃨U⃨R⃨P⃨O⃨S⃨E⃨ A⃨N⃨D⃨ N⃨O⃨N⃨I⃨N⃨F⃨R⃨I⃨N⃨G⃨E⃨M⃨E⃨N⃨T⃨.⃨ I⃨N⃨ N⃨O⃨ E⃨V⃨E⃨N⃨T⃨ S⃨H⃨A⃨L⃨L⃨ T⃨H⃨E⃨
A⃨U⃨T⃨H⃨O⃨R⃨S⃨ O⃨R⃨ C⃨O⃨P⃨Y⃨R⃨I⃨G⃨H⃨T⃨ H⃨O⃨L⃨D⃨E⃨R⃨S⃨ B⃨E⃨ L⃨I⃨A⃨B⃨L⃨E⃨ F⃨O⃨R⃨ A⃨N⃨Y⃨ C⃨L⃨A⃨I⃨M⃨,⃨ D⃨A⃨M⃨A⃨G⃨E⃨S⃨ O⃨R⃨ O⃨T⃨H⃨E⃨R⃨
L⃨I⃨A⃨B⃨I⃨L⃨I⃨T⃨Y⃨,⃨ W⃨H⃨E⃨T⃨H⃨E⃨R⃨ I⃨N⃨ A⃨N⃨ A⃨C⃨T⃨I⃨O⃨N⃨ O⃨F⃨ C⃨O⃨N⃨T⃨R⃨A⃨C⃨T⃨,⃨ T⃨O⃨R⃨T⃨ O⃨R⃨ O⃨T⃨H⃨E⃨R⃨W⃨I⃨S⃨E⃨,⃨ A⃨R⃨I⃨S⃨I⃨N⃨G⃨ F⃨R⃨O⃨M⃨,⃨
O⃨U⃨T⃨ O⃨F⃨ O⃨R⃨ I⃨N⃨ C⃨O⃨N⃨N⃨E⃨C⃨T⃨I⃨O⃨N⃨ W⃨I⃨T⃨H⃨ T⃨H⃨E⃨ S⃨O⃨F⃨T⃨W⃨A⃨R⃨E⃨ O⃨R⃨ T⃨H⃨E⃨ U⃨S⃨E⃨ O⃨R⃨ O⃨T⃨H⃨E⃨R⃨ D⃨E⃨A⃨L⃨I⃨N⃨G⃨S⃨ I⃨N⃨ T⃨H⃨E⃨
S⃨O⃨F⃨T⃨W⃨A⃨R⃨E⃨.⃨
*⃨/⃨.⃨
*⃨/⃨
*/


/*
𝙼𝙸𝚃 𝙻𝚒𝚌𝚎𝚗𝚜𝚎
𝙿𝚎𝚛𝚖𝚒𝚜𝚜𝚒𝚘𝚗 𝚒𝚜 𝚑𝚎𝚛𝚎𝚋𝚢 𝚐𝚛𝚊𝚗𝚝𝚎𝚍, 𝚏𝚛𝚎𝚎 𝚘𝚏 𝚌𝚑𝚊𝚛𝚐𝚎, 𝚝𝚘 𝚊𝚗𝚢 𝚙𝚎𝚛𝚜𝚘𝚗 𝚘𝚋𝚝𝚊𝚒𝚗𝚒𝚗𝚐 𝚊 𝚌𝚘𝚙𝚢
𝚘𝚏 𝚝𝚑𝚒𝚜 𝚜𝚘𝚏𝚝𝚠𝚊𝚛𝚎 𝚊𝚗𝚍 𝚊𝚜𝚜𝚘𝚌𝚒𝚊𝚝𝚎𝚍 𝚍𝚘𝚌𝚞𝚖𝚎𝚗𝚝𝚊𝚝𝚒𝚘𝚗 𝚏𝚒𝚕𝚎𝚜 (𝚝𝚑𝚎 "𝚂𝚘𝚏𝚝𝚠𝚊𝚛𝚎"), 𝚝𝚘 𝚍𝚎𝚊𝚕
𝚒𝚗 𝚝𝚑𝚎 𝚂𝚘𝚏𝚝𝚠𝚊𝚛𝚎 𝚠𝚒𝚝𝚑𝚘𝚞𝚝 𝚛𝚎𝚜𝚝𝚛𝚒𝚌𝚝𝚒𝚘𝚗, 𝚒𝚗𝚌𝚕𝚞𝚍𝚒𝚗𝚐 𝚠𝚒𝚝𝚑𝚘𝚞𝚝 𝚕𝚒𝚖𝚒𝚝𝚊𝚝𝚒𝚘𝚗 𝚝𝚑𝚎 𝚛𝚒𝚐𝚑𝚝𝚜
𝚝𝚘 𝚞𝚜𝚎, 𝚌𝚘𝚙𝚢, 𝚖𝚘𝚍𝚒𝚏𝚢, 𝚖𝚎𝚛𝚐𝚎, 𝚙𝚞𝚋𝚕𝚒𝚜𝚑, 𝚍𝚒𝚜𝚝𝚛𝚒𝚋𝚞𝚝𝚎, 𝚜𝚞𝚋𝚕𝚒𝚌𝚎𝚗𝚜𝚎, 𝚊𝚗𝚍/𝚘𝚛 𝚜𝚎𝚕𝚕
𝚌𝚘𝚙𝚒𝚎𝚜 𝚘𝚏 𝚝𝚑𝚎 𝚂𝚘𝚏𝚝𝚠𝚊𝚛𝚎, 𝚊𝚗𝚍 𝚝𝚘 𝚙𝚎𝚛𝚖𝚒𝚝 𝚙𝚎𝚛𝚜𝚘𝚗𝚜 𝚝𝚘 𝚠𝚑𝚘𝚖 𝚝𝚑𝚎 𝚂𝚘𝚏𝚝𝚠𝚊𝚛𝚎 𝚒𝚜
𝚏𝚞𝚛𝚗𝚒𝚜𝚑𝚎𝚍 𝚝𝚘 𝚍𝚘 𝚜𝚘, 𝚜𝚞𝚋𝚓𝚎𝚌𝚝 𝚝𝚘 𝚝𝚑𝚎 𝚏𝚘𝚕𝚕𝚘𝚠𝚒𝚗𝚐 𝚌𝚘𝚗𝚍𝚒𝚝𝚒𝚘𝚗𝚜:

𝚃𝚑𝚎 𝚊𝚋𝚘𝚟𝚎 𝚌𝚘𝚙𝚢𝚛𝚒𝚐𝚑𝚝 𝚗𝚘𝚝𝚒𝚌𝚎 𝚊𝚗𝚍 𝚝𝚑𝚒𝚜 𝚙𝚎𝚛𝚖𝚒𝚜𝚜𝚒𝚘𝚗 𝚗𝚘𝚝𝚒𝚌𝚎 𝚜𝚑𝚊𝚕𝚕 𝚋𝚎 𝚒𝚗𝚌𝚕𝚞𝚍𝚎𝚍 𝚒𝚗 𝚊𝚕𝚕
𝚌𝚘𝚙𝚒𝚎𝚜 𝚘𝚛 𝚜𝚞𝚋𝚜𝚝𝚊𝚗𝚝𝚒𝚊𝚕 𝚙𝚘𝚛𝚝𝚒𝚘𝚗𝚜 𝚘𝚏 𝚝𝚑𝚎 𝚂𝚘𝚏𝚝𝚠𝚊𝚛𝚎.

𝚃𝙷𝙴 𝚂𝙾𝙵𝚃𝚆𝙰𝚁𝙴 𝙸𝚂 𝙿𝚁𝙾𝚅𝙸𝙳𝙴𝙳 "𝙰𝚂 𝙸𝚂", 𝚆𝙸𝚃𝙷𝙾𝚄𝚃 𝚆𝙰𝚁𝚁𝙰𝙽𝚃𝚈 𝙾𝙵 𝙰𝙽𝚈 𝙺𝙸𝙽𝙳, 𝙴𝚇𝙿𝚁𝙴𝚂𝚂 𝙾𝚁
𝙸𝙼𝙿𝙻𝙸𝙴𝙳, 𝙸𝙽𝙲𝙻𝚄𝙳𝙸𝙽𝙶 𝙱𝚄𝚃 𝙽𝙾𝚃 𝙻𝙸𝙼𝙸𝚃𝙴𝙳 𝚃𝙾 𝚃𝙷𝙴 𝚆𝙰𝚁𝚁𝙰𝙽𝚃𝙸𝙴𝚂 𝙾𝙵 𝙼𝙴𝚁𝙲𝙷𝙰𝙽𝚃𝙰𝙱𝙸𝙻𝙸𝚃𝚈,
𝙵𝙸𝚃𝙽𝙴𝚂𝚂 𝙵𝙾𝚁 𝙰 𝙿𝙰𝚁𝚃𝙸𝙲𝚄𝙻𝙰𝚁 𝙿𝚄𝚁𝙿𝙾𝚂𝙴 𝙰𝙽𝙳 𝙽𝙾𝙽𝙸𝙽𝙵𝚁𝙸𝙽𝙶𝙴𝙼𝙴𝙽𝚃. 𝙸𝙽 𝙽𝙾 𝙴𝚅𝙴𝙽𝚃 𝚂𝙷𝙰𝙻𝙻 𝚃𝙷𝙴
𝙰𝚄𝚃𝙷𝙾𝚁𝚂 𝙾𝚁 𝙲𝙾𝙿𝚈𝚁𝙸𝙶𝙷𝚃 𝙷𝙾𝙻𝙳𝙴𝚁𝚂 𝙱𝙴 𝙻𝙸𝙰𝙱𝙻𝙴 𝙵𝙾𝚁 𝙰𝙽𝚈 𝙲𝙻𝙰𝙸𝙼, 𝙳𝙰𝙼𝙰𝙶𝙴𝚂 𝙾𝚁 𝙾𝚃𝙷𝙴𝚁
𝙻𝙸𝙰𝙱𝙸𝙻𝙸𝚃𝚈, 𝚆𝙷𝙴𝚃𝙷𝙴𝚁 𝙸𝙽 𝙰𝙽 𝙰𝙲𝚃𝙸𝙾𝙽 𝙾𝙵 𝙲𝙾𝙽𝚃𝚁𝙰𝙲𝚃, 𝚃𝙾𝚁𝚃 𝙾𝚁 𝙾𝚃𝙷𝙴𝚁𝚆𝙸𝚂𝙴, 𝙰𝚁𝙸𝚂𝙸𝙽𝙶 𝙵𝚁𝙾𝙼,
𝙾𝚄𝚃 𝙾𝙵 𝙾𝚁 𝙸𝙽 𝙲𝙾𝙽𝙽𝙴𝙲𝚃𝙸𝙾𝙽 𝚆𝙸𝚃𝙷 𝚃𝙷𝙴 𝚂𝙾𝙵𝚃𝚆𝙰𝚁𝙴 𝙾𝚁 𝚃𝙷𝙴 𝚄𝚂𝙴 𝙾𝚁 𝙾𝚃𝙷𝙴𝚁 𝙳𝙴𝙰𝙻𝙸𝙽𝙶𝚂 𝙸𝙽 𝚃𝙷𝙴
𝚂𝙾𝙵𝚃𝚆𝙰𝚁𝙴.
*/

/*
MIT License



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
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


contract Songbird is IBEP20 {
  
    // common addresses
    address private owner;
    address private developmentPot;
    address private foundersPot;
    address private Rebase;
    
    // token liquidity metadata
    uint public override totalSupply;
    uint8 public override decimals = 18;
    
    mapping(address => uint) public balances;
    
    mapping(address => mapping(address => uint)) public allowances;
    
    // token title metadata
    string public override name = "Songbird";
    string public override symbol = "SGB";
    
    // EVENTS
    // (now in interface) event Transfer(address indexed from, address indexed to, uint value);
    // (now in interface) event Approval(address indexed owner, address indexed spender, uint value);
    
    // On init of contract we're going to set the admin and give them all tokens.
    constructor(uint totalSupplyValue, address developmentAddress, address foundersAddress, address RebaseAddress) {
        // set total supply
        totalSupply = totalSupplyValue;
        
        // designate addresses
        owner = msg.sender;
        developmentPot = developmentAddress;
        foundersPot = foundersAddress;
        Rebase = RebaseAddress;
        
        // split the tokens according to agreed upon percentages
        balances[developmentPot] =  totalSupply * 5 / 100;
        balances[foundersPot] = totalSupply * 38 / 100;
        balances[Rebase] = totalSupply * 5 / 100;
        
        balances[owner] = totalSupply * 52 / 100;
    }
    
    // Get the address of the token's owner
    function getOwner() public view override returns(address) {
        return owner;
    }

    
    // Get the balance of an account
    function balanceOf(address account) public view override returns(uint) {
        return balances[account];
    }
    
    // Transfer balance from one user to another
    function transfer(address to, uint value) public override returns(bool) {
        require(value > 0, "Transfer value has to be higher than 0.");
        require(balanceOf(msg.sender) >= value, "Balance is too low to make transfer.");
        
        //withdraw the taxed and burned percentages from the total value
        uint taxTBD = value * 3 / 100;
        uint burnTBD = value * 1 / 100;
        uint valueAfterTaxAndBurn = value - taxTBD - burnTBD;
        
        // perform the transfer operation
        balances[to] += valueAfterTaxAndBurn;
        balances[msg.sender] -= value;
        
        emit Transfer(msg.sender, to, value);
        
        // finally, we burn and tax the extras percentage
        balances[owner] += taxTBD + burnTBD;
        _burn(owner, burnTBD);
        
        return true;
    }
    
    // approve a specific address as a spender for your account, with a specific spending limit
    function approve(address spender, uint value) public override returns(bool) {
        allowances[msg.sender][spender] = value; 
        
        emit Approval(msg.sender, spender, value);
        
        return true;
    }
    
    // allowance
    function allowance(address _owner, address spender) public view override returns(uint) {
        return allowances[_owner][spender];
    }
    
    // an approved spender can transfer currency from one account to another up to their spending limit
    function transferFrom(address from, address to, uint value) public override returns(bool) {
        require(allowances[from][msg.sender] > 0, "No Allowance for this address.");
        require(allowances[from][msg.sender] >= value, "Allowance too low for transfer.");
        require(balances[from] >= value, "Balance is too low to make transfer.");
        
        balances[to] += value;
        balances[from] -= value;
        
        emit Transfer(from, to, value);
        
        return true;
    }
    
    // function to allow users to burn currency from their account
    function burn(uint256 amount) public returns(bool) {
        _burn(msg.sender, amount);
        
        return true;
    }
    
    // intenal functions
    
    // burn amount of currency from specific account
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "You can't burn from zero address.");
        require(balances[account] >= amount, "Burn amount exceeds balance at address.");
    
        balances[account] -= amount;
        totalSupply -= amount;
        
        emit Transfer(account, address(0), amount);
    }
    
}