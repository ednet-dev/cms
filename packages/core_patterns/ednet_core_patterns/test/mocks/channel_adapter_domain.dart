import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;
import 'channel_test_adapters.dart';

/// Adapter that connects via HTTP to external systems
class HttpAdapter extends Entity<HttpAdapter> {
  /// Channel connected to this adapter
  final patterns.Channel channel;

  /// Base URL for this adapter
  final String baseUrl;

  HttpAdapter({required this.channel, required this.baseUrl});

  /// Handles HTTP requests by converting them to messages
  Future<void> handleRequest(dynamic request) async {
    // In a real implementation, would convert HTTP requests to messages
    // and send them to the channel
    final message = patterns.Message(
      payload: {'data': 'example'},
      metadata: {'source': 'http'},
    );

    await channel.send(message);
  }

  /// Converts messages to HTTP responses
  Future<dynamic> createResponse(patterns.Message message) async {
    // In a real implementation, would create HTTP responses from messages
    return {'status': 200, 'body': message.payload};
  }
}

/// Adapter that connects via WebSocket to external systems
class WebSocketAdapter extends Entity<WebSocketAdapter> {
  /// Channel connected to this adapter
  final patterns.Channel channel;

  /// Endpoint path for this adapter
  final String path;

  WebSocketAdapter({required this.channel, required this.path});

  /// Handles WebSocket messages by converting them to channel messages
  Future<void> handleMessage(String data) async {
    // In a real implementation, would convert WebSocket messages to channel messages
    final message = patterns.Message(
      payload: {'data': data},
      metadata: {'source': 'websocket'},
    );

    await channel.send(message);
  }

  /// Converts messages to WebSocket responses
  String createResponse(patterns.Message message) {
    // In a real implementation, would create WebSocket messages from channel messages
    return '{"data": ${message.payload["data"]}}';
  }
}

/// Provides a domain model for Channel Adapters pattern for testing
class ChannelAdapterTestDomain {
  late Domain domain;
  late Model model;
  late DomainModels domainModels;
  late DomainSession session;

  // Concepts
  late Concept adapterConcept;
  late Concept httpAdapterConcept;
  late Concept webSocketAdapterConcept;
  late Concept messageConcept;
  late Concept channelConcept;

  ChannelAdapterTestDomain() {
    _initDomain();
    _initModel();
    _initConcepts();
    _initRelationships();
    _initDomainModels();
  }

  void _initDomain() {
    domain = Domain('ChannelAdapter');
    domain.description = 'Channel Adapter pattern domain for testing';
  }

  void _initModel() {
    model = Model(domain, 'ChannelAdapterModel');
    model.description = 'Model for Channel Adapter pattern testing';
  }

  void _initConcepts() {
    // Base adapter concept
    adapterConcept = Concept(model, 'Adapter');
    adapterConcept.description =
        'Base adapter that connects to messaging channels';
    _addAdapterAttributes();

    // HTTP adapter concept
    httpAdapterConcept = Concept(model, 'HttpAdapter');
    httpAdapterConcept.description = 'Adapter that connects via HTTP protocol';
    httpAdapterConcept.entry = true;
    _addHttpAdapterAttributes();

    // WebSocket adapter concept
    webSocketAdapterConcept = Concept(model, 'WebSocketAdapter');
    webSocketAdapterConcept.description =
        'Adapter that connects via WebSocket protocol';
    webSocketAdapterConcept.entry = true;
    _addWebSocketAdapterAttributes();

    // Message concept
    messageConcept = Concept(model, 'Message');
    messageConcept.description = 'Message passed through channels';
    _addMessageAttributes();

    // Channel concept
    channelConcept = Concept(model, 'Channel');
    channelConcept.description = 'Messaging channel';
    _addChannelAttributes();
  }

