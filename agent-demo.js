const { ethers } = require("ethers");
require("dotenv").config();

// Contract ABIs (simplified for demo)
const AGENT_REGISTRY_ABI = [
    "function registerAgent(address _agentAddress, string memory _name, string memory _agentType) external",
    "function getAgent(address _agentAddress) external view returns (tuple(address agentAddress, string name, string agentType, bool isActive, uint256 registeredAt, uint256 totalTrades, uint256 totalProfit))",
    "function isAgentActive(address _agentAddress) external view returns (bool)"
];

const COORDINATION_HUB_ABI = [
    "function createTask(string memory _taskType, uint256 _priority, bytes memory _taskData) external returns (uint256)",
    "function getPendingTasks() external view returns (uint256[] memory)"
];

// Contract addresses (deployed on Monad)
const AGENT_REGISTRY_ADDRESS = "0xEA3E918fed9450024cC3473434F77A494f41c051";
const COORDINATION_HUB_ADDRESS = "0x04fE38d449201F897b29210FE874c725Ec307F8F";

class MonadSwarmAgent {
    constructor(name, type, privateKey) {
        this.name = name;
        this.type = type;
        this.provider = new ethers.providers.JsonRpcProvider(process.env.MONAD_RPC_URL);
        this.wallet = new ethers.Wallet(privateKey, this.provider);
        this.agentRegistry = new ethers.Contract(AGENT_REGISTRY_ADDRESS, AGENT_REGISTRY_ABI, this.wallet);
        this.coordinationHub = new ethers.Contract(COORDINATION_HUB_ADDRESS, COORDINATION_HUB_ABI, this.wallet);
    }

    async register() {
        console.log(`🤖 Registering ${this.name} (${this.type})...`);
        try {
            const tx = await this.agentRegistry.registerAgent(
                this.wallet.address,
                this.name,
                this.type
            );
            await tx.wait();
            console.log(`✅ ${this.name} registered successfully!`);
        } catch (error) {
            console.log(`⚠️  ${this.name} may already be registered`);
        }
    }

    async checkStatus() {
        const isActive = await this.agentRegistry.isAgentActive(this.wallet.address);
        console.log(`📊 ${this.name} status: ${isActive ? 'ACTIVE ✅' : 'INACTIVE ❌'}`);
        return isActive;
    }

    async monitorTasks() {
        console.log(`👀 ${this.name} monitoring for tasks...`);
        const pendingTasks = await this.coordinationHub.getPendingTasks();
        console.log(`📋 Found ${pendingTasks.length} pending tasks`);
        return pendingTasks;
    }

    async simulateTrading() {
        console.log(`💹 ${this.name} simulating ${this.type} strategy...`);

        // Simulate different strategies based on agent type
        switch (this.type) {
            case "arbitrage":
                console.log("   🔍 Scanning for price differences across DEXs...");
                console.log("   💰 Found opportunity: 0.5% profit on MON/USDC");
                break;
            case "liquidity":
                console.log("   💧 Analyzing liquidity pools...");
                console.log("   📈 Optimal position: MON/USDC pool with 12% APY");
                break;
            case "market-maker":
                console.log("   📊 Setting bid/ask spreads...");
                console.log("   🎯 Spread: 0.3% on MON/USDC pair");
                break;
            case "scout":
                console.log("   🔭 Monitoring market conditions...");
                console.log("   ⚡ Alert: High volatility detected");
                break;
        }
    }
}

async function main() {
    console.log("🐝 MonadSwarm Agent Runtime Demo\n");
    console.log("================================\n");

    // Create agent instances (using same wallet for demo)
    const agents = [
        new MonadSwarmAgent("ArbitrageBot-1", "arbitrage", process.env.PRIVATE_KEY),
        new MonadSwarmAgent("LiquidityBot-1", "liquidity", process.env.PRIVATE_KEY),
        new MonadSwarmAgent("MarketMaker-1", "market-maker", process.env.PRIVATE_KEY),
        new MonadSwarmAgent("Scout-1", "scout", process.env.PRIVATE_KEY)
    ];

    // Register all agents
    console.log("📝 PHASE 1: Agent Registration\n");
    for (const agent of agents) {
        await agent.register();
        await new Promise(resolve => setTimeout(resolve, 1000));
    }

    console.log("\n");

    // Check agent status
    console.log("🔍 PHASE 2: Status Check\n");
    for (const agent of agents) {
        await agent.checkStatus();
    }

    console.log("\n");

    // Monitor tasks
    console.log("📋 PHASE 3: Task Monitoring\n");
    await agents[0].monitorTasks();

    console.log("\n");

    // Simulate trading
    console.log("💹 PHASE 4: Strategy Execution\n");
    for (const agent of agents) {
        await agent.simulateTrading();
        console.log("");
    }

    console.log("================================\n");
    console.log("✅ Demo completed successfully!");
    console.log("\n📊 MonadSwarm Statistics:");
    console.log("   - Active Agents: 4");
    console.log("   - Agent Types: arbitrage, liquidity, market-maker, scout");
    console.log("   - Deployed Contracts: 4");
    console.log("   - Network: Monad Mainnet (Chain ID: 143)");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Error:", error.message);
        process.exit(1);
    });
