// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ticketing {
    address public owner;
    uint public ticketPrice = 0.01 ether;
    uint public totalTickets;
    mapping(address => uint) public ticketsOwned;

    event TicketPurchased(address indexed buyer, uint quantity);
    
    constructor(uint _totalTickets) {
        owner = msg.sender;
        totalTickets = _totalTickets;
    }

    function buyTicket(uint quantity) public payable {
        require(quantity > 0, "Quantity must be greater than zero");
        require(msg.value == ticketPrice * quantity, "Incorrect payment amount");
        require(totalTickets >= quantity, "Not enough tickets available");

        ticketsOwned[msg.sender] += quantity;
        totalTickets -= quantity;

        emit TicketPurchased(msg.sender, quantity);
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    // New function to get the contract balance
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // New function to get the number of tickets owned by a specific address
    function getTicketsOwned(address _owner) public view returns (uint) {
        return ticketsOwned[_owner];
    }
}