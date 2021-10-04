// SPDX-License-Identifier: MIT

/*
 * CheeseSalad one of 3 Elite Jobs from Keep3r BSC Network
 * 2020-2021 | Keeper Network Ltd.
 */

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

interface ICheeseSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface ICheeseSwapPair {
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


library FixedPoint {
    struct uq112x112 {
        uint224 _x;
    }

    struct uq144x112 {
        uint _x;
    }

    uint8 private constant RESOLUTION = 112;


    function encode(uint112 x) internal pure returns (uq112x112 memory) {
        return uq112x112(uint224(x) << RESOLUTION);
    }

    function encode144(uint144 x) internal pure returns (uq144x112 memory) {
        return uq144x112(uint256(x) << RESOLUTION);
    }

    function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
        require(x != 0, 'FixedPoint: DIV_BY_ZERO');
        return uq112x112(self._x / uint224(x));
    }

    function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
        uint z;
        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        return uq144x112(z);
    }

    function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
        return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
    }

    function decode(uq112x112 memory self) internal pure returns (uint112) {
        return uint112(self._x >> RESOLUTION);
    }

    function decode144(uq144x112 memory self) internal pure returns (uint144) {
        return uint144(self._x >> RESOLUTION);
    }
}

library CheeseSaladLibrary {
    using FixedPoint for *;

    function currentBlockTimestamp() internal view returns (uint32) {
        return uint32(block.timestamp % 2 ** 32);
    }

    function currentCumulativePrices(
        address pair
    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
        blockTimestamp = currentBlockTimestamp();
        price0Cumulative = ICheeseSwapPair(pair).price0CumulativeLast();
        price1Cumulative = ICheeseSwapPair(pair).price1CumulativeLast();
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = ICheeseSwapPair(pair).getReserves();
        if (blockTimestampLast != blockTimestamp) {
          uint32 timeElapsed = blockTimestamp - blockTimestampLast;
          price0Cumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
          price1Cumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
        }
    }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
  function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, errorMessage);
        return c;
    }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction underflow");
    }
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      if (a == 0) {
            return 0;
        }
      uint256 c = a * b;
      require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
  function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, errorMessage);
        return c;
    }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
      return c;
    }
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library CheeseSwapLibrary {
    using SafeMath for uint;
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'CheeseSwapLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'CheeseSwapLibrary: ZERO_ADDRESS');
    }
   function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'f52c5189a89e7ca2ef4f19f2798e3900fba7a316de7cef6c5a9446621ba86286' // init code hash of CheeseSwap
            ))));
    }
  function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = ICheeseSwapPair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }
   function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'CheeseSwapLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'CheeseSwapLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }
  function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'CheeseSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CheeseSwapLibrary: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'CheeseSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'CheeseSwapLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }
   function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'CheeseSwapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }
  function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'CheeseSwapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
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
    function worked(address keeper) external;
    function KPRH() external view returns (IKeep3rbHelper);
}

