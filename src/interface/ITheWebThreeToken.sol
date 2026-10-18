// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface ITheWebThreeToken {
    struct theWeb3CoinPool {
        address miningPool;
        address directSalePool;
        address investorSalePool;
        address ecosystemPool;
        address foundationPool;
    }

    event SetManager(address indexed newAddress, address oldAddress);
    event SetPoolAddress(theWeb3CoinPool indexed pool);

    function setManager(address _manager) external;
    function setPoolAddress(theWeb3CoinPool memory _twPool) external;
    function poolAllocate() external;
}
