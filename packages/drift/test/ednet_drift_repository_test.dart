import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_drift/cqrs_drift.dart';
import 'package:ednet_drift/ednet_drift_repository.dart';
import 'package:test/test.dart';
import 'dart:io';

import 'utils/test_domain.dart';

void main() {
  late Domain domain;
  late EDNetDriftRepository repository;
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('ednet_test_');
  });

  setUp(() {
    // Create a fresh domain model for each test
    domain = createTestDomain();
    
    // Create a repository with an in-memory database
    repository = EDNetDriftRepository(
      domain: domain,
      sqlitePath: ':memory:',
    );
  });

  tearDown(() async {
    await repository.database.close();
  });

  tearDownAll(() {
    tempDir.deleteSync(recursive: true);
  });

  group('EDNetDriftRepository', () {
    test('should initialize database correctly', () async {
      // Open the database and verify it's working
      await repository.open();
      
      // Verify the domain concepts were created as tables
      final tables = await repository.database.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      ).get();
      
      // Should have a 'task' table from our test domain
      expect(tables.map((t) => t.read<String>('name')), contains('task'));
    });
    
    test('should save and retrieve dynamic entities', () async {
      await repository.open();
      final taskConcept = domain.findConcept('Task')!;
      
      // Create a task entity
      final task = Entity<dynamic>();
      task.concept = taskConcept;
      task.setAttribute('name', 'Test Task');
      task.setAttribute('status', 'pending');
      task.setAttribute('priority', 1);
      
      // Save the entity
      await repository.saveDynamicEntity(task);
      
      // Retrieve all tasks
      final tasks = await repository.getAllDynamicEntities('Task');
      
      // Verify the task was saved correctly
      expect(tasks.length, 1);
      expect(tasks.first.getAttribute('name'), 'Test Task');
      expect(tasks.first.getAttribute('status'), 'pending');
      expect(tasks.first.getAttribute('priority'), 1);
    });
  });
  
  group('EDNetDriftCqrsRepository', () {
    late EDNetDriftCqrsRepository cqrsRepository;
    
    setUp(() {
      // Create a CQRS repository with an in-memory database
      cqrsRepository = EDNetDriftCqrsRepository(
        domain: domain,
        sqlitePath: ':memory:',
      );
    });
    
    tearDown(() async {
      await cqrsRepository.database.close();
    });
    
    test('should execute commands successfully', () async {
      await cqrsRepository.open();
      final taskConcept = domain.findConcept('Task')!;
      
      // Create a command to add a task
      final command = Command('CreateTask')
        ..withParameter('concept', taskConcept)
        ..withParameter('data', {
          'name': 'CQRS Task',
          'status': 'pending',
          'priority': 2,
        });
      
      // Execute the command
      final result = await cqrsRepository.executeCommand(command);
      
      // Verify the result
      expect(result.isSuccess, isTrue);
      expect(result.data?['id'], isNotNull);
      
      // Verify the task was created
      final query = ConceptQuery('FindAll', taskConcept);
      final queryResult = await cqrsRepository.executeQuery(query);
      
      expect(queryResult.isSuccess, isTrue);
      expect(queryResult.data?.length, 1);
      expect(queryResult.data?.first.getAttribute('name'), 'CQRS Task');
    });
    
    test('should execute queries with criteria', () async {
      await cqrsRepository.open();
      final taskConcept = domain.findConcept('Task')!;
      
      // Create several tasks
      for (var i = 0; i < 3; i++) {
        final command = Command('CreateTask')
          ..withParameter('concept', taskConcept)
          ..withParameter('data', {
            'name': 'Task $i',
            'status': i < 2 ? 'pending' : 'completed',
            'priority': i + 1,
          });
        await cqrsRepository.executeCommand(command);
      }
      
      // Query for pending tasks
      final query = ConceptQuery('FindByCriteria', taskConcept)
        ..withParameter('status', 'pending');
      
      final result = await cqrsRepository.executeQuery(query);
      
      // Verify we get only the pending tasks
      expect(result.isSuccess, isTrue);
      expect(result.data?.length, 2);
      expect(
        result.data?.map((e) => e.getAttribute('name')).toList(),
        containsAll(['Task 0', 'Task 1']),
      );
    });
    
    test('should execute REST API queries', () async {
      await cqrsRepository.open();
      final taskConcept = domain.findConcept('Task')!;
      
      // Create several tasks
      for (var i = 0; i < 3; i++) {
        final command = Command('CreateTask')
          ..withParameter('concept', taskConcept)
          ..withParameter('data', {
            'name': 'Task $i',
            'status': i < 2 ? 'pending' : 'completed',
            'priority': i + 1,
          });
        await cqrsRepository.executeCommand(command);
      }
      
      // Execute a REST API query
      final result = await cqrsRepository.executeRestQuery(
        'Task',
        {
          'filter': {'status': 'pending'},
          'sort': 'priority',
        },
      );
      
      // Verify the result
      expect(result.isSuccess, isTrue);
      expect(result.data?.length, 2);
      expect(result.data?.first.getAttribute('priority'), 1);
      expect(result.data?.last.getAttribute('priority'), 2);
    });
  });
}

class Command implements app.ICommand {
  final String _name;
  final Map<String, dynamic> _parameters = {};
  
  Command(this._name);
  
  @override
  String get name => _name;
  
  @override
  Map<String, dynamic> getParameters() => Map.unmodifiable(_parameters);
  
  Command withParameter(String name, dynamic value) {
    _parameters[name] = value;
    return this;
  }
  
  Command withParameters(Map<String, dynamic> parameters) {
    _parameters.addAll(parameters);
    return this;
  }
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true;
}
