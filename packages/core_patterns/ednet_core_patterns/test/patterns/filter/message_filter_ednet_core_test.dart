import 'dart:async';
import 'package:ednet_core/ednet_core.dart';
import '../../mocks/patterns/filter/filter_entities.dart';
import '../../../lib/src/patterns/common/base_message.dart';
import '../../../lib/src/patterns/common/channel.dart';
import 'package:test/test.dart';

/// Custom entity class for MessageFilter that properly extends Entity<FilterEntity>
class FilterEntity extends Entity<FilterEntity> {
  String? get filterName => getAttribute('name');
  set filterName(String? value) => setAttribute('name', value);

  String? get filterType => getAttribute('type');
  set filterType(String? value) => setAttribute('type', value);

  String? get status => getAttribute('status');
  set status(String? value) => setAttribute('status', value);
}

void main() {
  group('Message Filter Pattern integrated with EDNet Core', () {
    late Domain domain;
    late Model model;
    late Concept messageFilterConcept;
    late Concept messageConcept;
    late InMemoryChannel sourceChannel;
    late InMemoryChannel targetChannel;

    setUp(() {
      // Initialize domain model
      domain = Domain('DirectDemocracy');
      domain.description = 'Direct Democracy Domain for Message Filter testing';

      // Create model
      model = Model(domain, 'MessageFilterModel');
      model.description = 'Model for testing MessageFilter with EDNet Core';

      // Create concepts
      messageFilterConcept = Concept(model, 'MessageFilter');
      messageFilterConcept.description =
          'Filter for processing messages based on criteria';
      messageFilterConcept.entry = true;

      messageConcept = Concept(model, 'Message');
      messageConcept.description = 'Message for democratic deliberation';
      messageConcept.entry = true;

      // Define message attributes
      final contentAttr = Attribute(messageConcept, 'content');
      contentAttr.type = domain.getType('String');
      contentAttr.required = true;

      final authorAttr = Attribute(messageConcept, 'author');
      authorAttr.type = domain.getType('String');
      authorAttr.required = true;

      final topicAttr = Attribute(messageConcept, 'topic');
      topicAttr.type = domain.getType('String');

      final regionAttr = Attribute(messageConcept, 'region');
      regionAttr.type = domain.getType('String');

      // Define filter attributes
      final filterNameAttr = Attribute(messageFilterConcept, 'name');
      filterNameAttr.type = domain.getType('String');
      filterNameAttr.identifier = true;

      final filterTypeAttr = Attribute(messageFilterConcept, 'type');
      filterTypeAttr.type = domain.getType('String');
      filterTypeAttr.required = true;

      final statusAttr = Attribute(messageFilterConcept, 'status');
      statusAttr.type = domain.getType('String');
      statusAttr.init = 'inactive';

      // Create test channels
      sourceChannel = InMemoryChannel(
        id: 'source-channel',
        name: 'Source Channel',
        broadcast: true,
      );

      targetChannel = InMemoryChannel(
        id: 'target-channel',
        name: 'Target Channel',
        broadcast: true,
      );
    });

    test(
      'EDNetCoreMessageFilter properly integrates with Entity pattern',
      () async {
        // Create a message filter entity using the EDNet Core concept
        final filterEntity = FilterEntity();
        filterEntity.concept = messageFilterConcept;
        filterEntity.filterName = 'topic-filter';
        filterEntity.filterType = 'predicate';
        filterEntity.status = 'inactive';

        // Create a MessageFilter implementation using the Entity
        final topicFilter = EDNetCoreMessageFilter(
          entity: filterEntity,
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
          predicate: (message) => message.metadata['topic'] == 'housing',
        );

        // Verify entity integration
        expect(topicFilter.entity, equals(filterEntity));
        expect(topicFilter.name, equals('topic-filter'));
        expect(topicFilter.type, equals('predicate'));
        expect(topicFilter.status, equals('inactive'));

        // Start the filter and verify state is updated in the entity
        await topicFilter.start();
        expect(filterEntity.status, equals('active'));

        // Send a housing-related message
        final housingMessage = Message(
          payload: {
            'content': 'We need more affordable housing.',
            'author': 'citizen-123',
          },
          metadata: {'topic': 'housing'},
        );

        await sourceChannel.send(housingMessage);

        // Send a transportation message
        final transportationMessage = Message(
          payload: {
            'content': 'Public transportation needs improvement.',
            'author': 'citizen-456',
          },
          metadata: {'topic': 'transportation'},
        );

        await sourceChannel.send(transportationMessage);

        // Wait for processing
        await Future.delayed(Duration(milliseconds: 100));

        // Verify only the housing message passed through
        expect(targetChannel.messageCount, equals(1));

        // Stop the filter
        await topicFilter.stop();
        expect(filterEntity.status, equals('inactive'));
      },
    );

    test('MessageFilterRepository properly manages filter entities', () async {
      // Create a repository for message filters
      final filterEntities = Entities<FilterEntity>();
      filterEntities.concept = messageFilterConcept;

      final repository = MessageFilterRepository(filterEntities);

      // Create a topic filter
      final topicFilter = await repository.createPredicateFilter(
        name: 'housing-topic',
        sourceChannel: sourceChannel,
        targetChannel: targetChannel,
        predicate: (message) => message.metadata['topic'] == 'housing',
      );

      // Verify the entity was created and stored in the repository
      expect(filterEntities.length, equals(1));
      expect(topicFilter.entity, equals(filterEntities.first));

      // Start the filter
      await topicFilter.start();

      // Create and send a message
      final housingMessage = Message(
        payload: {
          'content': 'Housing policies need reform.',
          'author': 'citizen-789',
        },
        metadata: {'topic': 'housing'},
      );

      await sourceChannel.send(housingMessage);

      // Wait for processing
      await Future.delayed(Duration(milliseconds: 100));

      // Verify message was filtered correctly
      expect(targetChannel.messageCount, equals(1));

      // Find the filter by name
      final retrievedFilter = repository.getFilterByName('housing-topic');
      expect(retrievedFilter, isNotNull);
      expect(retrievedFilter!.status, equals('active'));

      // Stop all filters
      await repository.stopAllFilters();

      // Verify all filters are inactive
      expect(retrievedFilter.status, equals('inactive'));
    });
  });
}

