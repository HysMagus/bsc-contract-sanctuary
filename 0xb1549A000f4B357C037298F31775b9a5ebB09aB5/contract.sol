//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.1;
//pragma abicoder v2;

//import "./openzeppelinERC20ITF.sol";
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

//---------------------------== start

interface IABDKMathQuadFunc {
  function mulMul(uint256 x, uint256 y, uint256 z
    ) external pure returns (uint256);

  function mulDiv(uint256 x, uint256 y, uint256 z
    ) external pure returns (uint256);
}
// interface AggregatorXDAI {
//   function latestAnswer() external view returns (int256);
// }

//pragma solidity >=0.6.0;
//import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"
interface AggregatorEthereumV3 {
  function latestRoundData()
      external view
      returns (
          uint80 roundId,
          int256 answer,
          uint256 startedAt,
          uint256 updatedAt,
          uint80 answeredInRound
      );
  function getRoundData(uint80 _roundId)
    external view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
    // function latestAnswer() external view returns (int256);
    // function latestTimestamp() external view returns (uint256);
    //function latestRound() external view returns (uint256);
    //function getAnswer(uint256 roundId) external view returns (int256);
    //function getTimestamp(uint256 roundId) external view returns (uint256);

    event AnswerUpdated(
        int256 indexed current,
        uint256 indexed roundId,
        uint256 updatedAt
    );
    event NewRound(
        uint256 indexed roundId,
        address indexed startedBy,
        uint256 startedAt
    );
}
interface IUserRecord {
  function addBet(address user, uint256 period, uint256 idx) external;
  function updateBet(address user, uint256 period, uint256 idx) external;
}

