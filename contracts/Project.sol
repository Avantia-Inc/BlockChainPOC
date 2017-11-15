pragma solidity ^0.4.2;

import './zeppelin/lifecycle/Killable.sol';

contract Project is Killable {

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
    mapping(address => StatementOfWork) public submittedBids;
    address acceptedVendor;

    enum State { Open, Sold, Complete }
    State public state;

    function Project(bytes32 projectName) public {
        name = projectName; 
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

    function submitBid(uint estimatedCompletionDate, uint estimatedHours, uint hourlyRate) 
        inState(State.Open) // must not be sold or complete
        onlyVendor // must not be the client placing the bid
        public 
    {
        submittedBids[msg.sender] = StatementOfWork({
            estimatedCompletionDate: estimatedCompletionDate, 
            estimatedHours: estimatedHours, 
            reportedHours: 0, 
            hourlyRate: hourlyRate, 
            vendor: msg.sender, 
            accepted: false, 
            delivered: false
        });
    }

    function acceptBid(address vendor) 
        payable // ether is transferred to the contract as escrow
        inState(State.Open) // must not be already sold or completed
        onlyOwner // must be the client accepting their own project.
        public
    {
        StatementOfWork storage bid = submittedBids[vendor];

        // the client must send ether equal to that of the project cost.
        require(msg.value == bid.estimatedHours * bid.hourlyRate); 

        bid.accepted = true;
        state = State.Sold;
        vendor = bid.vendor;
    }
    
    function RecordHours(uint hoursWorked) onlyAcceptedVendor public {
        StatementOfWork storage sow = submittedBids[msg.sender];
        sow.reportedHours += hoursWorked;
    }

    function completeProject() 
        inState(State.Sold)
        onlyOwner
        public
    {

        StatementOfWork storage sow = submittedBids[acceptedVendor];
        require(sow.delivered);

        // set the state before any attempt of transfer, otherwise the
        // user could call this function many times and get more ether.
        state = State.Complete;
        
        acceptedVendor.transfer(TotalDue());
    }

    function CollectRefund()
        inState(State.Complete)
        onlyOwner
        public
    {
        msg.sender.transfer(this.balance);
    }

    function TotalDue() constant public returns (uint totalDue) {
        if (acceptedVendor == 0x0) {
            totalDue = 0;
        } else {
            StatementOfWork storage sow = submittedBids[acceptedVendor];

            if (sow.reportedHours <= sow.estimatedHours) {
                totalDue = sow.reportedHours * sow.hourlyRate;
            } else {
                totalDue = sow.estimatedHours * sow.hourlyRate;
            }
        }
    }
}