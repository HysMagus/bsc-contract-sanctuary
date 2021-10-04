// SPDX-License-Identifier: MIT




pragma solidity ^0.5.17;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "add: +");

        return c;
    }
    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "sub: -");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
}

interface IKeep3rb {
    function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool);
    function receipt(address credit, address keeper, uint amount) external;
    function unbond(address bonding, uint amount) external;
    function withdraw(address bonding) external;
    function bonds(address keeper, address credit) external view returns (uint);
    function unbondings(address keeper, address credit) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function jobs(address job) external view returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface WETH9 {
    function withdraw(uint wad) external;
}

interface ICheeseSwapRouter {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IKeep3rbJob {
    function work() external;
}

contract MetaKeep3rb {
    using SafeMath for uint;
    
    modifier upkeep() {
        require(KP3RB.isMinKeeper(msg.sender, 100e18, 0, 0), "MetaKeep3rb::isKeeper: keeper is not registered");
        uint _before = KP3RB.bonds(address(this), address(KP3RB));
        _;
        uint _after = KP3RB.bonds(address(this), address(KP3RB));
        uint _received = _after.sub(_before);
        uint _balance = KP3RB.balanceOf(address(this));
        if (_balance < _received) {
            KP3RB.receipt(address(KP3RB), address(this), _received.sub(_balance));
        }
        _received = _swap(_received);
        msg.sender.transfer(_received);
    }
    
    function task(address job, bytes calldata data) external upkeep {
        require(KP3RB.jobs(job), "MetaKeep3rb::work: invalid job");
        (bool success,) = job.call.value(0)(data);
        require(success, "MetaKeep3rb::work: job failure");
    }
    
    function work(address job) external upkeep {
        require(KP3RB.jobs(job), "MetaKeep3rb::work: invalid job");
        IKeep3rbJob(job).work();
    }
    
    IKeep3rb public constant KP3RB = IKeep3rb(0x1092E4F72a9D7a28418351D029e273906aF24797);
    WETH9 public constant WETH = WETH9(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    ICheeseSwapRouter public constant CHS = ICheeseSwapRouter(0x3047799262d8D2EF41eD2a222205968bC9B0d895);
    
    function unbond() external {
        require(KP3RB.unbondings(address(this), address(KP3RB)) < now, "MetaKeep3rb::unbond: unbonding");
        KP3RB.unbond(address(KP3RB), KP3RB.bonds(address(this), address(KP3RB)));
    }
    
    function withdraw() external {
        KP3RB.withdraw(address(KP3RB));
        KP3RB.unbond(address(KP3RB), KP3RB.bonds(address(this), address(KP3RB)));
    }
    
    function() external payable {}
    
    function _swap(uint _amount) internal returns (uint) {
        KP3RB.approve(address(CHS), _amount);
        
        address[] memory path = new address[](2);
        path[0] = address(KP3RB);
        path[1] = address(WETH);

        uint[] memory amounts = CHS.swapExactTokensForTokens(_amount, uint256(0), path, address(this), now.add(1800));
        WETH.withdraw(amounts[1]);
        return amounts[1];
    }
}