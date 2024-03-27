// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AssetCreatorFactory_multiToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/AssetCreatorFactory_multiToken.sol";
import {WWethBase20_multiToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/WWethBase20_multiToken.sol";

contract AssetCreatorFactory_multiToken_Test is Test {

     AssetCreatorFactory_multiToken public  assetCreatorFactory_multiToken;
    WWethBase20_multiToken public wwethBase20_multiToken;
    function setUp() public {
        assetCreatorFactory_multiToken = new AssetCreatorFactory_multiToken(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        wwethBase20_multiToken = new WWethBase20_multiToken();
    }

    function test_createAsset() public {
        assetCreatorFactory_multiToken.a_createAssets("ca-0", , 0.001);
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
