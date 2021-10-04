// SPDX-License-Identifier: MIT






pragma solidity ^0.8.0;

abstract contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view virtual returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view virtual returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public virtual;
  function approve(address _to, uint256 _tokenId) public virtual;
  function takeOwnership(uint256 _tokenId) public virtual;
}

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



pragma solidity ^0.8.0;

contract beastFactory is Ownable{
    event Newbeast(uint nftID,uint rare,uint energy,uint typeID,string _typeName);



    uint public cooldownTime = 60; //rare 5 cooldownTime
    //uint public cooldownTime = 2 hours;
    uint public beastPrice = 1000000;
    //uint public beastCount = 0;


    struct Mythicalcreatures{
        string typeName;
    }

    struct Beast{
        uint nftID;
        uint typeID; //神兽种类,
        uint attributeID; //金木水火土
        uint32 rare;
        uint energy; //能量值
        uint32 exp;
        uint32 level;
        uint32 readyTime;
        //uint256 winCount;
        //uint256 lostCount;
        string name;
        string typeName;
    }
    struct Boss{
        uint32 bossId;
        uint32 typeId;
        uint32 attributeID; //金木水火土
        uint32 rare;
        uint32 isready;
        uint32 reward;
        uint32 level;
        uint32 energy;
        string name;
    }



    Boss[] public boss;
    Beast[] public beasts;
    Mythicalcreatures[] public mythicalcreatures;
    mapping(uint=>address) public beastToOwner;
    mapping(address=>uint) public ownerBeastCount;
    mapping(uint=>string)  public mythicalcreaturesToName;
    uint public randNonce;
    uint public modulus;
    uint public typeID;
    uint public typeCount;
    uint public beastsCount;
    //uint public BeastOwnerCount = ownerBeastCount[_msgSender()];
    //mythicalcreaturesps[0] = ['jiuwei' ,'baize','pixiu','qiongqi','luoluo']


    //获取随机数
   function randMod(uint _modulus, uint _targetCount) public returns(uint){
        randNonce++;
        return modulus = (uint(keccak256(abi.encodePacked(_modulus,block.timestamp,msg.sender,randNonce))) % _targetCount)+1;
    }

    //创建神兽种类
    function _createMythicalcreatures(string memory _typeName) public onlyOwner  {
        //uint id = zombies.push(Zombie(_name, _dna, 0, 0, 1, 0)) - 1;
        mythicalcreatures.push(Mythicalcreatures(_typeName));
        typeCount = mythicalcreatures.length;
        typeID = mythicalcreatures.length-1;
        mythicalcreaturesToName[typeID] = _typeName;

    }

    function _createBoss(uint32 _Id,uint32 _typeId, uint32 _attributeId,uint32 _rare,uint32 _isready,uint32 _reward,uint32 _level, uint32 _energy,string memory _name) public  onlyOwner{
        //uint bossId = _Id;
        //uint attributeId = _attributeId;
        //uint rare = _rare;
        //uint isready = _isready;
        //uint reward = _reward;
        //string memory name = _name;
        boss.push(Boss(_Id,_typeId,_attributeId,_rare,_isready,_reward,_level,_energy,_name));

    }

    function _resetBoss(uint32 _Id, uint32 _typeId,uint32 _attributeId,uint32 _rare,uint32 _isready,uint32 _reward,string memory _name) public onlyOwner{
        Boss storage myBoss = boss[_Id];
        myBoss.typeId = _typeId;
        myBoss.attributeID = _attributeId;
        myBoss.rare = _rare;
        myBoss.isready = _isready;
        myBoss.reward = _reward;
        myBoss.name =  _name;
    }


    //实例化一只神兽
    function _createBeasts(uint _modulus) public  {
        require(typeCount>0,'typeCount must be != 0');
        uint _typeID = randMod(modulus,typeCount)-1;
        uint _attributeID =  randMod(modulus,5);
        uint _rare = randMod(_modulus,5);
        //uint _rare;
        uint _energy = randMod(_modulus,_rare*100)+_rare*100;
        uint _nftID = beasts.length;
        beasts.push(Beast(_nftID,_typeID,_attributeID,uint32(_rare),_energy,0,1,0,"Noname",mythicalcreaturesToName[_typeID]));
        beastToOwner[_nftID] = _msgSender();
        ownerBeastCount[_msgSender()] = ownerBeastCount[_msgSender()]+1;
        beastsCount = beastsCount+1;
        emit Newbeast(_nftID,_rare,_energy,_typeID,mythicalcreaturesToName[_typeID]);
    }

    function buyBeast() public payable{
        require(msg.value >= beastPrice);
        _createBeasts(modulus);
    }

    function setBeastPrice(uint _price) external onlyOwner{
        beastPrice = _price;
    }



}



