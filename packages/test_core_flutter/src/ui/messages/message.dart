part of ednet_core_flutter;

/// Base interface for all message types in the UI messaging system
abstract class Message {
  /// The unique identifier for this message
  String get id;

  /// The message type identifier
  String get type;

  /// The message payload (data)
  dynamic get payload;

  /// The message data (alias for payload)
  dynamic get data;

  /// Additional metadata for the message
  Map<String, dynamic>? get metadata;

  /// The source component that sent this message
  String get source;

  /// The destination component that should receive this message
  String? get destination;

  /// When the message was created
  DateTime get timestamp;
}
