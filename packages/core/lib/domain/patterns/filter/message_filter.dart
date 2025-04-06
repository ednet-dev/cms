part of ednet_core;

/// Domain model for the Message Filter pattern within EDNet Core.
///
/// The Message Filter pattern allows components to selectively receive
/// messages that match specific criteria, while discarding messages that
/// are irrelevant to the receiver.
class MessageFilterDomain {
  /// Creates the domain model for Message Filter pattern
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

/// Message Filter pattern for EDNet Core-based applications
///
/// The Message Filter pattern allows selective processing of messages based on
/// specific criteria. In direct democracy contexts, filters enable:
///
/// - Topic-specific discussion threads for citizen deliberation
/// - Jurisdiction-based voting channels (local, regional, national)
/// - Relevance filtering for citizens based on interests and affiliations
/// - Content moderation for appropriate democratic discourse
/// - Language and accessibility filtering for inclusive participation
abstract class MessageFilter {
  /// The source channel from which messages are filtered
  Channel get sourceChannel;

  /// The target channel to which filtered messages are sent
  Channel get targetChannel;

  /// Unique name for this filter
  String get name;

  /// Type of filter (predicate, selector, etc.)
  String get type;

  /// Current filter status (active, inactive, etc.)
  String get status;

  /// Starts the filter
  Future<void> start();

  /// Stops the filter
  Future<void> stop();

  /// Gets a configuration property
  dynamic getProperty(String name);

  /// Sets a configuration property
  void setProperty(String name, dynamic value);
}

/// Filter implementation that uses a predicate function to determine
/// whether messages should pass through
///
/// In a digital democracy context, predicate filters enable:
/// - Topic categorization of citizen discussions
/// - Filtering deliberation by relevance criteria
/// - Regional/jurisdictional message routing
/// - Content moderation based on community guidelines
class PredicateMessageFilter implements MessageFilter {
  @override
  final Channel sourceChannel;

  @override
  final Channel targetChannel;

  @override
  final String name;

  /// The predicate function that determines whether a message passes the filter
  final MessagePredicate predicate;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Statistics for monitoring
  int _messagesReceived = 0;
  int _messagesPassed = 0;
  int _messagesFiltered = 0;

  /// Creates a new predicate-based message filter
  ///
  /// Example in democratic context:
  /// ```dart
  /// final topicFilter = PredicateMessageFilter(
  ///   sourceChannel: allDeliberationsChannel,
  ///   targetChannel: housingPolicyChannel,
  ///   name: 'housing-topic-filter',
  ///   predicate: (msg) => msg.metadata['topic'] == 'housing'
  /// );
  /// ```
  PredicateMessageFilter({
    required this.sourceChannel,
    required this.targetChannel,
    required this.name,
    required this.predicate,
  }) {
    _properties['type'] = 'predicate';
    _properties['status'] = _status;
  }

  @override
  String get type => 'predicate';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': _messagesReceived,
        'passed': _messagesPassed,
        'filtered': _messagesFiltered,
      };
    }
    return _properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    _properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    _properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    _properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(Message message) async {
    _messagesReceived++;

    // Apply predicate to determine if message passes filter
    if (predicate(message)) {
      // Pass message to target channel
      await targetChannel.send(message);
      _messagesPassed++;
    } else {
      // Message filtered out
      _messagesFiltered++;
    }
  }
}

/// Selector-based filter that examines specific fields or properties of messages
///
/// In a digital democracy context, selectors enable:
/// - Filtering deliberation messages by policy area
/// - Citizen-specific filtering based on interests
/// - Jurisdictional filtering for relevant governance levels
/// - Language preference filtering for multilingual democracy
class SelectorMessageFilter<T> implements MessageFilter {
  @override
  final Channel sourceChannel;

  @override
  final Channel targetChannel;

  @override
  final String name;

  /// Function that extracts a value from a message
  final T Function(Message) selector;

  /// Value against which the selector result is compared
  final T expectedValue;

  /// Optional comparator function
  final bool Function(T, T)? comparator;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Statistics for monitoring
  int _messagesReceived = 0;
  int _messagesPassed = 0;
  int _messagesFiltered = 0;

