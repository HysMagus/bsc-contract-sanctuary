//"SPDX-License-Identifier: MIT"
pragma solidity ^0.7.5;
pragma abicoder v2;

//import "./openzeppelinERC20ITF.sol";
//import "./signedSafeMath.sol";
//import "hardhat/console.sol";
//version 1.4
// includes Openzeppelin 3.3.0 contracts:
// ... Context -> Ownable
// ... SafeMath, Address, SafeERC20
// ... IERC20, ERC20(aka ERC20Detailed),
//import "hardhat/console.sol";

// File: @openzeppelin/contracts/GSN/Context.sol
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    // function _msgData() internal view virtual returns (bytes memory) {
    //     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    //     return msg.data;
    // }
}

// File: @openzeppelin/contracts/access/Ownable.sol
//import "../GSN/Context.sol";
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @openzeppelin/contracts/math/SafeMath.sol
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    // function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    //     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    //     // benefit is lost if 'b' is also tested.
    //     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    //     if (a == 0) {
    //         return 0;
    //     }

    //     uint256 c = a * b;
    //     require(c / a == b, "SafeMath: multiplication overflow");

    //     return c;
    // }

    // function div(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return div(a, b, "SafeMath: division by zero");
    // }

    // function div(
    //     uint256 a,
    //     uint256 b,
    //     string memory errorMessage
    // ) internal pure returns (uint256) {
    //     require(b > 0, errorMessage);
    //     uint256 c = a / b;
    //     // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    //     return c;
    // }

    // function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return mod(a, b, "SafeMath: modulo by zero");
    // }

    // function mod(
    //     uint256 a,
    //     uint256 b,
    //     string memory errorMessage
    // ) internal pure returns (uint256) {
    //     require(b != 0, errorMessage);
    //     return a % b;
    // }
}


// File: @openzeppelin/contracts/utils/Address.sol
//pragma solidity >=0.6.2 <0.8.0;

library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */

    // function sendValue(address payable recipient, uint256 amount) internal {
    //     require(
    //         address(this).balance >= amount,
    //         "Address: insufficient balance"
    //     );

    //     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
    //     (bool success, ) = recipient.call{value: amount}("");
    //     require(
    //         success,
    //         "Address: unable to send value, recipient may have reverted"
    //     );
    // }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    // function functionCall(address target, bytes memory data)
    //     internal
    //     returns (bytes memory)
    // {
    //     return functionCall(target, data, "Address: low-level call failed");
    // }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) =
            target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

// functionStaticCall x2

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
// pragma solidity >=0.6.0 <0.8.0;
// import "./IERC20.sol";
// import "../../math/SafeMath.sol";
// import "../../utils/Address.sol";

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    // function safeIncreaseAllowance(
    //     IERC20 token,
    //     address spender,
    //     uint256 value
    // ) internal {
    //     uint256 newAllowance =
    //         token.allowance(address(this), spender).add(value);
    //     _callOptionalReturn(
    //         token,
    //         abi.encodeWithSelector(
    //             token.approve.selector,
    //             spender,
    //             newAllowance
    //         )
    //     );
    // }

    // function safeDecreaseAllowance(
    //     IERC20 token,
    //     address spender,
    //     uint256 value
    // ) internal {
    //     uint256 newAllowance =
    //         token.allowance(address(this), spender).sub(
    //             value,
    //             "SafeERC20: decreased allowance below zero"
    //         );
    //     _callOptionalReturn(
    //         token,
    //         abi.encodeWithSelector(
    //             token.approve.selector,
    //             spender,
    //             newAllowance
    //         )
    //     );
    // }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata =
            address(token).functionCall(
                data,
                "SafeERC20: low-level call failed"
            );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}


//-------------------------==
interface IPriceBetting {
    struct Bet {
        address addr;
        uint256 betAt; //time this bet was recorded
        uint256 amount; //amount of betting
        uint256 period; //in seconds
        uint256 priceAtBet;
        uint256 bettingOutcome;
        uint256 fundingSource;
        uint256 settledAt;
        uint256 settledPrice;
        int256 revenue;
    }
    function betsP2(uint256 idx) external view returns (Bet memory bet);
    
    function betsP1(uint256 idx) external view returns (Bet memory bet);
}

//openzeppelin 3.3
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

abstract contract Administration is Ownable {
    address private admin;
    event AccountTransferred(
        address indexed previousAccount,
        address indexed newAccount
    );

    constructor() {
        admin = _msgSender();
    }

    modifier onlyAdmin() {
        require(_msgSender() == admin, "Caller is not admin");
        _;
    }

    function isOnlyAdmin() public view returns (bool) {
        return _msgSender() == admin;
    }

    function transferAdmin(address newAdmin) external onlyOwner {
        require(newAdmin != address(0), "cannot be zero address");
        emit AccountTransferred(admin, newAdmin);
        admin = newAdmin;
    }
}

