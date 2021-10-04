// SPDX-License-Identifier: MIT;
pragma solidity ^0.6.10;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
        uint256 c = add(a, m);
        uint256 d = sub(c, 1);
        return mul(div(d, m), m);
    }
}

/// math.sol -- mixin for inline numerical wizardry

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
contract DSMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    function imin(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function imax(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    uint256 constant WAD = 10**18;
    uint256 constant RAY = 10**27;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
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
}
contract ECHOStandard is ERC20Detailed, DSMath {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    string constant tokenName = "echoDeFi";
    string constant tokenSymbol = "ECHO";
    uint8 constant tokenDecimals = 18;
    uint256 _totalSupply = 1_000_000 ether;
    uint256 public rate;
    mapping(address => uint256) public lastTimeBalanceNegative;
    mapping(address => uint256) public lastTimeBalancePositive;
    mapping(address => bool) public hasTransfered;
    uint256 public minimumBalance = 50 ether;
    uint256 public maxRewardable = 40_000 ether;
    uint256 public HODLTimeRewardable = 7 days;
    uint8 public burnRate = 5;
    mapping(address => uint256) public balanceBeforeLastReceive;
    mapping(address => bool) public isExcluded;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only_owner");
        _;
    }

    constructor()
        public
        payable
        ERC20Detailed(tokenName, tokenSymbol, tokenDecimals)
    {
        _mint(msg.sender, _totalSupply);
        owner = msg.sender;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }

    function allowance(address _owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowed[_owner][spender];
    }

    function findBurnVol(uint256 value) public view returns (uint256) {
        uint256 roundValue = value.ceil(100);
        uint256 burnVol = roundValue.mul(burnRate).div(100);
        return burnVol;
    }

    function wadToRay(uint256 _wad) internal pure returns (uint256) {
        return mul(_wad, 10**9);
    }

    function weiToRay(uint256 _wei) internal pure returns (uint256) {
        return mul(_wei, 10**27);
    }

    function yearlyRateToRay(uint256 _rateWad) internal pure returns (uint256) {
        return
            add(
                wadToRay(1 ether),
                rdiv(wadToRay(_rateWad), weiToRay(365 * 86400))
            );
    }

    function updateRate(uint256 rateWad) external onlyOwner {
        rate = yearlyRateToRay(rateWad);
    }

    function viewAccruedPlusCapital(address user)
        external
        view
        returns (uint256)
    {
        uint256 time =
            !hasTransfered[user]
                ? block.timestamp.sub(lastTimeBalancePositive[user])
                : block.timestamp.sub(lastTimeBalanceNegative[user]);
        return accrueInterest(_balances[user], rate, time);
    }

    function accrueInterest(
        uint256 _principal,
        uint256 _rate,
        uint256 _age
    ) internal pure returns (uint256) {
        return rmul(_principal, rpow(_rate, _age));
    }

    function calculateEarned(address user, uint256 balance)
        internal
        view
        returns (uint256)
    {
        uint256 sinceLastReceived =
            block.timestamp.sub(lastTimeBalancePositive[user]);
        uint256 time =
            !hasTransfered[user]
                ? block.timestamp.sub(lastTimeBalancePositive[user])
                : block.timestamp.sub(lastTimeBalanceNegative[user]);
        uint256 bals =
            sinceLastReceived < HODLTimeRewardable
                ? balanceBeforeLastReceive[user]
                : balance;
        if (bals > minimumBalance) return accrueInterest(bals, rate, time);
    }

    function transfer(address to, uint256 value)
        public
        override
        returns (bool)
    {
        require(value <= _balances[msg.sender], "Insufficient");
        require(to != address(0), "Address_zero");
        uint256 balance_ = _balances[msg.sender];
        _balances[msg.sender] = _balances[msg.sender].sub(value);

        balanceBeforeLastReceive[to] = _balances[to];
        uint256 tokensToBurn = findBurnVol(value);
        uint256 tokensToTransfer = value.sub(tokensToBurn);

        _balances[to] = _balances[to].add(tokensToTransfer);

        _totalSupply = _totalSupply.sub(tokensToBurn);
        emit Transfer(msg.sender, address(0), tokensToBurn);
        emit Transfer(msg.sender, to, tokensToTransfer);

        reward(msg.sender, balance_);
        lastTimeBalancePositive[to] = block.timestamp;
        lastTimeBalanceNegative[msg.sender] = block.timestamp;
        hasTransfered[msg.sender] = true;
        return true;
    }

    function reward(address person, uint256 amount) internal {
        if (!isExcluded[person] && calculateEarned(person, amount) > 0) {
            uint256 _amount = amount > maxRewardable ? maxRewardable : amount;
            uint256 value = (calculateEarned(person, _amount)).sub(_amount);
            _mint(person, value);
            _totalSupply = _totalSupply.add(value);
        }
    }

    function multiTransfer(address[] memory receivers, uint256[] memory amounts)
        external
    {
        for (uint256 i = 0; i < receivers.length; i++) {
            transfer(receivers[i], amounts[i]);
        }
    }

    function approve(address spender, uint256 value)
        public
        override
        returns (bool)
    {
        require(spender != address(0), "Address_zero");
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        require(value <= _balances[from], "Insufficient");
        require(value <= _allowed[from][msg.sender], "Increase_allowance");
        require(to != address(0), "Address_zero");
        uint256 balance_ = _balances[from];
        _balances[from] = _balances[from].sub(value);
        balanceBeforeLastReceive[to] = _balances[to];
        uint256 tokensToBurn = findBurnVol(value);
        uint256 tokensToTransfer = value.sub(tokensToBurn);

        _balances[to] = _balances[to].add(tokensToTransfer);
        _totalSupply = _totalSupply.sub(tokensToBurn);
        emit Transfer(from, to, tokensToTransfer);
        emit Transfer(from, address(0), tokensToBurn);
        reward(from, balance_);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        lastTimeBalancePositive[to] = block.timestamp;
        lastTimeBalanceNegative[from] = block.timestamp;
        hasTransfered[from] = true;
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool)
    {
        require(spender != address(0), "Address zero");
        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].add(addedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool)
    {
        require(spender != address(0), "Address zero");
        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].sub(subtractedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(amount != 0, "Amount must be > 0");
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(amount != 0, "Amount must be > 0");
        require(amount <= _balances[account], "Insufficient");
        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function burnFrom(address account, uint256 amount) external {
        require(amount <= _allowed[account][msg.sender], "Increase allowance");
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
            amount
        );
        _burn(account, amount);
    }

    /* Restricted functions */
    function updateBurnRate(uint8 bRate) external onlyOwner {
        burnRate = bRate;
    }

    function setRewardTimeHODLTime(uint256 _hodlTime) external onlyOwner {
        HODLTimeRewardable = _hodlTime;
    }

    function setMinMaxBalanceRewardable(uint256 _minR, uint256 _maxR)
        external
        onlyOwner
    {
        minimumBalance = _minR;
        maxRewardable = _maxR;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    function exclude(address[] calldata _excludes) external onlyOwner {
        for (uint8 i; i < _excludes.length; ++i) {
            isExcluded[_excludes[i]] = true;
        }
    }
}