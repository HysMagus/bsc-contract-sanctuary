pragma solidity ^0.5.8;

library SafeMath
{
  /**
   * List of revert message codes. Implementing dApp should handle showing the correct message.
   * Based on 0xcert framework error codes.
   */
  string constant OVERFLOW = "008001";
  string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
  string constant DIVISION_BY_ZERO = "008003";

  /**
   * @dev Multiplies two numbers, reverts on overflow.
   * @param _factor1 Factor number.
   * @param _factor2 Factor number.
   * @return product The product of the two factors.
   */
  function mul(
    uint256 _factor1,
    uint256 _factor2
  )
    internal
    pure
    returns (uint256 product)
  {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_factor1 == 0)
    {
      return 0;
    }

    product = _factor1 * _factor2;
    require(product / _factor1 == _factor2, OVERFLOW);
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
   * @param _dividend Dividend number.
   * @param _divisor Divisor number.
   * @return quotient The quotient.
   */
  function div(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 quotient)
  {
    // Solidity automatically asserts when dividing by 0, using all gas.
    require(_divisor > 0, DIVISION_BY_ZERO);
    quotient = _dividend / _divisor;
    // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
  }

  /**
   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   * @param _minuend Minuend number.
   * @param _subtrahend Subtrahend number.
   * @return difference Difference.
   */
  function sub(
    uint256 _minuend,
    uint256 _subtrahend
  )
    internal
    pure
    returns (uint256 difference)
  {
    require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
    difference = _minuend - _subtrahend;
  }

  /**
   * @dev Adds two numbers, reverts on overflow.
   * @param _addend1 Number.
   * @param _addend2 Number.
   * @return sum Sum.
   */
  function add(
    uint256 _addend1,
    uint256 _addend2
  )
    internal
    pure
    returns (uint256 sum)
  {
    sum = _addend1 + _addend2;
    require(sum >= _addend1, OVERFLOW);
  }

  /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
    * dividing by zero.
    * @param _dividend Number.
    * @param _divisor Number.
    * @return remainder Remainder.
    */
  function mod(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 remainder)
  {
    require(_divisor != 0, DIVISION_BY_ZERO);
    remainder = _dividend % _divisor;
  }

}

library AddressUtils
{

  /**
   * @dev Returns whether the target address is a contract.
   * @param _addr Address to check.
   * @return addressCheck True if _addr is a contract, false if not.
   */
  function isContract(
    address _addr
  )
    internal
    view
    returns (bool addressCheck)
  {
    // This method relies in extcodesize, which returns 0 for contracts in
    // construction, since the code is only stored at the end of the
    // constructor execution.

    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
    // for accounts without code, i.e. `keccak256('')`
    bytes32 codehash;
    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    assembly { codehash := extcodehash(_addr) } // solhint-disable-line
    addressCheck = (codehash != 0x0 && codehash != accountHash);
  }

}
interface ERC721
{
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );


  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external;
    
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;
    
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;

  function approve(
    address _approved,
    uint256 _tokenId
  )
    external;
    
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external;

  function balanceOf(
    address _owner
  )
    external
    view
    returns (uint256);

  function ownerOf(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  function getApproved(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    view
    returns (bool);

}

interface ERC721TokenReceiver{
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);
}
contract Ownable
{

  /**
   * @dev Error constants.
   */
  string public constant NOT_CURRENT_OWNER = "018001";
  string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
  string public constant NOT_CURRENT_MANAGER = "018003";

  address public owner;
  mapping(address=>bool) public Manager;


  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  constructor()
    public
  {
    owner = msg.sender;
  }
  modifier onlyOwner()
  {
    require(msg.sender == owner, NOT_CURRENT_OWNER);
    _;
  }
  
  modifier onlyManager()
  {
    require(Manager[msg.sender], NOT_CURRENT_MANAGER);
    _;
  }

  function addManager(address _maddr) public onlyOwner{
      Manager[_maddr] = true;
  }
  
  function delManager(address _maddr) public onlyOwner{
      Manager[_maddr] = false;
  }
  function transferOwnership(
    address _newOwner
  )
    public
    onlyOwner
  {
    require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }

}