interface IKeep3rbHelper {
    function getQuoteLimit(uint gasUsed) external view returns (uint);
}
// slidingOracle that uses observations collected to provide MA prices in the past
contract CheeseSalad {
    using FixedPoint for *;
    using SafeMath for uint;

    struct Observation {
        uint timestamp;
        uint price0Cumulative;
        uint price1Cumulative;
    }

    uint public minKeep = 1200e18;      //minKeep set to 1200 kp3rb

    modifier keeper() {
        require(KP3RB.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
        _;
    }

    modifier upkeep() {
        uint _gasUsed = gasleft();
        require(KP3RB.isMinKeeper(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
        _;
        uint _received = KP3RB.KPRH().getQuoteLimit(_gasUsed.sub(gasleft()));
        KP3RB.receipt(address(KP3RB), address(this), _received);
        _received = _swap(_received);
        msg.sender.transfer(_received);
    }

    address public governance;
    address public pendingGovernance;

    function setMinKeep(uint _keep) external {
        require(msg.sender == governance, "setGovernance: !gov");
        minKeep = _keep;
    }
   function setGovernance(address _governance) external {
        require(msg.sender == governance, "setGovernance: !gov");
        pendingGovernance = _governance;
    }
  function acceptGovernance() external {
        require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
        governance = pendingGovernance;
    }

    IKeep3rb public constant KP3RB = IKeep3rb(0x5EA29eEe799aA7cC379FdE5cf370BC24f2Ea7c81);
    WETH9 public constant WETH = WETH9(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    ICheeseSwapRouter public constant UNI = ICheeseSwapRouter(0x3047799262d8D2EF41eD2a222205968bC9B0d895);

    address public constant factory = 0xdd538E4Fd1b69B7863E1F741213276A6Cf1EfB3B;
    uint public constant periodSize = 900;

    /*
     * Period size reduced because BSC block time is much lower than Ethereum
     * Observation/hour increased 2x
     * In short window but more liquidity pairs
     */

    address[] internal _pairs;
    mapping(address => bool) internal _known;

    function pairs() external view returns (address[] memory) {
        return _pairs;
    }

    mapping(address => Observation[]) public observations;

    function observationLength(address pair) external view returns (uint) {
        return observations[pair].length;
    }

    function pairFor(address tokenA, address tokenB) external pure returns (address) {
        return CheeseSwapLibrary.pairFor(factory, tokenA, tokenB);
    }

    function pairForWETH(address tokenA) external pure returns (address) {
        return CheeseSwapLibrary.pairFor(factory, tokenA, address(WETH));
    }

    constructor() public {
        governance = msg.sender;
    }

    function updatePair(address pair) external keeper returns (bool) {
        return _update(pair);
    }

    function update(address tokenA, address tokenB) external keeper returns (bool) {
        address pair = CheeseSwapLibrary.pairFor(factory, tokenA, tokenB);
        return _update(pair);
    }

    function add(address tokenA, address tokenB) external {
        require(msg.sender == governance, "CheeseSwapOracle::add: !gov");
        address pair = CheeseSwapLibrary.pairFor(factory, tokenA, tokenB);
        require(!_known[pair], "known");
        _known[pair] = true;
        _pairs.push(pair);

        (uint price0Cumulative, uint price1Cumulative,) = CheeseSaladLibrary.currentCumulativePrices(pair);
        observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
    }

    function work() public upkeep {
        bool worked = _updateAll();
        require(worked, "CheeseSwapOracle: !work");
    }

    function workForFree() public keeper {
        bool worked = _updateAll();
        require(worked, "CheeseSwapOracle: !work");
    }

    function lastObservation(address pair) public view returns (Observation memory) {
        return observations[pair][observations[pair].length-1];
    }

    function _updateAll() internal returns (bool updated) {
        for (uint i = 0; i < _pairs.length; i++) {
            if (_update(_pairs[i])) {
                updated = true;
            }
        }
    }

    function updateFor(uint i, uint length) external keeper returns (bool updated) {
        for (; i < length; i++) {
            if (_update(_pairs[i])) {
                updated = true;
            }
        }
    }

    function workable(address pair) public view returns (bool) {
        return (block.timestamp - lastObservation(pair).timestamp) > periodSize;
    }

    function workable() external view returns (bool) {
        for (uint i = 0; i < _pairs.length; i++) {
            if (workable(_pairs[i])) {
                return true;
            }
        }
        return false;
    }

    function _update(address pair) internal returns (bool) {
        // we only want to commit updates once per period (i.e. windowSize / granularity)
        Observation memory _point = lastObservation(pair);
        uint timeElapsed = block.timestamp - _point.timestamp;
        if (timeElapsed > periodSize) {
            (uint price0Cumulative, uint price1Cumulative,) = CheeseSaladLibrary.currentCumulativePrices(pair);
            observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
            return true;
        }
        return false;
    }

    function computeAmountOut(
        uint priceCumulativeStart, uint priceCumulativeEnd,
        uint timeElapsed, uint amountIn
    ) private pure returns (uint amountOut) {
        // overflow is desired.
        FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
            uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
        );
        amountOut = priceAverage.mul(amountIn).decode144();
    }

    function _valid(address pair, uint age) internal view returns (bool) {
        return (block.timestamp - lastObservation(pair).timestamp) <= age;
    }

    function current(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {
        address pair = CheeseSwapLibrary.pairFor(factory, tokenIn, tokenOut);
        require(_valid(pair, periodSize.mul(2)), "CheeseSwapOracle::quote: stale prices");
        (address token0,) = CheeseSwapLibrary.sortTokens(tokenIn, tokenOut);

        Observation memory _observation = lastObservation(pair);
        (uint price0Cumulative, uint price1Cumulative,) = CheeseSaladLibrary.currentCumulativePrices(pair);
        if (block.timestamp == _observation.timestamp) {
            _observation = observations[pair][observations[pair].length-2];
        }

        uint timeElapsed = block.timestamp - _observation.timestamp;
        timeElapsed = timeElapsed == 0 ? 1 : timeElapsed;
        if (token0 == tokenIn) {
            return computeAmountOut(_observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
        } else {
            return computeAmountOut(_observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
        }
    }

    function quote(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (uint amountOut) {
        address pair = CheeseSwapLibrary.pairFor(factory, tokenIn, tokenOut);
        require(_valid(pair, periodSize.mul(granularity)), "CheeseSwapOracle::quote: stale prices");
        (address token0,) = CheeseSwapLibrary.sortTokens(tokenIn, tokenOut);

        uint priceAverageCumulative = 0;
        uint length = observations[pair].length-1;
        uint i = length.sub(granularity);


        uint nextIndex = 0;
        if (token0 == tokenIn) {
            for (; i < length; i++) {
                nextIndex = i+1;
                priceAverageCumulative += computeAmountOut(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative,
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i+1;
                priceAverageCumulative += computeAmountOut(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative,
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
            }
        }
        return priceAverageCumulative.div(granularity);
    }

    function prices(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
        return sample(tokenIn, amountIn, tokenOut, points, 1);
    }

    function sample(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) public view returns (uint[] memory) {
        address pair = CheeseSwapLibrary.pairFor(factory, tokenIn, tokenOut);
        (address token0,) = CheeseSwapLibrary.sortTokens(tokenIn, tokenOut);
        uint[] memory _prices = new uint[](points);

        uint length = observations[pair].length-1;
        uint i = length.sub(points * window);
        uint nextIndex = 0;
        uint index = 0;

        if (token0 == tokenIn) {
            for (; i < length; i+=window) {
                nextIndex = i + window;
                _prices[index] = computeAmountOut(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative,
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index + 1;
            }
        } else {
            for (; i < length; i+=window) {
                nextIndex = i + window;
                _prices[index] = computeAmountOut(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative,
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index + 1;
            }
        }
        return _prices;
    }

    function hourly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
        return sample(tokenIn, amountIn, tokenOut, points, 4);
    }

    function daily(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
        return sample(tokenIn, amountIn, tokenOut, points, 96);
    }

    function weekly(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {
        return sample(tokenIn, amountIn, tokenOut, points, 672);
    }

    function realizedVolatility(address tokenIn, uint amountIn, address tokenOut, uint points, uint window) external view returns (uint) {
        return stddev(sample(tokenIn, amountIn, tokenOut, points, window));
    }

    function realizedVolatilityHourly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
        return stddev(sample(tokenIn, amountIn, tokenOut, 1, 4));
    }

    function realizedVolatilityDaily(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
        return stddev(sample(tokenIn, amountIn, tokenOut, 1, 96));
    }

    function realizedVolatilityWeekly(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {
        return stddev(sample(tokenIn, amountIn, tokenOut, 1, 672));
    }

    function sqrt(uint256 x) public pure returns (uint256) {
        uint256 c = (x + 1) / 2;
        uint256 b = x;
        while (c < b) {
            b = c;
            c = (x / c + c) / 2;
        }
        return b;
    }

    function stddev(uint[] memory numbers) public pure returns (uint256 sd) {
        uint sum = 0;
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        uint256 mean = sum / numbers.length;        // Integral value; float not supported in Solidity
        sum = 0;
        uint i;
        for(i = 0; i < numbers.length; i++) {
            sum += (numbers[i] - mean) ** 2;
        }
        sd = sqrt(sum / (numbers.length - 1));      //Integral value; float not supported in Solidity
        return sd;
    }
    function blackScholesEstimate(
        uint256 _vol,
        uint256 _underlying,
        uint256 _time
    ) public pure returns (uint256 estimate) {
        estimate = 40 * _vol * _underlying * sqrt(_time);
        return estimate;
    }
    function retBasedBlackScholesEstimate(
        uint256[] memory _numbers,
        uint256 _underlying,
        uint256 _time
    ) public pure {
        uint _vol = stddev(_numbers);
        blackScholesEstimate(_vol, _underlying, _time);
    }

    receive() external payable {}

    function _swap(uint _amount) internal returns (uint) {
        KP3RB.approve(address(UNI), _amount);

        address[] memory path = new address[](2);
        path[0] = address(KP3RB);
        path[1] = address(WETH);

        uint[] memory amounts = UNI.swapExactTokensForTokens(_amount, uint256(0), path, address(this), block.timestamp.add(1800));
        WETH.withdraw(amounts[1]);
        return amounts[1];
    }
}