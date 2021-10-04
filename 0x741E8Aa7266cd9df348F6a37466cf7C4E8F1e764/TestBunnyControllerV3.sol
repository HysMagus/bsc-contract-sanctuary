// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/*
  ___                      _   _
 | _ )_  _ _ _  _ _ _  _  | | | |
 | _ \ || | ' \| ' \ || | |_| |_|
 |___/\_,_|_||_|_||_\_, | (_) (_)
                    |__/

*
* MIT License
* ===========
*
* Copyright (c) 2020 BunnyFinance
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

import "./IBEP20.sol";
import "./SafeBEP20.sol";
import "./Ownable.sol";

import "./IPancakeRouter02.sol";
import "./IPancakePair.sol";
import "./IStrategy.sol";
import "./IMasterChef.sol";
import "./IBunnyMinter.sol";
import "./IStrategyHelper.sol";
import "./Pausable.sol";

abstract contract TestBunnyControllerV3 is PausableUpgradeable {
    using SafeBEP20 for IBEP20;

    IBunnyMinter public minter;
    IStrategyHelper public helper;
    address public keeper;
    IBEP20 public token;

    address public dummy;

    modifier onlyKeeper {
        require(msg.sender == keeper || msg.sender == owner(), 'auth');
        _;
    }

    modifier onlyHelper {
        require(msg.sender == address(helper) || msg.sender == owner(), 'auth');
        _;
    }

    function __BunnyControllerV2_init() internal {
        __Pausable_init();

        helper = IStrategyHelper(0x154d803C328fFd70ef5df52cb027d82821520ECE);
        keeper = 0x793074D9799DC3c6039F8056F1Ba884a73462051;
    }

    function setToken(IBEP20 _token) internal {
        require(address(token) == address(0), 'once');
        token = _token;
    }

    function setKeeper(address _keeper) external onlyKeeper {
        require(_keeper != address(0), 'zero address');
        keeper = _keeper;
    }

    function setMinter(IBunnyMinter _minter) virtual public onlyOwner {
        // can zero
        minter = _minter;
        if (address(_minter) != address(0)) {
            token.safeApprove(address(_minter), 0);
            token.safeApprove(address(_minter), uint(~0));
        }
    }

    function setHelper(IStrategyHelper _helper) external onlyHelper {
        require(address(_helper) != address(0), "zero address");
        helper = _helper;
    }

    // salvage purpose only
    function withdrawToken(address _token, uint amount) external onlyOwner {
        require(_token != address(token), 'underlying token');
        IBEP20(_token).safeTransfer(owner(), amount);
    }

    uint256[49] private __gap;
}