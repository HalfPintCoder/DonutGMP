// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGmpReceiver {
    /**
     * @dev Handles the receipt of a single GMP message.
     * The contract must verify the msg.sender, it must be the Gateway Contract address.
     *
     * @param id The EIP-712 hash of the message payload, used as GMP unique identifier
     * @param network The chain_id of the source chain that send the message
     * @param source The pubkey/address which sent the GMP message
     * @param payload The message payload with no specified format
     * @return 32-byte result, which will be stored together with the GMP message
     */
    function onGmpReceived(bytes32 id, uint128 network, bytes32 source, bytes calldata payload)
        external
        payable
        returns (bytes32);
}

contract DonutVendingMachine is IGmpReceiver {
    address public owner;
    mapping(address => uint) public donutBalances;

    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    function getBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    function restock(uint amount) public {
        require(msg.sender == owner, "Only owner can restock the donuts!");
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable {
        require(msg.value >= amount * 0.5 ether, "You must pay a minimum of 1 ether for 2 donuts");
        require(donutBalances[address(this)] >= amount, "OOPS! Not enough donuts");
        donutBalances[address(this)] -= amount;
        donutBalances[address(msg.sender)] += amount;
    }

    function onGmpReceived(bytes32, uint128, bytes32, bytes calldata)
        external
        payable
        override
        returns (bytes32)
    {
        // Implement the handling of the GMP message here if needed
        // You can use the GMP message information for specific actions
        // This function is required to conform to the IGmpReceiver interface
        // but you can customize its implementation based on your requirements
        return bytes32(0); // Placeholder return value
    }
}
