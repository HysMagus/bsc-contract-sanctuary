// SPDX-License-Identifier: GPL-2.0
pragma solidity =0.7.6;
/*

    :::     :::::::::  :::::::::: :::::::::   ::::::::   ::::::::  :::    ::: :::::::::: ::::::::::: 
  :+: :+:   :+:    :+: :+:        :+:    :+: :+:    :+: :+:    :+: :+:   :+:  :+:            :+:     
 +:+   +:+  +:+    +:+ +:+        +:+    +:+ +:+    +:+ +:+        +:+  +:+   +:+            +:+     
+#++:++#++: +#++:++#+  +#++:++#   +#++:++#:  +#+    +:+ +#+        +#++:++    +#++:++#       +#+     
+#+     +#+ +#+        +#+        +#+    +#+ +#+    +#+ +#+        +#+  +#+   +#+            +#+     
#+#     #+# #+#        #+#        #+#    #+# #+#    #+# #+#    #+# #+#   #+#  #+#            #+#     
###     ### ###        ########## ###    ###  ########   ########  ###    ### ##########     ### 

* App       :   https://aperocket.finance
* Discord   :   https://discord.gg/TVUszg3Cr6
* Medium    :   https://aperocket.medium.com/
* Twitter   :   https://twitter.com/aperocketfi
* Telegram  :   https://t.me/aperocket
* GitHub    :   https://github.com/aperocket-labs

 */
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20, SafeMath, IERC20, Address} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "./libraries/Babylonian.sol";
import "./interfaces/IPancakeRouter02.sol";
import "./interfaces/IPancakePair.sol";
import "./interfaces/IPancakeFactory.sol";

