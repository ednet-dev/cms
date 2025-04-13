# UX Component Filters

This directory contains the implementation of the UX Component Filters for the Shell Architecture, based on the Enterprise Integration Pattern "Message Filter" from EDNet Core.

## Components

### Models

- **FilterCriteria**: Represents a single filter condition with field, operator, and value(s).
- **FilterGroup**: Combines multiple criteria with AND/OR logic for complex filtering.
- **FilterPreset**: Saved filter configurations that can be applied quickly.

### Services

- **FilterService**: Service class for managing filters with persistence using SharedPreferences and integration with UX channels for messaging.

### UI Components

- **FilterButton**: Button that triggers filter UI, displaying badge with active filter count.

## Integration with Enterprise Patterns

The UX Component Filters implement the Message Filter enterprise integration pattern from EDNet Core, allowing:

1. **Selective Component Filtering**: Components can be filtered based on message content
2. **Domain-Driven Filtering**: Integration with FilterEntity for domain model-based filtering
3. **Message-Based Architecture**: Filter events communicated via UX Channels
4. **Progressive Disclosure**: Support for different disclosure levels in filter UI

## Enterprise Pattern Integration Details

### Message Filter Pattern Implementation

The Message Filter pattern is one of the core Enterprise Integration Patterns that allows selective processing of messages. In our implementation:

#### 1. Predicate-Based Filtering

Each `FilterCriteria` converts to a `MessagePredicate` that determines whether a message should pass through:

```dart
// In FilterCriteria class
MessagePredicate toPredicate() {
  return (message) {
    // Extract field value from message payload
    final payload = message.payload;
    if (payload is! Map<String, dynamic>) {
      return false;
    }

    // Support nested fields with dot notation
    final fieldParts = field.split('.');
    dynamic fieldValue = payload;
    for (final part in fieldParts) {
      if (fieldValue is! Map<String, dynamic> || !fieldValue.containsKey(part)) {
        return false;
      }
      fieldValue = fieldValue[part];
    }

    // Apply operator logic based on value type
    switch (operator) {
      case FilterOperator.equals:
        return _compareEquals(fieldValue, value);
      // ... other operators
    }
  };
}
```

#### 2. Composable Filter Logic

The `FilterGroup` combines multiple predicates using functional composition techniques:

```dart
// In FilterGroup class
MessagePredicate toPredicate() {
  // If no active criteria, allow all messages
  if (!hasActiveCriteria) {
    return (_) => true;
  }

  // Get predicates for active criteria
  final predicates = activeCriteria.map((c) => c.toPredicate()).toList();

  // Apply AND/OR logic
  if (logic == FilterGroupLogic.and) {
    return (message) => predicates.every((predicate) => predicate(message));
  } else {
    return (message) => predicates.any((predicate) => predicate(message));
  }
}
```

#### 3. Channel-Based Messaging

Following the EDNet Core pattern, filters operate on channels - receiving from a source channel and sending to a target channel:

```dart
// Integration with MessageFilter from EDNet Core
Future<MessageFilter> createMessageFilter(
  FilterGroup filterGroup,
  Channel sourceChannel,
  Channel targetChannel, {
  required String name,
}) async {
  final predicate = filterGroup.toPredicate();

  return PredicateMessageFilter(
    sourceChannel: sourceChannel,
    targetChannel: targetChannel,
    name: name,
    predicate: predicate,
  );
}
```

### Shell Architecture Integration

The filter components seamlessly integrate with the Shell Architecture through several mechanisms:

#### 1. Progressive Disclosure Support

All filter components implement the Shell Architecture's `ProgressiveDisclosure` mixin:

```dart
class FilterCriteria with ProgressiveDisclosure {
  @override
  final DisclosureLevel disclosureLevel;
  
  // Constructor with progressive disclosure support
  FilterCriteria({
    // ... other parameters
    this.disclosureLevel = DisclosureLevel.basic,
  });
}
```

This allows filter components to adapt their complexity based on the user's expertise level.

#### 2. UX Channel Communication

Filter events are communicated through the Shell Architecture's UX channel infrastructure:

```dart
// In FilterService class
final UXChannel _filterChannel = UXChannel(
  'filter_channel',
  name: 'Filter Message Channel',
);

// Set up message handlers
void _setupMessageHandlers() {
  _filterChannel.onUXMessageType('apply_filter', (message) async {
    final filterData = message.payload['filter'] as Map<String, dynamic>;
    final filterGroup = FilterGroup.fromJson(filterData);
    await applyFilter(filterGroup);
  });
  
  // ... other message handlers
}

// Send filter-related messages
void _sendFilterMessage(String type, Map<String, dynamic> payload) {
  _filterChannel.sendUXMessage(UXMessage.create(
    type: type,
    payload: {
      ...payload,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    },
    source: 'filter_service',
  ));
}
```

