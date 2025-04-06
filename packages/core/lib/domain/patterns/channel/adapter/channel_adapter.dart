part of ednet_core;

/// The Channel Adapter pattern connects messaging channels to external systems.
///
/// This pattern allows integration with external applications or services that
/// don't natively support messaging channels. Adapters translate between the
/// messaging interface and the external system's API.
///
/// In EDNet/direct democracy contexts, channel adapters enable:
/// * Integration with legacy government systems
/// * Connecting to external data sources for informed decision-making
/// * Publishing democratic outcomes to public platforms
/// * Bridging between different citizen participation platforms
abstract class ChannelAdapter {
  /// The channel this adapter connects to
  Channel get channel;

  /// Name of this adapter
  String get name;

  /// Type of this adapter (HTTP, WebSocket, etc.)
  String get type;

  /// Current status of the adapter
  String get status;

  /// Starts the adapter
  Future<void> start();

  /// Stops the adapter
  Future<void> stop();

  /// Gets a configuration property by name
  dynamic getProperty(String name);

  /// Sets a configuration property
  void setProperty(String name, dynamic value);
}

/// HTTP-based Channel Adapter implementation.
///
/// This adapter allows HTTP communication with external systems by:
/// * Converting HTTP requests to messages on a channel
/// * Converting channel messages to HTTP responses
/// * Managing the lifecycle of HTTP connections
///
/// In EDNet/direct democracy contexts, HTTP adapters connect:
/// * Mobile voting apps to the voting infrastructure
/// * Government API gateways to deliberation platforms
/// * External validation services to identity verification
class HttpChannelAdapter implements ChannelAdapter {
  @override
  final Channel channel;

  @override
  final String name;

  /// Base URL for this adapter
  final String baseUrl;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new HTTP channel adapter
  HttpChannelAdapter({
    required this.channel,
    required this.baseUrl,
    required this.name,
  }) {
    _properties['baseUrl'] = baseUrl;
    _properties['type'] = 'HTTP';
    _properties['configuration'] = json.encode({'baseUrl': baseUrl});
  }

  @override
  String get type => 'HTTP';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) => _properties[name];

  @override
  void setProperty(String name, dynamic value) {
    _properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to channel messages
    _subscription = channel.receive().listen(_handleChannelMessage);

    // Update status
    _status = 'active';
    _properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    _properties['status'] = _status;
  }

  /// Handles an HTTP request, transforming it to a message
  Future<void> handleRequest(HttpRequest request) async {
    try {
      // Extract data from request
      final payload = _parseRequestBody(request);

      // Generate a unique request ID
      final requestId =
          'req-${DateTime.now().millisecondsSinceEpoch}-${_randomString(6)}';

      // Create a message with HTTP metadata
      final message = Message(
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

      // Send message to channel
      await channel.send(message);
    } catch (e) {
      // Log exception
      print('Error handling HTTP request: $e');
      rethrow;
    }
  }

  /// Creates an HTTP response from a message
  Future<HttpResponse> createResponse(Message message) async {
    // Extract status code from metadata or default to 200
    final statusCode =
        message.metadata['httpStatusCode'] as int? ??
        message.metadata['statusCode'] as int? ??
        200;

    // Extract content type or default to application/json
    final contentType =
        message.metadata['contentType'] as String? ?? 'application/json';

    // Create response headers
    final headers = <String, String>{'Content-Type': contentType};

    // Add any additional headers
    final messageHeaders = message.metadata['headers'];
    if (messageHeaders is Map<String, String>) {
      headers.addAll(messageHeaders);
    }

    // Serialize body based on content type
    String body;
    if (contentType.contains('application/json')) {
      body = json.encode(message.payload);
    } else {
      body = message.payload.toString();
    }

    return HttpResponse(statusCode: statusCode, headers: headers, body: body);
  }

  /// Processes a message from the channel
  void _handleChannelMessage(Message message) {
    // In a real implementation, this would convert the message to an HTTP response
    // and send it to the appropriate client
    print('Received message from channel: ${message.id}');
  }

  /// Parse request body based on content type
  Map<String, dynamic> _parseRequestBody(HttpRequest request) {
    if (request.body == null || request.body!.isEmpty) {
      return {};
    }

    final contentType = request.headers['Content-Type'] ?? '';

    if (contentType.contains('application/json')) {
      try {
        return json.decode(request.body!) as Map<String, dynamic>;
      } catch (e) {
        return {'error': 'Invalid JSON: $e'};
      }
    } else if (contentType.contains('text/plain')) {
      return {'content': request.body};
    } else {
      return {'rawContent': request.body};
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

/// WebSocket-based Channel Adapter implementation.
///
/// This adapter enables real-time bidirectional communication by:
/// * Converting WebSocket messages to channel messages
/// * Converting channel messages to WebSocket messages
/// * Managing WebSocket connections and lifecycle
///
/// In EDNet/direct democracy contexts, WebSocket adapters enable:
/// * Real-time vote counting displays
/// * Live deliberation platforms
/// * Collaborative amendment drafting
/// * Instant citizen feedback during public hearings
class WebSocketChannelAdapter implements ChannelAdapter {
  @override
  final Channel channel;

  @override
  final String name;

  /// Path for WebSocket connections
  final String path;

  /// Optional protocol
  final String? protocol;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new WebSocket channel adapter
  WebSocketChannelAdapter({
    required this.channel,
    required this.name,
    required this.path,
    this.protocol,
  }) {
    _properties['path'] = path;
    _properties['type'] = 'WebSocket';
    _properties['protocol'] = protocol;
    final config = {'path': path, if (protocol != null) 'protocol': protocol};
    _properties['configuration'] = json.encode(config);
  }

  @override
  String get type => 'WebSocket';

  @override
  String get status => _status;

  @override
  dynamic getProperty(String name) => _properties[name];

  @override
  void setProperty(String name, dynamic value) {
    _properties[name] = value;
  }

  @override
  Future<void> start() async {
    if (_status == 'active') return;

    // Subscribe to channel messages
    _subscription = channel.receive().listen(_handleChannelMessage);

    // Update status
    _status = 'active';
    _properties['status'] = _status;
  }

  @override
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
    _properties['status'] = _status;
  }

  /// Handles an incoming WebSocket message
  Future<void> handleMessage(String messageData) async {
    dynamic payload;

    try {
      // Try to parse as JSON
      payload = json.decode(messageData);
    } catch (e) {
      // If not JSON, use as text
      payload = {'text': messageData};
    }

    // Create message with WebSocket metadata
    final message = Message(
      payload: payload,
      metadata: {
        'source': 'websocket',
        'path': path,
        'timestamp': DateTime.now().toIso8601String(),
        'protocol': protocol,
      },
    );

    // Send to channel
    await channel.send(message);
  }

  /// Processes a message from the channel
  void _handleChannelMessage(Message message) {
    // Convert message to WebSocket format and send to clients
    final data = createWebSocketMessage(message);
    // In a real implementation, would send to connected WebSocket clients
    print('Would send to WebSocket clients: $data');
  }

  /// Create a WebSocket message from a channel message
  String createWebSocketMessage(Message message) {
    // For JSON content, serialize to JSON string
    if (message.payload is Map || message.payload is List) {
      return json.encode(message.payload);
    }

    // Otherwise convert to string
    return message.payload.toString();
  }
}
