// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title CoordinationHub
 * @dev Central hub for inter-agent communication and task coordination
 * @notice Part of MonadSwarm - Multi-agent trading collective
 */
contract CoordinationHub is Ownable, ReentrancyGuard {
    
    struct Task {
        uint256 taskId;
        string taskType; // "arbitrage", "provide-liquidity", "market-make"
        address assignedAgent;
        uint256 priority; // 1-10, higher is more urgent
        uint256 createdAt;
        uint256 completedAt;
        bool isCompleted;
        bytes taskData; // Encoded task parameters
    }
    
    struct Message {
        uint256 messageId;
        address fromAgent;
        address toAgent;
        string messageType;
        bytes messageData;
        uint256 timestamp;
    }
    
    // Task storage
    mapping(uint256 => Task) public tasks;
    uint256 public taskCounter;
    uint256[] public pendingTasks;
    
    // Message storage
    mapping(uint256 => Message) public messages;
    uint256 public messageCounter;
    
    // Agent registry reference
    address public agentRegistry;
    
    // Events
    event TaskCreated(uint256 indexed taskId, string taskType, uint256 priority);
    event TaskAssigned(uint256 indexed taskId, address indexed agent);
    event TaskCompleted(uint256 indexed taskId, address indexed agent);
    event MessageSent(uint256 indexed messageId, address indexed from, address indexed to);
    
    constructor(address _agentRegistry) Ownable(msg.sender) {
        agentRegistry = _agentRegistry;
    }
    
    /**
     * @dev Create a new task
     * @param _taskType Type of task
     * @param _priority Priority level (1-10)
     * @param _taskData Encoded task parameters
     */
    function createTask(
        string memory _taskType,
        uint256 _priority,
        bytes memory _taskData
    ) external onlyOwner returns (uint256) {
        require(_priority >= 1 && _priority <= 10, "Invalid priority");
        
        taskCounter++;
        
        tasks[taskCounter] = Task({
            taskId: taskCounter,
            taskType: _taskType,
            assignedAgent: address(0),
            priority: _priority,
            createdAt: block.timestamp,
            completedAt: 0,
            isCompleted: false,
            taskData: _taskData
        });
        
        pendingTasks.push(taskCounter);
        
        emit TaskCreated(taskCounter, _taskType, _priority);
        return taskCounter;
    }
    
    /**
     * @dev Assign a task to an agent
     * @param _taskId ID of the task
     * @param _agent Address of the agent
     */
    function assignTask(uint256 _taskId, address _agent) external onlyOwner {
        require(tasks[_taskId].taskId != 0, "Task does not exist");
        require(!tasks[_taskId].isCompleted, "Task already completed");
        require(tasks[_taskId].assignedAgent == address(0), "Task already assigned");
        
        tasks[_taskId].assignedAgent = _agent;
        
        emit TaskAssigned(_taskId, _agent);
    }
    
    /**
     * @dev Mark a task as completed
     * @param _taskId ID of the task
     */
    function completeTask(uint256 _taskId) external onlyOwner {
        require(tasks[_taskId].taskId != 0, "Task does not exist");
        require(!tasks[_taskId].isCompleted, "Task already completed");
        require(tasks[_taskId].assignedAgent != address(0), "Task not assigned");
        
        tasks[_taskId].isCompleted = true;
        tasks[_taskId].completedAt = block.timestamp;
        
        // Remove from pending tasks
        _removePendingTask(_taskId);
        
        emit TaskCompleted(_taskId, tasks[_taskId].assignedAgent);
    }
    
    /**
     * @dev Send a message between agents
     * @param _from Sender agent address
     * @param _to Recipient agent address
     * @param _messageType Type of message
     * @param _messageData Encoded message data
     */
    function sendMessage(
        address _from,
        address _to,
        string memory _messageType,
        bytes memory _messageData
    ) external onlyOwner returns (uint256) {
        messageCounter++;
        
        messages[messageCounter] = Message({
            messageId: messageCounter,
            fromAgent: _from,
            toAgent: _to,
            messageType: _messageType,
            messageData: _messageData,
            timestamp: block.timestamp
        });
        
        emit MessageSent(messageCounter, _from, _to);
        return messageCounter;
    }
    
    /**
     * @dev Get pending tasks sorted by priority
     * @return Array of pending task IDs
     */
    function getPendingTasks() external view returns (uint256[] memory) {
        return pendingTasks;
    }
    
    /**
     * @dev Get task details
     * @param _taskId ID of the task
     * @return Task struct
     */
    function getTask(uint256 _taskId) external view returns (Task memory) {
        return tasks[_taskId];
    }
    
    /**
     * @dev Get message details
     * @param _messageId ID of the message
     * @return Message struct
     */
    function getMessage(uint256 _messageId) external view returns (Message memory) {
        return messages[_messageId];
    }
    
    /**
     * @dev Internal function to remove a task from pending list
     * @param _taskId ID of the task to remove
     */
    function _removePendingTask(uint256 _taskId) internal {
        for (uint256 i = 0; i < pendingTasks.length; i++) {
            if (pendingTasks[i] == _taskId) {
                pendingTasks[i] = pendingTasks[pendingTasks.length - 1];
                pendingTasks.pop();
                break;
            }
        }
    }
}
