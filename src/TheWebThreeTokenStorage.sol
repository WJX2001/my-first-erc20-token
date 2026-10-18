// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import "./interface/ITheWebThreeToken.sol";

abstract contract TheWebThreeTokenStorage is ITheWebThreeToken {
  uint256 public constant MaxTotalSupply = 1_000_000_000 * 10 ** 6;
  
  string internal constant NAME = "TheWebThree Coin";
  string internal constant SYMBOL = "TWT";

  theWeb3CoinPool public twPool;

  bool public isAllocation;

  address public manager;

  uint256[100] private __gap;
}