//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundme is Script {
    uint256 constant SEND_Value = 0.01 ether;

    function fund(address deployed) public {
        vm.startBroadcast();
        FundMe(payable(deployed)).fund{value: SEND_Value}();
        vm.stopBroadcast();
    }

    function run() external {
        address recentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fund(recentDeployed);
        vm.stopBroadcast();
    }
}

contract FundmeWithdraw is Script {
    uint256 constant SEND_Value = 0.01 ether;

    function withdrawfund(address deployed) public {
        vm.startBroadcast();
        FundMe(payable(deployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address recentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        withdrawfund(recentDeployed);
        vm.stopBroadcast();
    }
}