#### 3. Domain Entity Integration

Bridges between UI filters and EDNet Core domain entities are provided through specific integration methods:

```dart
// Creating an EDNet Core message filter with domain entity
Future<EDNetCoreMessageFilter?> createEntityFilter(
  FilterGroup filterGroup,
  Channel sourceChannel,
  Channel targetChannel, {
  required String name,
  required FilterEntity entity,
}) async {
  final predicate = filterGroup.toPredicate();
  
  final filterImpl = PredicateMessageFilter(
    sourceChannel: sourceChannel,
    targetChannel: targetChannel,
    name: name,
    predicate: predicate,
  );
  
  return EDNetCoreMessageFilter(
    entity: entity,
    sourceChannel: sourceChannel,
    targetChannel: targetChannel,
    filterImpl: filterImpl,
  );
}
```

### Domain Model Integration

The filter system integrates with EDNet Core's domain model through the `FilterEntity` class:

```dart
// FilterEntity represents a domain entity for a filter
class FilterEntity extends Entity<FilterEntity> {
  // Gets the filter name
  String? get filterName => getAttribute('name');

  // Gets the filter type
  String? get filterType => getAttribute('type');

  // Gets the filter status
  String? get status => getAttribute('status');
}
```

This domain entity integration enables:

1. **Persistence**: Filters can be stored in domain repositories
2. **Domain Validation**: Filters can be validated against domain rules
3. **Domain Events**: Filter operations can trigger domain events
4. **Rich Semantics**: Filters can express domain-specific concepts

## Usage

### Basic Filtering

```dart
// Create filter criteria
final criteria = FilterCriteria(
  field: 'name',
  operator: FilterOperator.contains,
  valueType: FilterValueType.text,
  value: 'search term',
);

// Create a filter group
final filterGroup = FilterGroup(
  criteria: [criteria],
  logic: FilterGroupLogic.and,
);

// Apply the filter
final filterService = FilterService();
await filterService.applyFilter(filterGroup);
```

### Filter Button

```dart
// Display a filter button with active filter count
FilterButton(
  activeFilter: filterGroup,
  onPressed: () => showFilterDialog(context),
)
```

### Saved Presets

```dart
// Create a filter preset
final preset = FilterPreset(
  name: 'My Preset',
  filterGroup: filterGroup,
  description: 'Filters items containing search term',
);

// Save the preset
await filterService.savePreset(preset);

// Get all saved presets
final presets = await filterService.getPresets();
```

### Integration with Message Filter Pattern

The UX Component Filters can be integrated with the Message Filter pattern from EDNet Core:

```dart
// Convert FilterGroup to EDNet Core MessagePredicate
final predicate = filterGroup.toPredicate();

// Use predicate with a message filter
final filter = PredicateMessageFilter(
  sourceChannel: sourceChannel,
  targetChannel: targetChannel,
  name: 'my-filter',
  predicate: predicate,
);

// Start filtering
await filter.start();
```

## Architecture

The UX Component Filters follow these architectural principles:

1. **Shell Architecture**: Components are designed for the Shell Architecture, adapting between domain models and UI.
2. **Progressive Disclosure**: Filter UI adapts based on user expertise level.
3. **Enterprise Integration Patterns**: Implementing Message Filter pattern for selective processing.
4. **Domain-Driven Design**: Integration with EDNet Core domain model through FilterEntity.
5. **Channel Adapters**: Using UX Channels for message-based communication.

## Extension Points

The filter system can be extended through:

1. **Custom Filter Types**: Implement specialized filter types by extending FilterCriteria
2. **UX Adapters**: Create custom UX adapters for domain-specific filtering
3. **Filter Processors**: Implement custom filter processing logic for specific domains 

## Real-World Use Cases

In the EDNetOne democracy platform, the Message Filter pattern enables:

1. **Topic-Based Deliberation**: Citizens can filter discussions by policy area
2. **Regional Governance**: Filter messages by jurisdiction or geographical region
3. **Language-Specific Content**: Filter content based on language preferences
4. **Expertise Matching**: Match proposals with relevant domain experts
5. **Content Moderation**: Filter inappropriate content based on community guidelines

Each of these use cases leverages the composable, domain-driven filter infrastructure to provide targeted information to the right stakeholders at the right time. 