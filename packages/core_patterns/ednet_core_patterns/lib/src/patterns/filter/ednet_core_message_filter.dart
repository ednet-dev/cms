import 'dart:async';
import 'package:ednet_core/ednet_core.dart';
import '../common/base_message.dart';
import '../common/channel.dart';

/// Entity class for Message Filters that extends Entity
class FilterEntity extends Entity<FilterEntity> {
  /// Returns the name of the filter
  String? get filterName => getAttribute('name');
  set filterName(String? value) => setAttribute('name', value);

  /// Returns the type of filter (predicate, selector, composite)
  String? get filterType => getAttribute('type');
  set filterType(String? value) => setAttribute('type', value);

  /// Returns the current operational status (active, inactive)
  String? get status => getAttribute('status');
  set status(String? value) => setAttribute('status', value);

  /// Returns the filter description
  String? get description => getAttribute('description');
  set description(String? value) => setAttribute('description', value);
}

/// Domain model for the Message Filter pattern within EDNet Core.
class EDNetCoreMessageFilterDomain {
  /// Creates a domain model for the Message Filter pattern
  static Domain createDomain() {
    // Create domain for Message Filter pattern
    final domain = Domain('MessageFilter');
    domain.description =
        'Message Filter pattern for selectively receiving messages';

    // Create model within domain
    final model = Model(domain, 'MessageFilterModel');
    model.description = 'Model for the Message Filter pattern';

    // Create filter concept
    final filterConcept = Concept(model, 'Filter');
    filterConcept.description =
        'A filter that selectively processes messages based on criteria';
    filterConcept.entry = true;

    // Add attributes to filter concept
    final filterNameAttr = Attribute(filterConcept, 'name');
    filterNameAttr.type = domain.getType('String');
    filterNameAttr.identifier = true;

    final filterTypeAttr = Attribute(filterConcept, 'type');
    filterTypeAttr.type = domain.getType('String');
    filterTypeAttr.required = true;

    final statusAttr = Attribute(filterConcept, 'status');
    statusAttr.type = domain.getType('String');
    statusAttr.init = 'inactive';

    final descriptionAttr = Attribute(filterConcept, 'description');
    descriptionAttr.type = domain.getType('String');

    // Create source and target channel concepts
    final sourceChannelConcept = Concept(model, 'SourceChannel');
    sourceChannelConcept.description =
        'Source channel from which messages are filtered';

    final targetChannelConcept = Concept(model, 'TargetChannel');
    targetChannelConcept.description =
        'Target channel to which filtered messages are sent';

    // Create message concept
    final messageConcept = Concept(model, 'FilteredMessage');
    messageConcept.description = 'A message that has passed through a filter';

    // Create relationships
    final sourceChannelParent = Parent(
      filterConcept,
      sourceChannelConcept,
      'sourceChannel',
    );
    sourceChannelParent.required = true;
    sourceChannelParent.internal = true;

    final targetChannelParent = Parent(
      filterConcept,
      targetChannelConcept,
      'targetChannel',
    );
    targetChannelParent.required = true;
    targetChannelParent.internal = true;

    final filteredMessageChild = Child(
      filterConcept,
      messageConcept,
      'filteredMessages',
    );
    filteredMessageChild.internal = true;

    return domain;
  }
}

/// A predicate function that determines whether a message passes the filter
typedef MessagePredicate = bool Function(Message message);

/// A Message Filter implementation that integrates with EDNet Core Entity model
///
/// This class combines the Message Filter pattern with EDNet's domain modeling,
/// providing a persistent, domain-driven approach to message filtering.
///
/// In digital democracy contexts, EDNetCoreMessageFilter enables:
/// - Topic-specific discussion routing with domain validation
/// - Citizen deliberation channels with consistent entity lifecycle
/// - Regional governance message distribution with semantic meaning
/// - Content moderation with domain enforcement
class EDNetCoreMessageFilter {
  /// The underlying EDNet Core entity
  final FilterEntity entity;

  /// The source channel from which messages are filtered
  final Channel sourceChannel;

  /// The target channel to which filtered messages are sent
  final Channel targetChannel;

  /// The predicate used for filtering
  final MessagePredicate predicate;

