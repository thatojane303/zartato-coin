// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PotatoOracle {
    // State variable to store the potato price
    uint256 public potatoPrice;

    // Event to emit when the potato price is updated
    event PotatoPriceUpdated(uint256 newPrice);

    // Function to update the price of potatoes
    function updatePotatoPrice(uint256 newPrice) public {
        potatoPrice = newPrice;
        emit PotatoPriceUpdated(newPrice);
    }

    // Function to get the current potato price
    function getPotatoPrice() public view returns (uint256) {
        return potatoPrice;
    }
}