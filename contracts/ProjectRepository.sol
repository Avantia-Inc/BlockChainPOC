pragma solidity ^0.4.2;

import "./Project.sol";

contract ProjectRepository {
    mapping(address => Project[]) private projects;

    function createNewProject(bytes32 _name, uint _biddingEnd, uint _revealEnd) public {
        projects[msg.sender].push(new Project(_name, _biddingEnd, _revealEnd));
        //projects[msg.sender].push(0);
        //new Project(_name, _biddingEnd, _revealEnd);
        // TODO: project creation event
    }

    /*function createNewProject(address projectAddress) public {
        Project project = Project(projectAddress);
        projects[msg.sender].push(project);
    }*/

    // Cannot return dynamic arrays to external callers so this function will only work when called from web3.js
    function myProjects() view public returns (Project[] _myProjects) {
        return projects[msg.sender];
    }

    function projectAt(uint index) view public returns (Project _project) {
        return projects[msg.sender][index];
    }
}