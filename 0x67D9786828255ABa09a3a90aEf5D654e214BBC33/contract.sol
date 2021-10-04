pragma solidity 0.8.2;

// SPDX-License-Identifier: MIT

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

interface Token {
    function transferFrom(address, address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
}

contract ADA_WBNB_Pool is Ownable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;
    
    event RewardsTransferred(address holder, uint256 amount);
    
    // TENFI token contract address
    address public tokenAddress = 0x081B2aEB9925e1F72e889eac10516C2A48a9F76a;
    
    // LP token contract address
    address public LPtokenAddress = 0xBA51D1AB95756ca4eaB8737eCD450cd8F05384cF;
    
    // reward rate 56 % per year
    uint256 public rewardRate = 65307;
    uint256 public rewardInterval = 365 days;
    
    // unstaking possible after 0 days
    uint256 public cliffTime = 0 days;
    
    uint256 public farmEnableat;
    uint256 public totalClaimedRewards = 0;
    uint256 public totalDevFee = 0;
    uint256 private stakingAndDaoTokens = 100000e18;
    
    bool public farmEnabled = false;
    
    EnumerableSet.AddressSet private holders;
    
    mapping (address => uint256) public depositedTokens;
    mapping (address => uint256) public stakingTime;
    mapping (address => uint256) public lastClaimedTime;
    mapping (address => uint256) public totalEarnedTokens;
    
    function updateAccount(address account) private {
        uint256 pendingDivs = getPendingDivs(account);
        uint256 fee = pendingDivs.mul(2000).div(1e4);
        uint256 pendingDivsAfterFee = pendingDivs.sub(fee);
        
        if (pendingDivsAfterFee > 0) {
            require(Token(tokenAddress).transfer(account, pendingDivsAfterFee), "Could not transfer tokens.");
            totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivsAfterFee);
            totalClaimedRewards = totalClaimedRewards.add(pendingDivsAfterFee);
            emit RewardsTransferred(account, pendingDivsAfterFee);
        }
        
        if (fee > 0) {
            require(Token(tokenAddress).transfer(account, fee), "Could not transfer tokens.");
            totalDevFee = totalDevFee.add(fee);
            emit RewardsTransferred(account, fee);
        }
        
