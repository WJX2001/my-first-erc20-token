// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract ContractsBasic {
    bool public aVar;
    bool public bVar;

    event SetABEvent(bool a, bool b);

    function setAB(bool _aVar,bool _bVar) external {
        aVar = _aVar;
        bVar = _bVar;
        emit SetABEvent(_aVar,_bVar);
    }

    function compareAA() public view returns (bool)  {
        return aVar == bVar;
    }

}
