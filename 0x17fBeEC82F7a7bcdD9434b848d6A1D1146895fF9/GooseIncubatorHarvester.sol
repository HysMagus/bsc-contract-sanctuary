// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IBEP20.sol";
import "./interfaces/IPancakeRouter.sol";
import "./interfaces/IPancakeFactory.sol";
import "./interfaces/IPancakePair.sol";

import "./interfaces/IGooseIncubatorChef.sol";

contract GooseIncubatorHarvester is Ownable {

    using SafeMath for uint256;

    IGooseIncubatorChef public masterchef;
    IPancakeRouter public swapRouter;

    uint256 poolId;

    constructor(address masterchef_, address swapRouter_, uint256 poolId_){
        masterchef = IGooseIncubatorChef(masterchef_);
        swapRouter = IPancakeRouter(swapRouter_);
        poolId = poolId_;
    }

    function pendingRewards() public view returns (uint256) {
        uint256 pendingGoose = masterchef.pendingGoose(poolId, address(this));
        return _getSwapQuote(pendingGoose, address(rewardToken()), address(lpToken()));
    }

    function deposit(uint256 amount) external {
        IGooseIncubatorChef.PoolInfo memory poolInfo = masterchef.poolInfo(poolId);
        IBEP20 lpBEP20 = IBEP20(poolInfo.lpToken);
        lpBEP20.transferFrom(msg.sender, address(this), amount);
        lpBEP20.approve(address(masterchef), amount);
        masterchef.deposit(poolId, amount);
    }

    function compound() external {
        masterchef.withdraw(poolId, 0);
        address rewardAddr = rewardToken();
        uint256 rewardsAmount = IBEP20(rewardAddr).balanceOf(address(this));
        address lpAddr = lpToken();
        address[] memory path = _routeSwap(rewardAddr, lpAddr);
        uint256 amountOutMin = _getSwapQuote(rewardsAmount, rewardAddr, lpAddr);
        amountOutMin = amountOutMin.mul(96).div(100);
        IBEP20(rewardAddr).approve(address(swapRouter), rewardsAmount);
        swapRouter.swapExactTokensForTokens(
            rewardsAmount,
            amountOutMin,
            path,
            address(this),
            block.timestamp + 300
        );
        uint256 depositAmount = IBEP20(lpAddr).balanceOf(address(this));
        IBEP20(lpAddr).approve(address(masterchef), depositAmount);
        masterchef.deposit(poolId, depositAmount);
    }

    function withdraw() external onlyOwner {
        IGooseIncubatorChef.UserInfo memory userInfo = masterchef.userInfo(poolId, address(this));
        uint256 amount = userInfo.amount;
        masterchef.withdraw(poolId, amount);
        IBEP20 token = IBEP20(lpToken());
        amount = token.balanceOf(address(this));
        token.transfer(msg.sender, amount);
        token = IBEP20(rewardToken());
        amount = token.balanceOf(address(this));
        token.transfer(msg.sender, amount);
    }

    function rewardToken() public view returns (address) {
        return masterchef.goose();
    }

    function lpToken() public view returns (address) {
        IGooseIncubatorChef.PoolInfo memory poolInfo = masterchef.poolInfo(poolId);
        return poolInfo.lpToken;
    }

    function _routeSwap(address token0, address token1) internal view returns (address[] memory) {
        require(token0 != token1, "_routeSwap: tokens for swap are the same.");
        address WETH = swapRouter.WETH();

        address[] memory path;
        if (token0 == WETH || token1 == WETH) {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        } else {
            path = new address[](3);
            path[0] = token0;
            path[1] = WETH;
            path[2] = token1;
        }
        return path;
    }

    function _getSwapQuote(uint256 amount, address tokenFrom, address tokenTo) internal view returns (uint256) {
        IPancakeFactory swapFactory = IPancakeFactory(swapRouter.factory());
        address[] memory path = _routeSwap(tokenFrom, tokenTo);
        for (uint idx = 0; idx < path.length - 1;) {
            address from = path[idx++];
            address to = path[idx];
            IPancakePair swapPair = IPancakePair(swapFactory.getPair(from, to));
            uint256 fromReserves;
            uint256 toReserves;
            if (from == swapPair.token0() && to == swapPair.token1()) {
                (fromReserves, toReserves,) = swapPair.getReserves();
            } else if (from == swapPair.token1() && to == swapPair.token0()) {
                (toReserves, fromReserves,) = swapPair.getReserves();
            } else {
                revert("_getSwapQuote: Token pair mismatch.");
            }
            amount = swapRouter.quote(amount, fromReserves, toReserves);
        }
        return amount;
    }

}
