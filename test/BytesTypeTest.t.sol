// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
import {Test, console} from "forge-std/Test.sol";
import {BytesTypeContract} from "src/BasicStudy/BytesTypeContract.sol";

contract BytesTypeTest is Test {
    BytesTypeContract public btc;

    function setUp() public {
        btc = new BytesTypeContract();
    }

    function test_getBytesLength() public view {
        uint256 bLength = btc.getBytesLength();
        console.log("bLength is", bLength);
    }

    function test_getBytesByIndex() public {
        bytes1 indexBytes = btc.getBytesByIndex(1);
        console.logBytes1(indexBytes);
        console.log("uint8",uint8(indexBytes));
    }

    function test_compareBytes() public {
        bool res = btc.compareBytes();
        console.log("result is",res);
    }
}