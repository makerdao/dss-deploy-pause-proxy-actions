pragma solidity ^0.5.6;

import "ds-test/test.sol";

import "./TestchainPauseProxyActions.sol";
import {DssDeployTestBase} from "dss-deploy/DssDeploy.t.base.sol";
import {DSProxyFactory, DSProxy} from "ds-proxy/proxy.sol";

contract ProxyCalls {
    DSProxy proxy;
    address proxyLib;

    function file(address, address, address, bytes32, uint) public {
        proxy.execute(proxyLib, msg.data);
    }

    function file(address, address, address, bytes32, bytes32, uint) public {
        proxy.execute(proxyLib, msg.data);
    }

    function changeDelay(address, address, uint) public {
        proxy.execute(proxyLib, msg.data);
    }
}

contract TestchainPauseProxyActionsTest is DssDeployTestBase, ProxyCalls {
    function setUp() public {
        super.setUp();
        deploy();
        DSProxyFactory factory = new DSProxyFactory();
        proxyLib = address(new TestchainPauseProxyActions());
        proxy = DSProxy(factory.build());
        authority.setRootUser(address(proxy), true);
    }

    function testFile() public {
        assertEq(vat.Line(), 10000 * 10 ** 45);
        this.file(address(pause), address(plan), address(vat), bytes32("Line"), uint(20000 * 10 ** 45));
        assertEq(vat.Line(), 20000 * 10 ** 45);
    }

    function testFile2() public {
        (,,, uint line,) = vat.ilks("ETH");
        assertEq(line, 10000 * 10 ** 45);
        this.file(address(pause), address(plan), address(vat), bytes32("ETH"), bytes32("line"), uint(20000 * 10 ** 45));
        (,,, line,) = vat.ilks("ETH");
        assertEq(line, 20000 * 10 ** 45);
    }

    function testChangeDelay() public {
        assertEq(pause.delay(), 0);
        this.changeDelay(address(pause), address(new ActionChangeDelay()), 5);
        assertEq(pause.delay(), 5);
    }
}