  /// Stream subscription
  StreamSubscription? _subscription;

  /// Statistics for filter operation
  int _messagesReceived = 0;
  int _messagesPassed = 0;
  int _messagesFiltered = 0;

  /// Creates a new message filter backed by an EDNet Core entity
  ///
  /// Example in democratic context:
  /// ```dart
  /// final filterEntity = FilterEntity();
  /// filterEntity.concept = messageFilterConcept;
  /// filterEntity.filterName = 'housing-topic-filter';
  /// filterEntity.filterType = 'predicate';
  /// filterEntity.status = 'inactive';
  ///
  /// final topicFilter = EDNetCoreMessageFilter(
  ///   entity: filterEntity,
  ///   sourceChannel: allDeliberationsChannel,
  ///   targetChannel: housingPolicyChannel,
  ///   predicate: (msg) => msg.metadata['topic'] == 'housing'
  /// );
  /// ```
  EDNetCoreMessageFilter({
    required this.entity,
    required this.sourceChannel,
    required this.targetChannel,
    required this.predicate,
  });

  /// The name of this filter
  String get name => entity.filterName ?? 'unnamed-filter';

  /// The type of this filter (predicate, selector, composite)
  String get type => entity.filterType ?? 'unknown';

  /// The current operational status (active, inactive)
  String get status => entity.status ?? 'inactive';

  /// Gets a property of this filter
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': _messagesReceived,
        'passed': _messagesPassed,
        'filtered': _messagesFiltered,
      };
    }
    return entity.getAttribute(name);
  }

  /// Sets a property of this filter
  void setProperty(String name, dynamic value) {
    entity.setAttribute(name, value);
  }

  /// Starts the filter operation, updating the entity's status
  Future<void> start() async {
    if (status == 'active') return;

    // Start listening to messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update entity status
    entity.status = 'active';
  }

  /// Stops the filter operation, updating the entity's status
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    // Update entity status
    entity.status = 'inactive';
  }

  /// Process incoming messages
  Future<void> _processMessage(Message message) async {
    _messagesReceived++;

    if (predicate(message)) {
      await targetChannel.send(message);
      _messagesPassed++;
    } else {
      _messagesFiltered++;
    }
  }
}

/// Repository for managing message filters as domain entities
///
/// This class provides a domain-driven approach to creating and managing
/// filter entities, maintaining consistent lifecycle and state.
///
/// In digital democracy contexts, MessageFilterRepository enables:
/// - Citizens to create and discover deliberation topics
/// - Administrators to manage content moderation policies
/// - System persistence and recovery of filter configurations
/// - Metrics and auditing of filter effectiveness
class MessageFilterRepository {
  /// Collection of filter entities
  final Entities<FilterEntity> entities;

  /// Currently active filters
  final List<EDNetCoreMessageFilter> _activeFilters = [];

  /// Creates a new repository for filter entities
  MessageFilterRepository(this.entities);

  /// Create a predicate-based filter
  ///
  /// Example in democratic context:
  /// ```dart
  /// final housingFilter = await repository.createPredicateFilter(
  ///   name: 'housing-topic',
  ///   description: 'Routes housing policy discussions to the housing channel',
  ///   sourceChannel: allDiscussionsChannel,
  ///   targetChannel: housingChannel,
  ///   predicate: (msg) => msg.metadata['topic'] == 'housing',
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createPredicateFilter({
    required String name,
    String? description,
    required Channel sourceChannel,
    required Channel targetChannel,
    required MessagePredicate predicate,
  }) async {
    // Create entity
    final entity = FilterEntity();
    entity.concept = entities.concept;
    entity.filterName = name;
    entity.filterType = 'predicate';
    entity.status = 'inactive';
    if (description != null) {
      entity.description = description;
    }

    // Add to repository
    entities.add(entity);

    // Create filter
    final filter = EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      predicate: predicate,
    );

