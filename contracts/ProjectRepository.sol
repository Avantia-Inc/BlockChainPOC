pragma solidity ^0.4.2;

import "./Project.sol";

contract ProjectRepository {
    mapping(address => Project[]) private projects;

    function createNewProject(bytes32 _name, uint _biddingEnd, uint _revealEnd) public {
        projects[msg.sender].push(new Project(_name, _biddingEnd, _revealEnd));
        // TODO: project creation event
    }

    // Cannot return dynamic arrays to external callers so this function will only work when called from web3.js
    function myProjects() view public returns (Project[] _myProjects) {
        return projects[msg.sender];
    }

    function projectAt(uint index) view public returns (Project _project) {
        return projects[msg.sender][index];
    }
}