contract PriceBettingUserRecord is Administration {
    using SafeMath for uint256;
    using Math for uint256;
    using Address for address;

    mapping(address => Account) public accounts;
    //accounts[user]
    struct Account {
        uint256 cidxP2;
        uint256 cidxP1;
        uint256 uidxP2;
        uint256 uidxP1;
        mapping (uint256 => uint256) idxesAP2;
        mapping (uint256 => uint256) idxesAP1;
        mapping (uint256 => uint256) idxesBP2;
        mapping (uint256 => uint256) idxesBP1;
    }
    uint256 public period1 = 300;
    uint256 public period2 = 1800;
    address public addrPriceBetting;
    uint256 public maxOutLen = 50;

    constructor() {
        addrPriceBetting = address(0x9121e7445B4cCD88EF4B509Df17dB029128EbbA0);
    }
    modifier onlyContract() {
      require(msg.sender == addrPriceBetting, "not authorized contract");
        _;
    }

    function getAccountCCUU(address user) external view returns (uint256, uint256, uint256, uint256) {
      Account storage account = accounts[user];
      return (account.cidxP2, account.cidxP1, account.uidxP2, account.uidxP1);
    }

    function getAccountCU(address user, uint256 period) public view returns (uint256 cidx, uint256 uidx) {
      Account storage account = accounts[user];
      if (period == period2) {
        cidx = account.cidxP2;
        uidx = account.uidxP2;
      } else if (period == period1) {
        cidx = account.cidxP1;
        uidx = account.uidxP1;
      }
    }
    //--------------------== onlyAdmin settings
    function setSettings(uint256 option, address addr, uint256 uintNum) external onlyAdmin {
      if(option == 101){
        period1 = uintNum;
      } else if(option == 102){
        period2 = uintNum;

      } else if(option == 121){
        require(uintNum > 0, "cannot be zero length");
        maxOutLen = uintNum;

      } else if(option == 122){
        addrPriceBetting = addr;
      }
    }

    //--------------------== Public functions

/**
when someone enters a new bet, PriceBetting contract will tell BetRecord contract to save this user's new bet index, put those indexes into a mapping (1 -> index1, 2 -> index2, etc... )
*/
    function addBet(address user, uint256 period, uint256 idx) external onlyContract {
      Account storage account = accounts[user];
      uint256 cidxNew;
      if (period == period2) {
        cidxNew = account.cidxP2 + 1;
        accounts[user].cidxP2 = cidxNew;
        accounts[user].idxesAP2[cidxNew] = idx;
        accounts[user].idxesBP2[idx] = cidxNew;

      } else if (period == period1) {
        cidxNew = account.cidxP1 + 1;
        accounts[user].cidxP1 = cidxNew;
        accounts[user].idxesAP1[cidxNew] = idx;
        accounts[user].idxesBP1[idx] = cidxNew;
      }
      //console.log("[sc] addbet. idx:", idx, ", cidxNew:", cidxNew);
    }
/**
    struct Account {
        uint256 cidxP2;
        uint256 cidxP1;
        uint256 uidxP2;
        uint256 uidxP1;
        mapping (uint256 => uint256) idxesAP2;
        mapping (uint256 => uint256) idxesAP1;
        mapping (uint256 => uint256) idxesBP2;
        mapping (uint256 => uint256) idxesBP1;
    }

when a bet is cleared, then the same thing will happen, but just to update this bet
*/
    function updateBet(address user, uint256 period, uint256 idx) external onlyContract {
      Account storage account = accounts[user];
      uint256 idxB;
      if (period == period2) {
        idxB = account.idxesBP2[idx];
        accounts[user].uidxP2 = idxB;

      } else if (period == period1) {
        idxB = account.idxesBP1[idx];
        accounts[user].uidxP1 = idxB;
      }
      //console.log("[sc] updateBet");
    }

    function getBetsCheck(address user, uint256 period, uint256 idxStart, uint256 outLength, uint256 option) public view returns (
      address userOut,
      bool[] memory bools,
      uint256[] memory uintsInputs,
      uint256[] memory pmt, bool boolOut
      )
    {// uint256[] cidx2, uint256 uidx2, uint256 idxStart2, uint256 len2
      //console.log("sc getBetsCheck1");
      userOut = user;
      pmt = new uint256[](4);

      uintsInputs = new uint256[](4);
      uintsInputs[0] = period;
      uintsInputs[1] = idxStart;
      uintsInputs[2] = outLength;
      uintsInputs[3] = option;
      
      //console.log("sc getBetsCheck2");
      bools = new bool[](5);
      bools[0] = user != address(0);
      bools[1] = period == period2 || period == period1;
      
      //console.log("sc getBetsCheck3:", bools[0], bools[1]);
      (uint256 cidx, uint256 uidx) = getAccountCU(user, period);
      //console.log("sc getBetsCheck4:", cidx, uidx);
      pmt[0] = cidx;
      pmt[1] = uidx;
      pmt[2] = idxStart;
      //console.log("sc getBetsCheck5:", pmt[0], pmt[1], pmt[2]);
      bools[2] = option < 2;
      bools[3] = outLength > 0;
      bools[4] = true;//we will auto correct idxStart and idxEnd and length!  
      //console.log("sc getBetsCheck6:", bools[2], bools[3]);
      //pmt[2]...fix both idxStart and length
      if(idxStart > cidx) {
        pmt[2] = 0;
      }
      if(option == 0 && pmt[2] == 0){
        // historical trades and idxStart == 0
        if(uidx < 21) {
          pmt[2] = 1;
        } else {
          pmt[2] = uidx - 20;
        }
      } else if(option == 1 && pmt[2] <= uidx) {
        // active trades and idxStart <= uidx
        pmt[2] = uidx + 1;
        // active uncleared bets
      } else {}
      //console.log("sc getBetsCheck pmt[2]", pmt[2]);
      //pmt[3] ... output Length;
      if(option == 0){
        //historical trades: exclude active trade
        pmt[3] = outLength.min(uidx - pmt[2] + 1);

      } else if(option == 1){
        pmt[3] = outLength.min(cidx - pmt[2] + 1);
      }
      if(pmt[3] > maxOutLen) pmt[3] = maxOutLen;
      //console.log("sc getBetsCheck pmt[3]", pmt[3]);
      boolOut = bools[0] && bools[1] && bools[2] && bools[3] && bools[4];
    }

    // userAddr -> bet indexes: cleared or not
    function getBetIndexes(address user, uint256 period, uint256 idxStart, uint256 outLength, uint256 option) public view
        returns (uint256[] memory idxesOut, uint256 cidx2, uint256 uidx2, uint256 idxStart2, uint256 idxLast2)
    {
        (, , , uint256[] memory pmt, bool boolOut) = getBetsCheck(user, period, idxStart, outLength, option);
        require(boolOut, "invalid input detected");
        cidx2 = pmt[0];
        uidx2 = pmt[1];
        idxStart2 = pmt[2];
        //len = pmt[3];
        uint256 idx;

        idxesOut = new uint256[](pmt[3]);
        idxLast2 = idxStart2 + pmt[3] - 1;
        if (period == period2) {
          for (uint i = 0; i < pmt[3]; i++) {
              idx = idxStart2 + i;
              idxesOut[i] = accounts[user].idxesAP2[idx];
          }

        } else if (period == period1) {
          for (uint i = 0; i < pmt[3]; i++) {
              idx = idxStart2 + i;
              idxesOut[i] = accounts[user].idxesAP1[idx];
          }
        }
    }

    // userAddr -> bets: cleared or not
    function getBetterBets(address user, uint256 period, uint256 idxStart, uint256 outLength, uint256 option) public view
        returns (IPriceBetting.Bet[] memory betsOut, uint256 cidx3, uint256 uidx3, uint256 idxStart3, uint256 idxLast3)
    {
      (uint256[] memory indexes, uint256 cidx2, uint256 uidx2, uint256 idxStart2, uint256 idxLast2) = getBetIndexes(user, period, idxStart, outLength, option);
      cidx3 = cidx2;
      uidx3 = uidx2;
      idxStart3 = idxStart2;
      idxLast3 = idxLast2;
      IPriceBetting PriceBetting = IPriceBetting(addrPriceBetting);

      betsOut = new IPriceBetting.Bet[](indexes.length);
      if (period == period2) {
        for (uint i = 0; i < indexes.length; i++) {
            betsOut[i] = PriceBetting.betsP2(indexes[i]);
        }

      } else if (period == period1) {
        for (uint i = 0; i < indexes.length; i++) {
            betsOut[i] = PriceBetting.betsP1(indexes[i]);
        }
      }
    }
}
/*
    struct Account {
        uint256 cidxP2;
        uint256 cidxP1;
        uint256 uidxP2;
        uint256 uidxP1;
        mapping (uint256 => uint256) idxesAP2;
        mapping (uint256 => uint256) idxesAP1;
        mapping (uint256 => uint256) idxesBP2;
        mapping (uint256 => uint256) idxesBP1;
    }

*/
/**
 * MIT License
 * ===========
 *
 * Copyright (c) 2020,2021 Aries Financial
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 */