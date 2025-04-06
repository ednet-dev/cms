import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../common/base_message.dart';
import '../../common/channel.dart';
import '../../common/http_models.dart';

/// Domain model for the Channel Adapter pattern within EDNet Core.
///
/// This pattern connects applications to messaging channels by translating
/// between different protocols and the standard messaging format.
class ChannelAdapterDomain {
  /// Creates the domain model for Channel Adapter pattern
  static Domain createDomain() {
    // Create domain for Channel Adapter pattern
    final domain = Domain('ChannelAdapter');
    domain.description =
        'Channel Adapter pattern for connecting systems to messaging channels';

    // Create model within domain
    final model = Model(domain, 'ChannelAdapterModel');
    model.description = 'Model for the Channel Adapter pattern';

    // Create core concepts
    final adapterConcept = Concept(model, 'Adapter');
    adapterConcept.description =
        'An adapter that connects external systems to messaging channels';
    adapterConcept.entry = true;

    // Add attributes to adapter concept
    final adapterNameAttr = Attribute(adapterConcept, 'name');
    adapterNameAttr.type = domain.getType('String');
    adapterNameAttr.identifier = true;

    final adapterTypeAttr = Attribute(adapterConcept, 'type');
    adapterTypeAttr.type = domain.getType('String');
    adapterTypeAttr.required = true;

    final statusAttr = Attribute(adapterConcept, 'status');
    statusAttr.type = domain.getType('String');
    statusAttr.init = 'inactive';

    final configurationAttr = Attribute(adapterConcept, 'configuration');
    configurationAttr.type = domain.getType('String');
    // Instead of using description
    adapterConcept.label = 'JSON-encoded configuration for the adapter';

    // Create message concept (for handled messages)
    final messageConcept = Concept(model, 'Message');
    messageConcept.description = 'A message processed by the adapter';

    // Create channel concept
    final channelConcept = Concept(model, 'Channel');
    channelConcept.description =
        'A messaging channel that the adapter connects to';

    // Create relationships
    final channelRelationship = Parent(
      adapterConcept,
      channelConcept,
      'channel',
    );
    channelRelationship.identifier = false;
    channelRelationship.required = true;
    channelRelationship.internal = true;

    final messageChild = Child(adapterConcept, messageConcept, 'messages');
    messageChild.internal = true;

    // Create HTTP-specific concepts
    final httpRequestConcept = Concept(model, 'HttpRequest');
    httpRequestConcept.description =
        'An HTTP request handled by an HTTP adapter';

    final methodAttr = Attribute(httpRequestConcept, 'method');
    methodAttr.type = domain.getType('String');
    methodAttr.required = true;

    final pathAttr = Attribute(httpRequestConcept, 'path');
    pathAttr.type = domain.getType('String');
    pathAttr.required = true;

    final bodyAttr = Attribute(httpRequestConcept, 'body');
    bodyAttr.type = domain.getType('String');

    // Create response concept
    final httpResponseConcept = Concept(model, 'HttpResponse');
    httpResponseConcept.description =
        'An HTTP response produced by an HTTP adapter';

    final statusCodeAttr = Attribute(httpResponseConcept, 'statusCode');
    statusCodeAttr.type = domain.getType('int');
    statusCodeAttr.required = true;

    final responseBodyAttr = Attribute(httpResponseConcept, 'body');
    responseBodyAttr.type = domain.getType('String');

    // Create WebSocket-specific concepts
    final webSocketConcept = Concept(model, 'WebSocket');
    webSocketConcept.description =
        'A WebSocket connection handled by a WebSocket adapter';

    final pathWsAttr = Attribute(webSocketConcept, 'path');
    pathWsAttr.type = domain.getType('String');
    pathWsAttr.required = true;

    final protocolAttr = Attribute(webSocketConcept, 'protocol');
    protocolAttr.type = domain.getType('String');

    return domain;
  }
}

