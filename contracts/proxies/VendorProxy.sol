pragma solidity ^0.4.2;

import '../zeppelin/lifecycle/Killable.sol';
import "../Project.sol";

contract VendorProxy is Killable {
    bytes data;

    function sendProjectBid(Project project, bytes32 bid) public {
        project.submitBid(bid);
    }

    function revealProjectBid(Project project, uint estimatedCompletionDate, uint estimatedHours, uint hourlyRate) public {
        project.revealBid(estimatedCompletionDate, estimatedHours, hourlyRate);
    }

    function recordProjectHours(Project project, uint hoursWorked) public {
        project.recordHours(hoursWorked);
    }

    function markProjectDelivery(Project project) public {
        project.markDelivery();
    }

    //prime the data using the fallback function.
    function() public {
        data = msg.data;
    }

    function execute(address target) public returns (bool) {
        return target.call(data);
    }
}