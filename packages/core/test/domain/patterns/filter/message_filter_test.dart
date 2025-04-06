import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Message Filter', () {
    late InMemoryChannel sourceChannel;
    late InMemoryChannel targetChannel;

    setUp(() {
      sourceChannel = InMemoryChannel(id: 'source', broadcast: true);
      targetChannel = InMemoryChannel(id: 'target', broadcast: true);
    });

    tearDown(() async {
      await sourceChannel.close();
      await targetChannel.close();
    });

    test(
      'PredicateMessageFilter filters messages based on a predicate',
      () async {
        // Create a filter that only passes messages with a specific topic
        final filter = PredicateMessageFilter(
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          name: 'topic-filter',
          predicate: (msg) => msg.metadata['topic'] == 'housing',
        );

        await filter.start();

        // Track messages in target channel
        final receivedMessages = <Message>[];
        final subscription = targetChannel.receive().listen((message) {
          receivedMessages.add(message);
        });

        // Send test messages
        final housingMessage = Message(
          payload: 'Housing proposal',
          metadata: {'topic': 'housing'},
        );

        final environmentMessage = Message(
          payload: 'Environment proposal',
          metadata: {'topic': 'environment'},
        );

        await sourceChannel.send(housingMessage);
        await sourceChannel.send(environmentMessage);

        // Allow time for messages to be processed
        await Future.delayed(Duration(milliseconds: 100));

        // Verify only housing message passed through
        expect(receivedMessages.length, 1);
        expect(receivedMessages.first.payload, 'Housing proposal');

        // Verify stats
        final stats = filter.getProperty('stats') as Map<String, dynamic>;
        expect(stats['received'], 2);
        expect(stats['passed'], 1);
        expect(stats['filtered'], 1);

        // Cleanup
        await filter.stop();
        await subscription.cancel();
      },
    );

    test(
      'SelectorMessageFilter filters messages based on a selector',
      () async {
        // Create a filter that only passes messages from a specific region
        final filter = SelectorMessageFilter<String>(
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          name: 'region-filter',
          selector: (msg) => msg.metadata['region'] as String? ?? '',
          expectedValue: 'west',
        );

        await filter.start();

        // Track messages in target channel
        final receivedMessages = <Message>[];
        final subscription = targetChannel.receive().listen((message) {
          receivedMessages.add(message);
        });

        // Send test messages
        final westMessage = Message(
          payload: 'West region notice',
          metadata: {'region': 'west'},
        );

        final eastMessage = Message(
          payload: 'East region notice',
          metadata: {'region': 'east'},
        );

        await sourceChannel.send(westMessage);
        await sourceChannel.send(eastMessage);

        // Allow time for messages to be processed
        await Future.delayed(Duration(milliseconds: 100));

        // Verify only west region message passed through
        expect(receivedMessages.length, 1);
        expect(receivedMessages.first.payload, 'West region notice');

        // Cleanup
        await filter.stop();
        await subscription.cancel();
      },
    );

    test(
      'CompositeMessageFilter combines multiple filters with AND logic',
      () async {
        // Create a filter that requires both topic and region criteria
        final filter = CompositeMessageFilter(
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          name: 'composite-filter',
          filters: [
            (msg) => msg.metadata['topic'] == 'housing',
            (msg) => msg.metadata['region'] == 'west',
          ],
          operation: 'AND',
        );

        await filter.start();

        // Track messages in target channel
        final receivedMessages = <Message>[];
        final subscription = targetChannel.receive().listen((message) {
          receivedMessages.add(message);
        });

        // Send test messages with different combinations
        final message1 = Message(
          payload: 'West housing notice',
          metadata: {'topic': 'housing', 'region': 'west'},
        );

        final message2 = Message(
          payload: 'East housing notice',
          metadata: {'topic': 'housing', 'region': 'east'},
        );

        final message3 = Message(
          payload: 'West environment notice',
          metadata: {'topic': 'environment', 'region': 'west'},
        );

        await sourceChannel.send(message1); // Should pass
        await sourceChannel.send(message2); // Should be filtered out
        await sourceChannel.send(message3); // Should be filtered out

        // Allow time for messages to be processed
        await Future.delayed(Duration(milliseconds: 100));

        // Verify only message with both criteria passed through
        expect(receivedMessages.length, 1);
        expect(receivedMessages.first.payload, 'West housing notice');

        // Cleanup
        await filter.stop();
        await subscription.cancel();
      },
    );
  });
}
