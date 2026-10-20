// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract IntBasic {
    uint256 public aa;
    uint256 public bb;

    constructor(uint256 _aa,uint256 _bb){
        aa = _aa;
        bb = _bb;
    }

    function Add() public view returns(uint256) {
        return aa + bb;
    }
}
