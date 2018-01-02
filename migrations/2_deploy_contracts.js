var Ownable = artifacts.require("./zeppelin/ownership/Ownable.sol");
var Killable = artifacts.require("./zeppelin/lifecycle/Killable.sol");
var Authentication = artifacts.require("./Authentication.sol");
var ProjectRepository = artifacts.require("./ProjectRepository.sol");
var Project = artifacts.require("./Project.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable, Killable);
  deployer.link(Ownable, Project);
  deployer.deploy(Killable);
  deployer.link(Killable, Authentication);
  deployer.deploy(Authentication);
  deployer.deploy(Project);
  deployer.link(Project, ProjectRepository);
  deployer.deploy(ProjectRepository);
};
