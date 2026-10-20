// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import {IntBasic} from "../src/BasicStudy/IntBasic.sol";

contract IntBasicTest is Test {
    IntBasic ibc;

    function setUp() public {
        ibc = new IntBasic(1,2);
    }

    function test_Add() public view {
        uint256 cc = ibc.Add();
        console.log("cc is",cc);
    }
}