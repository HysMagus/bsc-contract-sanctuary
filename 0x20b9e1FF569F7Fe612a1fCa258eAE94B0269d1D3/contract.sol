// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.0/contracts/access/Ownable.sol

pragma solidity ^0.6.0;

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
contract Ownable is Context {
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

// File: browser/VaultKeep3r.sol

pragma solidity 0.6.12;


interface Strategy {
    function harvest() external;
}
interface VaultProfiter {
    function unpool() external;
}


// SPDX-License-Identifier: MIT
contract VaultKeep3r is Ownable {
    Strategy[] strategies;
    VaultProfiter public profiter;

    mapping(Strategy => bool) public active;
    mapping(Strategy => uint) public harvestInterval;
    mapping(Strategy => uint) public lastHarvest;
    
    constructor(address _profiter) public {
        //Add taco vault Strategy
        addStrategy(Strategy(0x33aC5a9d27b99D5030f484cfC7143f6974A07ebe),1 hours);
        //Add Smoke vault Strategy
        addStrategy(Strategy(0xE100A32E180363D2cC948Eca2cF967930C12DBC0),1 hours);
        //set profiter
        profiter = VaultProfiter(_profiter);
    }

    /* View functions to get strat and harvestable data */

    function getStrategies() external view returns (Strategy[] memory) {
        return strategies;
    }

    function getActiveStrategiesCount() public view returns(uint count) {
        for(uint i=0;i<strategies.length;i++) {
            if(active[strategies[i]]) {
                count++;
            }
        }
    }

    function getActiveStrategies() external view returns (Strategy[] memory activeStrats){
        activeStrats = new Strategy[](getActiveStrategiesCount());
        uint index = 0;
        for(uint i=0;i<strategies.length;i++) {
            if(active[strategies[i]]) {
                activeStrats[index] = strategies[i];
                index++;
            }
        }
    }

    function getHarvestableStrategiesCount() public view returns (uint count) {
        for(uint i=0;i<strategies.length;i++) {
            Strategy currStrat = strategies[i];
            if(active[currStrat]  && lastHarvest[currStrat] + harvestInterval[currStrat] <= block.timestamp) {
                count++;
            }
        }
    }

    function getHarvestableStrategies() external view returns (Strategy[] memory harvestableStrats) {
        harvestableStrats = new Strategy[](getHarvestableStrategiesCount());
        uint index=0;
        for(uint i=0;i<strategies.length;i++) {
            Strategy currStrat = strategies[i];
            if(active[currStrat]  && lastHarvest[currStrat] + harvestInterval[currStrat] <= block.timestamp) {
                //Add to harvestable
                harvestableStrats[index] = currStrat;
                index++;
            }
        }
    }

    /* Admin management functions */

    function setProfiter(address _newProfiter) external onlyOwner {
        profiter = VaultProfiter(_newProfiter);
    }

    function addStrategy(Strategy _strat,uint _harvestInterval) public onlyOwner {
        strategies.push(_strat);
        active[_strat] = true;
        harvestInterval[_strat] = _harvestInterval;
    }

    function activateStrat(Strategy _strat) external onlyOwner {
        active[_strat] = true;
    }

    function removeStrategy(Strategy _strat) external onlyOwner {
        active[_strat] = false;
        harvestInterval[_strat] = 0;
    }

    function updateHarvestInterval(Strategy _strat,uint _newInterval) external onlyOwner {
        harvestInterval[_strat] = _newInterval;
    }

    /*Harvest and take profit section */
    function harvestVaults(Strategy[] memory harvestableStrats) external onlyOwner {
        for(uint i=0;i<harvestableStrats.length;i++) {
            harvestableStrats[i].harvest();
            lastHarvest[harvestableStrats[i]] = block.timestamp;
        }
        //Once we are done with the harvests,convert profits to bnb
        if(address(profiter) != address(0)) profiter.unpool();
    }

}