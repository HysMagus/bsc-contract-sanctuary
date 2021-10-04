// Telegram channel of the contract - t.me/tendollarshistory
// We are sure that a group of people can do more than a bureaucratic machine!
//the contract does not store money on its balance, funds are automatically sent to all participants of the grid.
pragma solidity ^0.4.25;



 contract $History {
     struct User{
         address dis1;
         address dis2;
         address dis3;
         address dis4;
         address dis5;
         address dis6;
         address dis7;
     }
     
     struct Userstat{
         uint stat;
     }
     mapping(address => User) public users;
     mapping(address => Userstat) public usersstat;
     address public owner;
     address public partner;
     uint public itsprice = 30 finney;
     
     
     event ownershipTransferred(address indexed previousowner, address indexed newowner);
     event partnerTransferred(address indexed partner, address indexed newpartner);
     event priceTransfer(uint itsprice, uint newitsprice);
     constructor()public{
        owner = msg.sender;
        partner = 0x4e977304F48645044BE1B39F09E7aDdA2e8A8cA9;
        
      users[0x18661cd6403c046a8f210389f057dB2665689E45].dis1 = 0x54D7deDE96Ad761DB5ECF9c927C45F990cB7C923;
      users[0x54D7deDE96Ad761DB5ECF9c927C45F990cB7C923].dis1 = 0xa5E79608AD7C1f53c45f9778Dbc1debe247EEde2;
      users[0xa5E79608AD7C1f53c45f9778Dbc1debe247EEde2].dis1 = 0xF29D97312e7c45e97cBF1997a8609d0006DA9D5D;
      users[0xF29D97312e7c45e97cBF1997a8609d0006DA9D5D].dis1 = 0x488aDB5c8210a939051CFff266843A456c1B8C68;
      users[0x488aDB5c8210a939051CFff266843A456c1B8C68].dis1 = 0xcaa72f6BF6f5bBA511b17c7F668a68A000f5E688;
      users[0xcaa72f6BF6f5bBA511b17c7F668a68A000f5E688].dis1 = 0xC2A852B49a735133597D9Cb3dCdB6f90b784FC75;
      users[0xC2A852B49a735133597D9Cb3dCdB6f90b784FC75].dis1 = 0xe7f2ee3aA81F0Ec43d2fd25E0F7291e4c31f5be2;
     }
     
         modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
   function transferprice(uint newitsprice) public onlyOwner {
       emit priceTransfer(itsprice, newitsprice);
    itsprice = newitsprice;
   }
  
  function transferowner(address newowner) public onlyOwner {
    require(newowner != address(0));
    emit ownershipTransferred(owner, newowner);
    owner = newowner;
  }
    function transPart(address newpartner) public onlyOwner {
    require(newpartner != address(0));
    emit partnerTransferred(partner, newpartner);
    partner = newpartner;
  }
  
   function addUser(Userstat memory newUserstat ) private {
       address work = msg.sender;
       
       newUserstat.stat = 2;
       usersstat[work] = newUserstat;
       
   }
   
   function Start(address dis1) public payable{
       require(msg.value >= itsprice);
      require(usersstat[msg.sender].stat <= 0);
      require(dis1 != msg.sender);
      address sender = msg.sender;
      address dis2 = users[dis1].dis1;
      address dis3 = users[dis2].dis1;
      address dis4 = users[dis3].dis1;
      address dis5 = users[dis4].dis1;
      address dis6 = users[dis5].dis1;
      address dis7 = users[dis6].dis1;
      
      User memory newUser; 
     
       newUser.dis1 = dis1;
       newUser.dis2 = dis2;
       newUser.dis3 = dis3;
       newUser.dis4 = dis4;
       newUser.dis5 = dis5;
       newUser.dis6 = dis6;
       newUser.dis7 = dis7;
       users[sender] = newUser;
       Userstat memory newUserstat;
       uint valueowner = msg.value/2;
       partner.transfer(valueowner);
       
       
       
       
       
       addUser(newUserstat);
       transferpay(dis1,dis2,dis3,dis4,dis5,dis6,dis7);
   }
    
    function transferpay(address dis1,address dis2,address dis3,address dis4,address dis5,address dis6,address dis7) private {
       uint value1 = msg.value / 10; //10%
     uint value2 = msg.value * 24/1000; //2.4%
     uint value3 = msg.value * 3 / 100; //3%
     uint value4 = msg.value * 35 / 1000; //3.5%
     uint value5 = msg.value * 42/ 1000; //4.2%
     uint value6 = msg.value * 69 / 1000; //6.9%
     uint value7 = msg.value * 2 / 10; //20%
       dis1.transfer(value1);
       dis2.transfer(value2);
       dis3.transfer(value3);
       dis4.transfer(value4);
       dis5.transfer(value5);
       dis6.transfer(value6);
       dis7.transfer(value7); 
    }
 }