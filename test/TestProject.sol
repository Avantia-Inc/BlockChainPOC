pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProjectRepository.sol";
import "../contracts/Project.sol";
import "../contracts/testProxies/VendorProxy.sol";

contract TestProject {

  uint bidEnd = now + 1;
  uint bidReveal = bidEnd + 1;
  VendorProxy vendor = new VendorProxy();
  VendorProxy vendor2 = new VendorProxy();
  uint estimatedCompletionDate = now + 10000;
  uint estimatedHours = 500;
  uint hourlyRate = 300;
  bytes32 bid = keccak256(estimatedCompletionDate, estimatedHours, hourlyRate);

  function testProjectCreation() public {
    ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
    
    repo.createNewProject("new", bidEnd, bidReveal);
    
    Project myProject = repo.projectAt(0);

    Assert.equal(myProject.name(), "new", "Project name should match.");
  } 

  function testProjectBid() public {
      ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
      Project myProject = repo.projectAt(0);
           
      vendor.sendProjectBid(myProject, bid);
      
      Assert.equal(myProject.submittedBids(vendor), bid, "Added bid should match vendor address");
  }

  function testAnotherProjectBid() {
      ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
      Project myProject = repo.projectAt(0);
     
      bytes32 bid2 = "some other bid here";
      
      vendor2.sendProjectBid(myProject, bid2);
      
      Assert.equal(myProject.submittedBids(vendor2), bid2, "Added bid should match vendor address");
  }

  function testRevealBid() public {
     ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
     Project myProject = repo.projectAt(0);

     while (now < bidEnd) {
       // wait
     }

    vendor.revealProjectBid(myProject, estimatedCompletionDate, estimatedHours, hourlyRate); // TODO - real values here.
  
    var (revealedCompletionDate, revealedEstimatedHours, revealedReportedHours, revealedHourlyRate, revealedVendor, revealedAccepted, revealedDelivered) = myProject.revealedBids(vendor);

    Assert.equal(revealedCompletionDate, estimatedCompletionDate, "SOW completion date should match.");
    //Assert.equal(revealedEstimatedHours, estimatedHours, "SOW estimated hours should match.");
    //Assert.equal(revealedReportedHours, 0, "SOW reported hours should be 0.");
    //Assert.equal(revealedHourlyRate, hourlyRate, "SOW hourly rate should match.");
    //Assert.equal(revealedVendor, vendor, "SOW vendor should match.");
    //Assert.equal(revealedAccepted, false, "SOW accepted field should be false.");
    //Assert.equal(revealedDelivered, false, "SOW devliered field should be false.");
  }
}
