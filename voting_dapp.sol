// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }

    mapping (uint => Candidate) public candidate;
    mapping (address => bool) public voter;

    uint public candidateCount = 0;
    uint public startTime;
    uint public endTime;

    event VoteEvent(uint indexed_candidateId);

    constructor(uint _durationInMinutes){
        startTime = block.timestamp;
        endTime = startTime + (_durationInMinutes * 1 minutes);  

        addCandidate("Bob");
        addCandidate("Alice");
    }

    function addCandidate(string memory _name) private {
        candidateCount++;
        candidate[candidateCount] = Candidate({id: candidateCount, name: _name, voteCount: 0});
    }

    function vote(uint _candidateId) public {
        require(block.timestamp <= endTime && block.timestamp >= startTime, "Voting is not allowed at this time");
        require(!voter[msg.sender], "You have already voted!");
        require(_candidateId > 0 && _candidateId <= candidateCount, "You have entred invalid ID");

        voter[msg.sender] = true;
        candidate[_candidateId].voteCount++;

        emit VoteEvent(_candidateId);
    }

    function getAllCandidates() public view returns (Candidate[] memory) {
    Candidate[] memory candidateArray = new Candidate[](candidateCount);
    for(uint i = 1; i <= candidateCount; i++) {
        candidateArray[i - 1] = candidate[i];
    }
    return candidateArray;
}

    

    function getCandidateById(uint _candidateId) public view returns (Candidate memory){
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid ID");
        Candidate memory _candidate = candidate[_candidateId];
    }

    function getCurrentLeader() public view returns (string memory) {
        uint maxVotes = 0;
        uint leadingCandidateId = 0;

        for(uint i=1; i<= candidateCount; i++){
            if(candidate[i].voteCount > maxVotes) {
                maxVotes = candidate[i].voteCount;
                leadingCandidateId = i;
            }
        }
        
        return candidate[leadingCandidateId].name;
    }
    
   function getWinner() public view returns (string memory) {
        uint maxVotes = 0;
        string memory winner = "";
        for(uint i=1; i<= candidateCount; i++){
            if(candidate[i].voteCount > maxVotes) {
                return "No winner yet!";
            } else{
                winner = candidate[i].name;
            }
        }
    }
}