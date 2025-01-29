// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract BlockchainTicketing is ERC721Enumerable, Ownable {

    uint256 public ticketPrice;
    uint256 public maxTickets;
    uint256 public totalMinted;

    mapping(uint256 => bool) public isUsed;  // Tracks if a ticket has been used (for entry verification)

    event TicketPurchased(address indexed buyer, uint256 ticketId);
    event TicketUsed(uint256 ticketId, address indexed owner);
    event TicketCancelled(uint256 ticketId, address indexed owner);

    /**
     * @dev Constructor that initializes the ticketing contract.
     * @param _eventName The name of the event.
     * @param _eventSymbol The symbol of the event.
     * @param _ticketPrice The price of a ticket.
     * @param _maxTickets The maximum number of tickets available.
     */
    constructor(
    string memory _eventName,
    string memory _eventSymbol,
    uint256 _ticketPrice,
    uint256 _maxTickets
) ERC721(_eventName, _eventSymbol) Ownable(msg.sender) {
    ticketPrice = _ticketPrice;
    maxTickets = _maxTickets;
    totalMinted = 0;
}

    /**
     * @dev Allows a user to purchase a ticket.
     * Requires that the sender sends the correct amount of ETH and that there are still tickets available.
     */
    function buyTicket() external payable {
        require(totalMinted < maxTickets, "All tickets sold out");
        require(msg.value == ticketPrice, "Incorrect ticket price");

        uint256 ticketId = totalMinted + 1;
        _safeMint(msg.sender, ticketId);
        totalMinted++;

        emit TicketPurchased(msg.sender, ticketId);
    }

    /**
     * @dev Allows the ticket owner to use a ticket (e.g., for entry verification).
     * Requires that the ticket is owned by the sender and has not been used yet.
     * @param ticketId The ID of the ticket to be used.
     */
    function useTicket(uint256 ticketId) external {
        require(ownerOf(ticketId) == msg.sender, "You do not own this ticket");
        require(!isUsed[ticketId], "Ticket already used");

        isUsed[ticketId] = true;
        emit TicketUsed(ticketId, msg.sender);
    }

    /**
     * @dev Allows the ticket owner to cancel a ticket.
     * Requires that the ticket is owned by the sender and has not been used yet.
     * @param ticketId The ID of the ticket to be cancelled.
     */
    function cancelTicket(uint256 ticketId) external {
        require(ownerOf(ticketId) == msg.sender, "You do not own this ticket");
        require(!isUsed[ticketId], "Used tickets cannot be cancelled");

        _burn(ticketId);
        totalMinted--;

        emit TicketCancelled(ticketId, msg.sender);
    }

    /**
     * @dev Allows the contract owner to withdraw the funds collected from ticket sales.
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(owner()).transfer(balance);
    }

    /**
     * @dev Allows the owner to change the ticket price.
     * @param newTicketPrice The new ticket price.
     */
    function setTicketPrice(uint256 newTicketPrice) external onlyOwner {
        ticketPrice = newTicketPrice;
    }

    /**
     * @dev Allows the owner to change the maximum number of tickets.
     * @param newMaxTickets The new maximum number of tickets.
     */
    function setMaxTickets(uint256 newMaxTickets) external onlyOwner {
        maxTickets = newMaxTickets;
    }

    /**
     * @dev Returns the current contract balance.
     * @return The contract's current balance in wei.
     */
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
