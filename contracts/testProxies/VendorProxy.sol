pragma solidity ^0.4.2;

import '../zeppelin/lifecycle/Killable.sol';
import '../Project.sol';

contract VendorProxy is Killable {
    function sendProjectBid(Project project, bytes32 bid) public {
        project.submitBid(bid);
    }

    function revealProjectBid(Project project, uint estimatedCompletionDate, uint estimatedHours, uint hourlyRate) public {
        project.revealBid(estimatedCompletionDate, estimatedHours, hourlyRate);
    }
}