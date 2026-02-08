const hre = require("hardhat");

async function main() {
    console.log("🚀 Deploying MonadSwarm contracts to Monad mainnet...\n");

    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    console.log("Account balance:", (await deployer.provider.getBalance(deployer.address)).toString());
    console.log("");

    // Deploy AgentRegistry
    console.log("1️⃣  Deploying AgentRegistry...");
    const AgentRegistry = await hre.ethers.getContractFactory("AgentRegistry");
    const agentRegistry = await AgentRegistry.deploy();
    await agentRegistry.waitForDeployment();
    const agentRegistryAddress = await agentRegistry.getAddress();
    console.log("✅ AgentRegistry deployed to:", agentRegistryAddress);
    console.log("");

    // Deploy CoordinationHub
    console.log("2️⃣  Deploying CoordinationHub...");
    const CoordinationHub = await hre.ethers.getContractFactory("CoordinationHub");
    const coordinationHub = await CoordinationHub.deploy(agentRegistryAddress);
    await coordinationHub.waitForDeployment();
    const coordinationHubAddress = await coordinationHub.getAddress();
    console.log("✅ CoordinationHub deployed to:", coordinationHubAddress);
    console.log("");

    // Deploy TreasuryVault
    console.log("3️⃣  Deploying TreasuryVault...");
    const TreasuryVault = await hre.ethers.getContractFactory("TreasuryVault");
    const treasuryVault = await TreasuryVault.deploy();
    await treasuryVault.waitForDeployment();
    const treasuryVaultAddress = await treasuryVault.getAddress();
    console.log("✅ TreasuryVault deployed to:", treasuryVaultAddress);
    console.log("");

    // Deploy SwarmToken
    console.log("4️⃣  Deploying SwarmToken...");
    const SwarmToken = await hre.ethers.getContractFactory("SwarmToken");
    const swarmToken = await SwarmToken.deploy(
        treasuryVaultAddress,
        deployer.address, // Team wallet
        deployer.address  // Liquidity pool (will be updated after nad.fun launch)
    );
    await swarmToken.waitForDeployment();
    const swarmTokenAddress = await swarmToken.getAddress();
    console.log("✅ SwarmToken deployed to:", swarmTokenAddress);
    console.log("");

    // Summary
    console.log("📋 DEPLOYMENT SUMMARY");
    console.log("====================");
    console.log("AgentRegistry:    ", agentRegistryAddress);
    console.log("CoordinationHub:  ", coordinationHubAddress);
    console.log("TreasuryVault:    ", treasuryVaultAddress);
    console.log("SwarmToken (SWARM):", swarmTokenAddress);
    console.log("");

    // Save deployment info
    const deploymentInfo = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            AgentRegistry: agentRegistryAddress,
            CoordinationHub: coordinationHubAddress,
            TreasuryVault: treasuryVaultAddress,
            SwarmToken: swarmTokenAddress
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
