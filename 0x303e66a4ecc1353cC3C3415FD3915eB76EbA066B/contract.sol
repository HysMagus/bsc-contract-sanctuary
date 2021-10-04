pragma solidity ^0.5.8;

interface NFT{
    function transferFrom(address _from,address _to,uint256 _tokenId)external;
    function approve(address _approved,uint256 _tokenId) external;
    function safeTransferFrom(address _from,address _to,uint256 _tokenId) external;
    enum starType {st_nil,st1,st2,st3,st4,st5,st6}
    enum teamType {t_nil,t1,t2}
    function mint(address _to,uint256 _tokenId,uint256 _power,teamType _ttype,starType _stype,string calldata _uri) external ;
    function viewTokenID() view external returns(uint256);
    function setTokenTypeAttributes(uint256 _tokenId,uint8 _typeAttributes,uint256 _tvalue) external;
}

interface IERC20{
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}

interface IREL{
    function setParent(address _ply,address _parent) external;
    function getPlyParent(address _ply) external view returns(address);
    function sonNumber(address _ply) external view returns(uint256);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }


    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract saleStar{

    using SafeMath for *;

    address public owner;



    address payable public teamAddr;
    uint256 public plyBiggerAmount;

    mapping(address => bool) public manager;
    mapping(address => uint256) public plyBuyAmount;
    mapping(uint256 => SaleNFT) public saleInfo;
    mapping(uint256 => SalePrice) public salePriceInfo;
    mapping(uint256 => SaleNumber) public alreadySaleAmount;

    mapping(address => uint256) public gaftBuyHUSD;
    mapping(address => uint256) public gaftBuyGSD;

    mapping(address => uint256) public gaftNFTBalance;
    mapping(address => uint256[]) public gaftTokenIDList;
    mapping(address => mapping(uint256=>bool)) public isUserGaftTokenID;

    mapping(address => uint256) public plyseed;// ply ->
    mapping(address => uint256) public plySonBuy; // ply -> total son
    mapping(address => mapping(address => bool)) public plySonBuyFlage; // ply -> total son
    mapping(address => uint256) public getGaftByRel; // ply -> gaft number, this 5 seed can buy one;
    address public relAddr;
    uint256 public seedLimit;
    mapping(uint256 => uint256) public imageIdexRoundUp;

    struct SaleNFT{
        address receiveToken;
        uint8 saleState;
        uint256 totalSaleAmount;
        uint256 alreadySaleAmount;
        uint256 numberA;
        uint256 numberB;
        uint256 numberC;
        uint256 numberD;
        uint256 numberE;
        uint256 numberF;
    }

    struct  SaleNumber{
        uint256 numberA;
        uint256 numberB;
        uint256 numberC;
        uint256 numberD;
        uint256 numberE;
        uint256 numberF;
    }

    struct SalePrice{
        uint256 priceA;
        uint256 priceB;
        uint256 priceC;
        uint256 priceD;
        uint256 priceE;
        uint256 priceF;
    }



    mapping(uint256 => orderStruct) public orderInfo;
    struct orderStruct{
        uint256 tokenID;
        uint256 value;
        uint256 fee;
        uint256 createTime;
        uint256 saleTime;
        address owner;
        address buyer;
        uint8 state; // 1 saleing, 2 cansale; 3; soldOut
    }

    address public fee =  address(0x71180dD1b96aD2D571874B736223a31c00BF1c4B);
    address public HUSD =  address(0x55d398326f99059fF775485246999027B3197955);
    address public GSD =  address(0x55d398326f99059fF775485246999027B3197955);
    address  public sNft = address(0xA4706d9080Afa02A44e6d567Fa4367d2C4eE8132);


    event BuyGftUseHUSD(address _ply,uint256 _amount);
    event BuyGftUseGSD(address _ply,uint256 _amount,uint256 _gaftAmount);
    event BuyGftUseRel(address _ply,uint256 _amount);
    event BuyNFTUseHUSD(address _ply,uint256 _rid,uint8 _team,uint8 _type,uint256 _numberNFT,string  _uri);
    event MintNTF(address _ply, uint256 _id,uint256 _team,uint256 _type,uint256 _power,uint256 _imID);
    constructor(address payable _teamAddr,address _rAddr) public{
        owner = msg.sender;
        teamAddr = _teamAddr;
        plyBiggerAmount = 100000;
        relAddr = _rAddr;
        seedLimit = 5;
        initImageIdex();
    }


    function createSala(
        uint256 _id,
        address _rAddr,
        uint256 _numbA,
        uint256 _numbB,
        uint256 _numbC,
        uint256 _numbD,
        uint256 _numbE,
        uint256 _numbF)
    public onlyManager
    {
        SaleNFT  memory snft = saleInfo[_id];
        require(snft.saleState == 0,"already create this roundID");
        snft = SaleNFT(_rAddr,1,0,0,_numbA,_numbB,_numbC,_numbD,_numbE,_numbF);
        saleInfo[_id] = snft;

    }

    function setPrice(
        uint256 _rid,
        uint256 _priceA,
        uint256 _priceB,
        uint256 _priceC,
        uint256 _priceD,
        uint256 _priceE,
        uint256 _priceF)
    public onlyManager
    {
        SalePrice   memory snftPrice = salePriceInfo[_rid];
        SaleNFT  storage snft = saleInfo[_rid];
        require(saleInfo[_rid].saleState == 1,"not create");
        snftPrice = SalePrice(_priceA,_priceB,_priceC,_priceD,_priceE,_priceF);
        salePriceInfo[_rid] = snftPrice;
        snft.saleState =2;
        snft.totalSaleAmount = _priceA.mul(snft.numberA)
        +_priceB.mul(snft.numberB)
        +_priceC.mul(snft.numberC)
        +_priceD.mul(snft.numberD)
        +_priceE.mul(snft.numberE)
        +_priceF.mul(snft.numberF);


    }
    // 2 is start sale
    function buyNFTUseHUSD(uint256 _rid,uint8 _team,uint8 _type,uint256 _numberNFT,string memory _uri,address _parent) public payable{
        require(teamAddr != address(0),"teamAddr not set");
        require(_parent != address(0),"parent not exit");
        SaleNFT  storage snft = saleInfo[_rid];
        require(snft.saleState == 2,"not right state");
        require(plyBuyAmount[msg.sender] <= plyBiggerAmount,"already buy bigger");

        uint256 typePrice = checkNFTPrice(_rid,_type);
        uint256 _buyAmount = _numberNFT.mul(typePrice);
        require(_buyAmount <= msg.value,"not ength eth");
        uint256 numberToken = _buyAmount.div(typePrice);
        uint256 totalNeed ;
        uint256 canSaleNumber =  getTotalSaleAmount(_rid,_type).sub(getTotalAlreadSaleAmount(_rid,_type));


        if(canSaleNumber < numberToken){
            numberToken = canSaleNumber;
        }
        totalNeed = numberToken.mul(typePrice);
        require(totalNeed > 0,"need big 0 ");

        //IERC20(snft.receiveToken).transferFrom(msg.sender,teamAddr,totalNeed);
        teamAddr.transfer(msg.value);

        for(uint256 i=1;i<=numberToken;i++){
            mintNFTToken(msg.sender,_rid,_team,_type,_uri,0);

        }
        plyBuyAmount[msg.sender] = plyBuyAmount[msg.sender].add(numberToken);
        snft.alreadySaleAmount = snft.alreadySaleAmount.add(totalNeed);
        if(snft.alreadySaleAmount == snft.totalSaleAmount){
            snft.saleState = 3;
        }


        updateParent(msg.sender,_parent);
        emit BuyNFTUseHUSD( msg.sender, _rid, _team, _type, _numberNFT, _uri);
        //emit MintNTF(msg.sender ,_team,_type);
    }

    function updateParent(address _ply,address _parent)  internal{


        address localParnet = IREL(relAddr).getPlyParent(_ply);
        address parentAddr = _parent;
        if(localParnet == address(0)){
            if(_parent != address(1)){
                IREL(relAddr).setParent(_ply,_parent);
            }else{
                parentAddr = teamAddr;
            }

        }else{
            parentAddr = localParnet;
        }
        if(plySonBuyFlage[parentAddr][_ply]){
            return;
        }
        plyseed[parentAddr] = plyseed[_parent].add(1);
        plySonBuy[parentAddr] = plySonBuy[parentAddr].add(1);
        plySonBuyFlage[parentAddr][_ply] = true;

    }

    function getPlyFreeGftInfo(address _ply) public view returns(uint256 _sonNum,uint256 _alreadyGetNftFreeNumber) {
        _sonNum = IREL(relAddr).sonNumber(_ply);
        _alreadyGetNftFreeNumber = getGaftByRel[_ply];
    }

    function buyGftUseHUSD(uint256 _amount,address _parent) public{
        require(_parent != address(0) && msg.sender != _parent,"parent not exit");
        require(_amount <= IERC20(HUSD).allowance(msg.sender,address(this)),"not enght approve");
        require(_amount == 5*1e8 || _amount == 50*1e8,"only 5 or 50");
        IERC20(HUSD).transferFrom(msg.sender,teamAddr,_amount);
        gaftBuyHUSD[msg.sender] = gaftBuyHUSD[msg.sender].add(_amount);

        updateParent(msg.sender,_parent);
        emit BuyGftUseHUSD(msg.sender, _amount);

    }
    function buyGftUseGSD(uint256 _amount,address _parent) public{
        require(_parent != address(0) && msg.sender != _parent,"parent not exit");
        require(_amount <= IERC20(GSD).allowance(msg.sender,address(this)),"not enght approve");

        uint256 _gaftAmount;
        uint256 _priceGsd = 1000000000000000000;
        _gaftAmount = _amount.div(_priceGsd).div(5);
        require(_gaftAmount == 1 || _gaftAmount == 10,"only 5,or 50000");
        // check _gaft amount use gsd price;
        IERC20(GSD).transferFrom(msg.sender,teamAddr,_amount);
        gaftBuyGSD[msg.sender] = gaftBuyGSD[msg.sender].add(_amount);
        updateParent(msg.sender,_parent);
        emit BuyGftUseGSD(msg.sender, _amount,_gaftAmount);
    }

    function buyGftUseRel(uint256 _numberNFT) public{
        uint256 totalSeed = plyseed[msg.sender];
        uint256 needSeed = _numberNFT*seedLimit;
        require(totalSeed >= needSeed,"not enght seed");
        plyseed[msg.sender] = plyseed[msg.sender].sub(needSeed);
        getGaftByRel[msg.sender]  = getGaftByRel[msg.sender].add(_numberNFT);

        emit BuyGftUseRel( msg.sender, _numberNFT);
    }

    function mintGftNFT(address _ply,uint8[] memory _teamList,uint8[] memory _typeList,uint256[] memory _ImageIndexList) public {
        require(manager[msg.sender],"only Manager");
        uint256 len = _teamList.length;
        require(len == _typeList.length && len > 0 && len < 50 && len == _ImageIndexList.length,"lenght not equle");

        uint256 tokenID;
        for(uint256 i=0; i<len;i++){
            tokenID = mintNFTToken(_ply,1,_teamList[i],_typeList[i],"",_ImageIndexList[i]);
            if(!isUserGaftTokenID[_ply][tokenID]){
                isUserGaftTokenID[_ply][tokenID] = true;
                gaftNFTBalance[_ply] +=1;
                gaftTokenIDList[_ply].push(tokenID);

            }
        }

    }

    function mintNFTToken(address _ply,uint256 _rid,uint8 _team,uint8 _type ,string memory _uri,uint256 _imageIdex) internal returns(uint256){
        uint256 tokenID = NFT(sNft).viewTokenID();
        uint256 power = roundPower(_rid,_type);
        NFT.teamType  tType;
        NFT.starType sType;
        bool _mintResult = false;

        if(_team == 1){
            tType = NFT.teamType.t1;
            if(_type ==1){
                sType = NFT.starType.st1;
                _mintResult = true;
                alreadySaleAmount[_rid].numberA++;
            }else if(_type == 2){
                sType = NFT.starType.st2;
                _mintResult = true;
                alreadySaleAmount[_rid].numberB++;
            }else if(_type == 3){
                sType = NFT.starType.st3;
                _mintResult = true;
                alreadySaleAmount[_rid].numberC++;
            }else  if(_type == 4){
                sType = NFT.starType.st4;
                _mintResult = true;
                alreadySaleAmount[_rid].numberD++;
            }
        }else if( _team ==2){
            tType = NFT.teamType.t2;
            if(_type == 5){
                sType = NFT.starType.st5;
                _mintResult = true;
                alreadySaleAmount[_rid].numberE++;
            }else if(_type == 6){
                sType = NFT.starType.st6;
                _mintResult = true;
                alreadySaleAmount[_rid].numberF++;
            }
        }

        uint256 imIdx;
        if(_mintResult){
            NFT(sNft).mint(_ply,tokenID+1,power,tType,sType,_uri);
            imIdx = setImageIdex(tokenID+1,_type,_imageIdex);
        }
        //MintNTF(address _ply, uint256 _id,uint256 _team,uint256 _type,uint256 _power,uint256 _imID);
        emit MintNTF( _ply, tokenID+1,_team,_type,power,imIdx);
        return tokenID+1;

    }

    function setImageIdex(uint256 _tokenId,uint256 _stype,uint256 _imageIdex)  internal returns(uint256){
        uint256 r;
        if(_imageIdex ==0){
            r = roundImageIdx(_stype,_tokenId);
        }else{
            r = _imageIdex;
        }
        NFT(sNft).setTokenTypeAttributes(_tokenId,2,r);
        return r;
    }

    function getTotalAlreadSaleAmount(uint256 _rid,uint8 _type) public view returns(uint256){
        if(_type == 1){
            return alreadySaleAmount[_rid].numberA;
        }else if(_type == 2){
            return alreadySaleAmount[_rid].numberB;
        }else if(_type == 3){
            return alreadySaleAmount[_rid].numberC;
        }else if(_type == 4){
            return alreadySaleAmount[_rid].numberD;
        }else if(_type == 5){
            return alreadySaleAmount[_rid].numberE;
        }else if(_type == 6){
            return alreadySaleAmount[_rid].numberF;
        }
    }

    function getTotalSaleAmount(uint256 _rid,uint8 _type) public view returns(uint256){
        if(_type == 1){
            return saleInfo[_rid].numberA;
        }else if(_type == 2){
            return saleInfo[_rid].numberB;
        }else if(_type == 3){
            return saleInfo[_rid].numberC;
        }else if(_type == 4){
            return saleInfo[_rid].numberD;
        }else if(_type == 5){
            return saleInfo[_rid].numberE;
        }else if(_type == 6){
            return saleInfo[_rid].numberF;
        }
    }

    function checkNFTPrice(uint256 _rid,uint8 _type) public view returns(uint256){
        if(_type == 1){
            return salePriceInfo[_rid].priceA;
        }else if(_type == 2){
            return salePriceInfo[_rid].priceB;
        }else if(_type == 3){
            return salePriceInfo[_rid].priceC;
        }else if(_type == 4){
            return salePriceInfo[_rid].priceD;
        }else if(_type == 5){
            return salePriceInfo[_rid].priceE;
        }else if(_type == 6){
            return salePriceInfo[_rid].priceF;
        }
    }
    function roundPower(uint256 _rid,uint8 _type) public view returns(uint256 ) {
        uint256 tokenID = NFT(sNft).viewTokenID();
        //uint256 tokenID = 1;
        uint256 resultNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number),saleInfo[_rid].alreadySaleAmount,now,tokenID)));
        if(_type == 1){
            uint256 r = resultNumber %20;
            if(r == 0){
                r= 1;
            }
            return  r; // 0-20
        }else if(_type == 2){
            return  (resultNumber %32)+24; // 24-56
        }else if(_type == 3){
            return  (resultNumber %28)+60;//60-88
        }else if(_type == 4){
            return  (resultNumber %100)+130;//130-230
        }else if(_type == 5){
            return  (resultNumber %559)+430;//430-989
        }else if(_type == 6){
            return  (resultNumber %4000)+3418; // 3418-7418
        }
    }

    function setImageIdexRoundUp(uint256 _type,uint256 _up) public onlyManager{
        imageIdexRoundUp[_type] = _up;
    }

    function initImageIdex() internal{
        imageIdexRoundUp[2] = 41;
        imageIdexRoundUp[3] = 17;
        imageIdexRoundUp[4] = 10;
        imageIdexRoundUp[5] = 14;
        imageIdexRoundUp[6] = 7;
        imageIdexRoundUp[7] = 20;
    }

    function roundImageIdx(uint256 _type,uint256 _tokenId) public view returns(uint256){
        uint256 resultNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number),msg.sender,now,_tokenId)));
        if(_type == 4){
            return  (resultNumber % imageIdexRoundUp[4])+151; // 151-161
        }else if(_type == 3){
            return  (resultNumber % imageIdexRoundUp[3])+101; // 101-118
        }else if(_type == 2){
            return  (resultNumber %imageIdexRoundUp[2])+11;//11-52
        }else if(_type == 1){
            return  (resultNumber %imageIdexRoundUp[7])+1001;//1001-1020
        }else if(_type == 5){
            return  (resultNumber %imageIdexRoundUp[5])+200;//200-214
        }else if(_type == 6){
            return  (resultNumber %imageIdexRoundUp[6])+251; // 251-258
        }
    }

    function withHERC20(address tokenAddr, address recipient,uint256 amount) public onlyOwner{

        require(tokenAddr != address(0),"DPAddr: tokenAddr is zero");
        require(recipient != address(0),"DPAddr: recipient is zero");
        IERC20  tkCoin = IERC20(tokenAddr);
        if(tkCoin.balanceOf(address(this)) >= amount){
            tkCoin.transfer(recipient,amount);
        }else{
            tkCoin.transfer(recipient,tkCoin.balanceOf(address(this))) ;
        }
    }


    function setSeedLimit(uint256 _limit) public onlyOwner{
        require(_limit>0,"can not be zero");
        seedLimit = _limit;
    }
    function setNFTToken(address _nftAddr) public onlyOwner{
        sNft = _nftAddr;
    }

    function setFeeAddr(address _fee) public onlyOwner{
        fee = _fee;
    }
    function setBiggerAmount(uint256 _bigger) public onlyOwner{
        plyBiggerAmount = _bigger;
    }

    function addManager(address _mAddr) public onlyOwner{
        manager[_mAddr] = true;
    }
    modifier onlyOwner(){
        require(msg.sender == owner,"only owner");
        _;
    }
    modifier onlyManager(){
        require(manager[msg.sender] ,"only manager");
        _;
    }

}