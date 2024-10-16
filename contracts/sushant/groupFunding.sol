// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract fund_me {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public senders;
    address public owner;
    uint256 public requestedFunding = 5;
    uint256 public totalFunding;
    uint256 public deadline;
    bool public fundingOpen;

    constructor(address _owner) {
        owner = _owner;
        totalFunding=0;
        fundingOpen=true;
    }

    

    function fund() public payable {
        require(fundingOpen == false, "Not open for Funding ");
        require(msg.value > 1, "Not enough ETH. Send at least 1 ETH");

        addressToAmountFunded[msg.sender] += msg.value;
        senders.push(msg.sender);
        totalFunding += msg.value;
        deadline = block.timestamp + (24 * 1 hours);
    }

    // Applying the modified name correctly
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not enough funds");

        // Transfer the contract's balance to the owner
        payable(owner).transfer(balance);
    }

    // Rename the modifier to 'onlyOwner' to avoid conflict with the state variable
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    function closeFunding() internal {
        if (requestedFunding == totalFunding){
            fundingOpen = false;
        }

        if (block.timestamp == deadline){
            fundingOpen = false;
        }
    }

}
