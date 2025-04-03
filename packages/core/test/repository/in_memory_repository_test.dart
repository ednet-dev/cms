// import 'package:test/test.dart';
// import 'package:ednet_core/ednet_core.dart';
//
// // Mock entity for testing
// class TestEntity extends Entity {
//   final String name;
//   final int age;
//   final String status;
//
//   TestEntity({
//     required this.name,
//     required this.age,
//     required this.status,
//   });
//
//   @override
//   dynamic getAttribute(String name) {
//     switch (name) {
//       case 'name':
//         return this.name;
//       case 'age':
//         return this.age;
//       case 'status':
//         return this.status;
//       default:
//         return null;
//     }
//   }
// }
//
// // Mock concept for testing
// class TestConcept extends Concept {
//   TestConcept() : super(
//     code: 'test',
//     name: 'Test',
//     description: 'Test concept',
//   );
// }
//
// void main() {
//   group('InMemoryRepository', () {
//     late InMemoryRepository<TestEntity> repository;
//     late TestEntity entity1;
//     late TestEntity entity2;
//     late TestEntity entity3;
//
//     setUp(() {
//       repository = InMemoryRepository<TestEntity>();
//       entity1 = TestEntity(name: 'John', age: 30, status: 'active');
//       entity2 = TestEntity(name: 'Jane', age: 25, status: 'inactive');
//       entity3 = TestEntity(name: 'Bob', age: 40, status: 'active');
//     });
//
//     test('should find entity by id', () async {
//       await repository.save(entity1);
//       final found = await repository.findById(entity1.id);
//       expect(found, equals(entity1));
//     });
//
//     test('should return null for nonexistent entity', () async {
//       final found = await repository.findById('nonexistent');
//       expect(found, isNull);
//     });
//
//     test('should find all entities', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final all = await repository.findAll();
//       expect(all.length, equals(3));
//       expect(all, contains(entity1));
//       expect(all, contains(entity2));
//       expect(all, contains(entity3));
//     });
//
//     test('should filter by criteria', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final criteria = FilterCriteria<TestEntity>();
//       criteria.addCriterion(Criterion('status', 'active'));
//
//       final results = await repository.findByCriteria(criteria);
//       expect(results.length, equals(2));
//       expect(results, contains(entity1));
//       expect(results, contains(entity3));
//     });
//
//     test('should sort by attribute', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final criteria = FilterCriteria<TestEntity>();
//       criteria.orderBy('age', ascending: true);
//
//       final results = await repository.findByCriteria(criteria);
//       expect(results.length, equals(3));
//       expect(results[0], equals(entity2));
//       expect(results[1], equals(entity1));
//       expect(results[2], equals(entity3));
//     });
//
//     test('should handle pagination', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final criteria = FilterCriteria<TestEntity>();
//       criteria.orderBy('name', ascending: true);
//
//       // First page
//       var results = await repository.findByCriteria(criteria, take: 2);
//       expect(results.length, equals(2));
//       expect(results[0], equals(entity3));
//       expect(results[1], equals(entity2));
//
//       // Second page
//       results = await repository.findByCriteria(criteria, skip: 2, take: 1);
//       expect(results.length, equals(1));
//       expect(results[0], equals(entity1));
//     });
//
//     test('should count by criteria', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final criteria = FilterCriteria<TestEntity>();
//       criteria.addCriterion(Criterion('status', 'active'));
//
//       final count = await repository.countByCriteria(criteria);
//       expect(count, equals(2));
//     });
//
//     test('should save entity', () async {
//       await repository.save(entity1);
//       final found = await repository.findById(entity1.id);
//       expect(found, equals(entity1));
//     });
//
//     test('should update entity', () async {
//       await repository.save(entity1);
//       final updated = TestEntity(name: 'John Updated', age: 31, status: 'active');
//       await repository.save(updated);
//       final found = await repository.findById(entity1.id);
//       expect(found, equals(updated));
//     });
//
//     test('should delete entity', () async {
//       await repository.save(entity1);
//       await repository.delete(entity1);
//       final found = await repository.findById(entity1.id);
//       expect(found, isNull);
//     });
//
//     test('should get all entities in memory', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       final entities = repository.getEntities();
//       expect(entities.length, equals(3));
//       expect(entities, contains(entity1));
//       expect(entities, contains(entity2));
//       expect(entities, contains(entity3));
//     });
//
//     test('should clear all entities', () async {
//       await repository.save(entity1);
//       await repository.save(entity2);
//       await repository.save(entity3);
//
//       repository.clear();
//       final all = await repository.findAll();
//       expect(all, isEmpty);
//     });
//   });
// }