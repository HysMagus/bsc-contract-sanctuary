// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./SafeERC20.sol";
import "./Ownable.sol";

import "./IPancakeRouter02.sol";
import "./IPancakeFactory.sol";
import "./IRocketBunny.sol";
import "./IRocketBeneficiary.sol";
import "./IMasterChef.sol";
import "./IStakingRewards.sol";

/*
* 1. rocket (100,000 BUNNY) --> notifyCreate                    // Presale starts
* 2. rocket --> notifyEngage
* 3. rocket --> notifyArchive (add liquidity 50,000 BUNNY, 5,000 BNB)    // Presale End
* 4. owner --> setMasterChef
* 5. owner --> setStakingRewards
* 6. owner --> distributeTokens // distributes tokens to participants
* 7. owner --> finalize() // owner will burn unsold BUNNY tokens.
*/

contract PresalePancakeBunny is IRocketBeneficiary, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IPancakeRouter02 private constant router = IPancakeRouter02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    IPancakeFactory private constant factory = IPancakeFactory(0xBCfCcbde45cE874adCB698cC183deBcF17952812);

    address public rocket;
    address public token;

    address public masterChef;
    address public stakingRewards;

    uint public totalBalance;
    uint public totalFlipBalance;

    mapping (address => uint) private balance;
    address[] public users;

    modifier onlyRocket {
        require(msg.sender == rocket, '!auth');
        _;
    }

    constructor(address _rocket) public {
        rocket = _rocket;
    }

    receive() payable external {

    }

    function balanceOf(address account) view external returns(uint) {
        return balance[account];
    }

    function flipToken() view public returns(address) {
        return factory.getPair(token, router.WETH());
    }

    function notifyCreate(uint256, address _token) override external onlyRocket {
        token = _token;
    }

    function notifyEngage(uint256 auctionId, address user, uint256 amount) override external onlyRocket {
        users.push(user);
        amount = IRocketBunny(rocket).swapTokenAmount(auctionId, amount);
        balance[user] = balance[user].add(amount);
        totalBalance = totalBalance.add(amount);
    }

    function notifyArchive(uint256, address _token, uint256 amount) override external onlyRocket {
        require(IERC20(_token).balanceOf(address(this)) >= totalBalance, "less token");
        require(address(this).balance >= amount, "less balance");

        uint tokenAmount = totalBalance.div(2);
        IERC20(_token).safeApprove(address(router), 0);
        IERC20(_token).safeApprove(address(router), tokenAmount);
        router.addLiquidityETH{value: amount.div(2)}(_token, tokenAmount, 0, 0, address(this), block.timestamp);

        address lp = flipToken();
        totalFlipBalance = IERC20(lp).balanceOf(address(this));
    }

    function notifyClaim(uint256, address, uint256) override external {
        // do nothing. go to https://pancakebunny.finance
        // admin of pancakebunny will execute distributeTokens for participants before launching PancakeBunny.
    }

    function setMasterChef(address _masterChef) external onlyOwner {
        masterChef = _masterChef;
    }

    function setStakingRewards(address _rewards) external onlyOwner {
        stakingRewards = _rewards;
    }

    function distributeTokens(uint index, uint length, uint _pid) external onlyOwner {
        address lpToken = flipToken();
        require(lpToken != address(0), 'not set flip');
        require(masterChef != address (0), 'not set masterChef');
        require(stakingRewards != address(0), 'not set stakingRewards');

        IERC20(lpToken).safeApprove(masterChef, 0);
        IERC20(lpToken).safeApprove(masterChef, totalFlipBalance);

        IERC20(token).safeApprove(stakingRewards, 0);
        IERC20(token).safeApprove(stakingRewards, totalBalance.div(2));

        for(uint i=index; i<length; i++) {
            address user = users[i];
            uint share = shareOf(user);

            _distributeFlip(user, share, _pid);
            _distributeToken(user, share);

            delete balance[user];
        }
    }

    function _distributeFlip(address user, uint share, uint pid) private {
        uint remaining = IERC20(flipToken()).balanceOf(address(this));
        uint amount = totalFlipBalance.mul(share).div(1e18);
        if (amount == 0) return;

        if (remaining < amount) {
            amount = remaining;
        }
        IMasterChef(masterChef).depositTo(pid, amount, user);
    }

    function _distributeToken(address user, uint share) private {
        uint remaining = IERC20(token).balanceOf(address(this));
        uint amount = totalBalance.div(2).mul(share).div(1e18);
        if (amount == 0) return;

        if (remaining < amount) {
            amount = remaining;
        }
        IStakingRewards(stakingRewards).stakeTo(amount, user);
    }

    function shareOf(address _user) view private returns(uint) {
        return balance[_user].mul(1e18).div(totalBalance);
    }

    function finalize() external onlyOwner {
        // will go to the BUNNY pool as reward
        payable(owner()).transfer(address(this).balance);

        // will burn unsold tokens
        uint tokenBalance = IERC20(token).balanceOf(address(this));
        if (tokenBalance > 0) {
            IERC20(token).transfer(owner(), tokenBalance);
        }
    }
}