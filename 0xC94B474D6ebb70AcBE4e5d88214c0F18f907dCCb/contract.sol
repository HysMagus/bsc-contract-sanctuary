pragma solidity >=0.6.2;

contract Interaction {
    address vault;

    function setVaultAddr(address _vault) public {
        vault = _vault;
    }

    function deposit(uint _amount) public {
        return IVGatorVaultV6(vault).deposit(_amount);
    }

    function withdraw(uint256 _amount) external {
        return IVGatorVaultV6(vault).withdraw(_amount);
    }
}

interface IVGatorVaultV6 {
    function deposit(uint _amount) external;
    function withdraw(uint256 _amount) external;
}