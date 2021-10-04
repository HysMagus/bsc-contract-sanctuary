/**
 *Submitted for verification at hecoinfo.com on 2021-09-24
*/

/**
 *Submitted for verification at hecoinfo.com on 2021-09-11
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);
    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
contract SunLine{
    using SafeMath for uint256;
    struct User{
        //uint256 singleStake;
        uint256 stakeFil;
        uint256 recommendFil;
        address recommend;
        address[] members;
        address subordinate;
        address recommendSingle;
        uint256 singleReward;
        uint256 sunReward;
        uint256 myWith;
        uint8   level;
        // uint256 help;
    }
    mapping(address=>User) userInfo;
    mapping(uint8=>uint256) rate;
    address[] public userSum;
    uint256 totalStake;
    uint256 totalWith;
    address manager;
    address fil;
    address seFee;
    address recovery;
    
    constructor(){
        manager = msg.sender;
    }
    
    function getApprove(address _customer) public view returns(bool){
        uint256 amount = IERC20(fil).allowance(_customer, address(this));
        if(amount >=10000e8){
            return true;
        }else{
            return false;
        }
    }
    
    function setRateMapping(uint8 _lev,uint256 _rate) public{
        require(msg.sender==manager,"Ping:No permit");
        rate[_lev] = _rate;
    }

    function changOwner(address _owner) public{
        require(msg.sender==manager,"Ping:No permit");
        manager = _owner;
    }
    
    function getWithRate(uint8 _lev) public view returns(uint256 _rat){
        _rat = rate[_lev];
    }

    function getUserInfo(address _customer) public view returns(uint256 _stakeFil,uint256 _recoFil,
            uint256 _sinReward,uint256 _sunReward,uint256 _with,uint8 _level,address _sunReco,
            address _sinReco,address[] memory _members,uint256 _mems){
        User storage user = userInfo[_customer];
        // _sinStake = user.singleStake;
        _stakeFil = user.stakeFil;
        _recoFil = user.recommendFil;
        _sinReward = user.singleReward;
        _sunReward = user.sunReward;
        _with = user.myWith;
        //_help = user.help;
        _level = user.level;
        _sunReco = user.recommend;
        _sinReco = user.recommendSingle;
        _members = user.members;
        _mems = user.members.length;
    }


    function getUserReward(address _customer) public view returns(uint256 amount){
        User storage user = userInfo[_customer];
        amount = user.sunReward.add(user.singleReward);
    }
    
    function setPoolAddress(address _fil,address _seFee,address _recovery)public{
        require(msg.sender==manager,"Ping:No permit");
        fil = _fil;
        seFee = _seFee;
        recovery = _recovery;
    }

    function setFirstAccount(address _recommend,address _customer) public{
        require(msg.sender==manager,"Ping:No permit");
        User storage user = userInfo[_customer];
        User storage reco = userInfo[_recommend];
        reco.members.push(_customer);
        reco.subordinate = _customer;
        user.recommend = _recommend;
        userSum.push(_recommend);
        userSum.push(_customer);
    }

    function getUserRecommend(address _customer) public view returns(address _reco){
        User storage user = userInfo[_customer];
        _reco = user.recommend;
    }

   
    
    function provide(address _recommend,address _customer,uint256 _amount) public{
        require(_customer!=address(0) && _amount>=100e8,"Ping:Wrong address and amount");
        User storage user = userInfo[_customer];
        if(getUserRecommend(_customer)==address(0)){
            require(_recommend != address(0),"Ping:Zero code");
            User storage reco = userInfo[_recommend];
            require(reco.recommend!=address(0),"Ping:Recommend code wrong");
            reco.members.push(_customer);
            user.recommend = _recommend;
            address _last = userSum[userSum.length-1];
            User storage last = userInfo[_last];
            require(last.subordinate==address(0),"Ping:Only one subordinate");
            user.recommendSingle = _last;
            last.subordinate = _customer;
            userSum.push(_customer);
        }
        //require(user.recommend != address(0),"Ping:Zero code");
        require(IERC20(fil).transferFrom(_customer, address(this), _amount),"Ping:TransferFrom failed");
        totalStake = totalStake.add(_amount);
        user.stakeFil = user.stakeFil.add(_amount);
        updateMyLevel(_customer);
        updateLeaderLevel(_customer);
        uint256 preSingle = _amount.mul(40).div(4000);
        uint256 befor = _amount.mul(10).div(100);
        updateRecommendUp10Info(_customer, preSingle);//1.125
        updateRecommendDown30Info(_customer, preSingle);//1.125
        updateRecommend9Info(_customer,_amount);//100
        //outSystem(befor);
        sendFee(befor);
    }

    function sendFee(uint256 _amount)internal{
        require(IERC20(fil).transfer(recovery, _amount),"Ping:Transfer failed");
    }
    
    function updateRecommend9Info(address _customer,uint256 _amount) internal{
        User storage user = userInfo[_customer];
        address _loop = user.recommend;
        for(uint i=0; i<9; i++){
            User storage loop = userInfo[_loop];
            if(i==0){
                loop.recommendFil = loop.recommendFil.add(_amount.mul(20).div(100));
                loop.sunReward = loop.sunReward.add(_amount.mul(20).div(100));
                _loop = loop.recommend;
            }else if(i==1){
                loop.recommendFil = loop.recommendFil.add(_amount.mul(10).div(100));
                loop.sunReward = loop.sunReward.add(_amount.mul(10).div(100));
                _loop = loop.recommend;
            }else if(i>=2 && i<=4){
                loop.recommendFil = loop.recommendFil.add(_amount.mul(3).div(100));
                loop.sunReward = loop.sunReward.add(_amount.mul(3).div(100));
                _loop = loop.recommend;
            }else if(i>4 && i<8 && loop.members.length>=5){
                loop.recommendFil = loop.recommendFil.add(_amount.mul(2).div(100));
                loop.sunReward = loop.sunReward.add(_amount.mul(2).div(100));
                _loop = loop.recommend;
            }else if(i>7 && i<9 && loop.members.length>=10){
                loop.recommendFil = loop.recommendFil.add(_amount.mul(10).div(100));
                loop.sunReward = loop.sunReward.add(_amount.mul(10).div(100));
                _loop = loop.recommend;
            }else{
                _loop = loop.recommend;
            }
        }
    }
    
    //0-1 1-2 2-3 3-4 4-5 5-6 6-7 7-8 8-9 9-10 10-11 11-12 12-13 13-14 14-15 
    function updateRecommendUp10Info(address _customer,uint256 _amount) internal{
        User storage user = userInfo[_customer];
        address _loop = user.recommendSingle;
        for(uint i=0; i<10; i++){
            if(_loop !=address(0)){
                User storage loop = userInfo[_loop];
                loop.recommendFil = loop.recommendFil.add(_amount);
                loop.singleReward = loop.singleReward.add(_amount);
                _loop = loop.recommendSingle;
            }
        }
    }
    
    

    function updateRecommendDown30Info(address _customer,uint256 _amount) internal{
        User storage user = userInfo[_customer];
        address _loop = user.subordinate;
        for(uint i=0; i<30; i++){
            if(_loop !=address(0)){
                User storage loop = userInfo[_loop];
                loop.recommendFil = loop.recommendFil.add(_amount);
                loop.singleReward = loop.singleReward.add(_amount);
                _loop = loop.subordinate;
            }
        }
    }
    
    function updateMyLevel(address _customer) internal{
        User storage user = userInfo[_customer];
        if(user.stakeFil>=100e8 && user.level<1){
            user.level = 1;
        } 
        if(user.stakeFil>=500e8  && user.level<2){
            user.level = 2;
        }  
        if(user.stakeFil>=1000e8 && user.level<3){
            user.level = 3;
        } 
        if(user.stakeFil>=2000e8 && user.level<4){
            user.level = 4;
        } 
        if(user.stakeFil>=5000e8 && user.level<5){
            user.level = 5;
        } 
        if(user.stakeFil>=10000e8 && user.level<6){
            user.level = 6;
        }
    }
    
    function updateLeaderLevel(address _customer) internal{
        User storage me = userInfo[_customer];
        User storage user = userInfo[me.recommend];
        if(user.stakeFil>=100e8 && user.level<1){
            user.level = 1;
        } 
        if(user.stakeFil>=500e8  && user.level<2){
            user.level = 2;
        }  
        if(user.stakeFil>=1000e8 && user.level<3){
            user.level = 3;
        } 
        if(user.stakeFil>=2000e8 && user.level<4){
            user.level = 4;
        } 
        if(user.stakeFil>=5000e8 && user.level<5){
            user.level = 5;
        } 
        if(user.stakeFil>=10000e8 && user.level<6){
            user.level = 6;
        }
    }

    function getWithdrawInfo(address _customer,uint256 _amount) public view returns(uint256 _tru,uint256 _pro){
        User storage user = userInfo[_customer];
        if(user.level>=1){
            _tru = _amount.mul(rate[user.level]).div(100);
            _pro = _amount.sub(_amount.mul(rate[user.level].add(18)).div(100));  
        }else{
            _tru = 0;
            _pro = 0;
        }
        
    }

    function withdraw(address _customer,uint256 _amount) public{
        require(_customer!=address(0) && _amount>=100e8,"Ping:Wrong address and amount");
        User storage user = userInfo[_customer];
        require(_amount <= user.recommendFil,"Ping:Asset not enough");
        require(user.level>=1,"Ping:No withdraw permit");
        require(IERC20(fil).transfer(recovery,_amount.mul(10).div(100)),"Ping:Transfer failed");
        require(IERC20(fil).transfer(seFee,_amount.mul(8).div(100)),"Ping:Transfer failed");
        require(rate[user.level]>0,"Ping:Rate is Wrong");
        uint256 _with = _amount.mul(rate[user.level]).div(100);
        require(IERC20(fil).transfer(_customer,_with),"Ping:Transfer failed");
        user.recommendFil = user.recommendFil.sub(_amount);
        user.myWith = user.myWith.add(_with);
        
        uint256 _total = _amount.mul(rate[user.level].add(18)).div(100);
        uint256 _surplus = _amount.sub(_total);
        uint256 preSingle = _surplus.mul(50).div(4000);
        totalStake = totalStake.add(_surplus);
        totalWith = totalWith.add(_with);
        user.stakeFil = user.stakeFil.add(_surplus);
        updateMyLevel(_customer);
        updateRecommendDown30Info(_customer, preSingle);
        updateRecommendUp10Info(_customer, preSingle);
        updateRecommend9Info(_customer, _surplus);
    }

    function getTotalAmount() public view returns(uint256 _stake,uint256 _with,uint256 _leng){
        _leng = userSum.length;
        _stake = totalStake;
        _with = totalWith;
    }

    function pingData40(address _customer) public view returns(address[40] memory _u,uint256[40] memory _a){
        User storage user = userInfo[_customer];
        address _loop = user.recommendSingle;
        for(uint i = 0; i<40; i++){
            if(_loop != address(0)){
                User storage loop = userInfo[_loop];
                _u[i] = _loop;
                _a[i] = loop.stakeFil;
                _loop = loop.recommendSingle;
            }
        }
    }

    function pingDate60(address _customer) public view returns(address[60] memory _u,uint256[60] memory _a){
        User storage user = userInfo[_customer];
        address _loop = user.subordinate;
        for(uint i = 0; i<60; i++){
            if(_loop != address(0)){
                User storage loop = userInfo[_loop];
                _u[i] = _loop;
                _a[i] = loop.stakeFil;
                _loop = loop.subordinate;
            }
        }
    }
    
    function managerWithdraw(uint256 _amount) public{
        require(msg.sender==manager,"Ping:No permit");
        require(IERC20(fil).transfer(manager,_amount),"Ping:Transfer failed");
    }
    
}