contract NFToken is
  ERC721
{
  using SafeMath for uint256;
  using AddressUtils for address;

 
  string constant ZERO_ADDRESS = "003001";
  string constant NOT_VALID_NFT = "003002";
  string constant NOT_OWNER_OR_OPERATOR = "003003";
  string constant NOT_OWNER_APPROWED_OR_OPERATOR = "003004";
  string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
  string constant NFT_ALREADY_EXISTS = "003006";
  string constant NOT_OWNER = "003007";
  string constant IS_OWNER = "003008";


  bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

  
  mapping (uint256 => address) public idToOwner;

  uint256 internal tokenID;
  mapping (uint256 => address) internal idToApproval;

   
  mapping (address => uint256) private ownerToNFTokenCount;

  
  mapping (address => mapping (address => bool)) internal ownerToOperators;

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

 
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

 
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );


  modifier canOperate(
    uint256 _tokenId
  )
  {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender], NOT_OWNER_OR_OPERATOR);
    _;
  }


  modifier canTransfer(
    uint256 _tokenId
  )
  {
    address tokenOwner = idToOwner[_tokenId];
    require(
      tokenOwner == msg.sender
      || idToApproval[_tokenId] == msg.sender
      || ownerToOperators[tokenOwner][msg.sender],
      NOT_OWNER_APPROWED_OR_OPERATOR
    );
    _;
  }


  modifier validNFToken(
    uint256 _tokenId
  )
  {
    require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
    _;
  }


  constructor()
    public
  {
    //supportedInterfaces[0x80ac58cd] = true; // ERC721
  }
  
  function viewTokenID() view public returns(uint256 ){
      return tokenID;
  }
  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    //override
  {
    _safeTransferFrom(_from, _to, _tokenId, _data);
  }
  


  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    //override
  {
    _safeTransferFrom(_from, _to, _tokenId, "");
  }

 
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    //override
    canTransfer(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);

    _transfer(_to, _tokenId);
  }
  
  function transferList(address _to,uint256[] calldata _tokenIdList) external{
        uint256 len = _tokenIdList.length;
        address tokenOwner;// = idToOwner[_tokenId];
        uint256 _tokenId;
        
        for(uint256 i=0;i<len;i++){
            _tokenId = _tokenIdList[i];
            tokenOwner = idToOwner[_tokenId];
            require(tokenOwner != address(0), NOT_VALID_NFT);
            require(
                tokenOwner == msg.sender
                || idToApproval[_tokenId] == msg.sender
                || ownerToOperators[tokenOwner][msg.sender],
                NOT_OWNER_APPROWED_OR_OPERATOR
            );
            _transfer(_to, _tokenId);
        }
      
  }

    
 
  function approve(
    address _approved,
    uint256 _tokenId
  )
    external
    //override
    canOperate(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(_approved != tokenOwner, IS_OWNER);

    idToApproval[_tokenId] = _approved;
    emit Approval(tokenOwner, _approved, _tokenId);
  }

 
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external
    //override
  {
    ownerToOperators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

 
  function balanceOf(
    address _owner
  )
    external
    //override
    view
    returns (uint256)
  {
    require(_owner != address(0), ZERO_ADDRESS);
    return _getOwnerNFTCount(_owner);
  }

 
  function ownerOf(
    uint256 _tokenId
  )
    external
    //override
    view
    returns (address _owner)
  {
    _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_NFT);
  }


  function getApproved(
    uint256 _tokenId
  )
    external
    //override
    view
    validNFToken(_tokenId)
    returns (address)
  {
    return idToApproval[_tokenId];
  }


  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    //override
    view
    returns (bool)
  {
    return ownerToOperators[_owner][_operator];
  }

  function _transfer(
    address _to,
    uint256 _tokenId
  )
    internal
  {
    address from = idToOwner[_tokenId];
    _clearApproval(_tokenId);

    _removeNFToken(from, _tokenId);
    _addNFToken(_to, _tokenId);

    emit Transfer(from, _to, _tokenId);
  }


  function _mint(
    address _to,
    uint256 _tokenId
  )
    internal
    //virtual
  {
    require(_to != address(0), ZERO_ADDRESS);
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
    //require(_tokenId == tokenID+1,NFT_ALREADY_EXISTS);
    tokenID++;
    _addNFToken(_to, _tokenId);

    emit Transfer(address(0), _to, _tokenId);
  }


  function _burn(
    uint256 _tokenId
  )
    internal
    //virtual
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    _clearApproval(_tokenId);
    _removeNFToken(tokenOwner, _tokenId);
    emit Transfer(tokenOwner, address(0), _tokenId);
  }

 
  function _removeNFToken(
    address _from,
    uint256 _tokenId
  )
    internal
    //virtual
  {
    require(idToOwner[_tokenId] == _from, NOT_OWNER);
    ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
    delete idToOwner[_tokenId];
  }

  
  function _addNFToken(
    address _to,
    uint256 _tokenId
  )
    internal
    //virtual
  {
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

    idToOwner[_tokenId] = _to;
    ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
  }


  function _getOwnerNFTCount(
    address _owner
  )
    internal
    //virtual
    view
    returns (uint256)
  {
    return ownerToNFTokenCount[_owner];
  }

  function _safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    private
    canTransfer(_tokenId)
    validNFToken(_tokenId)
  {
    address tokenOwner = idToOwner[_tokenId];
    require(tokenOwner == _from, NOT_OWNER);
    require(_to != address(0), ZERO_ADDRESS);

    _transfer(_to, _tokenId);

    if (_to.isContract())
    {
      bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
      require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
    }
  }

  function _clearApproval(
    uint256 _tokenId
  )
    private
  {
    if (idToApproval[_tokenId] != address(0))
    {
      delete idToApproval[_tokenId];
    }
  }

}

