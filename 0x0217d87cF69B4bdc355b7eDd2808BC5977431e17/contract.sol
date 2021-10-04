//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.1;

//sol800
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

//sol800
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


//sol8.0.0
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


//sol8.0.0
library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    //function sendValue(address payable recipient, uint256 amount) internal {...}
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

// functionStaticCall x2
// functionDelegateCall x2

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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

//---------------------==
//sol8.0.0
library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    // function safeApprove(IERC20 token, address spender, uint256 value) internal {
    //     require((value == 0) || (token.allowance(address(this), spender) == 0),
    //         "SafeERC20: approve from non-zero to non-zero allowance"
    //     );
    //     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    // }

    // function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
    //     uint256 newAllowance = token.allowance(address(this), spender) + value;
    //     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    // }

    // function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
    //     unchecked {
    //         uint256 oldAllowance = token.allowance(address(this), spender);
    //         require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
    //         uint256 newAllowance = oldAllowance - value;
    //         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    //     }
    // }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
/**
    function compare( string memory a, string memory b) public pure returns(bool) { return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)); 
*/


library SafeMath {
    // function add(uint256 a, uint256 b) internal pure returns (uint256) {
    //     uint256 c = a + b;
    //     require(c >= a, "SafeMath: addition overflow");

    //     return c;
    // }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
}

//------------------------==
interface IPriceBetting {
    struct Bet {
        address addr;
        uint256 betAt; //time this bet was recorded
        uint256 amount; //amount of betting
        uint256 period; //in seconds
        uint256 assetPair; //0 BTC, 1 ETH
        uint256 priceAtBet;
        uint256 bettingOutcome;
        uint256 fundingSource;
        uint256 settledAt;
        uint256 settledPrice;
        int256 result;
    }
    function betsP2(uint256 idx) external view returns (Bet memory bet);
    
    function betsP1(uint256 idx) external view returns (Bet memory bet);
    function period1() external view returns (uint256);
    function period2() external view returns (uint256);
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

contract PriceBettingUserRecord is Ownable {
    using SafeMath for uint256;
    using Math for uint256;
    using Address for address;

    address private admin;
    event AccountTransferred(
        address indexed previousAccount,
        address indexed newAccount
    );

    modifier onlyAdmin() {
        require(_msgSender() == admin, "Caller is not admin");
        _;
    }

    function isOnlyAdmin() public view returns (bool) {
        return _msgSender() == admin;
    }

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
    uint256 public period1;
    uint256 public period2;
    address public addrPriceBetting;
    uint256 public maxOutLen = 50;
    uint256 public defaultOutLen = 20;

    constructor(
      ) {
      admin = address(0xAc52301711C49394b17cA585df714307f0C588C0);
      //admin = _msgSender();

      addrPriceBetting = address(0x3d137fAaAcabC36acEc4E1D830E7d1d5cF736EDb);

      IPriceBetting PriceBetting = IPriceBetting(addrPriceBetting);
      period1 = PriceBetting.period1();
      period2 = PriceBetting.period2();
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
      } else {
        require(false, "period not found");
      }
    }
    //--------------------== onlyAdmin settings
    function setSettings(uint256 option, address addr, uint256 uintNum) external onlyAdmin {
      if(option == 101){
        require(uintNum > 0, "period must be > 0");
        period1 = uintNum;
      } else if(option == 102){
        require(uintNum > 0, "period must be > 0");
        period2 = uintNum;

      } else if(option == 109){
        require(addr != address(0), "cannot be zero address");
        emit AccountTransferred(admin, addr);
        admin = addr;

      } else if(option == 121){
        require(uintNum > 0, "uintNum must be > 0");
        maxOutLen = uintNum;
      } else if(option == 122){
        require(uintNum > 0, "defaultOutLen must be > 0");
        defaultOutLen = uintNum;
      } else if(option == 191){
        require(addrPriceBetting != address(0), "address must not be zero address");
        addrPriceBetting = addr;
      } else {
        require(false, "option not found");
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
      } else {
        require(false, "period not found");
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
      } else {
        require(false, "period not found");
      }
      //console.log("[sc] updateBet");
    }

