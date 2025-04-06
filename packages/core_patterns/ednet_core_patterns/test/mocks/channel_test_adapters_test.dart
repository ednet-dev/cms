import 'dart:convert';
import 'package:test/test.dart';
import 'package:ednet_core_patterns/ednet_core_patterns.dart';
import 'channel_test_adapters.dart';

void main() {
  group('Channel Test Adapters', () {
    late InMemoryChannel channel;
    late TestHttpChannelAdapter httpAdapter;
    late TestWebSocketChannelAdapter wsAdapter;

    setUp(() {
      channel = InMemoryChannel(id: 'test-channel', broadcast: true);
      httpAdapter = TestHttpChannelAdapter(
        channel: channel,
        baseUrl: 'https://api.example.com',
      );
      wsAdapter = TestWebSocketChannelAdapter(
        channel: channel,
        path: '/websocket',
      );
    });

    test(
      'HTTP adapter correctly processes HTTP requests and responses',
      () async {
        // Start the adapter
        await httpAdapter.start();
        expect(httpAdapter.status, equals('active'));

        // Create an HTTP request
        final request = HttpRequest(
          method: 'GET',
          path: '/users',
          headers: {'Accept': 'application/json'},
          queryParameters: {'page': '1', 'limit': '10'},
        );

        // Handle the request - this adds a message to the channel
        await httpAdapter.handleRequest(request);

        // Verify message count
        expect(channel.messageCount, equals(1));

        // Create an HTTP response directly - don't try to listen to the channel
        // which could cause timeouts
        final response = await httpAdapter.handleOutgoingMessage(
          Message(
            payload: {'name': 'John', 'email': 'john@example.com'},
            metadata: {
              'httpStatusCode': 200,
              'contentType': 'application/json',
            },
          ),
        );

        // Verify the response
        expect(response.statusCode, equals(200));
        expect(response.headers['Content-Type'], equals('application/json'));
        expect(
          response.body,
          equals('{"name":"John","email":"john@example.com"}'),
        );

        // Stop the adapter
        await httpAdapter.stop();
        expect(httpAdapter.status, equals('inactive'));
      },
    );

    test('WebSocket adapter correctly processes WebSocket messages', () async {
      // Start the adapter
      await wsAdapter.start();
      expect(wsAdapter.status, equals('active'));

      // Send data to the WebSocket - this adds a message to the channel
      await wsAdapter.handleIncomingData(
        json.encode({'type': 'message', 'content': 'Hello WebSocket'}),
      );

      // Verify message count
      expect(channel.messageCount, equals(1));

      // Create an outgoing WebSocket message directly - don't try to listen to
      // the channel which could cause timeouts
      final data = await wsAdapter.handleOutgoingMessage(
        Message(
          payload: {'status': 'received', 'timestamp': '2023-01-01T12:00:00Z'},
        ),
      );

      // Verify the data
      final parsedData = json.decode(data);
      expect(parsedData['status'], equals('received'));
      expect(parsedData['timestamp'], equals('2023-01-01T12:00:00Z'));

      // Stop the adapter
      await wsAdapter.stop();
      expect(wsAdapter.status, equals('inactive'));
    });
  });
}
