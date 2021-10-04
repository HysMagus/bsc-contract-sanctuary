// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0;


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
        require(b > 0, errorMessage);
        uint256 c = a / b;

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


library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}


// library SignatureUtils {

//     function toEthBytes32SignedMessageHash (
//         bytes32 _msg
//     )
//         pure
//         public
//         returns (bytes32 signHash)
//     {
//         signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _msg));
//     }


//     function toEthPersonalSignedMessageHash(
//         bytes memory _msg
//     )
//         pure
//         public
//         returns (bytes32 signHash)
//     {
//         signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uintToString(_msg.length), _msg));
//     }


//     function uintToString(
//         uint v
//     )
//         pure
//         public
//         returns (string memory)
//     {
//         uint w = v;
//         bytes32 x;
//         if (v == 0) {
//             x = "0";
//         } else {
//             while (w > 0) {
//                 x = bytes32(uint(x) / (2 ** 8));
//                 x |= bytes32(((w % 10) + 48) * 2 ** (8 * 31));
//                 w /= 10;
//             }
//         }

//         bytes memory bytesString = new bytes(32);
//         uint charCount = 0;
//         for (uint j = 0; j < 32; j++) {
//             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
//             if (char != 0) {
//                 bytesString[charCount] = char;
//                 charCount++;
//             }
//         }
//         bytes memory resultBytes = new bytes(charCount);
//         for (uint j = 0; j < charCount; j++) {
//             resultBytes[j] = bytesString[j];
//         }

//         return string(resultBytes);
//     }

//     function parseSignature(
//         bytes memory _signatures,
//         uint _pos
//     )
//         pure
//         public
//         returns (uint8 v, bytes32 r, bytes32 s)
//     {
//         uint offset = _pos * 65;
//         // The signature format is a compact form of:
//         //   {bytes32 r}{bytes32 s}{uint8 v}
//         // Compact means, uint8 is not padded to 32 bytes.
//         assembly { // solium-disable-line security/no-inline-assembly
//             r := mload(add(_signatures, add(32, offset)))
//             s := mload(add(_signatures, add(64, offset)))
//             // Here we are loading the last 32 bytes, including 31 bytes
//             // of 's'. There is no 'mload8' to do this.
//             //
//             // 'byte' is not working due to the Solidity parser, so lets
//             // use the second best option, 'and'
//             v := and(mload(add(_signatures, add(65, offset))), 0xff)
//         }

//         if (v < 27) v += 27;

//         require(v == 27 || v == 28);
//     }

//     function countSignatures(
//         bytes memory _signatures
//     )
//         pure
//         public
//         returns (uint)
//     {
//         return _signatures.length % 65 == 0 ? _signatures.length / 65 : 0;
//     }


//     function recoverAddress(
//         bytes32 _hash,
//         bytes memory _signatures,
//         uint _pos
//     )
//         pure
//         public
//         returns (address)
//     {
//         uint8 v;
//         bytes32 r;
//         bytes32 s;
//         (v, r, s) = parseSignature(_signatures, _pos);
//         return ecrecover(_hash, v, r, s);
//     }

//     function recoverAddresses(
//         bytes32 _hash,
//         bytes memory _signatures
//     )
//         pure
//         public
//         returns (address[] memory addresses)
//     {
//         uint8 v;
//         bytes32 r;
//         bytes32 s;
//         uint count = countSignatures(_signatures);
//         addresses = new address[](count);
//         for (uint i = 0; i < count; i++) {
//             (v, r, s) = parseSignature(_signatures, i);
//             addresses[i] = ecrecover(_hash, v, r, s);
//         }
//     }

// }


interface IWETH {
    function deposit() external payable;
    function withdraw(uint) external;
}

contract ETHBurgerTransit {
    using SafeMath for uint;
    
    address public owner;
    address public signWallet;
    address public developWallet;
    address public WETH;
    
    uint public totalFee;
    uint public developFee;
    
    // key: payback_id 
    mapping (bytes32 => bool) public executedMap;
    
    event Transit(address indexed from, address indexed token, uint amount);
    event Withdraw(bytes32 paybackId, address indexed to, address indexed token, uint amount);
    event CollectFee(address indexed handler, uint amount);
    
    constructor(address _WETH, address _signer, address _developer) public {
        WETH = _WETH;
        signWallet = _signer;
        developWallet = _developer;
        owner = msg.sender;
    }
    
    receive() external payable {
        assert(msg.sender == WETH);
    }
    
    function changeSigner(address _wallet) external {
        require(msg.sender == owner, "CHANGE_SIGNER_FORBIDDEN");
        signWallet = _wallet;
    }
    
    function changeDevelopWallet(address _developWallet) external {
        require(msg.sender == owner, "CHANGE_DEVELOP_WALLET_FORBIDDEN");
        developWallet = _developWallet;
    } 
    
    function changeDevelopFee(uint _amount) external {
        require(msg.sender == owner, "CHANGE_DEVELOP_FEE_FORBIDDEN");
        developFee = _amount;
    }
    
    function collectFee() external {
        require(msg.sender == owner, "FORBIDDEN");
        require(developWallet != address(0), "SETUP_DEVELOP_WALLET");
        require(totalFee > 0, "NO_FEE");
        TransferHelper.safeTransferETH(developWallet, totalFee);
        totalFee = 0;
    }
    
    function transitForBSC(address _token, uint _amount) external {
        require(_amount > 0, "INVALID_AMOUNT");
        TransferHelper.safeTransferFrom(_token, msg.sender, address(this), _amount);
        emit Transit(msg.sender, _token, _amount);
    }
    
    function transitETHForBSC() external payable {
        require(msg.value > 0, "INVALID_AMOUNT");
        IWETH(WETH).deposit{value: msg.value}();
        emit Transit(msg.sender, WETH, msg.value);
    }
    
    function withdrawFromBSC(bytes calldata _signature, bytes32 _paybackId, address _token, address _to, uint _amount) external payable {
        require(_to == msg.sender, "FORBIDDEN");
        require(executedMap[_paybackId] == false, "ALREADY_EXECUTED");
        
        require(_amount > 0, "NOTHING_TO_WITHDRAW");
        require(msg.value == developFee, "INSUFFICIENT_VALUE");
        
        // bytes32 message = keccak256(abi.encodePacked(_paybackId, _token, _to, _amount));
        // require(_verify(message, _signature), "INVALID_SIGNATURE");
        
        if(_token == WETH) {
            IWETH(WETH).withdraw(_amount);
            TransferHelper.safeTransferETH(msg.sender, _amount);
        } else {
            TransferHelper.safeTransfer(_token, msg.sender, _amount);
        }
        totalFee = totalFee.add(developFee);
        
        executedMap[_paybackId] = true;
        
        emit Withdraw(_paybackId, msg.sender, _token, _amount);
    }
    
    // function _verify(bytes32 _message, bytes memory _signature) internal view returns (bool) {
    //     bytes32 hash = SignatureUtils.toEthBytes32SignedMessageHash(_message);
    //     address[] memory signList = SignatureUtils.recoverAddresses(hash, _signature);
    //     return signList[0] == signWallet;
    // }
}