contract PriceBetting is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;

    address private admin;
    address private governance;
    event AccountTransferred(
        address indexed previousAccount,
        address indexed newAccount
    );

    modifier onlyAdmin() {
        require(_msgSender() == admin, "Caller is not admin");
        _;
    }

    function isAccount(address addr, uint256 uintNum) public view returns (bool bool1) {
      if(uintNum == 1) bool1 = addr == admin;
      if(uintNum == 2) bool1 = addr == governance;
    }

    event Win(
        address indexed user,
        uint256 indexed timestamp,
        uint256 result,
        uint256 betIdx,
        uint256 indexed period
    );
    event Lose(
        address indexed user,
        uint256 indexed timestamp,
        uint256 result,
        uint256 betIdx,
        uint256 indexed period
    );
    event Tie(
        address indexed user,
        uint256 indexed timestamp,
        uint256 result,
        uint256 betIdx,
        uint256 indexed period
    );

    uint256 public idxSP2 = 0;
    uint256 public idxSP1 = 0;
    uint256 public idxEP2 = 0;
    uint256 public idxEP1 = 0;

    uint256 public period1;
    uint256 public period2;
    uint256 public maxBetAmt = 5 *(10**(18));
    uint256 public maxBetsToClear = 10;
    uint256 public profitRatio = 88; //lesser than 100
    uint256 public maxUnclaimedPoolRatio = 5; //<100
    bool public bettingStatus = true;

    address private vault;

    mapping(uint256 => Bet) public betsP2;
    mapping(uint256 => Bet) public betsP1;

    address public addrToken;
    address public addrPriceFeedBTC;
    address public addrPriceFeedETH;
    address public addrUserRecord;
    IABDKMathQuadFunc public ABDKMathQuadFunc;

    constructor(
    ) {
      admin = address(0xAc52301711C49394b17cA585df714307f0C588C0);
      governance = address(0x13A08dDcD940b8602f147FF228f4c08720456aA3);
      vault = address(0x13A08dDcD940b8602f147FF228f4c08720456aA3);

      addrToken = address(0x82D6F82a82d08e08b7619E6C8F139391C23DC539);
      ABDKMathQuadFunc = IABDKMathQuadFunc(0x441FbCa0cE9b475bE04556DDC4d1371db6F65c66);

      addrPriceFeedBTC = address(0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf);
      addrPriceFeedETH = address(0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);

      period1 = 1800; period2 = 3600;
    } 
    /*
    -----------== BSC Testnet
      addrToken = address(0x9121e7445B4cCD88EF4B509Df17dB029128EbbA0);
      ABDKMathQuadFunc = IABDKMathQuadFunc(0x1331e0a03D7f820c7d1C6676D4cE76DD2b791Cf2);

      addrPriceFeedBTC = address(0x5741306c21795FdCBb9b265Ea0255F499DFe515C);
      addrPriceFeedETH = address(0x143db3CEEfbdfe5631aDD3E50f7614B6ba708BA7);  
      
      -----------== BSC Mainnet
      addrToken = address(0x82D6F82a82d08e08b7619E6C8F139391C23DC539);
      ABDKMathQuadFunc = IABDKMathQuadFunc(0x441FbCa0cE9b475bE04556DDC4d1371db6F65c66);

      addrPriceFeedBTC = address(0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf);
      addrPriceFeedETH = address(0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);
    
    -------------== XDAI
      ABDKMathQuadFunc = IABDKMathQuadFunc(0x1331e0a03D7f820c7d1C6676D4cE76DD2b791Cf2);
      addrToken = address(0xc81c785653D97766b995D867CF91F56367742eAC);
      addrPriceFeedBTC = address(0xC3eFff1B3534Ab5e2Ce626DCF1783b7E83154eF4);
     */

    //--------------------== onlyAdmin settings
    event SetSettings(uint256 indexed option, address addr, bool _bool, uint256 uintNum);

    function setSettings(uint256 option, address addr, bool _bool, uint256 uintNum) external onlyAdmin {
      if(option == 101){
        period1 = uintNum;
      } else if(option == 102){
        period2 = uintNum;

      } else if(option == 103){
        bettingStatus = _bool;

      } else if(option == 104){
        require(uintNum >= 1*(10**(15)),"invalid number");
        maxBetAmt = uintNum;

      } else if(option == 105){
        require(uintNum > 0, "amount cannot be 0");
        maxBetsToClear = uintNum;
/**
    uint256 public period1 = 300;
    uint256 public period2 = 900;
    uint256 public maxBetAmt = 5 *(10**(18));
    uint256 public maxBetsToClear = 10;
    uint256 public profitRatio = 88; //lesser than 100
    uint256 public maxUnclaimedPoolRatio = 5; //<100
    bool public bettingStatus = true;
 */
      } else if(option == 106){
        require(uintNum > 0 && uintNum <= 100,"ratio invalid");
        profitRatio = uintNum;

      } else if(option == 107){
        require(uintNum > 0 && uintNum <= 100,"ratio invalid");
        maxUnclaimedPoolRatio = uintNum;

      } else if(option == 108){
        require(uintNum > 0, "ratio invalid");
        sharePriceUnit = uintNum;

      } else if(option == 109){
        require(addr != address(0), "cannot be zero address");
        if(uintNum == 0) admin = addr;
        if(uintNum == 1) governance = addr;
        emit AccountTransferred(admin, addr);        

      } else if(option == 997){//MUST clear all bets before changing token address!!!
        require(address(addr).isContract(),"invalid contract");
        addrToken = addr;
      } else if(option == 998){
        require(address(addr).isContract(),"invalid contract");
        addrUserRecord = addr;
      } else if(option == 999){
        //require(address(token).isContract(), "call to non-contract");
        require(addr != address(0), "vault cannot be zero address");
        vault = addr;
      }
      emit SetSettings(option, addr, _bool, uintNum);
    }

    //--------------------== Public functions
    function clearBetsExternal() public onlyAdmin {
        clearBets(period1);
        clearBets(period2);
    }

    function enterBetCheck(
        uint256 amount, uint256 period, uint256 assetPair,
        uint256 bettingOutcome, uint256 fundingSource
    ) public view
        returns (
            bool[] memory bools,
            uint256[] memory uints,
            uint256[] memory uintInputs,
            bool boolOut
        )
    {
        bools = new bool[](11);
        uints = new uint256[](6);
        uintInputs = new uint256[](5);
        
        uintInputs[0] = amount;
        uintInputs[1] = period;
        uintInputs[2] = bettingOutcome;
        uintInputs[3] = fundingSource;
        uintInputs[4] = assetPair;

        address user = msg.sender;
        uint256 allowed = IERC20(addrToken).allowance(user, address(this));
        bools[0] = amount >= 100;
        //amount: 0 invalid, 1 ~ 99 reserved for errCode -99~-1 & 1 ~ 100*profitRatio
        //... use errCode -99 ~ -1
        bools[1] = period == period2 || period == period1;
        bools[2] = bettingOutcome < 2;
        bools[3] = fundingSource < 2; // balance: 0, deposit: 1
        uint256 maxTotalUnclaimed = ABDKMathQuadFunc.mulDiv(poolBalance, maxUnclaimedPoolRatio, 100);

        bools[4] = totalUnclaimed <= maxTotalUnclaimed;

        uint256 tokenBalanceAtFundingSrc;
        if (fundingSource == 0) {//bet from balance
            tokenBalanceAtFundingSrc = betters[user].balance;
            bools[7] = amount <= totalUnclaimed;
        } else {//bet from wallet
            tokenBalanceAtFundingSrc = getTokenBalance(user);
            bools[7] = amount <= allowed;
        }
        bools[5] = amount <= tokenBalanceAtFundingSrc;
        bools[6] = amount <= maxBetAmt;
        bools[8] = bettingStatus;
        bools[9] = assetPair < 2;
        bools[10] = poolBalance > 0;

        boolOut = bools[0] && bools[1] && bools[2] && bools[3] && bools[4] && bools[5] && bools[6] && bools[7] && bools[8] && bools[9] && bools[10];

        uints[0] = allowed;
        uints[1] = tokenBalanceAtFundingSrc;
        uints[2] = totalUnclaimed;
        uints[3] = betters[user].balance;
        uints[4] = maxBetAmt;
        uints[5] = maxTotalUnclaimed;
    }

    function enterBet(
        uint256 amount, uint256 period, uint256 assetPair,
        uint256 bettingOutcome, uint256 fundingSource
    ) external {
        (, , ,bool boolOut) =
            enterBetCheck(amount, period, assetPair, bettingOutcome, fundingSource);
        require(boolOut, "invalid input detected");

        clearBets(period);

        address user = msg.sender;
        if (fundingSource == 0) {
          //console.log("[sc] ----== bet from balance");
          updateBetterBalance(false, amount, user);

        } else {
          //console.log("[sc] ----== bet from wallet");
          IERC20(addrToken).safeTransferFrom(user, address(this), amount);
        }

        Bet memory bet;
        bet.addr = user;
        bet.betAt = block.timestamp;
        bet.amount = amount;
        bet.period = period;
        bet.assetPair = assetPair;
        bet.priceAtBet = getLatestPrice(assetPair);
        bet.bettingOutcome = bettingOutcome;
        bet.fundingSource = fundingSource;
        bet.result = -1;

        //console.log("[sc] bet:", bet);
        //console.log("[sc] period:", period, period1, period2);
        if (period == period1) {
            idxEP1 += 1;
            betsP1[idxEP1] = bet;
            IUserRecord(addrUserRecord).addBet(user, period, idxEP1);
        } else if (period == period2) {
            idxEP2 += 1;
            betsP2[idxEP2] = bet;
            IUserRecord(addrUserRecord).addBet(user, period, idxEP2);
        }
    }

    //enum FundingSource{deposit, balance}
    struct Bet {
        address addr;
        uint256 betAt; //time this bet was recorded
        uint256 amount; //amount of betting
        uint256 period; //in seconds
        uint256 assetPair; //0 BTC, 1 ETH
        uint256 priceAtBet;
        uint256 bettingOutcome; //0 down, 1 up, 2 same, 3 uknown
        uint256 fundingSource; //0 balance, 1 deposit
        uint256 settledAt; //time this bet was settled
        uint256 settledPrice; //price this bet was settled
        int256 result; //
        //uint256 paidAt; //time this bet was paid
    }

    function getBet(uint256 period, uint256 betIdx)
        public view returns (Bet memory bet)
    {
        if (period == period2) bet = betsP2[betIdx];
        if (period == period1) bet = betsP1[betIdx];
    }

    function clearBets(uint256 period) private {
        //loop to clear max 4 old bets
        //console.log("[sc] clearBets()");
        uint256 idxStart;
        uint256 idxEnd;
        if (period == period2) {
            idxStart = idxSP2;
            idxEnd = idxEP2;
        } else if (period == period1) {
            idxStart = idxSP1;
            idxEnd = idxEP1;
        }//if changing period before all bets are cleared, this bet will never be clear!!!
        if ( idxEnd > idxStart) {
//            console.log("[sc] betIdx start & end good");
            for (
                uint256 betIdx = idxStart + 1;
                betIdx < idxStart + maxBetsToClear;
                betIdx++
            ) {
//                console.log("[sc] ---------== loop");
//                console.log("[sc] betIdx: %s, period: %s", betIdx, period);
                Bet memory bet = getBet(period, betIdx);

//                console.log("bet:: betAt: %s, blockTime: %s", bet.betAt, block.timestamp);
                if (bet.betAt == 0) {
 //                   console.log("[sc] ----== all bets have been settled");
                    break;
                }
                if (block.timestamp < bet.betAt + period) {
//                  console.log("[sc] ----== bets are waiting");
                    break;
                }
                settle(period, betIdx);
                if (period == period2) {
                    idxSP2 += 1;
                }
                if (period == period1) {
                    idxSP1 += 1;
                }
            }
        }
    }

    // function calcAmounts(uint256 amount) public view returns (uint256 gain, uint256 gaPrin, uint256 govGain) {
    //     gain = ABDKMathQuadFunc.mulDiv(amount, profitRatio, 100);//0.88
    //     gaPrin = amount + gain;//1.88
    //     govGain = amount - gain;//0.12
    // }
    function settle(uint256 period, uint256 betIdx
    ) private {
        Bet memory bet = getBet(period, betIdx);
        uint256 price = getLatestPrice(bet.assetPair);
        //console.log("[sc] settle(): betIdx: %s, priceNow: %s", betIdx, price);
        //console.log("[sc] priceAtBet: %s, bettingOutcome: %s",bet.priceAtBet, bet.bettingOutcome);

        //(uint256 gain, uint256 gaPrin, uint256 govGain) = calcAmounts(bet.amount);
        uint256 gain = ABDKMathQuadFunc.mulDiv(bet.amount, profitRatio, 100); //0.88
        uint256 gaPrin = bet.amount + gain; //1.88
        uint256 govGain = bet.amount.sub(gain); //0.12

        //console.log("bet.amount", bet.amount, gain, gaPrin);

        //totalUnsettledBetAmt = totalUnsettledBetAmt - bet.amount);

        if (price < bet.priceAtBet) {
          //the govBalance gets 0.12
          govBalance += govGain;
          if (bet.bettingOutcome == 0) {
//              console.log("[sc] ----== Win1: price down");
              handleWinning(period, betIdx, gain, gaPrin, price);
          } else {
//              console.log("[sc] ----== Lose1: price down");
              handleLosing(period, betIdx, gain, price);
          }
        } else if (price > bet.priceAtBet) {
          //the govBalance gets 0.12
          govBalance += govGain;
          if (bet.bettingOutcome == 1) {
//              console.log("[sc] ----== Win2: price up");
              handleWinning(period, betIdx, gain, gaPrin, price);
          } else {
//              console.log("[sc] ----== Lose2: price up");
              handleLosing(period, betIdx, gain, price);
          }
        } else {
//            console.log("[sc] ----== Same price");
            handleTie(period, betIdx, price);
        }
    }
    //--------------------==
    /*struct Bet {
        address addr;
        uint256 betAt; //time this bet was recorded
        uint256 amount; //amount of betting
        uint256 period; //in seconds
        uint256 tokenPair; //0 BTC, 1 ETH
        uint256 priceAtBet;
        uint256 bettingOutcome; //0 down, 1 up, 2 same, 3 uknown
        uint256 settledAt; //time this bet was settled
        uint256 settledPrice; //price this bet was settled
        uint256 result;
        uint256 fundingSource;
    }*/
    function handleWinning(uint256 period, uint256 betIdx, uint256 gain, uint256 gaPrin, uint256 price
    ) internal {
        //console.log("[sc] ----== handleWinning");
        //console.log(period, betIdx, gain, gaPrin);
        Bet memory bet = getBet(period, betIdx);
        require(poolBalance >= bet.amount, "poolBalance1");
        poolBalance = poolBalance.sub(bet.amount);
        // Pool loses 1
        setSharePrice();//after poolBalance updated

        if (bet.fundingSource == 0) {//from balance
          totalUnclaimed += gain;
        } else {//from wallet
          totalUnclaimed += gaPrin;
        }
        updateBetterBalance(true, gaPrin, bet.addr);
        updateBetterWinloss(true, gain, bet.addr);

        //console.log("[sc] gaPrin:", gaPrin);
        setBetResult(period, betIdx, gaPrin, block.timestamp, price);
        Win(bet.addr, block.timestamp, gaPrin, betIdx, bet.period);
        IUserRecord(addrUserRecord).updateBet(bet.addr, bet.period, betIdx);
    }
