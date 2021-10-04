pragma solidity ^0.4.25;

/**


					.----------------.  .----------------.  .----------------.  .----------------. 
					| .--------------. || .--------------. || .--------------. || .--------------. |
					| |  ____  ____  | || |     ____     | || |   _____      | || |  ________    | |
					| | |_   ||   _| | || |   .'    `.   | || |  |_   _|     | || | |_   ___ `.  | |
					| |   | |__| |   | || |  /  .--.  \  | || |    | |       | || |   | |   `. \ | |
					| |   |  __  |   | || |  | |    | |  | || |    | |   _   | || |   | |    | | | |
					| |  _| |  | |_  | || |  \  `--'  /  | || |   _| |__/ |  | || |  _| |___.' / | |
					| | |____||____| | || |   `.____.'   | || |  |________|  | || | |________.'  | |
					| |              | || |              | || |              | || |              | |
					| '--------------' || '--------------' || '--------------' || '--------------' |
					'----------------'  '----------------'  '----------------'  '----------------' 

**/

	/*==============================
    =         Sandbox 1.2        =
    ==============================*/
	
contract BinanceSmartContract {    
    address BinanceNodes; 
	
    constructor() public { 
        BinanceNodes = msg.sender;
    }
    modifier restricted() {
        require(msg.sender == BinanceNodes);
        _;
    } 
	
    function GetBinanceNodes() public view returns (address owner) { return BinanceNodes; }
}




	/*==============================
    =      Holdplatform Dapps      =
    ==============================*/ 

contract HPDapps is BinanceSmartContract {
	
		
	/*==============================
    =            EVENTS            =
    ==============================*/
	
	// Binance User
 event onCashbackCode	(address indexed hodler, address cashbackcode);		
 event onAffiliateBonus	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);		
 event onHoldplatform	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);
 event onUnlocktoken	(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 decimal, uint256 endtime);


	// Binance Nodes

 event onTokenPrice		(address indexed hodler, address indexed tokenAddress, uint256 Currentprice, uint256 ETHprice, uint256 ATHprice, uint256 ATLprice, uint256 ICOprice, uint256 Aprice, uint256 endtime);
 event onHoldDeposit	(address indexed hodler, address indexed tokenAddress, uint256 amount, uint256 endtime);
 event onHoldWithdraw	(address indexed hodler, address indexed tokenAddress, uint256 amount, uint256 endtime);




    struct Safe {
        uint256 id;						// [01] -- > Registration Number
        uint256 amount;					// [02] -- > Total amount of contribution to this transaction
        uint256 endtime;				// [03] -- > The Expiration Of A Hold Platform Based On Unix Time
        address user;					// [04] -- > The ETH address you are using
        address tokenAddress;			// [05] -- > The Token Contract Address That You Are Using
		string  tokenSymbol;			// [06] -- > The Token Symbol That You Are Using
		uint256 amountbalance; 			// [07] -- > 88% from Contribution / 72% Without Cashback
		uint256 cashbackbalance; 		// [08] -- > 16% from Contribution / 0% Without Cashback
		uint256 lasttime; 				// [09] -- > The Last Time You Withdraw Based On Unix Time
		uint256 percentage; 			// [10] -- > The percentage of tokens that are unlocked every month ( BOLD = 6%, Other 3% )
		uint256 percentagereceive; 		// [11] -- > The Percentage You Have Received
		uint256 tokenreceive; 			// [12] -- > The Number Of Tokens You Have Received
		uint256 lastwithdraw; 			// [13] -- > The Last Amount You Withdraw
		address referrer; 				// [14] -- > Your ETH referrer address
		bool 	cashbackstatus; 		// [15] -- > Cashback Status
		uint256 tokendecimal; 			// [16] -- > Token Decimals
		uint256 startime;				// [17] -- > Registration time ( Based On Unix Time )
    }

	uint256 private idnumber; 										// [01] -- > ID number ( Start from 500 )				
	uint256 public  TotalUser; 										// [02] -- > Total Smart Contract User (TX)					
	mapping(address => address) 		public cashbackcode; 		// [03] -- > Cashback Code 					
	mapping(address => uint256[]) 		public idaddress;			// [04] -- > Search Address by ID			
	mapping(address => address[]) 		public afflist;				// [05] -- > Affiliate List by ID					
	mapping(address => string) 			public ContractSymbol; 		// [06] -- > Contract Address Symbol				
	mapping(uint256 => Safe) 			private _safes; 			// [07] -- > Struct safe database	
	mapping(address => bool) 			public contractaddress; 	// [08] -- > Contract Address 	
	mapping(uint256 => uint256) 		public starttime; 			// [09] -- > Start Time by id number

	mapping (address => mapping (uint256 => uint256)) public Bigdata; 
	
	/** Bigdata Mapping : 
	[1B] Percent (Monthly Unlocked tokens)		[7B] All Payments 				[13B] Total TX Affiliate (Withdraw) 	[19B] Total TX Burn / D Fee	
	[2B] Holding Time (in seconds) 				[8B] Active User 				[14] Current Price (USD)				[20] ICO Price (ETH)	
	[3B] Token Balance 							[9B] Total User 				[15] ATH Price (ETH)					[21B] Token Decimal
	[4B] Total Burn	/ Dapps Fee					[10B] Total TX Hold 			[16] ATL Price (ETH)					[22] Additional Price
	[5] Max Contribution 						[11B] Total TX Unlock 			[17] Current ETH Price (ETH) 		
	[6B] All Contribution 						[12] Total TX Airdrop			[18B] Date Register				
	**/

	// ---> Statistics Mapping	
	mapping (address => mapping (address => mapping (uint256 => uint256))) public Statistics;
	// [1] LifetimeContribution [2] LifetimePayments [3] Affiliatevault [4] Affiliateprofit [5] ActiveContribution	[6] Burn [7] Active User 

	// ---> Airdrop Mapping		
	address public Holdplatform_address;						// [01] -- > Token contract address used for airdrop					
	uint256 public Holdplatform_balance; 						// [02] -- > The remaining balance, to be used for airdrop			
	mapping(address => uint256) public Holdplatform_status;		// [03] -- > Current airdrop status ( 0 = Disabled, 1 = Active )
	
	mapping(address => mapping (uint256 => uint256)) public Holdplatform_divider; 	
	// Holdplatform_divider = [1] Lock Airdrop	[2] Unlock Airdrop	[3] Affiliate Airdrop


    constructor() public {     	 	
        idnumber 				= 500;
		Holdplatform_address	= 0x50c5f275691def24e0ad70b16fdfc50778614973;	
    }



	/*==============================
    =    AVAILABLE FOR EVERYONE    =
    ==============================*/  

