// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract fund_me {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public senders;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function fund() public payable {
        require(msg.value > 1, "Not enough ETH. Send at least 1 ETH");

        addressToAmountFunded[msg.sender] += msg.value;
        senders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not enough funds");

        payable(owner).transfer(balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }
}
