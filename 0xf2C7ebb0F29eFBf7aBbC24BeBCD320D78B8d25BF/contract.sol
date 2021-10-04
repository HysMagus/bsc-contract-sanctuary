// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

abstract contract Chon20Interface {
    function totalSupply() public virtual view returns (uint);
    function balanceOf(address tokenOwnerChon) public virtual view returns (uint balance);
    function allowance(address tokenOwnerChon, address spenderChon) public virtual view returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spenderChon, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwnerChon, address indexed spenderChon, uint tokens);
}

pragma solidity 0.8.7;

contract Math {
    function safeAdd(uint x, uint b) public pure returns (uint y) {
        y = x + b;
        require(y >= x);
    }
    function safeSub(uint x, uint b) public pure returns (uint y) {
        require(b <= x);
        y = x - b;
    }
    function safeMul(uint x, uint b) public pure returns (uint y) {
        y = x * b;
        require(x == 0 || y / x == b);
    }
    function safeDiv(uint x, uint b) public pure returns (uint y) {
        require(b > 0);
        y = x / b;
    }
}

pragma solidity 0.8.7;

contract ChonChon is Chon20Interface, Math {
    string public tokenNameChon = "ChonChon";
    string public tokenSymbolChon = "Chon2x";
    uint public _tokenSupplyChon = 1*10**9 * 10**9;

    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        _balances[msg.sender] = _tokenSupplyChon;
        emit Transfer(address(0), msg.sender, _tokenSupplyChon);
    }
    
     function name() public view virtual returns (string memory) {
        return tokenNameChon;
    }


    function symbol() public view virtual returns (string memory) {
        return tokenSymbolChon;
    }


    function decimals() public view virtual returns (uint8) {
        return 9;
    }

    function totalSupply() public override view returns (uint) {
        return _tokenSupplyChon;
    }

    function balanceOf(address tokenOwnerChon) public override view returns (uint balance) {
        return _balances[tokenOwnerChon];
    }

    function allowance(address tokenOwnerChon, address spenderChon) public override view returns (uint remaining) {
        return allowed[tokenOwnerChon][spenderChon];
    }
    
   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "Chon20: transfer from the zero address");
        require(recipient != address(0), "Chon20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Chon20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        _transfer(msg.sender, to, tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spenderChon, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spenderChon] = tokens;
        emit Approval(msg.sender, spenderChon, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        _transfer(from, to, tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}