// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract croudFundin {
    mapping (address => uint) private donation;
    uint public tergetAmount;
    uint public time;
    address private manager;
    uint private totalAmount;
    uint public minimumAmount;
    uint public numberofDonater;
    uint public yesVoteCount;
    bool public votingStart;
    string public votingReason;
    uint public amount;

    constructor(uint _tergetAmount, uint _time, uint _minAmount){
        tergetAmount = _tergetAmount;
        time=block.timestamp+_time;
        manager=msg.sender;
        minimumAmount = _minAmount;
    }

    function fund() payable public{
        require(tergetAmount > totalAmount && time > block.timestamp, "Terget amount raised or time over");
        require(msg.value >= minimumAmount, "Minimum amount has to be doneted");
        if(donation[msg.sender] == 0){
            numberofDonater++;
        }
        donation[msg.sender]+=msg.value;
    }
    function refund() public{
        require(tergetAmount > totalAmount && time < block.timestamp, "Terget achived no refund");
        address payable refundAddress = payable(msg.sender);
        refundAddress.transfer(donation[msg.sender]);
    }

    function voting(bool vote) public {
        require(donation[msg.sender] > 0, "Donate before u vote :)");
        require(votingStart, "Voating is yet to start ");
        if(vote){
            yesVoteCount++;
        }
    }

    function startVoting(string memory reason, uint _amount) public {
        require(msg.sender == manager, "Ask manager to start the voting");
        require(tergetAmount < totalAmount, "terget amount not raised");
        votingStart = true;
        votingReason = reason;
        amount = _amount;
    }

    function sendMony(address payable sendingTo) public{
        require(msg.sender==manager, "You have to have the manager previlage");
        require((yesVoteCount/numberofDonater)*100 > 50, "You can not transfer this fund according to public voting" );
        sendingTo.transfer(amount);
    }
}