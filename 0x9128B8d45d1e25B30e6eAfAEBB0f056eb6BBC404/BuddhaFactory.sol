pragma solidity >=0.5.16;

/*
 * BuddhaSwapFinance
 * App:             https://pancakeswap.finance
 * Medium:          https://medium.com/@pancake_swap
 * Twitter:         https://twitter.com/pancake_swap
 * Telegram:        https://t.me/pancake_swap
 * Announcements:   https://t.me/pancake_swap_news
 * GitHub:          https://github.com/BuddhaSwapFinance
 */

import "./interfaces/IBuddhaFactory.sol";
import "./BuddhaPair.sol";

contract BuddhaFactory is IBuddhaFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH =
        keccak256(abi.encodePacked(type(BuddhaPair).creationCode));

    address public override feeTo;
    address public override feeToSetter;

    mapping(address => mapping(address => address)) public override getPair;
    address[] public override allPairs;

    // event PairCreated(address indexed token0, address indexed token1, address pair, uint256);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view override returns (uint256) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB)
        external
        override
        returns (address pair)
    {
        require(tokenA != tokenB, "BuddhaSwap: IDENTICAL_ADDRESSES");
        (address token0, address token1) =
            tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "BuddhaSwap: ZERO_ADDRESS");
        require(
            getPair[token0][token1] == address(0),
            "BuddhaSwap: PAIR_EXISTS"
        ); // single check is sufficient
        bytes memory bytecode = type(BuddhaPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IBuddhaPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external override {
        require(msg.sender == feeToSetter, "BuddhaSwap: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external override {
        require(msg.sender == feeToSetter, "BuddhaSwap: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