pragma solidity ^0.8.0;


contract beastHelper is beastFactory{
    address public deadAddress = address(0);


    modifier aboveLevel(uint _level, uint _nftID) {
    require(beasts[_nftID].level >= _level,'Level is not sufficient');
    _;
    }

    modifier onlyOwnerOf(uint _nftID){
        require(_msgSender() == beastToOwner[_nftID],'this beast is not yours');
        _;
    }

    modifier multiplyOnlyOwnerOf(uint _nftID, uint _targetNftId){
        require(_msgSender() == beastToOwner[_nftID] && _msgSender() == beastToOwner[_targetNftId],'this beast is not yours');
        _;
    }


    //exp大于20升级
    function expUp(uint _nftID, uint32 _exp) public onlyOwnerOf(_nftID){
        beasts[_nftID].exp = beasts[_nftID].exp + _exp;
        if(beasts[_nftID].exp>=20){
            levelUp(_nftID);
            beasts[_nftID].exp = beasts[_nftID].exp - 20;
        }
    }


    function levelUp(uint _nftID) public onlyOwnerOf(_nftID){
        if(beasts[_nftID].level < 300){
            beasts[_nftID].level+1;
            beasts[_nftID].energy+1;
        }
        if(beasts[_nftID].level >= 300){
            beasts[_nftID].level = 300;
        }
    }

    function changeName(uint _nftID, string calldata _newName)public aboveLevel(2,_nftID) onlyOwnerOf(_nftID){
        beasts[_nftID].name = _newName;
    }

    //获取某个地址的所有神兽
    function getBeastsByOwner(address _owner)external view returns(uint[] memory ){
        uint[] memory results = new uint[](ownerBeastCount[_owner]);
        uint counter =0;
        for (uint i = 0;i<=beasts.length;i++){
            if(beastToOwner[i] == _owner){
                results[counter] = i;
                counter++;
            }
        }
        return results;
    }

    function _triggerCooldown(Beast memory _beast) public view {
        _beast.readyTime = uint32(block.timestamp + (cooldownTime/_beast.rare)) ;
    }

    function setCooldown(uint _nftID) public onlyOwnerOf(_nftID){
        beasts[_nftID].readyTime =uint32(block.timestamp + cooldownTime/beasts[_nftID].rare) ;
    }
    function getCooldown(uint _nftID) public view onlyOwnerOf(_nftID) returns(uint){
        return beasts[_nftID].readyTime;
    }

    function _isReady2(uint _nftID) public view returns (bool) {
      return (beasts[_nftID].readyTime <= block.timestamp);
  }

    function _isReady(Beast memory _beast) public view returns (bool) {
      return (_beast.readyTime <= block.timestamp);
  }

  //卡牌合成,逻辑待确认
  function multiply(uint _nftID, uint _targetNftId) public multiplyOnlyOwnerOf(_nftID,_targetNftId) {
    Beast storage myBeast = beasts[_nftID];
    Beast storage targetBeast = beasts[_targetNftId];
    require(_isReady(myBeast) && _isReady(targetBeast) ,'Beast is not ready');
    uint _modulus =(myBeast.nftID +targetBeast.nftID);
    _createBeasts(_modulus);
    beastToOwner[myBeast.nftID] = deadAddress;
    beastToOwner[targetBeast.nftID] = deadAddress;
    ownerBeastCount[_msgSender()]--;
   // _targetDna = _targetDna % dnaModulus;
    //uint newDna = (myZombie.dna + _targetDna) / 2;
    //newDna = newDna - newDna % 10 + 9;
    //_createZombie("NoName", newDna);
    //_triggerCooldown(myZombie);
  }
}




