// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingPoll {
    struct Option {
        uint256 voteCount;
        bool exists;
    }

    struct Poll {
        mapping(address => bool) hasVoted;
        mapping(uint256 => Option) options;
        uint256 optionCount;
        bool exists;
    }

    mapping(uint256 => Poll) public polls;
    uint256 public pollCount;

    event Voted(address indexed voter, uint256 indexed pollId, uint256 indexed optionId);

    function createPoll(uint256 _optionCount) external {
        pollCount++;
        polls[pollCount].optionCount = _optionCount;
        polls[pollCount].exists = true;
    }

    function vote(uint256 _pollId, uint256 _optionId) external {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID");
        require(polls[_pollId].exists, "Poll does not exist");
        require(_optionId > 0 && _optionId <= polls[_pollId].optionCount, "Invalid option ID");
        require(!polls[_pollId].hasVoted[msg.sender], "You have already voted in this poll");

        polls[_pollId].options[_optionId].voteCount++;
        polls[_pollId].hasVoted[msg.sender] = true;

        emit Voted(msg.sender, _pollId, _optionId);
    }

    function getOptionVoteCount(uint256 _pollId, uint256 _optionId) external view returns (uint256) {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID");
        require(polls[_pollId].exists, "Poll does not exist");
        require(_optionId > 0 && _optionId <= polls[_pollId].optionCount, "Invalid option ID");

        return polls[_pollId].options[_optionId].voteCount;
    }
}
