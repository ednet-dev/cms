import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

// Mock AggregateRoot implementation for testing
class TestAggregate extends AggregateRoot<TestAggregate> {
  List<String> items = [];

  // Override to implement domain-specific behavior
  @override
  void applyEvent(dynamic event) {
    if (event is Event && event.name == 'ItemAdded') {
      items.add(event.data['itemName'] as String);
    }
  }

  // Override to validate business rules
  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();

    // Business rule: cannot have more than 5 items
    if (items.length > 5) {
      exceptions.add(
        ValidationException(
          'items',
          'Cannot have more than 5 items',
          entity: this,
        ),
      );
    }

    return exceptions;
  }

  // Helper to add items and record events
  void addItem(String name) {
    items.add(name);

    // Record the event
    final event = Event('ItemAdded', 'Item was added to aggregate', [], this, {
      'itemName': name,
    });

    // Process the event through the base class
    pendingEvents.add(event);
  }
}

// Mock command for testing
class AddItemCommand implements ICommand {
  final String itemName;
  final TestAggregate aggregate;
  final List<Event> _events = [];

  AddItemCommand(this.aggregate, this.itemName);

  @override
  String get name => 'AddItem';

  @override
  String get category => 'Test';

  @override
  String get description => 'Adds an item to the aggregate';

  @override
  bool doIt() {
    aggregate.addItem(itemName);
    _events.add(
      Event(
        'ItemAdded',
        'An item was added to the aggregate',
        ['ItemAddedHandler'],
        aggregate,
        {'itemName': itemName},
      ),
    );
    return true;
  }

  @override
  bool undo() {
    // Remove the last item
    if (aggregate.items.isNotEmpty) {
      aggregate.items.removeLast();
      return true;
    }
    return false;
  }

  @override
  List<Event> getEvents() => _events;

  // Other ICommand methods
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

// Mock policy for testing
class ItemLimitPolicy implements IPolicy {
  @override
  String get name => 'ItemLimitPolicy';

  @override
  String get description => 'Limits the number of items in an aggregate';

  @override
  PolicyScope? get scope => null;

  @override
  bool evaluate(Entity entity) {
    return entity is TestAggregate;
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    bool result = evaluate(entity);
    return PolicyEvaluationResult(
      result,
      result ? [] : [PolicyViolation(name, description)],
    );
  }

  // Event triggered methods - not part of the IPolicy interface
  bool shouldTriggerOnEvent(dynamic event) {
    return event.name == 'ItemAdded';
  }

  void executeActions(dynamic entity, dynamic event) {
    print(
      'Policy executed: Checking item limit after adding ${event.data['itemName']}',
    );
  }

  List<dynamic> generateCommands(dynamic entity, dynamic event) {
    // If we reach 5 items, generate a command to change the name as a notification
    TestAggregate aggregate = entity as TestAggregate;
    if (aggregate.items.length == 5) {
      return [AddItemCommand(aggregate, 'LIMIT REACHED - NOTIFICATION ITEM')];
    }
    return [];
  }
}

// Define a mock concept for our aggregate
Concept createTestAggregateConcept() {
  // Create a model first
  Model model = Model(Domain("TestDomain"));
  model.code = "TestModel";

  // Then create the concept
  Concept concept = Concept(model, 'TestAggregate');
  concept.entry = true; // This makes it eligible to be an aggregate root

  // Add some attributes
  Attribute nameAttr = Attribute('name', concept);
  nameAttr.type = model.domain.types.getTypeByCode("String");
  nameAttr.init = '';
  nameAttr.update = true;
  nameAttr.required = true;
  concept.attributes.add(nameAttr);

  return concept;
}

void main() {
  group('AggregateRoot', () {
    late TestAggregate aggregate;

    setUp(() {
      aggregate = TestAggregate();

      // Mock concept property since we're focused on AggregateRoot behavior
      aggregate.concept = _createMockConcept();
    });

    test('should initialize with version 0', () {
      expect(aggregate.version, equals(0));
    });

    test('should track pending events', () {
      aggregate.addItem('Item 1');
      aggregate.addItem('Item 2');

      expect(aggregate.pendingEvents.length, equals(2));
      expect(aggregate.pendingEvents[0].name, equals('ItemAdded'));
    });

    test('should clear pending events', () {
      aggregate.addItem('Item 1');
      aggregate.addItem('Item 2');

      aggregate.markEventsAsProcessed();

      expect(aggregate.pendingEvents.length, equals(0));
    });

    test('should enforce business invariants', () {
      for (int i = 0; i < 6; i++) {
        aggregate.addItem('Item $i');
      }

      final exceptions = aggregate.enforceBusinessInvariants();

      expect(exceptions.isEmpty, isFalse);
      var iterator = exceptions.iterator;
      expect(iterator.moveNext(), isTrue);
      expect(
        iterator.current.message,
        contains('Cannot have more than 5 items'),
      );
    });

    test('should increment version during event processing', () {
      expect(aggregate.version, equals(0));

      aggregate.rehydrateFromEventHistory([
        Event('ItemAdded', 'Item 1 added', [], aggregate, {
          'itemName': 'Event Item 1',
        }),
        Event('ItemAdded', 'Item 2 added', [], aggregate, {
          'itemName': 'Event Item 2',
        }),
      ]);

      expect(aggregate.version, equals(2));
    });
  });
}

// Create a mock concept without relying on the full EDNet API
dynamic _createMockConcept() {
  // Create a minimal mock concept that just reports entry = true
  return DynamicMock(entry: true);
}

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

  @override
  void applyEvent(dynamic event) {
    if (event is Map && event['name'] == 'ItemAdded') {
      items.add(event['data']['itemName'] as String);
    }
  }

  void addItem(String name) {
    items.add(name);
    pendingEvents.add({
      'name': 'ItemAdded',
      'data': {'itemName': name},
    });
  }
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
  });
}
