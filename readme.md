
# Castle Hexapolis

## Overview

[View the Guide](/client/public/castle_hexapolis.pdf)



Deployed Katana Instance: https://api.cartridge.gg/x/castle-hexapolis/katana



## How to run client
We are going to use `bun` as a package manager. you can use `npm` or `yarn ` as well.

```
cd client
```

```
bun install
```

```
bun run dev
```




- a. Deployment processes and debugging techniques

### Step 9: Running the Client

Steps include:
-a. Launching the client

- b. Generating models via npm
- c. Understanding client architecture
- d. Learning about the `torii` client

### Step 10: Utilizing `slot` for Remote Deployments

Understand [slot](https://github.com/cartridge-gg/slot) and its applications. Install `slot` and log in with these commands:

```bash
curl -L https://slot.cartridge.sh | bash
slotup
slot auth login
# For old auth credentials debug:
rm ~/Library/Application\ Support/slot/credentials.json
```

Deployment steps:

```bash
# Create and manage deployments
slot deployments create castle-hexapolis katana

# Retrieve and save credentials
slot deployments logs castle-hexapolis katana -f

# Build and migrate releases
sozo --release build
sozo --release migrate

# Set up torii and connect to the world
slot deployments create castle-hexapolis torii --rpc https://api.cartridge.gg/x/castle-hexapolis/katana --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15 --start-block 1

# Update authentication for the release
./scripts/default_auth.sh release
```


```
Configuration:
  World: 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
  RPC: https://api.cartridge.gg/x/castle-hexapolis/katana
  Start Block: 1

Endpoints:
  GRAPHQL: https://api.cartridge.gg/x/castle-hexapolis/torii/graphql
  GRPC: https://api.cartridge.gg/x/castle-hexapolis/torii/grpc
```