pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Project.sol";

contract TestProject {

  function testProjectCreation() {
    Project project = new Project("Test Project", 1511203271071, 1511203271071);
  
    bytes32 expected = "Test Project";

    Assert.equal(project.name(), expected, "ERROR");
  }
}
