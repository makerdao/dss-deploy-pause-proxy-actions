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

    function setAuthority(address, address, address) public {
        proxy.execute(proxyLib, msg.data);
    }

    function setDelay(address, address, uint) public {
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
        this.file(address(pause), address(govActions), address(vat), bytes32("Line"), uint(20000 * 10 ** 45));
        assertEq(vat.Line(), 20000 * 10 ** 45);
    }

    function testFile2() public {
        (,,, uint line,) = vat.ilks("ETH");
        assertEq(line, 10000 * 10 ** 45);
        this.file(address(pause), address(govActions), address(vat), bytes32("ETH"), bytes32("line"), uint(20000 * 10 ** 45));
        (,,, line,) = vat.ilks("ETH");
        assertEq(line, 20000 * 10 ** 45);
    }

    function testSetDelay() public {
        assertEq(pause.delay(), 0);
        this.setDelay(address(pause), address(govActions), 5);
        assertEq(pause.delay(), 5);
    }

    function testSetAuthority() public {
        assertEq(address(pause.authority()), address(authority));
        this.setAuthority(address(pause), address(govActions), address(123));
        assertEq(address(pause.authority()), address(123));
    }
}
