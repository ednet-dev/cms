# EDNet Core Integration of Message Filter Pattern - Memory File

## Pattern Overview

The Message Filter pattern integrated with EDNet Core provides a domain-driven approach to selectively processing messages based on specific criteria, allowing components to receive only relevant messages while discarding others. Key advantages:

- **Domain-Driven Filter Lifecycle**: Filters become first-class domain entities with proper lifecycle management
- **Persistence and Recovery**: Filters can be persisted, loaded, and restored
- **Business Policy Enforcement**: Domain policies can be applied to filter creation and operation
- **Semantic Meaning**: Filters express democratic deliberation concepts with rich domain semantics

In a direct democracy platform, EDNet Core integrated message filters enable:

1. **Domain-Validated Topic Discussions**: Topic-specific deliberation channels with consistent domain rules
2. **Jurisdiction-Aware Filtering**: Regional/jurisdictional governance with proper semantic relationships
3. **Model-Driven Personalization**: Interest-based filtering with domain entity backing
4. **Consistent Multilingual Support**: Language filtering with domain validation

## EDNet Core Modeling

The integration leverages three key EDNet Core components:

1. **FilterEntity**: Extends `Entity<FilterEntity>` to provide a proper domain entity for filter concepts
2. **EDNetCoreMessageFilter**: Wraps a FilterEntity with channel and filtering behavior
3. **MessageFilterRepository**: Manages filter entities across their lifecycle

The domain model follows EDNet Core conventions:

```
Domain (MessageFilter)
  └── Model (MessageFilterModel)
       └── Concept (Filter)
            ├── Attribute (name) [identifier]
            ├── Attribute (type) [required]
            ├── Attribute (status)
            ├── Attribute (description)
            ├── Parent (sourceChannel)
            ├── Parent (targetChannel)
            └── Child (filteredMessages)
```

## Integration Design Choices

1. **Entity-First Approach**: Filters as domain entities that have behavior (rather than behaviors that reference entities)
2. **Repository Pattern**: Clean separation between entity storage and filter behavior
3. **Factory Methods**: Simple creation patterns for different filter types
4. **Domain Properties**: Getter/setter access to entity attributes

## Examples of Domain Integration

### 1. Creating a Topic-Based Filter for Democratic Deliberation

```dart
// 1. Set up the domain model
final domain = EDNetCoreMessageFilterDomain.createDomain();
final model = domain.models.first;
final filterConcept = model.getConcept('Filter');

// 2. Create an entity repository
final filterEntities = Entities<FilterEntity>();
filterEntities.concept = filterConcept;
final repository = MessageFilterRepository(filterEntities);

// 3. Create a topic filter
final housingFilter = await repository.createPredicateFilter(
  name: 'housing-policy',
  description: 'Routes housing policy discussions to dedicated channel',
  sourceChannel: allDiscussionsChannel,
  targetChannel: housingChannel,
  predicate: (msg) => msg.metadata['topic'] == 'housing',
);

// 4. Start the filter
await housingFilter.start();
```

### 2. Regional Governance Filter with Domain Validation

```dart
// Create a region-specific filter
final northDistrictFilter = await repository.createSelectorFilter<String>(
  name: 'north-district',
  description: 'Routes messages from north district citizens',
  sourceChannel: allDiscussionsChannel,
  targetChannel: northDistrictChannel,
  selector: (msg) => msg.metadata['region'] as String? ?? '',
  expectedValue: 'north',
);

// Entity is validated by EDNet Core domain rules
try {
  northDistrictFilter.entity.concept.model.validateEntity(northDistrictFilter.entity);
  await northDistrictFilter.start();
} catch (e) {
  // Domain validation failed
  print('Filter validation failed: $e');
}
```

## Key Improvements Over Basic Implementation

1. **Domain Validation**: Filters are subject to EDNet Core domain rules and policies
2. **Entity Lifecycle Management**: Proper creation, activation, and retirement of filters
3. **Rich Semantic Model**: Filters express democratic concepts with proper domain vocabulary
4. **Policy Enforcement**: Business rules constrain filter behavior
5. **Integration with Domain Events**: Filters can be part of larger domain workflows

## Considerations for Future Development

1. **Value Object Extensions**: Creating rich domain value objects for filter predicates
2. **Event Sourcing**: Recording filter activities as domain events
3. **Policy-Based Filters**: Filters defined by domain policies rather than predicates
4. **Aggregate Integration**: Making filters part of larger domain aggregates

## Core Testing Approach

Tests focus on validating:

1. Proper entity creation and lifecycle
2. Domain rule enforcement
3. Filter behavior within domain constraints
4. Repository pattern operation
5. Integration with other domain entities 