    function getBetsCheck(address user, uint256 period, uint256 idxS, uint256 outLength, uint256 option) public view returns (
      address userOut,
      bool[] memory bools,
      uint256[] memory uintsInputs,
      uint256[] memory pmt, bool boolOut
      )
    {// uint256[] cidx2, uint256 uidx2, uint256 idxS2, uint256 len2
      //console.log("sc getBetsCheck1");
      userOut = user;
      pmt = new uint256[](4);

      uintsInputs = new uint256[](4);
      uintsInputs[0] = period;
      uintsInputs[1] = idxS;
      uintsInputs[2] = outLength;
      uintsInputs[3] = option;
      
      //console.log("sc getBetsCheck2");
      bools = new bool[](6);
      bools[0] = user != address(0);
      bools[1] = period == period2 || period == period1;
      
      //console.log("sc getBetsCheck3:", bools[0], bools[1]);
      (uint256 cidx, uint256 uidx) = getAccountCU(user, period);
      //console.log("sc getBetsCheck4:", cidx, uidx);
      pmt[0] = cidx;
      pmt[1] = uidx;
      pmt[2] = idxS;
      //console.log("sc getBetsCheck5:", pmt[0], pmt[1], pmt[2]);
      bools[2] = option < 2;// 0 historical, 1 active
      bools[3] = outLength > 0;
      //we will auto correct idxS and idxE and length!
      //console.log("sc getBetsCheck6:", bools[2], bools[3]);

      //historical trades: exclude active trade
      if(option == 0){// historical trades
        if(uidx == 0){// no historical record
          pmt[2] = 0; pmt[3] = 0;
          bools[4] = true;
        } else {
          if(idxS < 1 || idxS > uidx){
            bools[5] = false;
          }
          // if(uidx < defaultOutLen + 1) {
          // } else {
          //   pmt[2] = uidx.sub(defaultOutLen);
          // }
          pmt[3] = outLength.min(uidx.sub(pmt[2]) + 1);
        }
      } else if(option == 1) {// active trades 
        if(cidx == uidx){//no active record
          pmt[2] = 0; pmt[3] = 0;
          bools[4] = true;
        } else {
          if(idxS <= uidx || idxS > cidx){
            bools[5] = false;
          }
          pmt[3] = outLength.min(cidx.sub(pmt[2]) + 1);
        }
      }
      //console.log("sc getBetsCheck pmt[2]", pmt[2]);
      //pmt[3] ... output Length;
      if(pmt[3] > maxOutLen) pmt[3] = maxOutLen;
      //console.log("sc getBetsCheck pmt[3]", pmt[3]);
      boolOut = bools[0] && bools[1] && bools[2] && bools[3] && bools[4] && bools[5];
    }

    function getPageIndexes(address user, uint256 period, uint256 idxPage, uint256 outLength, uint256 option) public view returns (
      address userOut,
      bool[] memory bools,
      uint256[] memory uintsInputs,
      uint256[] memory pmt, int256[] memory idx, 
      bool boolOut
      ){
      //console.log("sc getBetsCheck1");
      userOut = user;
      uintsInputs = new uint256[](4);
      uintsInputs[0] = period;
      uintsInputs[1] = idxPage;
      uintsInputs[2] = outLength;
      uintsInputs[3] = option;
      
      bools = new bool[](4);
      bools[0] = user != address(0);
      bools[1] = period == period2 || period == period1;
      bools[2] = option < 2;// 0 historical, 1 active
      bools[3] = outLength > 0;
      //bools[4] = idxPage > 0 && idxPage < 
      boolOut = bools[0] && bools[1] && bools[2] && bools[3];
      //console.log("sc getBetsCheck3:", bools[0], bools[1]);
      (uint256 cidx, uint256 uidx) = getAccountCU(user, period);
      //console.log("sc getBetsCheck4:", cidx, uidx);
      pmt = new uint256[](3);
      pmt[0] = cidx; pmt[1] = uidx;
      pmt[2] = outLength;
      //console.log("[sc] cidx", pmt[0], ", uidx:", pmt[1]);
      idx = new int256[](2);

      if(option == 0){//historical records
        //console.log("historical records");
        //uidx > 0, idxS = 1 ~ uidx
        if(uidx == 0){// no historical record
          pmt[2] = 0;
//          console.log("no historical record");
        } else {
  //idxPage=  3   ,  2  ,   1,   0
          //(-3)->1~16, 17~36, 37~56, 57~76
//          console.log(uidx, idxPage, outLength);
//          console.log("here2");
        idx[0]= int256(uidx)-int256(idxPage*outLength);
        //console.log("here3");
  
          if(idx[0] < 1) {
//            console.log("no more historical record");
            pmt[2] = 0; idx[0] = 0;
          } else {
            //console.log("here4");
            idx[1]= int256(uidx) - 
              int256((idxPage+1)*outLength) + 1;

            //console.log("here5");
            if(idx[1] < 1) idx[1] = 1;
            //console.log("here6");
            pmt[2] = uint256(idx[0]- idx[1] + 1);
            //console.log("here7");
          }
          //idxS= 1 + idxPage * outLength;//1, 21, 41
          //idxE= (idxPage+1) * outLength;//20, 40, 60
        }

      } else if(option == 1){//active records
        //cidx > uidx, idxS = uidx+1 ~ cidx
        if(cidx == uidx){//no active record
          pmt[2] = 0;
//          console.log("no active record");
        } else {
  //idxPage=  1   ,   0
          //77~92 , 93 ~ 112
          idx[0]= int256(cidx)-int256(idxPage*outLength);
          if(idx[0] < 1) {
//            console.log("no more historical record");
            pmt[2] = 0; idx[0] = 0;
          } else {
            idx[1] = int256(cidx) - 
            int256((idxPage+1)*outLength) + 1;
            if(idx[1] <= int256(uidx)) idx[1] = int256(uidx+1);
            pmt[2] = uint256(idx[0]- idx[1] +1);
          }
        }
      }
  //console.log("[sc] idxS, idxE:", idx[0], idx[1]);
    }
    