pragma solidity ^0.8.0;


contract beastAttack is beastHelper{


    uint public attacPlayerkVictoryProbability = 7000;
    uint public attacBosskVictoryProbability = 5000;


    function setAttackPlayerVictoryProbability(uint _attacPlayerkVictoryProbability)public onlyOwner{
        attacPlayerkVictoryProbability = _attacPlayerkVictoryProbability;
    }

     function setAttackBossVictoryProbability(uint _attacBosskVictoryProbability)public onlyOwner{
        attacBosskVictoryProbability = _attacBosskVictoryProbability;
    }


    function gettAttackPlayerVictoryProbability(uint _myBeastId, uint _targetId) public view returns(uint){
        uint _attacPlayerkVictoryProbability = attacPlayerkVictoryProbability;
        if((beasts[_myBeastId].attributeID >beasts[_targetId].attributeID) && (beasts[_myBeastId].attributeID -beasts[_targetId].attributeID ==1)){
            _attacPlayerkVictoryProbability = _attacPlayerkVictoryProbability + 200;
        }
        if((beasts[_myBeastId].attributeID == 1) && beasts[_targetId].attributeID == 5){
            _attacPlayerkVictoryProbability = _attacPlayerkVictoryProbability + 200;
        }
        if((beasts[_myBeastId].energy>beasts[_targetId].energy)){
            _attacPlayerkVictoryProbability = _attacPlayerkVictoryProbability + (beasts[_myBeastId].energy - beasts[_targetId].energy);
        }
        if((beasts[_myBeastId].level>beasts[_targetId].level)){
            _attacPlayerkVictoryProbability = _attacPlayerkVictoryProbability + (beasts[_myBeastId].level - beasts[_targetId].level);
        }
        return _attacPlayerkVictoryProbability;
    }

    function gettAttackBossVictoryProbability(uint _myBeastId, uint _bossId) public view returns(uint){
        uint _attacBosskVictoryProbability = attacBosskVictoryProbability;
        if((beasts[_myBeastId].attributeID > boss[_bossId].attributeID) && (beasts[_myBeastId].attributeID - boss[_bossId].attributeID == 1)){
            _attacBosskVictoryProbability = _attacBosskVictoryProbability + 200;
        }
        if((beasts[_myBeastId].attributeID == 1) && boss[_bossId].attributeID == 5){
            _attacBosskVictoryProbability = _attacBosskVictoryProbability + 200;
        }
        if((beasts[_myBeastId].energy>boss[_bossId].energy)){
            _attacBosskVictoryProbability = _attacBosskVictoryProbability + (beasts[_myBeastId].energy - boss[_bossId].energy);
        }
        if((beasts[_myBeastId].level>boss[_bossId].level)){
            _attacBosskVictoryProbability = _attacBosskVictoryProbability + (beasts[_myBeastId].level - boss[_bossId].level);
        }
        return _attacBosskVictoryProbability;
    }


    function attackPlayer(uint _nftId,uint _targetId)external onlyOwnerOf(_nftId) returns(uint){
        require(_msgSender() != beastToOwner[_targetId],'The target beast is yours!');
        Beast storage myBeast = beasts[_nftId];
        require(_isReady(myBeast),'Your beast is not ready!');
        Beast storage enemyBeast = beasts[_targetId];
        uint _attacPlayerkVictoryProbability = gettAttackPlayerVictoryProbability(myBeast.nftID,enemyBeast.nftID);
        uint _rand = randMod(modulus,10000);
        if(_rand<=_attacPlayerkVictoryProbability){
            expUp(myBeast.nftID,enemyBeast.rare*2);
            //myBeast.level++;
            //multiply(_zombieId,enemyZombie.dna);
            _triggerCooldown(myBeast);
            return _nftId;
        }else{
            _triggerCooldown(myBeast);
            return _targetId;
        }

    }
    function attackBoss(uint _nftId,uint _BossId) external onlyOwnerOf(_nftId) returns(uint){
        require(boss[_BossId].isready == 1, 'The target beast is yours!');
        Boss storage enemyBoss = boss[_BossId];
        Beast storage myBeast = beasts[_nftId];
        require(_isReady(myBeast),'Your beast is not ready!');
        uint _attacBosskVictoryProbability = gettAttackBossVictoryProbability(myBeast.nftID,enemyBoss.bossId);
        uint _rand = randMod(modulus,10000);
        if(_rand<=_attacBosskVictoryProbability){
            expUp(myBeast.nftID,enemyBoss.rare*2);
            //myBeast.level++;
            //multiply(_zombieId,enemyZombie.dna);
            _triggerCooldown(myBeast);
            return _nftId;
        }else{
            //myZombie.lossCount++;
            //enemyZombie.winCount++;
            _triggerCooldown(myBeast);
            return _BossId;
        }
    }

}



