// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe as FundContract} from "../../src/FundMe.sol";
import {deployFundme as deployscript} from "../../script/DeployFundMe.s.sol";
import {FundFundme, FundmeWithdraw} from "../../script/interaction.s.sol";

contract fundIntegration is Test {
    FundContract Fundme;
    address User = makeAddr("user");
    uint256 constant SENDING_VALUE = 0.1 ether;
    uint256 constant USER_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deployscript Script = new deployscript();
        Fundme = Script.run();
        vm.deal(User, USER_BALANCE);
    }

    function testUserCanFund() public {
        FundFundme fund = new FundFundme();
        fund.fund(address(Fundme));
        //  address funder = Fundme.getFunders(0);
        //  assertEq(funder,User);
        FundmeWithdraw withdraw = new FundmeWithdraw();
        withdraw.withdrawfund(address(Fundme));
        assert(address(Fundme).balance == 0);
    }
}
