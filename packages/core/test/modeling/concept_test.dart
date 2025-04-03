import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Concept Management', () {
    late Domain domain;
    late Model model;
    late Concept concept;

    setUp(() {
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
      concept = Concept(model, 'TestConcept');
    });

    test('Adding a concept to model', () {
      expect(model.concepts.contains(concept), isTrue);
      expect(concept.code, equals('TestConcept'));
      expect(concept.model, equals(model));
    });

    test('Concept should not be an entry concept by default', () {
      expect(concept.entry, isFalse);
      expect(model.entryConcepts, isEmpty);
    });

    test('Setting concept as entry', () {
      // Act
      concept.entry = true;

      // Assert
      expect(concept.entry, isTrue);
      expect(model.entryConcepts, contains(concept));
      expect(model.entryConcepts.length, equals(1));
    });

    test('Adding parent-child relationship between concepts', () {
      // Arrange
      final parentConcept = Concept(model, 'ParentConcept')..entry = true;
      final childConcept = Concept(model, 'ChildConcept')..entry = true;

      // Act - Create parent relationship
      final parentRelation = Parent(childConcept, parentConcept, 'parent');

      // Assert
      expect(childConcept.parents.length, equals(1));
      expect(parentConcept.sourceParents.length, equals(1));
      expect(childConcept.parents.first, equals(parentRelation));
      expect(parentConcept.sourceParents.first, equals(parentRelation));
    });

    test('Getting entry concept by code', () {
      // Arrange
      concept.entry = true;

      // Act & Assert
      expect(model.getEntryConcept('TestConcept'), equals(concept));
      expect(
        () => model.getEntryConcept('NonExistentConcept'),
        throwsA(isA<EDNetException>()),
      );
    });
  });
}
