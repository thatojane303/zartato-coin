// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DroughtIndex
 * @dev Tracks the drought index which influences potato supply and ZARTATO peg
 * Higher drought = lower supply = higher price
 */
contract DroughtIndex is Ownable {
    
    // Drought index (0-100)
    uint256 public currentDroughtIndex;
    
    // Regional drought data
    mapping(string => uint256) public regionalDrought;
    
    // Historical data
    uint256[] public droughtHistory;
    
    // Events
    event DroughtIndexUpdated(uint256 newIndex, uint256 timestamp);
    event RegionalDroughtUpdated(string region, uint256 droughtLevel);
    
    constructor(uint256 initialDroughtIndex) {
        require(initialDroughtIndex <= 100, "Drought index must be between 0-100");
        currentDroughtIndex = initialDroughtIndex;
        droughtHistory.push(initialDroughtIndex);
    }
    
    /**
     * @dev Update the drought index
     * @param newIndex New drought index value (0-100)
     */
    function updateDroughtIndex(uint256 newIndex) external onlyOwner {
        require(newIndex <= 100, "Drought index must be between 0-100");
        currentDroughtIndex = newIndex;
        droughtHistory.push(newIndex);
        emit DroughtIndexUpdated(newIndex, block.timestamp);
    }
    
    /**
     * @dev Update regional drought data
     * @param region Name of the region
     * @param droughtLevel Drought level for that region
     */
    function updateRegionalDrought(string calldata region, uint256 droughtLevel) external onlyOwner {
        require(droughtLevel <= 100, "Drought level must be between 0-100");
        regionalDrought[region] = droughtLevel;
        emit RegionalDroughtUpdated(region, droughtLevel);
    }
    
    /**
     * @dev Get the current drought index
     */
    function getDroughtIndex() external view returns (uint256) {
        return currentDroughtIndex;
    }
    
    /**
     * @dev Get historical drought data
     */
    function getDroughtHistory() external view returns (uint256[] memory) {
        return droughtHistory;
    }
}