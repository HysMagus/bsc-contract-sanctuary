// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/Box/ArtBoxTypes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/** ArtBox Main contract  */
contract ArtBox is ERC721Enumerable, Ownable, Pausable {
  /// @dev Events
  event BoxCreated(address indexed owner, uint256 indexed boxId);
  event BoxLocked(
    address indexed owner,
    uint16 indexed boxXId,
    uint16 indexed boxYId
  );
  event BoxUpdated(
    address indexed owner,
    uint16 indexed boxXId,
    uint16 indexed boxYId
  );
  event BoxMigrated(
    address indexed sender,
    address owner,
    uint16 indexed boxXId,
    uint16 indexed boxYId
  );

  /** @dev Storage */
  uint256 private basePrice;
  uint256 private priceIncreaseFactor;
  uint256 private lockPrice;
  uint256 private maxBoxes;
  uint256 private maxX;
  uint256 private maxY;
  address payable private admin;
  address payable private fundDAO;
  address private previousVersion;
  string private baseURI;

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  ArtBoxTypes.Box[] private boxesMap;
  mapping(uint256 => mapping(uint256 => ArtBoxTypes.Box)) private boxes;

  /** @dev Constructor function, sets initial price, lock price and factor
   *   @param _admin overrides the administrator of the contract
   *   @param _fundDAO overrides the DAO of the contract
   */
  constructor(
    address payable _admin,
    address payable _fundDAO,
    uint256 _basePrice,
    uint256 _priceIncreaseFactor,
    uint256 _lockPrice,
    string memory _baseURI
  ) ERC721("ArtBox", "ARTBOX") {
    basePrice = _basePrice;
    lockPrice = _lockPrice;
    priceIncreaseFactor = _priceIncreaseFactor;

    baseURI = _baseURI;

    maxX = 27;
    maxY = 27;
    maxBoxes = (maxX + 1) * (maxY + 1);

    admin = payable(_admin);
    fundDAO = payable(_fundDAO);

    transferOwnership(_admin);
  }

  /** @dev Get current admin address
   *  @return Current admin address
   */
  function getCurrentAdmin() external view returns (address) {
    return admin;
  }

  /** @dev Get current DAO address
   * @return Current DAO address
   */
  function getCurrentFundDAO() external view returns (address) {
    return fundDAO;
  }

  /** @dev Sets the admin to the provider address
   * can only be called by the current owner (admin)
   */
  function updateAdmin(address payable _address)
    external
    onlyOwner
    whenNotPaused
  {
    admin = _address;
    transferOwnership(_address);
  }

  /** @dev Sets the DAO address to the provided address
   * can only be called by the owner (admin)
   */
  function updateFundDAO(address payable _address)
    external
    onlyOwner
    whenNotPaused
  {
    fundDAO = _address;
  }

  /** @dev Updates baseURI
   * can only be called by the owner (admin)
   */
  function updateBaseURI(string memory _baseURI)
    external
    onlyOwner
    whenNotPaused
  {
    baseURI = _baseURI;
  }

  /** @dev Updates previousVersion
   * can only be called by the owner (admin)
   */
  function updatePreviousVersion(address _previousVersion)
    external
    onlyOwner
    whenNotPaused
  {
    previousVersion = _previousVersion;
  }

  /** @dev Get a specific artbox by its coordinates
   * @param _boxXId coordinate for X
   * @param _boxYId coordinate for Y
   * @return ArtBoxTypes.Box an artbox with all the attributes
   */
  function getBoxByCoordinates(uint16 _boxXId, uint16 _boxYId)
    public
    view
    returns (ArtBoxTypes.Box memory)
  {
    return boxes[_boxXId][_boxYId];
  }

  /** @dev Get a specific artbox by its id
   * @param _boxId the id of the box
   * @return ArtBoxTypes.Box an artbox with all the attributes
   */
  function getBoxById(uint256 _boxId)
    public
    view
    returns (ArtBoxTypes.Box memory)
  {
    return boxesMap[_boxId];
  }

  /** @dev Get the full map of artboxes
   * @return Complete array of artboxes.
   */
  function getBoxes() external view returns (ArtBoxTypes.Box[] memory) {
    return boxesMap;
  }

  /** @dev Provides the current price for the next box
   * @return current price for the next box
   */
  function getCurrentPrice() public view returns (uint256) {
    return basePrice + (_tokenIds.current() * priceIncreaseFactor);
  }

  /** @dev Get current price to lock a box
   * @return current price to lock a box
   */
  function getCurrentLockPrice() public view returns (uint256) {
    return lockPrice;
  }

  /** @dev Updates the current lock price
   */
  function updateLockPrice(uint256 _newPrice) external onlyOwner whenNotPaused {
    lockPrice = _newPrice;
  }

  /** @dev Updates the multiplier used to calculate box prices
   */
  function updateIncreasePriceFactor(uint256 _newFactor)
    external
    onlyOwner
    whenNotPaused
  {
    priceIncreaseFactor = _newFactor;
  }

  /** @dev Pauses the contract preventing artbox updates
   */
  function pause() external onlyOwner whenNotPaused {
    _pause();
  }

  /** @dev Unpauses the contract to resume operations
   */
  function unpause() external onlyOwner whenPaused {
    _pause();
  }

  /** @dev Updates max x coordinates
   */
  function updateMaxX(uint256 _maxX) external onlyOwner whenNotPaused {
    maxX = _maxX;
  }

  /** @dev Updates max y coordinates
   */
  function updateMaxY(uint256 _maxY) external onlyOwner whenNotPaused {
    maxY = _maxY;
  }

  /** @dev Generate a new Box with the initial desired state provided by the user
   *  this function is really expensive but does all the work that the contract needs
   *  @param _boxXId the X coordinate of the artbox in the grid
   *  @param _boxYId the Y coordinate of the artbox in the grid
   *  @return the id in the global boxes array
   *  @notice We allocate a maximum of 784 boxes (28x28) to be displayed as one (originally).
   *  @notice can be updated if required and is calculated from x*y.
   *  @notice increment the total counter so we don't go over 784 boxes
   *  @notice then mint the token and do all the transfers to the admin and the DAO.
   */
  function createBox(
    uint16 _boxXId,
    uint16 _boxYId,
    uint32[16][16] memory boxFields
  ) public payable whenNotPaused returns (uint256) {
    uint256 price = getCurrentPrice();
    require(msg.value >= price, "Value not matched");
    require(_boxXId >= 0 && _boxXId <= 27, "There is no room for more boxes");
    require(_boxYId >= 0 && _boxYId <= 27, "There is no room for more boxes");
    require(
      boxes[_boxXId][_boxYId].minter == address(0),
      "The box already exists"
    );

    uint256 newBoxId = _tokenIds.current();
    ArtBoxTypes.Box memory _box = ArtBoxTypes.Box({
      id: newBoxId,
      x: _boxXId,
      y: _boxYId,
      locked: false,
      box: boxFields,
      minter: msg.sender,
      locker: address(0)
    });
    boxes[_boxXId][_boxYId] = _box;
    boxesMap.push(_box);

    require(newBoxId < maxBoxes, "There is no room for more boxes");
    _tokenIds.increment();
    _safeMint(msg.sender, newBoxId);

    admin.transfer(msg.value / 2);
    fundDAO.transfer(address(this).balance);

    // Emit the event and return the box id
    emit BoxCreated(msg.sender, newBoxId);

    return newBoxId;
  }

  /**
   *  @dev We lock the Box forever, it cannot be updated anymore after this
   *  @param boxXId the X coordinate of artbox in the grid
   *  @param boxYId the Y coordinate of artbox in the grid
   *  @return retuns true if the box is now locked
   */
  function lockBox(uint16 boxXId, uint16 boxYId)
    external
    payable
    whenNotPaused
    returns (bool)
  {
    require(
      msg.sender == ownerOf(boxes[boxXId][boxYId].id),
      "Must own the Box"
    );
    require(msg.value == lockPrice, "Must match the price");
    require(boxes[boxXId][boxYId].locked == false, "The box is already locked");

    boxes[boxXId][boxYId].locked = true;

    admin.transfer(msg.value / 2);
    fundDAO.transfer(address(this).balance);

    emit BoxLocked(msg.sender, boxXId, boxYId);

    return boxes[boxXId][boxYId].locked;
  }

  /** @dev Updates the box so the user can have a new shape or color, it has no additional cost.
   *  @param boxXId the X coordinate of artbox in the grid
   *  @param boxYId the Y coordinate of artbox in the grid
   *  @param _box the grid for this artbox to be updated
   * */
  function updateBox(
    uint16 boxXId,
    uint16 boxYId,
    uint32[16][16] memory _box
  ) external whenNotPaused {
    require(
      msg.sender == ownerOf(boxes[boxXId][boxYId].id),
      "Must own the Box"
    );
    require(
      boxes[boxXId][boxYId].locked == false,
      "The box cannot be updated anymore"
    );

    boxes[boxXId][boxYId].box = _box;

    for (uint256 i = 0; i <= boxesMap.length; i++) {
      if (boxesMap[i].id == boxes[boxXId][boxYId].id) {
        boxesMap[i].box = _box;
        break;
      }
    }

    emit BoxUpdated(msg.sender, boxXId, boxYId);
  }

  /** @dev Anyone can migrate the box to the current contract without any
   *  fees and transfer it to the owner, unless the spot is already used
   *  @param _boxXId the X coordinate of artbox in the grid
   *  @param _boxYId the Y coordinate of artbox in the grid
   * */
  function migrateBox(uint16 _boxXId, uint16 _boxYId)
    public
    onlyOwner
    whenNotPaused
  {
    require(_boxXId >= 0 && _boxXId <= 27, "There is no room for more boxes");
    require(_boxYId >= 0 && _boxYId <= 27, "There is no room for more boxes");
    require(
      boxes[_boxXId][_boxYId].minter == address(0),
      "The box already exists"
    );

    ArtBox previousArtbox = ArtBox(previousVersion);
    ArtBoxTypes.Box memory _originalArtbox = previousArtbox.getBoxByCoordinates(
      _boxXId,
      _boxYId
    );
    address boxOwner = previousArtbox.ownerOf(_originalArtbox.id);

    uint256 newBoxId = _tokenIds.current();
    ArtBoxTypes.Box memory _box = ArtBoxTypes.Box({
      id: newBoxId,
      x: _boxXId,
      y: _boxYId,
      locked: false,
      box: _originalArtbox.box,
      minter: _originalArtbox.minter,
      locker: _originalArtbox.locker
    });
    boxes[_boxXId][_boxYId] = _box;
    boxesMap.push(_box);

    require(newBoxId < maxBoxes, "There is no room for more boxes");
    _tokenIds.increment();
    _safeMint(boxOwner, newBoxId);

    emit BoxMigrated(msg.sender, boxOwner, _boxXId, _boxYId);
  }
}
