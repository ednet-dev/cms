import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('EDNet Core Patterns Integration', () {
    test('Integration between Channel Adapter and Message Filter', () async {
      // Create new channels for this test
      final sourceChannel = InMemoryChannel(
        id: 'source1',
        name: 'Source Channel',
        broadcast: true,
      );
      final targetChannel = InMemoryChannel(
        id: 'target1',
        name: 'Target Channel',
        broadcast: true,
      );

      // Create HTTP adapter connected to source channel
      final httpAdapter = HttpChannelAdapter(
        channel: sourceChannel,
        baseUrl: 'http://localhost:8080',
        name: 'Test HTTP Adapter',
      );

      // Create a filter that only passes messages with a specific topic
      final filter = PredicateMessageFilter(
        sourceChannel: sourceChannel,
        targetChannel: targetChannel,
        name: 'JSON Content Filter',
        predicate:
            (message) => message.metadata['contentType'] == 'application/json',
      );

      // Start components
      await httpAdapter.start();
      await filter.start();

      // Collect messages that pass through the filter
      final receivedMessages = <Message>[];
      final subscription = targetChannel.receive().listen((message) {
        receivedMessages.add(message);
      });

      // Create test HTTP requests
      final jsonRequest = HttpRequest(
        method: 'POST',
        path: '/api/test',
        headers: {'Content-Type': 'application/json'},
        body: '{"key": "value"}',
      );

      final textRequest = HttpRequest(
        method: 'POST',
        path: '/api/test',
        headers: {'Content-Type': 'text/plain'},
        body: 'Plain text content',
      );

      // Process the requests through the adapter
      await httpAdapter.handleRequest(jsonRequest);
      await httpAdapter.handleRequest(textRequest);

      // Allow time for messages to be processed
      await Future.delayed(Duration(milliseconds: 100));

      // Verify only the JSON message passed through the filter
      expect(sourceChannel.messageCount, equals(2));
      expect(receivedMessages.length, equals(1));
      expect(
        receivedMessages.first.metadata['contentType'],
        equals('application/json'),
      );

      // Clean up
      await subscription.cancel();
      await filter.stop();
      await httpAdapter.stop();
    });

    test(
      'Full cycle: HTTP Request → Message → Filter → HTTP Response',
      () async {
        // Create new channels for this test
        final sourceChannel = InMemoryChannel(
          id: 'source2',
          name: 'Source Channel',
          broadcast: true,
        );
        final targetChannel = InMemoryChannel(
          id: 'target2',
          name: 'Target Channel',
          broadcast: true,
        );

        // Create HTTP adapter connected to source channel
        final httpAdapter = HttpChannelAdapter(
          channel: sourceChannel,
          baseUrl: 'http://localhost:8080',
          name: 'Test HTTP Adapter',
        );

        // Create a filter that only passes messages with a specific topic
        final filter = PredicateMessageFilter(
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          name: 'JSON Content Filter',
          predicate:
              (message) =>
                  message.metadata['contentType'] == 'application/json',
        );

        await httpAdapter.start();
        await filter.start();

        // Simulate incoming HTTP request
        final request = HttpRequest(
          method: 'GET',
          path: '/api/data',
          headers: {'Content-Type': 'application/json'},
        );

        // Handle the request (converts to message and sends to source channel)
        await httpAdapter.handleRequest(request);

        // Allow time for message to be processed
        await Future.delayed(Duration(milliseconds: 100));

        // Verify message was sent to source channel
        expect(sourceChannel.messageCount, equals(1));

        // Create a response from a similar message
        final message = Message(
          payload: {'data': 'test response'},
          metadata: {'contentType': 'application/json'},
        );

        // Create a response from the message
        final response = await httpAdapter.createResponse(message);

        // Verify response properties
        expect(response.statusCode, equals(200));
        expect(response.headers['Content-Type'], equals('application/json'));

        // Clean up
        await filter.stop();
        await httpAdapter.stop();
      },
    );
  });
}
