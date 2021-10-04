//mmmmmmm..CakeBakery
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
abstract contract ERC20 {
    function totalSupply() public view virtual returns (uint);
    function balanceOf(address tokenOwner) public view virtual returns (uint balance);
    function allowance(address tokenOwner, address spender) public view virtual returns (uint remaining);
    function transfer(address to, uint tokens) public virtual returns (bool success);
    function approve(address spender, uint tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract BananaBoy {
    using SafeMath for uint256;
    address bananas = 0x603c7f932ED1fc6575303D8Fb018fDCBb0f39a95;
    //uint256 CAKE_TO_MAKE_BAKERS=1;
    uint256 public BANANA_TO_MAKE_MONKEYS=2592000;//for final version should be seconds in a day
    uint256 PSN=10000;
    uint256 PSNH=5000;
    bool public initialized=false;
    address public bananatreeAddress;
    address public bananatreeAddress2;
    mapping (address => uint256) public bananaBoys;
    mapping (address => uint256) public claimedBanana;
    mapping (address => uint256) public lastGrab;
    mapping (address => address) public referrals;
    uint256 public marketTrees;
    constructor() {
        bananatreeAddress=msg.sender;
        bananatreeAddress2=address(0xB4FDc2CD6B152527fEBE121F9D58470A8754B791);
    }
    function compoundBanana(address ref) public{
        require(initialized);
        if(ref == msg.sender) {
            ref = address(0);
        }
        if(referrals[msg.sender]==address(0) && referrals[msg.sender]!=msg.sender){
            referrals[msg.sender]=ref;
        }
        uint256 monkeysUsed=getMyBananas();
        uint256 newMonkeys=SafeMath.div(monkeysUsed,BANANA_TO_MAKE_MONKEYS);
        bananaBoys[msg.sender]=SafeMath.add(bananaBoys[msg.sender],newMonkeys);
        claimedBanana[msg.sender]=0;
        lastGrab[msg.sender]=block.timestamp;
        
        //send referral cakes
        claimedBanana[referrals[msg.sender]]=SafeMath.add(claimedBanana[referrals[msg.sender]],SafeMath.div(monkeysUsed,10));
        
        //boost market to nerf miners hoarding
        marketTrees=SafeMath.add(marketTrees,SafeMath.div(monkeysUsed,5));
    }
    function sellMonkeys() public{
        require(initialized);
        uint256 hasMonkeys=getMyBananas();
        uint256 bananaValue=calculateMonkeySell(hasMonkeys);
        uint256 fee=bananatreeFee(bananaValue);
        uint256 fee2=fee/2;
        claimedBanana[msg.sender]=0;
        lastGrab[msg.sender]=block.timestamp;
        marketTrees=SafeMath.add(marketTrees,hasMonkeys);
        ERC20(bananas).transfer(bananatreeAddress, fee2);
        ERC20(bananas).transfer(bananatreeAddress2, fee-fee2);
        ERC20(bananas).transfer(address(msg.sender), SafeMath.sub(bananaValue,fee));
    }
    function buyMonkeys(address ref, uint256 amount) public{
        require(initialized);
        ERC20(bananas).transferFrom(address(msg.sender), address(this), amount);
        uint256 balance = ERC20(bananas).balanceOf(address(this));	
        uint256 monkeysBought=calculateMonkeyBuy(amount,SafeMath.sub(balance,amount));
        monkeysBought=SafeMath.sub(monkeysBought,bananatreeFee(monkeysBought));
        uint256 fee=bananatreeFee(amount);
        uint256 fee2=fee/2;
        ERC20(bananas).transfer(bananatreeAddress, fee2);
        ERC20(bananas).transfer(bananatreeAddress2, fee-fee2);
        claimedBanana[msg.sender]=SafeMath.add(claimedBanana[msg.sender],monkeysBought);
        compoundBanana(ref);
    }
    //magic trade balancing algorithm
    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
    }
    function calculateMonkeySell(uint256 banana) public view returns(uint256) {
        return calculateTrade(banana,marketTrees,ERC20(bananas).balanceOf(address(this)));
    }
    function calculateMonkeyBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
        return calculateTrade(eth,contractBalance,marketTrees);
    }
    function calculateMonkeyBuySimple(uint256 eth) public view returns(uint256){
        return calculateMonkeyBuy(eth,ERC20(bananas).balanceOf(address(this)));
    }
    function bananatreeFee(uint256 amount) public pure returns(uint256){
        return SafeMath.div(SafeMath.mul(amount,5),100);
    }
    function seedMarket(uint256 amount) public{
        ERC20(bananas).transferFrom(address(msg.sender), address(this), amount);
        require(marketTrees==0);
        initialized=true;
        marketTrees=259200000000;
    }
    function getBalance() public view returns(uint256){
        return ERC20(bananas).balanceOf(address(this));
    }
    function getMyMonkeys() public view returns(uint256){
        return bananaBoys[msg.sender];
    }
    function getMyBananas() public view returns(uint256){
        return SafeMath.add(claimedBanana[msg.sender],getBananasSinceLastGrab(msg.sender));
    }
    function getBananasSinceLastGrab(address adr) public view returns(uint256){
        uint256 secondsPassed=min(BANANA_TO_MAKE_MONKEYS,SafeMath.sub(block.timestamp,lastGrab[adr]));
        return SafeMath.mul(secondsPassed,bananaBoys[adr]);
    }
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}