/**
interface IUserRecord {
  function addBet(address user, uint256 period, uint256 idx) external;
  function updateBet(address user, uint256 period, uint256 idx) external;
}*/
    function handleLosing(
        uint256 period,
        uint256 betIdx,
        uint256 gain, uint256 price
    ) internal {
        //console.log("[sc] ----== handleLosing:", period, betIdx, gain);
        Bet memory bet = getBet(period, betIdx);
        poolBalance += gain;
        // Pool gets 0.88
        setSharePrice();//after poolBalance updated

        if (bet.fundingSource == 0) {//from balance
          //add 0 in his balance
          require(totalUnclaimed >= bet.amount, "totalUnclaimed1");
          totalUnclaimed = totalUnclaimed.sub(bet.amount);
        } else {//from wallet
          //add 0 in his balance
          //add 0 in totalUnclaimed
        }
        //int256 result = -1*int256(bet.amount);
        updateBetterWinloss(false, bet.amount, bet.addr);
        setBetResult(period, betIdx, 0, block.timestamp, price);
        Lose(bet.addr, block.timestamp, 0, betIdx, bet.period);
        IUserRecord(addrUserRecord).updateBet(bet.addr, bet.period, betIdx);
    }

    function handleTie(
      uint256 period, uint256 betIdx, uint256 price) internal {
        //console.log("[sc] ----== handleTie");
        Bet memory bet = getBet(period, betIdx);
        //Pool gets nothing, the govBalance gets 0.
        if (bet.fundingSource == 0) {//from balance
          //add 0 in totalUnclaimed
        } else {//from wallet
          totalUnclaimed += bet.amount;
        }
        //add 1 in his balance for both cases above
        updateBetterBalance(true, bet.amount, bet.addr);

        setBetResult(period, betIdx, bet.amount, block.timestamp, price);
        Tie(bet.addr, block.timestamp, bet.amount, betIdx, bet.period);
        IUserRecord(addrUserRecord).updateBet(bet.addr, bet.period, betIdx);
    }
    //--------------------==
    /*struct Bet {
        address addr;
        uint256 betAt; //time this bet was recorded
        uint256 amount; //amount of betting
        uint256 period; //in seconds
        uint256 priceAtBet;
        uint256 bettingOutcome; //0 down, 1 up, 2 same, 3 uknown
        uint256 settledAt; //time this bet was settled
        uint256 settledPrice; //price this bet was settled
        uint256 result;
        uint256 fundingSource;
    }*/
    function setBetResult(
        uint256 period, uint256 betIdx, uint256 result, uint256 settledAt, uint256 settledPrice
    ) private {
        if (period == period2) {
            betsP2[betIdx].result = int256(result);
            betsP2[betIdx].settledAt = settledAt;
            betsP2[betIdx].settledPrice = settledPrice;
        } else if (period == period1) {
            betsP1[betIdx].result = int256(result);
            betsP1[betIdx].settledAt = settledAt;
            betsP1[betIdx].settledPrice = settledPrice;
        }
    }

    //-----------------== Pool
    uint256 public sharePriceUnit = 1000;//1*(10**9);
    uint256 public sharePrice = sharePriceUnit;
    uint256 public totalShares;
    uint256 public poolBalance;
    mapping(address => Pooler) public poolers;
    struct Pooler {
        uint256 shares;
        uint256 staking; //in token unit
    }

    event Stake(address indexed user, uint256 amount);
    function stake(uint256 amount) external {
      require(amount > 0, "amount1");
      //console.log("[solc] stake amount:", amount);
      IERC20(addrToken).safeTransferFrom(msg.sender, address(this), amount);

      //to   stake 100 AFI => issues  100/sharePrice shares, +100 AFI in poolBalance
      uint256 oldTotalShares = totalShares;
      poolBalance += amount;
      poolers[msg.sender].staking += amount;
      totalShares = ABDKMathQuadFunc.mulDiv(
      poolBalance, sharePriceUnit, sharePrice);
// newTotalShares = new_poolBalance / shareprice
// newShares = newTotalShares - oldTotalShares
// add newShares to this pooler
      poolers[msg.sender].shares += (totalShares.sub(oldTotalShares));
      emit Stake(msg.sender, amount);
    }

    event Unstake(address indexed user, uint256 amount);
    function unstake(uint256 _amount) external {
      //console.log("[sc] unstake amount:", amount);
      //to unstake 100 AFI => issues -100/sharePrice shares, -100 AFI in poolBalance,

      (uint256 effPoolerBalance, , , , bool isOk) = checkUnstake(msg.sender, _amount);
      require(isOk, "invalid inputs");

      if (_amount <= poolBalance){
        //uint256 effPoolerBalance = ABDKMathQuadFunc.mulDiv( poolers[msg.sender].shares, poolBalance, totalShares);
        if (_amount > 0 && _amount <= effPoolerBalance){
          //win & tie
          if ( effPoolerBalance >= poolers[msg.sender].staking && poolers[msg.sender].staking >= _amount){ 
            poolers[msg.sender].staking = poolers[msg.sender].staking.sub(_amount);
            uint256 oldTotalShares = totalShares;
            poolBalance = poolBalance.sub(_amount);
            totalShares = ABDKMathQuadFunc.mulDiv(poolBalance, sharePriceUnit, sharePrice);
            poolers[msg.sender].shares = poolers[msg.sender].shares.sub(oldTotalShares.sub(totalShares));
            tokenSafeTransfer(msg.sender, _amount);
          }
          else if ( _amount > poolers[msg.sender].staking){
            poolers[msg.sender].staking = 0;
            uint256 oldTotalShares = totalShares;
            poolBalance = poolBalance.sub(_amount);
            totalShares = ABDKMathQuadFunc.mulDiv(poolBalance, sharePriceUnit, sharePrice);
            poolers[msg.sender].shares = poolers[msg.sender].shares.sub(oldTotalShares.sub(totalShares));
            tokenSafeTransfer(msg.sender, _amount);
          }
          //lose
          else if ( poolers[msg.sender].staking > effPoolerBalance ) {
            poolers[msg.sender].staking = poolers[msg.sender].staking.sub(_amount);
            uint256 oldTotalShares = totalShares;
            poolBalance = poolBalance.sub(_amount);
            totalShares = ABDKMathQuadFunc.mulDiv(poolBalance, sharePriceUnit, sharePrice);
            poolers[msg.sender].shares = poolers[msg.sender].shares.sub(oldTotalShares.sub(totalShares));
            tokenSafeTransfer(msg.sender, _amount);
          }
        }
      }
    }

    function checkUnstake(address user, uint256 _amount)
        public view returns (uint256 effPoolerBalance, uint256 amount, Pooler memory pooler, bool[] memory bools, bool isOk)
    {
      bools = new bool[](3);
      //effShares = ABDKMathQuadFunc.mulDiv(poolers[user].shares, sharePrice, sharePriceUnit);

      effPoolerBalance = ABDKMathQuadFunc.mulDiv( poolers[msg.sender].shares, poolBalance, totalShares);

      pooler = poolers[user];
      amount = _amount;
      // if(_amount == 0 || _amount > poolers[msg.sender].staking){
      //   amount = poolers[msg.sender].staking;
      // }
      bools[0] = amount <= poolBalance;
      bools[1] = amount > 0;
      bools[2] = amount <= effPoolerBalance;

      isOk = bools[0] && bools[1] && bools[2];
    }

    function setSharePrice() private {
      if (totalShares == 0 || poolBalance == 0) {
        sharePrice = 1 * sharePriceUnit;
      } else {
        sharePrice = ABDKMathQuadFunc.mulDiv(
          poolBalance, sharePriceUnit, totalShares);
      }
    }
    function getDataStaking(address user)
        public view returns (uint256, uint256, uint256, Pooler memory, uint256, uint256)
    {
      uint256 effPoolerBalance;//int256 winloseBalance
      if (totalShares == 0 || poolBalance == 0) {
        effPoolerBalance = poolers[user].shares;
      } else {
        effPoolerBalance = ABDKMathQuadFunc.mulDiv(
            poolers[user].shares, poolBalance, totalShares);
      }
      return (poolBalance, totalShares, 
        getTokenBalance(address(this)), poolers[user], sharePrice, effPoolerBalance);
    }
    // winloseBalance = int256(effPoolerBalance) - int256(poolers[user].staking);
    // return(effPoolerBalance, winloseBalance)

    //-----------------== Better
    uint256 public totalUnclaimed;
    struct Better {
        uint256 balance;//unclaimed balance
        int256  winloss;//win: +0.88 or lose: -1
    }
    mapping(address => Better) public betters;

    function getDataBetIndexes() public view returns (
        uint256, uint256, uint256, uint256, uint256) {
      return (block.timestamp, idxSP2, idxEP2, idxSP1, idxEP1);
    }

    function getTokenBalance(address addr) public view returns (uint256){
          return IERC20(addrToken).balanceOf(addr);
    }
    function tokenSafeTransfer(address _to, uint256 amount) private {
        IERC20(addrToken).safeTransfer(_to, amount);
    }

    function getDataBetting(address user) external view returns (uint256, uint256, uint256, Better memory, uint256, uint256, uint256){
        return (totalUnclaimed, govBalance,
            getTokenBalance(address(this)), betters[user], maxBetsToClear, profitRatio, maxBetAmt);
    }

    function updateBetterBalance(bool isToAdd, uint256 amount, address user) private {
        if (isToAdd) {
            betters[user].balance += amount;
        } else {
            betters[user].balance = betters[user].balance.sub(amount);
        }
    }

    function updateBetterWinloss(bool isToAdd, uint256 amount, address user) private {
        if (isToAdd) {
            betters[user].winloss += int256(amount);
        } else {
            betters[user].winloss -= int256(amount);
        }
    }

    // use getDataBetting() as checker function 
    event Withdraw(address indexed user, uint256 amount);
    function withdraw(uint256 _amount) external {
        //console.log("[sc] withdraw amount", amount, better[msg.sender].balance, totalUnclaimed, getTokenBalance()); (, , , uint256 amount, bool boolOut) = withdrawCheck(_amount); require(boolOut, "input invalid");
        uint256 amount = _amount;
        if(_amount == 0){
          amount = betters[msg.sender].balance;// < totalUnclaimed ? betters[msg.sender].balance : totalUnclaimed;
        }//a < b ? a : b;
        updateBetterBalance(false, amount, msg.sender);
        totalUnclaimed = totalUnclaimed.sub(amount);
        tokenSafeTransfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }

    //-----== govBalance
    uint256 public govBalance;

    event Harvest(address indexed user, uint256 amount, address indexed toAddr);
    // use getDataBetting() to debug
    function harvest(uint256 _amount) public {
        require(isAccount(msg.sender, 2), "caller invalid");
        //console.log("[sc] harvest amount:", amount);
        require(vault != address(0), "vault cannot be zero address");
        //require(address(vault).isContract(), "call to non-contract");
        uint256 amount = _amount;
        if(_amount == 0){
          amount = govBalance;
        }
        govBalance = govBalance.sub(amount);
        tokenSafeTransfer(vault, amount);
        emit Harvest(msg.sender, amount, vault);
    }

    function getLatestPrice(uint256 assetPair) public view returns (uint256) {
      address pricefeed;
      if(assetPair == 0) {
        pricefeed = addrPriceFeedBTC;
      } else {
        pricefeed = addrPriceFeedETH;
      }
      //-----------==BSC/Kovan/Rinkeby
      (,int price,,,) = AggregatorEthereumV3(pricefeed).latestRoundData();
      return uint256(price);
      //console.log("roundID: %s, price: %s", roundID, price);
      //-----------==XDAI
      // return uint256(
      //     AggregatorXDAI(addrPriceFeed).latestAnswer()
      // );
  }
    function getHistoricalPrice(uint256 assetPair, uint256 roundId) public view returns (uint256, uint256) {
      address pricefeed;
      if(assetPair == 0) {
        pricefeed = addrPriceFeedBTC;
      } else {
        pricefeed = addrPriceFeedETH;
      }
      (, int price,, uint updatedAt, 
      ) =  AggregatorEthereumV3(pricefeed).getRoundData(uint80(roundId));//roundId, startedAt, answeredInRound
      require(updatedAt > 0, "Round not complete");
      return (updatedAt, uint256(price));
    }
}


/*
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
/*
    function withdrawCheck(uint256 _amount)
        public view returns (
            bool[] memory bools,
            uint256[] memory uints,
            uint256[] memory uintInputs,
            uint256 amount,
            bool boolOut
        )
        bools = new bool[](4);
        uints = new uint256[](3);
        uintInputs = new uint256[](4);
        
        address user = msg.sender;
        uintInputs[0] = _amount;
        uints[0] = betters[user].balance;
        uints[1] = totalUnclaimed;
        uints[2] = getTokenBalance();

        amount = _amount;
        if(_amount == 0){
          amount = uints[0] < uints[2] ? uints[0] : uints[2];
        }
        //console.log("amountNew:", amount);
        bools[0] = uints[0] >= amount;
        bools[1] = totalUnclaimed >= amount;
        bools[2] = uints[2] >= amount;
        bools[3] = uints[4] >= amount;
        boolOut = bools[0] && bools[1] && bools[2] && bools[3];
    }*/