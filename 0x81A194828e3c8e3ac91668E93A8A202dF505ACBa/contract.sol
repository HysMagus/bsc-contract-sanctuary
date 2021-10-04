//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.1;
//import "hardhat/console.sol";

library Math {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }
}


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

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
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

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/IRewardDistributionRecipient.sol
abstract contract IRewardDistributionRecipient is Ownable {
    address public rewardDistribution; //added "public"

    modifier onlyRewardDistribution() {
        require(
            _msgSender() == rewardDistribution,
            "Caller is not reward distribution"
        );
        _;
    }

    //added func
    function isOnlyRewardDistribution() external view returns (bool) {
        return _msgSender() == rewardDistribution;
    }

    function isOnlyRewardDistributionB(address user)
        external
        view
        returns (bool)
    {
        return user == rewardDistribution;
    }

    function setRewardDistribution(address _rewardDistribution)
        external
        onlyOwner
    {
        //console.log("[sc] setRewardDistribution... ");
        rewardDistribution = _rewardDistribution;
    }
}

contract BonusReward is IRewardDistributionRecipient {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    uint256 public dailyLimitDefault = 1000 * (10**18);
    uint256 public constant CLAIMDURATION = 1 days;

    mapping(address => uint256) private rewardsClaimed;
    mapping(address => uint256) private rewardBalance;
    mapping(address => uint256) private dailyLimit;
    mapping(address => uint256) private lastClaimedTime;

    event RewardPaid(address indexed user, uint256 reward);

    address public addrRewardToken;
    //IERC20 public erc20RewardToken;

    constructor() {
      addrRewardToken = address(0x82D6F82a82d08e08b7619E6C8F139391C23DC539);
      //erc20RewardToken = IERC20(_rewardToken);
    }

    function getRewardTokenBalance(address addr) public view returns (uint256) {
        return IERC20(addrRewardToken).balanceOf(addr);
    }

    function getRewardTokenBalanceOnContract() public view returns (uint256) {
        return IERC20(addrRewardToken).balanceOf(address(this));
    }

    function claimRewardCheck(address user) public view returns (bool, uint256, bool, uint256) {
        return
            (block.timestamp >= lastClaimedTime[user].add(CLAIMDURATION), block.timestamp, getRewardTokenBalanceOnContract() >= rewardBalance[user], rewardBalance[user]);
    }

    function claimReward() public {
        (bool isTimeOk, uint256 blockime, bool isRewardsSufficient, uint256 reward) = claimRewardCheck(msg.sender);
        //console.log("[sc] isTimeToClaim: %s, isRewardSufficient: %s, user rewards: %s", isTimeOk, isRewardsSufficient, reward);
        //blockime

        uint256 dailyLimitUser;
        if (dailyLimit[msg.sender] == 0) {
            dailyLimitUser = dailyLimitDefault;
        } else {
            dailyLimitUser = dailyLimit[msg.sender];
        }
        if (reward > dailyLimitUser) {
            reward = dailyLimitUser;
        }

        //require(reward > 0 && isTimeOk && isRewardSufficient(msg.sender), "check failed");
        if (reward > 0 && isTimeOk && isRewardsSufficient) {
            rewardBalance[msg.sender] = rewardBalance[msg.sender].sub(reward);
            IERC20(addrRewardToken).safeTransfer(msg.sender, reward);
            rewardsClaimed[msg.sender] = rewardsClaimed[msg.sender].add(reward);
            lastClaimedTime[msg.sender] = blockime;
            emit RewardPaid(msg.sender, reward);
        }
    }

    function getRewardsClaimed(address user) public view returns (uint256) {
        return rewardsClaimed[user];
    }

    function getRewardBalance(address user) public view returns (uint256) {
        return rewardBalance[user];
    }

    function getDailyLimit(address user) public view returns (uint256) {
        return dailyLimit[user];
    }

    function setDailyLimit(address user, uint256 amount)
        public
        onlyRewardDistribution
    {
        dailyLimit[user] = amount;
    }

    function getLastClaimedTime(address user) public view returns (uint256) {
        return lastClaimedTime[user];
    }

    function reduceRewardBalance(address user, uint256 amount)
        public
        onlyRewardDistribution
    {
        rewardBalance[user] = rewardBalance[user].sub(amount);
    }

    function addRewardBalance(address user, uint256 amount)
        public
        onlyRewardDistribution
    {
        rewardBalance[user] = rewardBalance[user].add(amount);
    }

    function getBlockTimestamp() public view returns (uint256) {
        return (block.timestamp);
    }

}

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