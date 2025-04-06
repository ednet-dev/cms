import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Creates a concept for the filter entity
Concept createFilterConcept() {
  // Create a domain for testing
  final domain = Domain('TestDomain');

  // Create a model within the domain
  final model = Model(domain, 'TestModel');

  // Create the filter concept
  final filterConcept = Concept(model, 'Filter');
  filterConcept.entry = true;

  // Define the attributes
  final nameAttr = Attribute(filterConcept, 'name');
  nameAttr.type = domain.getType('String');
  nameAttr.identifier = true;

  final typeAttr = Attribute(filterConcept, 'type');
  typeAttr.type = domain.getType('String');
  typeAttr.required = true;

  final statusAttr = Attribute(filterConcept, 'status');
  statusAttr.type = domain.getType('String');
  statusAttr.init = 'inactive';

  // Adding selectorType attribute for the selector filter
  final selectorTypeAttr = Attribute(filterConcept, 'selectorType');
  selectorTypeAttr.type = domain.getType('String');

  return filterConcept;
}

/// A simple factory function to create a FilterEntity collection for testing
Entities<FilterEntity> createFilterEntities() {
  final filterConcept = createFilterConcept();

  // Create a FilterEntity
  final template = FilterEntity();
  template.concept = filterConcept;

  // Create the entities collection using the template's concept
  final entities = Entities<FilterEntity>();
  entities.concept = filterConcept;

  return entities;
}

void main() {
  group('Message Filter Pattern', () {
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

  group('EDNet Core Message Filter Integration', () {
    late InMemoryChannel sourceChannel;
    late InMemoryChannel targetChannel;
    late Entities<FilterEntity> filterEntities;
    late MessageFilterRepository repository;
    late FilterEntity filterTemplate;

    setUp(() {
      sourceChannel = InMemoryChannel(id: 'source', broadcast: true);
      targetChannel = InMemoryChannel(id: 'target', broadcast: true);

      // Create entities collection
      filterEntities = createFilterEntities();

      // Create a filter entity template
      filterTemplate = FilterEntity();
      filterTemplate.concept = filterEntities.concept;

      // Create repository
      repository = MessageFilterRepository(filterEntities);
    });

    tearDown(() async {
      await sourceChannel.close();
      await targetChannel.close();
    });

    test(
      'EDNetCoreMessageFilter with predicate correctly filters messages',
      () async {
        // Create entity and add it to collection
        final entity = FilterEntity();
        entity.concept = filterEntities.concept;
        entity.setAttribute('name', 'topic-filter');
        entity.setAttribute('type', 'predicate');
        entity.setAttribute('status', 'inactive');

        filterEntities.add(entity);

        // Create filter implementation
        final filterImpl = PredicateMessageFilter(
          name: 'topic-filter',
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          predicate: (msg) => msg.metadata['topic'] == 'housing',
        );

        // Create wrapped filter
        final filter = EDNetCoreMessageFilter(
          entity: entity,
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          filterImpl: filterImpl,
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

        // Verify entity state
        expect(filter.name, 'topic-filter');
        expect(filter.type, 'predicate');
        expect(filter.status, 'active');

        // Verify entity in the collection
        expect(filterEntities.length, 1);
        expect(filterEntities.first.filterName, 'topic-filter');
        expect(filterEntities.first.status, 'active');

        // Stop the filter and verify status is updated in entity
        await filter.stop();
        expect(filter.status, 'inactive');
        expect(filterEntities.first.status, 'inactive');

        await subscription.cancel();
      },
    );

    test(
      'EDNetCoreMessageFilter with selector correctly filters messages',
      () async {
        // Create entity and add it to collection
        final entity = FilterEntity();
        entity.concept = filterEntities.concept;
        entity.setAttribute('name', 'region-filter');
        entity.setAttribute('type', 'selector');
        entity.setAttribute('status', 'inactive');

        // Set the selector type if the attribute exists
        try {
          entity.setAttribute('selectorType', 'String');
        } catch (e) {
          // Ignore if the attribute doesn't exist in the concept
        }

        filterEntities.add(entity);

        // Create filter implementation
        final filterImpl = SelectorMessageFilter<String>(
          name: 'region-filter',
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          selector: (msg) => msg.metadata['region'] as String? ?? '',
          expectedValue: 'west',
        );

        // Create wrapped filter
        final filter = EDNetCoreMessageFilter(
          entity: entity,
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          filterImpl: filterImpl,
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

        // Verify entity state
        expect(filter.entity.filterName, 'region-filter');
        expect(filter.entity.filterType, 'selector');
        expect(filter.entity.status, 'active');

        // Cleanup
        await filter.stop();
        await subscription.cancel();
      },
    );
  });
}
