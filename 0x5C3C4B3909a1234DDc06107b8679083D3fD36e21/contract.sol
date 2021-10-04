pragma solidity ^0.8.4;
// SPDX-License-Identifier: Unlicensed
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



interface IERC20 {


    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
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
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    
    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }
    
    function getTime() public view returns (uint256) {
        return block.timestamp;
    }

    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

contract prizeMarketingPool is Context, Ownable {

    string private _name = "DistributableRouter";
    string private _symbol = "Distribution";
    uint256 public  currentWithrawableReference = 0;
   
   
    IERC20 public busd = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    address public marketing = 0x910Ad70E105224f503067DAe10b518F73B07b5cD;
    address public prizePool = 0x0d5cC40d34243ae68519f6d10D0e0B61Cd297DFE;
    uint256 public marketingPart = 66;
    uint256 public prizepoolpart = 33;
    constructor () {
        
        

    }
    
    function name() public view returns (string memory) {
        return _name;
    }
   function updateBUSD(IERC20 newBUSD) public onlyOwner{
       busd = IERC20(newBUSD);
   }
    function newMarketing(address newAddress) public onlyOwner{
            marketing= newAddress;
    }
    function newPrizePool(address newAddress) public onlyOwner{
            prizePool = newAddress;
    }
    
    function divideAndTransfer() public onlyOwner{
        uint256 currentBusdBalance = busd.balanceOf(address(this));

        busd.transfer(marketing , currentBusdBalance*marketingPart/100);
        currentBusdBalance = busd.balanceOf(address(this));
        busd.transfer(prizePool, currentBusdBalance);

    }



    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function transferBalanceInAmount(address payable recipient, uint256 amount) external onlyOwner {
        uint256 transferAmount = amount * 10**18;
        recipient.transfer(transferAmount);
    }
   

    function transferFullBalance(address payable recipient) external onlyOwner {
        recipient.transfer(address(this).balance);
    }

    function balanceSC () public view returns(uint256){
        //address payable selfValue = this.balance();
       
        return busd.balanceOf(address(this));
    }
    

    


     //to receive bnb
    receive() external payable {}
}