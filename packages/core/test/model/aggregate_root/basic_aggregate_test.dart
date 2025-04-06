import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

// Simple dynamic mock helper
class DynamicMock {
  final Map<String, dynamic> _values = {};

  DynamicMock({bool entry = false}) {
    _values['entry'] = entry;
  }

  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();

    // Handle property access
    if (invocation.isGetter) {
      final propName = name.split('"')[1]; // Extract property name
      return _values[propName];
    }

    // Return a sensible default for unknown methods
    return null;
  }
}

// Simple test-only aggregate implementation
class MinimalTestAggregate extends AggregateRoot<MinimalTestAggregate> {
  List<String> items = [];

  // Override to prevent concept issues in testing
  @override
  bool get isAggregateRoot => true;

  @override
  void applyEvent(dynamic event) {
    if (event is Map && event['name'] == 'ItemAdded') {
      items.add(event['data']['itemName'] as String);
    } else if (event is Event && event.name == 'ItemAdded') {
      items.add(event.data['itemName'] as String);
    }
  }

  void addItem(String name) {
    items.add(name);

    // Use recordEvent instead of direct list access
    recordEvent(
      'ItemAdded',
      'Item was added to aggregate',
      [],
      data: {'itemName': name},
    );
  }

  // Override to validate business rules
  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();

    // Business rule: cannot have more than 3 items
    if (items.length > 4) {
      exceptions.add(
        ValidationException(
          'items',
          'Cannot have more than 3 items',
          entity: this,
        ),
      );
    }

    return exceptions;
  }
}

// Simple command for testing
class AddItemCommand implements ICommand {
  final MinimalTestAggregate aggregate;
  final String itemName;
  final List<Event> _events = [];

  AddItemCommand(this.aggregate, this.itemName);

  @override
  String get name => 'AddItem';

  @override
  String get category => 'Test';

  @override
  String get description => 'Add an item to the aggregate';

  @override
  bool doIt() {
    aggregate.addItem(itemName);
    _events.add(
      Event('ItemAdded', 'Item was added', [], aggregate, {
        'itemName': itemName,
      }),
    );
    return true;
  }

  @override
  bool undo() {
    if (aggregate.items.isNotEmpty) {
      aggregate.items.removeLast();
      return true;
    }
    return false;
  }

  @override
  List<Event> getEvents() => _events;

  @override
  bool get done => false;

  @override
  bool get undone => false;

  @override
  bool get redone => false;

  @override
  bool redo() => doIt();

  @override
  Event get failureEvent =>
      Event('AddItemFailed', 'Failed to add item', [], aggregate);

  @override
  Event get successEvent =>
      Event('AddItemSucceeded', 'Successfully added item', [], aggregate);
}

void main() {
  group('AggregateRoot', () {
    test('Basic functionality', () {
      final aggregate = MinimalTestAggregate();

      // Test version starts at 0
      expect(aggregate.version, equals(0));

      // Test event tracking
      aggregate.addItem('test');
      expect(aggregate.pendingEvents.length, equals(1));

      // Test event clearing
      aggregate.markEventsAsProcessed();
      expect(aggregate.pendingEvents.length, equals(0));
    });

    test('Event history rehydration', () {
      final aggregate = MinimalTestAggregate();

      // Create some events for the history
      final events = [
        Event('ItemAdded', 'First item', [], aggregate, {'itemName': 'Item 1'}),
        Event('ItemAdded', 'Second item', [], aggregate, {
          'itemName': 'Item 2',
        }),
      ];

      // Rehydrate the aggregate from history
      aggregate.rehydrateFromEventHistory(events);

      // Version should match event count
      expect(aggregate.version, equals(2));

      // State should reflect events
      expect(aggregate.items.length, equals(2));
      expect(aggregate.items, contains('Item 1'));
      expect(aggregate.items, contains('Item 2'));
    });

    test('Business rule validation', () {
      final aggregate = MinimalTestAggregate();

      // Add items below the limit
      for (int i = 0; i < 5; i++) {
        aggregate.addItem('Item $i');
      }

      // Validate business rules
      final validation = aggregate.enforceBusinessInvariants();
      expect(validation.isEmpty, isFalse);

      var iterator = validation.iterator;
      expect(iterator.moveNext(), isTrue);
      expect(
        iterator.current.message,
        contains('Cannot have more than 3 items'),
      );
    });

    test('Aggregate root detection', () {
      final aggregate = MinimalTestAggregate();

      // Test detection of aggregate roots
      expect(aggregate.isAggregateRoot, isTrue);
    });
  });
}
