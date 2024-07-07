// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetWorkConfig public activeWorkConfig;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetWorkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeWorkConfig = getSepoliaEthConfig();
        } else {
            activeWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory netWorkConfig = NetWorkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return netWorkConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        if (activeWorkConfig.priceFeed != address(0)) {
            return activeWorkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();
        NetWorkConfig memory netWorkConfig = NetWorkConfig({priceFeed: address(mockV3Aggregator)});
        return netWorkConfig;
    }
}
