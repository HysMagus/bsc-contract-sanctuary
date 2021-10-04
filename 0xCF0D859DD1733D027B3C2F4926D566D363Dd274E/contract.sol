// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

//sol800
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

//sol800
abstract contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

//sol800
abstract contract Administration is Ownable {
    address public admin;
    address public governance;
    event AccountTransferred(
        address indexed previousAccount,
        address indexed newAccount
    );

    constructor() {
        admin = _msgSender();
        governance = _msgSender();
    }

    modifier onlyAdmin() {
        require(_msgSender() == admin, "Caller is not admin");
        _;
    }

    function isOnlyAdmin() public view returns (bool) {
        return _msgSender() == admin;
    }

    function transferAccount(address addrNew, uint256 num) external onlyOwner {
        require(addrNew != address(0), "cannot be zero address");
        if(num == 0) admin = addrNew;
        if(num == 1) governance = addrNew;
        emit AccountTransferred(admin, addrNew);        
    }

    //-------------------==
    function isOnlyGov() public view returns (bool) {
        return _msgSender() == governance;
    }
}

//sol8.0.0
library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

//sol8.0.0
contract PricefeedAggr is Administration {
    using Address for address;

    uint256 public interfaceID = 1;
    bool public isLivePrice;

    address public addrPriceFeedBTCUSD;
    address public addrPriceFeedETHUSD;
    AggregatorEthereumV3 internal PricefeedBTCUSD;
    AggregatorEthereumV3 internal PricefeedETHUSD;

    address public addrBTCUSDpfXDAI;
    address public addrETHUSDpfXDAI;
    AggregatorXDAI internal BTCUSDpfXDAI;
    AggregatorXDAI internal ETHUSDpfXDAI;

    constructor(
    ) {
      interfaceID == 1;

       addrPriceFeedBTCUSD = address(0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf);
       addrPriceFeedETHUSD = address(0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);
      PricefeedBTCUSD = AggregatorEthereumV3(addrPriceFeedBTCUSD);
      PricefeedETHUSD = AggregatorEthereumV3(addrPriceFeedETHUSD);

      addrBTCUSDpfXDAI = address(
          0xC3eFff1B3534Ab5e2Ce626DCF1783b7E83154eF4
      );
      //addrETHUSDpfXDAI = address();
    }

    //--------------------== onlyAdmin settings
    function setSettings(uint256 option, address addr, uint256 uintNum) external onlyAdmin {
      if(option == 101){
        interfaceID = uintNum;

      } else if(option == 110){
        require(addr != address(0), "address must not be zero address");
        addrPriceFeedBTCUSD = addr;
        PricefeedBTCUSD = AggregatorEthereumV3(addr);

      } else if(option == 111){
        require(addr != address(0), "address must not be zero address");
        addrPriceFeedETHUSD = addr;
        PricefeedETHUSD = AggregatorEthereumV3(addr);

      } else {
        require(false, "option not found");
      }
    }

    //-----------------== Get Pricefeed Oracle data
    function getLatestPrices() public view
        returns (uint256[] memory updatedAt,
          uint256[] memory prices)
    {
      prices = new uint256[](2);
      updatedAt = new uint256[](2);

      if(interfaceID == 1) {
        (, int256 int256BTC, , uint256 updatedAtBTCUSD1, ) =
            PricefeedBTCUSD.latestRoundData();
        prices[0] = uint256(int256BTC);
        updatedAt[0] = updatedAtBTCUSD1;

        (, int256 int256ETH, , uint256 updatedAtETHUSD1, ) =
            PricefeedETHUSD.latestRoundData();
        prices[1] = uint256(int256ETH);
        updatedAt[1] = updatedAtETHUSD1;

      } else if (interfaceID == 2) {
        prices[0]= uint256(BTCUSDpfXDAI.latestAnswer());
        prices[1]= uint256(ETHUSDpfXDAI.latestAnswer());

      } else {

      }
    }
}

//pragma solidity >=0.6.0;
//import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"
interface AggregatorEthereumV3 {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values, which could be misinterpreted as actual reported values.
    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

interface AggregatorXDAI {
    function latestAnswer() external view returns (int256);

    function latestTimestamp() external view returns (uint256);

    function latestRound() external view returns (uint256);

    function getAnswer(uint256 roundId) external view returns (int256);

    function getTimestamp(uint256 roundId) external view returns (uint256);
}

/**
 * MIT License
 * ===========
 *
 * Copyright (c) 2020,2021 Aries Financial
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 */