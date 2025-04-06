import 'dart:async';
import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;

/// Base test interface for all filter implementations
///
/// In a digital democracy platform, filters serve to organize and target
/// democratic deliberation, ensuring citizens receive relevant information
/// and participate in appropriate forums
abstract class TestMessageFilter {
  /// The source channel from which messages are filtered
  patterns.Channel get sourceChannel;

  /// The target channel to which filtered messages are sent
  patterns.Channel get targetChannel;

  /// Unique name for this filter
  String get name;

  /// Type of filter (predicate, selector, composite)
  String get type;

  /// Current filter status (active, inactive)
  String get status;

  /// Starts the filter operation
  Future<void> start();

  /// Stops the filter operation
  Future<void> stop();

  /// Gets filter properties and statistics
  dynamic getProperty(String name);

  /// Sets filter configuration parameters
  void setProperty(String name, dynamic value);
}

/// Test implementation of a predicate-based message filter
///
/// In a digital democracy context, predicate filters enable:
/// - Topic-based routing of citizen deliberation
/// - Content moderation to maintain civil democratic discourse
/// - Jurisdictional filtering for appropriate governance levels
/// - Accessibility filtering for inclusive participation
class TestPredicateFilter implements TestMessageFilter {
  @override
  final patterns.Channel sourceChannel;

  @override
  final patterns.Channel targetChannel;

  @override
  final String name;

  /// Function that determines if a message passes the filter
  final bool Function(patterns.Message) predicate;

  /// Configuration properties
  final Map<String, dynamic> properties = {};

  /// Current operational status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Message processing statistics
  int messagesReceived = 0;
  int messagesPassed = 0;
  int messagesFiltered = 0;

  /// Creates a new test predicate filter
  TestPredicateFilter({
    required this.sourceChannel,
    required this.targetChannel,
    required this.name,
    required this.predicate,
  }) {
    properties['type'] = 'predicate';
    properties['status'] = _status;
  }

  @override
  String get type => 'predicate';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': messagesReceived,
        'passed': messagesPassed,
        'filtered': messagesFiltered,
      };
    }
    return properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(patterns.Message message) async {
    messagesReceived++;

    // Apply predicate to determine if message passes filter
    if (predicate(message)) {
      // Pass message to target channel
      await targetChannel.send(message);
      messagesPassed++;
    } else {
      // Message filtered out
      messagesFiltered++;
    }
  }
}

/// Test implementation of a selector-based message filter
///
/// In a digital democracy context, selector filters enable:
/// - Filtering deliberation by policy domain
/// - Regional/jurisdictional message routing
/// - Language selection for multilingual democratic participation
/// - Interest-based content targeting for citizens
class TestSelectorFilter<T> implements TestMessageFilter {
  @override
  final patterns.Channel sourceChannel;

  @override
  final patterns.Channel targetChannel;

  @override
  final String name;

  /// Selector function that extracts a value from a message
  final T Function(patterns.Message) selector;

  /// Value that the selector result is compared against
  final T expectedValue;

  /// Optional custom comparator
  final bool Function(T, T)? comparator;

  /// Configuration properties
  final Map<String, dynamic> properties = {};

  /// Current operational status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Message processing statistics
  int messagesReceived = 0;
  int messagesPassed = 0;
  int messagesFiltered = 0;

  /// Creates a new test selector filter
  TestSelectorFilter({
    required this.sourceChannel,
    required this.targetChannel,
    required this.name,
    required this.selector,
    required this.expectedValue,
    this.comparator,
  }) {
    properties['type'] = 'selector';
    properties['status'] = _status;
    properties['selectorType'] = expectedValue.runtimeType.toString();
  }

  @override
  String get type => 'selector';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': messagesReceived,
        'passed': messagesPassed,
        'filtered': messagesFiltered,
      };
    }
    return properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(patterns.Message message) async {
    messagesReceived++;

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
        messagesPassed++;
      } else {
        // Message filtered out
        messagesFiltered++;
      }
    } catch (e) {
      // Error extracting or comparing value
      messagesFiltered++;
      print('Error filtering message: $e');
    }
  }
}

/// Test implementation of a composite message filter
///
/// In a digital democracy context, composite filters enable:
/// - Multi-criteria citizen targeting (topic AND region)
/// - Complex deliberation filtering (housing OR transportation policies)
/// - Exclusion filters (all messages EXCEPT administrative)
/// - Time-sensitive democratic processes (active proposals AND not expired)
class TestCompositeFilter implements TestMessageFilter {
  @override
  final patterns.Channel sourceChannel;

  @override
  final patterns.Channel targetChannel;

  @override
  final String name;

  /// The predicates being combined
  final List<bool Function(patterns.Message)> filters;

  /// The logical operation (AND, OR, NOT)
  final String operation;

  /// Configuration properties
  final Map<String, dynamic> properties = {};

  /// Current operational status
  String _status = 'inactive';

  /// Subscription to source channel messages
  StreamSubscription? _subscription;

  /// Message processing statistics
  int messagesReceived = 0;
  int messagesPassed = 0;
  int messagesFiltered = 0;

  /// Creates a new test composite filter
  TestCompositeFilter({
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

    properties['type'] = 'composite';
    properties['status'] = _status;
    properties['operation'] = operation;
    properties['filterCount'] = filters.length;
  }

  @override
  String get type => 'composite';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': messagesReceived,
        'passed': messagesPassed,
        'filtered': messagesFiltered,
      };
    }
    return properties[name];
  }

  @override
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to source channel messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update status
    _status = 'active';
    properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    properties['status'] = _status;
  }

  /// Processes a message from the source channel
  Future<void> _processMessage(patterns.Message message) async {
    messagesReceived++;

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
      messagesPassed++;
    } else {
      // Message filtered out
      messagesFiltered++;
    }
  }
}
