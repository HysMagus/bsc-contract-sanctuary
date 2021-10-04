pragma solidity ^0.6.0;

//BETA - USE AT YOUR OWN RISK
import "./ERC20.sol"; 

contract WBanano is ERC20 {
  mapping(address => uint) public gasFeeLeft;
  mapping(address => string) public swapTickets;

  address payable public owner;

    constructor() ERC20("wBanano", "wBAN") public {
      owner = msg.sender;
    }


    function coverGasFees() public payable{
      gasFeeLeft[msg.sender] = gasFeeLeft[msg.sender]-msg.value;
      owner.transfer(msg.value);
    }

    function getGasFees(address account) public view returns(uint){
      return gasFeeLeft[account];
    }

    function append(string memory a, string memory b,string memory c) internal returns (string memory) {
      return string(abi.encodePacked(a,b,c));
    }

    function uint2str(uint i) internal pure returns (string memory) {
      if (i == 0) return "";
      uint j = i;
      uint length;
      while (j != 0) {
        length++;
        j /= 10;
      }
      bytes memory bstr = new bytes(length);
      uint k = length - 1;
      while (i != 0) {
        bstr[k--] = byte(uint8(48 + i % 10));
        i /= 10;
      }
      return string(bstr);
    }

    function swapBack(string memory banano_address) public{
      require(gasFeeLeft[msg.sender] <= 0,"Please pay your gas fees first, Hint: getGasFees() ");
      require(balanceOf(msg.sender) > 0,"You dont have any wBAN to swap.");
      require(bytes(banano_address).length == 64,"Not a Banano address");

      swapTickets[msg.sender] = append(uint2str(block.number),banano_address,uint2str(balanceOf(msg.sender)));
      _transfer(_msgSender(), owner, balanceOf(msg.sender));
    }

    function getBanTicket(address account) public view returns(string memory){
      return swapTickets[account];
    }



    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override{
      require(gasFeeLeft[msg.sender] <= 0,"Please pay your gas fee, Hint: getGasFees() ");
      require(gasFeeLeft[from] <= 0,"Please pay your gas fee, Hint: getGasFees() ");
      require(gasFeeLeft[to] <= 0,"Receiver still has to pay gas fee, Hint: getGasFees() ");
    }



    function initialTransfer(address recipient, uint256 amount,uint256 gaslimit) public {
      require(msg.sender == owner, "Only owner can call this function.");
      require(gasFeeLeft[recipient] == 0, "Please cover any previous gas fee.");

      _mint(recipient, amount);

      // _transfer(_msgSender(), recipient, amount);
      gasFeeLeft[recipient] = gaslimit*tx.gasprice+100;
    }
}
