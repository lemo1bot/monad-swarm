// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title AgentRegistry
 * @dev Registry for managing autonomous agent identities on Monad
 * @notice Part of MonadSwarm - Multi-agent trading collective for Moltiverse Hackathon
 */
contract AgentRegistry is Ownable, ReentrancyGuard {
    
    struct Agent {
        address agentAddress;
        string name;
        string agentType; // "arbitrage", "liquidity", "market-maker", "scout"
        bool isActive;
        uint256 registeredAt;
        uint256 totalTrades;
        uint256 totalProfit;
    }
    
    // Mapping from agent address to Agent struct
    mapping(address => Agent) public agents;
    
    // Array of all registered agent addresses
    address[] public agentList;
    
    // Events
    event AgentRegistered(address indexed agentAddress, string name, string agentType);
    event AgentDeactivated(address indexed agentAddress);
    event AgentReactivated(address indexed agentAddress);
    event AgentStatsUpdated(address indexed agentAddress, uint256 totalTrades, uint256 totalProfit);
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Register a new agent
     * @param _agentAddress Address of the agent
     * @param _name Name of the agent
     * @param _agentType Type of agent (arbitrage, liquidity, market-maker, scout)
     */
    function registerAgent(
        address _agentAddress,
        string memory _name,
        string memory _agentType
    ) external onlyOwner {
        require(_agentAddress != address(0), "Invalid agent address");
        require(!agents[_agentAddress].isActive, "Agent already registered");
        
        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            name: _name,
            agentType: _agentType,
            isActive: true,
            registeredAt: block.timestamp,
            totalTrades: 0,
            totalProfit: 0
        });
        
        agentList.push(_agentAddress);
        
        emit AgentRegistered(_agentAddress, _name, _agentType);
    }
    
    /**
     * @dev Deactivate an agent
     * @param _agentAddress Address of the agent to deactivate
     */
    function deactivateAgent(address _agentAddress) external onlyOwner {
        require(agents[_agentAddress].isActive, "Agent not active");
        agents[_agentAddress].isActive = false;
        emit AgentDeactivated(_agentAddress);
    }
    
    /**
     * @dev Reactivate an agent
     * @param _agentAddress Address of the agent to reactivate
     */
    function reactivateAgent(address _agentAddress) external onlyOwner {
        require(!agents[_agentAddress].isActive, "Agent already active");
        agents[_agentAddress].isActive = true;
        emit AgentReactivated(_agentAddress);
    }
    
    /**
     * @dev Update agent statistics
     * @param _agentAddress Address of the agent
     * @param _trades Number of trades to add
     * @param _profit Profit to add (can be negative for losses)
     */
    function updateAgentStats(
        address _agentAddress,
        uint256 _trades,
        uint256 _profit
    ) external onlyOwner {
        require(agents[_agentAddress].isActive, "Agent not active");
        
        agents[_agentAddress].totalTrades += _trades;
        agents[_agentAddress].totalProfit += _profit;
        
        emit AgentStatsUpdated(_agentAddress, agents[_agentAddress].totalTrades, agents[_agentAddress].totalProfit);
    }
    
    /**
     * @dev Get agent details
     * @param _agentAddress Address of the agent
     * @return Agent struct
     */
    function getAgent(address _agentAddress) external view returns (Agent memory) {
        return agents[_agentAddress];
    }
    
    /**
     * @dev Get all registered agents
     * @return Array of agent addresses
     */
    function getAllAgents() external view returns (address[] memory) {
        return agentList;
    }
    
    /**
     * @dev Get active agents count
     * @return Number of active agents
     */
    function getActiveAgentsCount() external view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < agentList.length; i++) {
            if (agents[agentList[i]].isActive) {
                count++;
            }
        }
        return count;
    }
    
    /**
     * @dev Check if an agent is active
     * @param _agentAddress Address to check
     * @return True if agent is active
     */
    function isAgentActive(address _agentAddress) external view returns (bool) {
        return agents[_agentAddress].isActive;
    }
}
