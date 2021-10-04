pragma solidity 0.5.10;


//      ****************************************************      //
//             Yearn Finance. Transparents                        //
//      ****************************************************      //

//-----------------------------------------------------------------------------


//
// Symbol        : YFT
// Name          : Yearn Finance Transparents
// Total supply  : 40000
// Decimals      : 18
// Owner Account : 0xd0Ca642224b5db3e8F72429645cD6683695e0016
//
//
// (c) by Yearn Finance. Transparents 2020. 
// ----------------------------------------------------------------------------


//      ****************************************************      //



contract YearnFinanceTransparents {
    // Track how many tokens are owned by each address.
    mapping (address => uint256) public balanceOf;


    string public name = "Yearn Finance. Transparents";
    string public symbol = "YFT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 40000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    
   // Contract constructor.
   // It sets the `msg.sender` as the proxy administrator.
   // @param _implementation address of the initial implementation.
   //

    constructor() public {
        // Initially assign all tokens to the contract's creator.
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    
    // Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // for more details about how this works.
    // Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    
    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;  // deduct from sender's balance
        balanceOf[to] += value;          // add to recipient's balance
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    
    function _mint(address account, uint amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        emit Transfer(address(0), account, amount);
    }
    
    function _burn(address account, uint amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        emit Transfer(account, address(0), amount);
    }
    
    
    
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => mapping(address => uint256)) public allowance;


    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value)
        public
        returns (bool success)
    {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}

/**
* Copyright 2020
*
* Permission is hereby granted, free of charge, to any person obtaining a copy 
* of this software and associated documentation files (the "Software"), to deal 
* in the Software without restriction, including without limitation the rights 
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
* copies of the Software, and to permit persons to whom the Software is furnished to 
* do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all 
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

//      ********************** Yearn Finance. Transparents *************************      //