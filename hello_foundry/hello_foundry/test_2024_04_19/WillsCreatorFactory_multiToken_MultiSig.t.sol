// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/AssetCreatorFactory_multiToken.sol";

contract WillsCreatorFactory_multiToken_MultiSig_Test is Test {
     AssetCreatorFactory_multiToken public  assetCreatorFactory_multiToken;
     WillsCreatorFactory_multiToken public  willsCreatorFactory_multiToken;

    function setUp() public {
        assetCreatorFactory_multiToken = new AssetCreatorFactory_multiToken(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        willsCreatorFactory_multiToken = new WillsCreatorFactory_multiToken(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        
    }

    function test_Will1() public {
        assetCreatorFactory_multiToken.a_createAssets("",,"" );
        willsCreatorFactory_multiToken.a_createCryptoVault("ca-0",123456, 123456, payable(benefitorAddr))
        //assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