contract DSMdate is NFToken {

    string internal nftName;
    string internal nftSymbol;
    enum starType {st_nil,st1,st2,st3,st4,st5,st6}
    enum teamType {t_nil,t1,t2}

    string constant INVALID_INDEX = "005007";

    uint256[] public tokens;
    mapping(uint256 => uint256) public idToIndex;
    mapping(address => uint256[]) public ownerToIds;
    mapping(uint256 => uint256) public idToOwnerIndex;
    mapping(uint256 => string) public typeName;
    
    mapping (uint256 => string) internal idToUri;
    mapping(uint256 => starAttributesStruct) public starAttributes;
    
    //weapon 
    mapping(address=>mapping(uint256=>uint256)) public weaponBalance;//ply -> weapon->number
    mapping(uint256 => uint256) public weaponTotal;
    mapping(address =>mapping(address =>mapping(uint256=>uint256))) public weaponApprove;
    mapping(uint256 => uint8) public weaponTeam; //weaponTeam
    
    event WeaponTransfer(address  _from, address  _to, uint256 _wtype, uint256 _value);
    event WeaponApproval(address  _owner, address  _spender, uint256 _wtype ,uint256 _value);
    event ADD_DEL_ToNFT(uint256 _tokenId,uint256 _wType,bool isInstall );
  
    struct starAttributesStruct{
      teamType  ttype;//Team1 ,team2
      starType stype;//ABCDEF
      uint256 power; // power
      uint256 tpye1; // weapon
      uint256 tpye2; // picture;
      uint256 tpye3;
      uint256 tpye4;
      uint256 tpye5;
      uint256 tpye6;
      uint256 tpye7;
      uint256 tpye8;
    }
    function _mintWeapon(address _to,uint256 _wType,uint256 _amount,uint8 _team) internal{
        weaponTeam[_wType] = _team;
        weaponBalance[_to][_wType] = weaponBalance[_to][_wType].add(_amount);
        weaponTotal[_wType] = weaponTotal[_wType].add(_amount);
        emit WeaponTransfer(address(0),_to,_wType,_amount);
    }
    function totalBalanceWeapon(uint256 _wType) public view returns(uint256) {
        return weaponTotal[_wType];
    }
    
    function balanceOfWeapon(address _ply,uint256 _wType) public view returns(uint256){
        return weaponBalance[_ply][_wType];
    }
    
    function tranferWeapoon(address _to,uint256 _wType,uint256 _amount) public{
        require(weaponBalance[msg.sender][_wType] >= _amount,"not enght balance");
        require(_to != address(0),"err to");
        weaponBalance[msg.sender][_wType] = weaponBalance[msg.sender][_wType].sub(_amount);
        weaponBalance[_to][_wType] = weaponBalance[_to][_wType].add(_amount);
        emit WeaponTransfer(msg.sender,_to,_wType,_amount);
    }
    function approveWeapon(address _to,uint256 _wType,uint256 _amount) public{
        weaponApprove[msg.sender][_to][_wType] = _amount;
        emit WeaponApproval(msg.sender, _to,  _wType , _amount);
    }
    function transferWeaponFrom(address _from,address _to,uint256 _wType,uint256 _amount) public{
        require(_amount>0,"no amount");
        require(weaponApprove[_from][msg.sender][_wType] >= _amount,"not enght approve");
        weaponApprove[_from][msg.sender][_wType] = weaponApprove[_from][msg.sender][_wType].sub(_amount);
        weaponBalance[_from][_wType] = weaponBalance[_from][_wType].sub(_amount);
        weaponBalance[_to][_wType] = weaponBalance[_to][_wType].add(_amount);
        emit WeaponTransfer(_from,_to,_wType,_amount);
    }
    
    function installWeaponToNFT(uint256 _tokenId,uint256 _wType) public validNFToken(_tokenId) canTransfer(_tokenId){
        require(weaponBalance[msg.sender][_wType]>0,"not weapon balance");
        require(starAttributes[_tokenId].tpye1==0,"only weapon ");
        uint8 team = weaponTeam[_wType];
        if(team == 1){
            require(starAttributes[_tokenId].ttype == teamType.t1,"weapon not is this team");
        }else if(team == 2){
            require(starAttributes[_tokenId].ttype == teamType.t2,"weapon not is this team");
        }
        weaponBalance[msg.sender][_wType] = weaponBalance[msg.sender][_wType].sub(1);
        _setTokenTypeAttributes(_tokenId,1,_wType);
        emit ADD_DEL_ToNFT( _tokenId, _wType, true );
    }
    
    function unInstalWeaponToNFT(uint256 _tokenId ) public validNFToken(_tokenId) canTransfer(_tokenId){
        uint256 wType = starAttributes[_tokenId].tpye1;
        require(wType>0,"not weapon");
        weaponBalance[msg.sender][wType] = weaponBalance[msg.sender][wType].add(1);
        _setTokenTypeAttributes(_tokenId,1,0);
        emit ADD_DEL_ToNFT( _tokenId, wType, false );
        
    }

    function totalSupply() external view returns (uint256) {
        return tokens.length;
    }

    function tokenByIndex(uint256 _index) external view returns (uint256){
        require(_index < tokens.length, INVALID_INDEX);
        return tokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner,uint256 _index) external view returns (uint256){
        require(_index < ownerToIds[_owner].length, INVALID_INDEX);
        return ownerToIds[_owner][_index];
    }
    
    function _mint(address _to,uint256 _tokenId) internal {
        super._mint(_to, _tokenId);
        tokens.push(_tokenId);
        idToIndex[_tokenId] = tokens.length - 1;
      
    }

    // /function multiApprove(address )

    function _burn(uint256 _tokenId) internal {
        super._burn(_tokenId);

        uint256 tokenIndex = idToIndex[_tokenId];
        uint256 lastTokenIndex = tokens.length - 1;
        uint256 lastToken = tokens[lastTokenIndex];

        tokens[tokenIndex] = lastToken;

        tokens.pop();
        // This wastes gas if you are burning the last token but saves a little gas if you are not.
        idToIndex[lastToken] = tokenIndex;
        idToIndex[_tokenId] = 0;
    }


    function _removeNFToken(address _from,uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == _from, NOT_OWNER);
        delete idToOwner[_tokenId];

        uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
        uint256 lastTokenIndex = ownerToIds[_from].length - 1;

        if (lastTokenIndex != tokenToRemoveIndex){
            uint256 lastToken = ownerToIds[_from][lastTokenIndex];
            ownerToIds[_from][tokenToRemoveIndex] = lastToken;
            idToOwnerIndex[lastToken] = tokenToRemoveIndex;
        }

        ownerToIds[_from].pop();
    }


    function _addNFToken(address _to,uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);
        idToOwner[_tokenId] = _to;

        ownerToIds[_to].push(_tokenId);
        idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;
    }
    
    function _getOwnerNFTCount(address _owner) internal view returns (uint256){
        return ownerToIds[_owner].length;
        
    }
    
    function _setTokenUri(uint256 _tokenId, string memory _uri) public validNFToken(_tokenId) {
        idToUri[_tokenId] = _uri;
        
    }
    
    function _setTokenAttributes(uint256 _tokenId, starType  _type, teamType _ttpye,uint256 _power) 
    internal validNFToken(_tokenId) {
        require(_type > starType.st_nil && _type <= starType.st6);
        require(_ttpye > teamType.t_nil && _ttpye <= teamType.t2);
        starAttributes[_tokenId] =  starAttributesStruct(_ttpye,_type,_power,0,0,0,0,0,0,0,0);
    }
    
    function _setTokenTypeAttributes(uint256 _tokenId,uint8 _typeAttributes,uint256 _tvalue) 
    internal validNFToken(_tokenId) {
        if(_typeAttributes == 1){
            starAttributes[_tokenId].tpye1 = _tvalue;
        }else if(_typeAttributes == 2){
            starAttributes[_tokenId].tpye2 = _tvalue; // picture;
        }else if(_typeAttributes == 3){
            starAttributes[_tokenId].tpye3 = _tvalue;
        }else if(_typeAttributes == 4){
            starAttributes[_tokenId].tpye4 = _tvalue;
        }else if(_typeAttributes == 5){
            starAttributes[_tokenId].tpye5 = _tvalue;
        }else if(_typeAttributes == 6){
            starAttributes[_tokenId].tpye6 = _tvalue;
        }else if(_typeAttributes == 7){
            starAttributes[_tokenId].tpye7 = _tvalue;
        }else if(_typeAttributes == 8){
            starAttributes[_tokenId].tpye8 = _tvalue;
        }
    }
    
}

