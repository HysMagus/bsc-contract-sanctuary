pragma solidity >=0.6.2;

contract Interaction {
    address vault;

    // function to set the vault address
    function setVaultAddr(address _vault) public {
        vault = _vault;
    }

    function deposit(uint _amount) public {
        // vault is the attribute that holds the address
        IVGatorVaultV6(vault).deposit(_amount);
    }

    function withdraw(uint256 _amount) external {
        IVGatorVaultV6(vault).withdraw(_amount);
    }
}

interface IVGatorVaultV6 {
    function deposit(uint _amount) external;
    function withdraw(uint256 _amount) external;
}