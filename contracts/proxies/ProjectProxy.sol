pragma solidity ^0.4.2;

import "../Project.sol";

contract ProjectProxy is Project {
    function ProjectProxy(bytes32 _name, uint _biddingEnd, uint _revealEnd)
        Project(_name, _biddingEnd, _revealEnd)
        public
    { 

    }

    function setBiddingEnd(uint end) onlyOwner public {
        biddingEnd = end;
    }

    function setRevealEnd(uint end) onlyOwner public {
        revealEnd = end;
    }
}