pragma solidity ^0.4.2;

import "./Project.sol";

contract ProjectRepository {
    mapping(address => Project[]) private projects;

    function createNewProject(bytes32 _name, uint _biddingEnd, uint _revealEnd) public {
        projects[msg.sender].push(new Project(_name, _biddingEnd, _revealEnd));
    }

    function myProjects() public view returns (Project[] _myProjects) {
        return projects[msg.sender];
    }

    function projectAt(uint index) public view returns (Project _project) {
        return projects[msg.sender][index];
    }
}