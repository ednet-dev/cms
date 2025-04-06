import 'dart:async';
import 'package:meta/meta.dart';
import 'base_message.dart';

/// A communication channel that enables message exchange between components.
///
/// The [Channel] abstraction represents a logical connector through which
/// messages flow between components in an integration architecture. In EIP,
/// channels are foundational building blocks for decoupling message producers
/// from consumers.
///
/// In a direct democracy context, channels could represent:
/// * Topic-specific discussion threads
/// * Voting pipelines for particular proposals
/// * Notification streams for community events
/// * Feedback mechanisms between citizens and representatives
abstract class Channel {
  /// Unique identifier for this channel
  final String id;

  /// Optional name for human-readable identification
  final String? name;

  /// Constructs a new channel with the given id and optional name
  Channel({required this.id, this.name});

  /// Sends a message to this channel
  ///
  /// Returns a Future that completes when the message has been sent.
  Future<void> send(Message message);

  /// Receives messages from this channel
  ///
  /// Returns a Stream of [Message] objects that can be listened to.
  /// The stream should only complete if the channel is explicitly closed.
  Stream<Message> receive();

  /// Closes this channel, releasing any resources
  Future<void> close();
}

/// Memory-based implementation of [Channel] for testing and simple scenarios.
///
/// The [InMemoryChannel] uses a Dart [StreamController] to manage message flow
/// and is useful for unit testing or simple in-process messaging.
class InMemoryChannel extends Channel {
  /// Controls the message stream
  final StreamController<Message> _controller;
  final List<Message> _messages = [];

  /// Creates a new in-memory channel with the given ID and optional name.
  ///
  /// If [broadcast] is true, multiple subscribers can listen to the channel.
  InMemoryChannel({required String id, String? name, bool broadcast = false})
    : _controller =
          broadcast
              ? StreamController<Message>.broadcast()
              : StreamController<Message>(),
      super(id: id, name: name);

  @override
  Future<void> send(Message message) async {
    if (_controller.isClosed) {
      throw StateError('Cannot send messages to a closed channel');
    }
    _messages.add(message);
    _controller.add(message);
  }

  @override
  Stream<Message> receive() {
    return _controller.stream;
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }

  /// Returns the number of messages that have been sent to this channel
  int get messageCount => _messages.length;
}
