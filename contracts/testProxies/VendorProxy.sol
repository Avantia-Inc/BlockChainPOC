pragma solidity ^0.4.2;

import '../zeppelin/lifecycle/Killable.sol';
import '../Project.sol';

contract VendorProxy is Killable {
    function sendProjectBid(Project project, bytes32 bid) public {
        project.submitBid(bid);
    }
}