    // userAddr -> bet indexes: cleared or not
    function getBetIndexes(address user, uint256 period, uint256 idxPage, uint256 outLength, uint256 option) public view
        returns (
          uint256[] memory idxesOut, 
          uint256[] memory uintO)
    { 
      // address userOut,
      // bool[] memory bools,
      // uint256[] memory uintsInputs,
      // uint256[] memory pmt, int256[] memory idx, 
      // bool boolOut
      (, , , uint256[] memory pmt, int256[] memory idx, bool boolOut) = getPageIndexes(user, period, idxPage, outLength, option);
      //(, , , uint256[] memory pmt, bool boolOut) = getBetsCheck(user, period, idxS, outLength, option);
      //console.log("here8");
      require(boolOut, "invalid input detected");
      //pmt[0] = cidx; pmt[1] = uidx;
      //pmt[2] = outLength;
      //cidx2, uidx2, idxS2, idxE2
      uintO = new uint256[](4);
      uintO[0] = pmt[0]; uintO[1] = pmt[1];
      uintO[2] = uint256(idx[0]);//idxS2
      uintO[3] = uint256(idx[1]);//idxE2
      //console.log("here9", pmt[2]);

      if(pmt[2] == 0){

      } else {
      //console.log("here10");
        idxesOut = new uint256[](pmt[2]);
        require( uintO[2] > 0 && uintO[3] > 0,"idxS2, idxE2");
        uint256 id = uintO[2];
        if (period == period2) {
          for (uint i = 0; i <= pmt[2]; i++) {
            //console.log("loop", i, id);
            idxesOut[i]= accounts[user].idxesAP2[id];
            id -= 1;
            if(i+1 == pmt[2]) break;
          }

        } else if (period == period1) {
          for (uint i = 0; i <= pmt[2]; i++) {
            //console.log("loop", i, id);
            idxesOut[i]= accounts[user].idxesAP1[id];
            id -= 1;
            if(i+1 == pmt[2]) break;
          }

        } else {
          require(false, "period not found");
        }
      }
      // if(pmt[3] == 0){

      // } else {
      //   idxesOut = new uint256[](pmt[3]);
      //   uintO[3] = (uintO[2] + pmt[3]).sub(1);
      //   if (period == period2) {
      //     for (uint i = 0; i < pmt[3]; i++) {
      //         idx = uintO[2] + i;
      //         idxesOut[i] = accounts[user].idxesAP2[idx];
      //     }

      //   } else if (period == period1) {
      //     for (uint i = 0; i < pmt[3]; i++) {
      //         idx = uintO[2] + i;
      //         idxesOut[i] = accounts[user].idxesAP1[idx];
      //     }
      //   } else {
      //     require(false, "period not found");
      //   }
      // }
    }

    // userAddr -> bets: cleared or not
    function getBetterBets(address user, uint256 period, uint256 idxPage, uint256 outLength, uint256 option) public view
        returns (IPriceBetting.Bet[] memory betsOut, uint256[] memory uintO2)
    {
      (uint256[] memory idxesOut, uint256[] memory uintO) = getBetIndexes(user, period, idxPage, outLength, option);
      //uintO = [cidx2, uidx2, idxS2, idxE2]
      uintO2 = new uint256[](4);
      uintO2[0] = uintO[0];
      uintO2[1] = uintO[1];
      uintO2[2] = uintO[2];
      uintO2[3] = uintO[3];
      
      IPriceBetting PriceBetting = IPriceBetting(addrPriceBetting);

      betsOut = new IPriceBetting.Bet[](idxesOut.length);
      if (period == period2) {
        for (uint i = 0; i < idxesOut.length; i++) {
            betsOut[i] = PriceBetting.betsP2(idxesOut[i]);
        }

      } else if (period == period1) {
        for (uint i = 0; i < idxesOut.length; i++) {
            betsOut[i] = PriceBetting.betsP1(idxesOut[i]);
        }
      } else {
        require(false, "period not found");
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