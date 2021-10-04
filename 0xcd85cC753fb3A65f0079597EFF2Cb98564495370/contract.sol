// chartlist.xyz
// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;


abstract contract Context {
    function _sender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
}

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router01 {
    
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
    
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

}

interface IUniswapV2Router02 is IUniswapV2Router01 {

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Token is Context{

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => bool) public exclude;
    mapping(address => bool) public isPair;

    uint public totalSupply = 500_000 * (10 ** 18);
    string public name = "Sad Coin";
    string public symbol = "SAD";
    uint public decimals = 18;

    bool takeFee = true;
    uint fee = 16;
    uint marketingFee = 4;
    bool availableBuy = true;
    uint liquify = 100 * (10 ** 15); // 100 finney = 0.1 ether

    IUniswapV2Router02 router;
    address pair;
    address public owner;
    address public marketing;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    event SwapETHForTokens(uint256 amountIn, address[] path);

    event SwapTokensForETH(uint256 amountIn, address[] path);
    
    //address routesAdress = 0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0; // testnet
    address routesAdress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // mainet
    
    constructor() {
        owner = _sender();
        marketing = _sender();
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routesAdress);
        pair = IUniswapV2Factory(_uniswapV2Router.factory())
               .createPair(address(this), _uniswapV2Router.WETH());
        router = _uniswapV2Router;
        isPair[pair] = true;
        balances[_sender()] = totalSupply;
        exclude[address(this)] = true;
        exclude[owner] = true;
        emit Transfer(address(0), _sender(), totalSupply);
    }
    
    modifier initial() {
        require(_sender() == owner);
        _;
    }

    bool internal entry;

    modifier noReentrant() {
        require(!entry, "No re-entrancy");
        entry = true;
        _;
        entry = false;
    }

    function changeOwner(address _newOwner) external initial {
        owner = _newOwner;
    }

    function feeInfo() external view returns(bool, uint, uint , bool, uint){
        return(takeFee, fee, marketingFee, availableBuy, liquify);
    }

    function setFee(bool active, uint fees, uint _marketingFee, bool _availableBuy) external initial {
        takeFee = active;
        fee = fees;
        marketingFee = _marketingFee;
        availableBuy = _availableBuy;
    }
 
    // case when there is no re-entrant problem
    function resolveNoReentrant(bool _entry) external initial {
        entry = _entry;
    }

    function setMarketingAddress(address account) external initial {
        marketing = account;
    }

    function setExclude(bool add, address account) external initial {
        exclude[account] = add;
    }

    function setPair(bool add, address account) external initial {
        isPair[account] = add;
    }

    function setLiquify(uint value) external initial {
        liquify = value * (10 ** 15); // finney
    }
    
    function balanceOf(address who) public view returns(uint) {
        return balances[who];
    }
    
    function transfer(address to, uint value) public returns(bool) {
        require(balances[_sender()] >= value, 'balance too low');
        _transfer(_sender(), to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balances[from] >= value, 'balance too low');
        require(allowance[from][_sender()] >= value, 'allowance too low');
        allowance[from][_sender()] -= value;
        _transfer(from, to, value);
        return true;   
    }

    function _transfer(address from, address to, uint value) internal {

       uint values = value;

       bool isSwap = isPair[from] || isPair[to];
       bool notExclude = !exclude[from] && !exclude[to];

       if(takeFee && notExclude && isSwap){

            uint _fee = value / (100 / fee);
               value = value - _fee;
            uint feeForMarketing = _fee / ( 100 / marketingFee );
            uint current = _fee - feeForMarketing;
            balances[address(this)] += current;
            balances[marketing] += feeForMarketing;

            uint calc = calculate(liquify);
            bool pass = balances[address(this)] >= calc;
             if(isPair[to] && pass){  

                uint tokenBalance = balances[address(this)];
                uint halfOfToken = tokenBalance / 2;
                uint otherHalf   = tokenBalance - halfOfToken;

                swapTokensForEth(halfOfToken);

                addLiquidity(otherHalf, address(this).balance); // all in
             }
        }

        balances[to] += value;
        balances[from] -= values;
        emit Transfer(from, to, value);

    }
    
    function approve(address spender, uint value) public returns (bool) {
        _approve(_sender(), spender, value);
        return true;   
    }
    
    function _approve(address from, address spender, uint value) internal{
        allowance[from][spender] = value;
        emit Approval(from, spender, value);
    }
    
    function _mint(address receiver, uint value) internal {
        balances[receiver] += value;
        totalSupply += value;
        emit Transfer(address(0), receiver, value);
    }

    function _burn(address sender, uint value) internal {
        balances[sender] -= value;
        totalSupply -= value;
        emit Transfer(sender, address(0), value);
    }

    function burn(uint value) public returns(bool){
        require(balances[_sender()] >= value);
        _burn(_sender(), value);
        return true;
    }
    
    // liquidity rate
    function getRate() public view returns(uint res){
        address token0 = IUniswapV2Pair(pair).token0();
        (uint rev0, uint rev1,) = IUniswapV2Pair(pair).getReserves();
        res = token0 == address(this) ? ( rev0 / rev1 ) : ( rev1 / rev0);
    }
    
    function calculate(uint etherAmount) internal view returns(uint){
        uint rate = getRate();
             rate = rate * etherAmount;
        return rate;
    }

    function liquifis() public view returns(uint){
        return calculate(liquify);
    }

    function calculateWithFee(uint etherAmount) public view returns(uint){
        uint rate = calculate(etherAmount);
        uint fees = rate / (100 / fee);
             rate -= fees;
        return rate;
    }

    function buy() external payable {

        require(availableBuy, 'buy mint token not availble');
        require(msg.value != 0);
        
        uint value = msg.value;
        uint buyerGet = calculate(value);
        uint _fee = buyerGet / (100 / fee);
             buyerGet = buyerGet - _fee;
        // token mint by buy
        _mint(_sender(), buyerGet);
        // mint for add the liquidity
        uint liquidityGet = calculate(value);
        _mint(address(this), liquidityGet);
        addLiquidity(liquidityGet, value);

    }

    function swapTokensForEth(uint amount) internal noReentrant {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = router.WETH();

            _approve(address(this), address(routesAdress), amount);
            try router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                amount,
                0, 
                path,
                address(this), 
                block.timestamp
            ) {} catch {}
    }
    
    function addLiquidity(uint tokenAmount, uint ethAmount) private noReentrant{
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner,
            block.timestamp
        );
        
    }

    
    function restoreEmergency(bool bnb, address _token) external initial {
        if(bnb){
            payable(owner).transfer(address(this).balance);
        }else{
            IERC20 token = IERC20(_token);
            uint bal = token.balanceOf(address(this));
            token.transfer(owner, bal);
        }
    }

    receive() external payable {}
}