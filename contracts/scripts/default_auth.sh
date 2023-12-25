#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

# Check the script argument for the mode
mode=${1:-dev} # default to 'dev' if no argument is provided

# Use different manifest file based on the mode
if [ "$mode" = "release" ]; then
    manifest_file="./target/release/manifest.json"
    export RPC_URL="https://api.cartridge.gg/x/emoji-man-demo/katana";
else
    manifest_file="./target/dev/manifest.json"
    export RPC_URL="http://localhost:5050";
fi

export WORLD_ADDRESS=$(cat $manifest_file | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat $manifest_file | jq -r '.contracts[] | select(.name == "castle_hexapolis::actions::actions" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("Position" "MovesQueue" "RPSType" "GameData" "PlayerID" "Energy" "PlayerAddress" "PlayerAtPosition" )

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
done

echo "Default authorizations have been successfully set."


# sozo auth writer MovesQueue 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer RpsType 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer GameData 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer PlayerID 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer Energy 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer PlayerAddress 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93
# sozo auth writer PlayerAttPosition 0x19ec38d1ab2e9a808b226247a4cc00ba555c22e92c50e918798dc08832dff62 --world 0x4c8f99c6a9b022822bc7879c815e39272d216a3cd9fa75676fa6238ebe2ee93