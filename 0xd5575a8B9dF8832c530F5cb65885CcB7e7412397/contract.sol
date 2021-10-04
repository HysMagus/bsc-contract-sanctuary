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

interface IVault {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
    function getPricePerFullShare() external view returns (uint256);
}

contract gvValueVoteProxyImpl is IVoteProxy {
    // gvVALUE-BBUSD token
    IValueLiquidPair public constant gvValueBBUSDPair = IValueLiquidPair(
        0xf98313f818c53E40Bd758C5276EF4B434463Bec4
    );
    // gvValue token
    IERC20 public constant gvValue = IERC20(
        0x0610C2d9F6EbC40078cf081e2D1C4252dD50ad15
    );

    // gvValueChef contract
    IMasterChef public constant chef = IMasterChef(
        0xd56339F80586c08B7a4E3a68678d16D37237Bd96
    );
    IVault public constant vault = IVault(
        0x58d3E700c52E3e013908a1f0037bdD1c6d262637
    );

    function decimals() public override virtual pure returns (uint8) {
        return 18;
    }

    function totalSupply() public override virtual view returns (uint256) {
        return gvValue.totalSupply();
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

    function balanceOfDetail(address _voter) public virtual view returns (
        uint256 balance,
        uint256 gvValueBBUSDStake,
        uint256 gvValueBBUSD,
        uint256 gvValueBBUSDVault
    ) {
        balance = gvValue.balanceOf(_voter);


        gvValueBBUSDStake = getTokenInPairMasterChef(4, chef, _voter, address(gvValue), gvValueBBUSDPair);
        gvValueBBUSD = getTokenBalanceInPair(_voter, address(gvValue), gvValueBBUSDPair);

        uint256 vaultBalance = vault.balanceOf(_voter) * vault.getPricePerFullShare() / 1e18;
        gvValueBBUSDVault = getTokenInPair(vaultBalance, address(gvValue), gvValueBBUSDPair);
    }

    function balanceOf(address _voter) public override virtual view returns (uint256) {
        (uint256 balance,
        uint256 gvValueBBUSDStake,
        uint256 gvValueBBUSD,
        uint256 gvValueBBUSDVault) = balanceOfDetail(_voter);
        return balance + gvValueBBUSDStake + gvValueBBUSD + gvValueBBUSDVault;
    }
}