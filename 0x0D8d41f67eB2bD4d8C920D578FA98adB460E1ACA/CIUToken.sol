// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.0;
import "./IBEP20.sol";
import "./SafeMath.sol";

interface ICIUMiner{
    function AddOneCut(uint256 amount) external;
}

interface tokenRecipient { 
	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
} 

contract CIUToken is IBEP20
{
    using SafeMath for uint256;
	
	mapping (address => bool) public frozenAccount; 
	
	/* This generates a public event on the blockchain that will notify clients */ 
	event FrozenFunds(address target, bool frozen); 
    
    address _owner;
    address _miner;
    address _minerpool;
    uint256 _maxSupply= 2000000000 * 1e8;

     string constant  _name = 'Cultural Industry Union';
     string constant _symbol = 'CIU';
     uint8 immutable _decimals = 8;
 
    address _pancakeAddress;
    uint256 _totalsupply;  

    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address=>bool) _isExcluded;
    mapping(address=>bool) _minter;
    mapping(address=>bool) _banneduser;
    mapping(address=>uint256) _balances;
    address _feeowner;

  
    constructor(address feeowner)
    {
        _owner = msg.sender;
        _mint(_owner,_maxSupply);
        _isExcluded[_owner]=true;
        _feeowner=feeowner;
    }
    
    modifier onlyOwner { 
		require(msg.sender == _owner); _; 
	}
	
	function transferOwnership(address newOwner) onlyOwner public { 
		_owner = newOwner;
	}

    function setMiner(address miner,address minerpool) public
    {
         require(msg.sender==_owner);
         _miner=miner;
         _minerpool=minerpool;
    }

    function BannUser(address user,bool ban) public
    {
         require(msg.sender==_owner);
         _banneduser[user]=ban;
    }

    function setPancakeAddress(address pancakeAddress) public
    {
        require(msg.sender==_owner);
        _pancakeAddress=pancakeAddress;
    }

    function name() public  pure returns (string memory) {
        return _name;
    }

    function symbol() public  pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalsupply;
    }

    function AddExcluded(address account) public 
    {
        require(msg.sender== _owner);
        _isExcluded[account] =true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
	
	function addMinter(address account) public
	{
		require(msg.sender== _owner);
		_minter[account]=true;
	}

    function takeOutErrorTransfer(address tokenaddress) public
    {
        require(msg.sender==_owner);
        IBEP20(tokenaddress).transfer(_owner, IBEP20(tokenaddress).balanceOf(address(this)));
    }

    function mint(address account,uint256 amount) public 
    {
        require(_minter[msg.sender]==true,"Must be minter");
        _mint(account,amount);
    }

    function _mint(address account, uint256 amount) private {
        require(account != address(0), 'BEP20: mint to the zero address');
        require(totalSupply().add(amount) <=_maxSupply,"MAX SUPPLY OVER");
        _totalsupply=_totalsupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }


    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _transfer(sender, recipient, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function burnFrom(address sender, uint256 amount) public override  returns (bool)
    {
         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _burn(sender,amount);
        return true;
    }

    function burn(uint256 amount) public override returns (bool)
    {
        _burn(msg.sender,amount);
        return true;
    }
 
    function _burn(address sender,uint256 tAmount) private
    {
         require(sender != address(0), "ERC20: transfer from the zero address");
        require(tAmount > 0, "Transfer amount must be greater than zero");
        _balances[sender] = _balances[sender].sub(tAmount);
        _balances[address(0)] = _balances[address(0)].add(tAmount);
         emit Transfer(sender, address(0), tAmount);
    }


    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        // Check for overflows 
		require(!frozenAccount[sender]); 
		
		// Check if sender is frozen 
		require(!frozenAccount[recipient]); 
        
        require(_banneduser[sender]==false,"banned");
  
        uint256 toamount = amount;
        if(recipient == _pancakeAddress)
        {
            if(!isExcluded(sender))
            {
                uint256 onepercent = amount.mul(1).div(100);
                if(onepercent > 0)
                {
                     uint256 p = onepercent.mul(5);
                    _balances[sender]= _balances[sender].sub(p);
                    _balances[address(0)]=_balances[address(0)].add(onepercent);
                    emit Transfer(sender, address(0), onepercent);
                    
                    _balances[_feeowner]= _balances[_feeowner].add(onepercent);
                    emit Transfer(sender, _feeowner, onepercent);
                    
                    _balances[_minerpool]= _balances[_minerpool].add(onepercent.mul(3));
                    ICIUMiner(_miner).AddOneCut(onepercent.mul(3));
                    emit Transfer(sender, _minerpool, onepercent.mul(3));
                    toamount = amount.sub(p);
                }
            }
        }

        _balances[sender]= _balances[sender].sub(toamount);
        _balances[recipient] = _balances[recipient].add(toamount); 
        emit Transfer(sender, recipient, toamount);
    }
	
	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens 
	/// @param target Address to be frozen 
	/// @param freeze either to freeze it or not 
	function freezeAccount(address target, bool freeze) onlyOwner public { // 冻结账户 
		frozenAccount[target] = freeze; emit FrozenFunds(target, freeze); 
	}

    
}