/// TestchainPauseProxyActions.sol

// Copyright (C) 2018 Gonzalo Balabasquer <gbalabasquer@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.5.6;

contract PauseLike {
    function plan(address, bytes memory, uint) public;
    function exec(address, bytes memory, uint) public;
}

contract TestchainPauseProxyActions {
    function file(address pause, address plan, address who, bytes32 what, uint256 data) external {
        PauseLike(pause).plan(address(plan), abi.encodeWithSignature("file(address,bytes32,uint256)", who, what, data), now);
        PauseLike(pause).exec(address(plan), abi.encodeWithSignature("file(address,bytes32,uint256)", who, what, data), now);
    }

    function file(address pause, address plan, address who, bytes32 ilk, bytes32 what, uint256 data) external {
        PauseLike(pause).plan(address(plan), abi.encodeWithSignature("file(address,bytes32,bytes32,uint256)", who, ilk, what, data), now);
        PauseLike(pause).exec(address(plan), abi.encodeWithSignature("file(address,bytes32,bytes32,uint256)", who, ilk, what, data), now);
    }
}
