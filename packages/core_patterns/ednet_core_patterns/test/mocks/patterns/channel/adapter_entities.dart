import 'dart:async';
import 'dart:convert';
import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;

/// Represents an HTTP request for testing
class HttpRequest {
  /// The HTTP method (GET, POST, etc.)
  final String method;

  /// The request path
  final String path;

  /// HTTP headers
  final Map<String, String> headers;

  /// Query parameters
  final Map<String, String>? queryParameters;

  /// Request body
  final String? body;

  /// Creates a new test HTTP request
  HttpRequest({
    required this.method,
    required this.path,
    this.headers = const {},
    this.queryParameters,
    this.body,
  });
}

/// Represents an HTTP response for testing
class HttpResponse {
  /// HTTP status code
  final int statusCode;

  /// HTTP headers
  final Map<String, String> headers;

  /// Response body
  final String body;

  /// Creates a new test HTTP response
  HttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });
}

/// A lightweight adapter for HTTP communication in testing
///
/// This adapter simplifies testing of HTTP integration scenarios in a digital democracy platform such as:
/// - Voting registration and submission systems
/// - Citizen identity verification services
/// - External API integration for democratic services
/// - Open data portals for government transparency
class TestHttpChannelAdapter {
  /// The communication channel
  final patterns.Channel channel;

  /// Base URL for HTTP connections
  final String baseUrl;

  /// Configuration and properties
  final Map<String, dynamic> properties = {};

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new test HTTP adapter
  TestHttpChannelAdapter({
    required this.channel,
    required this.baseUrl,
    required String name,
  }) {
    properties['name'] = name;
    properties['type'] = 'HTTP';
    properties['status'] = 'inactive';
    properties['baseUrl'] = baseUrl;
    properties['configuration'] = json.encode({'baseUrl': baseUrl});
  }

  /// Gets the name of this adapter
  String get name => properties['name'] as String;

  /// Gets the type of this adapter
  String get type => properties['type'] as String;

  /// Gets the status of this adapter
  String get status => properties['status'] as String;

  /// Gets a property
  dynamic getProperty(String name) => properties[name];

  /// Sets a property
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  /// Starts the adapter and begins listening for messages
  Future<void> start() async {
    if (status == 'active') return;

    // Subscribe to channel messages
    _subscription = channel.receive().listen(_handleChannelMessage);

    // Update status
    setProperty('status', 'active');
  }

  /// Stops the adapter and releases resources
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    setProperty('status', 'inactive');
  }

  /// Handles an HTTP request from an external system
  Future<void> handleRequest(HttpRequest request) async {
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

  /// Creates an HTTP response from a message
  Future<HttpResponse> handleOutgoingMessage(patterns.Message message) async {
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
    return HttpResponse(statusCode: statusCode, headers: headers, body: body);
  }

  /// Handles a message from the channel
  void _handleChannelMessage(patterns.Message message) {
    // In a real implementation, would convert messages to HTTP responses
    // and route them to the appropriate destination
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

/// A lightweight adapter for WebSocket communication in testing
///
/// This adapter facilitates testing of real-time democratic features such as:
/// - Live voting results and participation tracking
/// - Instant deliberation and feedback channels
/// - Real-time notification of citizen participation opportunities
/// - Live streaming of town halls and public hearings
class TestWebSocketChannelAdapter {
  /// The communication channel
  final patterns.Channel channel;

  /// Path for WebSocket connections
  final String path;

  /// Optional protocol
  final String? protocol;

  /// Configuration and properties
  final Map<String, dynamic> properties = {};

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new test WebSocket adapter
  TestWebSocketChannelAdapter({
    required this.channel,
    required this.path,
    this.protocol,
    required String name,
  }) {
    properties['name'] = name;
    properties['type'] = 'WebSocket';
    properties['status'] = 'inactive';
    properties['path'] = path;
    if (protocol != null) {
      properties['protocol'] = protocol;
    }
  }

  /// Gets the name of this adapter
  String get name => properties['name'] as String;

  /// Gets the type of this adapter
  String get type => properties['type'] as String;

  /// Gets the status of this adapter
  String get status => properties['status'] as String;

  /// Gets a property
  dynamic getProperty(String name) => properties[name];

  /// Sets a property
  void setProperty(String name, dynamic value) {
    properties[name] = value;
  }

  /// Starts the adapter and begins listening for messages
  Future<void> start() async {
    if (status == 'active') return;

    // Subscribe to channel messages
    _subscription = channel.receive().listen(_handleChannelMessage);

    // Update status
    setProperty('status', 'active');
  }

  /// Stops the adapter and releases resources
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    setProperty('status', 'inactive');
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

  /// Creates a WebSocket message from a channel message
  Future<String> handleOutgoingMessage(patterns.Message message) async {
    // In a real implementation, this might use different serialization
    // based on message type or other factors
    return json.encode(message.payload);
  }

  /// Handles a message from the channel
  void _handleChannelMessage(patterns.Message message) {
    // Convert message to WebSocket format and send to clients
    handleOutgoingMessage(message).then((data) {
      // In a real implementation, would send to connected WebSocket clients
      print('Would send to WebSocket clients: $data');
    });
  }
}
