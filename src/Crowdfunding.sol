// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//imports

contract CrowdFunding {
    //state variables
    string public s_name;
    string public s_description;
    uint256 public s_goal;
    uint256 public s_deadline;
    address public s_owner;
    bool public s_paused;

    enum CampaignState { Active, Successful, Failed };
    CampaignState public s_state;

    //type declarations
    struct Tier {
        string name;
        uint256 amount;
        uint256 backers;
    }

    Tier[] public s_tiers;

    struct Backer {
        uint256 totalContribution;
        mapping(uint256 => bool) fundedTiers;
    }

    mapping(address => Backer) public s_backers;





    //events

    

    //errors



    //modifiers

    modifier onlyOwner() {
        require(msg.sender == s_owner, "Not the owner");
        _;
    }

    modifier campaignOpen() {
        require(state == CampaignState.Active, "Campaign is not active.");
        _;
    }

    modifier notPaused() {
        require(!s_paused, "Contract is paused.");
        _;
    }


    //
    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal, 
        uint256 _durationInDays
    ) {
        s_name = _name;
        s_description = _description;
        s_goal = _goal;
        s_deadline = block.timestamp + (_duratyionInDays * 1 days);
        s_owner = _owner;
        s_state = CampaignState.Active;
    }

    function checkAndUpdateCampaignState() internal {
        if(s_state == CampaignState.Active) {
            if(block.timestamp >= s_deadline) {
                s_state = address(this).balance >= s_goal ? CampaignState.Successful : CampaignState.Failed;            
            } else {
                s_state = address(this).balance >= s_goal ? CampaignState.Successful : CampaignState.Active;
            }
        }
    }



    // receive() external payable {
    //     // ...
    // }

    // fallback() external {
    //     // ...
    // }

    // External functions
    

    // External functions that are view
    

    // External functions that are pure
    

    // Public functions
    function addTier(string memory _name,uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than 0.");
        s_tiers.push(Tier(_name, _amount, 0));
    }

    function removeTier(uint256 _index) public onlyOwner {
        require(_index < s_tiers.length, "Tier does not exist.");
        s_tiers[_index] = s_tiers[s_tiers.length -1];
        s_tiers.pop();
    }



    function fund(uint256 _tierIndex) public payable campaignOpen notPaused {
        require(_tierIndex < s_tiers.length, "Invalid tier.");
        require(msg.value == s_tiers[_tierIndex].amount, "Incorrect amount.");

        s_tiers[_tierIndex].s_backers++;
        s_backers[msg.sender].totalContribution += msg.value;
        s_backers[msg.sender].fundedTiers[_tierIndex] = true;

        checkAndUpdateCampaignState();
    }

    function withdraw() public onlyOwner {
        checkAndUpdateCampaignState();
        require(s_state == CampaignState.Successful, "Campaign not successful.");

        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        payable(s_owner).transfer(balance);
    }

    function refund() public {
        checkAndUpdateCampaignState();
        require(s_state == CampaignState.Failed, "Refunds not available.");
        uint256 amount = s_backers[msg.sender].totalContribution;
        require(amount > 0, "No contribution to refund");

        s_backers[msg.sender].totalContribution = 0;
        payable(msg.sender).transfer(amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function hasFundedTier(address _backer, uint256 _tierIndex) public view returns (bool) {
        return s_backers[_backer].fundedTiers[_tierIndex];
    }

    function getTiers() public view returns (Tier[] memory) {
        return s_tiers;
    }

    function getCampaignStatus() public view returns (CampaignState) {
        if (s_state == CampaignState.Active && block.timestamp > s_deadline) {
            return address(this).balance >= s_goal ? CampaignState.Successful : CampaignState.Failed;
        }
        return s_state;
    }

    function togglePause() public onlyOwner {
        s_paused = !s_paused;
    }

    function extendDeadline(uint256 _daysToAdd) public onlyOwner campaignOpen {
        s_deadline += _daysToAdd * 1 days;
    }


    // Internal functions

    

    // Private functions


}