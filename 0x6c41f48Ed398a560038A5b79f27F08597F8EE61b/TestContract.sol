pragma solidity >=0.6.4;

import './SafeMath.sol';
import './IBurger.sol';
import './IBakerySwapPair.sol';
import './IRouter.sol';


contract TestContract {
    using SafeMath for uint256;

    address constant public BNBADDR = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address constant public USDTADDR = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    address constant public bakeryFactory = 0x01bF7C66c6BD861915CdaaE475042d3c4BaE16A7;
    address constant public bakeryRouter = 0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F;

    address constant public burgerPlatform = 0x75Ca8F6c82df5FdFd09049f46AD5d072b0a53BF6;


    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only ownerr");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function tryProfit(uint256 amount, uint8 direction) onlyOwner external returns(uint256 finalAmount){
        address[] memory path = new address[](2);
        if (direction == 1){
            path[0] = BNBADDR;
            path[1] = USDTADDR;
            uint256[] memory amountTmps1 = IRouter(bakeryRouter).swapExactTokensForTokens(amount, 0, path, msg.sender, block.timestamp+1);

            path[0] = USDTADDR;
            path[1] = BNBADDR;
            uint256[] memory amountTmps2 = IRouter(burgerPlatform).swapExactTokensForTokens(amountTmps1[1], 0, path, msg.sender, block.timestamp+1);
            require(amountTmps2[1] > amount, "no profit");
            return (amountTmps2[1]-amount);
        }else if(direction ==2){
            path[0] = USDTADDR;
            path[1] = BNBADDR;
            uint256[] memory amountTmps1 = IRouter(bakeryRouter).swapExactTokensForTokens(amount, 0, path, msg.sender, block.timestamp+1);
            path[0] = BNBADDR;
            path[1] = USDTADDR;
            uint256[] memory amountTmps2 = IRouter(burgerPlatform).swapExactTokensForTokens(amountTmps1[1], 0, path, msg.sender, block.timestamp+1);
            require(amountTmps2[1] > amount, "no profit");
            return (amountTmps2[1]-amount);
        }
        return 0;
    }


    function hasProfit() external view returns (bool, uint256, uint256){
        address[] memory path = new address[](2);
        path[0] = BNBADDR;
        path[1] = USDTADDR;
        uint256 amountTmp = getBakeryAmountsOut(1 ether,path);
        path[0] = USDTADDR;
        path[1] = BNBADDR;
        amountTmp = getBurgerAmountsOut(amountTmp,path);
        if (amountTmp >= 1.01 ether){
            return (true, amountTmp-1 ether, 1);
        }
        if (amountTmp > 1 ether){
            return (false, amountTmp-1 ether, 1);
        }
        uint256 amountTmp1 = amountTmp;
        path[0] = USDTADDR;
        path[1] = BNBADDR;
        amountTmp = getBakeryAmountsOut(10 ether,path);
        path[0] = BNBADDR;
        path[1] = USDTADDR;
        amountTmp = getBurgerAmountsOut(amountTmp,path);
        if (amountTmp >= 10.1 ether){
            return (true, amountTmp-10.1 ether, 2);
        }

        if (amountTmp > 10 ether){
            return (false, amountTmp-10 ether, 2);
        }
        return (false, amountTmp1,amountTmp);
    }


    // ============ burger amount ========
    function getBurgerAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256 amounts) {
        uint256[] memory amountOuts = IBurger(burgerPlatform).getAmountsOut(amountIn, path);
        return amountOuts[path.length-1];
    }

    // ============ Bakery amount ========
    function getBakeryAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256 amount) {
        require(path.length >= 2, 'BakerySwapLibrary: INVALID_PATH');
        uint256[] memory amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            (uint256 reserveIn, uint256 reserveOut) = getBakeryReserves(path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
        return amounts[path.length - 1];
    }

    // fetches and sorts the reserves for a pair
    function getBakeryReserves(
        address tokenA,
        address tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (address token0, ) = sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1, ) = IBakerySwapPair(pairFor(tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, 'BakerySwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'BakerySwapLibrary: INSUFFICIENT_LIQUIDITY');
        uint256 amountInWithFee = amountIn.mul(997);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'BakerySwapLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'BakerySwapLibrary: ZERO_ADDRESS');
    }

    function pairFor(
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex'ff',
                        bakeryFactory,
                        keccak256(abi.encodePacked(token0, token1)),
                        hex'e2e87433120e32c4738a7d8f3271f3d872cbe16241d67537139158d90bac61d3' // init code hash
                    )
                )
            )
        );
    }
}