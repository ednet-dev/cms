import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_drift/cqrs_drift.dart';
import 'package:ednet_drift/ednet_drift_repository.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../utils/test_domain.dart';

void main() {
  late Domain domain;
  late EDNetDriftDatabase db;
  late DriftCommandAdapter commandAdapter;
  late Directory tempDir;
  late Concept taskConcept;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('ednet_test_');
  });

  setUp(() {
    // Create a fresh domain model for each test
    domain = createTestDomain();
    taskConcept = domain.findConcept('Task')!;
    
    // Create an in-memory database for testing
    final executor = NativeDatabase.memory();
    db = EDNetDriftDatabase(domain, executor);
    
    // Initialize the command adapter
    commandAdapter = DriftCommandAdapter(db);
  });

  tearDown(() async {
    await db.close();
  });

  tearDownAll(() {
    tempDir.deleteSync(recursive: true);
  });

  group('DriftCommandAdapter', () {
    test('should create an entity with AddCommand', () async {
      // Create a command to add a task
      final command = TestCommand('AddTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'name': 'Test Task',
          'status': 'pending',
          'priority': 1,
        });

      // Execute the command
      final result = await commandAdapter.executeCommand(command);

      // Verify the result
      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
      expect(result.data!['id'], isNotNull);

      // Verify the entity was created in the database
      final rows = await db.customSelect('SELECT * FROM task').get();
      expect(rows.length, 1);
      expect(rows.first.read<String>('name'), 'Test Task');
      expect(rows.first.read<String>('status'), 'pending');
      expect(rows.first.read<int>('priority'), 1);
    });

    test('should update an entity with UpdateCommand', () async {
      // First create an entity
      final createCommand = TestCommand('AddTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'name': 'Initial Task',
          'status': 'pending',
          'priority': 1,
        });

      final createResult = await commandAdapter.executeCommand(createCommand);
      final taskId = createResult.data!['id'];

      // Now update the entity
      final updateCommand = TestCommand('UpdateTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'id': taskId,
          'status': 'completed',
          'priority': 2,
        });

      final updateResult = await commandAdapter.executeCommand(updateCommand);

      // Verify the update result
      expect(updateResult.isSuccess, isTrue);
      expect(updateResult.data!['rowsAffected'], 1);

      // Verify the entity was updated in the database
      final rows = await db.customSelect('SELECT * FROM task WHERE id = ?',
          variables: [Variable(taskId)]).get();
      expect(rows.length, 1);
      expect(rows.first.read<String>('name'), 'Initial Task'); // Unchanged
      expect(rows.first.read<String>('status'), 'completed'); // Updated
      expect(rows.first.read<int>('priority'), 2); // Updated
    });

    test('should delete an entity with RemoveCommand', () async {
      // First create an entity
      final createCommand = TestCommand('AddTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'name': 'Task to Delete',
          'status': 'pending',
        });

      final createResult = await commandAdapter.executeCommand(createCommand);
      final taskId = createResult.data!['id'];

      // Now delete the entity
      final deleteCommand = TestCommand('RemoveTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'id': taskId,
        });

      final deleteResult = await commandAdapter.executeCommand(deleteCommand);

      // Verify the delete result
      expect(deleteResult.isSuccess, isTrue);
      expect(deleteResult.data!['rowsAffected'], 1);

      // Verify the entity was deleted from the database
      final rows = await db.customSelect('SELECT * FROM task').get();
      expect(rows.length, 0);
    });

    test('should handle command failures gracefully', () async {
      // Create a command with missing required data
      final command = TestCommand('AddTask')
        ..withParameter('concept', taskConcept)
        // Missing 'data' parameter

      // Execute the command
      final result = await commandAdapter.executeCommand(command);

      // Verify the result
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('No entity provided'));
    });

    test('should extract entity from command parameters correctly', () async {
      // Create a task entity directly
      final task = Entity<dynamic>();
      task.concept = taskConcept;
      task.setAttribute('name', 'Entity Task');
      task.setAttribute('status', 'pending');
      task.setAttribute('priority', 3);

      // Create a command with the entity as a parameter
      final command = TestCommand('AddTask')
        ..withParameter('entity', task);

      // Execute the command
      final result = await commandAdapter.executeCommand(command);

      // Verify the result
      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);

      // Verify the entity was created in the database
      final rows = await db.customSelect('SELECT * FROM task WHERE name = ?',
          variables: [Variable('Entity Task')]).get();
      expect(rows.length, 1);
      expect(rows.first.read<String>('status'), 'pending');
      expect(rows.first.read<int>('priority'), 3);
    });

    test('should handle transaction rollback on error', () async {
      // Create a valid command first
      final command1 = TestCommand('AddTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'name': 'Task 1',
          'status': 'pending',
        });

      await commandAdapter.executeCommand(command1);

      // Now create an invalid command that will fail
      final command2 = TestCommand('UpdateTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'id': 999, // Non-existent ID
          'status': 'completed',
        });

      final result = await commandAdapter.executeCommand(command2);
      expect(result.isSuccess, isFalse);

      // Verify that the first task still exists (transaction was rolled back)
      final rows = await db.customSelect('SELECT * FROM task').get();
      expect(rows.length, 1);
      expect(rows.first.read<String>('name'), 'Task 1');
    });
  });
}

/// A test command implementation for testing
class TestCommand implements app.ICommand {
  final String _name;
  final Map<String, dynamic> _parameters = {};
  
  TestCommand(this._name);
  
  @override
  String get name => _name;
  
  @override
  Map<String, dynamic> getParameters() => Map.unmodifiable(_parameters);
  
  /// Adds a parameter to this command.
  TestCommand withParameter(String name, dynamic value) {
    _parameters[name] = value;
    return this;
  }
  
  /// Adds multiple parameters to this command.
  TestCommand withParameters(Map<String, dynamic> parameters) {
    _parameters.addAll(parameters);
    return this;
  }
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true;
} 