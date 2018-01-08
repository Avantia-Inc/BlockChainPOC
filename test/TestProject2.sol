pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/Project.sol";
import "../contracts/proxies/ProjectProxy.sol";
import "../contracts/proxies/VendorProxy.sol";

contract TestProject2 {
  // Truffle will send the TestContract one Ether after deploying the contract.
  uint public initialBalance = 1 ether;

  uint private bidEnd = now + 10;
  uint private bidReveal = bidEnd + 60;
  uint private estimatedCompletionDate = now + 10000;
  uint private estimatedHours = 500;
  uint private hourlyRate = 300;
  bytes32 private bid = keccak256(estimatedCompletionDate, estimatedHours, hourlyRate);
  VendorProxy private vendor = new VendorProxy();

  enum TestStage { Bid, Reveal, Accept, RecordHours, MarkDelivery, Complete, Withdrawl }

  function testInvalidRecordHours() public {
    ProjectProxy projectProxy = setupProject(TestStage.RecordHours);

    var vendor2 = new VendorProxy();
    Project(address(vendor2)).recordHours(10);
    var result = vendor2.execute.gas(200000)(projectProxy);
    Assert.isFalse(result, "non accepted vendor can't record hours");
  }

  function testMarkDelivery() public {
    ProjectProxy projectProxy = setupProject(TestStage.MarkDelivery);

    vendor.markProjectDelivery(projectProxy);

    Assert.equal(uint(projectProxy.state()), 2, "state should be Delivered (2)");

    var vendor2 = new VendorProxy();
    Project(address(vendor2)).markDelivery();
    var result = vendor2.execute.gas(200000)(projectProxy);
    Assert.isFalse(result, "non accepted vendor can't deliver");
  }

  function setupProject(TestStage stage) private returns (ProjectProxy testObject) {    

    var projectProxy = new ProjectProxy("proxy", bidEnd, bidReveal); // use project proxy to control uneditable Project state variables

    // add bid
    vendor.sendProjectBid(projectProxy, bid);
    // reveal bid
    projectProxy.setBiddingEnd(now - 60); // end bidding

    vendor.revealProjectBid(projectProxy, estimatedCompletionDate, estimatedHours, hourlyRate);

    projectProxy.acceptBid.value(estimatedHours * hourlyRate)(vendor);

    if (stage == TestStage.RecordHours) {
      return projectProxy;
    }

    vendor.recordProjectHours(projectProxy, 450);

    if (stage == TestStage.MarkDelivery) {
      return projectProxy;
    }
  }
}