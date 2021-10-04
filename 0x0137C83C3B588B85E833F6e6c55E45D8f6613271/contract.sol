// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IPancakeFactory {
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

contract createPancakePairContract {
	// The Pancake Factory
    IPancakeFactory internal pancakeFactory;
	
    constructor () public {
        pancakeFactory = IPancakeFactory(address(0xBCfCcbde45cE874adCB698cC183deBcF17952812));
	}

	function createPancakePair(address addr1, address addr2) public returns(address) {
		address pairAddress = pancakeFactory.getPair(addr1, addr2);
		
		
		if(pairAddress == address(0)){
			address tokenPancakePair = pancakeFactory.createPair(
				addr1,
				addr2
			);
			
			return tokenPancakePair;
		} 
		
		return pairAddress;
    }
}