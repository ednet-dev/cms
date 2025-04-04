# The Command-Event-Policy Cycle

In the previous articles, we've explored individual components of EDNet Core: entities, aggregates, collections, concepts, policies, and events. In this final article, we'll see how these components work together to form a powerful architectural pattern: the Command-Event-Policy cycle. This cycle enables reactive, autonomous domain models that can respond to changes and enforce business rules automatically.

## The Command-Event-Policy Cycle

The Command-Event-Policy cycle is a pattern that combines three key components:

1. **Commands**: Instructions to perform an action or change state
2. **Events**: Records of something that has happened in the domain
3. **Policies**: Rules that respond to events and may generate new commands

These three components form a cycle where:
- Commands are executed on aggregate roots
- Execution of commands produces events
- Events trigger policies
- Policies may generate new commands

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Commands  │────▶│    Events   │────▶│   Policies  │
└─────────────┘     └─────────────┘     └─────────────┘
       ▲                                       │
       │                                       │
       └───────────────────────────────────────┘
```

This cycle creates a dynamic, reactive system where domain behavior can emerge from the interaction of simple rules, rather than being explicitly programmed as sequential steps.

## Commands: Expressing Intent

Commands represent the intent to change the state of the domain. They are named with imperative verbs (Create, Update, Cancel) and are typically implemented as simple data transfer objects:

```dart
class PlaceOrderCommand {
  final String customerId;
  final List<OrderItem> items;
  final String? shippingAddress;
  final String? paymentMethodId;
  
  PlaceOrderCommand({
    required this.customerId,
    required this.items,
    this.shippingAddress,
    this.paymentMethodId
  });
}
```

Commands should:
- Express a single intent
- Be immutable
- Include all necessary data to execute the action
- Be named in the imperative tense
- Represent something that might be rejected

### Command Handlers

In EDNet Core, commands are typically handled by methods on aggregate roots or by dedicated command handlers:

```dart
// Command handling in an aggregate root
class Order extends AggregateRoot<Order> {
  dynamic executeCommand(dynamic command) {
    if (command is PlaceOrderCommand) {
      return placeOrder(command);
    } else if (command is ShipOrderCommand) {
      return shipOrder(command);
    } else if (command is CancelOrderCommand) {
      return cancelOrder(command);
    }
    
    return {
      'isSuccess': false,
      'errorMessage': 'Unknown command type: ${command.runtimeType}'
    };
  }
  
  dynamic placeOrder(PlaceOrderCommand command) {
    // Validate command
    var validationResult = validateCommand(command);
    if (!validationResult.isEmpty) {
      return {
        'isSuccess': false,
        'errorMessage': 'Invalid command',
        'validationErrors': validationResult.toList()
      };
    }
    
    // Set order properties
    customerId = command.customerId;
    
    // Add items to order
    for (var item in command.items) {
      var orderLine = OrderLine();
      orderLine.productId = item.productId;
      orderLine.quantity = item.quantity;
      orderLine.unitPrice = item.unitPrice;
      lines.add(orderLine);
    }
    
    // Record domain event
    recordEvent(
      'OrderPlaced',
      'Order was placed by customer',
      ['OrderFulfillmentHandler', 'NotificationHandler'],
      data: {
        'customerId': customerId,
        'orderTotal': calculateTotal(),
        'lineCount': lines.length
      }
    );
    
    return {'isSuccess': true, 'orderId': oid.toString()};
  }
}
```

### Command Validation

Commands are validated before execution to ensure they are valid and can be executed:

```dart
ValidationResult validateCommand(PlaceOrderCommand command) {
  var result = ValidationResult();
  
  // Check for required fields
  if (command.customerId.isEmpty) {
    result.add(ValidationException('customerId', 'Customer ID is required'));
  }
  
  if (command.items.isEmpty) {
    result.add(ValidationException('items', 'Order must have at least one item'));
  }
  
  // Check item validity
  for (var i = 0; i < command.items.length; i++) {
    var item = command.items[i];
    
    if (item.productId.isEmpty) {
      result.add(ValidationException(
        'items[$i].productId',
        'Product ID is required'
      ));
    }
    
    if (item.quantity <= 0) {
      result.add(ValidationException(
        'items[$i].quantity',
        'Quantity must be greater than zero'
      ));
    }
    
    if (item.unitPrice < 0) {
      result.add(ValidationException(
        'items[$i].unitPrice',
        'Unit price cannot be negative'
      ));
    }
  }
  
  return result;
}
```

## Events: Recording Facts

As we saw in the previous article, events record facts about what has happened in the domain. They are the result of successful command execution and form the basis for event sourcing:

```dart
// Event created when a command is executed
final event = recordEvent(
  'OrderPlaced',
  'Order was placed by customer',
  ['OrderFulfillmentHandler', 'NotificationHandler'],
  data: {
    'customerId': customerId,
    'orderTotal': calculateTotal(),
    'lineCount': lines.length
  }
);
```

Events should:
- Be named in the past tense (Created, Updated, Canceled)
- Include all relevant data about what happened
- Be immutable
- Be treated as facts (they cannot be rejected or undone)

### Event Publishing

Once events are recorded by an aggregate, they need to be published to event handlers. This is typically done by an application service:

```dart
class OrderService extends ApplicationService {
  final OrderRepository _orderRepo;
  
