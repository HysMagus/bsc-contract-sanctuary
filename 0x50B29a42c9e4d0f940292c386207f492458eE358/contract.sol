// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/EnumerableSet.sol


pragma solidity ^0.6.0;

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

// File: contracts/interfaces/IGoSwapFactory.sol

pragma solidity >=0.5.0;

interface IGoSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function migrator() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
    function setMigrator(address) external;
    function pairCodeHash() external pure returns (bytes32);
}

// File: contracts/interfaces/IGoSwapCompany.sol

pragma solidity >=0.5.0;

interface IGoSwapCompany {
    function factory() external pure returns (address);
    function pairForFactory(address tokenA, address tokenB) external pure returns (address);
    function createPair(address tokenA, address tokenB) external returns (address);
}

// File: contracts/libraries/AdminRole.sol

pragma solidity >=0.5.0;


contract AdminRole{
    using EnumerableSet for EnumerableSet.AddressSet;
    /// @dev 管理员set
    EnumerableSet.AddressSet private _admins;

    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);

    /**
     * @dev 构造函数
     */
    constructor () internal {
        _addAdmin(msg.sender);
    }

    /**
     * @dev 修改器:只能通过管理员调用
     */
    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "AdminRole: caller does not have the Admin role");
        _;
    }

    /**
     * @dev 判断是否是管理员
     * @param account 帐号地址
     * @return 是否是管理员
     */
    function isAdmin(address account) public view returns (bool) {
        return _admins.contains(account);
    }

    /**
     * @dev 返回所有管理员
     * @return admins 管理员数组
     */
    function allAdmins() public view returns (address[] memory admins) {
        admins = new address[](_admins.length());
        for(uint256 i=0;i<_admins.length();i++){
            admins[i] = _admins.at(i);
        }
    }

    /**
     * @dev 添加管理员
     * @param account 帐号地址
     */
    function addAdmin(address account) public onlyAdmin {
        _addAdmin(account);
    }

    /**
     * @dev 移除管理员
     * @param account 帐号地址
     */
    function removeAdmin(address account) public onlyAdmin {
        _removeAdmin(account);
    }

    /**
     * @dev 撤销管理员
     */
    function renounceAdmin() public {
        _removeAdmin(msg.sender);
    }

    /**
     * @dev 私有添加管理员
     * @param account 帐号地址
     */
    function _addAdmin(address account) internal {
        _admins.add(account);
        emit AdminAdded(account);
    }

    /**
     * @dev 私有移除管理员
     * @param account 帐号地址
     */
    function _removeAdmin(address account) internal {
        _admins.remove(account);
        emit AdminRemoved(account);
    }
}

// File: contracts/GoSwapCompany.sol

pragma solidity =0.6.12;





contract GoSwapCompany is AdminRole, IGoSwapCompany {
    using EnumerableSet for EnumerableSet.AddressSet;
    /// @notice 当前工厂合约
    address public override factory;
    /// @dev 工厂合约列表
    EnumerableSet.AddressSet private factorys;

    /// @notice 配对寻找工厂的映射,地址=>(地址=>地址)
    mapping(address => mapping(address => address)) public override pairForFactory;

    /**
     * @dev 创建配对
     * @param tokenA TokenA
     * @param tokenB TokenB
     * @return pair 配对地址
     */
    function createPair(address tokenA, address tokenB) external override returns (address pair) {
        // 确认token没有过对应的工厂,或者是管理员创建的配对,可以强制更新工厂合约
        require(pairForFactory[tokenA][tokenB] == address(0) || isAdmin(msg.sender), 'GoSwap: PAIR_EXISTS');
        // 调用工厂合约的创建配对方法
        pair = IGoSwapFactory(factory).createPair(tokenA, tokenB);
        // 记录token对应的工厂合约地址
        pairForFactory[tokenA][tokenB] = factory;
        pairForFactory[tokenB][tokenA] = factory;
    }

    /**
     * @dev 设置新工厂合约
     * @param _factory 新工厂合约地址
     */
    function setNewFactory(address _factory) public onlyAdmin {
        require(!factorys.contains(_factory), 'factory exist!');
        factorys.add(_factory);
        factory = _factory;
    }

    /**
     * @dev 返回工厂合约数量
     * @return 工厂合约数量
     */
    function factoryLength() public view returns (uint256) {
        return factorys.length();
    }

    /**
     * @dev 根据索引查询工厂合约地址
     * @param index 索引
     * @return 工厂合约地址
     */
    function getFactoryByIndex(uint256 index) public view returns (address) {
        return factorys.at(index);
    }
}