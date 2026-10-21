// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract BytesTypeContract {
    // 6个 十六进制字符 = 3字节
    bytes32 public bytes1Array1 = hex"abcdef";
    bytes32 public bytes2Array2 = hex"abcdee";

    function getBytesLength() public view returns (uint256) {
        return bytes1Array1.length;
    }

    function getBytesByIndex(uint256 index) public view returns (bytes1) {
        require(index < bytes2Array2.length,"index out of bounds");
        return bytes2Array2[index];
    }

    function compareBytes() public view returns (bool) {
        return keccak256(abi.encodePacked(bytes1Array1)) == keccak256(abi.encodePacked(bytes2Array2));
    }
}
