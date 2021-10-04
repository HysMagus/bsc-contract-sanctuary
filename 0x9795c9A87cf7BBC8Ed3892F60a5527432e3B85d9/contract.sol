pragma solidity ^0.6.12;


interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IValueLiquidPair is IERC20 {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IVoteProxy {
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _voter) external view returns (uint256);
}

interface IMasterChef {
    function userInfo(uint256, address)
    external
    view
    returns (uint256, uint256);
}

contract MDGVoteProxyImpl is IVoteProxy {
    // MDG token
    IERC20  public constant MDG = IERC20(
        0xC1eDCc306E6faab9dA629efCa48670BE4678779D
    );

    // MDGChef contract
    IMasterChef public constant chef = IMasterChef(
        0x8f0A813D39F019a2A98958eDbf5150d3a06Cd20f
    );

    function decimals() public override virtual pure returns (uint8) {
        return 18;
    }

    function totalSupply() public override virtual view returns (uint256) {
        return MDG.totalSupply();
    }

    function getTokenInPair(uint256 lpAmount, address token, IValueLiquidPair pair) public view returns (uint256) {
        uint256 amount = 0;
        uint256 supply = pair.totalSupply();
        (uint112 r0, uint112 r1,) = pair.getReserves();
        if (pair.token0() == token) {
            return r0 * lpAmount / supply;
        } else if (pair.token1() == token) {
            return r1 * lpAmount / supply;
        }
        return 0;
    }

    function getTokenInMasterChef(uint256 pid, IMasterChef chef, address user) public view returns (uint256) {
        (uint256 amount,) = chef.userInfo(pid, user);
        return amount;
    }

    function getTokenInPairMasterChef(uint256 pid, IMasterChef chef, address user, address token, IValueLiquidPair pair) public view returns (uint256) {
        return getTokenInPair(getTokenInMasterChef(pid, chef, user), token, pair);
    }

    function getTokenBalanceInPair(address user, address token, IValueLiquidPair pair) public view returns (uint256) {
        return getTokenInPair(IERC20(pair).balanceOf(user), token, pair);
    }

    function balanceOfDetail(address _voter) public view returns (uint256 balance, uint256 mdgbnbStake, uint256 mdgbnb, uint256 mdgmdoStake, uint256 mdgmdo, uint256 mdgbusdStake, uint256 mdgbusd, uint256 mdgStake) {

        balance = MDG.balanceOf(_voter);

        IValueLiquidPair mdgbnbPair = IValueLiquidPair(0x5D69a0e5E91d1E66459A76Da2a4D8863E97cD90d);
        mdgbnbStake = getTokenInPairMasterChef(0, chef, _voter, address(MDG), mdgbnbPair);
        mdgbnb = getTokenBalanceInPair(_voter, address(MDG), mdgbnbPair);

        IValueLiquidPair mdgmdoPair = IValueLiquidPair(0x1E1916B3FADcCB6c73FA938C91300c70A486276C);
        mdgmdoStake = getTokenInPairMasterChef(4, chef, _voter, address(MDG), mdgmdoPair);
        mdgmdo = getTokenBalanceInPair(_voter, address(MDG), mdgmdoPair);

        IValueLiquidPair mdgbusdPair = IValueLiquidPair(0xB10C30f83eBb92F5BaEf377168C4bFc9740d903c);
        mdgbusdStake = getTokenInPairMasterChef(5, chef, _voter, address(MDG), mdgbusdPair);
        mdgbusd = getTokenBalanceInPair(_voter, address(MDG), mdgbusdPair);
        mdgStake = getTokenInMasterChef(8, chef, _voter);
    }

    function balanceOf(address _voter) public override virtual view returns (uint256) {
        (uint256 balance,uint256 mdgbnbStake,uint256 mdgbnb,uint256 mdgmdoStake,uint256 mdgmdo,uint256 mdgbusdStake,uint256 mdgbusd,uint256 mdgStake) = balanceOfDetail(_voter);
        return balance + mdgbnbStake + mdgbnb + mdgmdoStake + mdgmdo + mdgbusdStake + mdgbusd + mdgStake;
    }
}