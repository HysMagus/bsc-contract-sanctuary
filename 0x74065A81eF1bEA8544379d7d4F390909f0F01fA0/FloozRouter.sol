pragma solidity =0.6.6;

// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@0x/contracts-utils/contracts/src/v06/LibBytesV06.sol";
import "./libraries/TransferHelper.sol";
import "./libraries/PancakeLibrary.sol";
import "./interfaces/IReferralRegistry.sol";
import "./interfaces/IReferrals.sol";
import "./interfaces/IWETH.sol";
import "./interfaces/IZerox.sol";

contract TestRouter is Ownable, Pausable {
    using SafeMath for uint256;
    using LibBytesV06 for bytes;
    event SwapFeeUpdated(uint16 swapFee);
    event ReferralRegistryUpdated(address referralRegistry);
    event ReferralRewardRateUpdated(uint16 referralRewardRate);
    event ReferralsActivatedUpdated(bool activated);
    event FeeReceiverUpdated(address payable feeReceiver);
    event BalanceThresholdUpdated(uint256 balanceThreshold);
    event CustomReferralRewardRateUpdated(address indexed account, uint16 referralRate);
    event ReferralRewardPaid(address from, address indexed to, address tokenOut, address tokenReward, uint256 amount);
    event FeePaid(address token, uint256 amount);
    event ForkCreated(address factory);
    event ForkUpdated(address factory);

    uint256 public constant FEE_DENOMINATOR = 10000;
    address public immutable WETH;
    IReferralRegistry public referralRegistry;
    IERC20 public saveYourAssetsToken;
    uint256 public balanceThreshold;
    address payable public feeReceiver;
    uint16 public swapFee;
    uint16 public referralRewardRate;
    bool public referralsActivated;
    address payable public immutable zeroEx;

    // stores individual referral rates
    mapping(address => uint16) public customReferralRewardRate;

    // stores fork informations
    mapping(address => bool) public forkActivated;
    mapping(address => bytes) public forkInitCode;

    modifier isValidFork(address factory) {
        require(forkActivated[factory], "FloozRouter: invalid factory");
        _;
    }

    modifier isValidReferee(address referee) {
        require(msg.sender != referee, "FloozRouter: self referral");
        _;
    }

    constructor(
        address _WETH,
        uint16 _swapFee,
        uint16 _referralRewardRate,
        address payable _feeReceiver,
        uint256 _balanceThreshold,
        IERC20 _saveYourAssetsToken,
        IReferralRegistry _referralRegistry,
        address payable _zeroEx
    ) public {
        WETH = _WETH;
        swapFee = _swapFee;
        referralRewardRate = _referralRewardRate;
        feeReceiver = _feeReceiver;
        saveYourAssetsToken = _saveYourAssetsToken;
        balanceThreshold = _balanceThreshold;
        referralsActivated = true;
        referralRegistry = _referralRegistry;
        zeroEx = _zeroEx;
    }

    receive() external payable {}

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(
        address factory,
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) internal {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = PancakeLibrary.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOut) : (amountOut, uint256(0));
            address to = i < path.length - 2 ? _pairFor(factory, output, path[i + 2]) : _to;
            IPancakePair(_pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactETHForTokens(
        address factory,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external payable whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        require(path[0] == WETH, "FloozRouter: INVALID_PATH");
        referee = _getReferee(referee);
        (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(msg.value, referee, false);
        amounts = _getAmountsOut(factory, swapAmount, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(WETH).deposit{value: swapAmount}();
        assert(IWETH(WETH).transfer(_pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(factory, amounts, path, msg.sender);

        if (feeAmount > 0) {
            _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);
        }
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(
        address factory,
        address[] memory path,
        address _to
    ) internal {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = PancakeLibrary.sortTokens(input, output);
            IPancakePair pair = IPancakePair(_pairFor(factory, input, output));
            uint256 amountInput;
            uint256 amountOutput;
            {
                // scope to avoid stack too deep errors
                (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
                (uint256 reserveInput, uint256 reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
                amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
                amountOutput = _getAmountOut(amountInput, reserveInput, reserveOutput);
            }
            (uint256 amount0Out, uint256 amount1Out) = input == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
            address to = i < path.length - 2 ? _pairFor(factory, output, path[i + 2]) : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        address factory,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) {
        require(path[path.length - 1] == WETH, "FloozRouter: ETH has to be the last path item");
        referee = _getReferee(referee);
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), amountIn);
        _swapSupportingFeeOnTransferTokens(factory, path, address(this));
        uint256 amountOut = IERC20(WETH).balanceOf(address(this));
        require(amountOut >= amountOutMin, "FloozRouter: slippage setting to low");
        IWETH(WETH).withdraw(amountOut);
        (uint256 amountWithdraw, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(amountOut, referee, false);
        TransferHelper.safeTransferETH(msg.sender, amountWithdraw);

        if (feeAmount > 0) _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapExactTokensForTokens(
        address factory,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        referee = _getReferee(referee);
        (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(amountIn, referee, false);
        amounts = _getAmountsOut(factory, swapAmount, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), amounts[0]);
        _swap(factory, amounts, path, msg.sender);

        if (feeAmount > 0) _withdrawFeesAndRewards(path[0], path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapExactTokensForETH(
        address factory,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == WETH, "FloozRouter: INVALID_PATH");
        referee = _getReferee(referee);
        amounts = _getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), amounts[0]);
        _swap(factory, amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        (uint256 amountOut, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(
            amounts[amounts.length - 1],
            referee,
            false
        );
        TransferHelper.safeTransferETH(msg.sender, amountOut);

        if (feeAmount > 0) _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapETHForExactTokens(
        address factory,
        uint256 amountOut,
        address[] calldata path,
        address referee
    ) external payable whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        require(path[0] == WETH, "FloozRouter: INVALID_PATH");
        referee = _getReferee(referee);
        amounts = _getAmountsIn(factory, amountOut, path);
        (, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(amounts[0], referee, false);
        require(amounts[0].add(feeAmount).add(referralReward) <= msg.value, "FloozRouter: EXCESSIVE_INPUT_AMOUNT");
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(_pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(factory, amounts, path, msg.sender);

        if (feeAmount > 0) _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);

        // refund dust eth, if any
        if (msg.value > amounts[0].add(feeAmount).add(referralReward))
            TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0].add(feeAmount).add(referralReward));
    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        address factory,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) {
        referee = _getReferee(referee);
        (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(amountIn, referee, false);
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), swapAmount);
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(msg.sender);
        _swapSupportingFeeOnTransferTokens(factory, path, msg.sender);
        require(
            IERC20(path[path.length - 1]).balanceOf(msg.sender).sub(balanceBefore) >= amountOutMin,
            "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );

        if (feeAmount > 0) _withdrawFeesAndRewards(path[0], path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapTokensForExactTokens(
        address factory,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        referee = _getReferee(referee);
        amounts = _getAmountsIn(factory, amountOut, path);
        (, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(amounts[0], referee, false);
        require(amounts[0].add(feeAmount).add(referralReward) <= amountInMax, "FloozRouter: EXCESSIVE_INPUT_AMOUNT");
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), amounts[0]);
        _swap(factory, amounts, path, msg.sender);

        if (feeAmount > 0) _withdrawFeesAndRewards(path[0], path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapTokensForExactETH(
        address factory,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address referee
    ) external whenNotPaused isValidFork(factory) isValidReferee(referee) returns (uint256[] memory amounts) {
        require(path[path.length - 1] == WETH, "FloozRouter: INVALID_PATH");
        referee = _getReferee(referee);
        amounts = _getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, "FloozRouter: EXCESSIVE_INPUT_AMOUNT");
        TransferHelper.safeTransferFrom(path[0], msg.sender, _pairFor(factory, path[0], path[1]), amounts[0]);
        _swap(factory, amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(
            amounts[amounts.length - 1],
            referee,
            false
        );

        TransferHelper.safeTransferETH(msg.sender, swapAmount);
        if (feeAmount > 0) _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);
    }

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        address factory,
        uint256 amountOutMin,
        address[] calldata path,
        address referee
    ) external payable whenNotPaused isValidFork(factory) isValidReferee(referee) {
        require(path[0] == WETH, "FloozRouter: INVALID_PATH");
        referee = _getReferee(referee);
        (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(msg.value, referee, false);
        IWETH(WETH).deposit{value: swapAmount}();
        assert(IWETH(WETH).transfer(_pairFor(factory, path[0], path[1]), swapAmount));
        uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(msg.sender);
        _swapSupportingFeeOnTransferTokens(factory, path, msg.sender);
        require(
            IERC20(path[path.length - 1]).balanceOf(msg.sender).sub(balanceBefore) >= amountOutMin,
            "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT"
        );
        if (feeAmount > 0) _withdrawFeesAndRewards(address(0), path[path.length - 1], referee, feeAmount, referralReward);
    }

    function _getReferee(address referee) internal returns (address) {
        address sender = msg.sender;
        if (!referralRegistry.hasUserReferee(sender) && referee != address(0)) {
            referralRegistry.createReferralAnchor(sender, referee);
        }
        return referralRegistry.getUserReferee(sender);
    }

    function _calculateFeesAndRewards(
        uint256 amount,
        address referee,
        bool reverseCalculation
    )
        internal
        view
        returns (
            uint256 swapAmount,
            uint256 feeAmount,
            uint256 referralReward
        )
    {
        if (userAboveBalanceThreshold(msg.sender)) {
            referralReward = 0;
            feeAmount = 0;
            swapAmount = amount;
        } else {
            uint256 fees;
            if (reverseCalculation) {
                // assumes amount already includes fee
                swapAmount = amount.mul(FEE_DENOMINATOR).div(FEE_DENOMINATOR.add(swapFee));
                fees = amount.sub(swapAmount);
            } else {
                // assumes swap amount without fees is provided and adds x fee
                fees = amount.mul(swapFee).div(FEE_DENOMINATOR);
                swapAmount = amount.sub(fees);
            }
            if (referee != address(0) && referralsActivated) {
                uint16 referralRate = customReferralRewardRate[referee] > 0 ? customReferralRewardRate[referee] : referralRewardRate;
                referralReward = fees.mul(referralRate).div(FEE_DENOMINATOR);
                feeAmount = amount.sub(swapAmount).sub(referralReward);
            } else {
                referralReward = 0;
                feeAmount = fees;
            }
        }
    }

    /// @dev Forwards calls to the appropriate implementation contract.
    fallback() external payable {
        bytes4 selector = msg.data.readBytes4(0);
        address impl = IZerox(zeroEx).getFunctionImplementation(selector);
        if (impl == address(0)) {
            _revertWithData(NotImplementedError(selector));
        }

        (bool success, bytes memory resultData) = impl.delegatecall(msg.data);
        if (!success) {
            _revertWithData(resultData);
        }
        _returnWithData(resultData);
    }

    function NotImplementedError(bytes4 selector) internal pure returns (bytes memory) {
        return abi.encodeWithSelector(bytes4(keccak256("NotImplementedError(bytes4)")), selector);
    }

    /// @dev Revert with arbitrary bytes.
    /// @param data Revert data.
    function _revertWithData(bytes memory data) private pure {
        assembly {
            revert(add(data, 32), mload(data))
        }
    }

    /// @dev Return with arbitrary bytes.
    /// @param data Return data.
    function _returnWithData(bytes memory data) private pure {
        assembly {
            return(add(data, 32), mload(data))
        }
    }

    function registerFork(address _factory, bytes calldata _initCode) external onlyOwner {
        require(!forkActivated[_factory], "FloozRouter: ACTIVATED_FORK");
        forkActivated[_factory] = true;
        forkInitCode[_factory] = _initCode;
        emit ForkCreated(_factory);
    }

    function updateFork(
        address _factory,
        bytes calldata _initCode,
        bool _activated
    ) external onlyOwner {
        forkActivated[_factory] = _activated;
        forkInitCode[_factory] = _initCode;
        emit ForkUpdated(_factory);
    }

    function userAboveBalanceThreshold(address _account) public view returns (bool) {
        return saveYourAssetsToken.balanceOf(_account) >= balanceThreshold;
    }

    function getUserFee(address user) public view returns (uint256) {
        saveYourAssetsToken.balanceOf(user) >= balanceThreshold ? 0 : swapFee;
    }

    function updateSwapFee(uint16 newSwapFee) external onlyOwner {
        swapFee = newSwapFee;
        emit SwapFeeUpdated(newSwapFee);
    }

    function updateReferralRewardRate(uint16 newReferralRewardRate) external onlyOwner {
        referralRewardRate = newReferralRewardRate;
        emit ReferralRewardRateUpdated(newReferralRewardRate);
    }

    function updateFeeReceiver(address payable newFeeReceiver) external onlyOwner {
        feeReceiver = newFeeReceiver;
        emit FeeReceiverUpdated(newFeeReceiver);
    }

    function updateBalanceThreshold(uint256 newBalanceThreshold) external onlyOwner {
        balanceThreshold = newBalanceThreshold;
        emit BalanceThresholdUpdated(balanceThreshold);
    }

    function updateReferralsActivated(bool newReferralsActivated) external onlyOwner {
        referralsActivated = newReferralsActivated;
        emit ReferralsActivatedUpdated(newReferralsActivated);
    }

    function updateReferralRegistry(address newReferralRegistry) external onlyOwner {
        referralRegistry = IReferralRegistry(newReferralRegistry);
        emit ReferralRegistryUpdated(newReferralRegistry);
    }

    function updateCustomReferralRewardRate(address account, uint16 referralRate) external onlyOwner returns (uint256) {
        require(referralRate <= FEE_DENOMINATOR, "FloozRouter: INVALID_RATE");
        customReferralRewardRate[account] = referralRate;
        emit CustomReferralRewardRateUpdated(account, referralRate);
    }

    function getUserReferee(address user) external view returns (address) {
        return referralRegistry.getUserReferee(user);
    }

    function hasUserReferee(address user) external view returns (bool) {
        return referralRegistry.hasUserReferee(user);
    }

    /**
     * @dev Withdraw ETH that somehow ended up in the contract.
     */
    function withdrawETH(address payable to, uint256 amount) external onlyOwner {
        TransferHelper.safeTransferETH(to, amount);
    }

    /**
     * @dev Withdraw any erc20 compliant tokens that
     * somehow ended up in the contract.
     */
    function withdrawERC20Token(
        address token,
        address to,
        uint256 amount
    ) external onlyOwner {
        TransferHelper.safeTransfer(token, to, amount);
    }

    function _withdrawFeesAndRewards(
        address tokenReward,
        address tokenOut,
        address referee,
        uint256 feeAmount,
        uint256 referralReward
    ) internal {
        if (tokenReward == address(0)) {
            TransferHelper.safeTransferETH(feeReceiver, feeAmount);
            if (referralReward > 0) {
                TransferHelper.safeTransferETH(referee, referralReward);
                emit ReferralRewardPaid(msg.sender, referee, tokenOut, tokenReward, referralReward);
            }
        } else {
            TransferHelper.safeTransferFrom(tokenReward, msg.sender, feeReceiver, feeAmount);
            if (referralReward > 0) {
                TransferHelper.safeTransferFrom(tokenReward, msg.sender, referee, referralReward);
                emit ReferralRewardPaid(msg.sender, referee, tokenOut, tokenReward, referralReward);
            }
        }
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function _getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal view returns (uint256 amountOut) {
        require(amountIn > 0, "FloozRouter: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "FloozRouter: INSUFFICIENT_LIQUIDITY");
        uint256 amountInWithFee = amountIn.mul((9975 - getUserFee(msg.sender)));
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function _getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal view returns (uint256 amountIn) {
        require(amountOut > 0, "FloozRouter: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "FloozRouter: INSUFFICIENT_LIQUIDITY");
        uint256 numerator = reserveIn.mul(amountOut).mul(10000);
        uint256 denominator = reserveOut.sub(amountOut).mul(9975 - getUserFee(msg.sender));
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function _getAmountsOut(
        address factory,
        uint256 amountIn,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, "FloozRouter: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        for (uint256 i; i < path.length - 1; i++) {
            (uint256 reserveIn, uint256 reserveOut) = _getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = _getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function _getAmountsIn(
        address factory,
        uint256 amountOut,
        address[] memory path
    ) internal view returns (uint256[] memory amounts) {
        require(path.length >= 2, "FloozRouter: INVALID_PATH");
        amounts = new uint256[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint256 i = path.length - 1; i > 0; i--) {
            (uint256 reserveIn, uint256 reserveOut) = _getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = _getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }

    // fetches and sorts the reserves for a pair
    function _getReserves(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (uint256 reserveA, uint256 reserveB) {
        (address token0, ) = PancakeLibrary.sortTokens(tokenA, tokenB);
        (uint256 reserve0, uint256 reserve1, ) = IPancakePair(_pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function _pairFor(
        address factory,
        address tokenA,
        address tokenB
    ) internal view returns (address pair) {
        (address token0, address token1) = PancakeLibrary.sortTokens(tokenA, tokenB);
        pair = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex"ff",
                        factory,
                        keccak256(abi.encodePacked(token0, token1)),
                        forkInitCode[factory] // init code hash
                    )
                )
            )
        );
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function executeZeroExTrade(
        bytes memory _data,
        address _sellCurrency,
        address _buyCurrency,
        address _referee
    ) public payable {
        _referee = _getReferee(_referee);
        bytes4 selector = _data.readBytes4(0);
        address impl = IZerox(zeroEx).getFunctionImplementation(selector);
        if (impl == address(0)) {
            _revertWithData(NotImplementedError(selector));
        }

        bool isAboveThreshold = userAboveBalanceThreshold(msg.sender);
        // skip fees & rewards for GodMode Users
        if (isAboveThreshold) {
            (bool success, bytes memory resultData) = impl.delegatecall(_data);
            if (!success) {
                _revertWithData(resultData);
            }
        } else {
            // if ETH in execute trade as router & distribute funds & fees
            if (msg.value > 0) {
                (uint256 swapAmount, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(msg.value, _referee, true);
                _withdrawFeesAndRewards(address(0), _buyCurrency, _referee, feeAmount, referralReward);
                (bool success, bytes memory resultData) = impl.call{value: swapAmount}(_data);
                if (!success) {
                    _revertWithData(resultData);
                }
                TransferHelper.safeTransfer(_buyCurrency, msg.sender, IERC20(_buyCurrency).balanceOf(address(this)));
            } else {
                uint256 balanceBefore;
                uint256 balanceAfter;
                balanceBefore = IERC20(_sellCurrency).balanceOf(msg.sender);
                (bool success, bytes memory resultData) = impl.delegatecall(_data);
                if (!success) {
                    _revertWithData(resultData);
                }
                balanceAfter = IERC20(_sellCurrency).balanceOf(msg.sender);
                require(balanceBefore > balanceAfter, "INVALID_TOKEN");
                (, uint256 feeAmount, uint256 referralReward) = _calculateFeesAndRewards(balanceBefore.sub(balanceAfter), _referee, false);
                _withdrawFeesAndRewards(_sellCurrency, _buyCurrency, _referee, feeAmount, referralReward);
                _returnWithData(resultData);
            }
        }
    }
}
