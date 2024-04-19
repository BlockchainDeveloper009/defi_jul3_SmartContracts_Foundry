// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {ERCMock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
//Helper


//getSepohliaEthConfig

//mock

contract HelperConfig is Script {
    struct NetworkConfig {
        address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        address weth;
        address wbtc;
        uint256 deployerKey;
    }
    uint8 public constant DECIMALS= 8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    NetworkConfig public activeNetworkConfig;
    uint256 public constant DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepohliaEthConfig();
        }else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns(NetworkConfig memory){
        return NetworkConfig({
            // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
            wethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, 
            wbtcUsdPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43,
            weth: ,
            wbtc: ,

            deployerKey: vm.envUint("PRIVATE_KEY");
        });
    }
///

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if(activeNetworkConfig.wethUsdPriceFeed != address(0)){
             return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator ethUsdPriceFeed = new MockV3Aggregator(
            DECIMALS,
            ETH_USD_PRICE
        );

        ERC20Mock wethMock = new ERC20Mock("WETH", "WETH", msg.sender, 1000e8);

        ERC20Mock wbtcMock = new ERC20Mock("WBTC", "WBTC", msg.sender, 1000e8);

        vm.stopBroadcast();

        return NetworkConfig({
            wethUsdPriceFeed: address(ethUsdPriceFeed),
            wbtcUsdPriceFeed: address(btcUsdPriceFeed),
             weth: address(wethMock),
            wbtc: address(wbtcMock),

            deployerKey: DEFAULT_ANVIL_KEY;
        })

    }
}
