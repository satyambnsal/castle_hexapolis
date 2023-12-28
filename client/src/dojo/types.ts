import { Account } from "starknet";
// import {  } from "../phaser/config/constants";
import { TileType } from "./utils";

export interface SystemSigner {
    signer: Account;
}

export type Tile = {
    row: number;
    col: number;
    tile_type: TileType;
};
export interface PlaceTileSystemProps extends SystemSigner {
    tiles: Tile[];
}
