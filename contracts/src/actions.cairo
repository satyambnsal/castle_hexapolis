//---------------------------------------------------------------------------------------------
// *Actions Contract*
// This contract handles all the actions that can be performed by the user
//---------------------------------------------------------------------------------------------

#[dojo::contract]
mod actions {
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use core::traits::Into;
    use starknet::{ContractAddress, get_caller_address};
    use debug::PrintTrait;
    use castle_hexapolis::interface::IActions;

    // import models
    use castle_hexapolis::models::{
        GAME_DATA_KEY, TileType, Tile, GameData, Score, RemainingMoves, PlayerAddress, PlayerID,
        Direction
    };

    // import config
    use castle_hexapolis::config::{GRID_SIZE, REMAINING_MOVES_DEFAULT};

    // import integer
    use integer::{u128s_from_felt252, U128sFromFelt252Result, u128_safe_divmod};

    // resource of world
    const DOJO_WORLD_RESOURCE: felt252 = 0;

    // ---------------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------------
    // --------- EXTERNALS -------------------------------------------------------------------------
    // These functions are called by the user and are exposed to the public
    // ---------------------------------------------------------------------------------------------

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(self: @ContractState) {
            let world = self.world_dispatcher.read();
            let player_address = get_caller_address();

            let mut game_data = get!(world, GAME_DATA_KEY, (GameData));

            // increment player count
            game_data.number_of_players += 1;

            // NOTE: save game_data model with the set! macro
            set!(world, (game_data));

            let player_id = assign_player_id(world, game_data.number_of_players, player_address);

            assign_score(world, player_id, 0);
            assign_remaining_moves(world, player_id, REMAINING_MOVES_DEFAULT);

            place_default_tiles(world, player_id);
        }

        fn place_tile(self: @ContractState, tile1: (u8, u8, TileType)) {
            let world = self.world_dispatcher.read();

            let player_address = get_caller_address();
            // Get player ID
            let player_id = get!(world, player_address, (PlayerID)).player_id;

            assert(player_id > 0, 'player does not exist');

            let mut remaining_moves = get!(world, player_id, (RemainingMoves)).moves;
            assert(remaining_moves > 0, 'no moves left');
            let (row_1, col_1, tile_type_1) = tile1;

            // tile type validation
            assert(
                tile_type_1 == TileType::Grass
                    || tile_type_1 == TileType::Street
                    || tile_type_1 == TileType::WindMill,
                'invalid tile type'
            );

            // check if tile coordinates are within map boundry
            assert(is_tile_in_boundry(row_1, col_1), 'invalid tile position');

            // check if tile is already occupied
            assert(!is_tile_occupied(world, row_1, col_1, player_id), 'tile is already occupied');

            // check if neighbour tile is settled
            let mut new_tile = Tile {
                row: row_1,
                col: col_1,
                player_id,
                tile_type: tile_type_1,
                counted: false,
                is_hill: false
            };
            assert(is_neighbor_settled(world, new_tile), 'neighbour is not settled')
        }

