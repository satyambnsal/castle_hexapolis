
# Realms.World : Castle Hexapolis
A Strategic City-Development Game

<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/f6d2e0c0-424a-4e00-a39b-e9790bca71cf" width = "270" height = "220">

## Overview
[View the Guide](/client/public/castle_hexapolis.pdf)


**Welcome, esteemed city planners and strategists!**

You have been summoned by the Lord of the Realm to the grand challenge of "Castle Hexapolis", the digital realm where your urban planning skills and tactical acumen will be put to the test! This web-based browser game blends the charm of medieval city-building with the cerebral challenge of hexagonal tile placement. Prepare to embark on a journey of strategy, foresight, and creativity as you expand your city from a single Castle hex tile to a sprawling, interconnected metropolis.

**Game Objective**

Your mission in "Castle Hexapolis" is straightforward yet captivating: skilfully expand your city outward from the central Castle tile, utilising a variety of hex tiles to maximize your points. With ROADS, WATCH TOWERS, and PARKS hex tiles at your disposal, every decision can tilt the balance of power in this dynamic cityscape.

**Core Game Elements**


<table style="width: 579px;" >
<tbody>
<tr style="height: 65px;">
<td style="width: 88.3393px; height: 65px;">&nbsp;<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/ed2fd1d5-f4d6-466f-9f33-9bfcdd2a976c" width="100" height="100"></td>
<td style="width: 489.661px; height: 65px;">&nbsp;
<p>The CASTLE : Your starting point and the heart of your city. All roads lead here!</p>
</td>
</tr>
<tr style="height: 87.8571px;">
<td style="width: 88.3393px; height: 87.8571px;">&nbsp;<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/66e700cf-43e6-4372-8696-d0de8e929a08" width="100" height="100"></td>
<td style="width: 489.661px; height: 87.8571px;">&nbsp;
<p>CITY WALL GATES: The gateways to the outside world. Connecting these to your Castle via roads is a key to victory.</p>
</td>
</tr>
</tbody>
</table>
<!-- DivTable.com -->



GAME TILES:

<table style="width: 515px;">
<tbody>
<tr style="height: 51.8571px;">
<td style="width: 59px; height: 51.8571px;">&nbsp;
<p>ROAD</p>
</td>
<td style="width: 120.8036px; height: 51.8571px;"><img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/53cc9a1e-4cc7-4a5c-b4eb-c245a50388ac" width="100" height="100"></td>
<td style="width: 354.196px; height: 51.8571px;">
<p>&nbsp;</p>
<p>Connect these to your Castle and city-wall gates for essential points.</p>
<p>&nbsp;</p>
</td>
</tr>
<tr style="height: 31px;">
<td style="width: 59px; height: 31px;">&nbsp;
<p>WATCH TOWER</p>
</td>
<td style="width: 120.8036px; height: 31px;">&nbsp;<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/3c67d8ad-77ce-493d-bf95-b553f4a4d38c" width="100" height="100"></td>
<td style="width: 354.196px; height: 31px;">
<p>&nbsp;</p>
<p>Strategically place these for defence and bonus points, especially on hill tiles</p>
<p>&nbsp;</p>
</td>
</tr>
<tr style="height: 31px;">
<td style="width: 59px; height: 31px;">&nbsp;PARK</td>
<td style="width: 120.8036px; height: 31px;">&nbsp;<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/401af068-ee5e-4fef-9ec2-24781f25330d" width="100" height="100"></td>
<td style="width: 354.196px; height: 31px;">&nbsp;
<p>Group these in threes to create lush parks and score big</p>
<p>&nbsp;</p>
</td>
</tr>
</tbody>
</table>
<!-- DivTable.com -->


**Gameplay Mechanics**

Each turn, you place a trio of hex tiles, carefully considering their placement in relation to your existing structures. With 24 trio tiles in the game, each decision is crucial in sculpting your city's landscape and securing your triumph.

**Scoring System**

Place trios of hexes to grow your city outward from the CASTLE.
Try to get the highest score you can!

<img src="https://github.com/satyambnsal/castle-hexapolis/assets/106560290/5a3e0b12-c8d3-4b1f-a440-72c393a3899e" width="300" height="300">

**ROADS:**

+1 points if connected to CASTLE by other ROADS

+3 points per CITY WALL GATE connected to the CASTLE by ROADS

**WATCH TOWER:**

+1 point if not touching another WATCH TOWER

+2 points if also on a hill

**PARK:**

+5 points for every 3 PARKS in a connected group

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