/// A Message Filter implementation that integrates with EDNet Core Entity model
class EDNetCoreMessageFilter {
  /// The underlying EDNet Core entity
  final FilterEntity entity;

  /// The source channel from which messages are filtered
  final Channel sourceChannel;

  /// The target channel to which filtered messages are sent
  final Channel targetChannel;

  /// The predicate used for filtering
  final bool Function(Message) predicate;

  /// Stream subscription
  StreamSubscription? _subscription;

  /// Stats
  int _messagesReceived = 0;
  int _messagesPassed = 0;
  int _messagesFiltered = 0;

  EDNetCoreMessageFilter({
    required this.entity,
    required this.sourceChannel,
    required this.targetChannel,
    required this.predicate,
  });

  String get name => entity.filterName ?? 'unnamed-filter';

  String get type => entity.filterType ?? 'unknown';

  String get status => entity.status ?? 'inactive';

  dynamic getProperty(String name) {
    if (name == 'stats') {
      return {
        'received': _messagesReceived,
        'passed': _messagesPassed,
        'filtered': _messagesFiltered,
      };
    }
    return entity.getAttribute(name);
  }

  void setProperty(String name, dynamic value) {
    entity.setAttribute(name, value);
  }

  Future<void> start() async {
    if (status == 'active') return;

    // Start listening to messages
    _subscription = sourceChannel.receive().listen(_processMessage);

    // Update entity status
    entity.status = 'active';
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    // Update entity status
    entity.status = 'inactive';
  }

  /// Process incoming messages
  Future<void> _processMessage(Message message) async {
    _messagesReceived++;

    if (predicate(message)) {
      await targetChannel.send(message);
      _messagesPassed++;
    } else {
      _messagesFiltered++;
    }
  }
}

/// Repository for managing message filters
class MessageFilterRepository {
  final Entities<FilterEntity> entities;
  final List<EDNetCoreMessageFilter> _activeFilters = [];

  MessageFilterRepository(this.entities);

  /// Create a predicate-based filter
  Future<EDNetCoreMessageFilter> createPredicateFilter({
    required String name,
    required Channel sourceChannel,
    required Channel targetChannel,
    required bool Function(Message) predicate,
  }) async {
    // Create entity
    final entity = FilterEntity();
    entity.concept = entities.concept;
    entity.filterName = name;
    entity.filterType = 'predicate';
    entity.status = 'inactive';

    // Add to repository
    entities.add(entity);

    // Create filter
    final filter = EDNetCoreMessageFilter(
      entity: entity,
      sourceChannel: sourceChannel,
      targetChannel: targetChannel,
      predicate: predicate,
    );

    _activeFilters.add(filter);
    return filter;
  }

  /// Get a filter by name
  EDNetCoreMessageFilter? getFilterByName(String name) {
    for (var filter in _activeFilters) {
      if (filter.name == name) {
        return filter;
      }
    }
    return null;
  }

  /// Stop all active filters
  Future<void> stopAllFilters() async {
    for (var filter in _activeFilters) {
      await filter.stop();
    }
  }
}
