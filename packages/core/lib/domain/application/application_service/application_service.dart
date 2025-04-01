part of ednet_core;

/// Represents an application service that orchestrates domain operations.
///
/// The [ApplicationService] class serves as a facade for domain operations, providing:
/// - Access to domain operations via the repository
/// - Transaction management
/// - Command handling and validation
/// - Event processing
/// - Use case orchestration
///
/// This class follows the Command Query Responsibility Segregation (CQRS) pattern,
/// separating command (write) operations from query (read) operations.
///
/// Example usage:
/// ```dart
/// class OrderApplicationService extends ApplicationService<Order> {
///   OrderApplicationService(
///     Repository<Order> repository, {
///     required String name,
///     required List<ApplicationService> dependencies,
///   }) : super(repository, name: name, dependencies: dependencies);
///
///   Future<OrderResult> createOrder(CreateOrderCommand command) async {
///     // Implementation
///   }
/// }
/// ```
abstract class ApplicationService<T extends AggregateRoot> {
  /// The name of this application service.
  final String name;
  
  /// Dependencies on other application services.
  final List<ApplicationService> dependencies;
  
  /// The repository for accessing aggregate instances.
  final Repository<T> repository;
  
  /// The domain session for transaction management.
  ///
  /// This session bridges the application and domain layers,
  /// allowing application commands to be executed in the domain context.
  final IDomainSession? session;

  /// Creates a new application service.
  ///
  /// Parameters:
  /// - [repository]: Repository for the aggregate type
  /// - [name]: Name of the service
  /// - [dependencies]: Other services this one depends on
  /// - [session]: Optional domain session for transaction management
  ApplicationService(
    this.repository, {
    required this.name,
    this.dependencies = const [],
    this.session,
  });

  /// Executes a command within a transactional context.
  /// 
  /// This method:
  /// 1. Validates the command
  /// 2. Executes it within a transaction
  /// 3. Persists changes using the repository
  /// 4. Returns the result
  /// 
  /// Parameters:
  /// - [command]: The command to execute
  /// 
  /// Returns:
  /// A Future with the result of the command execution
  Future<CommandResult> executeCommand(ICommand command) async {
    if (!validateCommand(command)) {
      return CommandResult.failure("Command validation failed");
    }
    
    try {
      // Begin transaction
      final result = await _executeCommandInternal(command);
      
      // Apply domain events
      await _processDomainEvents(command.getEvents());
      
      return result;
    } catch (e) {
      // Handle exceptions
      return CommandResult.failure("Command execution failed: $e");
    }
  }
  
  /// Validates a command before execution.
  /// 
  /// Override this method to implement command validation logic.
  /// 
  /// Parameters:
  /// - [command]: The command to validate
  /// 
  /// Returns:
  /// True if the command is valid, false otherwise
  bool validateCommand(ICommand command) {
    // Base implementation - subclasses should override
    return true;
  }
  
  /// Internal method to execute a command.
  /// 
  /// Parameters:
  /// - [command]: The command to execute
  /// 
  /// Returns:
  /// A Future with the result of the command execution
  Future<CommandResult> _executeCommandInternal(ICommand command) async {
    // Execute the command in the domain
    if (session != null) {
      // Bridge between application and domain layer commands
      if (session is DomainSession) {
        // Direct access to DomainSession implementation
        (session as DomainSession).executeCommand(command);
      } else {
        // If we're dealing with a custom session implementation,
        // we need to ensure it can handle our command type
        try {
          session!.executeCommand(command);
        } catch (e) {
          // If there's a type mismatch, try converting the command
          try {
            final domainCommand = ApplicationModelIntegration.toDomainCommand(command);
            session!.executeCommand(domainCommand);
          } catch (_) {
            // Re-throw the original exception if conversion fails
            rethrow;
          }
        }
      }
      return CommandResult.success();
    } else {
      // If no session provided, execute directly
      if (command.doIt()) {
        return CommandResult.success();
      } else {
        return CommandResult.failure("Command execution failed");
      }
    }
  }
  
  /// Processes domain events after command execution.
  /// 
  /// Parameters:
  /// - [events]: List of domain events to process
  Future<void> _processDomainEvents(List<IDomainEvent> events) async {
    for (var event in events) {
      await processEvent(event);
    }
  }
  
  /// Processes a domain event.
  /// 
  /// Override this method to implement event handling logic.
  /// 
  /// Parameters:
  /// - [event]: The event to process
  Future<void> processEvent(IDomainEvent event) async {
    // Base implementation - subclasses should override
  }
  
  /// Retrieves an aggregate by its identifier.
  /// 
  /// Parameters:
  /// - [id]: The identifier of the aggregate
  /// 
  /// Returns:
  /// A Future with the aggregate or null if not found
  Future<T?> getById(dynamic id) async {
    return await repository.findById(id);
  }
  
  /// Retrieves all aggregates.
  /// 
  /// Returns:
  /// A Future with a list of all aggregates
  Future<List<T>> getAll() async {
    return await repository.findAll();
  }
  
  /// Retrieves aggregates matching the specified criteria.
  /// 
  /// Parameters:
  /// - [criteria]: The criteria to match
  /// 
  /// Returns:
  /// A Future with a list of matching aggregates
  Future<List<T>> getByCriteria(Criteria<T> criteria) async {
    return await repository.findByCriteria(criteria);
  }
  
  /// Creates a new domain session if one doesn't exist.
  ///
  /// This method provides a convenient way to obtain a session
  /// for transaction management, creating a new one if needed.
  ///
  /// Returns:
  /// The existing session or a new one from the domain models
  IDomainSession getOrCreateSession() {
    if (session != null) {
      return session!;
    }
    
    // Create a new session if possible
    if (repository is DomainAwareRepository) {
      final domainModels = (repository as DomainAwareRepository).getDomainModels();
      return domainModels.newSession();
    }
    
    throw StateError(
      'Cannot create a new session: no existing session provided and ' +
      'repository does not implement DomainAwareRepository'
    );
  }
}

/// Interface for repositories that are aware of their domain models.
///
/// This interface allows repositories to provide access to their
/// domain models, which can be used to create new sessions.
abstract class DomainAwareRepository {
  /// Gets the domain models associated with this repository.
  ///
  /// Returns:
  /// The domain models for this repository
  IDomainModels getDomainModels();
}
