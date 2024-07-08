### Democracy Tools
This pub package provides a set of tools for handling matters of direct democracy, including proposing, assignment, voting, discussing, and communicating.

## Installation
To use this package, add democracy_tools as a dependency in your pubspec.yaml file.

## Usage
To use the tools provided by this package, import the democracy_tools library and create an instance of the Democracy class.

'''
import 'package:democracy_tools/democracy_tools.dart';

void main() {
  var democracy = Democracy();
}
'''

## Proposing
To propose a new matter for consideration, use the propose method of the Democracy instance. This method takes a Proposal object, which contains the details of the proposal.

'''
democracy.propose(Proposal(
  title: 'New park in downtown',
  description: 'We propose building a new park in the downtown area to provide a green space for the community.',
  proposer: 'Jane Doe',
));
'''

## Assigning
To assign a matter to a committee, use the assign method of the Democracy instance. This method takes a Matter object, which contains the details of the matter, and a Committee object, which contains the details of the committee.

'''
democracy.assign(Matter(
  title: 'New park in downtown',
  description: 'We propose building a new park in the downtown area to provide a green space for the community.',
    proposer: 'Jane Doe',
), Committee(
    name: 'Parks and Recreation',
    members: ['Jane Doe', 'John Doe'],
    ));
'''

## Voting
To allow members of the community to vote on a proposal, use the vote method of the Democracy instance. This method takes the id of the proposal and the voter who is casting the vote.

'''
democracy.vote('1', 'Jane Doe');
'''

## Discussing
To facilitate discussion of a proposal, use the discuss method of the Democracy instance. This method takes the id of the proposal and a Comment object, which contains the details of the discussion.

'''
democracy.discuss('1', Comment(
    commenter: 'Jane Doe',
    comment: 'I think this is a great idea!',
));
'''
