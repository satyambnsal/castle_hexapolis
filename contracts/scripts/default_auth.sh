#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

# Check the script argument for the mode
mode=${1:-dev} # default to 'dev' if no argument is provided

# Use different manifest file based on the mode
if [ "$mode" = "release" ]; then
    manifest_file="./target/release/manifest.json"
    export RPC_URL="https://api.cartridge.gg/x/castle-hexapolis/katana"
else
    manifest_file="./target/dev/manifest.json"
    export RPC_URL="http://localhost:5050"
fi

export WORLD_ADDRESS=$(cat $manifest_file | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat $manifest_file | jq -r '.contracts[] | select(.name == "castle_hexapolis::actions::actions" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("Tile" "PlayerId" "PlayerAddress" "Score" "RemainingMoves" "GameData")

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
done

echo "Default authorizations have been successfully set."

# sozo auth writer Tile 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
# sozo auth writer PlayerId 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
# sozo auth writer GameData 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
# sozo auth writer PlayerAddress 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
# sozo auth writer Score 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
# sozo auth writer RemainingMoves 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 --world 0xb18e8ef76b6739c501ccb7be5121704babacc68976b4b07789e3a366e68b15
