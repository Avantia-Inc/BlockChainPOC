pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/Project.sol";
import "../contracts/proxies/ProjectProxy.sol";
import "../contracts/proxies/VendorProxy.sol";

contract TestProject {
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

  function testProjectCreation() public {
    var myProject = new Project("test", now + 60, now + 120);

    Assert.equal(myProject.name(), "test", "project name should match");
    Assert.equal(myProject.biddingEnd(), now + 60, "biddingEnd should match");
    Assert.equal(myProject.revealEnd(), now + 120, "revealEnd should match");
    Assert.equal(uint(myProject.state()), 0, "state should be Open (0)");
  }

  function testProjectBid() public {
    var myProject = new Project("test", now + 60, now + 120);

    // a vendor can send bids
    vendor.sendProjectBid(myProject, "some bid string");

    // a client cannot send bids - limit gas so exception doesn't use all of our gas for this test
    var clientBidResult = myProject.call.gas(200000)("submitBid", "client bid string");

    Assert.equal(myProject.submittedBids(vendor), "some bid string", "Added bid should match vendor address");

    Assert.isFalse(clientBidResult, "client bid should fail");

    Assert.isZero(myProject.submittedBids(msg.sender), "client should not have bids");

    Assert.notEqual(msg.sender, address(vendor), "client and vendor are not equal");
  }

  function testBiddingEnded() public {
    var myProject = new Project("test", now - 60, now + 120);

    // bidding has ended so any bids should fail
    Project(address(vendor)).submitBid("bid string"); // prime the proxy
    var bidResult = vendor.execute.gas(200000)(myProject); // execute call and limit gas

    Assert.isFalse(bidResult, "bidding after bid end should fail");
  }

  function testRevealBid() public {

    var projectProxy = new ProjectProxy("proxy", bidEnd, bidReveal); // use project proxy to control uneditable Project state variables

    // add bid
    vendor.sendProjectBid(projectProxy, bid);

    // end bidding
    projectProxy.setBiddingEnd(now - 10);

    // reveal bid
    vendor.revealProjectBid(projectProxy, estimatedCompletionDate, estimatedHours, hourlyRate);

    var (revealedCompletionDate, revealedEstimatedHours, revealedReportedHours, revealedHourlyRate, revealedVendor, revealedAccepted, revealedDelivered) = projectProxy.revealedBids(vendor);

    Assert.equal(revealedCompletionDate, estimatedCompletionDate, "SOW completion date should match.");
    Assert.equal(revealedEstimatedHours, estimatedHours, "SOW estimated hours should match.");
    Assert.equal(revealedReportedHours, 0, "SOW reported hours should be 0.");
    Assert.equal(revealedHourlyRate, hourlyRate, "SOW hourly rate should match.");
    Assert.equal(revealedVendor, vendor, "SOW vendor should match.");
    Assert.equal(revealedAccepted, false, "SOW accepted field should be false.");
    Assert.equal(revealedDelivered, false, "SOW devliered field should be false.");
  }

  function testInvalidReveals() public {
    var projectProxy = new ProjectProxy("proxy", bidEnd, bidReveal);

    // add bid
    vendor.sendProjectBid(projectProxy, bid);

    // bidding not yet ended
    Project(address(vendor)).revealBid(estimatedCompletionDate, estimatedHours, hourlyRate); // prime proxy
    var result = vendor.execute.gas(200000)(projectProxy);
    Assert.isFalse(result, "can't reveal bid during bidding phase");

    // invalid reveal data
    projectProxy.setBiddingEnd(now - 60); // end bidding
    Project(address(vendor)).revealBid(estimatedCompletionDate, estimatedHours + 100, hourlyRate / 2); // prime proxy with invalid data
    result = vendor.execute.gas(200000)(projectProxy);
    Assert.isFalse(result, "bid should fail if invalid data passed in");

    // reveal has ended
    projectProxy.setRevealEnd(now - 10); // end reveal
    result = vendor.execute.gas(200000)(projectProxy);
    Assert.isFalse(result, "can't reveal bid after reveal phase");
  }

  function testAcceptBid() public {
    var projectProxy = setupProject(TestStage.Accept);

    projectProxy.acceptBid.value(estimatedHours * hourlyRate)(vendor);

    Assert.equal(projectProxy.acceptedVendor(), vendor, "vendor should be accepted");

    Assert.equal(uint(projectProxy.state()), 1, "state should be Sold (1)");
  }

  function testRecordHours() public {
    ProjectProxy projectProxy = setupProject(TestStage.RecordHours);

    vendor.recordProjectHours(projectProxy, 10);

    Assert.equal(projectProxy.totalDue(), 10 * hourlyRate, "total due should match 10 hours work");

    vendor.recordProjectHours(projectProxy, 5);

    Assert.equal(projectProxy.totalDue(), 15 * hourlyRate, "total due should match 15 hours work");
  }

  function setupProject(TestStage stage) private returns (ProjectProxy testObject) {    

    var projectProxy = new ProjectProxy("proxy", bidEnd, bidReveal); // use project proxy to control uneditable Project state variables

    // add bid
    vendor.sendProjectBid(projectProxy, bid);
    // reveal bid
    projectProxy.setBiddingEnd(now - 60); // end bidding

    if (stage == TestStage.Reveal) {
      return projectProxy;
    }

    vendor.revealProjectBid(projectProxy, estimatedCompletionDate, estimatedHours, hourlyRate);

    if (stage == TestStage.Accept) {
      return projectProxy;
    }

    projectProxy.acceptBid.value(estimatedHours * hourlyRate)(vendor);

    if (stage == TestStage.RecordHours) {
      return projectProxy;
    }
  }
}
