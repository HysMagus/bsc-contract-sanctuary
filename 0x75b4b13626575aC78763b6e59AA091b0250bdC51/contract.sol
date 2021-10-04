// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

abstract contract RXKT20Interface {
    function totalSupply() public virtual view returns (uint);
    function balanceOf(address tokenOwnerRXKT) public virtual view returns (uint balance);
    function allowance(address tokenOwnerRXKT, address spenderRXKT) public virtual view returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spenderRXKT, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwnerRXKT, address indexed spenderRXKT, uint tokens);
}

pragma solidity 0.8.6;

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

pragma solidity 0.8.6;

contract RxKite is RXKT20Interface, Math {
    string public tokenNameRXKT = "RxKite";
    string public tokenSymbolRXKT = "RxKite";
    uint public _tokenSupplyRXKT = 1*10**12 * 10**9;

    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        _balances[msg.sender] = _tokenSupplyRXKT;
        emit Transfer(address(0), msg.sender, _tokenSupplyRXKT);
    }
    
     function name() public view virtual returns (string memory) {
        return tokenNameRXKT;
    }


    function symbol() public view virtual returns (string memory) {
        return tokenSymbolRXKT;
    }


    function decimals() public view virtual returns (uint8) {
        return 9;
    }

    function totalSupply() public override view returns (uint) {
        return _tokenSupplyRXKT;
    }

    function balanceOf(address tokenOwnerRXKT) public override view returns (uint balance) {
        return _balances[tokenOwnerRXKT];
    }

    function allowance(address tokenOwnerRXKT, address spenderRXKT) public override view returns (uint remaining) {
        return allowed[tokenOwnerRXKT][spenderRXKT];
    }
    
   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "RXKT20: transfer from the zero address");
        require(recipient != address(0), "RXKT20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "RXKT20: transfer amount exceeds balance");
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

    function approve(address spenderRXKT, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spenderRXKT] = tokens;
        emit Approval(msg.sender, spenderRXKT, tokens);
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