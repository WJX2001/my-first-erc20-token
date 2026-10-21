// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import {AddressTypeContract} from "../src/BasicStudy/AddressTypeContract.sol";

contract AddressTypeTest is Test {
    AddressTypeContract public addressType;
    address public constant USDT_TOKEN = 0x55d398326f99059fF775485246999027B3197955;
    address public bob;

    event Received(address receiver, uint256 amount);
    event SetRecipient(address oldAddress, address newAddress);

    function setUp() public {
        addressType = new AddressTypeContract(USDT_TOKEN);

        // 转出测试需要收款人
        bob = makeAddr("bob");
        addressType.setRecipient(bob);
    }

    function test_ConstructorSetUsdtTokenAddress() public view {
        assertEq(addressType.usdtTokenAddress(), USDT_TOKEN);
    }

    function test_ReceiveAcceptsETHAndEmitsEvent() public {
        uint256 ethAmount = 1 ether;

        vm.expectEmit(address(addressType));
        emit Received(address(this), ethAmount);

        (bool success,) = address(addressType).call{value: ethAmount}("");

        assertTrue(success);
        assertEq(address(addressType).balance, ethAmount);
    }

    function test_DepositAcceptsETHAndEmitsEvent() public {
        uint256 ethAmount = 1.5 ether;
        vm.expectEmit(address(addressType));
        emit Received(address(this), ethAmount);
        bool success = addressType.deposit{value: ethAmount}(ethAmount);
        console.log("deposit eth is", address(addressType).balance);
        assertTrue(success);
        assertEq(address(addressType).balance, ethAmount);
    }

    function test_DepositRevertsWhenAmountExceedsMsgValue() public {
        vm.expectRevert(bytes("balance is not enough"));
        addressType.deposit{value: 1 ether}(2 ether);
    }

    function test_SetRecipientUpdatesRecipientAndEmitsEvent() public {
        address recipient = address(0xBEEF);
        // 由addressType 发出的事件我要检查
        vm.expectEmit(address(addressType));
        emit SetRecipient(address(0), recipient);

        addressType.setRecipient(recipient);
        assertEq(addressType.recipient(), recipient);
    }

    function test_TransferETHSendsAmountToRecipient() public {
        address recipient = address(0xBEEF);
        uint256 contractBalance = 2 ether;
        uint256 transferAmount = 0.75 ether;

        addressType.setRecipient(recipient);
        vm.deal(address(addressType), contractBalance);

        bool success = addressType.transferETH(transferAmount);

        assertTrue(success);
        assertEq(recipient.balance, transferAmount);
        assertEq(address(addressType).balance, contractBalance - transferAmount);
    }

    function test_CallETHSendsOneEtherToRecipient() public {
        address recipient = address(0xBEEF);
        addressType.setRecipient(recipient);
        vm.deal(address(addressType), 1 ether);

        bool success = addressType.callETH();
        assertTrue(success);
        assertEq(recipient.balance, 1 ether);
        assertEq(address(addressType).balance, 0);
    }

    function test_SendETHSendsOneEtherToRecipient() public {
        address recipient = address(0xBEEF);
        addressType.setRecipient(recipient);
        vm.deal(address(addressType), 1 ether);

        bool success = addressType.sendETH();
        assertTrue(success);
        assertEq(recipient.balance, 1 ether);
        assertEq(address(addressType).balance, 0);
    }

    function test_CallETHRevertsWhenContractBalanceIsInsufficient() public {
        addressType.setRecipient(address(0xBEEF));
        vm.expectRevert(bytes("Transfer failed"));

        addressType.callETH();
    }
    // ========== 测转出：三种方式 ==========

    function test_TransferETH() public {
        // 1. 先让合约有钱（测试合约默认有 ETH，直接 deposit）
        addressType.deposit{value: 2 ether}(2 ether);

        uint256 beforeBal = bob.balance;

        // 2. 从合约转出给 recipient(bob)
        bool ok = addressType.transferETH(1 ether);
        assertTrue(ok);

        // 3. 断言：bob 多了 1 ETH，合约少了 1 ETH
        assertEq(bob.balance - beforeBal, 1 ether);
        assertEq(address(addressType).balance, 1 ether);
        console.log("bob balance", bob.balance);
    }

    function test_CallETH() public {
        addressType.deposit{value: 2 ether}(2 ether);

        uint256 beforeBal = bob.balance;

        // callETH 合约里写死转 1 ether
        bool ok = addressType.callETH();
        assertTrue(ok);

        assertEq(bob.balance - beforeBal, 1 ether);
    }

    function test_SendETH() public {
        addressType.deposit{value: 2 ether}(2 ether);

        uint256 beforeBal = bob.balance;

        // sendETH 合约里写死转 1 ether
        bool ok = addressType.sendETH();
        assertTrue(ok);

        assertEq(bob.balance - beforeBal, 1 ether);
    }
}
