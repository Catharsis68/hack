pragma solidity ^0.4.0;
contract DeliveryTimeManagement {

    struct Supplier {
      mapping (uint => DeliverySlot) slots;
      address deliverySlotId;
      bool isTradeable;
      string timeFrom;
      string timeTo;
      string timestamp;

      enum type;
      enum ActionChoices { Food, Nonfood, freezer }
      uint price;

      string gate;
      string warehouse;
    }

    struct Proposal {
      uint voteCount;
    }

    function getBlockTimestamp() constant returns (uint) // returns current block timestamp in SECONDS (not ms) from epoch
    {
    	return block.timestamp; 						 // also "now" == "block.timestamp", as in "return now;"
    }

    address warehouse;
    mapping(address => Supplier) suppliers;
    Proposal[] proposals;

    /// Create a new ballot with $(_numProposals) different proposals.
    function Ballot(uint8 _numProposals) public {
        warehouse = msg.sender;
        suppliers[warehouse].weight = 1;
        proposals.length = _numProposals;
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    function giveRightToVote(address toSupplier) public {
        if (msg.sender != warehouse || suppliers[toSupplier].voted) return;
        suppliers[toSupplier].weight = 1;
    }

    /// Delegate your vote to the voter $(to).
    function delegate(address to) public {
        Voter storage sender = suppliers[msg.sender]; // assigns reference
        if (sender.voted) return;
        while (suppliers[to].delegate != address(0) && suppliers[to].delegate != msg.sender)
            to = suppliers[to].delegate;
        if (to == msg.sender) return;
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegateTo = suppliers[to];
        if (delegateTo.voted)
            proposals[delegateTo.vote].voteCount += sender.weight;
        else
            delegateTo.weight += sender.weight;
    }

    /// Give a single vote to proposal $(toProposal).
    function vote(uint8 toProposal) public {
        Voter storage sender = suppliers[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
