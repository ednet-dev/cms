# AggregateRoot in EDNet Core

## Overview

The AggregateRoot pattern in EDNet Core is an implementation of the Domain-Driven Design (DDD) tactical pattern that represents a cluster of domain objects treated as a single unit for data changes.

In DDD, an aggregate is a pattern that:
- Encapsulates related objects as a single unit
- Enforces invariants at the aggregate boundary
- Ensures transactional consistency 
- Provides a single entry point to interact with the cluster of objects

## Relationship to EDNet Core Concepts

In EDNet Core, the AggregateRoot pattern is connected to concepts where `entry = true`. This alignment makes sense because:

1. Entry concepts in EDNet Core are the roots of a conceptual hierarchy
2. They serve as access points into the domain model
3. They represent complete, independently meaningful business entities

## Implementation

The `AggregateRoot<T>` class extends the `Entity<T>` class and adds:

- Version tracking for optimistic concurrency control
- Validation of business invariants
- Command handling capabilities
- Event generation and application (for event sourcing)
- Relationship integrity enforcement
- Policy integration for event-driven workflows

## The Command-Event-Policy Cycle

One of the key architectural patterns enabled by the AggregateRoot is the command-event-policy cycle:

1. **Commands** are executed on AggregateRoots
2. AggregateRoots emit **Events** when state changes
3. Events trigger **Policies**
4. Policies generate new **Commands**
5. The cycle continues...

This creates a powerful reactive architecture where business processes can flow naturally through the domain model.

```
┌─────────────┐     executes     ┌──────────────────┐
│   Command   │─────────────────▶│   AggregateRoot  │
└─────────────┘                  └──────────────────┘
      ▲                                   │
      │                                   │
      │                                   │ emits
      │                                   │
      │                                   ▼
┌─────────────┐     triggers     ┌──────────────────┐
│   Policy    │◀────────────────│      Event       │
└─────────────┘                  └──────────────────┘
      │
      │ generates
      │
      ▼
┌─────────────┐
│   Command   │
└─────────────┘
```

## How AggregateRoot Addresses Validation Warnings

One of the key benefits of using the AggregateRoot pattern is that it can automatically manage required relationships between entities, addressing validation warnings like:

- `IzbornaLista.election parent is required`
- `IzbornaJedinica.election parent is required`
- `Glas.election parent is required`

These warnings occur because the entities in the model have required parent-child relationships that aren't always set when creating the entities individually. The AggregateRoot pattern ensures these relationships are properly established.

## Example Usage

A concrete implementation for managing elections might look like:

```dart
// Create an AggregateRoot
final electionAggregate = usDomain.createElectionAggregate(
  name: 'Election 2022',
  // ... other properties
);

// Add child entities through the aggregate
electionAggregate.addElectionList(democrats);
electionAggregate.addElectionList(republicans);
electionAggregate.addelectoralUnit(unit);
electionAggregate.registerVote(vote);

// Validate relationships
final validationErrors = electionAggregate.validateRelationships();
```

## Integration with Policies

AggregateRoots can now work with policies that trigger based on events:

```dart
// Define a policy that reacts to vote registration events
class VoteAuditPolicy implements IEventTriggeredPolicy {
  @override
  bool evaluate(Entity entity) {
    return entity is Election;
  }
  
  @override
  bool shouldTriggerOnEvent(Event event) {
    return event.name == 'VoteRegistered';
  }
  
  @override
  void executeActions(Entity entity, Event event) {
    print('Auditing vote from ${event.data['voterId']}');
  }
  
  @override
  List<ICommand> generateCommands(Entity entity, Event event) {
    return [
      RecordAuditLogCommand(
        entityId: entity.id,
        action: 'Vote',
        userId: event.data['voterId'],
        timestamp: DateTime.now()
      )
    ];
  }
}

// Register the policy with the aggregate
electionAggregate.registerPolicy(VoteAuditPolicy());

// Execute a command that will emit an event
electionAggregate.executeCommand(
  RegisterVoteCommand(voterId: 'citizen1', candidateId: 'candidate1')
);
// This will automatically:
// 1. Execute the command
// 2. Emit a VoteRegistered event
// 3. Trigger the VoteAuditPolicy
// 4. Generate and execute the RecordAuditLogCommand
```

## Philosophical and Practical Implications

### Consistency Boundary

The AggregateRoot defines a consistency boundary. Inside this boundary, business rules must be consistent. This is why many validation issues can be solved by applying this pattern - it ensures the right relationships exist.

### Entity Lifecycle Management

By managing the lifecycle of entities within the aggregate, the AggregateRoot helps prevent "orphaned" entities or invalid relationships.

### Transactional Consistency

All changes to entities within an aggregate should be committed in a single transaction, which helps maintain data integrity.

### Event-Driven Architecture

The integration with events and policies enables reactive, event-driven architectures where business processes can flow naturally through domain events.

## Integration with Event Sourcing

The AggregateRoot also supports event sourcing by providing methods to:
- Create events based on state changes
- Apply events to reconstruct the aggregate's state

This makes it suitable for systems that need to track the full history of domain changes.

## Best Practices

1. Keep aggregates small - only include entities that must change together
2. Identify proper aggregate boundaries based on business rules
3. Access entities in the aggregate only through the aggregate root
4. Use repository queries to load complete aggregates
5. Apply updates atomically to maintain consistency 

## Roadmap

### Short-term (Next 3 months)
- Enhance command handling capabilities with more structured command objects
- Improve integration with event sourcing by adding support for event replay
- Add more comprehensive validation for aggregate relationships
- Develop standard patterns for inter-aggregate communication

### Medium-term (6-12 months)
- Create a repository pattern specifically optimized for aggregates
- Add support for optimistic concurrency control with version checking
- Develop tooling for visualizing aggregate boundaries
- Add performance optimizations for large aggregate loads

### Long-term (Beyond 12 months)
- Support for distributed aggregates in microservice architectures
- Add AI-assisted aggregate boundary detection and optimization
- Create integration patterns with CQRS architecture
- Develop comprehensive monitoring and metrics for aggregate health 