pragma solidity ^0.8.0;
contract beastOwnership is beastHelper, ERC721 {

  mapping (uint => address) beastApprovals;

  function balanceOf(address _owner) public view override returns (uint256 _balance) {
    return ownerBeastCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view override returns (address _owner) {
    return beastToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) internal {
    ownerBeastCount[_to] = ownerBeastCount[_to]+1;
    ownerBeastCount[_from] = ownerBeastCount[_from]-1;
    beastToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    _transfer(_msgSender(), _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    beastApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public override {
    require(beastApprovals[_tokenId] == _msgSender());
    address owner = ownerOf(_tokenId);
    _transfer(owner, _msgSender(), _tokenId);
  }
}


pragma solidity ^0.8.0;


contract beastMarket is beastOwnership {
    struct beastSales{
        address payable seller;
        uint price;
    }



    mapping(uint=>beastSales) public beastShop;
    mapping(uint=>address) public battleField;
    uint shopbeastCount;
    uint battleFieldCount;
    uint public minPrice = 1*10**18;
    uint public mintax = 1*10**17;
    uint public marketFee = 6;

    event SaleBeast(uint indexed beastId,address indexed seller);
    event JoinbattleField(uint indexed beastId,address indexed joiner);
    event BuyShopBeast(uint indexed beastId,address indexed buyer,address indexed seller);

    function saleMyBeast(uint _beastId,uint _price)public onlyOwnerOf(_beastId){
        require(_price>=minPrice+mintax,'Your price must > minPrice+tax');
        beastShop[_beastId] = beastSales(payable(_msgSender()),_price);
        shopbeastCount = shopbeastCount+1;
        emit SaleBeast(_beastId,_msgSender());
    }

    function joinBattlefield(uint _beastId)public onlyOwnerOf(_beastId){
        require(beasts[_beastId].readyTime == 0 ,'beast is not ready');
        battleField[_beastId] = _msgSender();
        battleFieldCount = battleFieldCount+1;
        emit JoinbattleField(_beastId,_msgSender());
    }




    function buyShopBeast(uint _beastId)public payable{
        require(msg.value >= beastShop[_beastId].price,'No enough money');
        require(beastShop[_beastId].seller != _msgSender() ,'It is your beast !');
        _transfer(beastShop[_beastId].seller,_msgSender(), _beastId);
        beastShop[_beastId].seller.transfer((msg.value *(100 - marketFee))/100) ;
        delete beastShop[_beastId];
        shopbeastCount = shopbeastCount-1;
        emit BuyShopBeast(_beastId,_msgSender(),beastShop[_beastId].seller);
    }
    function getShopBeasts() external view returns(uint[] memory) {
        uint[] memory result = new uint[](shopbeastCount);
        uint counter = 0;
        for (uint i = 0; i < beasts.length; i++) {
            if (beastShop[i].price != 0) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function setMarketFee(uint _value)public onlyOwner{
        marketFee = _value;
    }
    function setMinPrice(uint _value)public onlyOwner{
        minPrice = _value;
    }
}


pragma solidity ^0.8.0;

contract BeastCore is beastMarket,beastAttack {

    string public constant name = "MyCryptoBeast";
    string public constant symbol = "MCB";

    //function() external payable {
    //}

    receive() external payable { }
    //function withdraw() external onlyOwner {
    //    owner.transfer(address(this).balance);
    //}

    function checkBalance() external view onlyOwner returns(uint) {
        return address(this).balance;
    }

}