pragma solidity ^0.8.0;

import "./SafeMath.sol";
import "./ERC20.sol";

contract RCWToken is ERC20 {
    using SafeMath for uint256;
    IERC20 public token;

    mapping(address => bool) bots;
    mapping(address => uint256) public balances;
    //mapping(address => mapping(address => uint)) public allowance;
    uint public maxSupply = 100000000 * 10 ** 18; // 100M
    
    event CreateCharacter(uint256 amount, string msg);
    event BuyItem(uint256 amount, string msg);
    event ConvertPoints(uint256 amount, string msg);

     constructor(string memory name, string memory symbol) ERC20(name, symbol)
     {
       _mint(_msgSender(), maxSupply);
     }

    function createCharacter(address recipient, uint256 amount) public payable{
        transferFrom(msg.sender, recipient, amount);
    }

    function buyItem(address recipient, uint256 amount) public payable{
        transferFrom(msg.sender, recipient, amount);
        
    }

     function convertPoints(address recipient, uint256 amount) public payable{
        transferFrom(msg.sender, recipient, amount);
    }
    
}