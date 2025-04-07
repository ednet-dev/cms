part of ednet_core_flutter;

/// Default implementation of the Message interface for UI components
class UXMessage implements Message {
  @override
  final String id;

  @override
  final String type;

  @override
  final Map<String, Object?> payload;

  @override
  final String source;

  @override
  final String? destination;

  @override
  final DateTime timestamp;

  @override
  final Map<String, Object?>? metadata;

  @override
  Map<String, Object?> get data => payload;

  /// Creates a new UXMessage
  UXMessage({
    required this.id,
    required this.type,
    required this.payload,
    required this.source,
    this.destination,
    this.metadata,
  }) : timestamp = DateTime.now();

  /// Creates a UXMessage with a randomly generated ID
  factory UXMessage.create({
    required String type,
    required Map<String, Object?> payload,
    required String source,
    String? destination,
    Map<String, Object?>? metadata,
  }) {
    final id = '${type}_${source}_${DateTime.now().millisecondsSinceEpoch}';
    return UXMessage(
      id: id,
      type: type,
      payload: payload,
      source: source,
      destination: destination,
      metadata: metadata,
    );
  }
}
