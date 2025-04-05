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
      - name: citizenId
        type: String
        category: identifier
        sequence: 1
        init: ''
        essential: true
        sensitive: false
      - name: firstName
        type: String
        category: required
        sequence: 2
        init: ''
        essential: true
        sensitive: false
      - name: lastName
        type: String
        category: required
        sequence: 3
        init: ''
        essential: true
        sensitive: false
  - name: Proposal
    attributes:
      - name: proposalId
        type: String
        category: identifier
        sequence: 1
        init: ''
        essential: true
        sensitive: false
      - name: title
        type: String
        category: required
        sequence: 2
        init: ''
        essential: true
        sensitive: false
      - name: description
        type: String
        category: optional
        sequence: 3
        init: ''
        
        sensitive: false
  - name: Vote
    attributes:
      - name: voteId
        type: String
        category: identifier
        sequence: 1
        init: ''
        essential: true
        sensitive: false
      - name: voteValue
        type: String
        category: required
        sequence: 2
        init: ''
        essential: true
        sensitive: false

relations:
  - from: Citizen
    to: Proposal
    fromToName: proposed
    fromToMin: 1
    fromToMax: '*'
    toFromName: proposer
    toFromMin: 1
    toFromMax: 1
    fromToId: false
    toFromId: false
    internal: false
    
  - from: Citizen
    to: Vote
    fromToName: castedVote
    fromToMin: 1
    fromToMax: '*'
    toFromName: voter
    toFromMin: 1
    toFromMax: 1
    fromToId: false
    toFromId: false
    internal: false
    
  - from: Proposal
    to: Vote
    fromToName: receivedVote
    fromToMin: 0
    fromToMax: '*'
    toFromName: proposal
    toFromMin: 1
    toFromMax: 1
    fromToId: false
    toFromId: false
    internal: false
    

''';
  