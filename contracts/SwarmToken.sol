// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SwarmToken
 * @dev Governance token for MonadSwarm - to be launched on nad.fun
 * @notice Token holders govern agent strategies and receive profit distributions
 */
contract SwarmToken is ERC20, Ownable {
    
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens
    
    // Token distribution
    uint256 public constant PUBLIC_SALE_ALLOCATION = 400_000_000 * 10**18; // 40%
    uint256 public constant TREASURY_ALLOCATION = 300_000_000 * 10**18;    // 30%
    uint256 public constant TEAM_ALLOCATION = 200_000_000 * 10**18;        // 20%
    uint256 public constant LIQUIDITY_ALLOCATION = 100_000_000 * 10**18;   // 10%
    
    address public treasury;
    address public teamWallet;
    address public liquidityPool;
    
    bool public tradingEnabled;
    
    event TradingEnabled(uint256 timestamp);
    event ProfitDistributed(uint256 amount, uint256 timestamp);
    
    constructor(
        address _treasury,
        address _teamWallet,
        address _liquidityPool
    ) ERC20("MonadSwarm", "SWARM") Ownable(msg.sender) {
        require(_treasury != address(0), "Invalid treasury address");
        require(_teamWallet != address(0), "Invalid team wallet");
        require(_liquidityPool != address(0), "Invalid liquidity pool");
        
        treasury = _treasury;
        teamWallet = _teamWallet;
        liquidityPool = _liquidityPool;
        
        // Mint initial supply
        _mint(msg.sender, PUBLIC_SALE_ALLOCATION); // For nad.fun launch
        _mint(treasury, TREASURY_ALLOCATION);
        _mint(teamWallet, TEAM_ALLOCATION);
        _mint(liquidityPool, LIQUIDITY_ALLOCATION);
        
        tradingEnabled = false;
    }
    
    /**
     * @dev Enable trading (can only be called once)
     */
    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Trading already enabled");
        tradingEnabled = true;
        emit TradingEnabled(block.timestamp);
    }
    
    /**
     * @dev Override transfer to enforce trading restrictions
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        // Allow minting and owner transfers before trading is enabled
        if (!tradingEnabled) {
            require(
                from == address(0) || from == owner() || to == owner(),
                "Trading not yet enabled"
            );
        }
        
        super._update(from, to, value);
    }
    
    /**
     * @dev Distribute profits to token holders (simplified version)
     * @notice In production, this would use a more sophisticated profit distribution mechanism
     */
    function distributeProfits() external payable onlyOwner {
        require(msg.value > 0, "No profits to distribute");
        
        // Transfer profits to treasury for distribution
        (bool success, ) = treasury.call{value: msg.value}("");
        require(success, "Profit distribution failed");
        
        emit ProfitDistributed(msg.value, block.timestamp);
    }
    
    /**
     * @dev Update treasury address
     */
    function updateTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "Invalid treasury address");
        treasury = _newTreasury;
    }
    
    /**
     * @dev Burn tokens (for deflationary mechanism)
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
