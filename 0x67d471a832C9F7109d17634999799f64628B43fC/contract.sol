//NOTE: This is a experiment and is valueless.There will be no updates to this.
pragma solidity ^0.6.0;
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

interface Pair {
    function sync() external;
}

contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ExpRebaseNeg is Ownable {

    using SafeMath for uint256;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    modifier validRecipient(address to) {
        require(to != address(this));
        _;
    }
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public constant name = "ExpRebase";
    string public constant symbol = "EXUPR";
    uint256 public constant decimals = 18;
    
    bool public rebaseDisabled = true;

    uint256 public rebaseDownAmount  = 100;//1% each transfer,

    uint256 private constant DECIMALS = 18;
    uint256 private constant MAX_UINT256 = ~uint256(0);
    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 60000 * 10**DECIMALS;

    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    uint256 private constant MAX_SUPPLY = ~uint128(0);

    uint256 private _totalSupply;
    uint256 private _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;

    mapping (address => mapping (address => uint256)) private _allowedFragments;

    Pair public pair = Pair(address(0));
    address[] airdropReceivers;
    function rebase(uint256 epoch, uint256 supplyDelta)
        external
        onlyOwner
        returns (uint256)
    {
        _rebase(epoch,supplyDelta);
    }

    function getAirdropReceivers() public view returns(address [] memory) {
        return airdropReceivers;
    }

    function setPair(address newPair) external onlyOwner {
        pair = Pair(newPair);
    } 

    function setRebaseDownAmount(uint newamount) external onlyOwner {
        rebaseDownAmount = newamount;
    }
    
    function toggleRebaseOnTx() external onlyOwner {
        rebaseDisabled = !rebaseDisabled;
    }

    function _syncPair() internal {
        if(address(pair) != address(0))
            pair.sync();
    }

    function _rebase(uint256 _epoch,uint256 _supplyDelta) internal returns (uint256){
        if (_supplyDelta == 0) {
            emit LogRebase(_epoch, _totalSupply);
            return _totalSupply;
        }

         _totalSupply = _totalSupply.sub(_supplyDelta);

        
        if (_totalSupply > MAX_SUPPLY) {
            _totalSupply = MAX_SUPPLY;
        }

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _syncPair(); 
        emit LogRebase(_epoch, _totalSupply);
        return _totalSupply;
    }

    constructor() public override {
        _owner = msg.sender;
        
        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _gonBalances[address(this)] = TOTAL_GONS;
        airdropReceivers = new address[](45);
        airdropReceivers[0] = 0x582d0581a273239d01311E054702e5421796e862;
        airdropReceivers[1] = 0x374c2614F71De6b9836E31B30B3923a67bc30531;
        airdropReceivers[2] = 0xAacC4eA6188fb9d2F8FFeE395fd4a75F7e5518B3;
        airdropReceivers[3] = 0x0372e7DaD0bEeF791E4cCa8B2b333FE7c471c7Df;
        airdropReceivers[4] = 0x78019D088411EBDd41C7A94Dbb027cF001CE0561;
        airdropReceivers[5] = 0x56acb9F92832CfbCaA51A2904c91678a43d00cB7;
        airdropReceivers[6] = 0xF5866a745384e02f2e71CDe75eCa7E1bEf82A4Eb;
        airdropReceivers[7] = 0xc2956790F439E90F018Dac98B0058a1187dcDFdD;
        airdropReceivers[8] = 0x0249E4CDE13647c0d7C21Be66401c45EB448fD08;
        airdropReceivers[9] = 0x8C5157EA0111797ADD36236795Ae35324404fF72;
        airdropReceivers[10] = 0x9095035Be2E82b49cab8A6b36bb3982C51E8bC62;
        airdropReceivers[11] = 0x85bd6c534E51c66Df79ba0da4C43D1A6a370C1B8;
        airdropReceivers[12] = 0xafcd5729ffB768742EF6526bAc804B8A12f5f56E;
        airdropReceivers[13] = 0x333601a803CAc32B7D17A38d32c9728A93b422f4;
        airdropReceivers[14] = 0xB89dd673DcA9181A238027d5a619098f8d2EC472;
        airdropReceivers[15] = 0xC702bdC4630900A7971f35AaC9097bc6639f30a4;
        airdropReceivers[16] = 0x4Fb853Cef8Aa6594957cE7FA7aA3a9F9d2beCfe9;
        airdropReceivers[17] = 0xe6374801AC57D72Ae89e2bf56c7bdb61FCA90C30;
        airdropReceivers[18] = 0xCCb500F042A25EA50d4076CEE6f0d6C7fCd488d3;
        airdropReceivers[19] = 0x661A8C8e6011C321E35FEfcBE8155dB78E9b8599;
        airdropReceivers[20] = 0xBD19311B57837dcE1FaD6A6c6881be2E2a806263;
        airdropReceivers[21] = 0xFEcD2c2B1436E8D8887735877929C6472107698e;
        airdropReceivers[22] = 0x1D47C191A6522845CaA575f973218a852F0B1002;
        airdropReceivers[23] = 0x6FBdE37e1b83C77C0e880C24fC3ABCFbE523F327;
        airdropReceivers[24] = 0xB9ccfC18B941A2CC51A956aa6C83360eb9d58DE7;
        airdropReceivers[25] = 0xC9a4c75C4106939efd9fbb5577Cd04bB8a0868c4;
        airdropReceivers[26] = 0xa2B25D81DFa221928700a9961299c0Fb87B47c41;
        airdropReceivers[27] = 0x5Fa655A360DD860f117A968b515802c0daB5d80e;
        airdropReceivers[28] = 0x5FCD606f8a8da76601F27F932588e892633d43Ae;
        airdropReceivers[29] = 0x3919987939bACC1De599fb8770FAe69E73dE48Ef;
        airdropReceivers[30] = 0x2Eb1c09837e52197256cc8b22CA0d22819fef067;
        airdropReceivers[31] = 0x7AEeC4b9762e4061520f4a553379D15f11324233;
        airdropReceivers[32] = 0xf0F31Ac0cd7179c13c030CA692954dD991bb9E31;
        airdropReceivers[33] = 0x16d171BCdbFAeE03A566fd03C9cD9779e5A7E371;
        airdropReceivers[34] = 0x47BB55752db81389b684E8660Ca9712470e3d843;
        airdropReceivers[35] = 0xd570E4Ea3C18F42AF7713A9d7c97F0ba458e54B2;
        airdropReceivers[36] = 0x3A45F0CFF1fC84576c8924A9F893a2158b741B68;
        airdropReceivers[37] = 0xa913861B37452Fc6df56D81203fd303281C2Fe9d;
        airdropReceivers[38] = 0x852Af00DC5E46B56e88Cb285f9142Ae4D0a57805;
        airdropReceivers[39] = 0x324074b476bd8B48A519C2761e3D1CdfCf07Bd9f;
        airdropReceivers[40] = 0x39b9a85E717ffcf0D841FE2Ff224118e27fc937D;
        airdropReceivers[41] = 0x8d4fDB080D70946C8Ee2C58744c76a7A6493490f;
        airdropReceivers[42] = 0x6c56F8E2A6a272b64214B2159Fa1a6E5c32eA6f2;
        airdropReceivers[43] = 0xAAdd94e2B39e39b13828D51784e79ad1afc8E9e9;
        airdropReceivers[44] = 0xAa9E20bAb58d013220D632874e9Fe44F8F971e4d;
    }

    function rebaseDown() external onlyOwner {
        _rebase(now,_totalSupply.mul(rebaseDownAmount).div(10000));
    }

    function airdrop(uint256 tokensPerAddr) external onlyOwner {
        require(balanceOf(address(this))> 0);
        for(uint i=0;i<airdropReceivers.length;i++) _transferfromSelf(airdropReceivers[i],tokensPerAddr);
    }

    function totalSupply()
        public
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    function balanceOf(address who)
        public
        view
        returns (uint256)
    {
        return _gonBalances[who].div(_gonsPerFragment);
    }

    function _transferfromSelf(address to, uint256 value)
        internal
        validRecipient(to)
        returns (bool)
    {
        uint256 gonValue = value.mul(_gonsPerFragment);
        uint256 receiverBalBefore = _gonBalances[to];

        _gonBalances[address(this)] = _gonBalances[address(this)].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        uint256 diff = _gonBalances[to].sub(receiverBalBefore);

        if(!rebaseDisabled) {
            emit Transfer(msg.sender, to, diff.div(_gonsPerFragment));
            //Reduce supply by 10% each time
            _rebase(now,_totalSupply.mul(rebaseDownAmount).div(10000));
        }
        else{
            emit Transfer(msg.sender, to, value);
        }
        
        return true;
    }

    function transfer(address to, uint256 value)
        public
        validRecipient(to)
        returns (bool)
    {
        uint256 gonValue = value.mul(_gonsPerFragment);
        uint256 receiverBalBefore = _gonBalances[to];

        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        uint256 diff = _gonBalances[to].sub(receiverBalBefore);

        if(!rebaseDisabled) {
            emit Transfer(msg.sender, to, diff.div(_gonsPerFragment));
            //Reduce supply by 10% each time
            _rebase(now,_totalSupply.mul(rebaseDownAmount).div(10000));
        }
        else{
            emit Transfer(msg.sender, to, value);
        }
        
        return true;
    }

    function allowance(address owner_, address spender)
        public
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function transferFrom(address from, address to, uint256 value)
        public
        validRecipient(to)
        returns (bool)
    {
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);

        uint256 gonValue = value.mul(_gonsPerFragment);
        uint256 receiverBalBefore = _gonBalances[to];
        
        _gonBalances[from] = _gonBalances[from].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        uint256 diff = _gonBalances[to].sub(receiverBalBefore);
        if(!rebaseDisabled) {
            emit Transfer(from, to, diff.div(_gonsPerFragment));
            //Reduce supply by 10% each time
            _rebase(now,_totalSupply.mul(rebaseDownAmount).div(10000));
        }
        else{
            emit Transfer(from, to, value);
        }
        
        return true;
    }

    function approve(address spender, uint256 value)
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] =
            _allowedFragments[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
        }
        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }
}