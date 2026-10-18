// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {
    Initializable
} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {TheWebThreeToken} from "../src/TheWebThreeToken.sol";
import {ITheWebThreeToken} from "../src/interface/ITheWebThreeToken.sol";
import {
    ERC1967Proxy
} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {
    OwnableUpgradeable
} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract TheWebThreeTokenTest is Test {
    TheWebThreeToken internal implementation;
    TheWebThreeToken internal token;

    address internal owner = makeAddr("owner");
    address internal manager = makeAddr("manager");
    address internal newManager = makeAddr("newManager");
    address internal nonOwner = makeAddr("nonOwner");

    address internal miningPool = makeAddr("miningPool");
    address internal directSalePool = makeAddr("directSalePool");
    address internal investorSalePool = makeAddr("investorSalePool");
    address internal ecosystemPool = makeAddr("ecosystemPool");
    address internal foundationPool = makeAddr("foundationPool");

    event SetManager(address indexed newAddress, address oldAddress);

    function setUp() public {
        implementation = new TheWebThreeToken();

        // 相当于调用 TheWebThreeToken的 initialize 方法，把这个调用打包成二进制字节
        bytes memory initData = abi.encodeCall(
            TheWebThreeToken.initialize,
            (owner, manager)
        );
        // 创建代理合约，代理把逻辑实现地址存到指定存储槽，在代理的存储空间执行 initialize(owner,manager);
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(implementation),
            initData
        );
        // 把代理合约地址强转为 TheWebThreeToken 类型
        token = TheWebThreeToken(address(proxy));
    }

    function testInitializeSetsMetadataOwnerManagerAndAllocationFlag()
        public
        view
    {
        assertEq(token.name(), "TheWebThree Coin");
        assertEq(token.symbol(), "TWT");
        assertEq(token.tokenDecimals(), 6);
        assertEq(token.owner(), owner);
        assertEq(token.manager(), manager);
        assertFalse(token.isAllocation());
        assertEq(token.totalSupply(), 0);
    }

    function testImplementationCannotBeInitializedDirectly() public {
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        implementation.initialize(owner, manager);
    }

    function testInitializeRevertsWhenOwnerIsZeroAddress() public {
        TheWebThreeToken newImplementation = new TheWebThreeToken();

        bytes memory initData = abi.encodeCall(
            TheWebThreeToken.initialize,
            (address(0), manager)
        );

        vm.expectRevert(
            "TheWebThreeToken initialize: _owner can't be zero address"
        );
        new ERC1967Proxy(address(newImplementation), initData);
    }

    function testInitializeCanOnlyRunOnce() public {
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        token.initialize(owner, manager);
    }

    function testOwnerCanSetManager() public {
        // 下一笔交易的 msg.sender = owner
        vm.prank(owner);
        vm.expectEmit(true, true, true, true, address(token));
        emit SetManager(newManager, manager);
        token.setManager(newManager);

        assertEq(token.manager(), newManager);
    }

    function testNonOwnerCannotSetManager() public {
        vm.prank(nonOwner);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                nonOwner
            )
        );
        token.setManager(newManager);
    }
}
