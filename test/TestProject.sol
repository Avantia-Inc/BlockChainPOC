pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProjectRepository.sol";
import "../contracts/Project.sol";
import "../contracts/testProxies/VendorProxy.sol";

contract TestProject {

  function testProjectCreation() public {
    bytes32 bid = "some bid here";
    ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
    VendorProxy vendor = new VendorProxy();

    repo.createNewProject("new", now + 60, now + 120);
    Project myProject = repo.projectAt(0);
    vendor.sendProjectBid(myProject, bid);

    //mapping(address => bytes32) submittedBids = myProject.submittedBids();
    Assert.equal(myProject.submittedBids(vendor), bid, "Added bid should match vendor address");
  }
}