contract DS_NFT is DSMdate,Ownable{
   
    constructor(string memory _name,string memory _symbol) public {
        nftName = _name;
        nftSymbol = _symbol;
        
    }

    function mint(
        address _to,
        uint256 _tokenId,
        uint256 _power,
        teamType _ttype,
        starType _stype,
        string calldata _uri
    )
        external
        onlyManager
    {
        if(_ttype == teamType.t1){
            require(_stype>=starType.st1 && _stype <=starType.st4,"");
        }else if(_ttype == teamType.t2){
            require(_stype>=starType.st5 && _stype <=starType.st6,"");
        }
        
        super._mint(_to, _tokenId);
        super._setTokenUri(_tokenId, _uri);
        super._setTokenAttributes(_tokenId,_stype,_ttype,_power);
    }
    
     function mintWeapon(address _to,uint256 _wType,uint256 _amount,uint8 _team) external onlyManager{
         _mintWeapon(_to,_wType,_amount,_team);
     }
    
    function burn(uint256 _tokenId) external onlyManager {
        super._burn(_tokenId);
    }
    
    function setTokenTypeAttributes(uint256 _tokenId,uint8 _typeAttributes,uint256 _tvalue) external onlyManager{
        super._setTokenTypeAttributes(_tokenId,_typeAttributes,_tvalue);
    }
}