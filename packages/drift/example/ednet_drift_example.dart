import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_drift/ednet_drift_repository.dart';
import 'package:ednet_drift/cqrs_drift.dart';

void main() async {
  print('EDNet Drift CQRS Example');
  print('=======================');
  
  // Create a domain model with a simple Task concept
  final domain = createExampleDomain();
  
  // Create a repository with CQRS capabilities
  final repository = EDNetDriftCqrsRepository(
    domain: domain,
    sqlitePath: ':memory:', // Use in-memory database for the example
  );
  
  // Initialize the database
  await repository.open();
  
  // Demonstrate command execution
  print('\nExecuting commands:');
  await demonstrateCommands(repository, domain);
  
  // Demonstrate query execution
  print('\nExecuting queries:');
  await demonstrateQueries(repository, domain);
  
  // Demonstrate REST API query parameters
  print('\nExecuting REST API queries:');
  await demonstrateRestQueries(repository, domain);
  
  print('\nExample completed.');
}

/// Creates a simple domain model for the example.
Domain createExampleDomain() {
  final domain = Domain('ExampleDomain');
  
  // Create a Task concept
  final taskConcept = Concept(domain.models.first, 'Task');
  taskConcept.description = 'A task to be completed';
  
  // Add attributes
  final nameAttribute = Attribute();
  nameAttribute.code = 'name';
  nameAttribute.type = Type()..code = 'String';
  nameAttribute.required = true;
  taskConcept.attributes.add(nameAttribute);
  
  final statusAttribute = Attribute();
  statusAttribute.code = 'status';
  statusAttribute.type = Type()..code = 'String';
  statusAttribute.init = 'pending';
  taskConcept.attributes.add(statusAttribute);
  
  final priorityAttribute = Attribute();
  priorityAttribute.code = 'priority';
  priorityAttribute.type = Type()..code = 'int';
  priorityAttribute.init = '1';
  taskConcept.attributes.add(priorityAttribute);
  
  final dueDateAttribute = Attribute();
  dueDateAttribute.code = 'dueDate';
  dueDateAttribute.type = Type()..code = 'DateTime';
  taskConcept.attributes.add(dueDateAttribute);
  
  return domain;
}

/// Demonstrates command execution.
Future<void> demonstrateCommands(
  EDNetDriftCqrsRepository repository,
  Domain domain
) async {
  final taskConcept = domain.findConcept('Task')!;
  
  // Create CreateTask command
  final createTask = Command('CreateTask')
    ..withParameter('concept', taskConcept)
    ..withParameter('data', {
      'name': 'Complete CQRS implementation',
      'status': 'in_progress',
      'priority': 2,
      'dueDate': DateTime.now().add(Duration(days: 1)),
    });
  
  // Execute command
  final createResult = await repository.executeCommand(createTask);
  print('CreateTask result: ${createResult.isSuccess ? "Success" : "Failure"}');
  if (createResult.isSuccess) {
    print('  Created task with ID: ${createResult.data?['id']}');
  } else {
    print('  Error: ${createResult.errorMessage}');
  }
  
  // Create more tasks for demonstration
  final createTask2 = Command('CreateTask')
    ..withParameter('concept', taskConcept)
    ..withParameter('data', {
      'name': 'Write documentation',
      'status': 'pending',
      'priority': 1,
    });
  
  await repository.executeCommand(createTask2);
  
  final createTask3 = Command('CreateTask')
    ..withParameter('concept', taskConcept)
    ..withParameter('data', {
      'name': 'Review code',
      'status': 'pending',
      'priority': 3,
    });
  
  await repository.executeCommand(createTask3);
  
  // Update a task
  final updateTask = Command('UpdateTask')
    ..withParameter('concept', taskConcept)
    ..withParameter('data', {
      'id': createResult.data?['id'],
      'status': 'completed',
    });
  
  final updateResult = await repository.executeCommand(updateTask);
  print('UpdateTask result: ${updateResult.isSuccess ? "Success" : "Failure"}');
  if (updateResult.isSuccess) {
    print('  Updated task with ID: ${createResult.data?['id']}');
  } else {
    print('  Error: ${updateResult.errorMessage}');
  }
}

