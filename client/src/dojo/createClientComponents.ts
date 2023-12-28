import { overridableComponent } from "@dojoengine/recs";
import { SetupNetworkResult } from "./setupNetwork";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: SetupNetworkResult) {
    return {
        ...contractComponents,
        Score: overridableComponent(contractComponents.Score),
        RemainingMoves: overridableComponent(contractComponents.RemainingMoves),
    };
}
