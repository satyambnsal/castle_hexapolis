//---------------------------------------------------------------------------------------------
// *Actions Contract*
// This contract handles all the actions that can be performed by the user
// Typically you group functions that require similar authentication into a single contract
//---------------------------------------------------------------------------------------------

#[dojo::contract]
mod actions {
    use starknet::{ContractAddress, get_caller_address};
    use debug::PrintTrait;
    use castle_hexapolis::interface::IActions;

    // import models
    use castle_hexapolis::models::{
        GAME_DATA_KEY, TileType, Tile, GameData, Score, RemainingMoves, PlayerAddress, PlayerID
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

            // player address
            let player_address = get_caller_address();

            // game data
            let mut game_data = get!(world, GAME_DATA_KEY, (GameData));

            // increment player count
            game_data.number_of_players += 1;

            // NOTE: save game_data model with the set! macro
            set!(world, (game_data));

            let player_id = assign_player_id(world, game_data.number_of_players, player_address);

            assign_score(world, player_id, 0);
            assign_remaining_moves(world, player_id, REMAINING_MOVES_DEFAULT);
            set!(
                world,
                (Tile { player_id, row: GRID_SIZE, col: GRID_SIZE, tile_type: TileType::Center })
            )
        }

        fn place_tile(self: @ContractState, tile: (u8, u8)) {}

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
    fn player_at_tile(world: IWorldDispatcher, x: u8, y: u8) -> u128 {
        get!(world, (x, y), (Tile)).player_id
    }

    // @dev: Sets player score and remaining moves
    fn player_score_and_remaining_moves(
        world: IWorldDispatcher, player_id: u128, score: u8, moves: u8
    ) {
        set!(world, (Score { player_id, score }, RemainingMoves { player_id, moves }));
    }
}
