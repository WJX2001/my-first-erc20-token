// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";

abstract contract LibToken is ERC20Upgradeable, ERC20BurnableUpgradeable {

    address public msgSender;

    constructor() {
        msgSender = msg.sender;
    }

    function tokenBalance(address _address) external view virtual returns (uint256) {
        return balanceOf(_address);
    }

    function tokenDecimals() external view virtual returns (uint8);
}