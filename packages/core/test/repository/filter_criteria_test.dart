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

void main() {
  group('FilterCriteria', () {
    test('should be empty when created', () {
      final criteria = FilterCriteria<TestEntity>();
      expect(criteria.isEmpty, isTrue);
      expect(criteria.length, equals(0));
    });
    
    test('should add criterion correctly', () {
      final criteria = FilterCriteria<TestEntity>();
      criteria.addCriterion(Criterion('status', 'active'));
      expect(criteria.isNotEmpty, isTrue);
      expect(criteria.length, equals(1));
      expect(criteria.criteria.first.attribute, equals('status'));
      expect(criteria.criteria.first.value, equals('active'));
    });
    
    test('should set sort order correctly', () {
      final criteria = FilterCriteria<TestEntity>();
      criteria.orderBy('name', ascending: false);
      expect(criteria.sortAttribute, equals('name'));
      expect(criteria.sortAscending, isFalse);
    });
    
    test('should create equals criterion', () {
      final criterion = Criterion.equals('status', 'active');
      expect(criterion.attribute, equals('status'));
      expect(criterion.value, equals('active'));
      expect(criterion.operator, equals(ComparisonOperator.equals));
    });
    
    test('should create not equals criterion', () {
      final criterion = Criterion.notEquals('status', 'inactive');
      expect(criterion.attribute, equals('status'));
      expect(criterion.value, equals('inactive'));
      expect(criterion.operator, equals(ComparisonOperator.notEquals));
    });
    
    test('should create greater than criterion', () {
      final criterion = Criterion.greaterThan('age', 30);
      expect(criterion.attribute, equals('age'));
      expect(criterion.value, equals(30));
      expect(criterion.operator, equals(ComparisonOperator.greaterThan));
    });
    
    test('should create less than criterion', () {
      final criterion = Criterion.lessThan('age', 30);
      expect(criterion.attribute, equals('age'));
      expect(criterion.value, equals(30));
      expect(criterion.operator, equals(ComparisonOperator.lessThan));
    });
    
    test('should create contains criterion', () {
      final criterion = Criterion.contains('name', 'John');
      expect(criterion.attribute, equals('name'));
      expect(criterion.value, equals('John'));
      expect(criterion.operator, equals(ComparisonOperator.contains));
    });
    
    test('should create in criterion', () {
      final values = ['active', 'inactive'];
      final criterion = Criterion.in_('status', values);
      expect(criterion.attribute, equals('status'));
      expect(criterion.value, equals(values));
      expect(criterion.operator, equals(ComparisonOperator.in_));
    });
  });
} 