/// Channel Adapter pattern for EDNet Core-based applications
///
/// The Channel Adapter pattern enables integration between messaging channels
/// and external systems using different protocols. In direct democracy contexts,
/// these adapters facilitate:
///
/// - Secure voting system integration across infrastructure boundaries
/// - Connection of diverse citizen participation platforms to core deliberation systems
/// - Real-time streaming of democratic processes to citizens across devices
/// - Integration with government APIs and identity verification services
abstract class ChannelAdapter {
  /// The channel this adapter connects to
  Channel get channel;

  /// Unique name for this adapter
  String get name;

  /// Protocol or communication type used by this adapter
  String get type;

  /// Current adapter status (active, inactive, etc.)
  String get status;

  /// Starts the adapter
  Future<void> start();

  /// Stops the adapter
  Future<void> stop();

  /// Gets a configuration property
  dynamic getProperty(String name);

  /// Sets a configuration property
  void setProperty(String name, dynamic value);
}

/// Adapter for HTTP communication with external systems
///
/// In a direct democracy context, this adapter enables:
/// - Integration with government identity services for voter verification
/// - Secure transmission of votes via standard HTTP protocols
/// - REST API access to civic data repositories
/// - Web-based submission of citizen feedback
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

  /// Creates a new HTTP adapter
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
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
  }

  /// Handles an HTTP request, converting it to a message
  ///
  /// For example, a citizen's vote submission via HTTP is converted
  /// to an internal message format for the voting system to process
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

      // Send the message to the channel
      await channel.send(message);
    } catch (e) {
      // Log exception
      print('Error handling HTTP request: $e');
      rethrow;
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

  /// Handles a message from the channel, potentially converting to HTTP response
  void _handleChannelMessage(Message message) {
    // Implementation would convert messages to HTTP responses
    // and route them to the appropriate destination
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

  /// Creates an HTTP response from a message
  ///
  /// For example, a vote confirmation from the internal system is
  /// converted to an HTTP response for the citizen's web browser
  Future<HttpResponse> createResponse(Message message) async {
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
}

/// Adapter for WebSocket communication with external systems
///
/// In a direct democracy context, this enables:
/// - Real-time voting results display for citizens
/// - Live participation in deliberation processes
/// - Instant notifications of civic proceedings and decisions
/// - Streaming of town halls and public debates
class WebSocketChannelAdapter implements ChannelAdapter {
  @override
  final Channel channel;

  @override
  final String name;

  /// Path for WebSocket connections
  final String path;

  /// Optional WebSocket protocol
  final String? protocol;

  /// Configuration properties
  final Map<String, dynamic> _properties = {};

  /// Current status
  String _status = 'inactive';

  /// Subscription to channel messages
  StreamSubscription? _subscription;

  /// Creates a new WebSocket adapter
  WebSocketChannelAdapter({
    required this.channel,
    required this.path,
    required this.name,
    this.protocol,
  }) {
    _properties['path'] = path;
    _properties['type'] = 'WebSocket';
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
  }

  @override
  Future<void> stop() async {
    // Cancel subscription
    await _subscription?.cancel();
    _subscription = null;

    // Update status
    _status = 'inactive';
  }

  /// Handles incoming WebSocket data from an external system
  ///
  /// For example, a citizen joining a deliberation session via WebSocket
  /// is translated into an internal message for the deliberation system
  Future<void> handleIncomingData(String data) async {
    try {
      // Parse the data as JSON
      final payload = json.decode(data);

      // Create a message with WebSocket metadata
      final message = Message(
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
  ///
  /// For example, a participation update from the internal system
  /// is formatted for WebSocket transmission to all connected citizens
  Future<String> createWebSocketMessage(Message message) async {
    // In a real implementation, might use different serialization
    // based on message type or other factors
    return json.encode(message.payload);
  }

  /// Handles a message from the channel, potentially sending to WebSocket clients
  void _handleChannelMessage(Message message) {
    // Convert message to WebSocket format and send to clients
    createWebSocketMessage(message).then((data) {
      // In a real implementation, would send to connected WebSocket clients
      print('Would send to WebSocket clients: $data');
    });
  }
}
