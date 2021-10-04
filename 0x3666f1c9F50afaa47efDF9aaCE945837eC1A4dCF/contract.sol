pragma solidity >=0.5.0 <0.9.0;

contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }


    function percent(uint numerator, uint denominator, uint precision) public view returns(uint quotient) {
        // caution, check safe-to-multiply here
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        return ( _quotient);
    }
}


//ERC Token Standard #20 Interface

abstract contract ERC20Interface {
    function totalSupply() virtual public view returns (uint);
    function balanceOf(address tokenOwner) virtual public view returns (uint balance);
    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
    function transfer(address to, uint tokens) virtual public returns (bool success);
    function approve(address spender, uint tokens) virtual public returns (bool success);
    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}



//Contract function to receive approval and execute function in one call

abstract contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;
}

//Actual token contract


contract Ownable {
    address owner;
    bool isOwnershipEnabled = true;
    
    function disableOwnership() public virtual {
        isOwnershipEnabled = false;
    }
    
    modifier restricted() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) public restricted {
        owner = newOwner;
    }
}


contract InflaToken is ERC20Interface, SafeMath, Ownable {
    string public symbol;
    string public  name;
    string private walletAddress;
    uint public decimals;
    uint public _totalSupply;
    uint buyPrice;
    bool enableBuy;
    bool enableSell;
    uint public sellingSupply;
    uint sellFee;
    uint mintPercent;
    uint lastMinted;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    address[] storedAddresses;
    mapping(address => bool) isStored;

    constructor(string memory _symbol, string memory _name, uint _decimals) public {
        owner = msg.sender;
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
        _totalSupply = 100000 * (10 ** decimals);
        buyPrice = 0.001 ether;

        enableBuy = true;
        enableSell = true;

        uint ownerReward = safeDiv(safeMul(_totalSupply, 10), 100);
        balances[msg.sender] = ownerReward;

        sellingSupply = safeSub(_totalSupply, ownerReward);

        storedAddresses.push(msg.sender);
        isStored[msg.sender] = true;
        sellFee = 15;
        mintPercent = 10;
        lastMinted = 0;

        emit Transfer(address(0), msg.sender, ownerReward);
    }

    function totalSupply() public override view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public override view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        if (!isStored[to]) {
            isStored[to] = true;
            storedAddresses.push(to);
        }
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }
    
    function _changeMintPercent() private {
        uint normalizedTotalSupply = safeDiv(_totalSupply, 10 ** 18);
        
        if (normalizedTotalSupply < 10 * 10**8) {
            mintPercent = 10;
        } else if (normalizedTotalSupply < 10 * 10**9) {
            mintPercent = 5;
        } else if (normalizedTotalSupply < 10 * 10**10) {
            mintPercent = 2;
        } else {
            mintPercent = 1;
        }
    }
    
    // function renou

    function mint() public {
        _changeMintPercent();
    
        for (uint i = 0; i < storedAddresses.length; i++) {
            address userAdd = storedAddresses[i];
            uint userBalance = balances[userAdd];
            uint balanceAddition = safeDiv(safeMul(userBalance, mintPercent), 100);
            balances[userAdd] += balanceAddition;
            _totalSupply += balanceAddition;
        }

        uint newSellingSupply = safeDiv(safeMul(sellingSupply, mintPercent), 100);
        sellingSupply += newSellingSupply;
        _totalSupply += newSellingSupply;
    }

    function buy() public payable {
        require(enableBuy, 'selling needs to be enabled');
        require(msg.value >= 0.01 ether, "need to buy with 0.01");
        uint tokenToSell = safeDiv(msg.value, buyPrice) ** decimals;

        require(sellingSupply >= tokenToSell);

        if (sellingSupply >= tokenToSell) {
            balances[msg.sender] += tokenToSell;
            sellingSupply -= tokenToSell;

            if (!isStored[msg.sender]) {
                isStored[msg.sender] = true;
                storedAddresses.push(msg.sender);
            }
        }
        
        emit Transfer(address(this), msg.sender, tokenToSell);
    }

    function updateBuyPrice(uint price) public restricted {
        buyPrice = price;
    }

    function sell(uint amount) public {
        if (enableSell) {
            require(enableSell, 'selling needs to be enabled');
            require(balances[msg.sender] >= amount);
            uint etherAmount = safeDiv(amount, safeDiv(safeMul(buyPrice, safeSub(100, sellFee)), 100));
            
            // help ensure owner has ether/bnb to buy tokens from exchanges and raise the price
            uint amountToOwner = safeDiv(amount, safeMul(buyPrice, safeDiv(sellFee, 100)));
            
            require(address(this).balance > etherAmount);
            
            if (address(this).balance > etherAmount) {
                payable(msg.sender).transfer(etherAmount);
            }
            
            if (address(this).balance > etherAmount) {
                payable(owner).transfer(amountToOwner);
            }
            
            balances[msg.sender] -= amount;
            
            
            emit Transfer(msg.sender, address(this), amount);
        }
    }

    function transferBalanceToOwner(uint amount) public restricted {
        if (address(this).balance >= amount) {
            payable(owner).transfer(amount);
        }
    }

    function getBalance() public restricted view returns (uint balance) {
        return address(this).balance;
    }

    function transferToBalance() public payable {
        require(msg.value > 0.001 ether);
    }
    
    function disableSellingAndBuying() public restricted {
        enableSell = false;
        enableBuy = false;
    }
    
    function enableSelling() public restricted {
        enableSell = true;
        enableBuy = true;
    }
    
    function disableOwnership() public override {
        isOwnershipEnabled = false;
        disableSellingAndBuying();
        transferBalanceToOwner(getBalance());
    }
}