    _activeFilters.add(filter);
    return filter;
  }

  /// Create a selector-based filter
  ///
  /// This uses a selector function to extract a value from a message
  /// and compare it with an expected value.
  ///
  /// Example in democratic context:
  /// ```dart
  /// final regionalFilter = await repository.createSelectorFilter<String>(
  ///   name: 'north-district',
  ///   description: 'Routes messages from north district citizens',
  ///   sourceChannel: allDiscussionsChannel,
  ///   targetChannel: northDistrictChannel,
  ///   selector: (msg) => msg.metadata['region'] as String? ?? '',
  ///   expectedValue: 'north',
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createSelectorFilter<T>({
    required String name,
    String? description,
    required Channel sourceChannel,
    required Channel targetChannel,
    required T Function(Message) selector,
    required T expectedValue,
    bool Function(T, T)? comparator,
  }) async {
    // Create entity
    final entity = FilterEntity();
    entity.concept = entities.concept;
    entity.filterName = name;
    entity.filterType = 'selector';
    entity.status = 'inactive';
    if (description != null) {
      entity.description = description;
    }

    // Add to repository
    entities.add(entity);

    // Create selector predicate
    final predicate = (Message message) {
      try {
        final value = selector(message);
        return comparator != null
            ? comparator(value, expectedValue)
            : value == expectedValue;
      } catch (e) {
        return false;
      }
    };

    // Create filter
    final filter = EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      predicate: predicate,
    );

    _activeFilters.add(filter);
    return filter;
  }

  /// Create a composite filter combining multiple criteria
  ///
  /// Example in democratic context:
  /// ```dart
  /// final youthEnvironmentFilter = await repository.createCompositeFilter(
  ///   name: 'youth-environment',
  ///   description: 'Routes environmental topics from youth council',
  ///   sourceChannel: allDiscussionsChannel,
  ///   targetChannel: youthCouncilChannel,
  ///   predicates: [
  ///     (msg) => msg.metadata['topic'] == 'environment',
  ///     (msg) => msg.metadata['demographic'] == 'youth',
  ///   ],
  ///   operation: 'AND',
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createCompositeFilter({
    required String name,
    String? description,
    required Channel sourceChannel,
    required Channel targetChannel,
    required List<MessagePredicate> predicates,
    required String operation,
  }) async {
    if (!['AND', 'OR', 'NOT'].contains(operation)) {
      throw ArgumentError('Operation must be one of: AND, OR, NOT');
    }

    if (operation == 'NOT' && predicates.length != 1) {
      throw ArgumentError('NOT operation requires exactly one predicate');
    }

    // Create entity
    final entity = FilterEntity();
    entity.concept = entities.concept;
    entity.filterName = name;
    entity.filterType = 'composite';
    entity.status = 'inactive';
    entity.setAttribute('operation', operation);
    entity.setAttribute('predicateCount', predicates.length);
    if (description != null) {
      entity.description = description;
    }

    // Add to repository
    entities.add(entity);

    // Create composite predicate
    final compositePredicate = (Message message) {
      switch (operation) {
        case 'AND':
          return predicates.every((predicate) => predicate(message));
        case 'OR':
          return predicates.any((predicate) => predicate(message));
        case 'NOT':
          return !predicates.single(message);
        default:
          return false;
      }
    };

    // Create filter
    final filter = EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      predicate: compositePredicate,
    );

    _activeFilters.add(filter);
    return filter;
  }

  /// Get a filter by name
  EDNetCoreMessageFilter? getFilterByName(String name) {
    for (var filter in _activeFilters) {
      if (filter.name == name) {
        return filter;
      }
    }
    return null;
  }

  /// Get all active filters
  List<EDNetCoreMessageFilter> getAllFilters() {
    return List.unmodifiable(_activeFilters);
  }

  /// Get filters by type
  List<EDNetCoreMessageFilter> getFiltersByType(String type) {
    return _activeFilters.where((filter) => filter.type == type).toList();
  }

  /// Start all filters
  Future<void> startAllFilters() async {
    for (var filter in _activeFilters) {
      await filter.start();
    }
  }

  /// Stop all active filters
  Future<void> stopAllFilters() async {
    for (var filter in _activeFilters) {
      await filter.stop();
    }
  }

  /// Remove a filter by name
  Future<bool> removeFilter(String name) async {
    final filter = getFilterByName(name);
    if (filter == null) return false;

    await filter.stop();
    _activeFilters.remove(filter);

    final filterEntity = filter.entity;
    return entities.remove(filterEntity);
  }
}
