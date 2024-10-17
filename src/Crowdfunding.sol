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
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier campaignOpen() {
        require(state == CampaignState.Active, "Campaign is not active.");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused.");
        _;
    }


    //
    constructor(
        string memory _name,
        string memory _description,
        uint256 _goal, 
        uint256 _durationInDays
    ) {
        name = _name;
        description = _description;
        goal = _goal;
        deadline = block.timestamp + (_duratyionInDays * 1 days);
        owner = _owner;
        state = CampaignState.Active;
    }

    function checkAndUpdateCampaignState() internal {
        if(state == CampaignState.Active) {
            if(block.timestamp >= deadline) {
                state = address(this).balance >= goal ? CampaignState.Successful : CampaignState.Failed;            
            } else {
                state = address(this).balance >= goal ? CampaignState.Successful : CampaignState.Active;
            }
        }
    }



    receive() external payable {
        // ...
    }

    fallback() external {
        // ...
    }

    // External functions
    

    // External functions that are view
    

    // External functions that are pure
    

    // Public functions
    function fund() public payable {
        
    }


    function withdraw() public {

    }

    function getContractBalance() public view returns(uint256) {


    }

    // Internal functions

    

    // Private functions


}