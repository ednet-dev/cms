# TDD Memory - Ednet Core Library

## Context Summary
- This is a Test-Driven Development (TDD) implementation for the `ednet_core` library
- Located in `/Users/slavisam/projects/cms/packages/core`
- Current focus: Creating a comprehensive simulation of Serbian electoral processes
- Recent progress: Implemented basic tests for Entity components, OID, and Entities filtering
- Next focus: EDNetOne simulation framework for Serbian elections

## AI Assistant Role
- Implement TDD approach for the `ednet_core` library
- Create and maintain test files following TDD principles
- Track progress and plan next steps in this memory file
- Ensure comprehensive test coverage
- Follow RGR (Red-Green-Refactor) cycle
- Document test cases clearly
- Maintain test isolation
- Always commit with semantic message scoped to core when having green run
- Use examples from the domain of direct democracy for all tests
  - EDNet stands for "Explicit Democracy Network"
  - Focus on concepts like Citizen, Vote, Bill, Decision, Initiative, Referendum, etc.
  - Model relationships that reflect democratic processes and structures
  - Ensure examples demonstrate real-world democratic scenarios

## EDNetOne Serbian Election Simulation

### Overview
We are creating a realistic simulation of the Serbian electoral process using the EDNetOne domain model. This will serve as a comprehensive test suite demonstrating the capabilities of the ednet_core library while simulating a real-world election system with realistic data.

### Serbian Electoral System Context
- Multi-level elections (national, provincial, local)
- Proportional representation system with 3% threshold (except for minority parties)
- 250 members in National Assembly elected from party lists
- Provincial Assembly of Vojvodina with 120 seats
- Local municipal/city assemblies with varying seat numbers
- Several types of elections: parliamentary, presidential, provincial, local
- Voter turnout statistics from recent elections (approx. 50-60%)
- Demographic distribution based on 2022 census data

### Simulation Requirements

#### Domain Model Components
1. **Electoral Entities**
   - Voters (Serbian citizens with voting rights, approx. 6.5 million)
   - Candidates (Individual politicians)
   - Political Parties (Including coalitions)
   - Electoral Lists (Party lists for proportional representation)
   - Electoral Units (Polling stations, municipalities, districts)
   - Electoral Commissions (National, provincial, local)
   - Observers (Domestic and international)

