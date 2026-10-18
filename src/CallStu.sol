//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.20;
//
//contract CallFunctionContract {
//  uint256 public number;
//
//  function setNumber(uint256 newNumber) public {
//    number = newNumber;
//  }
//
//  function increment() public {
//    number++;
//  }
//}
//
//contract CallFunctionContractImplement {
//  function callSetNumber(address _target,uint256 _number) public {
//    (bool success,) = _target.call(
//      abi.encodeWithSignature("setNumber(uint256)", _number)
//    )
//    require(success, "call set number fail");
//  }
//
//  function callIncrement(address _target) public {
//    (bool success,) = _target.call(
//      abi.encodeWithSignature("increment()"),""
//    );
//    require(success, "call increment fail");
//  }
//}