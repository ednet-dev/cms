import 'package:ednet_core_patterns/ednet_core_patterns.dart' as patterns;
import 'package:test/test.dart';
import '../../mocks/patterns/filter/filter_domain.dart';
import '../../mocks/patterns/filter/filter_entities.dart';

void main() {
  group('Message Filter Pattern for Digital Democracy', () {
    late MessageFilterDomain testDomain;
    late Map<String, patterns.InMemoryChannel> channels;

    setUp(() {
      // Initialize domain model
      testDomain = MessageFilterDomain();

      // Create deliberation channels
      channels = testDomain.createDeliberationChannels();
    });

    tearDown(() async {
      // Clean up any active channels
      for (final channel in channels.values) {
        await channel.close();
      }
    });

    test(
      'Topic Filter routes citizen messages to topic-specific discussion threads',
      () async {
        // Create a filter for housing policy discussions
        final housingFilter = testDomain.createTopicFilter(
          sourceChannel: channels['all-discussions']!,
          targetChannel: channels['housing']!,
          topic: 'housing',
          name: 'housing-topic-filter',
        );

        // Start the filter
        await housingFilter.start();

        // Verify initial state
        expect(housingFilter.status, equals('active'));
        expect(channels['housing']!.messageCount, equals(0));

        // Send a housing-related message from a citizen
        final housingMessage = patterns.Message(
          payload: {
            'content':
                'We need more affordable housing options in the city center.',
            'author': 'citizen-123',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'housing',
            'region': 'central',
            'type': 'deliberation',
          },
        );

        await channels['all-discussions']!.send(housingMessage);

        // Send an unrelated transportation message from another citizen
        final transportationMessage = patterns.Message(
          payload: {
            'content': 'The subway expansion project should be prioritized.',
            'author': 'citizen-456',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'transportation',
            'region': 'central',
            'type': 'deliberation',
          },
        );

        await channels['all-discussions']!.send(transportationMessage);

        // Wait for filter processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify that only the housing message passed to the topic-specific channel
        expect(channels['housing']!.messageCount, equals(1));

        // Verify filter statistics
        final stats = housingFilter.getProperty('stats') as Map;
        expect(stats['received'], equals(2));
        expect(stats['passed'], equals(1));
        expect(stats['filtered'], equals(1));

        // Get the passed message
        final passedMessage = await channels['housing']!.receive().first;

        // Verify it contains the correct content
        expect(
          passedMessage.payload['content'],
          contains('affordable housing'),
        );
      },
    );

    test(
      'Regional Filter routes citizen messages to jurisdiction-specific discussions',
      () async {
        // Create a filter for north district regional discussions
        final northDistrictFilter = testDomain.createRegionalFilter(
          sourceChannel: channels['all-discussions']!,
          targetChannel: channels['north-district']!,
          region: 'north',
          name: 'north-district-filter',
        );

        // Start the filter
        await northDistrictFilter.start();

        // Verify initial state
        expect(northDistrictFilter.status, equals('active'));
        expect(channels['north-district']!.messageCount, equals(0));

        // Send a north district citizen's message
        final northMessage = patterns.Message(
          payload: {
            'content': 'Our district needs more public parks.',
            'author': 'citizen-789',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'urban-planning',
            'region': 'north',
            'type': 'proposal',
          },
        );

        await channels['all-discussions']!.send(northMessage);

        // Send a south district citizen's message
        final southMessage = patterns.Message(
          payload: {
            'content': 'We should renovate the community center.',
            'author': 'citizen-012',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'urban-planning',
            'region': 'south',
            'type': 'proposal',
          },
        );

        await channels['all-discussions']!.send(southMessage);

        // Wait for filter processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify that only the north district message passed to the regional channel
        expect(channels['north-district']!.messageCount, equals(1));

        // Verify filter statistics
        final stats = northDistrictFilter.getProperty('stats') as Map;
        expect(stats['received'], equals(2));
        expect(stats['passed'], equals(1));
        expect(stats['filtered'], equals(1));

        // Get the passed message
        final passedMessage = await channels['north-district']!.receive().first;

        // Verify it contains the correct content
        expect(passedMessage.payload['content'], contains('public parks'));
      },
    );

    test(
      'Composite Filter combines multiple criteria for targeted citizen engagement',
      () async {
        // Create a composite filter for youth engagement on environmental topics
        final youthEnvironmentFilter = testDomain.createCompositeFilter(
          sourceChannel: channels['all-discussions']!,
          targetChannel: channels['youth-council']!,
          filters: [
            // Environmental topic filter
            (msg) => msg.metadata['topic'] == 'environment',
            // Youth demographic filter
            (msg) => msg.metadata['demographic'] == 'youth',
          ],
          operation: 'AND',
          name: 'youth-environment-filter',
        );

        // Start the filter
        await youthEnvironmentFilter.start();

        // Verify initial state
        expect(youthEnvironmentFilter.status, equals('active'));
        expect(channels['youth-council']!.messageCount, equals(0));

        // Send a youth environmental message
        final youthEnvMessage = patterns.Message(
          payload: {
            'content': 'Students should lead climate initiatives in schools.',
            'author': 'youth-345',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'environment',
            'demographic': 'youth',
            'type': 'initiative',
          },
        );

        await channels['all-discussions']!.send(youthEnvMessage);

        // Send an adult environmental message
        final adultEnvMessage = patterns.Message(
          payload: {
            'content': 'We need stronger environmental regulations.',
            'author': 'citizen-678',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'environment',
            'demographic': 'adult',
            'type': 'proposal',
          },
        );

        await channels['all-discussions']!.send(adultEnvMessage);

        // Send a youth transportation message
        final youthTransportMessage = patterns.Message(
          payload: {
            'content': 'Students need discounted public transport.',
            'author': 'youth-901',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'transportation',
            'demographic': 'youth',
            'type': 'proposal',
          },
        );

        await channels['all-discussions']!.send(youthTransportMessage);

        // Wait for filter processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify that only the youth + environment message passed
        expect(channels['youth-council']!.messageCount, equals(1));

        // Verify filter statistics
        final stats = youthEnvironmentFilter.getProperty('stats') as Map;
        expect(stats['received'], equals(3));
        expect(stats['passed'], equals(1));
        expect(stats['filtered'], equals(2));

        // Get the passed message
        final passedMessage = await channels['youth-council']!.receive().first;

        // Verify it contains the correct content
        expect(
          passedMessage.payload['content'],
          contains('climate initiatives'),
        );
      },
    );

    test(
      'Language Filter enables multilingual democratic participation',
      () async {
        // Create a filter for Spanish language discussions
        final spanishFilter = testDomain.createLanguageFilter(
          sourceChannel: channels['all-discussions']!,
          targetChannel:
              channels['housing']!, // Reusing housing channel for simplicity
          language: 'es',
          name: 'spanish-language-filter',
        );

        // Start the filter
        await spanishFilter.start();

        // Verify initial state
        expect(spanishFilter.status, equals('active'));
        expect(channels['housing']!.messageCount, equals(0));

        // Send a Spanish language message
        final spanishMessage = patterns.Message(
          payload: {
            'content': 'Necesitamos más viviendas asequibles.',
            'author': 'citizen-234',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'housing',
            'language': 'es',
            'type': 'deliberation',
          },
        );

        await channels['all-discussions']!.send(spanishMessage);

        // Send an English language message
        final englishMessage = patterns.Message(
          payload: {
            'content': 'We need more affordable housing.',
            'author': 'citizen-567',
            'timestamp': DateTime.now().toIso8601String(),
          },
          metadata: {
            'topic': 'housing',
            'language': 'en',
            'type': 'deliberation',
          },
        );

        await channels['all-discussions']!.send(englishMessage);

        // Wait for filter processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify that only the Spanish message passed
        expect(channels['housing']!.messageCount, equals(1));

        // Verify filter statistics
        final stats = spanishFilter.getProperty('stats') as Map;
        expect(stats['received'], equals(2));
        expect(stats['passed'], equals(1));
        expect(stats['filtered'], equals(1));

        // Get the passed message
        final passedMessage = await channels['housing']!.receive().first;

        // Verify it contains the Spanish content
        expect(passedMessage.payload['content'], contains('asequibles'));
      },
    );

    test('Moderation Filter maintains civil democratic discourse', () async {
      // Create a moderation filter to ensure civil discourse
      final moderationFilter = testDomain.createModerationFilter(
        sourceChannel: channels['all-discussions']!,
        targetChannel: channels['housing']!, // Reusing housing channel
        blockedTerms: ['offensive', 'inappropriate', 'abusive'],
        name: 'civility-filter',
      );

      // Start the filter
      await moderationFilter.start();

      // Send a civil democratic message
      final civilMessage = patterns.Message(
        payload: {
          'content': 'I respectfully disagree with the housing proposal.',
          'author': 'citizen-890',
          'timestamp': DateTime.now().toIso8601String(),
        },
        metadata: {'topic': 'housing', 'type': 'deliberation'},
      );

      await channels['all-discussions']!.send(civilMessage);

      // Send a message with blocked terms
      final uncivil_message = patterns.Message(
        payload: {
          'content': 'This is an offensive proposal and should be rejected.',
          'author': 'citizen-123',
          'timestamp': DateTime.now().toIso8601String(),
        },
        metadata: {'topic': 'housing', 'type': 'deliberation'},
      );

      await channels['all-discussions']!.send(uncivil_message);

      // Wait for filter processing
      await Future.delayed(Duration(milliseconds: 100));

      // Verify that only the civil message passed
      expect(channels['housing']!.messageCount, equals(1));

      // Verify filter statistics
      final stats = moderationFilter.getProperty('stats') as Map;
      expect(stats['received'], equals(2));
      expect(stats['passed'], equals(1));
      expect(stats['filtered'], equals(1));

      // Get the passed message
      final passedMessage = await channels['housing']!.receive().first;

      // Verify it contains the respectful content
      expect(
        passedMessage.payload['content'],
        contains('respectfully disagree'),
      );
    });

    test(
      'Filter lifecycle is properly managed for democratic process integrity',
      () async {
        // Create a simple topic filter
        final topicFilter = testDomain.createTopicFilter(
          sourceChannel: channels['all-discussions']!,
          targetChannel: channels['environment']!,
          topic: 'environment',
          name: 'environment-filter',
        );

        // Check initial state
        expect(topicFilter.status, equals('inactive'));

        // Start the filter
        await topicFilter.start();

        // Verify active status
        expect(topicFilter.status, equals('active'));

        // Send an environmental message
        final envMessage = patterns.Message(
          payload: {
            'content': 'We should protect our local parks.',
            'author': 'citizen-123',
          },
          metadata: {'topic': 'environment'},
        );

        await channels['all-discussions']!.send(envMessage);

        // Wait for processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify message was passed while filter was active
        expect(channels['environment']!.messageCount, equals(1));

        // Stop the filter
        await topicFilter.stop();

        // Verify inactive status
        expect(topicFilter.status, equals('inactive'));

        // Send another environmental message
        final anotherEnvMessage = patterns.Message(
          payload: {
            'content': 'We need better recycling programs.',
            'author': 'citizen-456',
          },
          metadata: {'topic': 'environment'},
        );

        await channels['all-discussions']!.send(anotherEnvMessage);

        // Wait for potential processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify that no additional messages were passed after filter was stopped
        expect(channels['environment']!.messageCount, equals(1));
      },
    );
  });
}
