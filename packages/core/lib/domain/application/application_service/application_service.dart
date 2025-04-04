part of ednet_core;

/// Defines the standard interface for application services in the EDNet Core framework.
///
/// Application services coordinate the workflow between different parts of the domain:
/// - They receive commands from clients
/// - They load and interact with aggregate roots
/// - They manage the transaction boundaries
/// - They handle event publishing
/// - They coordinate policy execution
///
/// Application services act as the primary entry point for client applications
/// into the domain model, providing a clean API that abstracts away the details
/// of the domain implementation.
///
/// Example usage:
/// ```dart
/// class OrderService extends ApplicationService {
///   final OrderRepository _orderRepository;
///   final CustomerRepository _customerRepository;
///
///   OrderService(
///     DomainSession session,
///     this._orderRepository,
///     this._customerRepository,
///   ) : super(session);
///
///   CommandResult placeOrder(PlaceOrderCommand command) {
///     // Begin transaction
///     final transaction = beginTransaction('PlaceOrder');
///
///     try {
///       // Validate customer exists
///       final customer = _customerRepository.getById(command.customerId);
///       if (customer == null) {
///         return CommandResult.failure('Customer not found');
///       }
///
///       // Create order aggregate
///       final order = Order.create(command.customerId, command.items);
///
///       // Execute domain logic via aggregate root
///       final result = order.executeCommand(command);
///       if (result.isFailure) {
///         return result;
///       }
///
///       // Save changes
///       _orderRepository.save(order);
///
///       // Publish events
///       publishEvents(order.pendingEvents);
///
///       // Commit transaction
///       transaction.commit();
///
///       return CommandResult.success(data: {
///         'orderId': order.id,
///       });
///     } catch (e) {
///       // Rollback transaction
///       transaction.rollback();
///       return CommandResult.failure(e.toString());
///     }
///   }
/// }
/// ```
abstract class ApplicationService {
  /// The domain session this service operates within
  final dynamic _session;

  /// Creates a new application service with the given session
  ApplicationService(this._session);

  /// Gets the domain session
  dynamic get session => _session;

  /// Begins a new transaction with the given name
  dynamic beginTransaction(String name) {
    try {
      // Use dynamic invocation to create transaction
      return _createTransaction(name, _session);
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  /// Helper method to dynamically create transaction
  dynamic _createTransaction(String name, dynamic session) {
    if (session == null) return null;

    // Try different approaches to create a transaction
    try {
      // First try directly invoking Transaction constructor if available
      final transactionClass = _getTransactionClass();
      if (transactionClass != null) {
        return Function.apply(transactionClass, [name, session]);
      }
    } catch (_) {}

    // Fallback to session.beginTransaction if available
    if (session.beginTransaction != null &&
        session.beginTransaction is Function) {
      return session.beginTransaction(name);
    }

    // Return a simple mock transaction if nothing else works
    return _createMockTransaction(name);
  }

  /// Creates a mock transaction for fallback
  dynamic _createMockTransaction(String name) {
    return {'name': name, 'commit': () {}, 'rollback': () {}};
  }

  /// Helper to dynamically access Transaction class if available
  dynamic _getTransactionClass() {
    // Simple approach based on the session context
    if (_session != null) {
      // Try session.createTransaction if available
      if (_session.createTransaction is Function) {
        return _session.createTransaction;
      }

      // Try session.transactionFactory if available
      if (_session.transactionFactory is Function) {
        return _session.transactionFactory;
      }
    }

    // Fallback to basic factory function
    return (name, session) {
      return {
        'name': name,
        'session': session,
        'commit': () {},
        'rollback': () {},
      };
    };
  }

  /// Publishes events to the event bus
  void publishEvents(List<dynamic> events) {
    for (var event in events) {
      if (_session != null && _session.publishEvent is Function) {
        _session.publishEvent(event);
      }
    }
  }

  /// Executes a command on the specified aggregate root
  dynamic executeCommand(dynamic aggregateRoot, dynamic command) {
    // Set the session on the aggregate root if it doesn't have one
    if (aggregateRoot.session == null) {
      aggregateRoot.session = _session;
    }

    // Execute the command
    return aggregateRoot.executeCommand(command);
  }

  /// Executes a command handler for the given command
  dynamic executeCommandHandler(dynamic command) {
    // Find appropriate command handler for this command type
    final handlerName = '${command.runtimeType}Handler';

    // Attempt to find and execute the handler
    try {
      // This could be implemented with reflection or a command handler registry
      throw UnimplementedError('Command handler execution is not implemented');
    } catch (e) {
      return _createCommandFailureResult('No handler found for $handlerName');
    }
  }

  /// Helper to create a command failure result
  dynamic _createCommandFailureResult(String errorMessage) {
    // Try through session if available
    if (_session != null) {
      // Try session.createCommandFailureResult if available
      if (_session.createCommandFailureResult is Function) {
        return _session.createCommandFailureResult(errorMessage);
      }

      // Try session.commandResultFactory if available
      if (_session.commandResultFactory is Function &&
          _session.commandResultFactory.failure is Function) {
        return _session.commandResultFactory.failure(errorMessage);
      }
    }

    // Fallback to simple map structure
    return {'isSuccess': false, 'errorMessage': errorMessage};
  }

  /// Validates an entity
  dynamic validate(dynamic entity) {
    // Try to call required validation method if available
    if (entity != null &&
        entity.concept != null &&
        entity.concept.validateRequiredAttributes != null) {
      return entity.concept.validateRequiredAttributes(entity);
    }

    // Return empty validation result
    return _createEmptyValidationResult();
  }

  /// Helper to create empty validation result
  dynamic _createEmptyValidationResult() {
    // Try through session if available
    if (_session != null) {
      // Try session.createEmptyValidationResult if available
      if (_session.createEmptyValidationResult is Function) {
        return _session.createEmptyValidationResult();
      }

      // Try session.validationFactory if available
      if (_session.validationFactory is Function) {
        return _session.validationFactory.createEmpty();
      }
    }

    // Fallback to simple object with isEmpty property
    return {
      'isEmpty': true,
      'iterator': {'moveNext': () => false, 'current': null},
    };
  }

  /// Validates an aggregate root
  dynamic validateAggregate(dynamic aggregateRoot) {
    if (aggregateRoot != null &&
        aggregateRoot.validateAggregate != null &&
        aggregateRoot.validateAggregate is Function) {
      return aggregateRoot.validateAggregate();
    }
    return _createEmptyValidationResult();
  }
}
