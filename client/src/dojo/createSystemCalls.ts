import { SetupNetworkResult } from "./setupNetwork";
import { ClientComponents } from "./createClientComponents";
import { PlaceTileSystemProps, SystemSigner } from "./types";
import { uuid } from "@latticexyz/utils";
import { Entity, getComponentValue } from "@dojoengine/recs";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { cairo } from "starknet";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

const ACTIONS_PATH = "castle_hexapolis::actions::actions";

export function createSystemCalls(
    { execute }: SetupNetworkResult,
    { Score, PlayerId, RemainingMoves, Tile }: ClientComponents
) {
    const spawn = async (props: SystemSigner) => {
        try {
            await execute(props.signer, ACTIONS_PATH, "spawn", []);
        } catch (e) {
            console.error(e);
        }
    };

    const fetch_score_and_remaining_moves = (props: SystemSigner) => {
        const playerAddressEntity = getEntityIdFromKeys([
            BigInt(props.signer.address),
        ]) as Entity;
        const player_id = getComponentValue(
            PlayerId,
            playerAddressEntity
        )?.player_id;

        const playerIdEntity = getEntityIdFromKeys([
            BigInt(player_id?.toString() || "0"),
        ]);

        const score = getComponentValue(Score, playerIdEntity)?.score;
        const remaining_moves = getComponentValue(
            RemainingMoves,
            playerIdEntity
        )?.moves;
        return { score, remaining_moves };
    };

    const place_tile = async (props: PlaceTileSystemProps) => {
        const { signer, tiles } = props;
        const calldata: bigint[] = [];
        tiles.forEach(({ row, col, tile_type }) => {
            calldata.push(BigInt(row));
            calldata.push(BigInt(col));
            calldata.push(BigInt(tile_type));
        });
        console.log("place tile calldata", calldata);

        try {
            const { transaction_hash } = await execute(
                signer,
                ACTIONS_PATH,
                "place_tile",
                [tiles.length, ...calldata]
            );
            console.log({ transaction_hash });
            await new Promise((resolve) => setTimeout(resolve, 3000));
        } catch (err) {
            console.log("Failed to place tile", err);
        }
    };

    return {
        spawn,
        place_tile,
        fetch_score_and_remaining_moves,
    };
}
