/// Defines the core model structure for the EDNet Core framework.
///
/// This library provides a comprehensive domain modeling system that:
/// - Supports declarative domain model specification
/// - Enables structured command and event definitions
/// - Enforces business rules through policies
/// - Configures application services
/// - Bridges the domain and application layers
///
/// The domain model library is the foundation of the EDNet Core framework,
/// providing the building blocks for domain-driven design implementation.
///
/// Example usage:
/// ```dart
/// import 'package:ednet_core/domain/model.dart';
/// 
/// // Load a model from YAML
/// final model = Model.fromYaml(domainModelYaml);
/// 
/// // Access model components
/// final aggregateRoot = model.getAggregateRoot('Task');
/// final command = model.getCommand('Task', 'Finish');
/// final service = model.getApplicationService('TaskAssignment');
/// ```
library model;

import 'package:ednet_core/domain/application.dart' as app;
export 'package:ednet_core/domain/model/commands/interfaces/i_command.dart';
export 'package:ednet_core/domain/model/event/event.dart';
export 'package:ednet_core/domain/model/event/interfaces/i_past.dart';
export 'package:ednet_core/domain/model/entity/entity.dart';
export 'package:ednet_core/domain/model/entity/entities.dart';
export 'package:ednet_core/domain/model/value_object/value_object.dart';
export 'package:ednet_core/domain/model/oid.dart';
export 'package:ednet_core/domain/model/aggregate_root/aggregate_root.dart';
export 'package:ednet_core/domain/model/criteria/filter_criteria.dart';

part 'model/i_model_entries.dart';
part 'model/model_entries.dart';

/// Default YAML template for a Task Management domain model.
///
/// This template demonstrates:
/// - Domain dependencies (depends on UserManagement)
/// - Aggregate root definition (Task)
/// - Command definition (finish)
/// - Policy definition (task_finished_policy)
/// - Event definition (task_finished)
/// - Application service definition (TaskAssignment)
///
/// The YAML structure follows these conventions:
/// - Top-level keys define major components
/// - Nested keys define component properties
/// - Lists define multiple instances
/// - Indentation defines hierarchy
///
/// Example usage:
/// ```dart
/// final model = Model.fromYaml(defaultDomainModelYaml);
/// final taskService = model.getApplicationService('TaskAssignment');
/// taskService.executeCommand('assign', taskData);
/// ```
String defaultDomainModelYaml = '''
name: TaskManagement
dependsOn: [UserManagement]
aggregateRoots:
  name: task
  commands:
    name: finish
    intention: Finish the task
    policies:
      name: task_finished_policy
      expectation: Task must be in progress
      enforcement: throw TaskNotInProgressException
      events:
    name: task_finished
    payload:
      name
      task_id
applicationServices:
  name: TaskAssignment
  dependencies:
    TaskRepository
    UserRepository
  commands:
    name: assign
    intention: Assign a task to a user
    events:
      name: task_assigned
      payload:
        task_id
        user_id
''';

/// Bridges between the domain model and application layers.
///
/// This class provides adapter methods to convert between domain model
/// components and their application layer counterparts, enabling seamless
/// integration between the two layers.
///
/// Example usage:
/// ```dart
/// // Convert a domain model entity to an application layer aggregate root
/// final domainEntity = // ...
/// final appAggregate = ModelApplicationBridge.toApplicationAggregate(domainEntity);
///
/// // Convert a domain model command to an application layer command
/// final domainCommand = // ...
/// final appCommand = ModelApplicationBridge.toApplicationCommand(domainCommand);
/// ```
class ModelApplicationBridge {
  /// Converts a domain model entity to an application layer aggregate root.
  ///
  /// This method creates an application layer aggregate root that wraps
  /// the domain model entity, providing enhanced functionality while
  /// maintaining compatibility.
  ///
  /// [entity] is the domain model entity to convert.
  /// Returns an application layer aggregate root.
  static app.AggregateRoot toApplicationAggregate(Entity entity) {
    // This would be implemented based on the specific aggregate root type
    throw UnimplementedError(
      'Converting domain entities to application aggregates requires ' +
      'specific implementation for each aggregate type'
    );
  }
  
  /// Converts a domain model command to an application layer command.
  ///
  /// This method creates an application layer command that is compatible
  /// with the domain model command, providing enhanced functionality.
  ///
  /// [command] is the domain model command to convert.
  /// Returns an application layer command.
  static app.ICommand toApplicationCommand(commands.ICommand command) {
    // This is the inverse of ApplicationModelIntegration.toDomainCommand
    throw UnimplementedError(
      'Converting domain commands to application commands requires ' +
      'specific implementation for each command type'
    );
  }
  
  /// Converts a domain model filter criteria to an application layer criteria.
  ///
  /// This method creates an application layer criteria object that is compatible
  /// with the domain model criteria, providing enhanced querying capabilities.
  ///
  /// [criteria] is the domain model criteria to convert.
  /// Returns an application layer criteria.
  static app.Criteria toApplicationCriteria(FilterCriteria criteria) {
    // This would create a bridge between FilterCriteria and app.Criteria
    throw UnimplementedError(
      'Converting domain criteria to application criteria requires ' +
      'specific implementation'
    );
  }
}
