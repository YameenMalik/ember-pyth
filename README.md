# Pyth + Ember Testing Package
This is test sui move test package that uses the ember vaults and pyth oracle price feed

## How to?
To deploy contract do `sui move publih` - Copy the published package id from the CLI
To perform the contract call run:

```powershell
sui client call `
  --package <Above Published Package> `
  --module main `
  --function get_receipt_token_price `
  --type-args <Deposit Token Type> <Receipt Token Type> `
  --args <Vault ID> <Pyth Price Feed Object ID> 0x6
```

- The Package id could be found from the CLI after package is published
- The type args are the deposit and receipt token types of the vault. The `vault.json` contains all vault deposit and receipt token type
- The vault id is the id of the vault for which we want to get the receipt token price. IDs of all vaults could be found in `vault.json`
- The pyth price feed object id can be obtained using price feed id using srcip `fetch-pyth-id.ts`. The script accepts a price-feed-id that could be found on Pyth website over [here](https://docs.pyth.network/price-feeds/price-feeds)

Sample example of performing the contract call to fetch receipt token price for vault Gamma SUI looks like this:
```powershell
sui client call `
  --package 0xff923ba54e53e8095bcad2f10e69501ccac785426fa9609c8b631e8f176bedfc `
  --module main `
  --function get_receipt_token_price `
  --type-args 0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI `
  0x4dc301602277552a6c2c3309b02a70f7aae27eeeb300863de9466b4c1be7d568::egsui::EGSUI `
  --args 0x3fe669ff41cd6ee8d9d6aa4b04d14336ac1c796800f499cb5bf321b9930d0cfe `
  0x801dbc2f0053d34734814b2d6df491ce7807a725fe9a01ad74a07e9c51396c37 `
  0x6
```

The contract call emits a dummy event `ReceiptTokenPrice` ( This is only for testing, most likely the user may want this function to return the price, so please update the method before publishing if that is what you need. Thanks)
```
╭───────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                  │
├───────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                      │
│  │ EventID: 7PZx4LKPFEVbVKYSpGvUd2764ikZ3TWkcnpD5qEZo8rr:0                                                │
│  │ PackageID: 0xff923ba54e53e8095bcad2f10e69501ccac785426fa9609c8b631e8f176bedfc                          │
│  │ Transaction Module: main                                                                               │
│  │ Sender: 0xda6112e0d44870659810fab4eb718cbd4c2d30596b159f03eb340183f54b38f7                             │
│  │ EventType: 0xff923ba54e53e8095bcad2f10e69501ccac785426fa9609c8b631e8f176bedfc::main::ReceiptTokenPrice │
│  │ ParsedJSON:                                                                                            │
│  │   ┌─────────────────────┬────────────┐                                                                 │
│  │   │ deposit_token_price │ 3597204370 │                                                                 │
│  │   ├─────────────────────┼────────────┤                                                                 │
│  │   │ rate                │ 1000000000 │                                                                 │
│  │   ├─────────────────────┼────────────┤                                                                 │
│  │   │ receipt_token_price │ 3597204370 │                                                                 │
│  │   └─────────────────────┴────────────┘                                                                 │
│  └──                                                                                                      │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