contract Zap is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using Address for address;

    /*///////////////////////////////////////////////////////////////
                        PUBLIC
    //////////////////////////////////////////////////////////////*/
    uint256 public constant PRECISION = 10_000;
    uint256 public slippageParam = 9950; // 0,5% default
    address public constant WBNB = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

    /*///////////////////////////////////////////////////////////////
                        PRIVATE
    //////////////////////////////////////////////////////////////*/
    IPancakeRouter02 private BASE_ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PCS Router

    receive() external payable {}

    struct Params {
        address _from;
        address _to;
        address[] _path;
        address[] _token0Path;
        address[] _token1Path;
        address _token0Router;
        address _token1Router;
        uint256 _slippage;
        uint256 _amount;
    }

    function zapIn(
        address from,
        address to,
        uint256 amount,
        uint256 slippage,
        address[] memory path,
        address[] memory token0Path,
        address[] memory token1Path,
        address _token0Router,
        address _token1Router,
        bool isLP
    ) external payable nonReentrant {
        (address token0Router, address token1Router) = _determineRouters(_token0Router, _token1Router);

        if (slippage == 0) {
            slippage = slippageParam;
        }

        if (from != address(0)) {
            // If amount > balance, zap all
            if (amount > IERC20(from).balanceOf(msg.sender)) {
                amount = IERC20(from).balanceOf(msg.sender);
            }
            IERC20(from).safeTransferFrom(msg.sender, address(this), amount);
        }

        Params memory parms = Params({
            _from: from,
            _to: to,
            _path: path,
            _token0Path: token0Path,
            _token1Path: token1Path,
            _token0Router: token0Router,
            _token1Router: token1Router,
            _slippage: slippage,
            _amount: amount
        });

        if (!isLP) {
            _swapTokenForToken(parms);
            return;
        }

        _swapTokenForLP(parms);
    }

    function zapOut(
        address _from,
        uint256 _amount,
        address _router
    ) external nonReentrant {
        // If amount > balance, zap all
        if (_amount > IERC20(_from).balanceOf(msg.sender)) _amount = IERC20(_from).balanceOf(msg.sender);
        IERC20(_from).safeTransferFrom(msg.sender, address(this), _amount);
        _approveTokenIfNeeded(_from, _router);

        IPancakePair lpToken = IPancakePair(_from);

        address token0 = lpToken.token0();
        address token1 = lpToken.token1();

        if (token0 == WBNB || token1 == WBNB) {
            (uint256 amountToken, uint256 amountETH) = IPancakeRouter02(_router).removeLiquidityETH(
                token0 != WBNB ? token0 : token1,
                _amount,
                0,
                0,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_out(msg.sender, _from, _amount, amountToken, amountETH);
            return;
        } else {
            (uint256 amountA, uint256 amountB) = IPancakeRouter02(_router).removeLiquidity(
                token0,
                token1,
                _amount,
                0,
                0,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_out(msg.sender, _from, _amount, amountA, amountB);
        }
    }

    function estimateAmountOut(
        address _router,
        address[] memory _path,
        uint256 _amount
    ) public view returns (uint256 amountOut) {
        uint256[] memory amountsOut = IPancakeRouter02(_router).getAmountsOut(_amount, _path);
        amountOut = amountsOut[amountsOut.length.sub(1)];
    }

    /*///////////////////////////////////////////////////////////////
                        INTERNAL IMPLEMENTATIONS
    //////////////////////////////////////////////////////////////*/
    function _swapTokenForToken(Params memory parms) internal {
        if (parms._from == address(0)) {
            address router = parms._token0Router == address(0) ? address(BASE_ROUTER) : parms._token0Router;
            parms._amount = msg.value;
            uint256[] memory output = IPancakeRouter02(router).swapExactETHForTokens{value: parms._amount}(
                getAmountOut(router, parms._path, parms._amount),
                parms._path,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_in(msg.sender, parms._from, parms._to, parms._amount, output[output.length.sub(1)]);
            return;
        } else if (parms._to == address(0)) {
            address router = parms._token1Router == address(0) ? address(BASE_ROUTER) : parms._token1Router;
            _approveTokenIfNeeded(parms._from, router);
            uint256[] memory output = IPancakeRouter02(router).swapExactTokensForETH(
                parms._amount,
                getAmountOut(router, parms._path, parms._amount).mul(parms._slippage).div(PRECISION),
                parms._path,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_in(msg.sender, parms._from, parms._to, parms._amount, output[output.length.sub(1)]);
            return;
        }

        if (parms._token0Router == parms._token1Router) {
            uint256[] memory amountsOut = IPancakeRouter02(parms._token0Router).getAmountsOut(
                parms._amount,
                parms._path
            );
            uint256 amountOut = amountsOut[amountsOut.length.sub(1)];

            _approveTokenIfNeeded(parms._from, parms._token0Router);
            uint256[] memory output = IPancakeRouter02(parms._token0Router).swapExactTokensForTokens(
                parms._amount,
                amountOut.mul(parms._slippage).div(PRECISION),
                parms._path,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_in(msg.sender, parms._from, parms._to, parms._amount, output[output.length.sub(1)]);
            return;
        }

        _switchToken(
            parms._from,
            parms._to,
            parms._token0Path,
            parms._token1Path,
            parms._token0Router,
            parms._token1Router,
            parms._amount,
            parms._slippage
        );
    }

    function _swapTokenForLP(Params memory lpp) internal {
        IPancakePair lpToken = IPancakePair(lpp._to);

        address token0 = lpToken.token0();
        address token1 = lpToken.token1();

        //If not on the same router, convert all token to WBNB, then to one of the LP token
        if (lpp._token0Router != lpp._token1Router) {
            _switchTokenLP(
                lpp._from,
                lpp._token0Router,
                lpp._token0Path,
                lpp._amount,
                token0,
                token1,
                lpp._token1Router,
                lpp._token1Path
            );
        }

        // If from BNB, convert directly to one of the LP token
        if (lpp._from == address(0)) {
            lpp._amount = msg.value;
            uint256[] memory output = IPancakeRouter02(lpp._token0Router).swapExactETHForTokens{value: lpp._amount}(
                0,
                lpp._path,
                address(this),
                block.timestamp + 60
            );
        } else if (lpp._token0Router == lpp._token1Router) {
            if (lpp._from != token0 && lpp._from != token1) {
                _approveTokenIfNeeded(lpp._from, lpp._token0Router);
                IPancakeRouter02(lpp._token0Router).swapExactTokensForTokens(
                    lpp._amount,
                    0,
                    lpp._path,
                    address(this),
                    block.timestamp + 60
                );
            }
        }

        uint256 token0Balance = IERC20(token0).balanceOf(address(this));
        uint256 token1Balance = IERC20(token1).balanceOf(address(this));

        uint256 swapAmt;
        {
            (uint256 r0, uint256 r1, ) = lpToken.getReserves();
            (uint256 token0Reserve, uint256 token1Reserve) = lpToken.token0() == WBNB ? (r0, r1) : (r1, r0);
            (swapAmt, ) = optimalDeposit(token0Balance, token1Balance, token0Reserve, token1Reserve);
        }

        address[] memory path = new address[](2);
        (path[0], path[1]) = (token0, token1);

        if (token1Balance > token0Balance) {
            (path[0], path[1]) = (token1, token0);
        }

        _approveTokenIfNeeded(token0, lpp._token1Router);
        _approveTokenIfNeeded(token1, lpp._token1Router);

        uint256[] memory out = IPancakeRouter02(lpp._token1Router).swapExactTokensForTokens(
            swapAmt,
            0,
            path,
            address(this),
            block.timestamp + 60
        );

        (uint256 amountA, uint256 amountB, uint256 liquidity) = IPancakeRouter02(lpp._token1Router).addLiquidity(
            token0,
            token1,
            IERC20(token0).balanceOf(address(this)),
            IERC20(token1).balanceOf(address(this)),
            0,
            0,
            msg.sender,
            block.timestamp + 60
        );
        emit zap_in_LP(msg.sender, lpp._from, lpp._to, lpp._amount, amountA, amountB, liquidity);
    }

    /* =========== Restricted functions ============== */

    function setSlippage(uint256 newSlippage) external onlyOwner {
        slippageParam = newSlippage;
    }

    function withdraw(address token) external onlyOwner {
        if (token == address(0)) {
            payable(owner()).transfer(address(this).balance);
            return;
        }

        IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
    }

    function setBaseRouter(address newRouter) external onlyOwner {
        BASE_ROUTER = IPancakeRouter02(newRouter);
    }

    /* =========== Internal functions ============== */

    /// @dev Compute optimal deposit amount
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amonut of token B desired to deposit
    /// @param resA amount of token A in reserve
    /// @param resB amount of token B in reserve
    function optimalDeposit(
        uint256 amtA,
        uint256 amtB,
        uint256 resA,
        uint256 resB
    ) internal pure returns (uint256 swapAmt, bool isReversed) {
        if (amtA.mul(resB) >= amtB.mul(resA)) {
            swapAmt = _optimalDepositA(amtA, amtB, resA, resB);
            isReversed = false;
        } else {
            swapAmt = _optimalDepositA(amtB, amtA, resB, resA);
            isReversed = true;
        }
    }

    function _approveTokenIfNeeded(address token, address router) private {
        if (IERC20(token).allowance(address(this), address(router)) == 0) {
            IERC20(token).safeApprove(address(router), type(uint256).max);
        }
    }

    /// @dev Compute optimal deposit amount helper
    /// @param amtA amount of token A desired to deposit
    /// @param amtB amonut of token B desired to deposit
    /// @param resA amount of token A in reserve
    /// @param resB amount of token B in reserve
    function _optimalDepositA(
        uint256 amtA,
        uint256 amtB,
        uint256 resA,
        uint256 resB
    ) internal pure returns (uint256) {
        require(amtA.mul(resB) >= amtB.mul(resA), "Reversed");

        uint256 a = 998;
        uint256 b = uint256(1998).mul(resA);
        uint256 _c = (amtA.mul(resB)).sub(amtB.mul(resA));
        uint256 c = _c.mul(1000).div(amtB.add(resB)).mul(resA);

        uint256 d = a.mul(c).mul(4);
        uint256 e = Babylonian.sqrt(b.mul(b).add(d));

        uint256 numerator = e.sub(b);
        uint256 denominator = a.mul(2);

        return numerator.div(denominator);
    }

    function getAmountOut(
        address _router,
        address[] memory _path,
        uint256 _amount
    ) internal view returns (uint256 amountOut) {
        uint256[] memory amountsOut = IPancakeRouter02(_router).getAmountsOut(_amount, _path);
        amountOut = amountsOut[amountsOut.length.sub(1)];
    }

    function _determineRouters(address _router0, address _router1) internal returns (address, address) {
        address token0Router;
        address token1Router;

        // Use PCS by default
        if ((_router0) == address(0) && (_router1) == address(0)) {
            token0Router = address(BASE_ROUTER);
            token1Router = address(BASE_ROUTER);
        }
        // If only one Router, use the same for both
        else if (_router0 == address(0)) {
            token0Router = _router1;
            token1Router = _router1;
        } else if (_router1 == address(0)) {
            token1Router = _router0;
            token0Router = _router0;
        } else {
            token0Router = _router0;
            token1Router = _router1;
        }

        return (token0Router, token1Router);
    }

    function _switchToken(
        address _from,
        address _to,
        address[] memory _token0Path,
        address[] memory _token1Path,
        address _token0Router,
        address _token1Router,
        uint256 _amount,
        uint256 _slippage
    ) internal {
        uint256[] memory amountsOutBNB = IPancakeRouter02(_token0Router).getAmountsOut(_amount, _token0Path);
        uint256 amountOutBNB = amountsOutBNB[amountsOutBNB.length.sub(1)];

        _approveTokenIfNeeded(_from, _token0Router);

        IPancakeRouter02(_token0Router).swapExactTokensForETH(
            _amount,
            amountOutBNB.mul(_slippage).div(PRECISION),
            _token0Path,
            address(this),
            block.timestamp + 60
        );
        // If _to = BNB, end here
        if (_to == WBNB) {
            return;
        } else {
            // Then, convert BNB in to Token
            uint256[] memory amountsOut = IPancakeRouter02(_token1Router).getAmountsOut(amountOutBNB, _token1Path);
            uint256 amountOut = amountsOut[amountsOut.length.sub(1)];

            _approveTokenIfNeeded(WBNB, _token1Router);

            uint256[] memory output = IPancakeRouter02(_token1Router).swapExactETHForTokens{value: amountOutBNB}(
                amountOutBNB.mul(_slippage).div(PRECISION),
                _token1Path,
                msg.sender,
                block.timestamp + 60
            );
            emit zap_in(msg.sender, _from, _to, _amount, output[output.length.sub(1)]);
            return;
        }
    }

    function _switchTokenLP(
        address _from,
        address _tokenRouter,
        address[] memory _tokenPath,
        uint256 _amount,
        address _lpToken0,
        address _lpToken1,
        address _lpRouter,
        address[] memory _lpPath
    ) internal {
        address[] memory path = new address[](2);
        uint256[] memory amountsOutBNB;
        uint256 amountOutBNB;
        //(path[0], path[1]) = (_from, WBNB);

        amountsOutBNB = IPancakeRouter02(_tokenRouter).getAmountsOut(_amount, _tokenPath);
        amountOutBNB = amountsOutBNB[amountsOutBNB.length.sub(1)];

        _approveTokenIfNeeded(_from, _tokenRouter);
        IPancakeRouter02(_tokenRouter).swapExactTokensForTokens(
            _amount,
            amountOutBNB,
            _tokenPath,
            address(this),
            block.timestamp + 60
        );

        // Then if token 0 and token 1 not WBNB, convert to one of them
        // TODO : Use LP path here, or handle busd affilied tokens
        if (_lpToken0 != WBNB && _lpToken1 != WBNB) {
            //address[] memory path = new address[](2);

            //(path[0], path[1]) = (WBNB, _lpToken0);

            _approveTokenIfNeeded(WBNB, _lpRouter);
            IPancakeRouter02(_lpRouter).swapExactTokensForTokens(
                amountOutBNB,
                0,
                _lpPath,
                address(this),
                block.timestamp + 60
            );
        }
    }

    /*///////////////////////////////////////////////////////////////
                            EVENTS 
    //////////////////////////////////////////////////////////////*/
    event zap_in(address caller, address tokenIn, address tokenOut, uint256 inputAmout, uint256 outputAmout);
    event zap_in_LP(
        address caller,
        address tokenIn,
        address LpOut,
        uint256 inputAmout,
        uint256 amountTokenA,
        uint256 amoutTokenB,
        uint256 liquidity
    );
    event zap_out(address caller, address lpToken, uint256 inputAmout, uint256 tokenA, uint256 tokenB);
}
