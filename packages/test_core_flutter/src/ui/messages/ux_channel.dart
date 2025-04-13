part of ednet_core_flutter;

/// Channel for UX message routing
class Channel {
  final String name;
  final StreamController<Message> _controller =
      StreamController<Message>.broadcast();

  /// Stream of messages on this channel
  Stream<Message> get messages => _controller.stream;

  /// Creates a new channel with the given name
  Channel(this.name);

  /// Sends a message to this channel
  void send(Message message) {
    _controller.add(message);
  }

  /// Closes the channel
  void dispose() {
    _controller.close();
  }
}

/// Channel specifically for UI component communication
class UXChannel {
  /// The unique identifier for this channel
  final String id;

  /// The name of this channel
  final String name;

  final StreamController<Message> _controller =
      StreamController<Message>.broadcast();

  /// Constructor that creates a channel specifically for UI messages
  UXChannel(this.id, {required this.name});

  /// Stream of messages on this channel
  Stream<Message> get messages => _controller.stream;

  /// Send a message through this channel
  void send(Message message) {
    _controller.add(message);
  }

  /// Close the channel
  void dispose() {
    _controller.close();
  }

  /// Send a UI message through this channel
  void sendUXMessage(UXMessage message) => send(message);

  /// Register a handler for UI messages of a specific type
  void onUXMessageType(String type, Function(UXMessage) handler) {
    messages.listen((message) {
      if (message is UXMessage && message.type == type) {
        handler(message);
      }
    });
  }
}
