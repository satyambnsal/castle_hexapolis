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

    const place_tile = async (props: PlaceTileSystemProps) => {
        const { signer, tiles } = props;
        const [tile1, tile2, tile3] = tiles;
        console.log("Tile 1", tile1, signer);
        // // get player ID
        const playerEntityId = getEntityIdFromKeys([
            BigInt(signer.address),
        ]) as Entity;

        // // get the RPS ID associated with the PlayerID
        const player_id = getComponentValue(
            PlayerId,
            playerEntityId
        )?.player_id;

        try {
            const { transaction_hash } = await execute(
                signer,
                ACTIONS_PATH,
                "place_tile",
                [BigInt(tile1.row), BigInt(tile1.col), BigInt(tile1.tile_type)]
            );
            console.log({ transaction_hash });
            await new Promise((resolve) => setTimeout(resolve, 1000));
        } catch (err) {
            console.log("Failed to place tile", err);
        }

        console.log({ playerEntityId, player_id });
        // // get the RPS entity
        // const rpsEntity = getEntityIdFromKeys([
        //     BigInt(rpsId?.toString() || "0"),
        // ]);

        // // get the RPS position
        // const position = getComponentValue(Position, rpsEntity);

        // let currentEnergyAmt = getComponentValue(Energy, rpsEntity)?.amt || 0;

        // // update the position with the direction
        // const new_position = updatePositionWithDirection(
        //     direction,
        //     position || { x: 0, y: 0 }
        // );

        // // add an override to the position
        // const positionId = uuid();
        // Position.addOverride(positionId, {
        //     entity: rpsEntity,
        //     value: { id: rpsId, x: new_position.x, y: new_position.y },
        // });

        // // add an override to the energy
        // const energyId = uuid();
        // Energy.addOverride(energyId, {
        //     entity: rpsEntity,
        //     value: { id: rpsId, amt: currentEnergyAmt-- },
        // });

        // try {
        //     const { transaction_hash } = await execute(
        //         signer,
        //         ACTIONS_PATH,
        //         "move",
        //         [direction]
        //     );

        //     // logging the transaction hash
        //     // console.log(
        //     //     await signer.waitForTransaction(transaction_hash, {
        //     //         retryInterval: 100,
        //     //     })
        //     // );

        //     // just wait until indexer sync - currently ~1 second.
        //     // TODO: v0.4.0 will resolve to indexer
        //     await new Promise((resolve) => setTimeout(resolve, 1000));
        // } catch (e) {
        //     console.log(e);
        //     Position.removeOverride(positionId);
        //     Energy.removeOverride(energyId);
        // } finally {
        //     Position.removeOverride(positionId);
        //     Energy.removeOverride(energyId);
        // }
    };

    return {
        spawn,
        place_tile,
    };
}
