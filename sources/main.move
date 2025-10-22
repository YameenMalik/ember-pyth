
module testing::main;

use ember_vaults::vault::Vault;
use pyth::price_info::PriceInfoObject;
use pyth::price::{Price};
use pyth::i64::{I64};
use sui::event::emit;
use sui::clock::Clock;
use std::u128::{Self};

// Event
public struct ReceiptTokenPrice has copy, drop {
    rate: u64,
    deposit_token_price: u128,
    receipt_token_price: u128,
}


// The pyth oracle price must be <= max age seconds old
const ORACLE_PRICE_MAX_AGE: u64 = 600;
const BASE_UINT : u128 = 1000000000;
const U64_MAX: u128 = 18446744073709551615; // 2^64 - 1

// Entry function fetching vault rate and prices
entry fun get_receipt_token_price<T,R>(ember_vault: &Vault<T,R>, deposit_token_price_info: &PriceInfoObject, clock: &Clock) {
    let (deposit_token_price, receipt_token_price) = get_ember_vault_token_price(ember_vault, deposit_token_price_info, clock);
    emit (ReceiptTokenPrice { rate, deposit_token_price, receipt_token_price });
}

// public getter to get the deposit and receipt token price of ember vault
public fun get_ember_vault_token_price<T,R>(ember_vault: &Vault<T,R>, deposit_token_price_info: &PriceInfoObject, clock: &Clock): (u128, u128) {

    // get vault rate
    let rate = ember_vaults::vault::get_vault_rate(ember_vault);

    let deposit_token_price = get_pyth_oracle_price(deposit_token_price_info, clock);
    let receipt_token_price = base_div(deposit_token_price, rate as u128);
    (deposit_token_price, receipt_token_price)
}


/// Get the pyth oracle price from the price info object ( 1e9 format)
public fun get_pyth_oracle_price(price_info_obj: &PriceInfoObject, clock: &Clock): u128 {
    let price = get_oracle_price(price_info_obj, clock);
    let expo = (u128::pow(10,(get_oracle_base(price_info_obj, clock) as u8)) as u128);
    base_div(price, expo)

}

public fun base_div(value : u128, baseValue: u128): u128 {
        return (value * BASE_UINT) / baseValue 
}


/// Get the oracle price from the price info object
fun get_oracle_price(price_info_obj: &PriceInfoObject, clock: &Clock): u128{
        let price: Price = pyth::pyth::get_price_no_older_than(price_info_obj, clock, ORACLE_PRICE_MAX_AGE);   
        let price_i64: I64 = pyth::price::get_price(&price);
        let price_u64: u64 = pyth::i64::get_magnitude_if_positive(&price_i64);
        return (price_u64 as u128)
    }

/// Get the oracle base from the price info object
fun get_oracle_base(price_info_obj: &PriceInfoObject, clock: &Clock
    ): u128{
        let price: Price = pyth::pyth::get_price_no_older_than(price_info_obj, clock, ORACLE_PRICE_MAX_AGE);   
        let expo_i64: I64 = pyth::price::get_expo(&price);
        let expo_u64: u64 = pyth::i64::get_magnitude_if_negative(&expo_i64);
        return (expo_u64 as u128)
    }

/// Safely cast u128 to u64, returning 0 if the value is too large
public fun safe_cast_u128_to_u64(value: u128): u64 {
    if (value > U64_MAX) {
        0
    } else {
        (value as u64)
    }
}

/// Safely cast u128 to u64 with a custom default value if the value is too large
public fun safe_cast_u128_to_u64_with_default(value: u128, default_value: u64): u64 {
    if (value > U64_MAX) {
        default_value
    } else {
        (value as u64)
    }
}
