// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract deploy_WSYPtoken_Script is Script {
    uint256 public constant INITIAL_SUPPLY= 1000 ether;
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}
