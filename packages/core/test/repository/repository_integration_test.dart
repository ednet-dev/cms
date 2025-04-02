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
  
  test('should handle complex filtering and sorting', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final criteria = FilterCriteria<TestEntity>();
    criteria.addCriterion(Criterion('status', 'active'));
    criteria.orderBy('age', ascending: false);
    
    final results = await repository.findByCriteria(criteria);
    expect(results.length, equals(2));
    expect(results[0], equals(entity3));
    expect(results[1], equals(entity1));
  });
  
  test('should handle pagination with sorting', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    await repository.save(entity3);
    
    final criteria = FilterCriteria<TestEntity>();
    criteria.orderBy('name', ascending: true);
    
    // First page
    var results = await repository.findByCriteria(criteria, take: 2);
    expect(results.length, equals(2));
    expect(results[0], equals(entity3));
    expect(results[1], equals(entity2));
    
    // Second page
    results = await repository.findByCriteria(criteria, skip: 2, take: 1);
    expect(results.length, equals(1));
    expect(results[0], equals(entity1));
  });
  
  test('should handle updates and queries', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    
    // Update entity1
    final updated = TestEntity(
      name: 'John Updated',
      age: 31,
      status: 'active',
    );
    await repository.save(updated);
    
    // Query should return updated entity
    final criteria = FilterCriteria<TestEntity>();
    criteria.addCriterion(Criterion('name', 'John Updated'));
    final results = await repository.findByCriteria(criteria);
    expect(results.length, equals(1));
    expect(results[0], equals(updated));
  });
  
  test('should handle concurrent operations', () async {
    await repository.save(entity1);
    await repository.save(entity2);
    
    // Concurrent save and delete
    await Future.wait([
      repository.save(entity3),
      repository.delete(entity2),
    ]);
    
    final all = await repository.findAll();
    expect(all.length, equals(2));
    expect(all, contains(entity1));
    expect(all, contains(entity3));
  });
  
  test('should handle concept queries with complex parameters', () async {
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
        'page': 1,
        'pageSize': 10,
      },
    );
    
    expect(result, isA<EntityQueryResult<TestEntity>>());
    final entityResult = result as EntityQueryResult<TestEntity>;
    expect(entityResult.entities.length, equals(1));
    expect(entityResult.entities[0], equals(entity1));
    expect(entityResult.metadata['totalCount'], equals(1));
  });
} 