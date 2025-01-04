// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockAggV3.sol";

contract HelperConfig is Script {
    config public activeNetwork;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct config {
        address pricefeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else {
            activeNetwork = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (config memory) {
        config memory sepoliaConfig = config({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (config memory) {
        if (activeNetwork.pricefeed != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator MockPrice = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();
        config memory anvilConfig = config({pricefeed: address(MockPrice)});
        return anvilConfig;
    }
}
