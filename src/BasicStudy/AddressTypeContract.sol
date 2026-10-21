// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract AddressTypeContract {
    address public usdtTokenAddress;
    address public recipient;

    event Received(address receiver, uint256 amount);
    event SetRecipient(address oldAddress, address newAddress);

    constructor(address _usdtTokenAddress){
        usdtTokenAddress = _usdtTokenAddress;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function deposit(uint256 amount) public payable returns (bool) {
        require(amount <= msg.value, "balance is not enough");
        emit Received(msg.sender, amount);
        return true;
    }

    function setRecipient (address _recipientAddress) public {
        address oldAddress = recipient;
        recipient = _recipientAddress;
        emit SetRecipient(oldAddress,_recipientAddress);
    }

    function transferETH(uint256 amount) public returns (bool) {
        payable(recipient).transfer(amount);
        return true;
    }

    function callETH() public returns (bool) {
        (bool success, ) = payable(recipient).call{value: 1 ether}("");
        require(success,"Transfer failed");
        return success;
    }

    function sendETH() public returns (bool) {
        bool success = payable(recipient).send(1 ether);
        require(success,"Transfer failed");
        return success;
    }


    function addressBalance() public view returns (uint256) {
        return recipient.balance;
    }
}
