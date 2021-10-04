pragma solidity ^0.8.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


contract FlashLoaner {
    address payable private owner; // payable - can receive Ether from contract
    event Arguments(address borrowRouter, address extRouter, uint fee);

    constructor() {
        owner = payable(msg.sender);
    }

    function execute(address _sender, uint _amount0, uint _amount1, bytes calldata _data) internal {

        address borrowRouter;
        address extRouter;
        uint fee;

        (borrowRouter, extRouter, fee) = abi.decode(_data, (address, address, uint));

        emit Arguments(borrowRouter, extRouter, fee);

        require(_amount0 > 0 || _amount1 > 0, 'loaner: both amounts are empty');
        require(_amount0 == 0 || _amount1 == 0, 'loaner: both amounts are not empty');
        require(borrowRouter != address(0), 'loaner: empty borrow router');
        require(extRouter != address(0), 'loaner: empty external router');
        //require(fee >= 0, 'loaner: empty fee');

        // borrow pair
        address token0 = IPancakePair(msg.sender).token0();
        address token1 = IPancakePair(msg.sender).token1();

        uint amountToken = _amount0 == 0 ? _amount1 : _amount0;

        // обмен во внешней паре
        address[] memory path = new address[](2);
        address[] memory path1 = new address[](2);

        // path - borrowToken -> payToken
        // path1 - payToken -> borrowToken
        path[0] = path1[1] = _amount0 == 0 ? token1 : token0;
        path[1] = path1[0] = _amount0 == 0 ? token0 : token1;

        IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);

        token.approve(address(extRouter), amountToken);

        // no need for require() check, if amount required is not sent bakeryRouter will revert
        uint amountRequired = IPancakeRouter02(borrowRouter).getAmountsIn(amountToken, path1)[0];

        uint amountReceived = IPancakeRouter02(extRouter).swapExactTokensForTokens(
            amountToken,
            amountRequired,
            path,
            address(this),
            block.timestamp + 180
        )[1];

        require(amountReceived > amountRequired, "loaner: no profit");
        require((amountReceived - amountRequired) > fee, "loaner: profit is less than fee");

        // do not use this variable - avoid stack too deep error
        //IERC20 otherToken = IERC20(_amount0 == 0 ? token0 : token1);

        // send back borrow
        IERC20(_amount0 == 0 ? token0 : token1).transfer(msg.sender, amountRequired);
        // our win
        IERC20(_amount0 == 0 ? token0 : token1).transfer(owner, amountReceived - amountRequired);

    }

    // mdex
    function swapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function BiswapCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function AlitaSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function aliumCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function annexCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function babyCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function berryCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function bourbonCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function boxswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function BscsswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function BSCswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);}

    function cafeCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function cheeseswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function coinswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function corgiSCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function definixCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function demaxCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function dinoCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function elkCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function fatAnimalCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function foodcourtCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function gibxCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function infinityCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function jetswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function latteSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function manyswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function MOKCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function NarwhalswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function NimbusCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function oniCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function orionpoolV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function pancakeCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function pancakeForkCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function pantherCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function pinkswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function planetCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function pokemoonCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);}

    function rimauCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function safeswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function seedCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function shibaCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);}

    function soccerCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function sparkswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function stableXCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function ThugswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function twindexswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function wardenCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function waultSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function yetuswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function YieldFieldsCall(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }

    function YouSwapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
        execute(sender, amount0, amount1, data);
    }
}