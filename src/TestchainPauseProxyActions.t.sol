pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "./TestchainPauseProxyActions.sol";

contract TestchainPauseProxyActionsTest is DSTest {
    TestchainPauseProxyActions actions;

    function setUp() public {
        actions = new TestchainPauseProxyActions();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
