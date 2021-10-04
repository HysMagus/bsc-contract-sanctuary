pragma solidity ^0.8.1;

interface ERC {
    function transfer(address to, uint value) external returns (bool);
}


contract Math {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract LockDropContract is Math{
    
    ERC public smartContract;
        
   address public tokenContract;
   address public admin;
   uint256 public lockDropPerBnB;
   
   modifier isAdmin(){
       require(msg.sender == admin,"Not Admin");
       _;
   }
   
   event LockDrop(address indexed to, uint256 value);
   
   constructor(address _admin, address _tokenContract){
       admin = _admin;
       tokenContract = _tokenContract;
   }
   
   function sendTokens(address _receiver,uint256 _amount) private{
       smartContract = ERC(tokenContract);
       smartContract.transfer(
       _receiver, 
       Math.mul(_amount,lockDropPerBnB)
       );
       payable(admin).transfer(_amount);
       emit LockDrop(_receiver,Math.mul(_amount,lockDropPerBnB));
   }
   
   function updateAdmin(address _newAdmin) isAdmin public returns(bool success){
       admin = _newAdmin;
       return true;
   }
   
   function updateTokenContract(address _newContract) isAdmin public returns(bool success){
       tokenContract = _newContract;
       return true;
   }
   
   function updateLockDropPerBnB(uint256 _amount) isAdmin public returns(bool success){
       lockDropPerBnB = _amount;
       return true;
   }
   
   function drain(address _to, uint256 _amount) isAdmin public returns(bool success){
       smartContract.transfer(_to,_amount);
       return true;
   }
   
   receive() external payable{
         sendTokens(msg.sender,msg.value);
   }
   
}