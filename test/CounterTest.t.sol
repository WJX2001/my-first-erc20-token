// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import {ContractsBasic} from "../src/BasicStudy/ContractsBasic.sol";

contract CounterTest is Test {
    ContractsBasic cb;

    function setUp() public {
        cb = new ContractsBasic();
    }

    function test_SetAB() public {
        cb.setAB(false, false);

        bool a = cb.aVar();
        bool b = cb.bVar();

        console.log("a is", a);
        console.log("b is", b);
    }

    function test_compareAA() public view {
        bool aa = cb.compareAA();
        console.log("aa is", aa);
    }

    function test_Bool() public pure {
        bool a = true;
        bool b = false;

        bool retAndOne = a && b;
        bool retAndTwo = b && a;

        bool retOrA = a || b;
        bool retOrB = b || a;

        bool retNotA = !a;
        bool retNotB = !b;
        console.log("retAndOne is", retAndOne);
        console.log("retAndTwo is", retAndTwo);
        console.log("retOrA is", retOrA);
        console.log("retOrB", retOrB);
        console.log("retNotA is",retNotA);
        console.log("retNotB is",retNotB);
    }

}