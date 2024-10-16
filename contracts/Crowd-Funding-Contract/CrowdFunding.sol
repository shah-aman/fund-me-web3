// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {


    struct Campaign {
        address payable recipient;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
        bool claimed;
        bool isActive;
    }


    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;

    event CampaignCreated(uint256 campaignId, address recipient, uint256 goal, uint256 deadline);
    event PledgeMade(uint256 campaignId, address pledger, uint256 amount);
    event CampaignEnded(uint256 campaignId, bool claimed);

    //constructor
    constructor() {
        campaignCount = 0;
    }

    function createCampaign ( uint256 goal, uint256 deadline) public payable returns (uint256) {      
        campaignCount++;
        campaigns[campaignCount] = Campaign({
            recipient:payable(msg.sender)  ,
            goal: goal,
            pledged: 0,
            deadline: deadline,
            claimed: false,
            isActive: true
        });
    
        emit CampaignCreated(campaignCount, msg.sender, goal, deadline);
        return campaignCount;
    }

    function pledge(uint256 campaignId) public payable {
        Campaign storage campaign = campaigns[campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has already ended");
        // check if campaign id is in the mapping
        require(campaign.isActive == true, "Campaign is not active");
        require(campaignId > 0 && campaignId <= campaignCount, "Campaign does not exist");
       require(msg.value > 0, "Pledge amount must be greater than 0");
        campaign.pledged += msg.value;
        // if campaing amount is greater than the goal set isActive to false
        if (campaign.pledged >= campaign.goal) {
            campaign.isActive = false;
        }
        emit PledgeMade(campaignId, msg.sender, msg.value);
    }

function claimFunds(uint256 campaignId) public {
    Campaign storage campaign = campaigns[campaignId];
    require(campaignId > 0 && campaignId <= campaignCount, "Campaign does not exist");
    require(!campaign.claimed, "Funds have already been claimed");
    require(!campaign.isActive, "Campaign is still active");
    // check if the 
    require(campaign.recipient == msg.sender, "Only the recipient can claim the funds");

    campaign.recipient.transfer(campaign.pledged);
    campaign.claimed = true;
    emit CampaignEnded(campaignId, true);
}

   
    
}
