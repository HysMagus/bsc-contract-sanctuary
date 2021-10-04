pragma solidity >=0.7.6;

// SPDX-License-Identifier: BSD-3-Clause

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
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
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
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
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
        return address(uint256(_at(set._inner, index)));
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
  constructor()  {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

}


interface Token {
    function transfer(address, uint) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    
}


contract CSGoGame is Ownable {
    using SafeMath for uint;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    
    
    uint public totalScore;
    uint public constant amountToLock = 1000000000000000000;
    
    address private constant tokenAddress = 0x75de745a333a47Fe786e8DbBf3E9440d3d5Bc809; 
   
    EnumerableSet.AddressSet private holders;
    
    mapping (address => address) public player;
    mapping (address => string) public name;
    mapping (address => uint) public reward;
    
    mapping (address => bool) public claimed;
    mapping (address => bool) public validated;
    
    mapping (address => uint) public position;
    
    mapping (address => uint) public score;
    
    function addParticipant(address _holder, address _player, string memory _name) public returns (bool){
        require(!holders.contains(_holder));
        
        require(Token(tokenAddress).transferFrom(_holder, address(this) , amountToLock ) , "Error locking 1 token");
        
        holders.add(_holder);
        player[_holder] = _player;   
        name[_holder] = _name;
        
        return true;
        
    }
    function setScore(address _holder, uint _score) public returns (bool){
        require(holders.contains(_holder));
        require(_holder == msg.sender);
        
        score[_holder] =_score;
        
        return true;    
    }
    function validateScore( address _holder) public onlyOwner returns (bool){
        require(holders.contains(_holder));
        require(!validated[_holder]);
        
        validated[_holder] = true;
        totalScore = totalScore.add(score[_holder]);
        
        return true;
    }
    
     function end() public onlyOwner returns(bool){
        
        for(uint i = 0; i < holders.length(); i = i.add(1)){
            address actual = holders.at(i);
            if(!validated[actual]){
                validated[actual] = true;
                totalScore = totalScore.add(score[actual]);
            }
        }
        
        require(totalScore > 0);
        
        
        
        address[] memory jugadores = new address[](holders.length()) ;
        
        uint nivelMaximo = 0;
        uint indice = 0;
        uint l;
        uint posicion = 1;
        
        for(uint k = 0; k< holders.length(); k = k.add(1)){
            jugadores[k] = holders.at(k);
        }
        uint aux = holders.length();
        while(aux > 0){
            nivelMaximo = 0;
            indice = 0;
            for( l = 0; l< aux; l = l.add(1)){
                
                if(score[jugadores[l]] > nivelMaximo && validated[jugadores[l]]){
                    nivelMaximo = score[jugadores[l]];
                    indice = l;
                }
                
            }
            
            /*Guardar el maximo */
           
            position[jugadores[indice]]=posicion;
            posicion = posicion.add(1);
            
            /* Borrar el maximo */
            jugadores[indice] = jugadores[aux - 1];
            aux=aux.sub(1);
        }
        
        return true;
    }

    function claim() public returns (bool){
        require(holders.contains(msg.sender), "You're not playing");
        require(!claimed[msg.sender], "You already claimed");
        require(validated[msg.sender], "Score has not been validated");
        require(position[msg.sender] > 0 && position[msg.sender] < 11 , "You are not on the TOP 10");
        
        address _holder = msg.sender;
        claimed[msg.sender] = true;
        
        if(position[_holder] == 1){
                    reward[_holder] = 5000000000000000000;
                }else if(position[_holder] == 2){
                    reward[_holder] = 3500000000000000000;
                }else if(position[_holder] == 3){
                    reward[_holder] = 2500000000000000000;
                }else if(position[_holder] > 3 && position[_holder] < 11){
                    reward[_holder] = 1000000000000000000;
                }
        uint _rewHolder = reward[_holder];
        uint _rewGamer = _rewHolder.div(100).mul(50);
        _rewHolder=_rewHolder.div(100).mul(50).add(amountToLock); //75% holder + 1 LOCKED
        
        require(Token(tokenAddress).transfer(_holder, _rewHolder), "Error sending rewards to the holder");
        require(Token(tokenAddress).transfer(player[_holder], _rewGamer), "Error sending rewards to the gamer");
      
        return true;
        
    }
    
    function getIsHolder(address dir) public view returns (bool){
        return holders.contains(dir);
    }
    

    function getNumGamers() public view returns (uint){
        return holders.length();
    }
    function isValidated(address dir) public view returns (uint){
        uint value = 0;
        if(validated[dir]){
            value = 1;
        }
        return value;
    }
    
   
    
    function getHolder(uint pos) public view returns (address){
        return holders.at(pos);
    }
    function getGamer(uint pos) public view returns (address){
        return player[holders.at(pos)];
    }
    
   
    
    function getHoldersList() public view returns (address[] memory ) {
        require (holders.length() > 0);
        uint length = holders.length();
        
        address[] memory _holders = new address[](length);
        
        for (uint i = 0; i < length; i = i.add(1)) {
            address _current = holders.at(i);
            _holders[i] = _current;
        }
        
        return (_holders);
    }
    
    
    function deletePlayer( address dir) public onlyOwner returns (bool){
        require(holders.contains(dir));
        holders.remove(dir);
        
        return true;
    }
    
    function updateScore(address dir, uint _score) public onlyOwner returns (bool){
        require(holders.contains(dir));
        require(!validated[dir]);
        
        validated[dir] = true;
        score[dir] = _score;
        
        
        return true;
    }
    
}