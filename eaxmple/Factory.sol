// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import {IMiddleware} from "./Middleware.sol";
import {IBase} from "./Base.sol";

// 3.工厂合约
// tips: 需要部署
contract Factory {
    uint private counter;

    function create(address MiddlewareAddress) external returns(address base){
        bytes memory bytecode = IMiddleware(MiddlewareAddress).createCode();
        bytes32 salt = keccak256(abi.encodePacked(counter));

        assembly {
            base := create2(0, add(bytecode, 32), mload(bytecode), salt)
            if iszero(extcodesize(base)) {
                revert(0, 0)
            }
        }

        IBase(base).init();
        counter++;
    }
}