  OrderService(DomainSession session, this._orderRepo) : super(session);
  
  dynamic placeOrder(PlaceOrderCommand command) {
    // Begin transaction
    final transaction = beginTransaction('PlaceOrder');
    
    try {
      // Create order aggregate
      var order = Order();
      
      // Execute command
      var result = order.executeCommand(command);
      if (!result['isSuccess']) {
        return result;
      }
      
      // Save the aggregate
      _orderRepo.save(order);
      
      // Publish events
      publishEvents(order.pendingEvents);
      
      // Mark events as processed
      order.markEventsAsProcessed();
      
      // Commit transaction
      transaction.commit();
      
      return result;
    } catch (e) {
      // Rollback transaction
      transaction.rollback();
      return {
        'isSuccess': false,
        'errorMessage': e.toString()
      };
    }
  }
}
```

## Policies: Enforcing Rules and Reacting to Events

Policies enforce business rules and react to events. Unlike commands, which are explicitly invoked, policies are triggered automatically when relevant events occur:

```dart
class LowStockNotificationPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'LowStockNotification';
  
  @override
  String get description => 'Notify when stock levels are low';
  
  @override
  bool evaluate(Entity entity) {
    return entity is Product;
  }
  
  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event.name == 'StockChanged';
  }
  
  @override
  void executeActions(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'] as int;
    
    if (newStock < product.reorderThreshold) {
      NotificationService.sendLowStockAlert(
        product.code,
        product.name,
        newStock,
        product.reorderThreshold
      );
    }
  }
  
  @override
  List<dynamic> generateCommands(dynamic entity, dynamic event) {
    final product = entity as Product;
    final newStock = event.data['newStock'] as int;
    
    if (newStock < product.reorderThreshold && !product.reorderPlaced) {
      return [CreatePurchaseOrderCommand(product)];
    }
    return [];
  }
}
```

Policies have several key components:
- **Evaluation**: Determining if the policy applies to an entity
- **Triggering**: Determining if the policy should react to an event
- **Action**: Performing side effects (notifications, logging, etc.)
- **Command Generation**: Creating new commands to continue the cycle

### Policy Registration and Execution

Policies are registered with the domain model and executed when events are published:

```dart
// Register policies with the model
model.registerPolicy('LowStockNotification', LowStockNotificationPolicy());

// Policy execution engine
class PolicyEngine {
  final PolicyRegistry _registry;
  final CommandBus _commandBus;
  
  PolicyEngine(this._registry, this._commandBus);
  
  void processEvent(Entity entity, dynamic event) {
    // Find policies that should trigger for this event
    var applicablePolicies = _registry.getAllPolicies().where((policy) {
      if (policy is IEventTriggeredPolicy) {
        return policy.evaluate(entity) && policy.shouldTriggerOnEvent(event);
      }
      return false;
    });
    
    // Execute actions for each policy
    for (var policy in applicablePolicies) {
      if (policy is IEventTriggeredPolicy) {
        // Execute side effects
        policy.executeActions(entity, event);
        
        // Generate and dispatch commands
        var commands = policy.generateCommands(entity, event);
        for (var command in commands) {
          _commandBus.dispatch(command);
        }
      }
    }
  }
}
```

## Completing the Cycle: The Command Bus

To complete the Command-Event-Policy cycle, we need a way to dispatch commands generated by policies. This is handled by the Command Bus:

```dart
class CommandBus {
  final Map<Type, ICommandHandler> _handlers = {};
  
  void registerHandler<T>(ICommandHandler<T> handler) {
    _handlers[T] = handler;
  }
  
