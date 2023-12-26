// ---------------------------------------------------------------------
// This file contains the interface of the contract.
// ---------------------------------------------------------------------

#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState);
    fn place_tile(self: @TContractState, tile1: (u8, u8, u8));
    fn cleanup(self: @TContractState);
}
