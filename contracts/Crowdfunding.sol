// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Decentralized Fundraiser
 * @dev A simple contract for creating and donating to fundraising campaigns.
 */
contract Project {
    address public owner;
    uint256 public goalAmount;
    uint256 public totalRaised;
    bool public goalReached;

    mapping(address => uint256) public donations;

    event DonationReceived(address indexed donor, uint256 amount);
    event GoalReached(uint256 totalRaised);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    constructor(uint256 _goalAmount) {
        owner = msg.sender;
        goalAmount = _goalAmount;
        goalReached = false;
    }

    /**
     * @dev Allows users to donate to the project.
     */
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than 0");

        donations[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit DonationReceived(msg.sender, msg.value);

        if (totalRaised >= goalAmount && !goalReached) {
            goalReached = true;
            emit GoalReached(totalRaised);
        }
    }

    /**
     * @dev Allows the owner to withdraw funds once the goal is reached.
     */
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Goal not reached yet");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner).transfer(balance);
        emit FundsWithdrawn(owner, balance);
    }

    /**
     * @dev Returns contract balance.
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

