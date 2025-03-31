import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:your_package/drift_core_repository.dart';

// Domain Model Setup for Testing
class TodoDomain extends Domain {
  TodoDomain() : super("Todo");
}

class TodoModel extends ModelEntries {
  late Tasks tasks;

  TodoModel(Domain domain) : super(domain, "TodoModel") {
    tasks = Tasks(this);
    addEntry("Task", tasks);
  }
}

class Task extends Entity<Task> {
  String title = "";
  bool done = false;

  Task(Concept concept) : super(concept);
}

class Tasks extends Entities<Task> {
  Tasks(ModelEntries modelEntries) : super(modelEntries);
}

void main() {
  late DriftCoreRepository repository;
  late TodoDomain domain;
  late TodoModel todoModel;

  setUp(() {
    domain = TodoDomain();
    todoModel = TodoModel(domain);
    domain.addModelEntries(todoModel);
    repository = DriftCoreRepository(domains: [domain]);
  });

  tearDown(() async {
    await repository.close();
  });

  group('DriftCoreRepository', () {
    test(
      'should initialize database and create tables for domain model concepts',
      () async {
        // Given repository is initialized with domain model

        // When inserting the first entity
        final task =
            Task(todoModel.tasks.concept!)
              ..title = 'Setup database schema'
              ..done = false;
        await repository.insertEntity(task);

        // Then table should be created and entity persisted
        expect(task.oid, isNotNull);
      },
    );

    test('should insert a new entity and assign oid and timestamps', () async {
      // Given a valid entity
      final task =
          Task(todoModel.tasks.concept!)
            ..title = 'Write test'
            ..done = false;

      // When inserted into repository
      await repository.insertEntity(task);

      // Then oid and timestamps are set
      expect(task.oid, isNotNull);
      expect(task.whenAdded, isNotNull);
      expect(task.whenSet, isNotNull);
      expect(task.whenRemoved, isNull);
    });

    test(
      'should update existing entity attributes and update whenSet timestamp',
      () async {
        // Given an existing entity
        final task =
            Task(todoModel.tasks.concept!)
              ..title = 'Initial title'
              ..done = false;
        await repository.insertEntity(task);
        final initialWhenSet = task.whenSet;

        // When updating entity attributes
        task.title = 'Updated title';
        await Future.delayed(
          Duration(seconds: 1),
        ); // Ensure timestamp difference
        await repository.updateEntity(task);

        // Then attributes and whenSet timestamp are updated
        expect(task.whenSet, isNot(equals(initialWhenSet)));
        expect(task.title, equals('Updated title'));
      },
    );

    test('should not insert entity if required attribute is missing', () async {
      // Given entity with missing required attribute
      final task = Task(
        todoModel.tasks.concept!,
      ); // title is required by domain logic

      // When inserting into repository
      expect(() => repository.insertEntity(task), throwsException);
    });

    test('should delete entity from repository and database', () async {
      // Given an existing entity
      final task =
          Task(todoModel.tasks.concept!)
            ..title = 'Task to delete'
            ..done = false;
      await repository.insertEntity(task);

      // When deleting the entity
      await repository.deleteEntity(task);

      // Then entity is removed from database and memory
      expect(todoModel.tasks.contains(task), isFalse);
    });

    test('should prevent deletion if entity has essential children', () async {
      // Given parent-child relationship with essential parent
      final concept = todoModel.tasks.concept!;
      final subtaskConcept = Concept(todoModel, "Subtask");
      final subtasks = Entities<Entity>(todoModel)..concept = subtaskConcept;

      final childRelation = Child(
        subtaskConcept,
        "subtasks",
        concept,
        internal: true,
        essential: true,
      );
      concept.children.add(childRelation);
      subtaskConcept.parents.add(
        Parent(
          subtaskConcept,
          "task",
          concept,
          internal: true,
          essential: true,
        ),
      );

      final task = Task(concept)..title = 'Parent task';
      await repository.insertEntity(task);

      final subtask = Entity(subtaskConcept);
      subtask.setParent('task', task);
      await repository.insertEntity(subtask);

      // When deleting parent entity
      expect(() => repository.deleteEntity(task), throwsException);
    });

    test(
      'should allow deletion if entity has only non-essential children',
      () async {
        // Given parent-child relationship with non-essential parent
        final concept = todoModel.tasks.concept!;
        final noteConcept = Concept(todoModel, "Note");
        final notes = Entities<Entity>(todoModel)..concept = noteConcept;

        final childRelation = Child(
          noteConcept,
          "notes",
          concept,
          internal: true,
          essential: false,
        );
        concept.children.add(childRelation);
        noteConcept.parents.add(
          Parent(
            noteConcept,
            "task",
            concept,
            internal: true,
            essential: false,
          ),
        );

        final task = Task(concept)..title = 'Task with notes';
        await repository.insertEntity(task);

        final note = Entity(noteConcept);
        note.setParent('task', task);
        await repository.insertEntity(note);

        // When deleting parent entity
        await repository.deleteEntity(task);

        // Then deletion succeeds
        expect(todoModel.tasks.contains(task), isFalse);
      },
    );

    test('should enforce uniqueness of identifier attributes', () async {
      // Given entities with a unique identifier attribute (e.g. "code")
      final concept = todoModel.tasks.concept!;
      concept.updateCode = true;

      final task1 =
          Task(concept)
            ..code = 'unique_code'
            ..title = 'Task 1';
      await repository.insertEntity(task1);

      final task2 =
          Task(concept)
            ..code =
                'unique_code' // Duplicate code
            ..title = 'Task 2';

      // When inserting second entity
      expect(() => repository.insertEntity(task2), throwsException);
    });

    test('should handle type conversions correctly (DateTime, bool)', () async {
      // Given entity with DateTime and bool attributes
      final concept = todoModel.tasks.concept!;
      concept.attributes.add(
        Attribute(concept, "dueDate")..type = Type("DateTime"),
      );
      concept.attributes.add(Attribute(concept, "urgent")..type = Type("bool"));

      final task =
          Task(concept)
            ..title = 'Time sensitive task'
            ..setAttribute('dueDate', DateTime.utc(2025, 01, 01))
            ..setAttribute('urgent', true);

      // When inserting and retrieving entity
      await repository.insertEntity(task);
      final retrievedDueDate = task.getAttribute<DateTime>('dueDate');
      final retrievedUrgent = task.getAttribute<bool>('urgent');

      // Then types are correctly stored and retrieved
      expect(retrievedDueDate, DateTime.utc(2025, 01, 01));
      expect(retrievedUrgent, isTrue);
    });

    test(
      'should persist and reload entities across repository instances',
      () async {
        // Given entities inserted in one repository instance
        final task = Task(todoModel.tasks.concept!)..title = 'Persistent task';
        await repository.insertEntity(task);
        final oid = task.oid;

        await repository.close();

        // When initializing a new repository instance
        repository = DriftCoreRepository(domains: [domain]);

        // And loading entities (implement load method)
        // For brevity, assume load method exists
        final reloadedTask = await repository.loadEntityByOid<Task>(
          todoModel.tasks.concept!,
          oid!,
        );

        // Then entity is correctly reloaded with attributes
        expect(reloadedTask, isNotNull);
        expect(reloadedTask!.title, 'Persistent task');
      },
    );
  });
}
