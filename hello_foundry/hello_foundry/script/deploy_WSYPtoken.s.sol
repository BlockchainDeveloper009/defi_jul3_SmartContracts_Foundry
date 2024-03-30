// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {WSYPToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/WSYP.sol";

contract deploy_WSYPtoken_Script is Script {
    uint256 public constant INITIAL_SUPPLY= 1000 ether;
    function setUp() public {}

    function run() public returns(WSYPToken){
        vm.startBroadcast();
        new WSYPToken("Sri Yogananda Paramahamsa Token","WSYP",2000);
        vm.stopBroadcast();
    }
}