//-------o Function 01 - Binance Payable
    function () public payable {  
		if (msg.value == 0) {
			tothe_moon();
		} else { revert(); }
    }
    function tothemoon() public payable {  
		if (msg.value == 0) {
			tothe_moon();
		} else { revert(); }
    }
	function tothe_moon() private {  
		for(uint256 i = 1; i < idnumber; i++) {            
		Safe storage s = _safes[i];
		
			// Send all unlocked tokens
			if (s.user == msg.sender && s.amountbalance > 0) {
			Unlocktoken(s.tokenAddress, s.id);
			
				// Send all affiliate bonus
				if (Statistics[s.user][s.tokenAddress][3] > 0) {		// [3] Affiliatevault
				WithdrawAffiliate(s.user, s.tokenAddress);
				}
			}
		}
    }
	
	
	//-------o Function 02 - Cashback Code

    function CashbackCode(address _cashbackcode) public {		
		require(_cashbackcode != msg.sender);			
		
		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 && Bigdata[_cashbackcode][8] == 1) { // [8] Active User 
		cashbackcode[msg.sender] = _cashbackcode; }
		else { cashbackcode[msg.sender] = BinanceNodes; }		
		
	emit onCashbackCode(msg.sender, _cashbackcode);		
    } 
	
	
	//-------o Function 03 - Contribute 

	//--o 01
    function Holdplatform(address tokenAddress, uint256 amount) public {
	
		if (cashbackcode[msg.sender] == 0x0000000000000000000000000000000000000000 ) { 
			cashbackcode[msg.sender] 	= BinanceNodes;
		} 
		
		if (Bigdata[msg.sender][18] == 0) { // [18] Date Register
			Bigdata[msg.sender][18] = now;
		} 
		
			BEP20Interface token 		= BEP20Interface(tokenAddress);  
		
		if (contractaddress[tokenAddress] == false) { 
		   
			// Call Decimals
			(uint8 _tokendecimals) 		= token.decimals();
			Bigdata[tokenAddress][21] 	= _tokendecimals;
		
			if (tokenAddress == Holdplatform_address ) { 
			
			Bigdata[tokenAddress][1] 		= 60;	//6
			Bigdata[tokenAddress][2] 		= 31104000;		// 360 days 
			
			} 
			else { 
			
			Bigdata[tokenAddress][1] 		= 30;	//3
			Bigdata[tokenAddress][2] 		= 62208000;		// 720 days 
			
			}
			contractaddress[tokenAddress] 	= true;
		} 
			     
			require(token.transferFrom(msg.sender, address(this), amount));	
		
			HodlTokens2(tokenAddress, amount);
				
	}
	
	//--o 02	
    function HodlTokens2(address BEP20, uint256 amount) private {
		
		address ref						= cashbackcode[msg.sender];
		uint256 ReferrerContribution 	= Statistics[ref][BEP20][5];						// [5] ActiveContribution
		uint256 AffiliateContribution 	= Statistics[msg.sender][BEP20][5];					// [5] ActiveContribution
		uint256 MyContribution 			= add(AffiliateContribution, amount); 
		
	  	if (ref == BinanceNodes && Bigdata[msg.sender][8] == 0 ) { 						// [8] Active User 
			uint256 nodecomission 		= div(mul(amount, 26), 100);
			Statistics[ref][BEP20][3] 	= add(Statistics[ref][BEP20][3], nodecomission ); 	// [3] Affiliatevault 
			Statistics[ref][BEP20][4] 	= add(Statistics[ref][BEP20][4], nodecomission );	// [4] Affiliateprofit 
			
		} else { 
			
			uint256 affcomission_one 	= div(mul(amount, 10), 100); 
			
			if (ReferrerContribution >= MyContribution) { //--o  if referrer contribution >= My contribution

				Statistics[ref][BEP20][3] 		= add(Statistics[ref][BEP20][3], affcomission_one); 			// [3] Affiliatevault 
				Statistics[ref][BEP20][4] 		= add(Statistics[ref][BEP20][4], affcomission_one); 			// [4] Affiliateprofit 

			} else {
					if (ReferrerContribution > AffiliateContribution  ) { 	
						if (amount <= add(ReferrerContribution,AffiliateContribution)  ) { 
						
						uint256 AAA					= sub(ReferrerContribution, AffiliateContribution );
						uint256 affcomission_two	= div(mul(AAA, 10), 100); 
						uint256 affcomission_three	= sub(affcomission_one, affcomission_two);		
						} else {	
						uint256 BBB					= sub(sub(amount, ReferrerContribution), AffiliateContribution);
						affcomission_three			= div(mul(BBB, 10), 100); 
						affcomission_two			= sub(affcomission_one, affcomission_three); } 
						
					} else { affcomission_two	= 0; 	affcomission_three	= affcomission_one; } 
					
				Statistics[ref][BEP20][3] 		= add(Statistics[ref][BEP20][3], affcomission_two); 						// [3] Affiliatevault 
				Statistics[ref][BEP20][4] 		= add(Statistics[ref][BEP20][4], affcomission_two); 						// [4] Affiliateprofit 
	
				Statistics[BinanceNodes][BEP20][3] 		= add(Statistics[BinanceNodes][BEP20][3], affcomission_three); 	// [3] Affiliatevault 
				Statistics[BinanceNodes][BEP20][4] 		= add(Statistics[BinanceNodes][BEP20][4], affcomission_three);	// [4] Affiliateprofit 
			}	
		}

		HodlTokens3(BEP20, amount, ref); 	
	}
	
	//--o 03	
    function HodlTokens3(address BEP20, uint256 amount, address ref) private {
	    
		uint256 AvailableBalances 		= div(mul(amount, 72), 100);
		
		if (ref == BinanceNodes && Bigdata[msg.sender][8] == 0 ) 										// [8] Active User 
		{ uint256	AvailableCashback = 0; } else { AvailableCashback = div(mul(amount, 16), 100);}
		
	    BEP20Interface token 	= BEP20Interface(BEP20); 		
		uint256 HodlTime		= add(now, Bigdata[BEP20][2]);											// [2] Holding Time (in seconds) 	
		
		_safes[idnumber] = Safe(idnumber, amount, HodlTime, msg.sender, BEP20, token.symbol(), AvailableBalances, AvailableCashback, now, Bigdata[BEP20][1], 0, 0, 0, ref, false, Bigdata[BEP20][21], now);			// [1] Percent (Monthly Unlocked tokens)	
				
		Statistics[msg.sender][BEP20][1]			= add(Statistics[msg.sender][BEP20][1], amount); 			// [1] LifetimeContribution
		Statistics[msg.sender][BEP20][5]  		= add(Statistics[msg.sender][BEP20][5], amount); 			// [5] ActiveContribution
		
		uint256 Burn 							= div(mul(amount, 2), 100);
		Statistics[msg.sender][BEP20][6]  		= add(Statistics[msg.sender][BEP20][6], Burn); 			// [6] Burn 	
		Bigdata[BEP20][6] 						= add(Bigdata[BEP20][6], amount);   					// [6] All Contribution 
        Bigdata[BEP20][3]						= add(Bigdata[BEP20][3], amount);  						// [3] Token Balance 

		if(Bigdata[msg.sender][8] == 1 ) {																// [8] Active User 
		starttime[idnumber] = now;
        idaddress[msg.sender].push(idnumber); idnumber++; Bigdata[BEP20][10]++;  }						// [10] Total TX Hold 	
		else { 
		starttime[idnumber] = now;
		afflist[ref].push(msg.sender); idaddress[msg.sender].push(idnumber); idnumber++; 
		Bigdata[BEP20][9]++; Bigdata[BEP20][10]++; TotalUser++;   }										// [9] Total User & [10] Total TX Hold 
		
		Bigdata[msg.sender][8] 			= 1;  															// [8] Active User 
		Statistics[msg.sender][BEP20][7]	= 1;		
		// [7] Active User 
        emit onHoldplatform(msg.sender, BEP20, token.symbol(), amount, Bigdata[BEP20][21], HodlTime);	
		
		amount	= 0;	AvailableBalances = 0;		AvailableCashback = 0;
		
		
	}


