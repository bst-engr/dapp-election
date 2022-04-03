pragma solidity ^0.5.16;

contract Election {
    //Model a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    //Constituency Model
    struct Constituency {
        uint id;
        string name;
        uint candidateCount;
        mapping(uint => Candidate) candidates;
        mapping(address => bool) voters;
    }

    mapping(uint => Constituency) public constituencies;

    uint public constituencyCount;
    // Store accounts that have voted
    mapping(address => bool) public voters;
    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    // Constructor
    constructor () public {
        addConstituency("NA1", ["Candidate 1", "Candidate 2", "Candidate 3"]);
        addConstituency("NA2", ["Candidate 4", "Candidate 5"]);
    }
    function addConstituency (string memory _name, array memory candidateList) private {
        constituencyCount++;
        constituencies[constituencyCount] = Constituency(constituencyCount, _name, 0);
        //Add Candidates
        constituencies[constituencyCount].candidateCount++;
        for(var i=0; i<candidateList.length; i++) {
            addCandidate(candidateList[i], constituencyCount);
        }
    }
    function addCandidate (string memory _name, uint memory _constituencyId) private {
        constituencies[_constituencyId].candidateCount++;
        constituencies[_constituencyId][candidates][constituencies[constituencyCount].candidateCount] = Candidate(_name);
    }

    function vote (uint _constituencyId, uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= constituencies[_constituencyId].candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        constituencies[_constituencyId].candidates[_candidateId].voteCount ++;
        // trigger voted event
        emit votedEvent(_candidateId);
    }
}