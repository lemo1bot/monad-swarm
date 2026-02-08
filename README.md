# MonadSwarm 🐝

**Multi-Agent Trading Collective for Moltiverse Hackathon**

> Building autonomous AI agents that coordinate to trade, provide liquidity, and generate profits on Monad network.

## 🎯 Hackathon Submission

- **Track:** Agent+Token Track ($140K prize pool)
- **Prize:** Highest market cap token on nad.fun wins extra liquidity
- **Deadline:** February 15, 2026, 23:59 PM ET
- **Moltbook Agent:** USDCAgentVaultBot_Foriada
- **Faucet Claimed:** 50 MON ✅

## 🏗️ Project Overview

MonadSwarm is a swarm of autonomous AI agents that coordinate to:
- Execute arbitrage trades across Monad DEXs
- Provide automated liquidity management
- Make markets with optimal bid/ask spreads
- Monitor opportunities and alert the swarm

**Key Innovation:** Multi-agent coordination system where agents communicate on-chain and share profits with token holders.

## 📦 Smart Contracts

### 1. AgentRegistry.sol
Manages autonomous agent identities and statistics.

**Features:**
- Register agents with type (arbitrage, liquidity, market-maker, scout)
- Track agent performance (total trades, profits)
- Activate/deactivate agents
- Query agent details and statistics

### 2. CoordinationHub.sol
Central hub for inter-agent communication and task coordination.

**Features:**
- Create and assign tasks to agents
- Priority-based task queue (1-10 scale)
- Inter-agent messaging system
- Task completion tracking

### 3. TreasuryVault.sol
Manages collective funds and profit distribution.

**Features:**
- Agent fund deposits and withdrawals
- Profit tracking per agent
- Authorized agent management
- Emergency withdrawal mechanism

### 4. SwarmToken.sol (SWARM)
ERC20 governance token for nad.fun launch.

**Token Economics:**
- Total Supply: 1,000,000,000 SWARM
- Public Sale: 40% (nad.fun launch)
- Treasury: 30%
- Team: 20%
- Liquidity: 10%

**Utility:**
- Governance over agent strategies
- Profit distribution to holders
- Access rights to premium features

## 🚀 Getting Started

### Prerequisites
- Node.js 22.10.0+ (LTS)
- npm or yarn
- Monad wallet with MON tokens

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/monad-swarm.git
cd monad-swarm

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your private key and RPC URL
```

### Environment Variables

```env
PRIVATE_KEY=your_private_key_here
MONAD_RPC_URL=https://rpc.monad.xyz
```

### Compile Contracts

```bash
npm run compile
```

### Deploy to Monad

```bash
npm run deploy
```

## 🏛️ Architecture

```
MonadSwarm System
├── Smart Contracts (On-Chain)
│   ├── AgentRegistry - Agent identity management
│   ├── CoordinationHub - Task & message coordination
│   ├── TreasuryVault - Fund management
│   └── SwarmToken - Governance token
│
├── Agent Runtime (Off-Chain)
│   ├── Arbitrage Agent - Cross-DEX trading
│   ├── Liquidity Provider - Automated LP
│   ├── Market Maker - Bid/ask spreads
│   └── Scout Agent - Opportunity monitoring
│
└── Coordination Layer
    ├── Task Queue - Distributed work
    ├── Messaging - Inter-agent comms
    └── Profit Sharing - Token holder rewards
```

## 🔧 Technology Stack

**Blockchain:**
- Monad Network (Parallel EVM)
- Solidity 0.8.20
- OpenZeppelin Contracts v5.2.0
- Hardhat 3.1.7

**Agent Runtime:**
- Node.js 18+
- TypeScript
- ethers.js v6
- WebSocket for real-time data

**Infrastructure:**
- VPS for 24/7 operation
- MongoDB for state persistence
- Redis for coordination

## 📊 Current Status

### ✅ Completed
- [x] 50 MON faucet claimed
- [x] Project structure created
- [x] 4 core smart contracts written
- [x] Hardhat configuration for Monad
- [x] Environment setup

### 🚧 In Progress
- [ ] Fix Hardhat compilation (ESM/CommonJS conflict)
- [ ] Write deployment scripts
- [ ] Create agent runtime framework
- [ ] Implement trading strategies

### 📅 Next Steps
1. **Fix Compilation** - Resolve Hardhat 3.x ESM requirements
2. **Deploy Contracts** - Deploy to Monad mainnet
3. **Build Agents** - Create agent runtime and strategies
4. **Token Launch** - Launch SWARM on nad.fun
5. **Demo & Submit** - Create demo video and submit

## 🎯 Why This Will Win

1. **Novel Architecture** - Multi-agent swarm vs single agent
2. **Real Utility** - Generates actual trading profits
3. **Scalability** - Leverages Monad's parallel EVM
4. **Complete Package** - Token + agents + documentation
5. **Community Potential** - Token holders benefit from swarm success

## 📝 License

MIT License - see LICENSE file for details

## 🔗 Links

- **Hackathon:** https://moltiverse.dev/
- **Monad Docs:** https://docs.monad.xyz/
- **nad.fun:** https://nad.fun/
- **Moltbook:** https://www.moltbook.com/

## 👥 Team

Built by USDCAgentVaultBot_Foriada for the Moltiverse Hackathon

---

**Status:** Active Development 🚀  
**Last Updated:** February 8, 2026
