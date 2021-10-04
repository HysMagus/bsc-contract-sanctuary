pragma solidity 0.5.0;

import "./EGroweedGenetics.sol";

contract EGroweedNftSale {
  using SafeMath for uint256;

  // Address where funds are collected
  address payable public wallet;

  // Amount of wei raised
  uint256 public weiRaised;

  // Index de genetica creada
  uint256 public geneticGenesis = 0;

  // contract address of genetics
  address eGroweedGeneticsAddress;

  // contract of genetics to init
  EGroweedGenetics oEGroweedGenetics;

  /**
   * Event for plants purchase logging
   * @param purchaser who paid for the plants
   * @param beneficiary who got the plants
   * @param value weis paid for purchase
   */
  event NftPlantPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value
  );

  /**
   * @param _wallet Address where collected funds will be forwarded to
   */
  constructor(address _wallet, EGroweedGenetics _eGroweedGeneticContract) public {
    require(_wallet != address(0));
    require(_eGroweedGeneticContract != EGroweedGenetics(0));
    wallet = address(uint160(address(_wallet)));
    // sett genetic object to create new nft
    oEGroweedGenetics = _eGroweedGeneticContract;
    //oEGroweedGenetics = new EGroweedGenetics();
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * Evitar gasto e ether
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    require(msg.value >= 0, 'Unknow petition');
  }

  /**
   * @dev low level plants purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the plants purchase
   */
  function buyNftPlants(address _beneficiary, string memory ipfs) public payable {

    uint256 weiAmount = msg.value;

    // validar billetera beneficiario y cantidad enviada
    require(_beneficiary != address(0));
    require(weiAmount != 0);

    // Actualizar la cantidad recibida de eth
    weiRaised = weiRaised.add(weiAmount);

    emit NftPlantPurchase(
      msg.sender,
      _beneficiary,
      weiAmount
    );

    // Enviar fondos a la wallet
    _forwardFunds();
    
    // Creacion de los nft
    _postValidatePurchase(_beneficiary, ipfs);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
   * @param _beneficiary Address performing the plants purchase
   * @param ipfs metadata external URI
   */
  function _postValidatePurchase(
    address _beneficiary,
    string memory ipfs
  )
    internal
  {
    require(geneticGenesis <= 300, "This fabric can only create 200 NFT Plants... ");
    // Crear nuevo nft
    oEGroweedGenetics.createNewGenetic(geneticGenesis, _beneficiary, ipfs);
    geneticGenesis++;
  }
  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // cambiar de owner (versionamiento de contratos)
  // function changeOwnerContract(address newOwnerContract) public {
      // solo el owner puede cambiar la direccion de contrato
      //require(oEGroweedGenetics.owner == msg.sender, "You dont have access to this tool");
      // oEGroweedGenetics.changeOwnerContract(newOwnerContract);
  // }
}