  /// Creates a new selector-based message filter
  ///
  /// Example in democratic context:
  /// ```dart
  /// final regionalFilter = SelectorMessageFilter<String>(
  ///   sourceChannel: allNotificationsChannel,
  ///   targetChannel: westDistrictChannel,
  ///   name: 'west-district-filter',
  ///   selector: (msg) => msg.metadata['region'] as String,
  ///   expectedValue: 'west-district'
  /// );
  /// ```
  SelectorMessageFilter({
    required this.sourceChannel,
    required this.targetChannel,
    required this.name,
    required this.selector,
    required this.expectedValue,
    this.comparator,
  }) {
    _properties['type'] = 'selector';
    _properties['status'] = _status;
    _properties['selectorType'] = expectedValue.runtimeType.toString();
  }

  @override
  String get type => 'selector';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': _messagesReceived,
        'passed': _messagesPassed,
        'filtered': _messagesFiltered,
      };
    }
    return _properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    _properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    _properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    _properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(Message message) async {
    _messagesReceived++;

    try {
      // Extract value using selector
      final value = selector(message);

      // Compare with expected value
      final matches =
          comparator != null
              ? comparator!(value, expectedValue)
              : value == expectedValue;

      if (matches) {
        // Pass message to target channel
        await targetChannel.send(message);
        _messagesPassed++;
      } else {
        // Message filtered out
        _messagesFiltered++;
      }
    } catch (e) {
      // Error extracting or comparing value
      _messagesFiltered++;
      print('Error filtering message: $e');
    }
  }
}

/// Composite filter that combines multiple filters with AND/OR/NOT logic
///
/// In a digital democracy context, composite filters enable:
/// - Multi-criteria deliberation filtering (topic AND jurisdiction)
/// - Interest-based filtering with complex rules (housing OR transportation)
/// - Exclusion filters (all messages EXCEPT administrative announcements)
/// - Time-sensitive filtering (active proposals AND not expired)
class CompositeMessageFilter implements MessageFilter {
  @override
  final Channel sourceChannel;

  @override
  final Channel targetChannel;

  @override
  final String name;

  /// The filters being combined
  final List<MessagePredicate> filters;

  /// The logical operation (AND, OR, NOT)
  final String operation;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Statistics for monitoring
  int _messagesReceived = 0;
  int _messagesPassed = 0;
  int _messagesFiltered = 0;

  /// Creates a new composite message filter
  ///
  /// Example in democratic context:
  /// ```dart
  /// final targetedAnnouncementFilter = CompositeMessageFilter(
  ///   sourceChannel: allAnnouncementsChannel,
  ///   targetChannel: citizenFeedChannel,
  ///   name: 'targeted-announcements',
  ///   filters: [
  ///     (msg) => msg.metadata['region'] == citizen.region,
  ///     (msg) => citizen.interests.contains(msg.metadata['topic']),
  ///   ],
  ///   operation: 'AND'
  /// );
  /// ```
  CompositeMessageFilter({
    required this.sourceChannel,
    required this.targetChannel,
    required this.name,
    required this.filters,
    required this.operation,
  }) {
    if (!['AND', 'OR', 'NOT'].contains(operation)) {
      throw ArgumentError('Operation must be one of: AND, OR, NOT');
    }

    if (operation == 'NOT' && filters.length != 1) {
      throw ArgumentError('NOT operation requires exactly one filter');
    }

    _properties['type'] = 'composite';
    _properties['status'] = _status;
    _properties['operation'] = operation;
    _properties['filterCount'] = filters.length;
  }

  @override
  String get type => 'composite';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': _messagesReceived,
        'passed': _messagesPassed,
        'filtered': _messagesFiltered,
      };
    }
    return _properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    _properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    _properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    _properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(Message message) async {
    _messagesReceived++;

    // Apply composite logic based on operation
    bool passes;

    switch (operation) {
      case 'AND':
        passes = filters.every((filter) => filter(message));
        break;
      case 'OR':
        passes = filters.any((filter) => filter(message));
        break;
      case 'NOT':
        passes = !filters.single(message);
        break;
      default:
        passes = false;
    }

    if (passes) {
      // Pass message to target channel
      await targetChannel.send(message);
      _messagesPassed++;
    } else {
      // Message filtered out
      _messagesFiltered++;
    }
  }
}
