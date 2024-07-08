part of democracy_direct;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/democracy/direct/json/model.dart

var democracyDirectModelJson = r'''
domain: democracy
model: direct

concepts:
  - name: Citizen
    entry: true
    attributes:
      - name: firstName
      - name: lastName
      - name: email

  - name: Proposal
    attributes:
      - name: title
        category: required
        essential: true
      - name: description

  - name: Vote
    attributes:
      - name: voteValue
        category: required
        essential: true

  - name: Comment
    attributes:
      - name: text
        category: required
        essential: true

  - name: Election
    entry: true
    attributes:
      - name: title
        category: required
        essential: true
      - name: description

  - name: Message
    attributes:
      - name: text
        category: required
        essential: true
      - name: status
        category: required
        essential: true
        default: 'unread'

relations:
  - from: Citizen
    to: Proposal
    fromToName: proposed
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: proposer
    toFromMin: "1"
    toFromMax: "1"

  - from: Citizen
    to: Vote
    fromToName: castedVotes
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: voter
    toFromMin: "1"
    toFromMax: "1"

  - from: Proposal
    to: Vote
    fromToName: receivedVotes
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: proposal
    toFromMin: "1"
    toFromMax: "1"

  - from: Citizen
    to: Comment
    fromToName: commented
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: commenter
    toFromMin: "1"
    toFromMax: "1"

  - from: Comment
    to: Comment
    fromToName: reply
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: replyTo
    toFromMin: "1"
    toFromMax: "1"

  - from: Proposal
    to: Comment
    fromToName: comments
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: replyTo
    toFromMin: "1"
    toFromMax: "1"

  - from: Election
    to: Vote
    fromToName: castedVote
    fromToMin: "0"
    fromToMax: 'N'
    toFromName: election
    toFromMin: "1"
    toFromMax: "1"

  - from: Citizen
    to: Message
    fromToName: sentMessages
    fromToMin: "0"
    fromToMax: "N"
    toFromName: owner
    toFromMin: "1"
    toFromMax: "1"

  - from: Citizen
    to: Message
    fromToName: receivedMessages
    fromToMin: "0"
    fromToMax: "N"
    toFromName: recipient
    toFromMin: "1"
    toFromMax: "1"

  - from: Citizen
    to: Election
    fromToName: elections
    fromToMin: "0"
    fromToMax: "N"
    toFromName: candidate
    toFromMin: "1"
    toFromMax: "1"






''';
  