part of ednet_core;

/// AggregateRoot represents a DDD tactical pattern that serves as the entry point and consistency boundary
/// for a graph of objects that represent a cohesive domain concept.
///
/// An AggregateRoot is responsible for:
/// 1. Enforcing invariants across the entire aggregate
/// 2. Ensuring transactional consistency
/// 3. Protecting the internal state of the aggregate
/// 4. Providing a single entry point into the aggregate
/// 5. Being the only object within the aggregate that outside objects can reference
///
/// In ednet_core, an AggregateRoot is built on top of the existing Entity framework
/// and connected to concepts where entry = true.
abstract class AggregateRoot<T extends Entity<T>> extends Entity<T> {
  /// List of pending events that occurred but haven't been processed yet
  final List<dynamic> _pendingEvents = [];

  /// The domain session this aggregate operates within
  dynamic _session;

  /// Policy engine for handling policy enforcement and triggering
  dynamic _policyEngine;

  /// Stores the current state/version of the aggregate
  int _version = 0;

  /// Create a new aggregate root
  AggregateRoot() : super();

  /// Get the current version of the aggregate
  int get version => _version;

  /// Get the domain session this aggregate operates within
  dynamic get session => _session;

  /// Set the domain session for this aggregate
  set session(dynamic session) {
    _session = session;
    if (session != null && _policyEngine == null) {
      _policyEngine = PolicyEngine(session);
    }
  }

  /// Get the policy engine for this aggregate
  dynamic get policyEngine => _policyEngine;

  /// Set the policy engine for this aggregate
  set policyEngine(dynamic engine) {
    _policyEngine = engine;
  }

  /// Get pending events that need to be processed
  List<dynamic> get pendingEvents => List.unmodifiable(_pendingEvents);

  /// Marks all pending events as processed
  void markEventsAsProcessed() {
    _pendingEvents.clear();
  }

  /// Records a domain event and adds it to pending events
  /// Also triggers policy evaluation if a policy engine is attached
  dynamic recordEvent(
    String name,
    String description,
    List<String> handlers, {
    Map<String, dynamic> data = const {},
  }) {
    final event = Event(name, description, handlers, this, data);
    _pendingEvents.add(event);

    // Apply the event to update aggregate state
    applyEvent(event);

    // Trigger policies if available
    if (_policyEngine != null) {
      _triggerPoliciesFromEvent(event);
    }

    return event;
  }

  /// Checks if this Entity's concept is marked as an entry point
  bool get isAggregateRoot => concept.entry;

  /// Validates that this entity can function as an aggregate root
  void enforceAggregateRootInvariants() {
    if (!isAggregateRoot) {
      throw ValidationException(
        'entry',
        'AggregateRoot must be applied to entry concepts only.',
        entity: this,
      );
    }
  }

