# Ednet Core TDD Test Plan

## Core Components
- [ ] Core Repository
  - [ ] Basic repository operations
  - [ ] Transaction handling
  - [ ] Error handling

## Domain Modeling
- [ ] Serializable
  - [ ] Serialization/deserialization
  - [ ] Error handling

## Entity Components
- [ ] OID (Object ID)
  - [ ] Generation
  - [ ] Comparison
  - [ ] Validation
- [ ] Entity
  - [ ] Creation
  - [ ] Modification
  - [ ] Deletion
  - [ ] Validation
- [ ] Entities
  - [ ] Collection operations
  - [ ] Filtering
  - [ ] Sorting

## Commands
- [ ] Add Command
  - [ ] Command execution
  - [ ] Validation
- [ ] Remove Command
  - [ ] Command execution
  - [ ] Validation
- [ ] Set Attribute Command
  - [ ] Command execution
  - [ ] Validation
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
- [ ] Validation Exceptions
  - [ ] Exception types
  - [ ] Error messages
  - [ ] Stack traces

## Model Components
- [ ] Model Entries
  - [ ] Entry management
  - [ ] Validation
  - [ ] Operations

## Current Status
- Next test to implement: Model Testing
- Current phase: Initial setup
- Last completed test: None

## Notes
- Focus on one component at a time
- Follow RGR (Red-Green-Refactor) cycle
- Ensure comprehensive test coverage
- Document test cases clearly
- Maintain test isolation 