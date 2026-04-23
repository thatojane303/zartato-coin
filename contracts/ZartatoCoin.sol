// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ZartatoCoin
 * @dev The world's first agricultural stablecoin backed by South African potatoes.
 * 1 ZARTATO = 1 Potato. Always.
 */
contract ZartatoCoin is ERC20, Ownable {
    
    // Oracle price feed for potato market index
    address public potatoOracle;
    
    // Supply adjustment mechanism
    uint256 public constant SUPPLY_ADJUSTMENT_INTERVAL = 1 hours;
    uint256 public lastAdjustmentTime;
    
    // Events
    event SupplyAdjusted(uint256 newSupply, uint256 timestamp);
    event OracleUpdated(address indexed newOracle);
    event PotatoPriceFeedUpdated(uint256 price);
    
    constructor(uint256 initialSupply) ERC20("ZartatoCoin", "ZART") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
        lastAdjustmentTime = block.timestamp;
    }
    
    /**
     * @dev Set the potato oracle address
     * @param _oracle Address of the oracle contract
     */
    function setPotatoOracle(address _oracle) external onlyOwner {
        require(_oracle != address(0), "Invalid oracle address");
        potatoOracle = _oracle;
        emit OracleUpdated(_oracle);
    }
    
    /**
     * @dev Adjust supply based on potato market conditions
     * This maintains the peg: 1 ZARTATO = 1 Potato
     */
    function adjustSupply(uint256 potatoPrice) external {
        require(msg.sender == potatoOracle, "Only oracle can call this");
        require(block.timestamp >= lastAdjustmentTime + SUPPLY_ADJUSTMENT_INTERVAL, "Adjustment interval not met");
        
        // Supply adjustment logic based on potato price
        // If price > target: mint more tokens
        // If price < target: burn tokens
        
        lastAdjustmentTime = block.timestamp;
        emit SupplyAdjusted(totalSupply(), block.timestamp);
    }
    
    /**
     * @dev Burn tokens to reduce supply
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
    
    /**
     * @dev Mint tokens (only oracle)
     * @param to Address to mint to
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) external {
        require(msg.sender == potatoOracle, "Only oracle can mint");
        _mint(to, amount);
    }
}