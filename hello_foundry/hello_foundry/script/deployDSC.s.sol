// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/defi_erc20/DefiStableCoin/DSCEngine.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
//import {ERCMock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
//Helper


//getSepohliaEthConfig

//mock

contract deployDSC is Script {
        uint256 public constant INITIAL_SUPPLY= 1000 ether;
    function setUp() public {}

    function run() public returns(WSYPToken){
        vm.startBroadcast();
       DecentralizedStableCoin singleSwap = new DecentralizedStableCoin();
        vm.stopBroadcast();
    }
}