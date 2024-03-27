// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WSYPToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/WSYP.sol";
import {wSYPToken} from "../script/deploy_WSYPtoken.s.sol";
contract WSYPToken_Tests is Test {
    WSYPToken public wSYPToken;

    function setUp() public {
        wSYPToken = new WSYPToken("WSYP Token","WSYP",1000);
        
    }

    function test_Increment() public {
        wSYPToken.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        wSYPToken.setNumber(x);
        assertEq(counter.number(), x);
    }
}
