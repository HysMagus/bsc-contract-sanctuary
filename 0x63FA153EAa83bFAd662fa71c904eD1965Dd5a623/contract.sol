// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

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
        require(b > 0, errorMessage);
        uint256 c = a / b;
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

interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    
    constructor () internal { }

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable {

    bool public paused = false;

    address public owner;
    address public manager;

    event OwnershipTransferred(address previousOwner, address newOwner);
    event Pause();
    event Unpause();

    modifier onlyOwner {
        require(msg.sender == owner || msg.sender == manager,"must be owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    constructor() public {
        owner = msg.sender;
        manager = msg.sender;
    }


    function isOwner(address wallet) public view returns(bool) {
        return wallet == owner;
    }


    function transferOwnership(address _newOwner, address _oldOwner) public onlyOwner {
        _transferOwnership(_newOwner, _oldOwner);
    }
    
    function transferManagership(address _newManager, address _oldManager) public onlyOwner {
        _transferManagership(_newManager, _oldManager);
    }


    function pause() public onlyOwner whenNotPaused {

        paused = true;
        emit Pause();
    }


    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpause();
    }

    function _transferOwnership(address _newOwner, address _oldOwner) internal {
        require(_newOwner != address(0));
        owner = _newOwner;
        emit OwnershipTransferred(_oldOwner, _newOwner);
    }
    
    function _transferManagership(address _newManager, address _oldManager) internal {
        require(_newManager != address(0));
        manager = _newManager;
    }
}

contract WhiteListed is Ownable{
    mapping(address => bool) public blackListed;
    event userWhiteListed(address indexed _address);
    event userBlackListed(address indexed _address);
    
    constructor() public{    }
    
    function restrictUser(address _address) public onlyOwner{
        blackListed[_address] = true;
        emit userWhiteListed(_address);
    }
    
    function allowUser(address _address) public onlyOwner{
        blackListed[_address] = false;
        emit userBlackListed(_address);
    }
    
    modifier onlywhiteListed{
        require(!blackListed[msg.sender],"user access restricted by admin");
        _;
    }
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor () public {
        _name = "X10N";
        _symbol = "x10";
        _decimals = 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

contract ERC20 is Context, IERC20, WhiteListed{
  using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    constructor()public{
        _totalSupply = 1800000000e18;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
        function transfer(address recipient, uint256 amount) public virtual override onlywhiteListed returns (bool) {
        require(!blackListed[recipient],"user access restricted by admin");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        require(!blackListed[spender],"user access restricted by admin");
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override onlywhiteListed returns (bool) {
        require(!blackListed[spender],"user access restricted by admin");
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override onlywhiteListed returns (bool) {
        require(!blackListed[recipient],"user access restricted by admin");
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual onlywhiteListed returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual onlywhiteListed returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint256 amount) internal virtual {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

contract X10N is ERC20, ERC20Detailed {

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 value);
    event MintFinished();
    bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

    constructor() public {
    }


    function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool){
        _mint(_to,_amount);
        emit Mint(_to,_amount);
        return true;
    }


    function burn(uint256 _value) public {
    _burn(msg.sender, _value);
    emit Burn(msg.sender, _value);
  }

    function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }

    function burnFrom(address _to, uint256 _amount) external returns (bool) {
        _burnFrom(_to,_amount);
    }
    
    function withdraw() public onlyOwner{
        require(address(this).balance>0,"insufficient contract funds");
        address(uint160(owner)).transfer(address(this).balance);
    }
}