/// Defines the core model structure for the EDNet Core framework.
///
/// This file contains the model definition system that allows for:
/// - Declarative domain model specification
/// - Command and event definitions
/// - Policy enforcement rules
/// - Application service configuration
///
/// The model is defined using a YAML-based DSL that supports:
/// - Domain dependencies
/// - Aggregate root definitions
/// - Command and event specifications
/// - Policy definitions
/// - Application service configuration
///
/// Example usage:
/// ```dart
/// final model = Model.fromYaml(defaultDomainModelYaml);
/// final taskService = model.getApplicationService('TaskAssignment');
/// ```

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
