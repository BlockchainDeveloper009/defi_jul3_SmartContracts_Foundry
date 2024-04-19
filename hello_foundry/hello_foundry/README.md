## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### deploy

```shell
$ forge create SimpleStorage --rpc-url "" --interactive
```
```shell
$ forge script script/storage.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### Test

```shell
$ forge test
```
### Test one file
```shell
$ forge test -m testBobBalance;
$ forge test -m <functionName>
$ forge test -m invariant_protocolMustHaveMoreValueThanTotalSupply -vvvv;
```
### Forge tricks

```shell
#format solidity code
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Convert Hex to Decimal
```
$ cast --to-base 0x714c2 dec
```

### Add .env to project

```
$ source .env
$echo PRIVATE_KEY
$ forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --private-keu $PRIVATE_KEY
```


### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Counter.s.sol:CounterScript --rpc-url <https:127.0.0.1:8545> --private-key <your_private_key>
$ forge script script/Counter.s.sol:CounterScript --rpc-url $RPC_URL_FROM_DOT_ENV --private-key <your_private_key>
```

### Cast - to interact with contract from bash

```shell
$ cast <subcommand>
$ cast send --help
$ cast send contractaddr "store(uint256)" 123
$ cast send contractaddr "methodnameWithIntakingArgs)" incomingArgs --rpc-url $RPC_URL_FROM_DOT_ENV --private-key <your_private_key>
# send vs call of transaction, refer patrick collins video https://youtu.be/umepbfKp5rI?t=28754
$ cast call --help
#wallet, ledger
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


### vscode extensions

- markdown all in one - preview for .md files

