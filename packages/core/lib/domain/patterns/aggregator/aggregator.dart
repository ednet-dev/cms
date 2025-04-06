part of ednet_core;

/// Function that extracts a correlation identifier from a message.
typedef CorrelationIdExtractor = dynamic Function(Message message);

/// Function that builds a result from a list of aggregated messages.
typedef ResultBuilder<T> = T Function(List<Message> messages);

/// The Aggregator pattern combines results of individual but related messages
/// into a single message.
///
/// When implementing direct democracy systems, aggregation is essential for:
/// * Combining individual votes into voting results
/// * Gathering citizen feedback on proposals from multiple sources
/// * Collecting signatures for initiatives across various platforms
/// * Assembling related documents/amendments into complete proposal packages
///
/// This implementation follows EDNet's domain-driven approach by:
/// * Modeling aggregation as a stateful process with clear life cycle
/// * Supporting multiple completion strategies (count-based, time-based)
/// * Integrating with the message and channel abstractions
/// * Providing correlation mechanisms to associate related messages
abstract class MessageAggregator<T> {
  /// Adds a message to be aggregated
  void addMessage(Message message);

  /// Checks if the aggregation is complete based on the strategy
  bool isComplete();

  /// Returns the aggregated result after all messages have been processed
  T getAggregatedResult();

  /// Clears all accumulated messages and resets the aggregator state
  void reset();
}

/// Aggregates messages until the expected count is reached.
///
/// The [CountBasedAggregator] is configured with an expected number of messages
/// and will complete once that many messages with the same correlation ID have
/// been received.
class CountBasedAggregator<T> implements MessageAggregator<T> {
  /// The expected number of messages to complete aggregation
  final int expectedCount;

  /// Function that extracts correlation ID from a message
  final CorrelationIdExtractor correlationIdExtractor;

  /// Function that builds the result from aggregated messages
  final ResultBuilder<T> resultBuilder;

  /// Messages indexed by correlation ID
  final Map<dynamic, List<Message>> _messagesByCorrelationId = {};

  /// Creates a new count-based aggregator.
  ///
  /// * [expectedCount] - Number of messages needed to complete aggregation
  /// * [correlationIdExtractor] - Extracts the correlation ID from messages
  /// * [resultBuilder] - Builds the final result from aggregated messages
  CountBasedAggregator({
    required this.expectedCount,
    required this.correlationIdExtractor,
    required this.resultBuilder,
  }) {
    if (expectedCount <= 0) {
      throw ArgumentError('Expected count must be positive');
    }
  }

  @override
  void addMessage(Message message) {
    final correlationId = correlationIdExtractor(message);

    if (correlationId == null) {
      throw ArgumentError('Message has no correlation ID');
    }

    _messagesByCorrelationId.putIfAbsent(correlationId, () => []);
    _messagesByCorrelationId[correlationId]!.add(message);
  }

  @override
  bool isComplete() {
    // Check if any group has reached the expected count
    return _messagesByCorrelationId.values.any(
      (messages) => messages.length >= expectedCount,
    );
  }

  @override
  T getAggregatedResult() {
    if (!isComplete()) {
      throw StateError('Aggregation is not complete');
    }

    // Find the first complete group
    final completeGroup = _messagesByCorrelationId.values.firstWhere(
      (messages) => messages.length >= expectedCount,
    );

    // Build the result using the provided builder function
    return resultBuilder(completeGroup);
  }

  @override
  void reset() {
    _messagesByCorrelationId.clear();
  }
}

/// Aggregates messages until a specified timeout period has elapsed.
///
/// The [TimeBasedAggregator] collects messages for a set duration and
/// then marks itself as complete. This is useful for scenarios where
/// messages arrive at unpredictable intervals but a result is needed
/// within a specific timeframe.
class TimeBasedAggregator<T> implements MessageAggregator<T> {
  /// Duration to wait before completing aggregation
  final Duration timeout;

  /// Function that extracts correlation ID from a message
  final CorrelationIdExtractor correlationIdExtractor;

  /// Function that builds the result from aggregated messages
  final ResultBuilder<T> resultBuilder;

  /// Messages indexed by correlation ID
  final Map<dynamic, List<Message>> _messagesByCorrelationId = {};

  /// Timers for each correlation group
  final Map<dynamic, Timer> _timers = {};

  /// Tracks which correlation groups are complete
  final Set<dynamic> _completedGroups = {};

  /// Creates a new time-based aggregator.
  ///
  /// * [timeout] - Duration to wait before completing aggregation
  /// * [correlationIdExtractor] - Extracts the correlation ID from messages
  /// * [resultBuilder] - Builds the final result from aggregated messages
  TimeBasedAggregator({
    required this.timeout,
    required this.correlationIdExtractor,
    required this.resultBuilder,
  });

  @override
  void addMessage(Message message) {
    final correlationId = correlationIdExtractor(message);

    if (correlationId == null) {
      throw ArgumentError('Message has no correlation ID');
    }

    // Don't accept messages for completed groups
    if (_completedGroups.contains(correlationId)) {
      return;
    }

    // Add message to its group
    _messagesByCorrelationId.putIfAbsent(correlationId, () => []);
    _messagesByCorrelationId[correlationId]!.add(message);

    // Start a timer for this correlation group if one doesn't exist
    if (!_timers.containsKey(correlationId)) {
      _timers[correlationId] = Timer(timeout, () {
        _completedGroups.add(correlationId);
      });
    }
  }

  @override
  bool isComplete() {
    return _completedGroups.isNotEmpty;
  }

  @override
  T getAggregatedResult() {
    if (!isComplete()) {
      throw StateError('Aggregation is not complete');
    }

    // Get the first completed group
    final correlationId = _completedGroups.first;
    final messages = _messagesByCorrelationId[correlationId] ?? [];

    // Build the result using the provided builder function
    return resultBuilder(messages);
  }

  @override
  void reset() {
    // Cancel all timers
    for (final timer in _timers.values) {
      timer.cancel();
    }

    _messagesByCorrelationId.clear();
    _timers.clear();
    _completedGroups.clear();
  }

  /// Cancels all active timers and releases resources
  void dispose() {
    reset();
  }
}

/// The Aggregator pattern combines multiple related messages into a single message.
///
/// This pattern is useful when:
/// 1. A meaningful business event requires information from multiple messages
/// 2. Messages arrive in different orders or at different times
/// 3. The system needs to reduce the volume of messages by combining related ones
///
/// In EDNet/direct democracy contexts, aggregation enables:
/// * Combining individual votes into voting tallies
/// * Gathering citizen feedback on proposals from multiple sources
/// * Summarizing deliberation activities for organizational stakeholders
/// * Consolidating reports from different governance committees
abstract class Aggregator {
  /// The channel that receives incoming messages to be aggregated
  Channel get inputChannel;

  /// The channel where aggregated messages are published
  Channel get outputChannel;

  /// Current status of the aggregator
  String get status;

  /// Starts the aggregator
  Future<void> start();

  /// Stops the aggregator
  Future<void> stop();

  /// Gets a configuration property by name
  dynamic getProperty(String name);

  /// Sets a configuration property
  void setProperty(String name, dynamic value);
}