        // ----- ADMIN FUNCTIONS -----
        // These functions are only callable by the owner of the world
        fn cleanup(self: @ContractState) {}
    }

    // ---------------------------------------------------------------------------------------------
    // ---------------------------------------------------------------------------------------------
    // --------- INTERNALS -------------------------------------------------------------------------
    // These functions are called by the contract and are not exposed to the public
    // ---------------------------------------------------------------------------------------------

    // @dev: 
    // 1. Assigns player id
    // 2. Sets player address
    // 3. Sets player id
    fn assign_player_id(
        world: IWorldDispatcher, num_players: u128, player_address: ContractAddress
    ) -> u128 {
        let player_id: u128 = num_players;
        set!(
            world,
            (PlayerID { player_address, player_id }, PlayerAddress { player_address, player_id })
        );
        player_id
    }

    fn assign_score(world: IWorldDispatcher, player_id: u128, score: u8) {
        set!(world, (Score { player_id, score }))
    }

    fn assign_remaining_moves(world: IWorldDispatcher, player_id: u128, moves: u8) {
        set!(world, (RemainingMoves { player_id, moves }));
    }


    // @dev: Returns player id at tile
    // fn player_at_tile(world: IWorldDispatcher, x: u8, y: u8) -> u128 {
    //     get!(world, (x, y), (Tile)).player_id
    // }

    // @dev: Sets player score and remaining moves
    fn player_score_and_remaining_moves(
        world: IWorldDispatcher, player_id: u128, score: u8, moves: u8
    ) {
        set!(world, (Score { player_id, score }, RemainingMoves { player_id, moves }));
    }

    fn is_tile_in_boundry(row: u8, col: u8) -> bool {
        (row >= 0 && row <= 2 * GRID_SIZE + 1) && (col >= 0 && col <= 2 * GRID_SIZE + 1)
    }

    fn is_tile_occupied(world: IWorldDispatcher, row: u8, col: u8, player_id: u128) -> bool {
        let tile = get!(world, (row, col, player_id), (Tile));
        // 'tile'.print();
        // tile.player_id.print();
        // tile.row.print();
        // let t: TileType = tile.tile_type;
        // let t1: felt252 = t.into();
        // t1.print();

        tile.tile_type != TileType::Empty
    }

    fn neighbor(world: IWorldDispatcher, tile: Tile, direction: Direction) -> Tile {
        match direction {
            Direction::East(()) => get!(world, (tile.row, tile.col + 1, tile.player_id), (Tile)),
            Direction::NorthEast(()) => get!(
                world, (tile.row - 1, tile.col + 1, tile.player_id), (Tile)
            ),
            Direction::NorthWest(()) => get!(
                world, (tile.row - 1, tile.col, tile.player_id), (Tile)
            ),
            Direction::West(()) => get!(world, (tile.row, tile.col - 1, tile.player_id), (Tile)),
            Direction::SouthWest(()) => get!(
                world, (tile.row + 1, tile.col, tile.player_id), (Tile)
            ),
            Direction::SouthEast(()) => get!(
                world, (tile.row + 1, tile.col + 1, tile.player_id), (Tile)
            ),
        }
    }

    fn get_neighbors(world: IWorldDispatcher, tile: Tile) -> Array<Tile> {
        let mut result = ArrayTrait::<Tile>::new();

        let mut all_neighbours = array![
            neighbor(world, tile, Direction::East(())),
            neighbor(world, tile, Direction::NorthEast(())),
            neighbor(world, tile, Direction::NorthWest(())),
            neighbor(world, tile, Direction::West(())),
            neighbor(world, tile, Direction::SouthWest(())),
            neighbor(world, tile, Direction::SouthEast(()))
        ];

        loop {
            if (all_neighbours.len() == 0) {
                break;
            }

            let current = all_neighbours.pop_front().unwrap();
            if (is_tile_in_boundry(current.row, current.col)) {
                result.append(current);
            }
        };
        'neighbours len'.print();
        result.len().print();

        result
    }


    fn is_neighbor(world: IWorldDispatcher, tile: Tile, other: Tile) -> bool {
        let mut neighbors = get_neighbors(world, tile);
        loop {
            if (neighbors.len() == 0) {
                break false;
            }

            let curent_neighbor = neighbors.pop_front().unwrap();

            if (curent_neighbor.col == other.col) {
                if (curent_neighbor.row == other.row) {
                    break true;
                }
            };
        }
    }

    fn is_neighbor_settled(world: IWorldDispatcher, tile: Tile) -> bool {
        let mut neighbors = get_neighbors(world, tile);
        // 'neightbour len'.print();
        // neighbors.len().print();
        loop {
            if (neighbors.len() == 0) {
                break false;
            }
            let current_neighbour = neighbors.pop_front().unwrap();
            // 'neightbour x'.print();
            // current_neighbour.row.print();
            // 'neighbour y'.print();
            // current_neighbour.col.print();
            if ((current_neighbour.tile_type != TileType::Empty)
                && current_neighbour.tile_type != TileType::Port) {
                break true;
            }
        }
    }

    fn place_default_tiles(world: IWorldDispatcher, player_id: u128) {
        set!(
            world,
            (Tile {
                player_id,
                row: GRID_SIZE,
                col: GRID_SIZE,
                tile_type: TileType::Center,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: 0,
                col: GRID_SIZE,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: 0,
                col: GRID_SIZE * 2,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: GRID_SIZE,
                col: 0,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: GRID_SIZE,
                col: GRID_SIZE * 2,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: GRID_SIZE * 2,
                col: 0,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
        set!(
            world,
            (Tile {
                player_id,
                row: GRID_SIZE * 2,
                col: GRID_SIZE,
                tile_type: TileType::Port,
                counted: false,
                is_hill: false
            })
        );
    }

    fn calculate_score_for_tile(world: IWorldDispatcher, tile: Tile) -> u8 {
        if (tile.counted) {
            return 0;
        }

        if (tile.tile_type == TileType::WindMill) {
            let mut isolated = true;
            let mut score = 0;

            let mut neighbors = get_neighbors(world, tile);

            loop {
                if (neighbors.len() == 0) {
                    break;
                }

                let current_neighbour = neighbors.pop_front().unwrap();
                if (current_neighbour.tile_type == TileType::WindMill) {
                    isolated = false;
                    if (current_neighbour.counted) {
                        set!(
                            world,
                            Tile {
                                row: current_neighbour.row,
                                col: current_neighbour.col,
                                player_id: current_neighbour.player_id,
                                is_hill: current_neighbour.is_hill,
                                tile_type: current_neighbour.tile_type,
                                counted: false
                            }
                        );
                        if (current_neighbour.is_hill) {
                            score -= 3;
                        } else {
                            score -= 1;
                        }
                    }
                }
            };

            if (isolated) {
                if (tile.is_hill) {
                    score += 3;
                } else {
                    score += 1;
                }
            }

            return score;
        } else {
            // Implement logic for tiletype street and grass
            return 1;
        }
    }
}
