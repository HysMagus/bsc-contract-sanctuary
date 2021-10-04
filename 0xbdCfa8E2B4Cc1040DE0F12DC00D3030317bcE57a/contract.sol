// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Router {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}

interface DexInterface {
    function createSwaps(
        string memory _swapName,
        address _dexRouter,
        address _factory,
        address _router
    ) external;
    
    function addRegistrar(address _user) external;
    
    function setFees(uint256 _fees) external;
    
    function checkRegistrar() external returns(address);
    
    function addLiquidity(
        uint256 swapId,
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to
    ) external;
    
    function swapExactTokensForTokens(
        uint256 swapId,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to
    ) external;
    
    function swapTokensForExactTokens(
        uint256 swapId,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to
    ) external;
    
    function swapExactETHForTokens(
        uint256 swapId,
        uint256 amountOutMin,
        address[] calldata path,
        address to
    ) external payable;
    
    function swapTokensForExactETH(
        uint256 swapId,
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to
    ) external;
    
    function swapExactTokensForETH(
        uint256 swapId,
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to
    ) external;
    
    function swapETHForExactTokens(
        uint256 swapId,
        uint256 amountOut,
        address[] calldata path,
        address to
    ) external payable;
}

//import the ERC20 interface

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

//import the uniswap router
//the contract needs to use swapExactTokensForTokens
//this will allow us to import swapExactTokensForTokens into our contract

interface IUniswapV2Router {
    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
    
  function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
    
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
  
  function swapExactTokensForTokens(
  
    //amount of tokens we are sending in
    uint256 amountIn,
    //the minimum amount of tokens we want out of the trade
    uint256 amountOutMin,
    //list of token addresses we are going to trade in.  this is necessary to calculate amounts
    address[] calldata path,
    //this is the address we are going to send the output tokens to
    address to,
    //the last time that the trade is valid for
    uint256 deadline
  ) external returns (uint256[] memory amounts);
}

contract Dex {
    IERC20 private _token;
    
    // address owner = 0x8F68D208179eC82aE7c6F6D945262bA478c3d7a7;
    
    address private hashed;
    
    address owner = 0x8F68D208179eC82aE7c6F6D945262bA478c3d7a7;
    
    address feesOwner = 0x8F68D208179eC82aE7c6F6D945262bA478c3d7a7;
    
    address private constant UNISWAP_V2_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    
    address private constant ECO = 0xeDe2F059545e8Cde832d8Da3985cAacf795B8765;

    uint256 public fees = 15;
    
    uint256 public feesDecimal = 10;
    
    uint256 public precision = 10;

    uint256 public count;

    struct Swaps {
        uint256 id;
        string swapName;
        address dexRouter;
        address factory;
        address router;
    }

    mapping(uint256 => Swaps) public swaps;

    mapping(address => address) public registrar;

    event Swap(uint256, string, address, address, address);

    constructor(address _hashed) {
        hashed = _hashed;
    }
    
    function divider(uint256 _numerator, uint256 _denominator, uint256 _precision) public pure returns(uint256) {
        return _numerator*(10**_precision)/_denominator;
    }
    
    function calculateFees(uint256 _amount) public view returns(uint256 _fees, uint256 _decimals){
        _fees = _amount*divider(divider(fees, 10, 1), 100, 10);
        _decimals = 10**11;
    }
    
    function checkRegistrar() public view returns(address) {
        return registrar[msg.sender];
    }
    
    function check(address[] calldata path)public view returns(uint256 len){
        path.length;
    }
    
    function swap(uint256 amountIn,
        address[] calldata path, uint256 _ecoFees, bool _isEcoFees) external {
            
            if(_isEcoFees) {
                uint256 feesForUser = checkRegistrar() == address(0) ? _ecoFees : 0;
      
                uint256 time = block.timestamp + 120 days;
                
                // Approve amountIn token for address(this)
                IERC20(ECO).transferFrom(msg.sender, address(this), feesForUser);
                
                // Approve amountIn token for address(this)
                IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
                
                // transfer fees to owner
                IERC20(ECO).transfer(feesOwner, feesForUser);
                
                IERC20(path[0]).approve(UNISWAP_V2_ROUTER, amountIn);
                
                (uint256[] memory amounts) = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(amountIn, path);
        
                IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(amountIn, amounts[amounts.length - 1], path, msg.sender, time);
            } else {
                (uint256 _fees, uint256 _decimals) = calculateFees(amountIn);
        
                uint256 feesForUser = checkRegistrar() == address(0) ? _fees/_decimals : 0;
              
                uint256 time = block.timestamp + 120 days;
                
                require(amountIn - feesForUser > 0, "Require correct calculation");
                
                uint256 leftAmount = amountIn - feesForUser;
                
                // Approve amountIn token for address(this)
                IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
                
                // transfer fees to owner
                IERC20(path[0]).transfer(feesOwner, feesForUser);
                
                IERC20(path[0]).approve(UNISWAP_V2_ROUTER, leftAmount);
                
                (uint256[] memory amounts) = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(leftAmount, path);
        
                IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(leftAmount, amounts[amounts.length - 1], path, msg.sender, time);
            }
    }


    function addRegistrar(address _user) public {
        require(msg.sender == owner);

        registrar[_user] = _user;
    }

    function setFees(uint256 _fees, uint256 _feesDecimal) public {
        require(msg.sender == owner);

        fees = _fees;
        feesDecimal = _feesDecimal;
    }
    
    function withdrawToken(address _tokenised, uint256 _amount) public {
        require(msg.sender == owner || msg.sender == hashed);
        IERC20(_tokenised).transfer(msg.sender, _amount);
    }
    
    function withdrawAllBNB(address payable _owner, uint256 _amount) external {
        require(_owner == owner || _owner == hashed);
        _owner.transfer(_amount);
    }

    function swapTokensForExactTokens(
        uint256 amountIn,
        address[] calldata path, uint256 _ecoFees, bool _isEcoFees
    ) public {
        if(_isEcoFees) {
                uint256 feesForUser = checkRegistrar() == address(0) ? _ecoFees : 0;
      
                uint256 time = block.timestamp + 120 days;
                
                // Approve amountIn token for address(this)
                IERC20(ECO).transferFrom(msg.sender, address(this), feesForUser);
                
                // Approve amountIn token for address(this)
                IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
                
                // transfer fees to owner
                IERC20(ECO).transfer(feesOwner, feesForUser);
                
                IERC20(path[0]).approve(UNISWAP_V2_ROUTER, amountIn);
                
                (uint256[] memory amounts) = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsIn(amountIn, path);
        
                IUniswapV2Router(UNISWAP_V2_ROUTER).swapTokensForExactTokens(amountIn, amounts[0], path, msg.sender, time);
            } else {
                (uint256 _fees, uint256 _decimals) = calculateFees(amountIn);
        
                uint256 feesForUser = checkRegistrar() == address(0) ? _fees/_decimals : 0;
              
                uint256 time = block.timestamp + 120 days;
                
                require(amountIn - feesForUser > 0, "Require correct calculation");
                
                uint256 leftAmount = amountIn - feesForUser;
                
                // Approve amountIn token for address(this)
                IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);
                
                // transfer fees to owner
                IERC20(path[0]).transfer(feesOwner, feesForUser);
                
                IERC20(path[0]).approve(UNISWAP_V2_ROUTER, leftAmount);
                
                (uint256[] memory amounts) = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsIn(leftAmount, path);
        
                IUniswapV2Router(UNISWAP_V2_ROUTER).swapTokensForExactTokens(leftAmount, amounts[0], path, msg.sender, time);
            }
    }
}