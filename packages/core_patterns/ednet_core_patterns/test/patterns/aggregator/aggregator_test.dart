import 'package:ednet_core_patterns/ednet_core_patterns.dart';
import 'package:test/test.dart';

void main() {
  group('Aggregator Pattern', () {
    test('Count-based aggregator should collect and combine messages', () {
      // Create an implementation of MessageAggregator (not yet implemented)
      final aggregator = CountBasedAggregator<int>(
        expectedCount: 3,
        correlationIdExtractor: (message) => message.metadata['correlationId'],
        resultBuilder:
            (messages) => messages.fold(
              0,
              (sum, message) => sum + (message.payload as int),
            ),
      );

      // Create test messages with the same correlation ID
      final message1 = Message(
        payload: 5,
        metadata: {'correlationId': 'test-123'},
      );

      final message2 = Message(
        payload: 10,
        metadata: {'correlationId': 'test-123'},
      );

      final message3 = Message(
        payload: 7,
        metadata: {'correlationId': 'test-123'},
      );

      // Not complete until we've added all messages
      aggregator.addMessage(message1);
      expect(aggregator.isComplete(), false);

      aggregator.addMessage(message2);
      expect(aggregator.isComplete(), false);

      // Should be complete after the expected number of messages
      aggregator.addMessage(message3);
      expect(aggregator.isComplete(), true);

      // Verify the aggregation result
      expect(aggregator.getAggregatedResult(), equals(22)); // 5 + 10 + 7 = 22
    });

    test(
      'Time-based aggregator should collect messages until timeout',
      () async {
        // Create a time-based aggregator with a short timeout for testing
        final aggregator = TimeBasedAggregator<int>(
          timeout: Duration(milliseconds: 100), // Short timeout for testing
          correlationIdExtractor:
              (message) => message.metadata['correlationId'],
          resultBuilder:
              (messages) => messages.fold(
                0,
                (sum, message) => sum + (message.payload as int),
              ),
        );

        // Create test messages with the same correlation ID
        final message1 = Message(
          payload: 5,
          metadata: {'correlationId': 'test-timeout'},
        );

        final message2 = Message(
          payload: 10,
          metadata: {'correlationId': 'test-timeout'},
        );

        // Add messages (not reaching count completion)
        aggregator.addMessage(message1);
        aggregator.addMessage(message2);

        // Should not be complete yet
        expect(aggregator.isComplete(), false);

        // Wait for the timeout to occur
        await Future.delayed(Duration(milliseconds: 150));

        // Should be complete after timeout
        expect(aggregator.isComplete(), true);

        // Verify the aggregation result (5 + 10 = 15)
        expect(aggregator.getAggregatedResult(), equals(15));

        // Clean up
        aggregator.dispose();
      },
    );
  });
}
