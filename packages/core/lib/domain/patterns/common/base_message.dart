part of ednet_core;

/// A core message type used across Enterprise Integration Patterns.
///
/// The [Message] class represents the fundamental unit of communication in
/// messaging-based systems. Messages are immutable value objects that contain:
///
/// * [payload] - The main content/data of the message
/// * [metadata] - Additional information about the message (headers, routing information, etc.)
/// * [id] - Unique identifier for the message
///
/// In a direct democracy context, messages could represent:
/// * Votes being cast
/// * Proposals being submitted or amended
/// * Notifications about deliberation processes
/// * Results of collective decision-making
class Message extends ValueObject {
  /// The primary data/content carried by this message
  final dynamic payload;

  /// Additional properties that describe or contextualize the message
  final Map<String, dynamic> metadata;

  /// Unique identifier for this message instance
  final String id;

  /// Creates a new Message with the given [payload] and optional [metadata].
  ///
  /// If [id] is not provided, a new random ID will be generated.
  Message({required this.payload, Map<String, dynamic>? metadata, String? id})
    : metadata = metadata ?? {},
      id = id ?? _generateId() {
    validate();
  }

  /// Creates a copy of this message with optionally modified properties
  @override
  Message copyWith({
    dynamic payload,
    Map<String, dynamic>? metadata,
    String? id,
  }) {
    return Message(
      payload: payload ?? this.payload,
      metadata: metadata ?? Map.from(this.metadata),
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, payload ?? Object(), metadata];

  /// Simple utility method to compare maps
  static bool _mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    return map1.entries.every(
      (entry) => map2.containsKey(entry.key) && map2[entry.key] == entry.value,
    );
  }

  /// Generates a random ID for a message
  static String _generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1000000).toString().padLeft(6, '0');
    return '$now-$random';
  }
}
