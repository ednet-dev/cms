# Domain-Specific Language (DSL) for ednet_core

## Overview

This DSL is designed to define domain models using defined YAML syntax. It allows the specification of
concepts, attributes, and relationships within a domain, facilitating the creation of robust and
interconnected data models.

## Motivation

The DSL aims to:

1. **Simplify** the representation of complex domain models.
2. **Ensure consistency** in how concepts and their relationships are defined.
3. **Facilitate easy parsing and validation** of models.

## Global Online Direct Democracy Domain Model Example

### YAML Syntax

#### Domain and Model

```yaml
domain: DirectDemocracy
model: GlobalModel
```

The `domain` and `model` fields specify the overarching context for the concepts and relationships.

#### Concepts

Concepts represent the key entities within the domain. Each concept can have multiple attributes.
- `name`: Name of the concept.
- `entry`: Indicates if the concept is an entry point for the model (aggregate root).
- `attributes`: List of attributes associated with the concept.

```yaml
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
```

##### Explanation of Attributes:

- `name`: The name of the attribute.
- `type`: The data type of the attribute (e.g., `String`, `int`, `double`, `bool`, `DateTime`).
- `category`: Specifies the role of the attribute (`identifier`, `required`, `optional`, `guid`).
    - `identifier`: Unique identifier for the concept.
    - `required`: Essential attribute that must be provided.
    - `optional`: Attribute that is not mandatory.
    - `guid`: Globally unique identifier.
- `sequence`: Order in which the attributes appear.
- `init`: Initial value for the attribute.
    - `''`: Empty string.
    - `increment`: Incremental value.
    - `empty`: Empty value.
- `essential`: Boolean indicating if the attribute is essential.
- `sensitive`: Boolean indicating if the attribute contains sensitive information.

#### Relations

Relations define how concepts are connected to each other.

```yaml
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
    
```

##### Explanation of Relations:

- `from`: Source concept of the relation.
- `to`: Target concept of the relation.
- `fromToName`: Name of the relation from the perspective of the source concept.
- `fromToMin`: Minimum number of connections from the source to the target.
- `fromToMax`: Maximum number of connections from the source to the target.
- `toFromName`: Name of the relation from the perspective of the target concept.
- `toFromMin`: Minimum number of connections from the target to the source.
- `toFromMax`: Maximum number of connections from the target to the source.
- `fromToId`: Boolean indicating if the relation from the source to the target is an identifier.
- `toFromId`: Boolean indicating if the relation from the target to the source is an identifier.
- `internal`: Boolean indicating if the relation is internal.
- `category`: Type of the relation (e.g., `association`, `inheritance`, `reflexive`, `twin`).

## Full Example

Here is the complete YAML for the global online direct democracy domain model:

```yaml
domain: DirectDemocracy
model: GlobalModel

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
    
```

## Explanation of the Example

1. **Concepts**:
    - **Citizen**: Represents a participant in the democracy system.
        - Attributes include `citizenId`, `firstName`, and `lastName`.
    - **Proposal**: Represents a proposal submitted by citizens.
        - Attributes include `proposalId`, `title`, and `description`.
    - **Vote**: Represents a vote casted by a citizen.
        - Attributes include `voteId` and `voteValue`.

2. **Relations**:
    - **Citizen to Proposal**: A citizen can propose multiple proposals (`proposed`), and each
      proposal is linked back to one proposer.
    - **Citizen to Vote**: A citizen can cast multiple votes (`castedVote`), and each vote is linked
      back to one voter.
    - **Proposal to Vote**: A proposal can receive multiple votes (`receivedVote`), and each vote is
      linked back to one proposal.

By defining these concepts and relations, the model captures the essential elements and their
interactions within the domain of

a global online direct democracy system. This structure ensures that data integrity is maintained
and relationships between entities are clearly understood.

---

This README should provide a comprehensive guide to using the DSL for defining domain models, along
with a concrete example to illustrate its application.