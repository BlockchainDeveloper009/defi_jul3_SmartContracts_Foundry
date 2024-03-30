// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {AssetCreatorFactory_multiToken} from "../src/willSettler_withMultiToken_MultiSig_2024Mar09/AssetCreatorFactory_multiToken.sol";

//Asset creation

// input data validation
/**
 * only approved token contract address should be used
 * asset amount should be greater than 0
 * asset amount should be in metamask customer account
 * 
 * 2. Getter view functions should never revert <- evergreen invariant
 * 
 */