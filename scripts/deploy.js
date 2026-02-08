const hre = require("hardhat");

async function main() {
    console.log("🚀 Deploying MonadSwarm contracts to Monad mainnet...\n");

    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    console.log("");

    // Deploy AgentRegistry
    console.log("1️⃣  Deploying AgentRegistry...");
    const AgentRegistry = await hre.ethers.getContractFactory("AgentRegistry");
    const agentRegistry = await AgentRegistry.deploy();
    await agentRegistry.deployed();
    console.log("✅ AgentRegistry deployed to:", agentRegistry.address);
    console.log("");

    // Deploy CoordinationHub
    console.log("2️⃣  Deploying CoordinationHub...");
    const CoordinationHub = await hre.ethers.getContractFactory("CoordinationHub");
    const coordinationHub = await CoordinationHub.deploy(agentRegistry.address);
    await coordinationHub.deployed();
    console.log("✅ CoordinationHub deployed to:", coordinationHub.address);
    console.log("");

    // Deploy TreasuryVault
    console.log("3️⃣  Deploying TreasuryVault...");
    const TreasuryVault = await hre.ethers.getContractFactory("TreasuryVault");
    const treasuryVault = await TreasuryVault.deploy();
    await treasuryVault.deployed();
    console.log("✅ TreasuryVault deployed to:", treasuryVault.address);
    console.log("");

    // Deploy SwarmToken
    console.log("4️⃣  Deploying SwarmToken...");
    const SwarmToken = await hre.ethers.getContractFactory("SwarmToken");
    const swarmToken = await SwarmToken.deploy(
        treasuryVault.address,
        deployer.address, // Team wallet
        deployer.address  // Liquidity pool (will be updated after nad.fun launch)
    );
    await swarmToken.deployed();
    console.log("✅ SwarmToken deployed to:", swarmToken.address);
    console.log("");

    // Summary
    console.log("📋 DEPLOYMENT SUMMARY");
    console.log("====================");
    console.log("AgentRegistry:    ", agentRegistry.address);
    console.log("CoordinationHub:  ", coordinationHub.address);
    console.log("TreasuryVault:    ", treasuryVault.address);
    console.log("SwarmToken (SWARM):", swarmToken.address);
    console.log("");

    // Save deployment info
    const deploymentInfo = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            AgentRegistry: agentRegistry.address,
            CoordinationHub: coordinationHub.address,
            TreasuryVault: treasuryVault.address,
            SwarmToken: swarmToken.address
        }
    };

    const fs = require("fs");
    fs.writeFileSync(
        "deployment-info.json",
        JSON.stringify(deploymentInfo, null, 2)
    );
    console.log("💾 Deployment info saved to deployment-info.json");
    console.log("");

    console.log("🎉 All contracts deployed successfully!");
    console.log("");
    console.log("📝 Next steps:");
    console.log("1. Verify contracts on Monad block explorer");
    console.log("2. Launch SWARM token on nad.fun");
    console.log("3. Register agents in AgentRegistry");
    console.log("4. Start agent runtime");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