  /// Protects the aggregate by enforcing its business rules and invariants
  /// Should be overridden by concrete implementations to express domain-specific rules
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();
    // Domain-specific business rules should be implemented here by subclasses
    // Example:
    // if (election.registeredVoters < election.minimumRequiredVoters) {
    //   exceptions.add(ValidationException(
    //     'registeredVoters',
    //     'Insufficient voters for election',
    //     entity: election
    //   ));
    // }
    return exceptions;
  }

  /// Executes a command against this aggregate root, ensuring all business rules are satisfied
  /// Returns a CommandResult indicating success or failure
  dynamic executeCommand(dynamic command) {
    // Validate that this is a proper aggregate root
    enforceAggregateRootInvariants();

    // Begin transaction
    try {
      // Execute the command using the existing command infrastructure
      bool executed = false;

      if (command.doIt != null && command.doIt is Function) {
        executed = command.doIt();
      }

      if (!executed) {
        return {"isSuccess": false, "errorMessage": "Command execution failed"};
      }

      // Validate business rules after command execution
      ValidationExceptions validationResults = enforceBusinessInvariants();

      if (!validationResults.isEmpty) {
        // If validation fails, try to undo the command
        if (command.undo != null && command.undo is Function) {
          command.undo();
        }
        return {
          "isSuccess": false,
          "errorMessage": validationResults.toString(),
        };
      }

      // If everything is valid, increment version and collect events
      _version++;

      // Add any command events to our pending events
      if (command.getEvents != null && command.getEvents is Function) {
        final commandEvents = command.getEvents();
        _pendingEvents.addAll(commandEvents);

        // Apply each event to update state
        for (var event in commandEvents) {
          applyEvent(event);
        }

        // Trigger policies based on each event
        if (_policyEngine != null) {
          for (var event in commandEvents) {
            _triggerPoliciesFromEvent(event);
          }
        }
      }

      // Return success with aggregate information
      return {
        "isSuccess": true,
        "data": {
          'id': oid.toString(),
          'version': _version,
          'pendingEvents': pendingEvents,
        },
      };
    } catch (e) {
      // If any domain rule is violated, reject the command
      return {
        "isSuccess": false,
        "errorMessage": "Command execution failed: ${e.toString()}",
      };
    }
  }

  /// Creates a transaction for this aggregate root
  Transaction beginTransaction(String name, DomainSession session) {
    this.session = session;
    return Transaction(name, session);
  }

  /// Registers a policy with this aggregate
  void registerPolicy(Policy policy) {
    if (_policyEngine == null) {
      _policyEngine = PolicyEngine(session);
    }
    _policyEngine.addPolicy(policy);
  }

  /// Trigger policies based on an event
  void _triggerPoliciesFromEvent(dynamic event) {
    if (_policyEngine == null) return;

    // First, evaluate which policies apply to this entity
    final applicablePolicies = _policyEngine.getApplicablePolicies(this);

    // For each applicable policy, check if it should trigger on this event
    for (var policy in applicablePolicies) {
      if (_isEventTriggeredPolicy(policy)) {
        dynamic dynamicPolicy = policy;
        if (dynamicPolicy.shouldTriggerOnEvent(event)) {
          // Policy is triggered by this event, execute its actions
          dynamicPolicy.executeActions(this, event);

          // If the policy generates commands, execute them
          final commands = dynamicPolicy.generateCommands(this, event);
          for (var command in commands) {
            if (command.doIt != null && command.doIt is Function) {
              // Link the command to this aggregate's session if not already set
              if (_isSessionAware(command) && session != null) {
                (command as dynamic).setSession(session);
              }

              // Execute the command
              executeCommand(command);
            }
          }
        }
      }
    }
  }

  /// Helper method to check if an object implements IEventTriggeredPolicy
  bool _isEventTriggeredPolicy(dynamic obj) {
    return obj != null &&
        obj.shouldTriggerOnEvent is Function &&
        obj.executeActions is Function &&
        obj.generateCommands is Function;
  }

  /// Helper method to check if an object implements SessionAware
  bool _isSessionAware(dynamic obj) {
    return obj != null && obj.setSession is Function;
  }

  /// Reconstructs the aggregate's state from its event history
  /// Used in event sourcing scenarios
  void rehydrateFromEventHistory(List<dynamic> eventHistory) {
    for (var event in eventHistory) {
      applyEvent(event);
      _version++;
    }
  }

  /// Applies a single event to update the aggregate's state
  /// Should be overridden by concrete implementations with domain-specific logic
  void applyEvent(dynamic event) {
    // Each specific AggregateRoot should override this with domain-specific logic
    // Example:
    // if (event.name == 'VoteCast') {
    //   _recordVote(event.data['voterId'], event.data['candidateId']);
    // } else if (event.name == 'CandidateRegistered') {
    //   _registerCandidate(event.data['candidateId'], event.data['candidateName']);
    // }
  }

  /// Ensures that domain relationships maintain the aggregate's consistency boundaries
  /// This helps address the validation warnings by maintaining proper domain relationships
  ValidationExceptions maintainRelationshipIntegrity() {
    final exceptions = ValidationExceptions();

    // To be implemented by concrete classes for their specific relationship rules
    // Example:
    // for (var ballot in ballots) {
    //   if (ballot.election != this) {
    //     try {
    //       // Use existing command infrastructure to set parent
    //       var setParentCmd = SetParentCommand(session, ballot, 'election', this);
    //       setParentCmd.doIt();
    //     } catch (e) {
    //       exceptions.add(ValidationException(
    //         'relationship',
    //         e.toString(),
    //         entity: ballot
    //       ));
    //     }
    //   }
    // }

    return exceptions;
  }

  /// Validates the entire aggregate against domain rules
  ValidationExceptions validateAggregate() {
    // Start with relationship integrity checks
    ValidationExceptions exceptions = maintainRelationshipIntegrity();

    // Then add business rule validations
    ValidationExceptions businessRuleExceptions = enforceBusinessInvariants();
    var iterator = businessRuleExceptions.iterator;
    while (iterator.moveNext()) {
      exceptions.add(iterator.current);
    }

    return exceptions;
  }

  /// Creates a graph representation of the entire aggregate
  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['isAggregateRoot'] = true;
    graph['version'] = _version;
    graph['pendingEventCount'] = _pendingEvents.length;
    return graph;
  }
}

/// Interface for objects that can be associated with a domain session
abstract class SessionAware {
  /// Sets the domain session for this object
  void setSession(dynamic session);
}

/// Base class for all domain events in the system
abstract class DomainEvent {
  final String aggregateId;
  final int version;
  final DateTime timestamp;

  DomainEvent(this.aggregateId, this.version) : timestamp = DateTime.now();

  Map<String, dynamic> toMap();
}

/// Base class for all commands in the system
abstract class Command {
  void execute(AggregateRoot aggregateRoot);
}

/// Exception specifically for domain validation failures
class DomainValidationException implements Exception {
  final String message;
  final Entity? entity;

  DomainValidationException(this.message, {this.entity});

  @override
  String toString() =>
      'Domain Validation Error: $message${entity != null ? ' in ${entity.runtimeType}' : ''}';
}
