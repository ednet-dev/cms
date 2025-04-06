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
