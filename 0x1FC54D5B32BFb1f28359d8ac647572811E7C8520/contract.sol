pragma solidity  =0.6.6;
pragma experimental ABIEncoderV2;

// SPDX-License-Identifier: MIT;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}




interface IERC20 {
    function balanceOf(address owner) external view returns (uint);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}

interface IDelfyLocker {
    
    struct Auction {
         address _auctionAddress;
         address auctionOwner;
         address LPTokenAddress;
         uint auctionLockPeriod;
         bool withdrawn;
         bool LPTokenburned;
     }
     
    function addAuctionDetails(address dexRouter,address token, address _owner, address _auctionAddr, uint _lockPeriod,bool _burnLP) external;
    function withdrawLpToken(address _token, uint _amount) external;
    function burnDexLPToken (address _token, uint _amountToBurn) external;
    function getLPAmount(address _auctionAddr) external view returns(uint);
}

contract Mutex {
    bool isLocked;
    modifier noReentrance() {
        require(!isLocked);
        isLocked = true;
        _;
        isLocked = false;
    }
    
}

contract DelfyLocker is Mutex, IDelfyLocker {
     using SafeMath for uint;
   
     
     uint256 private minimumLockPeriod = 90 days;
    //  address public immutable factory;
     mapping(address=> bool) public isFactory;
     address owner;
     
     address constant deadAddress = 0x000000000000000000000000000000000000dEaD;

       
    
     
     mapping(address=>Auction)public  auctionDetails; // auction address is required for this mapping
     mapping(address=>mapping( address=>address)) public auctionAddress; // auction owner address & token address is required for this mapping

     event Transfer(address _from, address _to, uint _amount);
     
     
     constructor() public {
       
       owner =msg.sender;
     }
     
     
    function setFactory(address _factory) external {
        require(msg.sender == owner, "only_owner");
        isFactory[_factory] =true;
    }
    
     
     
     function getLPAmount(address _auctionAddr) external view override returns(uint){
        return IERC20(auctionDetails[_auctionAddr].LPTokenAddress).balanceOf(address(this));
     }
     
     
     mapping(address => address) private tokenAddress; // for internal validations only
     
     function addAuctionDetails(address dexRouter, address token, address _owner, 
     address _auctionAddr, uint _lockPeriod, bool _burnLP) external override {
         require(isFactory[msg.sender], "LOCKER: only_factory");
         auctionAddress[_owner][token] = _auctionAddr;
         auctionDetails[_auctionAddr]._auctionAddress = _auctionAddr;
         auctionDetails[_auctionAddr].auctionOwner = _owner;
         auctionDetails[_auctionAddr].auctionLockPeriod = now.add(_lockPeriod);
         auctionDetails[_auctionAddr].LPTokenburned = _burnLP;
         tokenAddress[_auctionAddr]= token;
         address dexFactory = IUniswapV2Router02(dexRouter).factory();
         address weth = IUniswapV2Router02(dexRouter).WETH();
         address _pairAddr = IUniswapV2Factory(dexFactory).getPair(weth, token);
         if (_pairAddr == address(0)){
             IUniswapV2Factory(dexFactory).createPair(weth, token);
         }
         auctionDetails[_auctionAddr].LPTokenAddress = IUniswapV2Factory(dexFactory).getPair(weth, token);
     }

     // token address is used since this contract is design to lock LPtokens only
     function withdrawLpToken(address _token, uint _amount) external override noReentrance {
        require(auctionAddress[msg.sender][_token] != address(0),"LOCKER: no_auction");
        address _auctionAddress = auctionAddress[msg.sender][_token];
        require(now > auctionDetails[_auctionAddress].auctionLockPeriod, "LOCKER: in_lock_period");
        require(IERC20(auctionDetails[_auctionAddress].LPTokenAddress).balanceOf(address(this))>= _amount, 'LOCKER:: Balance_Zero'); 
        TransferHelper.safeTransfer( auctionDetails[_auctionAddress].LPTokenAddress, auctionDetails[_auctionAddress].auctionOwner, 
        _amount);
        auctionDetails[_auctionAddress].withdrawn=true;
        emit Transfer(address(this), auctionDetails[_auctionAddress].auctionOwner,  
        IERC20(auctionDetails[_auctionAddress].LPTokenAddress).balanceOf(address(this)));
        
     }
     
     
     function burnDexLPToken (address _token, uint _amount) external override noReentrance{
        require(auctionAddress[msg.sender][_token] != address(0) || tokenAddress[msg.sender]==_token, "LOCKER: no_auction_no_balance");
        address _auctionAddress;
        auctionAddress[msg.sender][_token]!=address(0)? _auctionAddress = auctionAddress[msg.sender][_token] : _auctionAddress = msg.sender;
        require(IERC20(auctionDetails[_auctionAddress].LPTokenAddress).balanceOf(address(this))>= _amount, 'LOCKER:: insufficient_bal');
        TransferHelper.safeTransfer( auctionDetails[_auctionAddress].LPTokenAddress, deadAddress, 
        _amount);
        auctionDetails[_auctionAddress].LPTokenburned=true;
        emit Transfer(address(this), deadAddress,  IERC20(auctionDetails[_auctionAddress].LPTokenAddress).balanceOf(address(this)));
     }
     
     
     // Restricted function
    function removeFactory(address _oldFactory) external {
        require(msg.sender == owner, "only_owner");
        isFactory[_oldFactory] =false;
    }
}


// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
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