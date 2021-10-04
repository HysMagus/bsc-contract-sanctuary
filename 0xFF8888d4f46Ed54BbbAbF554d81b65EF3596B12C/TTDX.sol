/**
 *Submitted for verification at https://bscscan.com/ on 2021-02-20
*/
// https://turtledex.io
/*
*     ooooooooooooo                          .   oooo                  .o8                        
*     8'   888   `8                        .o8   `888                 "888                        
*          888      oooo  oooo  oooo d8b .o888oo  888   .ooooo.   .oooo888   .ooooo.  oooo    ooo 
*          888      `888  `888  `888""8P   888    888  d88' `88b d88' `888  d88' `88b  `88b..8P'  
*          888       888   888   888       888    888  888ooo888 888   888  888ooo888    Y888'    
*          888       888   888   888       888 .  888  888    .o 888   888  888    .o  .o8"'88b   
*         o888o      `V88V"V8P' d888b      "888" o888o `Y8bod8P' `Y8bod88P" `Y8bod8P' o88'   888o 
*/

pragma solidity ^0.4.26;

import "./TTDXBEP20Basic.sol";
import "./safeMath.sol";
import "./TTDXBasicToken.sol";
import "./TTDXBEP20.sol";
import "./TTDXStandardToken.sol";
import "./TTDXOwnable.sol";
import "./TTDXMintable.sol";
import "./TTDXFreezable.sol";
import "./TTDXBurnable.sol";
import "./TTDXFreezableMintableToken.sol";
import "./TTDXPausable.sol";

contract Consts {
    uint public constant TOKEN_DECIMALS = 8;
    uint8 public constant TOKEN_DECIMALS_UINT8 = 8;
    uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;

    string public constant TOKEN_NAME = "Turtledex Token";
    string public constant TOKEN_SYMBOL = "TTDX";
    bool public constant PAUSED = false;
    address public constant TARGET_USER = 0xf2F7622e33e6DA56d7e54c34EA65e825999f34A1;
    
    bool public constant CONTINUE_MINTING = true;
}

contract TTDXToken is Consts, FreezableMintableToken, BurnableToken, Pausable
    
{
    
    event Initialized();
    bool public initialized = false;

    constructor() public {
        init();
        transferOwnership(TARGET_USER);
    }
    

    function name() public pure returns (string _name) {
        return TOKEN_NAME;
    }

    function symbol() public pure returns (string _symbol) {
        return TOKEN_SYMBOL;
    }

    function decimals() public pure returns (uint8 _decimals) {
        return TOKEN_DECIMALS_UINT8;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
        require(!paused);
        return super.transferFrom(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool _success) {
        require(!paused);
        return super.transfer(_to, _value);
    }

    
    function init() private {
        require(!initialized);
        initialized = true;

        if (PAUSED) {
            pause();
        }

        
        address[4] memory addresses = [address(0x78AfF3b8b1de9242cC2dc8f19930C83454F1FF82),address(0xd90Ae8c0d6D85Ad67271EA6165C6128e0A4D75eA),address(0x473998a6eFeB8C676D369E105afB6cc73a0FaDBC),address(0xABEfc6Afc055387076056eB9f9cC7e25Bc7756Ea)];
        uint[4] memory amounts = [uint(60000000000000),uint(450000000000000),uint(600000000000000),uint(1890000000000000)];
        uint64[4] memory freezes = [uint64(1706742001),uint64(0),uint64(0),uint64(1633039201)];

        for (uint i = 0; i < addresses.length; i++) {
            if (freezes[i] == 0) {
                mint(addresses[i], amounts[i]);
            } else {
                mintAndFreeze(addresses[i], amounts[i], freezes[i]);
            }
        }
        

        if (!CONTINUE_MINTING) {
            finishMinting();
        }

        emit Initialized();
    }
    
}