  void _addAdapterAttributes() {
    final nameAttribute = Attribute(adapterConcept, 'name');
    nameAttribute.type = domain.getType('String');
    nameAttribute.required = true;

    final typeAttribute = Attribute(adapterConcept, 'type');
    typeAttribute.type = domain.getType('String');
    typeAttribute.required = true;

    final statusAttribute = Attribute(adapterConcept, 'status');
    statusAttribute.type = domain.getType('String');
    statusAttribute.init = 'inactive';

    final configurationAttribute = Attribute(adapterConcept, 'configuration');
    configurationAttribute.type = domain.getType('String');
  }

  void _addHttpAdapterAttributes() {
    final baseUrlAttribute = Attribute(httpAdapterConcept, 'baseUrl');
    baseUrlAttribute.type = domain.getType('String');
    baseUrlAttribute.required = true;
  }

  void _addWebSocketAdapterAttributes() {
    final pathAttribute = Attribute(webSocketAdapterConcept, 'path');
    pathAttribute.type = domain.getType('String');
    pathAttribute.required = true;

    final protocolAttribute = Attribute(webSocketAdapterConcept, 'protocol');
    protocolAttribute.type = domain.getType('String');
  }

  void _addMessageAttributes() {
    final payloadAttribute = Attribute(messageConcept, 'payload');
    payloadAttribute.type = domain.getType('String');
    payloadAttribute.required = true;

    final metadataAttribute = Attribute(messageConcept, 'metadata');
    metadataAttribute.type = domain.getType('String');
  }

  void _addChannelAttributes() {
    final idAttribute = Attribute(channelConcept, 'id');
    idAttribute.type = domain.getType('String');
    idAttribute.required = true;
    idAttribute.identifier = true;

    final broadcastAttribute = Attribute(channelConcept, 'broadcast');
    broadcastAttribute.type = domain.getType('bool');
    broadcastAttribute.init = 'false';
  }

  void _initRelationships() {
    // HTTP and WebSocket adapters inherit from Adapter
    final adapterParentForHttp = Parent(
      httpAdapterConcept,
      adapterConcept,
      'adapter',
    );
    adapterParentForHttp.internal = true;
    adapterParentForHttp.inheritance = true;

    final adapterParentForWebSocket = Parent(
      webSocketAdapterConcept,
      adapterConcept,
      'adapter',
    );
    adapterParentForWebSocket.internal = true;
    adapterParentForWebSocket.inheritance = true;

    // Adapters have a channel
    final channelParentForHttp = Parent(
      httpAdapterConcept,
      channelConcept,
      'channel',
    );
    channelParentForHttp.required = true;

    final channelParentForWebSocket = Parent(
      webSocketAdapterConcept,
      channelConcept,
      'channel',
    );
    channelParentForWebSocket.required = true;

    // Messages are children of adapters
    final messageChildForHttp = Child(
      httpAdapterConcept,
      messageConcept,
      'messages',
    );
    messageChildForHttp.internal = true;

    final messageChildForWebSocket = Child(
      webSocketAdapterConcept,
      messageConcept,
      'messages',
    );
    messageChildForWebSocket.internal = true;
  }

  void _initDomainModels() {
    domainModels = DomainModels(domain);
    session = DomainSession(domainModels);
  }

  /// Creates a properly initialized HTTP adapter for testing
  TestHttpChannelAdapter createHttpAdapter({
    required patterns.Channel channel,
    required String baseUrl,
    String name = 'test-http-adapter',
  }) {
    return TestHttpChannelAdapter(
      channel: channel,
      baseUrl: baseUrl,
      name: name,
    );
  }

  /// Creates a properly initialized WebSocket adapter for testing
  TestWebSocketChannelAdapter createWebSocketAdapter({
    required patterns.Channel channel,
    required String path,
    String? protocol,
    String name = 'test-websocket-adapter',
  }) {
    return TestWebSocketChannelAdapter(
      channel: channel,
      path: path,
      protocol: protocol,
      name: name,
    );
  }

  /// Creates a test channel for use with adapters
  patterns.InMemoryChannel createChannel({
    String id = 'test-channel',
    bool broadcast = true,
  }) {
    return patterns.InMemoryChannel(id: id, broadcast: broadcast);
  }
}
