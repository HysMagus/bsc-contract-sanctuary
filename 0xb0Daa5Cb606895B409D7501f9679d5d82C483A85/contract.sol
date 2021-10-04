pragma solidity >=0.6.2;

contract Interaction {
    address strategyCakeV2;

    function setStrategyCakeV2(address _str) public {
        strategyCakeV2 = _str;
    }

    function deposit() external payable {
        return IStrategyCakeV2(strategyCakeV2).deposit();
    }

    function withdraw(uint256 _amount) external payable {
        return IStrategyCakeV2(strategyCakeV2).withdraw(_amount);
    }
}

interface IStrategyCakeV2 {
    function deposit() external;

    function withdraw(uint256 _amount) external;
}