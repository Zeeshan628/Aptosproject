module MyModule::AirdropScheduler {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the airdrop schedule.
    struct Airdrop has store, key {
        amount: u64,          // Amount of tokens to be airdropped per user
        is_active: bool,      // Airdrop active status
    }

    /// Function to create and activate an airdrop schedule.
    public fun create_airdrop(owner: &signer, amount: u64) {
        let airdrop = Airdrop {
            amount,
            is_active: true,
        };
        move_to(owner, airdrop);
    }

    /// Function to claim airdropped tokens if the airdrop is active.
    public fun claim_airdrop(user: &signer, airdrop_owner: address) acquires Airdrop {
        let airdrop = borrow_global<Airdrop>(airdrop_owner);

        // Ensure the airdrop is active
        assert!(airdrop.is_active, 1);

        // Transfer tokens from the airdrop owner to the user
        let tokens = coin::withdraw<AptosCoin>(user, airdrop.amount);
        coin::deposit<AptosCoin>(signer::address_of(user), tokens);
    }
}
