pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


pragma solidity 0.6.12;


contract Basic is Ownable {
    mapping(address => bool) public mod;
    mapping(address => bool) public support;
    
    modifier onlyMod() {
        require(mod[msg.sender] || msg.sender == owner(), "Must be mod");
        _;
    }

    modifier onlySupport() {
        require(support[msg.sender] || msg.sender == owner(), "Must be support");
        _;
    }    

    function addMod(address _mod) public onlyOwner {
        if (_mod != address(0x0) && _mod != address(0)) {
            mod[_mod] = true;
        }
    }

    function addSupport(address _support) public onlyOwner {
        if (_support != address(0x0) && _support != address(0)) {
            support[_support] = true;
        }
    }    

    function removeMod(address _mod) public onlyOwner {
        if (mod[_mod]) {
            mod[_mod] = false;
        }
    }

    function removeSupport(address _support) public onlyOwner {
        if (support[_support]) {
            support[_support] = false;
        }
    }    

    constructor() public Ownable() {}
}


// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;


contract Members is Basic {
    struct MemberStruct {
        bool isExist;
        uint256 id;
        uint256 referrerID;
        uint256 referredUsers;
        uint256 time;
    }
    mapping(address => MemberStruct) public members;
    mapping(uint256 => address) public membersList;
    mapping(uint256 => mapping(uint256 => address)) public memberChild;
    uint256 public lastMember;

    constructor() public {}

    function isMember(address _user) public view returns (bool) {
        return members[_user].isExist;
    }

    function addMember(address _member, address _parent) public onlyMod {
        if (lastMember > 0) {
            require(members[_parent].isExist, "Sponsor not exist");
        }
        MemberStruct memory memberStruct;
        memberStruct = MemberStruct({
            isExist: true,
            id: lastMember,
            referrerID: members[_parent].id,
            referredUsers: 0,
            time: now
        });
        members[_member] = memberStruct;
        membersList[lastMember] = _member;
        memberChild[members[_parent].id][
            members[_parent].referredUsers
        ] = _member;
        members[_parent].referredUsers++;
        lastMember++;
    }

    function infoMember(address _member)
        public
        view
        returns (
            bool isExist,
            uint256 id,
            uint256 referrerID,
            uint256 referredUsers,
            uint256 time
        )
    {
        MemberStruct memory member = members[_member];
        return (
            member.isExist,
            member.id,
            member.referrerID,
            member.referredUsers,
            member.time
        );
    }

    function getParentTree(address _member, uint256 _deep)
        public
        view
        returns (address[] memory)
    {
        address[] memory parentTree = new address[](_deep);
        address referrerLevel = membersList[members[_member].referrerID];
        if (referrerLevel != address(0)) {
            parentTree[0] = referrerLevel;
        }
        for (uint256 i = 1; i < _deep; i++) {
            if (referrerLevel != address(0)) {
                referrerLevel = getUserReferrerLast(referrerLevel);
                if (referrerLevel != address(0)) {
                    parentTree[i] = referrerLevel;
                }
            } else {
                break;
            }
        }
        return parentTree;
    }

    function getUserReferrerLast(address _user) public view returns (address) {
        return membersList[members[_user].referrerID];
    }
}