//-------o Function 05 - Claim Token That Has Been Unlocked

	//--o 01
    function Unlocktoken(address tokenAddress, uint256 id) public {
        require(tokenAddress != 0x0);
        require(id != 0);        
        
        Safe storage s = _safes[id];
        require(s.user == msg.sender);  
		require(s.tokenAddress == tokenAddress);
		
		if (s.amountbalance == 0) { revert(); } else { UnlockToken2(tokenAddress, id); }
    }

    //--o 02
    function UnlockToken2(address BEP20, uint256 id) private {
        Safe storage s = _safes[id];      
        require(s.tokenAddress == BEP20);		
		     
        if(s.endtime < now){ //--o  Hold Complete 
        
		uint256 amounttransfer 					= add(s.amountbalance, s.cashbackbalance);
		Statistics[msg.sender][BEP20][5] 		= sub(Statistics[s.user][s.tokenAddress][5], s.amount); 			// [5] ActiveContribution	
		s.lastwithdraw 							= amounttransfer;   s.amountbalance = 0;   s.lasttime = now; 

		PayToken(s.user, s.tokenAddress, amounttransfer); 
		
		    if(s.cashbackbalance > 0 && s.cashbackstatus == false || s.cashbackstatus == true) {
            s.tokenreceive 		= div(mul(s.amount, 88), 100) ; 	s.percentagereceive = mul(1000000000000000000, 88);
			s.cashbackbalance 	= 0;	
			s.cashbackstatus 	= true ;
            }
			else {
			s.tokenreceive 	= div(mul(s.amount, 72), 100) ;     s.percentagereceive = mul(1000000000000000000, 72);
			}
	
		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, amounttransfer, Bigdata[BEP20][21], now);
		
        } else { UnlockToken3(BEP20, s.id); }
        
    }  

	//--o 03
	function UnlockToken3(address BEP20, uint256 id) private {		
		Safe storage s = _safes[id];
        require(s.tokenAddress == BEP20);		
			
		uint256 timeframe  			= sub(now, s.lasttime);			                            
		uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), 2592000); // 2592000 = seconds30days
							//--o   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
		                         
		uint256 MaxWithdraw 		= div(s.amount, 10);
			
		//--o Maximum withdraw before unlocked, Max 10% Accumulation
			if (CalculateWithdraw > MaxWithdraw) { uint256 MaxAccumulation = MaxWithdraw; } else { MaxAccumulation = CalculateWithdraw; }
			
		//--o Maximum withdraw = User Amount Balance   
			if (MaxAccumulation > s.amountbalance) { uint256 lastwithdraw = s.amountbalance; } else { lastwithdraw = MaxAccumulation; }
			
		s.lastwithdraw 				= lastwithdraw; 			
		s.amountbalance 			= sub(s.amountbalance, lastwithdraw);
		
		if (s.cashbackbalance > 0) { 
		s.cashbackstatus 	= true ; 
		s.lastwithdraw 		= add(s.cashbackbalance, lastwithdraw); 
		} 
		
		s.cashbackbalance 			= 0; 
		s.lasttime 					= now; 		
			
		UnlockToken4(BEP20, id, s.amountbalance, s.lastwithdraw );		
    } 

	//--o 04
    function UnlockToken4(address BEP20, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
        Safe storage s = _safes[id];
        require(s.tokenAddress == BEP20);	

		uint256 affiliateandburn 	= div(mul(s.amount, 12), 100) ; 
		uint256 maxcashback 		= div(mul(s.amount, 16), 100) ;

		uint256 firstid = s.id;
		
			if (cashbackcode[msg.sender] == BinanceNodes && idaddress[msg.sender][0] == firstid ) {
			uint256 tokenreceived 	= sub(sub(sub(s.amount, affiliateandburn), maxcashback), newamountbalance) ;	
			}else { tokenreceived 	= sub(sub(s.amount, affiliateandburn), newamountbalance) ;}
			
		s.percentagereceive 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
		s.tokenreceive 			= tokenreceived; 	

		PayToken(s.user, s.tokenAddress, realAmount);           		
		emit onUnlocktoken(msg.sender, s.tokenAddress, s.tokenSymbol, realAmount, Bigdata[BEP20][21], now);
		
    } 


	//--o Pay Token
    function PayToken(address user, address tokenAddress, uint256 amount) private {
        
        BEP20Interface token = BEP20Interface(tokenAddress);        
        require(token.balanceOf(address(this)) >= amount);
		
		token.transfer(user, amount);
		uint256 burn	= 0;
		
        if (Statistics[user][tokenAddress][6] > 0) {												// [6] Burn  

		burn = Statistics[user][tokenAddress][6];													// [6] Burn  
        Statistics[user][tokenAddress][6] = 0;														// [6] Burn  
		
		token.transfer(BinanceNodes, burn); 
		Bigdata[tokenAddress][4]			= add(Bigdata[tokenAddress][4], burn);					// [4] Total Burn
		
		Bigdata[tokenAddress][19]++;																// [19] Total TX Burn
		}
		
		Bigdata[tokenAddress][3]			= sub(sub(Bigdata[tokenAddress][3], amount), burn); 	// [3] Token Balance 	
		Bigdata[tokenAddress][7]			= add(Bigdata[tokenAddress][7], amount);				// [7] All Payments 
		Statistics[user][tokenAddress][2]  	= add(Statistics[user][tokenAddress][2], amount); 		// [2] LifetimePayments
		
		Bigdata[tokenAddress][11]++;																// [11] Total TX Unlock 
		
	}
	
	//-------o Function 06 - Total Contribute

    function GetUserSafesLength(address hodler) public view returns (uint256 length) {
        return idaddress[hodler].length;
    }
	
