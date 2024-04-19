//// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SingleSwap_Uni_V3_yt_blockexplorer} from "../src/defi_UniSwapContracts/SingleSwap_Uni_V3_yt_blockexplorer.sol";

contract deploy_SingleSwap_UniV3_yt_blockexplorer_Script is Script {
    uint256 public constant INITIAL_SUPPLY= 1000 ether;
    function setUp() public {}

    function run() public returns(WSYPToken){
        vm.startBroadcast();
       SingleSwap_Uni_V3_yt_blockexplorer singleSwap = new SingleSwap_Uni_V3_yt_blockexplorer();


        vm.stopBroadcast();
    }
}
