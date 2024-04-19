// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {WSYPToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/WSYP.sol";
import {deploy_WSYPtoken_Script} from "../script/deploy_WSYPtoken.s.sol";

//@reference: https://github.com/Cyfrin/foundry-erc20-f23

contract WSYPToken_Tests is Test {
    WSYPToken public wSYPToken;
    deploy_WSYPtoken_Script public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uin256 public constant STARTING_BALANCE = 100 ether;


    function setUp() public {
        deployer = new deploy_WSYPtoken_Script();
        wSYPToken = deployer.run();
    //contractAddress = address(deployer)
        vm.prank(msg.sender); 
        wSYPToken.transfer(bob, STARTING_BALANCE);
        
    }

    function test_BobBalance() public {
        
        assertEq(STARTING_BALANCE, wSYPToken.balanceOf(bob));
    }
//forge test -m testBobBalance;

    function testAllowancesWorks(uint256 x) public {
        //transferFrom
        uint256 initialAllowance = 1000;
        // Bob approves alice to take token
        vm.prank(bob);
        wSYPToken.approve(alice, initialAllowance);

        vm.prank(alice);
        uint256 transferAmount = 500;
        wSYPToken.transferFrom(bob,alice, transferAmount);
        assertEq(wSYPToken.balanceOf(alice), transferAmount);

        assertEq(wSYPToken.balanceOf(bob), STARTING_BALANCE - transferAmount)
    }
}