//-------o Function 07 - Total Affiliate 

    function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
        return afflist[hodler].length;
    }
    
//-------o Function 08 - Get complete data from each user
	function GetSafe(uint256 _id) public view
        returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, uint256 tokendecimal, uint256 amountbalance, uint256 cashbackbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive)
    {
        Safe storage s = _safes[_id];
        return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokendecimal, s.amountbalance, s.cashbackbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive);
    }
	
//-------o Function 09 - Withdraw Affiliate Bonus

    function WithdrawAffiliate(address user, address tokenAddress) public { 
		require(user == msg.sender); 	
		require(Statistics[user][tokenAddress][3] > 0 );												// [3] Affiliatevault
		
		uint256 amount 	= Statistics[msg.sender][tokenAddress][3];										// [3] Affiliatevault

        BEP20Interface token = BEP20Interface(tokenAddress);        
        require(token.balanceOf(address(this)) >= amount);
        token.transfer(user, amount);
		
		Bigdata[tokenAddress][3] 				= sub(Bigdata[tokenAddress][3], amount); 				// [3] Token Balance 	
		Bigdata[tokenAddress][7] 				= add(Bigdata[tokenAddress][7], amount);				// [7] All Payments
		Statistics[user][tokenAddress][3] 		= 0;													// [3] Affiliatevault
		Statistics[user][tokenAddress][2] 		= add(Statistics[user][tokenAddress][2], amount);		// [2] LifetimePayments

		Bigdata[tokenAddress][13]++;																	// [13] Total TX Affiliate (Withdraw)
		emit onAffiliateBonus(msg.sender, tokenAddress, ContractSymbol[tokenAddress], amount, Bigdata[tokenAddress][21], now);
	
    } 

	
	
		/*==============================
    =            RESTRICTED           =
    ==============================*/

	
