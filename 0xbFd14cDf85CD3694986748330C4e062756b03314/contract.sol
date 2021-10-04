// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract GamixToken {
    
    address payable private owner;
    bool private _paused;
    bool private _ended;
    
    string public name = "Gamix Token";
    string  public symbol = "GMIX";
    uint8   public decimals = 18;
    uint256 public totalSupply;
    
    uint256 public tokenRate;
    uint256 public tokensSold;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    
    
    event OwnerSet(
        address indexed oldOwner, 
        address indexed newOwner
    );
    
    event Sell(address _buyer, uint256 _amount);
    event Paused(address account);
    event Unpaused(address account);
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // modifier to check if caller is owner
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }    
    
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }
    
    modifier isEnded() {
        require(!_ended, "Sale is Ended");
        _;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    using SafeMath for uint256;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    constructor(){
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
        _paused = false;
        _ended = false;
        totalSupply = 20000 * 1 ether;
        balanceOf[msg.sender] = totalSupply;
    }   
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function changeOwner(address payable newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }    
    
    function getOwner() external view returns (address) {
        return owner;
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        require(balanceOf[msg.sender] >= _value, "Not enough Balance!");
        require(_to != address(0), "You are not allowed to transfer to yourself");
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);

        return true;
    }
    
    function doTransfer(address _to, uint256 _value) private returns (bool success) {
        balanceOf[owner] = balanceOf[owner].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(owner, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "You are not allowed to transfer to yourself");
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);

        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);

        return true;
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                function icoRate(uint256 _tokensPerBnb) public isOwner {
                    require(_tokensPerBnb > 0, "Token rate should be greater than 0");
                    tokenRate = _tokensPerBnb;
                }
                
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
                function paused() public view returns (bool) {
                    return _paused;
                }    
                
                function _pauseIco() public whenNotPaused isOwner {
                    _paused = true;
                    emit Paused(msg.sender);
                }    
                
                function _unPauseIco() public whenPaused isOwner {
                    _paused = false;
                    emit Unpaused(msg.sender);
                }  
                
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                receive() external payable whenNotPaused {
                    buyTokens(msg.sender);
                }  
                
                function buyTokens(address _beneficiary) public payable whenNotPaused isEnded{
                    require(msg.value > 0, "Amount sent must be greater than 0");
                    require(tokenRate > 0, "Token rate is not set");
                    uint256 tokens = tokenRate.mul(msg.value);
                    tokensSold = tokensSold.add(tokens);
                    doTransfer(_beneficiary, tokens);
                
                }
            
                //save  gas
                function endIco() public isOwner {
                    require(transfer(owner, balanceOf[address(this)]));
            
                    // UPDATE: Let's not destroy the contract here
                    // Just transfer the balance to the admin
                    owner.transfer(address(this).balance);
                    _ended = true;
                }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


library SafeMath {     
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      require(b <= a, "Subtraction Error");
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      require(c >= a, "Addition Error");
      return c;
    }  
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
          return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "Multiplication Error");
        return c;
    }  
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
}