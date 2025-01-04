// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe as contractFund} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract deployFundme is Script {
    function run() external returns (contractFund) {
        HelperConfig helperconfig = new HelperConfig();
        address EthUsdPrice = helperconfig.activeNetwork();
        vm.startBroadcast();
        contractFund Fund = new contractFund(EthUsdPrice);
        vm.stopBroadcast();
        return Fund;
    }
}