        lastClaimedTime[account] = block.timestamp;
    }
    
    function getPendingDivs(address _holder) public view returns (uint256 _pendingDivs) {
        if (!holders.contains(_holder)) return 0;
        if (depositedTokens[_holder] == 0) return 0;
        
        uint256 timeDiff = block.timestamp.sub(lastClaimedTime[_holder]);
        uint256 stakedAmount = depositedTokens[_holder];
        
        if (block.timestamp <= farmEnableat + 1 days) {
            uint256 pendingDivs = stakedAmount.mul(738199).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 1 days && block.timestamp <= farmEnableat + 2 days) {
            uint256 pendingDivs = stakedAmount.mul(678723).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 2 days && block.timestamp <= farmEnableat + 3 days) {
            uint256 pendingDivs = stakedAmount.mul(625079).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 3 days && block.timestamp <= farmEnableat + 4 days) {
            uint256 pendingDivs = stakedAmount.mul(574932).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 4 days && block.timestamp <= farmEnableat + 5 days) {
            uint256 pendingDivs = stakedAmount.mul(528285).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 5 days && block.timestamp <= farmEnableat + 6 days) {
            uint256 pendingDivs = stakedAmount.mul(486302).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 6 days && block.timestamp <= farmEnableat + 7 days) {
            uint256 pendingDivs = stakedAmount.mul(447818).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 7 days && block.timestamp <= farmEnableat + 8 days) {
            uint256 pendingDivs = stakedAmount.mul(411666).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 8 days && block.timestamp <= farmEnableat + 9 days) {
            uint256 pendingDivs = stakedAmount.mul(379012).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 9 days && block.timestamp <= farmEnableat + 10 days) {
            uint256 pendingDivs = stakedAmount.mul(348691).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 10 days && block.timestamp <= farmEnableat + 11 days) {
            uint256 pendingDivs = stakedAmount.mul(320703).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 11 days && block.timestamp <= farmEnableat + 12 days) {
            uint256 pendingDivs = stakedAmount.mul(295047).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 12 days && block.timestamp <= farmEnableat + 13 days) {
            uint256 pendingDivs = stakedAmount.mul(271723).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 13 days && block.timestamp <= farmEnableat + 14 days) {
            uint256 pendingDivs = stakedAmount.mul(249565).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 14 days && block.timestamp <= farmEnableat + 15 days) {
            uint256 pendingDivs = stakedAmount.mul(229740).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 15 days && block.timestamp <= farmEnableat + 16 days) {
            uint256 pendingDivs = stakedAmount.mul(211081).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 16 days && block.timestamp <= farmEnableat + 17 days) {
            uint256 pendingDivs = stakedAmount.mul(194754).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 17 days && block.timestamp <= farmEnableat + 18 days) {
            uint256 pendingDivs = stakedAmount.mul(178428).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 18 days && block.timestamp <= farmEnableat + 19 days) {
            uint256 pendingDivs = stakedAmount.mul(164433).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 19 days && block.timestamp <= farmEnableat + 20 days) {
            uint256 pendingDivs = stakedAmount.mul(151605).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 20 days && block.timestamp <= farmEnableat + 21 days) {
            uint256 pendingDivs = stakedAmount.mul(138777).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 21 days && block.timestamp <= farmEnableat + 22 days) {
            uint256 pendingDivs = stakedAmount.mul(128281).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 22 days && block.timestamp <= farmEnableat + 23 days) {
            uint256 pendingDivs = stakedAmount.mul(117786).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 23 days && block.timestamp <= farmEnableat + 24 days) {
            uint256 pendingDivs = stakedAmount.mul(108456).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 24 days && block.timestamp <= farmEnableat + 25 days) {
            uint256 pendingDivs = stakedAmount.mul(100293).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 25 days && block.timestamp <= farmEnableat + 26 days) {
            uint256 pendingDivs = stakedAmount.mul(92130).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 26 days && block.timestamp <= farmEnableat + 27 days) {
            uint256 pendingDivs = stakedAmount.mul(83966).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 27 days && block.timestamp <= farmEnableat + 28 days) {
            uint256 pendingDivs = stakedAmount.mul(78135).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 28 days && block.timestamp <= farmEnableat + 29 days) {
            uint256 pendingDivs = stakedAmount.mul(71138).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 29 days && block.timestamp <= farmEnableat + 30 days) {
            uint256 pendingDivs = stakedAmount.mul(65307).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
            
        } else if (block.timestamp > farmEnableat + 30 days) {
            uint256 pendingDivs = stakedAmount.mul(rewardRate).mul(timeDiff).div(rewardInterval).div(1e4);
            
            return pendingDivs;
        }
    }
    
    function getNumberOfHolders() public view returns (uint256) {
        return holders.length();
    }
    
    
    function deposit(uint256 amountToStake) public {
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(farmEnabled, "Farming is not enabled");
        require(Token(LPtokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
        
        updateAccount(msg.sender);
        
        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountToStake);
        
        if (!holders.contains(msg.sender)) {
            holders.add(msg.sender);
            stakingTime[msg.sender] = block.timestamp;
        }
    }
    
    function withdraw(uint256 amountToWithdraw) public {
        require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
        
        require(block.timestamp.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
        
        updateAccount(msg.sender);
        
        require(Token(LPtokenAddress).transfer(msg.sender, amountToWithdraw), "Could not transfer tokens.");
        
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
        
        if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
            holders.remove(msg.sender);
        }
    }
    
    function claimDivs() public {
        updateAccount(msg.sender);
    }
    
    function getStakingAndDaoAmount() public view returns (uint256) {
        if (totalClaimedRewards >= stakingAndDaoTokens) {
            return 0;
        }
        uint256 remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
        return remaining;
    }
    
    function setTokenAddress(address _tokenAddressess) public onlyOwner {
        tokenAddress = _tokenAddressess;
    }
    
    function setCliffTime(uint256 _time) public onlyOwner {
        cliffTime = _time;
    }
    
    function setRewardInterval(uint256 _rewardInterval) public onlyOwner {
        rewardInterval = _rewardInterval;
    }
    
    function setStakingAndDaoTokens(uint256 _stakingAndDaoTokens) public onlyOwner {
        stakingAndDaoTokens = _stakingAndDaoTokens;
    }
    
    function setRewardRate(uint256 _rewardRate) public onlyOwner {
        rewardRate = _rewardRate;
    }
    
    function enableFarming() external onlyOwner() {
        farmEnabled = true;
        farmEnableat = block.timestamp;
    }
    
    // function to allow admin to claim *any* ERC20 tokens sent to this contract
    function transferAnyERC20Tokens(address _tokenAddress, address _to, uint256 _amount) public onlyOwner {
        require(_tokenAddress != LPtokenAddress);
        
        Token(_tokenAddress).transfer(_to, _amount);
    }
}