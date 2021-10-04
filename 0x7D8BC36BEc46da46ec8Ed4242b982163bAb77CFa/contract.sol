pragma solidity <=0.7.5;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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

interface ERC {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}



contract Presale{

    ERC public Tether;
    ERC public Token;
    
    AggregatorV3Interface internal ref;

    int8 public salePhase = 1;

    address public admin;

    struct History{
        uint256[] timeStamp;
        int8[] paymentMethod;
        uint256[] amount;
    }

    modifier isAdmin(){
        require(msg.sender == admin,"Access Error");
        _;
    }

    mapping(address => History) history;

    /**
        mapping phases of sale with price, total sold
        and sale caps.
     */

    mapping(int8 => uint256) public tokenPrice;      // 6 precision - 1 USD = 1000000
    mapping(int8 => uint256) public sold;
    mapping(int8 => uint256) public saleCap;

    constructor(address _busdContract, address _tokenContract) public {
        Tether = ERC(_busdContract);
        Token = ERC(_tokenContract);
        ref = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
        admin = msg.sender;
    }

    function PurchaseWithEther() public payable returns(bool){
        uint256 _amountToken = resolverEther(msg.value);
        History storage h = history[msg.sender];
                        h.timeStamp.push(block.timestamp);
                        h.paymentMethod.push(2);
                        h.amount.push(_amountToken);
        Token.transfer(msg.sender,_amountToken);
        payable(admin).transfer(msg.value);
        return true;
    }
    
    /*
        @dev returns the amount of purchased Tokens
        for equivalent ethers
    */
    
    function resolverEther(uint256 _amountEther) public view returns(uint256){
        uint256 bnbPrice = uint256(fetchBnbPrice());
                bnbPrice = SafeMath.mul(_amountEther,bnbPrice); // 18 * 8
                bnbPrice = SafeMath.div(bnbPrice,10**2);        // 26 / 2
        uint256 _tokenAmount = SafeMath.div(bnbPrice,tokenPrice[salePhase]); // 24 / 6
        return _tokenAmount;
    }

    function PurchaseWithTether(
        uint256 _amountTether
        ) 
        public returns(bool){
        require(
                Tether.allowance(msg.sender,address(this)) >= _amountTether,
                "Allowance Exceeded"
                );
        uint256 _amountToken = resolverTether(_amountTether);
        History storage h = history[msg.sender];
                        h.timeStamp.push(block.timestamp);
                        h.paymentMethod.push(1);
                        h.amount.push(_amountToken);
        Tether.transferFrom(msg.sender,admin,_amountTether);
        Token.transfer(msg.sender,_amountToken);
        return true;
    }

    /**
        @dev returns the amount of purchased tokens.
     */
    
    function resolverTether(uint256 _amountTether) private view returns(uint256){
        uint256 _tempAmount = SafeMath.mul(_amountTether,10**6);
        uint256 _tokenAmount = SafeMath.div(_tempAmount,tokenPrice[salePhase]);
        return _tokenAmount;
    }

    /**
       @dev returns the purchase history of a user.
       Pass the user address to the function arguments.
     */

    function fetchPurchaseHistory(address _user) public view returns(
        uint256[] memory timeStamp,
        int8[] memory paymentMethod,
        uint256[] memory amount
    ){
        History storage h = history[_user];
        return (
            h.timeStamp,
            h.paymentMethod,
            h.amount
        );
    }

    function fetchBnbPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = ref.latestRoundData();
        return price;
    }

    function setPrice(int8 _phase,uint256 _price) public isAdmin returns(bool){
        tokenPrice[_phase] = _price;
        return true;
    }

    function setSaleCap(int8 _phase,uint256 _cap) public isAdmin returns(bool){
        saleCap[_phase] = _cap;
        return true;
    }

    function updateSalePhase(int8 _phase) public isAdmin returns(bool){
        salePhase = _phase;
        return true;
    }
    
    function getCurrentSalePrice() public view returns(uint256){
        return tokenPrice[salePhase];
    }
    
    function getAllowance() public view returns(uint256){
        return Tether.allowance(msg.sender,address(this));
    }

    function updateAdmin(address _user) public isAdmin returns(bool){
        admin = _user;
        return true;
    }

    function updateRef(address _newRef) public isAdmin returns(bool){
        ref = AggregatorV3Interface(_newRef);
        return true;
    }

}