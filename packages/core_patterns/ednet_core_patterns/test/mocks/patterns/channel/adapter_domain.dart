import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;
import 'adapter_entities.dart';

/// Domain model for the Channel Adapter pattern tests
///
/// In a global digital democracy platform, the Channel Adapter pattern serves
/// to integrate diverse communication channels and external systems, enabling:
///
/// - Connection of citizen-facing applications through various protocols
/// - Integration with legacy government systems via standardized messaging
/// - Support for multinational/multilingual messaging formats
/// - Secure connection to voting and identity verification systems
/// - Real-time deliberation across heterogeneous platforms
class ChannelAdapterDomain {
  // Helper methods to create test instances

  /// Creates a properly initialized test channel
  ///
  /// In a democracy platform, channels represent specific communication pipelines like:
  /// - Voting channels for specific referendum topics
  /// - Deliberation channels for proposal discussions
  /// - Notification channels for civic participation updates
  patterns.InMemoryChannel createChannel({
    String id = 'test-channel',
    bool broadcast = true,
  }) {
    return patterns.InMemoryChannel(id: id, broadcast: broadcast);
  }

  /// Creates a properly initialized HTTP adapter for testing
  ///
  /// In a democracy platform, HTTP adapters connect to:
  /// - Government APIs providing official data
  /// - External identity verification services
  /// - REST-based voting registration systems
  /// - Public data portals for transparency
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
  ///
  /// In a democracy platform, WebSocket adapters enable:
  /// - Real-time voting results broadcasting
  /// - Live deliberation participation
  /// - Instant notification delivery to citizens
  /// - Streaming of public hearings and debates
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
}
