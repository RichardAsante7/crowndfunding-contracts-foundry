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



}