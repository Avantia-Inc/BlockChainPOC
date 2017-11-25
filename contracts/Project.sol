pragma solidity ^0.4.2;

import './zeppelin/ownership/Ownable.sol';

contract Project is Ownable {

    struct StatementOfWork {
        uint estimatedCompletionDate;
        uint estimatedHours;
        uint reportedHours;
        uint hourlyRate;
        address vendor;
        bool accepted;
        bool delivered;
    }

    bytes32 public name;
    mapping(address => bytes32) public submittedBids;
    mapping(address => StatementOfWork) public revealedBids;
    address public acceptedVendor;

    enum State { Open, Sold, Delivered, Complete }
    State public state;

    uint public biddingEnd;
    uint public revealEnd;

    function Project(bytes32 _name, uint _biddingEnd, uint _revealEnd) public {
        name = _name; 
        biddingEnd = _biddingEnd;
        revealEnd = _revealEnd;
        state = State.Open;
    }

    // For simplicity, any address that is not the project creator's address is considered a vendor.
    modifier onlyVendor() {
        require(msg.sender != owner);
        _;
    }

    modifier onlyAcceptedVendor() {
        require(msg.sender == acceptedVendor);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    modifier onlyBefore(uint _time) {
        require(now < _time); 
        _; 
    }

    modifier onlyAfter(uint _time) {
        require(now > _time); 
        _; 
    }

    function submitBid(uint estimatedCompletionDate, uint estimatedHours, uint hourlyRate)
        inState(State.Open) // must not be sold or complete
        onlyBefore(biddingEnd) // before scheduled bidding end time
        onlyVendor // must not be the client placing the bid
        public
    {
        submittedBids[msg.sender] = keccak256(estimatedCompletionDate, estimatedHours, hourlyRate);
    }

    function revealBid(uint estimatedCompletionDate, uint estimatedHours, uint hourlyRate) 
        inState(State.Open) // must not be sold or complete
        onlyAfter(biddingEnd) // after scheduled bidding end time
        onlyBefore(revealEnd) // but before scheduled reveal end time
        onlyVendor // must not be the client placing the bid
        public
    {
        bytes32 bid = submittedBids[msg.sender];
        bytes32 reveal = keccak256(estimatedCompletionDate, estimatedHours, hourlyRate);

        require(bid == reveal);

        revealedBids[msg.sender] = StatementOfWork({
            estimatedCompletionDate: estimatedCompletionDate, 
            estimatedHours: estimatedHours, 
            reportedHours: 0, 
            hourlyRate: hourlyRate, 
            vendor: msg.sender, 
            accepted: false, 
            delivered: false
        });

        // TODO: add event
    }

    function acceptBid(address vendor) 
        payable // ether is transferred to the contract as escrow
        inState(State.Open) // must not be already sold or completed
        onlyOwner // must be the client accepting their own project.
        public
    {
        StatementOfWork storage bid = revealedBids[vendor];

        // the client must send ether equal to that of the project cost.
        require(msg.value == bid.estimatedHours * bid.hourlyRate); 

        bid.accepted = true;
        state = State.Sold;
        acceptedVendor = bid.vendor;
        // TODO: add event
    }
    
    function recordHours(uint hoursWorked) 
        inState(State.Sold)
        onlyAcceptedVendor 
        public 
    {
        StatementOfWork storage sow = revealedBids[msg.sender];
        sow.reportedHours += hoursWorked;
    }

    function markDelivery() 
        inState(State.Sold) 
        onlyAcceptedVendor
        public 
    {
        StatementOfWork storage sow = revealedBids[msg.sender];
        sow.delivered = true;
        state = State.Delivered;
        // TODO: add delivered event
    }

    function completeProject() 
        inState(State.Delivered)
        onlyOwner
        public
    {
        //StatementOfWork storage sow = revealedBids[acceptedVendor];
        //require(sow.delivered);

        // set the state before any attempt of transfer, otherwise the
        // user could call this function many times and get more ether.
        state = State.Complete;
        
        uint refund = this.balance - totalDue();
        if (refund > 0) {
            msg.sender.transfer(refund);
        }
        
        // TODO: added completed event
    }

    function withdrawPayment()
        inState(State.Complete)
        onlyAcceptedVendor
        public
    {
        msg.sender.transfer(this.balance);
    }

    function totalDue() constant public returns (uint amount) {
        if (acceptedVendor == 0x0) {
            amount = 0;
        } else {
            StatementOfWork storage sow = revealedBids[acceptedVendor];

            if (sow.reportedHours <= sow.estimatedHours) {
                amount = sow.reportedHours * sow.hourlyRate;
            } else {
                amount = sow.estimatedHours * sow.hourlyRate;
            }
        }
    }

    function kill() 
        inState(State.Open) // if state is sold to end early vendor records any hours, marks their work delivered, and contract is completed normally
        onlyOwner
        public
    {
        // Remaining balance is refunded to owner
        selfdestruct(owner);
    }
}