import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

// Mock entity for testing
class TestEntity extends Entity {
  final String name;
  final int age;
  final String status;
  
  TestEntity({
    required this.name,
    required this.age,
    required this.status,
  });
  
  @override
  dynamic getAttribute(String name) {
    switch (name) {
      case 'name':
        return this.name;
      case 'age':
        return this.age;
      case 'status':
        return this.status;
      default:
        return null;
    }
  }
}

// Mock concept for testing
class TestConcept extends Concept {
  TestConcept() : super(code: 'test', name: 'Test');
}

void main() {
  late InMemoryQueryableRepository<TestEntity> repository;
  late TestEntity entity1;
  late TestEntity entity2;
  late TestEntity entity3;
  late TestConcept concept;
  late QueryDispatcher queryDispatcher;
  
  setUp(() {
    concept = TestConcept();
    queryDispatcher = QueryDispatcher();
    repository = InMemoryQueryableRepository(
      concept: concept,
      queryDispatcher: queryDispatcher,
    );
    entity1 = TestEntity(name: 'John', age: 30, status: 'active');
    entity2 = TestEntity(name: 'Jane', age: 25, status: 'inactive');
    entity3 = TestEntity(name: 'Bob', age: 40, status: 'active');
  });
  
  test('should execute concept query', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final result = await repository.executeConceptQuery('FindAll');
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(3));
  });
  
  test('should execute concept query with parameters', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final result = await repository.executeConceptQuery(
      'FindAll',
      {'status': 'active'},
    );
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(2));
    expect(entityResult.entities, contains(entity1));
    expect(entityResult.entities, contains(entity3));
  });
  
  test('should handle pagination in concept query', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final result = await repository.executeConceptQuery(
      'FindAll',
      {
        'page': 1,
        'pageSize': 2,
        'sortBy': 'name',
        'sortDirection': 'asc',
      },
    );
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(2));
    expect(entityResult.entities[0], equals(entity3));
    expect(entityResult.entities[1], equals(entity2));
    expect(entityResult.metadata['totalCount'], equals(3));
  });
  
  test('should execute complex concept query', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final result = await repository.executeConceptQuery(
      'FindAll',
      {
        'status': 'active',
        'age': 30,
        'sortBy': 'name',
        'sortDirection': 'desc',
      },
    );
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(1));
    expect(entityResult.entities[0], equals(entity1));
  });
  
  test('should execute query without dispatcher', () async {
    repository = InMemoryQueryableRepository(
      concept: concept,
      queryDispatcher: null,
    );
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final result = await repository.executeConceptQuery('FindAll');
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(3));
  });
} 