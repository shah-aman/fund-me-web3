// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ameyaTaneja_fund_me {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function fund() public payable {
        require(msg.value > 0, "You need to send some Ether");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}
