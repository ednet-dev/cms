part of ednet_core;

/// Entity class for Message Filter in EDNet Core
///
/// This class extends [Entity] to provide a domain-driven representation of a message filter.
class FilterEntity extends Entity<FilterEntity> {
  /// Creates a filter entity
  FilterEntity() : super();

  /// Gets the filter name
  String? get filterName => getAttribute('name');

  /// Gets the filter type
  String? get filterType => getAttribute('type');

  /// Gets the filter status
  String? get status => getAttribute('status');

  @override
  bool get isEmpty => false;

  @override
  Id get id {
    // Use 'name' as the identity attribute
    final name = getAttribute('name');
    if (name == null) {
      throw StateError('Filter entity has no name attribute');
    }
    return Id.withOid(Oid(name.toString()));
  }
}

/// EDNet Core implementation of Message Filter pattern
///
/// The [EDNetCoreMessageFilter] wraps a filter entity to provide a seamless integration between
/// the Message Filter pattern and EDNet Core's domain modeling capabilities.
///
/// In a direct democracy context, this implementation allows:
/// * Persisting filter configurations as domain entities
/// * Tracking filter history and state changes
/// * Applying domain policies to messaging rules
/// * Integrating filters with other domain concepts
class EDNetCoreMessageFilter implements MessageFilter {
  /// The underlying filter entity
  final FilterEntity entity;

  /// The source channel
  @override
  final Channel sourceChannel;

  /// The target channel
  @override
  final Channel targetChannel;

  /// The filter implementation
  final MessageFilter _filterImpl;

  /// Creates a new EDNet Core message filter
  ///
  /// Example:
  /// ```dart
  /// final filter = EDNetCoreMessageFilter(
  ///   entity: filterEntity,
  ///   sourceChannel: sourceChannel,
  ///   targetChannel: targetChannel,
  ///   filterImpl: PredicateMessageFilter(...)
  /// );
  /// ```
  EDNetCoreMessageFilter({
    required this.entity,
    required this.sourceChannel,
    required this.targetChannel,
    required MessageFilter filterImpl,
  }) : _filterImpl = filterImpl;

  @override
  String get name => entity.filterName ?? 'unnamed-filter';

  @override
  String get status => entity.status ?? 'inactive';

  @override
  String get type => entity.filterType ?? 'unknown';

  @override
  dynamic getProperty(String propertyName) {
    return _filterImpl.getProperty(propertyName);
  }

  @override
  Future<void> start() async {
    await _filterImpl.start();

    // Update entity status
    entity.setAttribute('status', 'active');
  }

  @override
  Future<void> stop() async {
    await _filterImpl.stop();

    // Update entity status
    entity.setAttribute('status', 'inactive');
  }

  @override
  void setProperty(String name, dynamic value) {
    _filterImpl.setProperty(name, value);

    // For important properties, synchronize with entity
    if (['name', 'type', 'status'].contains(name)) {
      entity.setAttribute(name, value);
    }
  }
}

/// Repository for managing filter entities
///
/// The [MessageFilterRepository] provides factory methods to create different types of filters
/// while managing the underlying filter entities. It serves as a bridge between
/// the messaging infrastructure and EDNet Core's domain model.
class MessageFilterRepository {
  /// Entities collection for FilterEntity
  final Entities<FilterEntity> entities;

  /// Creates a new repository with the given entities collection
  MessageFilterRepository(this.entities);

  /// Creates a predicate-based message filter
  ///
  /// Example:
  /// ```dart
  /// final topicFilter = await repository.createPredicateFilter(
  ///   name: 'housing-topic-filter',
  ///   sourceChannel: allDeliberationsChannel,
  ///   targetChannel: housingPolicyChannel,
  ///   predicate: (msg) => msg.metadata['topic'] == 'housing'
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createPredicateFilter({
    required String name,
    required Channel sourceChannel,
    required Channel targetChannel,
    required MessagePredicate predicate,
  }) async {
    // Create and configure entity
    final entity = FilterEntity();
    entity.setAttribute('name', name);
    entity.setAttribute('type', 'predicate');
    entity.setAttribute('status', 'inactive');

    // Add to entities collection
    entities.add(entity);

    // Create implementation
    final filterImpl = PredicateMessageFilter(
      name: name,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      predicate: predicate,
    );

    // Create and return wrapped filter
    return EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      filterImpl: filterImpl,
    );
  }

  /// Creates a selector-based message filter
  ///
  /// Example:
  /// ```dart
  /// final regionalFilter = await repository.createSelectorFilter<String>(
  ///   name: 'west-district-filter',
  ///   sourceChannel: allNotificationsChannel,
  ///   targetChannel: westDistrictChannel,
  ///   selector: (msg) => msg.metadata['region'] as String,
  ///   expectedValue: 'west-district'
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createSelectorFilter<T>({
    required String name,
    required Channel sourceChannel,
    required Channel targetChannel,
    required T Function(Message) selector,
    required T expectedValue,
    bool Function(T, T)? comparator,
  }) async {
    // Create and configure entity
    final entity = FilterEntity();
    entity.setAttribute('name', name);
    entity.setAttribute('type', 'selector');
    entity.setAttribute('status', 'inactive');
    entity.setAttribute('selectorType', T.toString());

    // Add to entities collection
    entities.add(entity);

    // Create implementation
    final filterImpl = SelectorMessageFilter<T>(
      name: name,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      selector: selector,
      expectedValue: expectedValue,
      comparator: comparator,
    );

    // Create and return wrapped filter
    return EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      filterImpl: filterImpl,
    );
  }

  /// Creates a composite message filter
  ///
  /// Example:
  /// ```dart
  /// final targetedAnnouncementFilter = await repository.createCompositeFilter(
  ///   name: 'targeted-announcements',
  ///   sourceChannel: allAnnouncementsChannel,
  ///   targetChannel: citizenFeedChannel,
  ///   filters: [
  ///     (msg) => msg.metadata['region'] == citizen.region,
  ///     (msg) => citizen.interests.contains(msg.metadata['topic']),
  ///   ],
  ///   operation: 'AND'
  /// );
  /// ```
  Future<EDNetCoreMessageFilter> createCompositeFilter({
    required String name,
    required Channel sourceChannel,
    required Channel targetChannel,
    required List<MessagePredicate> filters,
    required String operation,
  }) async {
    // Create and configure entity
    final entity = FilterEntity();
    entity.setAttribute('name', name);
    entity.setAttribute('type', 'composite');
    entity.setAttribute('status', 'inactive');
    entity.setAttribute('operation', operation);
    entity.setAttribute('filterCount', filters.length);

    // Add to entities collection
    entities.add(entity);

    // Create implementation
    final filterImpl = CompositeMessageFilter(
      name: name,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      filters: filters,
      operation: operation,
    );

    // Create and return wrapped filter
    return EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      filterImpl: filterImpl,
    );
  }

  /// Gets a filter by name
  ///
  /// Returns null if no filter with the given name exists
  Future<EDNetCoreMessageFilter?> getFilter(String name) async {
    // Find entity by name attribute
    for (var entity in entities) {
      if (entity.filterName == name) {
        return null; // In a real implementation, we would reconstruct the filter
      }
    }

    return null;
  }
}