2. **Electoral Processes**
   - Voter Registration
   - Candidate Registration
   - Campaign Period
   - Voting Process
   - Vote Counting
   - Mandate Allocation (D'Hondt method for proportional representation)
   - Result Verification
   - Election Disputes Resolution

3. **Data Requirements**
   - Serbian demographic distribution (age, gender, region)
   - Geographic data (districts, municipalities, polling stations)
   - Political landscape (parties, coalitions, candidates)
   - Historical voting patterns
   - Electoral thresholds and rules

### Implementation Plan

#### Phase 1: Core Domain Model Setup (Next Immediate Actions)
1. Create `test/ednet_one/serbian_election_simulation_test.dart`
2. Implement the Serbian election domain model extending the basic EDNetOne model:
   - Define `SerbianCitizen` entity with demographic attributes
   - Define `PoliticalParty` and `Coalition` entities
   - Define `ElectoralList` entity
   - Define `ElectoralUnit` hierarchy (polling station, municipality, district)
   - Define `Ballot` and `Vote` entities specific to Serbian elections

3. Create realistic data generation functions:
   - `generateSerbianPopulation()` - Create realistic voter demographics
   - `generateSerbianPoliticalLandscape()` - Create parties and coalitions
   - `generateElectoralUnits()` - Create geographic electoral structure

#### Phase 2: Parliamentary Election Simulation
1. Implement registration process for voters and candidates
2. Implement voting simulation with realistic participation rates
3. Implement D'Hondt method for seat allocation
4. Implement result analysis and visualization

#### Phase 3: Multi-level Election Simulation
1. Extend the simulation to include presidential elections
2. Add provincial elections (Vojvodina)
3. Add local elections for selected municipalities

#### Phase 4: Advanced Scenario Simulation
1. Implement "what-if" scenarios for different voter turnout
2. Simulate electoral reform scenarios
3. Implement historical comparison with past elections

### Detailed Specifications for Serbian Election Domain Model

#### SerbianCitizen Entity
- Attributes:
  - `name` (String, required): Full name
  - `jmbg` (String, required): Unique citizen ID number (13 digits)
  - `birthDate` (DateTime, required): Date of birth
  - `gender` (String, required): Gender
  - `municipality` (String, required): Municipality of residence
  - `pollingStation` (Reference): Assigned polling station
  - `hasVoted` (Boolean): Voting status in current election
  - `politicalPreference` (Reference, optional): Preferred party/coalition

#### PoliticalParty Entity
- Attributes:
  - `name` (String, required): Official party name
  - `abbreviation` (String, required): Party abbreviation/acronym
  - `foundingDate` (DateTime): Date of establishment
  - `ideology` (String): Political orientation
  - `isMinorityParty` (Boolean): Whether party represents a national minority
  - `leaderName` (String): Name of party leader
  - `memberCount` (Integer): Approximate number of members

#### ElectoralList Entity
- Attributes:
  - `name` (String, required): Official list name
  - `number` (Integer, required): Ballot number
  - `parties` (References): Component parties/coalitions
  - `candidates` (References): Candidates on the list (ordered)
  - `isMinorityList` (Boolean): Whether list represents national minority
  - `votes` (Integer): Total votes received
  - `seatCount` (Integer): Total seats won

#### ElectoralUnit Entity
- Attributes:
  - `name` (String, required): Unit name
  - `code` (String, required): Unique identifier
  - `level` (String, required): National/Provincial/Local
  - `parentUnit` (Reference, optional): Higher-level electoral unit
  - `population` (Integer): Population count
  - `registeredVoters` (Integer): Number of registered voters
  - `actualVoters` (Integer): Number of actual voters (turnout)

#### Vote Entity
- Attributes:
  - `electoralList` (Reference, required): Chosen electoral list
  - `electoralUnit` (Reference, required): Electoral unit where vote was cast
  - `timestamp` (DateTime, required): Time of voting
  - `isValid` (Boolean, required): Whether vote is valid
  - `isProcessed` (Boolean, required): Whether vote has been counted

### Next Immediate Actions (Serbian Election Simulation)

#### Priority 1: D'Hondt Method Implementation
1. **Implement D'Hondt Calculator**
   - Create `DhondtCalculator` class for seat allocation
   - Implement core algorithm with proper rounding
   - Handle special cases for minority lists
   - Add validation against real Serbian election results
   - Test cases:
     - Basic seat allocation
     - Minority party special cases
     - Tie-breaking scenarios
     - Edge cases (single party, all equal votes)

#### Priority 2: Electoral Threshold Implementation
1. **Implement Threshold Rules**
   - Add 3% threshold validation for regular parties
   - Implement special handling for minority parties
   - Create coalition vote aggregation logic
   - Test cases:
     - Regular party above/below threshold
     - Minority party exemption
     - Coalition threshold calculation
     - Vote redistribution after threshold application

#### Priority 3: Polling Station Operations
1. **Implement Polling Station Workflow**
   - Create polling station state machine
   - Add time-based operations (opening/closing)
   - Implement voter verification process
   - Add invalid ballot handling
   - Test cases:
     - Station opening/closing procedures
     - Voter processing workflow
     - Invalid ballot scenarios
     - Real-time turnout tracking

#### Priority 4: Voter Turnout Simulation
1. **Implement Turnout Generator**
   - Create demographic-based turnout patterns
   - Add time-of-day voting distribution
   - Implement regional variation handling
   - Test cases:
     - Demographic group turnout rates
     - Time-based voting patterns
     - Regional participation differences
     - Early voting simulation

### Current Implementation Focus
Working on Priority 1: D'Hondt Method Implementation
- Creating test cases for seat allocation
- Implementing core algorithm
- Validating against historical election data

## Ednet Core TDD Test Plan

## Core Components
- [ ] Core Repository
  - [ ] Basic repository operations
  - [ ] Transaction handling
  - [ ] Error handling

## Domain Modeling
- [x] Model
  - [x] Basic initialization
  - [x] Domain association
  - [x] Policy components initialization
  - [x] Concept management
    - [x] Basic concept creation
    - [x] Entry concept handling
    - [x] Parent-child relationships
  - [ ] Model validation

- [ ] Concept
  - [x] Basic initialization
  - [x] Default values
  - [x] Collection management
  - [x] Attribute management
    - [x] Type validation
    - [x] Required attribute validation
    - [x] String length validation
    - [x] Derived attribute validation
    - [x] Increment validation
    - [x] Email format validation
  - [x] Parent/Child relationship validation
  - [ ] Policy integration
- [ ] Serializable
  - [ ] Serialization/deserialization
  - [ ] Error handling

## Entity Components
- [x] OID (Object ID)
  - [x] Generation
  - [x] Comparison
  - [x] Validation
- [x] Entity
  - [x] Creation
  - [x] Modification
  - [x] Attribute setting/getting
  - [x] Code handling and utilities
  - [x] Copying
  - [x] Type conversion
  - [x] Reference management
- [x] Entity Relationships
  - [x] Parent-child relationships
  - [x] Reference handling
  - [x] Validation of required relationships
- [x] Entities
  - [x] Collection operations
  - [x] Validation logic
  - [x] Filtering
  - [x] Sorting

## Commands
- [x] Add Command
  - [x] Command execution
  - [x] Validation
- [x] Remove Command
  - [x] Command execution
  - [x] Validation
- [x] Set Attribute Command
  - [x] Command execution
  - [x] Validation
- [ ] Transaction
  - [ ] Transaction management
  - [ ] Rollback handling
- [ ] Past Command
  - [ ] Command history
  - [ ] Replay functionality

## Policy Components
- [ ] Attribute Policy
  - [ ] Policy evaluation
  - [ ] Validation
- [ ] Composite Policy
  - [ ] Policy combination
  - [ ] Evaluation
- [ ] Entity Policies
  - [ ] Policy management
  - [ ] Application
- [ ] Policy Engine
  - [ ] Policy execution
  - [ ] Error handling
- [ ] Time Based Policy
  - [ ] Time-based evaluation
  - [ ] Validation

## Error Handling
- [x] Validation Exceptions
  - [x] Exception types
  - [x] Error messages
  - [ ] Stack traces

## Model Components
- [ ] Model Entries
  - [ ] Entry management
  - [ ] Validation
  - [ ] Operations

## Serbian Election Simulation
- [ ] Domain Model
  - [ ] SerbianCitizen entity
  - [ ] PoliticalParty entity
  - [ ] ElectoralList entity
  - [ ] ElectoralUnit entity
  - [ ] Vote entity
- [ ] Data Generation
  - [ ] Demographics generation
  - [ ] Political landscape generation
  - [ ] Electoral units generation
- [ ] Election Processes
  - [ ] Registration simulation
  - [ ] Voting simulation
  - [ ] Vote counting
  - [ ] Mandate allocation
  - [ ] Result analysis

## Current Status
- Next test to implement: Serbian Election Simulation domain model and initial data generators
- Current phase: Setting up realistic simulation environment
- Last completed test: Entities filtering and sorting tests
- Recent addition: Comprehensive plan for Serbian Election Simulation

## Completed Tests
1. Model Testing - Basic Initialization (✓)
   - Empty concepts initialization
   - Domain and code assignment
   - Policy components initialization
   - Domain models registration

2. Concept Testing - Basic Functionality (✓)
   - Default values
   - Model association
   - Entry concept handling
   - Parent-child relationships

3. Attribute Validation Testing (✓)
   - Type validation 
   - Required attribute validation
   - String length validation
   - Derived attribute validation
   - Attribute increment validation
   - Email format validation
   - DateTime and Boolean validation

4. Entity Testing - Using Direct Democracy Domain (✓)
   - Citizen entity creation and initialization
   - Attribute setting and getting
   - Code handling and string representation
   - Entity copying

5. Entity Relationships Testing - Using Direct Democracy Domain (✓)
   - Vote entity requiring Citizen and Referendum parents
   - Validation of required relationships
   - Basic tests of parent-child relationships

6. Add Command Testing - Using Direct Democracy Domain (✓)
   - Add citizen command execution
   - Undo/redo functionality
   - Transaction grouping
   - Validation handling
   - Past interface interaction

7. Remove Command Testing - Using Direct Democracy Domain (✓)
   - Remove citizen command execution
   - Undo/redo functionality
   - Transaction grouping
   - Handling of nonexistent entities
   - Remove-Add-Remove sequence

8. Set Attribute Command Testing - Using Direct Democracy Domain (✓)
   - Set attribute command execution
   - Preservation of before value
   - Undo/redo functionality
   - Transaction grouping
   - Setting null/empty values
   - Sequential attribute changes

9. Transaction Testing - Using Direct Democracy Domain (✓)
   - Transaction with valid commands
   - Transaction rollback with invalid commands
   - Undo/redo transaction
   - Transaction with different command types

10. Past Command Testing - Using Direct Democracy Domain (✓)
    - Command tracking
    - Undo/redo functionality
    - History clearing
    - History management after undo

11. OID Testing - Using Direct Democracy Domain (✓)
    - OID generation
    - OID comparison and equality
    - Timestamp handling
    - OID entity lookup operations
    - String representation

12. Entities Filtering and Sorting - Using Direct Democracy Domain (✓)
    - Basic filtering with selectWhere method
    - Complex filtering with multiple conditions
    - Attribute-based filtering with selectWhereAttribute
    - Collection sorting with order method
    - Iteration and transformation with map and where
    - Operation chaining for complex queries

## Next Steps
1. Create the Serbian Election Simulation test directory and initial files
2. Implement the domain model for the Serbian election system
3. Develop realistic data generators for demographics and political landscape
4. Implement tests for the electoral process components
5. Create comprehensive simulation scenarios

## Technical Debt and Improvements
- The entity and entities tests still have some failing tests that need fixing
- Consider creating a separate test util package for test helpers
- Consider extracting domain specific validation into policy components
- Create visualization helpers to aid in understanding test scenarios
- Enhance domain model with more business rules and constraints

test(core): add comprehensive Serbian election simulation plan

- Add detailed specifications for Serbian electoral system simulation
- Define domain model for Serbian election entities and processes
- Create implementation plan with phased approach
- Detail realistic data requirements for demographic and political modeling
- Specify next immediate actions for Serbian election simulation implementation 