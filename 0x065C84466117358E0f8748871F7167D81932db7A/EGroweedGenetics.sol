pragma solidity 0.5.0;

import "./ERC721Full.sol";

contract EGroweedGenetics is ERC721Full {

    constructor() ERC721Full("EGROWEED_GENETICS", "EGW") public {
    }

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // contrato de venta que genera los tokens 
    address ownerToCreateNewGenetics = address(0);

    /**
    * Estructura de la genetica de las plantas 
    * digitales en su version 1
    */
    struct genetic {
        uint dna;
        uint attCode;
    }
    // asignar geneticas (nfts) a los e-growers
    // mapping (uint256 => uint256) genetic_idnft;
    // mapping (uint256 => address) genetic_owner;
    // mapping (address => uint256[]) owner_genetics;
    genetic[] public genetics;

    // Crear genetica
    function _createGenetic(uint _dna, uint256 _genetic, address _beneficiary, string memory ipfs) private {
        // obtener y asignar el id del nft
        uint256 idNft = genetics.push(genetic(_dna,_genetic));
        // Asignar id del nft a crear a la genetica de egroweed
        // genetic_idnft[_genetic] = idNft;
        // Asignar al owner la genetica
        // genetic_owner[_genetic] = _beneficiary;
        // agregar el id del token al owner
        // owner_genetics[_beneficiary].push(idNft);
        // crear el token
        _mint(_beneficiary, idNft);
        _setTokenURI(idNft, ipfs);
    }

    // Generar nuevo codigo de genetica
    function _generateGeneticV1() private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)))+uint(keccak256(abi.encodePacked(msg.sender)))+uint(keccak256(abi.encodePacked(block.difficulty, now)));
        return rand % dnaModulus;
    }

    // Crear nuevo codigo genetica
    function createNewGenetic(uint256 _attCode, address _beneficiary, string memory ipfs) public {
        require(msg.sender == ownerToCreateNewGenetics, "Genetic only can be created by owner contract");
        uint randDna = _generateGeneticV1();
        _createGenetic(randDna, _attCode, _beneficiary, ipfs);
    }

    // Configuracion inicial del contrato. Solo puede crear tokens el contrato que se asigne al inicio
    function setup(address newOwnerAddress) public {
        //require(newOwnerAddress != '', "Address format incorrect");
        require(ownerToCreateNewGenetics == address(0), "The contract has been initialized");
        ownerToCreateNewGenetics = newOwnerAddress;
    }

    /*function getOwnerGenetics(address _OwnerAddress) public view returns (string memory){
        require(_OwnerAddress != address(0), "invalid owner address");

        uint256[] memory ownerGenetics = owner_genetics[_OwnerAddress];
        // require(ownerGenetics.length > 0, "The owner dont have nft plants");

        uint256 nftLength = ownerGenetics.length;
        string memory nftStrConcatente = "";
        
        for (uint256 i=0; i<nftLength; i++) {
            nftStrConcatente =  uint2str(nftStrConcatente) + uint2str(ownerGenetics[i]) + ",";
        }
        return nftStrConcatente;
    }*/

    /**
    * Obtener los NFT que tiene un owner
    */
    function tokensOfOwner(address owner) public view returns (uint256[] memory){
        return _tokensOfOwner(owner);
    }

    /*function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }*/

    // cambiar de owner (versionamiento de contratos)
    // function changeOwnerContract(address newOwnerContract) public {
        // solo el owner puede cambiar la direccion de contrato
        // require(ownerToCreateNewGenetics == msg.sender, "You dont have access to this tool");
        // ownerToCreateNewGenetics = newOwnerContract;
    // }
}