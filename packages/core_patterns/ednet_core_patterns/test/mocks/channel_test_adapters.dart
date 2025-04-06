import 'dart:async';
import 'dart:convert';
import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;

/// A simplified version of ChannelAdapter for testing
class TestChannelAdapter {
  /// The channel this adapter connects to
  final patterns.Channel channel;

  /// Configuration data
  final Map<String, dynamic> properties = {};

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new test adapter
  TestChannelAdapter({
    required this.channel,
    required String name,
    required String type,
  }) {
    properties['name'] = name;
    properties['type'] = type;
    properties['status'] = 'inactive';
  }

  /// Gets a property value
  dynamic getProperty(String name) => properties[name];

  /// Sets a property value
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  /// Gets the name of this adapter
  String get name => properties['name'] as String;

  /// Gets the type of this adapter
  String get type => properties['type'] as String;

  /// Gets the status of this adapter
  String get status => properties['status'] as String;

  /// Starts the adapter
  Future<void> start() async {
    if (status == 'active') return;

    // Subscribe to channel messages
    _subscription = channel.receive().listen(_handleChannelMessage);

    // Update status
    setProperty('status', 'active');
  }

  /// Stops the adapter
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    setProperty('status', 'inactive');
  }

  /// Handles a message from the channel
  void _handleChannelMessage(patterns.Message message) {
    // Override in subclasses
  }
}

/// HTTP Channel Adapter implementation for testing
class TestHttpChannelAdapter extends TestChannelAdapter {
  /// Base URL for this adapter
  final String baseUrl;

  /// Completers for pending requests
  final Map<String, Completer<patterns.HttpResponse>> _pendingRequests = {};

  /// Creates a new HTTP adapter
  TestHttpChannelAdapter({
    required patterns.Channel channel,
    required this.baseUrl,
    String name = 'test-http-adapter',
  }) : super(channel: channel, name: name, type: 'HTTP') {
    // Store configuration as JSON
    final config = {'baseUrl': baseUrl};
    setProperty('configuration', json.encode(config));
  }

  /// Handles an HTTP request
  Future<void> handleRequest(patterns.HttpRequest request) async {
    try {
      // Parse request body based on content type
      final payload =
          request.body != null && request.body!.isNotEmpty
              ? _parseBody(request.body!, request.headers['Content-Type'])
              : <String, dynamic>{};

      // Generate a unique request ID
      final requestId =
          'req-${DateTime.now().millisecondsSinceEpoch}-${_randomString(6)}';

      // Create a message with HTTP metadata
      final message = patterns.Message(
        payload: payload,
        metadata: {
          'httpMethod': request.method,
          'httpPath': request.path,
          'requestId': requestId,
          if (request.headers.containsKey('Content-Type'))
            'contentType': request.headers['Content-Type'],
          if (request.queryParameters != null)
            'queryParams': request.queryParameters,
        },
      );

      // Send the message to the channel
      await channel.send(message);
    } catch (e) {
      // Log exception
      print('Error handling HTTP request: $e');
      rethrow;
    }
  }

  /// Handles a message to create an HTTP response
  Future<patterns.HttpResponse> handleOutgoingMessage(
    patterns.Message message,
  ) async {
    // Extract status code from metadata (default to 200)
    final statusCode = message.metadata['httpStatusCode'] as int? ?? 200;

    // Determine content type (default to application/json)
    final contentType =
        message.metadata['contentType'] as String? ?? 'application/json';

    // Prepare headers
    final headers = <String, String>{'Content-Type': contentType};

    // Add any additional headers from metadata
    if (message.metadata.containsKey('headers') &&
        message.metadata['headers'] is Map<String, String>) {
      headers.addAll(message.metadata['headers'] as Map<String, String>);
    }

    // Serialize body based on content type
    String body;
    if (contentType.contains('application/json')) {
      body = json.encode(message.payload);
    } else if (contentType.contains('text/')) {
      body = message.payload.toString();
    } else {
      // Default to JSON
      body = json.encode(message.payload);
    }

    // Create and return the response
    return patterns.HttpResponse(
      statusCode: statusCode,
      headers: headers,
      body: body,
    );
  }

  @override
  void _handleChannelMessage(patterns.Message message) {
    // Check if this is a response to a pending request
    if (message.metadata.containsKey('requestId') &&
        _pendingRequests.containsKey(message.metadata['requestId'])) {
      final completer = _pendingRequests.remove(message.metadata['requestId']);

      // Create an HTTP response from the message
      handleOutgoingMessage(message)
          .then((response) => completer?.complete(response))
          .catchError((error) => completer?.completeError(error));
    }
  }

  /// Parses an HTTP body based on content type
  dynamic _parseBody(String body, String? contentType) {
    if (contentType == null || body.isEmpty) {
      return <String, dynamic>{};
    }

    if (contentType.contains('application/json')) {
      try {
        return json.decode(body);
      } catch (e) {
        return {'rawContent': body};
      }
    } else if (contentType.contains('text/')) {
      return {'content': body};
    } else {
      return {'rawContent': body};
    }
  }

  /// Generates a random string for IDs
  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().microsecondsSinceEpoch;
    final result = StringBuffer();

    for (var i = 0; i < length; i++) {
      result.write(chars[random % chars.length]);
    }

    return result.toString();
  }
}

/// WebSocket Channel Adapter implementation for testing
class TestWebSocketChannelAdapter extends TestChannelAdapter {
  /// Path for WebSocket connections
  final String path;

  /// Optional protocol
  final String? protocol;

  /// Creates a new WebSocket adapter
  TestWebSocketChannelAdapter({
    required patterns.Channel channel,
    required this.path,
    this.protocol,
    String name = 'test-websocket-adapter',
  }) : super(channel: channel, name: name, type: 'WebSocket') {
    // Store configuration as JSON
    final config = {'path': path, if (protocol != null) 'protocol': protocol};
    setProperty('configuration', json.encode(config));
  }

  /// Handles incoming WebSocket data
  Future<void> handleIncomingData(String data) async {
    try {
      // Parse the data as JSON
      final payload = json.decode(data);

      // Create a message with WebSocket metadata
      final message = patterns.Message(
        payload: payload,
        metadata: {
          'source': 'websocket',
          'path': path,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Send the message to the channel
      await channel.send(message);
    } catch (e) {
      // Log error
      print('Error handling WebSocket data: $e');
      rethrow;
    }
  }

  /// Handles a message, creating WebSocket output
  Future<String> handleOutgoingMessage(patterns.Message message) async {
    // In a real implementation, this might use different serialization
    // based on message type or other factors
    return json.encode(message.payload);
  }

  @override
  void _handleChannelMessage(patterns.Message message) {
    // Convert message to WebSocket format and send to clients
    handleOutgoingMessage(message).then((data) {
      // In a real implementation, this would send to connected clients
      print('Would send to WebSocket clients: $data');
    });
  }
}
