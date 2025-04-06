import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('Channel Adapter Pattern', () {
    late InMemoryChannel sourceChannel;
    late HttpChannelAdapter httpAdapter;
    late WebSocketChannelAdapter webSocketAdapter;

    setUp(() {
      // Create test channels
      sourceChannel = InMemoryChannel(
        id: 'source-channel',
        name: 'Source Channel',
      );

      // Create adapters
      httpAdapter = HttpChannelAdapter(
        channel: sourceChannel,
        baseUrl: 'http://localhost:8080',
        name: 'Test HTTP Adapter',
      );

      webSocketAdapter = WebSocketChannelAdapter(
        channel: sourceChannel,
        path: '/ws',
        name: 'Test WebSocket Adapter',
      );
    });

    test('HTTP adapter initialization sets correct properties', () {
      expect(httpAdapter.name, equals('Test HTTP Adapter'));
      expect(httpAdapter.type, equals('HTTP'));
      expect(httpAdapter.status, equals('inactive'));
      expect(httpAdapter.baseUrl, equals('http://localhost:8080'));
      expect(
        httpAdapter.getProperty('baseUrl'),
        equals('http://localhost:8080'),
      );
    });

    test('WebSocket adapter initialization sets correct properties', () {
      expect(webSocketAdapter.name, equals('Test WebSocket Adapter'));
      expect(webSocketAdapter.type, equals('WebSocket'));
      expect(webSocketAdapter.status, equals('inactive'));
      expect(webSocketAdapter.path, equals('/ws'));
      expect(webSocketAdapter.getProperty('path'), equals('/ws'));
    });

    test('HTTP adapter start/stop changes status', () async {
      expect(httpAdapter.status, equals('inactive'));

      await httpAdapter.start();
      expect(httpAdapter.status, equals('active'));

      await httpAdapter.stop();
      expect(httpAdapter.status, equals('inactive'));
    });

    test('WebSocket adapter start/stop changes status', () async {
      expect(webSocketAdapter.status, equals('inactive'));

      await webSocketAdapter.start();
      expect(webSocketAdapter.status, equals('active'));

      await webSocketAdapter.stop();
      expect(webSocketAdapter.status, equals('inactive'));
    });
  });
}