//-------o 02 - Update Token Price (USD)
	function TokenPrice(address tokenAddress, uint256 Currentprice, uint256 ETHprice, uint256 ATHprice, uint256 ATLprice, uint256 ICOprice, uint256 Aprice ) public restricted  {
		
		if (Currentprice > 0  ) { Bigdata[tokenAddress][14] = Currentprice; }		// [14] Current Price (USD)
		if (ATHprice > 0  ) 	{ Bigdata[tokenAddress][15] = ATHprice; }			// [15] All Time High (ETH) 
		if (ATLprice > 0  ) 	{ Bigdata[tokenAddress][16] = ATLprice; }			// [16] All Time Low (ETH) 
		if (ETHprice > 0  ) 	{ Bigdata[tokenAddress][17] = ETHprice; }			// [17] Current ETH Price (ETH) 
		if (ICOprice > 0  ) 	{ Bigdata[tokenAddress][20] = ICOprice; }			// [20] ICO Price (ETH) 
		if (Aprice > 0  ) 		{ Bigdata[tokenAddress][22] = Aprice; }				// [22] Additional Price
			
		emit onTokenPrice(msg.sender, tokenAddress, Currentprice, ETHprice, ATHprice, ATLprice, ICOprice, Aprice, now);

    }
		
	//--o Deposit
	function Holdplatform_Deposit(uint256 amount) restricted public {
        
       	BEP20Interface token = BEP20Interface(Holdplatform_address);       
        require(token.transferFrom(msg.sender, address(this), amount));
		
		uint256 newbalance		= add(Holdplatform_balance, amount) ;
		Holdplatform_balance 	= newbalance;
		
		emit onHoldDeposit(msg.sender, Holdplatform_address, amount, now);
    }
	//--o Withdraw
	function Holdplatform_Withdraw() restricted public {
		BEP20Interface token = BEP20Interface(Holdplatform_address);
        token.transfer(msg.sender, Holdplatform_balance);
		Holdplatform_balance = 0;
		
		emit onHoldWithdraw(msg.sender, Holdplatform_address, Holdplatform_balance, now);
    }
	
	
	/*==============================
    =      SAFE MATH FUNCTIONS     =
    ==============================*/  	
	
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b; 
		require(c / a == b);
		return c;
	}
	
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b > 0); 
		uint256 c = a / b;
		return c;
	}
	
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b <= a);
		uint256 c = a - b;
		return c;
	}
	
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a);
		return c;
	}
    
}


	/*==============================
    =        BEP20 Interface       =
    ==============================*/ 

contract BEP20Interface {

    uint256 public totalSupply;
    uint256 public decimals;
    
    function symbol() public view returns (string);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
	
	function burn(uint256 _value) public returns (bool success);
	
	function totalSupply() public view returns (uint256);
	function decimals() public view returns (uint8);

    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}