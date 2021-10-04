pragma solidity ^0.6.12;

interface IThugswapFactory {
    function allPairsLength() external view returns (uint);
    function allPairs(uint) external view returns (address pair);
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
interface IThugsCollector {
    function convert(address token0, address token1) external;
}


pragma solidity ^0.6.12;
interface IThugswapPair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function balanceOf(address account) external view returns (uint);
}


pragma solidity ^0.6.12;
contract ThugsAutomatedBuyer {



    IThugswapFactory public constant TV2F = IThugswapFactory(0xaC653cE27E04C6ac565FD87F18128aD33ca03Ba2);
    IThugsCollector public constant TV2C = IThugsCollector(0x300D5a743a6339BDb1c1966979baC053E6d0119C);


    function count() public view returns (uint) {
        uint _count = 0;
        for (uint i = 0; i < TV2F.allPairsLength(); i++) {
            if (haveBalance(TV2F.allPairs(i))) {
                _count++;
            }
        }
        return _count;
    }

    function workable() public view returns (bool) {
        return count() > 0;
    }

    function workableAll(uint _count) external view returns (address[] memory) {
        return (workable(_count, 0, TV2F.allPairsLength()));
    }

    function workable(uint _count, uint start, uint end) public view returns (address[] memory) {
        address[] memory _workable = new address[](_count);
        uint index = 0;
        for (uint i = start; i < end; i++) {
            if (haveBalance(TV2F.allPairs(i))) {
                _workable[index] = TV2F.allPairs(i);
                index++;
            }
        }
        return _workable;
    }

    function haveBalance(address pair) public view returns (bool) {
        return IThugswapPair(pair).balanceOf(address(TV2C)) > 0;
    }

    function batch(IThugswapPair[] calldata pair) external {
        bool _worked = true;
        for (uint i = 0; i < pair.length; i++) {
            if (haveBalance(address(pair[i]))) {
                TV2C.convert(pair[i].token0(), pair[i].token1());
            } else {
                _worked = false;
            }
        }
    }

    function work() external{
        require(workable(),"No pairs to convert");
        // iterate and add convert all pairs with balance
        for (uint i = 0; i < TV2F.allPairsLength(); i++) {
            if (haveBalance(TV2F.allPairs(i))) {
                //Do work
                TV2C.convert(IThugswapPair(TV2F.allPairs(i)).token0(), IThugswapPair(TV2F.allPairs(i)).token1());
            }
        }
    }
}