/// Demonstrates query execution.
Future<void> demonstrateQueries(
  EDNetDriftCqrsRepository repository,
  Domain domain
) async {
  final taskConcept = domain.findConcept('Task')!;
  
  // Create a query to find all tasks
  final findAllQuery = ConceptQuery('FindAll', taskConcept);
  
  // Execute the query
  final findAllResult = await repository.executeQuery(findAllQuery);
  if (findAllResult.isSuccess) {
    print('Found ${findAllResult.data?.length ?? 0} tasks:');
    for (var task in findAllResult.data!) {
      print('  Task: ${task.getAttribute('name')} - ${task.getAttribute('status')}');
    }
  } else {
    print('Error executing FindAll query: ${findAllResult.errorMessage}');
  }
  
  // Create a query to find tasks by status
  final findByStatusQuery = ConceptQuery('FindByCriteria', taskConcept)
    ..withParameter('status', 'pending');
  
  // Execute the query
  final findByStatusResult = await repository.executeQuery(findByStatusQuery);
  if (findByStatusResult.isSuccess) {
    print('\nFound ${findByStatusResult.data?.length ?? 0} pending tasks:');
    for (var task in findByStatusResult.data!) {
      print('  Task: ${task.getAttribute('name')} - Priority: ${task.getAttribute('priority')}');
    }
  } else {
    print('Error executing FindByCriteria query: ${findByStatusResult.errorMessage}');
  }
  
  // Create a query with sorting
  final findSortedQuery = ConceptQuery('FindByCriteria', taskConcept)
    ..withSorting('priority', ascending: false);
  
  // Execute the query
  final findSortedResult = await repository.executeQuery(findSortedQuery);
  if (findSortedResult.isSuccess) {
    print('\nTasks sorted by priority (descending):');
    for (var task in findSortedResult.data!) {
      print('  Task: ${task.getAttribute('name')} - Priority: ${task.getAttribute('priority')}');
    }
  } else {
    print('Error executing FindByCriteria query: ${findSortedResult.errorMessage}');
  }
}

/// Demonstrates REST API query parameter handling.
Future<void> demonstrateRestQueries(
  EDNetDriftCqrsRepository repository,
  Domain domain
) async {
  // Simulate REST API request parameters
  final params1 = {
    'filter': {'status': 'pending'},
    'sort': 'priority',
    'page': '1',
    'limit': '10',
  };
  
  // Execute REST API query
  final result1 = await repository.executeRestQuery('Task', params1);
  if (result1.isSuccess) {
    print('REST API query result (filter by status):');
    for (var task in result1.data!) {
      print('  Task: ${task.getAttribute('name')} - Status: ${task.getAttribute('status')}');
    }
  } else {
    print('Error executing REST API query: ${result1.errorMessage}');
  }
  
  // Simulate REST API request with different parameter formats
  final params2 = {
    'filter[priority]': '3',
    'sort': '-priority',
  };
  
  // Execute REST API query
  final result2 = await repository.executeRestQuery('Task', params2);
  if (result2.isSuccess) {
    print('\nREST API query result (filter by priority):');
    for (var task in result2.data!) {
      print('  Task: ${task.getAttribute('name')} - Priority: ${task.getAttribute('priority')}');
    }
  } else {
    print('Error executing REST API query: ${result2.errorMessage}');
  }
}

/// A general-purpose command for demonstration.
class Command implements app.ICommand {
  final String _name;
  final Map<String, dynamic> _parameters = {};
  
  Command(this._name);
  
  @override
  String get name => _name;
  
  @override
  Map<String, dynamic> getParameters() => Map.unmodifiable(_parameters);
  
  /// Adds a parameter to this command.
  Command withParameter(String name, dynamic value) {
    _parameters[name] = value;
    return this;
  }
  
  /// Adds multiple parameters to this command.
  Command withParameters(Map<String, dynamic> parameters) {
    _parameters.addAll(parameters);
    return this;
  }
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true; // Simplified for demo
}
