#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    /// Increase contract balance.
    fn add_balance(ref self: TContractState, amount: u256);
    /// Retrieve contract balance.
    fn get_balance(self: @TContractState) -> u256;
}

#[starknet::contract]
mod SimpleStorage {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        balance: u256,
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
    fn add_balance (ref self: ContractState, amount: u256) {

        let _balance = self.balance.read();
        
        self.balance.write(_balance + amount);
    }

    fn get_balance (self: @ContractState) -> u256 {
        self.balance.read()
    }
}

}