  Future<dynamic> dispatch(dynamic command) async {
    final handler = _handlers[command.runtimeType];
    if (handler == null) {
      throw CommandHandlerNotFoundException(
        'No handler registered for ${command.runtimeType}'
      );
    }
    
    return await handler.handle(command);
  }
}
```

The Command Bus routes commands to their appropriate handlers, closing the loop of the Command-Event-Policy cycle.

## Practical Example: Order Fulfillment Process

Let's see how the Command-Event-Policy cycle works in practice with an order fulfillment process:

```dart
// 1. Start with a command
final placeOrderCommand = PlaceOrderCommand(
  customerId: 'CUST123',
  items: [
    OrderItem(productId: 'PROD456', quantity: 2, unitPrice: 29.99),
    OrderItem(productId: 'PROD789', quantity: 1, unitPrice: 49.99)
  ]
);

// 2. Command handler executes command and produces events
final orderService = OrderService(session, orderRepo);
final result = await orderService.placeOrder(placeOrderCommand);

// The event 'OrderPlaced' is now published

// 3. Policy reacts to the event
// InventoryReservationPolicy would automatically:
// - Reserve inventory for each product
// - If inventory is insufficient, generate a command:
final backorderCommand = CreateBackorderCommand(
  orderId: result['orderId'],
  productId: 'PROD456',
  quantity: 1
);

// 4. Command bus dispatches the new command
final backorderResult = await commandBus.dispatch(backorderCommand);

// 5. New events are generated (BackorderCreated)
// Which may trigger other policies, continuing the cycle
```

This example demonstrates how complex business processes can emerge from the interaction of simple commands, events, and policies, without requiring explicit orchestration.

## Advanced Patterns in the Command-Event-Policy Cycle

### Process Managers

Process managers (also called sagas) coordinate long-running processes across multiple aggregates:

```dart
class OrderFulfillmentProcess implements IEventTriggeredPolicy {
  @override
  String get name => 'OrderFulfillmentProcess';
  
  @override
  String get description => 'Manages the order fulfillment process';
  
  @override
  bool evaluate(Entity entity) {
    return entity is Order;
  }
  
  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event.name == 'OrderPlaced' ||
           event.name == 'PaymentReceived' ||
           event.name == 'InventoryReserved' ||
           event.name == 'OrderShipped';
  }
  
  @override
  void executeActions(dynamic entity, dynamic event) {
    // Update process tracking database
    updateProcessStatus(entity.oid.toString(), event.name);
  }
  
  @override
  List<dynamic> generateCommands(dynamic entity, dynamic event) {
    final order = entity as Order;
    
    if (event.name == 'OrderPlaced') {
      return [ProcessPaymentCommand(order.paymentMethodId, order.total)];
    } else if (event.name == 'PaymentReceived') {
      return [ReserveInventoryCommand(order.oid.toString(), order.lines)];
    } else if (event.name == 'InventoryReserved') {
      return [PrepareShipmentCommand(order.oid.toString())];
    }
    
    return [];
  }
}
```

### Event Collaboration

Multiple aggregates can collaborate through events without direct coupling:

```dart
// Inventory aggregate reacts to order events
class InventoryHandler implements EventHandler {
  final InventoryRepository _repo;
  
  InventoryHandler(this._repo);
  
  @override
  String get eventName => 'OrderPlaced';
  
  @override
  Future<void> handle(Event event) async {
    final orderLines = event.data['lines'] as List;
    
    for (var line in orderLines) {
      var productId = line['productId'];
      var quantity = line['quantity'];
      
      // Update inventory
      var inventory = await _repo.getByProductId(productId);
      inventory.reserveStock(quantity);
      await _repo.save(inventory);
    }
  }
}
```

### Eventual Consistency

The Command-Event-Policy cycle naturally leads to eventually consistent systems:

```dart
// OrderSummary projection is updated asynchronously
class OrderSummaryProjectionHandler implements EventHandler {
  final Database _db;
  
  OrderSummaryProjectionHandler(this._db);
  
  @override
  String get eventName => 'OrderStatusChanged';
  
  @override
  Future<void> handle(Event event) async {
    final orderId = event.entity.oid.toString();
    final newStatus = event.data['newStatus'];
    
    // Update read model asynchronously
    await _db.updateOrderSummary(orderId, 'status', newStatus);
  }
}
```

## Application Services as Orchestrators

Application services act as the orchestrators of the Command-Event-Policy cycle:

```dart
class ApplicationService {
  final DomainSession _session;
  final CommandBus _commandBus;
  final EventBus _eventBus;
  final PolicyEngine _policyEngine;
  
