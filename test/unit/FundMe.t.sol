// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from 'forge-std/Test.sol';
import {FundMe as FundContract} from "../../src/FundMe.sol";
import {deployFundme as deployscript} from "../../script/DeployFundMe.s.sol" ;
contract fundmetest is Test {
    FundContract Fundme;
    address User = makeAddr("user");
    uint256 constant SENDING_VALUE = 0.1 ether;
    uint256 constant USER_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
   function setUp() external{
     deployscript Script = new deployscript();
     Fundme = Script.run();
     vm.deal(User,USER_BALANCE);
   }
   function testMinUsd() public {
     assertEq(Fundme.MINIMUM_USD(),5e18);
   }
   function testOwnerIsSender() public {
    console.log("owner address:",Fundme.getOwner());
    console.log("contract address : ",address(this));
    console.log(msg.sender);
    //assertEq(Fundme.i_owner(),address(this)); address(this) if you deploy using the test 
    assertEq(Fundme.getOwner(),msg.sender);//msg.sender if you do the script to deploy contract
   }
   function testVersion() public {
    uint256 version = Fundme.getVersion();
    console.log(version);
    assertEq(version,4);
   }
   function testFundEth()public {
    vm.expectRevert();
    Fundme.fund();
    
   }
   modifier getfund {
    vm.prank(User); //next tx will be sent by this user (address)
    Fundme.fund{value:SENDING_VALUE}();
    _;
   }
   function testFundUpdate() public getfund {
    // vm.prank(User); //next tx will be sent by this user (address)
    // Fundme.fund{value:SENDING_VALUE}();
     uint256 amountToFund = Fundme.getAddressToAmount(User);
    assertEq(amountToFund,SENDING_VALUE);
   }
   function testFunders() public getfund {
    address funder = Fundme.getFunders(0);
    assertEq(funder,User);
   }
   function testOwnlyWithdraw() public getfund {
    vm.expectRevert();
    vm.prank(User);
    Fundme.withdraw();
   }
   function testWithdrawSingle () public getfund {
    uint256 startingBalanceOwner = Fundme.getOwner().balance;
    uint256 startingFundMeBalance = address(Fundme).balance;
    vm.prank(Fundme.getOwner());
    Fundme.withdraw();
    uint256 endingBalanceOwner = Fundme.getOwner().balance;
    uint256 endingFundBalance = address(Fundme).balance;
    assertEq(endingFundBalance,0);
    assertEq(startingBalanceOwner+startingFundMeBalance,endingBalanceOwner);
   }
   function testWithMultiple () public {
    uint160 FundersNumbers = 10;
    uint160 Funderindex = 1;
    
    for (uint256 i ; i<FundersNumbers ;i++){
      //hoax() = vm.prank + vm.deal;
      hoax(address(1),SENDING_VALUE);
      Fundme.fund{value:SENDING_VALUE}();
    }
    uint256 startingOwnerBalance = Fundme.getOwner().balance;
    uint256 startingFundBalance = address(Fundme).balance;
    uint256 gasStart = gasleft();
    vm.txGasPrice(GAS_PRICE);
    vm.prank(Fundme.getOwner());
    Fundme.withdraw();
    uint256 gasEnd = gasleft();
    uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
    console.log("gasStaret :",gasStart);
    console.log("gasEnd : ",gasEnd);
    console.log("gasUsed : ",gasUsed);
    assert (address(Fundme).balance==0);
    
    assert (startingFundBalance+startingOwnerBalance == Fundme.getOwner().balance);
   }
   function testWithMultipleCheaper () public {
    uint160 FundersNumbers = 10;
    uint160 Funderindex = 1;
    
    for (uint256 i ; i<FundersNumbers ;i++){
      //hoax() = vm.prank + vm.deal;
      hoax(address(1),SENDING_VALUE);
      Fundme.fund{value:SENDING_VALUE}();
    }
    uint256 startingOwnerBalance = Fundme.getOwner().balance;
    uint256 startingFundBalance = address(Fundme).balance;
    uint256 gasStart = gasleft();
    vm.txGasPrice(GAS_PRICE);
    vm.prank(Fundme.getOwner());
    Fundme.cheaperWithDraw();
    uint256 gasEnd = gasleft();
    uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
    console.log("gasStaret :",gasStart);
    console.log("gasEnd : ",gasEnd);
    console.log("gasUsed : ",gasUsed);
    assert (address(Fundme).balance==0);
    
    assert (startingFundBalance+startingOwnerBalance == Fundme.getOwner().balance);
   }
}