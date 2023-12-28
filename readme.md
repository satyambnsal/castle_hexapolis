
# Castle Hexapolis

## Overview



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
slot deployments create emoji-man-demo katana

# Retrieve and save credentials
slot deployments logs emoji-man-demo katana -f

# Build and migrate releases
sozo --release build
sozo --release migrate

# Set up torii and connect to the world
slot deployments create emoji-man-demo torii --rpc https://api.cartridge.gg/x/emoji-man-demo/katana --world 0x1fad58d91d5d121aa6dc4d16c01a161e0441ef75fe7d31e3664a61e66022b1f --start-block 1

# Update authentication for the release
./scripts/default_auth.sh release
```

### Step 11:

Deploy to vercel.

## Next Steps

### Bonus 1: Add a collectables

- Add a way to spawn collectables on the map and allow players to collect them

### Bonus 2: Leaderboard

- Add UI in client to show total amount of killed types.




## Action Items

- [] Implement the randomness. it takes 3 values from this array [1,1,1,2,2,2,3,3,3]