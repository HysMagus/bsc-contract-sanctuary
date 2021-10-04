//SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
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
}

interface IBEP20 {
    function balanceOf(address account) external view returns (uint256);
}

/**
 * Bogdabot interface for accepting transfer hooks
 */
interface IBogdabot {
    function txHook(address caller, address sender, address receiver, uint256 amount) external;
}

abstract contract Bogdabot is IBogdabot {
    address _owner;
    address _bogged;
    address _pair;
    
    constructor (address __bogged, address __pair) {
        _owner = msg.sender;
        _bogged = __bogged;
        _pair = __pair;
    }
    
    modifier onlyOwner() { require(msg.sender == _owner); _; }
    modifier onlyBogged() { require(msg.sender == _bogged); _; }
}

interface IPriceOracle {
    function getSpotPrice() external returns (uint256); // current price at time of call 
    function getAveragedPrice(uint256 amount) external returns (uint256); // average of last x prices
    function getPreviousPrice(uint256 offset) external returns (uint256);
    function getPreviousTimestamp(uint256 offset) external returns (uint256);
    
    function getAllPrices() external view returns (uint256[] memory);
    function getAllTimestamps() external view returns (uint256[] memory);
    
    function getBNBSpotPrice() external view returns (uint256);
    
    function getDecimals() external view returns (uint256);
}

contract BogPriceOracleV1 is Bogdabot, IPriceOracle {
    using SafeMath for uint256;
    
    uint256 decimals = 6;
    uint256 priceAmt = 10;
    uint256 lastPriceBlock;
    
    uint256[] prices;
    uint256[] timestamps;
    
    address wbnbAdr = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address busdAdr = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address wbnb_busd_pair = 0x1B96B92314C44b159149f7E0303511fB2Fc4774f;
    
    address _targetA;
    address _targetB;
    address _targetPair;
    
    constructor (address _bogged, address targetA, address targetB, address targetPair) Bogdabot(_bogged, _pair) { 
        _targetA = targetA;
        _targetB = targetB;
        _targetPair = targetPair;
    }
    
    function txHook(address caller, address sender, address receiver, uint256 amount) external override onlyBogged {
        updatePrices();
    }
    
    function updatePrices() internal {
        if(lastPriceBlock == block.number){ return; } // only want 1 update per block
        lastPriceBlock = block.number;
        prices.push(_getSpotPrice());
        timestamps.push(block.timestamp);
    }
    
    function getDecimals() external view override returns (uint256) {
        return decimals;
    }
    
    /**
     * Returns USD per BNB * 10^decimals
     */
    function getBNBSpotPrice() external view override returns (uint256) {
        return getPriceFromPair(wbnbAdr, busdAdr, wbnb_busd_pair);
    }
    
    function getSpotPrice() external view override returns (uint256) {
        return _getSpotPrice();
    } 
    
    function _getSpotPrice() internal view returns (uint256) {
        return getPriceFromPair(_targetA, _targetB, _targetPair);
    }
    
    function getAveragedPrice(uint256 amount) external view override returns (uint256) {
        require(amount > 0 && amount <= prices.length);
        uint256 cumulative = 0;
        for(uint256 i=0; i<amount; i++){
            cumulative += prices[prices.length - 1 - i];
        }
        return cumulative.div(amount);
    }
    
    function getPreviousPrice(uint256 offset) external view override returns (uint256) {
        require(offset < prices.length);
        return prices[prices.length - 1 - offset];
    }
    
    function getPreviousTimestamp(uint256 offset) external view override returns (uint256) {
        require(offset < timestamps.length);
        return timestamps[timestamps.length - 1 - offset];
    }
    
    
    function getAllPrices() external override view returns (uint256[] memory) {
        return prices;
    }
    
    function getAllTimestamps() external override view returns (uint256[] memory) {
        return timestamps;
    }
    
    /**
     * Returns 10^decimals * tokenA per tokenB
     */
    function getPriceFromPair(address tokenA, address tokenB, address pair) internal view returns (uint256) {
        uint256 reserveA = IBEP20(tokenA).balanceOf(pair);
        uint256 reserveB = IBEP20(tokenB).balanceOf(pair);
        return calculatePriceFromReserves(reserveA, reserveB);
    }
    
    /**
     * Returns 10^decimals * tokenA per tokenB
     */
    function calculatePriceFromReserves(uint256 reserveA, uint256 reserveB) internal view returns (uint256) {
        return reserveA.mul(10 ** decimals).div(reserveB);
    }
}