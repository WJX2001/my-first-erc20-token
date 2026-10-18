// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Vm.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

import { TheWeb3Token2 } from "../src/TheWeb3Token2.sol";
import { console, Script } from "forge-std/Script.sol";


// forge script ./script/deployTheWebThreeToken.s.sol:deployTheWebThreeTokenScript --rpc-url $PRC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key I4C1AKJT8J9KJVCXHZKK317T3XV8IVASRX
contract deployTheWebThreeTokenScript is Script {
    ProxyAdmin public theWeb3TokenProxyAdmin;

    TheWeb3Token2 public theWebThreeToken;
    TheWeb3Token2 public theWebThreeTokenImplementation;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // 谁出 gas 谁签名部署
        address managerAddress = vm.envAddress("MANAGER_ADDRESS"); // token 的 manager 例如以后调用 poolAllocate

        address deployerAddress = vm.addr(deployerPrivateKey); // 部署者地址 -> 当作 token 的 owner
        vm.startBroadcast(deployerPrivateKey);

        // 实现合约：只负责怎么干活，可以理解为 一本菜谱/一个员工手册
        // - 里面写 transfer、initialize、poolAllocate 等逻辑
        theWebThreeTokenImplementation = new TheWeb3Token2();

        // 编辑初始化数据 把调用 initialize(owner,manager) 编成 bytes
        bytes memory initData = abi.encodeCall(
            TheWeb3Token2.initialize,
            (deployerAddress, managerAddress)
        );

        // 代理合约：只负责当门面
        // 用户永远跟这个地址打交道，自己不写业务逻辑，收到调用后，去照着实现合约的代码执行
        // 但改数据时，改的是自己 Proxy 里的存储
        // 可以理解：店面地址固定；厨师按照 员工手册干活；账本记在这家店里，不记在手册上
        // 用 delegateCall 执行 initData 在 Proxy 上跑 initialize
        TransparentUpgradeableProxy proxyTheWebThreeToken =
                    new TransparentUpgradeableProxy(
                address(theWebThreeTokenImplementation), // 用哪本手册
                deployerAddress, // 谁有权换手册  ProxyAdmin 的 owner
                initData             // 开业时先做哪些初始化
            );
        theWebThreeToken = TheWeb3Token2(address(proxyTheWebThreeToken));
        // 管这个 Token 代理能不能升级、怎么升级的那个合约地址
        theWeb3TokenProxyAdmin = ProxyAdmin(getProxyAdminAddress(address(proxyTheWebThreeToken)));

        console.log("deploy proxyTheWebThreeToken:", address(proxyTheWebThreeToken));
        console.log("deploy theWebThreeTokenImplementation:", address(theWebThreeTokenImplementation));
        console.log("deploy theWeb3TokenProxyAdmin:", address(theWeb3TokenProxyAdmin));
        vm.stopBroadcast();
    }

    //
    function getProxyAdminAddress(address proxy) internal view returns (address) {
        address CHEATCODE_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
        Vm vm = Vm(CHEATCODE_ADDRESS);

        bytes32 adminSlot = vm.load(proxy, ERC1967Utils.ADMIN_SLOT);
        return address(uint160(uint256(adminSlot)));
    }
}