// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./AcuityAtomicSwap.sol";

contract AcuityAtomicSwapTest is DSTest {
    AcuityAtomicSwap swap;

    function setUp() public {
        swap = new AcuityAtomicSwap();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
