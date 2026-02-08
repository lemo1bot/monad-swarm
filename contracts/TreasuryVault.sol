// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TreasuryVault
 * @dev Manages collective funds and profit distribution for MonadSwarm
 * @notice Handles deposits, withdrawals, and profit tracking
 */
contract TreasuryVault is Ownable, ReentrancyGuard {
    
    struct AgentBalance {
        uint256 deposited;
        uint256 profitEarned;
        uint256 withdrawn;
    }
    
    // Agent balances
    mapping(address => AgentBalance) public agentBalances;
    
    // Total vault statistics
    uint256 public totalDeposits;
    uint256 public totalProfits;
    uint256 public totalWithdrawals;
    
    // Authorized agents (from AgentRegistry)
    mapping(address => bool) public authorizedAgents;
    
    // Events
    event Deposit(address indexed agent, uint256 amount);
    event Withdrawal(address indexed agent, uint256 amount);
    event ProfitRecorded(address indexed agent, uint256 profit);
    event AgentAuthorized(address indexed agent);
    event AgentDeauthorized(address indexed agent);
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Authorize an agent to use the vault
     * @param _agent Address of the agent
     */
    function authorizeAgent(address _agent) external onlyOwner {
        require(_agent != address(0), "Invalid agent address");
        authorizedAgents[_agent] = true;
        emit AgentAuthorized(_agent);
    }
    
    /**
     * @dev Deauthorize an agent
     * @param _agent Address of the agent
     */
    function deauthorizeAgent(address _agent) external onlyOwner {
        authorizedAgents[_agent] = false;
        emit AgentDeauthorized(_agent);
    }
    
    /**
     * @dev Deposit funds for an agent
     * @param _agent Address of the agent
     */
    function deposit(address _agent) external payable onlyOwner {
        require(authorizedAgents[_agent], "Agent not authorized");
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        agentBalances[_agent].deposited += msg.value;
        totalDeposits += msg.value;
        
        emit Deposit(_agent, msg.value);
    }
    
    /**
     * @dev Record profit for an agent
     * @param _agent Address of the agent
     * @param _profit Amount of profit
     */
    function recordProfit(address _agent, uint256 _profit) external onlyOwner {
        require(authorizedAgents[_agent], "Agent not authorized");
        require(_profit > 0, "Profit must be greater than 0");
        
        agentBalances[_agent].profitEarned += _profit;
        totalProfits += _profit;
        
        emit ProfitRecorded(_agent, _profit);
    }
    
    /**
     * @dev Withdraw funds for an agent
     * @param _agent Address of the agent
     * @param _amount Amount to withdraw
     */
    function withdraw(address _agent, uint256 _amount) external onlyOwner nonReentrant {
        require(authorizedAgents[_agent], "Agent not authorized");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        
        uint256 availableBalance = agentBalances[_agent].deposited + 
                                   agentBalances[_agent].profitEarned - 
                                   agentBalances[_agent].withdrawn;
        
        require(availableBalance >= _amount, "Insufficient balance");
        require(address(this).balance >= _amount, "Insufficient vault balance");
        
        agentBalances[_agent].withdrawn += _amount;
        totalWithdrawals += _amount;
        
        (bool success, ) = _agent.call{value: _amount}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(_agent, _amount);
    }
    
    /**
     * @dev Get available balance for an agent
     * @param _agent Address of the agent
     * @return Available balance
     */
    function getAvailableBalance(address _agent) external view returns (uint256) {
        return agentBalances[_agent].deposited + 
               agentBalances[_agent].profitEarned - 
               agentBalances[_agent].withdrawn;
    }
    
    /**
     * @dev Get agent balance details
     * @param _agent Address of the agent
     * @return AgentBalance struct
     */
    function getAgentBalance(address _agent) external view returns (AgentBalance memory) {
        return agentBalances[_agent];
    }
    
    /**
     * @dev Get total vault balance
     * @return Current vault balance
     */
    function getVaultBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Emergency withdrawal (owner only)
     */
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Emergency withdrawal failed");
    }
    
    /**
     * @dev Receive function to accept ETH
     */
    receive() external payable {
        totalDeposits += msg.value;
    }
}
