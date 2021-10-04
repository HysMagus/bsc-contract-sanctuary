// Root file: contracts/TokenQuery.sol

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >= 0.5.1;
interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

pragma experimental ABIEncoderV2;

contract TokenQuery {
    
    struct Token {
        address tokenAddress;
        string name;
        string symbol;
        uint8 decimals;
        uint balance;
        uint totalSupply;
    }
    
    function queryInfo(address user, address[] memory tokens) public view returns(Token[] memory info_list){
        info_list = new Token[](tokens.length);
        for(uint i = 0;i < tokens.length;i++) {
            info_list[i] = Token(tokens[i], IERC20(tokens[i]).name(), IERC20(tokens[i]).symbol(), IERC20(tokens[i]).decimals()
            ,IERC20(tokens[i]).balanceOf(user), IERC20(tokens[i]).totalSupply());
        }
    }
    
    function queryTokenList(address[] memory tokens) public view returns (Token[] memory token_list) {
        uint count = tokens.length;
        if(count > 0) {
            token_list = new Token[](count);
            for(uint i = 0;i < count;i++) {
                Token memory tk;
                tk.tokenAddress = tokens[i];
                tk.symbol = IERC20(tk.tokenAddress).symbol();
                tk.decimals = IERC20(tk.tokenAddress).decimals();
                tk.balance = IERC20(tk.tokenAddress).balanceOf(msg.sender);
                tk.totalSupply = IERC20(tk.tokenAddress).totalSupply();
                token_list[i] = tk;
            }
        }
    }
}