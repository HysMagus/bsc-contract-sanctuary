// SPDX-License-Identifier: MIT
pragma solidity 0.8.2;

abstract contract StarkX20Interface {
    function totalSupply() public virtual view returns (uint);
    function balanceOf(address tokenOwnerStarkX) public virtual view returns (uint balance);
    function allowance(address tokenOwnerStarkX, address spenderStarkX) public virtual view returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spenderStarkX, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwnerStarkX, address indexed spenderStarkX, uint tokens);
}

pragma solidity 0.8.2;

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

pragma solidity 0.8.2;

contract StarkX is StarkX20Interface, Math {
    string public tokenNameStarkX = "StarkX";
    string public tokenSymbolStarkX = "StarkX";
    uint public _tokenSupplyStarkX = 1*10**9 * 10**9;

    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        _balances[msg.sender] = _tokenSupplyStarkX;
        emit Transfer(address(0), msg.sender, _tokenSupplyStarkX);
    }
    
     function name() public view virtual returns (string memory) {
        return tokenNameStarkX;
    }


    function symbol() public view virtual returns (string memory) {
        return tokenSymbolStarkX;
    }


    function decimals() public view virtual returns (uint8) {
        return 9;
    }

    function totalSupply() public override view returns (uint) {
        return _tokenSupplyStarkX;
    }

    function balanceOf(address tokenOwnerStarkX) public override view returns (uint balance) {
        return _balances[tokenOwnerStarkX];
    }

    function allowance(address tokenOwnerStarkX, address spenderStarkX) public override view returns (uint remaining) {
        return allowed[tokenOwnerStarkX][spenderStarkX];
    }
    
   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "StarkX20: transfer from the zero address");
        require(recipient != address(0), "StarkX20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "StarkX20: transfer amount exceeds balance");
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

    function approve(address spenderStarkX, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spenderStarkX] = tokens;
        emit Approval(msg.sender, spenderStarkX, tokens);
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