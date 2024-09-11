// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Escrow{
    struct Agreement{
        address player1;
        address player2;
        address controller;
        uint amount;
        bool player1Paid;
        bool player2Paid;
    }

    Agreement[] public agreements;

    modifier onlyPlayers (uint _id) {
        require(msg.sender == agreements[_id].player1 || msg.sender == agreements[_id].player2, "The deposit is acceptable by only the players.");
        _;
    }
    modifier onlyController (uint _id) {
        require(msg.sender == agreements[_id].controller, "This can only be done by the Official.");
        _;
    }

    function new_agreement (address _player1, address _player2, uint _amount) public returns(uint) {
        agreements.push(Agreement(_player1, _player2, msg.sender, _amount, false, false));
        return agreements.length-1;
    }

    function deposit (uint _id) public payable onlyPlayers(_id) {
        if(msg.sender==agreements[_id].player1){
            require(msg.value == agreements[_id].amount, "Amount is not as per the terms.");
            agreements[_id].player1Paid = true;
        }
        if(msg.sender==agreements[_id].player2){
            require(msg.value == agreements[_id].amount, "Amount is not as per the terms.");
            agreements[_id].player2Paid = true;
        }
    }

    function refund (uint _id) public payable onlyPlayers(_id) {
        if(msg.sender==agreements[_id].player1){
            require(agreements[_id].player1Paid, "You have not paid yet.");
            agreements[_id].player1Paid = false;
            payable(agreements[_id].player1).transfer(agreements[_id].amount);
        }
        if(msg.sender==agreements[_id].player2){
            require(agreements[_id].player2Paid, "You have not paid yet.");
            agreements[_id].player2Paid = false;
            payable(agreements[_id].player2).transfer(agreements[_id].amount);
        }
    }

    function complete (uint _id, address payable winner) public payable onlyController(_id) {
        if(winner == agreements[_id].player1){
            require(agreements[_id].player1Paid, "Player1 has not paid yet.");
            payable(agreements[_id].player1).transfer(agreements[_id].amount*2);
            agreements[_id].amount = 0;
        }
        if(winner == agreements[_id].player2){
            require(agreements[_id].player2Paid, "Player2 has not paid yet.");
            payable(agreements[_id].player2).transfer(agreements[_id].amount*2);
            agreements[_id].amount = 0;
        }
    }
}