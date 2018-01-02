//var Project = artifacts.require("./Project.sol");
var ProjectRepository = artifacts.require("./ProjectRepository.sol");

contract('ProjectRepository', function(accounts) {
  it("...should create a project.", function() {
    return ProjectRepository.deployed().then(function(instance) {
      projectRepositoryInstance = instance; console.log("log message");

      return projectRepositoryInstance.createNewProject('Test Project', 1511203271071, 1511203271071, {from: accounts[0]});
    }).then(function() {
      
      projectRepositoryInstance.myProjects.call().then(function(results) {
          console.log(results.length);
      });
    }).catch(function(e){
      console.log("create project catch.");
    });
  });
});
