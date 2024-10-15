
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract fund_me {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public senders;
    address public owner;

    constructor(address _owner) {
        owner = i_owner;
    }

    function fund() public payable {
        require(msg.value > 1, "Not enough ETH. send at least 1 ETH");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public owner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not enough Funds");
    }

    modifier owner() {
        require(msg.sender == owner, "Unauthorized Access");
    }
}
