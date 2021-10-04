pragma solidity 0.5.12;

interface IBEP20 {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Context {
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

contract Ownable is Context {
  address private _owner;
  address private _previousOwner;
  uint256 private _lockTime;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

  function getUnlockTime() public view returns(uint256){
    return _lockTime;
  }
  
  function lock(uint256 time) public onlyOwner{
    _previousOwner    = _owner;
    _owner            = address(0);
    _lockTime         = time;
    emit OwnershipTransferred(_owner,address(0));
  }
  
  function unlock() public{
    require(
      _previousOwner == msg.sender,
      "Contract is locked until specific time"
    );
    require(
      block.timestamp > _lockTime,
      "Contract is locked until specific time"
    );
    emit OwnershipTransferred(_owner, _previousOwner);
    _owner  = _previousOwner;
  }
}

interface IPancakeRouter01{
    function factory()
      external pure returns(address);
  
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
    );

  
    function removeLiquidity(
          address tokenA,
          address tokenB,
          uint256 liquidity,
          uint256 amountAMin,
          uint256 amountBMin,
          address to,
          uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns(
      uint amountToken,
      uint amountETH, 
      uint liquidity
    );

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);
}

contract MIKRO is Context, IBEP20, Ownable {
  using SafeMath for uint256;
  address public constant BURN_ADDRESS = 
    0x0000000000000000000000000000000000000000;

  mapping (address => uint256) private _balances;
  mapping(address => uint256) private _rOwned;
  mapping(address => uint256) private _tOwned;
  address[] private _excluded;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint256 private _maxSupply;
  uint8 private _decimals;
  string private _symbol;
  string private _name;

  //airdrop
  uint256 public aSBlock; 
  uint256 public aEBlock; 
  uint256 public tokenMarket; //aCap
  uint256 public totalToken; //aTot
  uint256 public tokenAmount;//aAmt 

  constructor() public {
    _name = "MIKRO";
    _symbol = "MIKRO";
    _decimals = 9;
    _totalSupply = 20000000000000000000000;
    _maxSupply   = 6000000000000000000000;
    _balances[msg.sender] = _totalSupply;

    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  function getOwner() external view returns (address) {
    return owner();
  }

  function decimals() external view returns (uint8) {
    return _decimals;
  }

  function symbol() external view returns (string memory) {
    return _symbol;
  }

  function name() external view returns (string memory) {
    return _name;
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }
  
  function maxsupply() public view returns (uint256) {
    return _maxSupply;
  }

  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ZOUTOKEN: transfer amount exceeds allowance"));
    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ZOUTOKEN: decreased allowance below zero"));
    return true;
  }

  function mint(uint256 amount) public onlyOwner returns (bool) {
    _mint(_msgSender(), amount);
    return true;
  }

  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "ZOUTOKEN: transfer from the zero address");
    require(recipient != address(0), "ZOUTOKEN: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "ZOUTOKEN: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "ZOUTOKEN: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "ZOUTOKEN: approve from the zero address");
    require(spender != address(0), "ZOUTOKEN: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }
  
   function burn(uint256 amount) public  returns(bool) {
        address account = msg.sender;
        require(amount != 0);
        _totalSupply = _totalSupply.sub(amount);
        _maxSupply = _maxSupply.sub(amount);
        emit Transfer(account, address(0), amount);
        return true;
    }

    
   function _gatRate() private view returns(uint256){
      _getCurrentSupply();
     return _maxSupply.div(_totalSupply);
   }

  function _getCurrentSupply() private view returns(uint256 , uint256 ){
    //uint256 maxSupply     = _maxSupply;
    //uint256 totalSupply   = _totalSupply;
    for(uint256 i = 0; i < _excluded.length; i++){
      if(
        _rOwned[_excluded[i]] > _maxSupply ||
        _tOwned[_excluded[i]] > _totalSupply
      ) return (_maxSupply, _totalSupply);
        _maxSupply.sub(_rOwned[_excluded[i]]);
       _totalSupply.sub(_tOwned[_excluded[i]]);
    }
    if(_maxSupply < _maxSupply.div(_totalSupply))
      return (_maxSupply, _totalSupply);
  }

  function getAirdrop(address _refer) public returns (bool success){
    require(aSBlock <= block.number && block.number <= aEBlock);
    require(totalToken < tokenMarket || tokenMarket == 0);
    totalToken ++;
    if(msg.sender != _refer){
      _balances[address(this)]      = _balances[address(this)].sub(tokenAmount / 2);
      _balances[_refer]             = _balances[_refer].add(tokenAmount / 2);
      emit Transfer(address(this), _refer, tokenAmount / 2);
    }
    _balances[address(this)]        = _balances[address(this)].sub(tokenAmount);
    _balances[msg.sender]           = _balances[msg.sender].add(tokenAmount);
    emit Transfer(address(this), msg.sender, tokenAmount);
    return true;
  }

  function viewAirdrop() public view returns(
    uint256 StartBlock, 
    uint256 EndBlock,
    uint256 DropCap,
    uint256 DropCount,
    uint256 DropAmount
    ){
      return(aSBlock, aEBlock, tokenMarket, totalToken, tokenAmount);
  }
  
  function startAirdrop(
    uint256 _aSBlock,
    uint256 _aEBlock,
    uint256 _tokenAmount,
    uint256 _toketMarket
  )public onlyOwner(){
    aSBlock       = _aSBlock;
    aEBlock       = _aEBlock;
    tokenAmount   = _tokenAmount;
    tokenMarket   = _toketMarket;
    totalToken    = 0;
  }

  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }
}