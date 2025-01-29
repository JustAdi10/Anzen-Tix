// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TestContract {
    uint256 private value;

    event ValueChanged(uint256 newValue);

    function setValue(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}
