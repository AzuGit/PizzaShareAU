// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract PizzaShare {

// form to be fill when you post a pizzashare
    struct PizzaCampaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => PizzaCampaign) public PizzaCampaigns;

    uint256 public numberOfPizzaCampaigns = 0;

/**
 * allow create a pizzashare to receive donations
 * @param {struc} PizzaCamapign - all the items
 */
    function createPizzaCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        PizzaCampaign storage PizzaCampaign = PizzaCampaigns[numberOfPizzaCampaigns];

        require(PizzaCampaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        PizzaCampaign.owner = _owner;
        PizzaCampaign.title = _title;
        PizzaCampaign.description = _description;
        PizzaCampaign.target = _target;
        PizzaCampaign.deadline = _deadline;
        PizzaCampaign.amountCollected = 0;
        PizzaCampaign.image = _image;

        numberOfPizzaCampaigns++;

        return numberOfPizzaCampaigns - 1;
    }

/**
 * allow to donate in any pizzashare already created
 */
    function donateToPizzaCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        PizzaCampaign storage PizzaCampaign = PizzaCampaigns[_id];

        PizzaCampaign.donators.push(msg.sender);
        PizzaCampaign.donations.push(amount);

        (bool sent,) = payable(PizzaCampaign.owner).call{value: amount}("");

        if(sent) {
            PizzaCampaign.amountCollected = PizzaCampaign.amountCollected + amount;
        }
    }

/**
 * allow get an array with all the pizzashares donators to show on frontend
 */
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (PizzaCampaigns[_id].donators, PizzaCampaigns[_id].donations);
    }

/**
 * allow get an array with all the pizzashares to show on frontend
 */
    function getPizzaCampaigns() public view returns (PizzaCampaign[] memory) {
        PizzaCampaign[] memory allPizzaCampaigns = new PizzaCampaign[](numberOfPizzaCampaigns);

        for(uint i = 0; i < numberOfPizzaCampaigns; i++) {
            PizzaCampaign storage item = PizzaCampaigns[i];

            allPizzaCampaigns[i] = item;
        }

        return allPizzaCampaigns;
    }
}