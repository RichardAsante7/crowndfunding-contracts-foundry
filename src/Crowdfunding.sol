// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//imports

contract CrowdFunding {

    //type declarations


    //state variables
    string public s_name;
    string public s_description;
    uint256 public s_goal;
    uint256 public s_deadline;
    address public s_owner;




    //events

    

    //errors



    //modifiers


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
        // state = CampaignState.Active;
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
    function fund() public {

    }


    function withdraw() public {

    }

    function getContractBalance() public view returns(uint256) {
        

    }

    // Internal functions
    

    // Private functions


}