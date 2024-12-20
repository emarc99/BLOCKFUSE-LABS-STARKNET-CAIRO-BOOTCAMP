use starknet::ContractAddress;

#[starknet::interface]
pub trait IToken<TContractState>{
    fn mint(ref self: TContractState, recipient: ContractAddress, amount: u256);
}


#[starknet::contract]
mod ERC20 {
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};

    // use erc20::IToken; // same as below impl of IToken
    use starknet::ContractAddress;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.erc20.initializer("EmarcToken", "EMC");        
    }

    // ERC20 Mixin
    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl Token of super::IToken<ContractState>{
        fn mint (ref self: ContractState, recipient: ContractAddress, amount: u256){
            self.erc20.mint(recipient, amount);
        }
    }

   
    
}
