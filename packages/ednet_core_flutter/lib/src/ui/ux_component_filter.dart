part of ednet_core_flutter;

/// A filter for UX components based on entity properties
///
/// Implements the Message Filter pattern from Enterprise Integration Patterns
/// to selectively display UI components based on entity criteria.
abstract class UXComponentFilter {
  /// The criteria used to filter entities
  EntityFilterCriteria get filterCriteria;

  /// Check if this filter should process a message
  bool shouldProcess(Message message);

  /// Filter messages based on correlation ID
  bool filterMessage(Message message);

  /// Process a message
  void processMessage(Message message);

  /// Subscribe to a channel
  void subscribeToChannel(Channel channel);
}

/// A message filter implementation
class MessageFilter implements UXComponentFilter {
  final Channel _sourceChannel;
  final Channel _targetChannel;

  /// Constructor
  MessageFilter(this._sourceChannel, this._targetChannel) {
    _sourceChannel.messages.listen((message) {
      if (shouldProcess(message)) {
        _targetChannel.send(message);
      }
    });
  }

  @override
  bool filterMessage(Message message) {
    return shouldProcess(message);
  }

  @override
  void processMessage(Message message) {
    if (shouldProcess(message)) {
      _targetChannel.send(message);
    }
  }

  @override
  void subscribeToChannel(Channel channel) {
    channel.messages.listen((message) {
      if (shouldProcess(message)) {
        _targetChannel.send(message);
      }
    });
  }

  @override
  bool shouldProcess(Message message) {
    // Allow filtering UI components based on entity properties
    if (message.type == 'ux.render' || message.type == 'ux.update') {
      final entityData = message.payload['entity'] as Map<String, dynamic>?;
      if (entityData != null) {
        return filterCriteria.matches(entityData);
      }
    }

    // For non-UI messages or messages without entity data, pass through
    return true;
  }

  @override
  EntityFilterCriteria get filterCriteria =>
      EntityFilterCriteria((data) => true); // Default accepts everything
}

/// Criteria for filtering entities in UI components
class EntityFilterCriteria {
  /// The filter predicate function
  final bool Function(Map<String, dynamic> entityData) predicate;

  /// Constructor with predicate function
  const EntityFilterCriteria(this.predicate);

  /// Check if the given entity data matches the criteria
  bool matches(Map<String, dynamic> entityData) => predicate(entityData);

  /// Create a filter criteria that matches entities with the specified attribute value
  static EntityFilterCriteria whereAttribute(
    String attributeName,
    Object? value,
  ) {
    return EntityFilterCriteria((data) => data[attributeName] == value);
  }

  /// Create a filter criteria that matches entities with an attribute containing the value
  static EntityFilterCriteria whereAttributeContains(
    String attributeName,
    String value, {
    bool caseSensitive = false,
  }) {
    return EntityFilterCriteria((data) {
      final attrValue = data[attributeName]?.toString();
      if (attrValue == null) return false;

      return caseSensitive
          ? attrValue.contains(value)
          : attrValue.toLowerCase().contains(value.toLowerCase());
    });
  }

  /// Create a filter criteria that matches entities of a specific type
  static EntityFilterCriteria ofType(String entityType) {
    return EntityFilterCriteria(
      (data) =>
          data['entityType'] == entityType ||
          data['concept']?['code'] == entityType,
    );
  }

  /// Create a filter criteria that matches entities based on a disclosure level
  static EntityFilterCriteria withMinimumDisclosureLevel(
    DisclosureLevel level,
  ) {
    return EntityFilterCriteria((data) {
      final entityLevel = data['disclosureLevel'];
      if (entityLevel == null)
        return true; // No level specified means show always

      // Convert string to enum if needed
      final actualLevel = entityLevel is String
          ? DisclosureLevel.values.firstWhere(
              (e) => e.toString() == 'DisclosureLevel.$entityLevel',
              orElse: () => DisclosureLevel.basic,
            )
          : entityLevel as DisclosureLevel;

      // Show if the entity's level is at most the requested level
      return actualLevel.index <= level.index;
    });
  }

  /// Combine this criteria with another using AND logic
  EntityFilterCriteria and(EntityFilterCriteria other) {
    return EntityFilterCriteria((data) => matches(data) && other.matches(data));
  }

  /// Combine this criteria with another using OR logic
  EntityFilterCriteria or(EntityFilterCriteria other) {
    return EntityFilterCriteria((data) => matches(data) || other.matches(data));
  }

  /// Negate this criteria
  EntityFilterCriteria get not {
    return EntityFilterCriteria((data) => !matches(data));
  }
}

/// A specialized UX Component Filter for progressive disclosure of UI elements
class ProgressiveDisclosureFilter extends MessageFilter {
  /// The current disclosure level
  final DisclosureLevel disclosureLevel;

  /// Constructor
  ProgressiveDisclosureFilter(
    this.disclosureLevel,
    Channel sourceChannel,
    Channel targetChannel,
  ) : super(sourceChannel, targetChannel);

  @override
  EntityFilterCriteria get filterCriteria =>
      EntityFilterCriteria.withMinimumDisclosureLevel(disclosureLevel);

  /// Create a new filter with an updated disclosure level
  ProgressiveDisclosureFilter copyWithLevel(
    DisclosureLevel newLevel,
    Channel sourceChannel,
    Channel targetChannel,
  ) {
    return ProgressiveDisclosureFilter(newLevel, sourceChannel, targetChannel);
  }
}
