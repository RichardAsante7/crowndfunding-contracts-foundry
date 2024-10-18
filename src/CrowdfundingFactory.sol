// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Crowdfunding} from "./Crowdfunding.sol";

contract CrowdfundingFactory {
    address public s_owner;
    bool public s_paused;

    struct Campaign {
        address campaignAddress;
        address owner;
        string name;
        uint256 creationTime;
    }

    Campaign[] public s_campaigns;
    mapping(address => Campaign[]) public s_userCampaigns;

    modifier onlyOwner() {
        require(msg.sender == s_owner, "Not owner.");
        _;
    }

    modifier notPaused() {
        require(!s_paused, "Factory is paused");
        _;
    }

    constructor() {
        s_owner = msg.sender;
    }


    function createCampaign(
        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationInDays
    ) external notPaused {
        Crowdfunding newCampaign = new Crowdfunding(
            msg.sender,
            _name,
            _description,
            _goal,
            _durationInDays
        );
        address campaignAddress = address(newCampaign);

        Campaign memory campaign = Campaign({
            campaignAddress: campaignAddress,
            owner: msg.sender,
            name: _name,
            creationTime: block.timestamp
        });

        s_campaigns.push(campaign);
        s_userCampaigns[msg.sender].push(campaign);
    }

    function getUserCampaigns(address _user) external view returns (Campaign[] memory) {
        return s_userCampaigns[_user];
    }

    function getAllCampaigns() external view returns (Campaign[] memory) {
        return s_campaigns;
    }

    function togglePause() external onlyOwner {
        s_paused = !s_paused;
    }
}


}