  ApplicationService(
    this._session,
    this._commandBus,
    this._eventBus,
    this._policyEngine
  );
  
  dynamic executeCommand(dynamic command) {
    // Dispatch command
    var result = _commandBus.dispatch(command);
    
    // If successful and events were generated
    if (result['isSuccess'] && result['events'] != null) {
      // Publish events
      for (var event in result['events']) {
        _eventBus.publish(event);
        
        // Process policies
        _policyEngine.processEvent(event.entity, event);
      }
    }
    
    return result;
  }
}
```

## Best Practices for the Command-Event-Policy Cycle

1. **Command Responsibility**: Keep commands focused on a single intention
2. **Event Completeness**: Ensure events contain all data needed by handlers
3. **Policy Independence**: Design policies to be independent of each other
4. **Idempotent Handlers**: Make event handlers idempotent to handle duplicate events
5. **Command Validation**: Validate commands before execution, not during
6. **Event Evolution**: Design for event schema evolution from the beginning
7. **Policy Reactivity**: Keep policies reactive rather than proactive
8. **Transaction Boundaries**: Clearly define transaction boundaries around command execution

## Challenges and Considerations

The Command-Event-Policy cycle brings several challenges:

### 1. Debugging Complexity

With asynchronous, reactive flows, debugging can become more challenging:

```dart
// Add tracing to help debug event flows
class TracingEventBus implements EventBus {
  final EventBus _innerBus;
  final Logger _logger;
  
  TracingEventBus(this._innerBus, this._logger);
  
  @override
  void publish(Event event) {
    var eventId = Uuid().v4();
    _logger.info(
      'Publishing event ${event.name} (ID: $eventId) ' +
      'for ${event.entity.runtimeType} ' +
      '(ID: ${event.entity.oid})'
    );
    
    _innerBus.publish(event);
    
    _logger.info('Event $eventId published successfully');
  }
}
```

### 2. Managing Event Schemas

As your system evolves, managing event schemas becomes crucial:

```dart
class EventSchemaRegistry {
  final Map<String, Map<int, EventSchema>> _schemas = {};
  
  void registerSchema(String eventName, int version, EventSchema schema) {
    _schemas.putIfAbsent(eventName, () => {});
    _schemas[eventName]![version] = schema;
  }
  
  EventSchema? getSchema(String eventName, int version) {
    return _schemas[eventName]?[version];
  }
  
  bool validateEvent(Event event, int version) {
    final schema = getSchema(event.name, version);
    if (schema == null) return false;
    
    return schema.validate(event.data);
  }
}
```

### 3. Testing Event-Driven Systems

Testing event-driven systems requires special attention:

```dart
void testOrderFulfillmentProcess() {
  // Create test doubles
  var mockCommandBus = MockCommandBus();
  var mockEventBus = MockEventBus();
  var mockPolicyEngine = MockPolicyEngine();
  
  // Create the service with mocks
  var service = OrderService(
    mockSession,
    mockOrderRepo,
    mockCommandBus,
    mockEventBus,
    mockPolicyEngine
  );
  
  // Execute command
  service.placeOrder(testPlaceOrderCommand);
  
  // Verify command was validated
  verify(mockCommandBus.validate(testPlaceOrderCommand)).called(1);
  
  // Verify event was published
  verify(mockEventBus.publish(
    argThat(isA<Event>().having((e) => e.name, 'name', 'OrderPlaced'))
  )).called(1);
  
  // Verify policy engine was invoked
  verify(mockPolicyEngine.processEvent(
    any,
    argThat(isA<Event>().having((e) => e.name, 'name', 'OrderPlaced'))
  )).called(1);
}
```

## Conclusion

The Command-Event-Policy cycle is a powerful pattern that brings together commands, events, and policies to create reactive, autonomous domain models. By separating the intention to change state (commands) from the record of what happened (events) and the reactions to those changes (policies), we create more maintainable, extensible, and testable systems.

EDNet Core provides all the components needed to implement this pattern effectively:
- Aggregate roots that handle commands and record events
- Event sourcing for robust state management
- Policy framework for automatic rule enforcement
- Command bus for dispatching commands
- Event bus for publishing events

This completes our exploration of EDNet Core's domain modeling capabilities. From entities and concepts to the Command-Event-Policy cycle, we've seen how EDNet Core provides a comprehensive toolkit for building rich, expressive domain models that capture the complexity of real-world business domains.

---

*This article is part of the #EDNet - Core domain modeling series, exploring advanced domain modeling techniques with the EDNet Core framework.* 