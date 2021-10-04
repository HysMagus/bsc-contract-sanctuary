// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IBEPF{
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function currentSupply() external view returns(uint256);
    function balanceOf(address account) external view returns (uint256);
    function website() external view returns (string memory);
    function icon() external view returns(string memory);
    function holders() external view returns(uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}
contract BEPF is IBEPF{
    
    mapping (address => uint256) private _balances;
    
    uint256 private _holdersCount = 2;
    mapping (uint256 => address) private _holders;
    
    mapping (address => uint256) private _holdersID;
    
    uint256 private _totalSupply = 10000000000000000000000000;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    constructor(){
        _balances[msg.sender] = _totalSupply;
        _holders[1] = msg.sender;
        _holdersID[msg.sender] = 1;
    }
    function name() external view override returns (string memory) {
        return "bep.finance";
    }
    function symbol() external view override returns (string memory) {
        return "BEPF";
    }
    function decimals() external view override returns (uint256) {
        return 18;
    }
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    function currentSupply() external view override returns(uint256){
        return _totalSupply;
    }
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
    function website() external view override returns (string memory){
        //string website = "https://bep.finance/#tokenomics";
        return "https://bep.finance/#tokenomics";
    }
    function icon() external view override returns(string memory){
        return "https://bep.finance/assets/img/favicon.png";
    }
    function holders() external view override returns(uint256){
        return _holdersCount - 1;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
            _balances[msg.sender] -= amount;
            
            if(_holdersID[recipient] == 0){
                _holdersID[recipient] = _holdersCount;
                _holders[_holdersCount] = recipient;
                _holdersCount += 1;
            }
            
            uint256 total = amount - (amount * 5 /100);
            uint256 distributed = amount * 4 / 100;
            
            _totalSupply -= amount * 5 /100;
            
            for(uint256 t = 1; t < _holdersCount; t += 1){
                _balances[_holders[t]] += _balances[_holders[t]] * distributed / _totalSupply;
                _totalSupply += _balances[_holders[t]] * distributed / _totalSupply;
            }
            _balances[recipient] += total;
            
            emit Transfer(msg.sender, recipient, amount);
                    
            return true;
    }


}