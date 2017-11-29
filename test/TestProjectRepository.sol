pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProjectRepository.sol";
import "../contracts/Project.sol";

contract TestProjectRepository {

  function testProjectCreation() {
    ProjectRepository repo = ProjectRepository(DeployedAddresses.ProjectRepository());
    
    repo.createNewProject("Test Project", 1511203271071, 1511203271071);
    
    Project myProject = repo.projectAt(0);

    Assert.equal(myProject.name(), "Test Project", "Project name should match.");
  }
}
