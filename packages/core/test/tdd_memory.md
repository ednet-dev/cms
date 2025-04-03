# TDD Memory - Ednet Core Library

## Context Summary
- This is a Test-Driven Development (TDD) implementation for the `ednet_core` library
- Located in `/Users/slavisam/projects/cms/packages/core`
- Current focus: Command validation and execution
- Recent progress: Added tests for Add, Remove, and Set Attribute commands using direct democracy domain examples
- Next focus: Transaction validation and execution, Past command handling

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

## Semantic Commit Instructions
1. When completing a significant task or feature, update TDD Memory with progress
2. Generate a semantic commit message at the bottom of the TDD Memory file using the format:
   ```
   <type>(<scope>): <description>
   
   - <bullet points describing changes>
   ```
3. Where:
   - `<type>` is one of: feat, fix, docs, style, refactor, test, chore
   - `<scope>` should be "core" for ednet_core library
   - `<description>` is a concise summary of the changes
4. Execute the commit with the following commands:
   ```
   cd /Users/slavisam/projects/cms
   git add packages/core/
   git commit -m "<commit message from TDD Memory>"
   ```
5. Clear the commit message from TDD Memory after successful commit

# Ednet Core TDD Test Plan

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
- [ ] OID (Object ID)
  - [ ] Generation
  - [ ] Comparison
  - [ ] Validation
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
  - [ ] Filtering
  - [ ] Sorting

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

## Current Status
- Next test to implement: Transaction Validation and Past Command Handling
- Current phase: Command Implementation and Testing
- Last completed test: Set Attribute Command

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

## Next Steps
1. Implement Transaction tests with direct democracy examples:
   - Test transaction validation (e.g., required fields within transaction)
   - Test rollback handling when a command within a transaction fails
   - Complex nested transactions
2. Implement Past command tests:
   - Test undo/redo limits
   - Test clear history functionality
   - Test past reactions (if applicable)

## Notes
- Focus on one component at a time
- Follow RGR (Red-Green-Refactor) cycle
- Ensure comprehensive test coverage
- Document test cases clearly
- Maintain test isolation
- Direct democracy domain examples provide meaningful context

## Technical Debt and Improvements
- Consider refactoring the validation logic in Entities class to make it more modular
- Evaluate possibility of separating validation concerns from entity collection management
- Need to ensure consistent validation behavior across different operations
- The Entity relationship handling requires a complex setup of entry concepts and core concept

test(core): add tests for Add, Remove, and SetAttribute commands

- Implement comprehensive tests for AddCommand using Citizen entities
- Implement comprehensive tests for RemoveCommand using Citizen entities
- Implement comprehensive tests for SetAttributeCommand using Citizen entities
- Verify command execution, undo/redo, transaction grouping, and edge cases
- Use direct democracy domain examples consistently 