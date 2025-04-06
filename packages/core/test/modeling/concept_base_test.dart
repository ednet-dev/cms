import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Concept Base', () {
    late Domain domain;
    late Model model;

    setUp(() {
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
    });

    test('Concept should be initialized with default values', () {
      // Act
      final concept = Concept(model, 'TestConcept');

      // Assert
      expect(
        concept.entry,
        isFalse,
        reason: 'entry should be false by default',
      );
      expect(concept.abstract, isFalse);
      expect(concept.min, equals('0'));
      expect(concept.max, equals('N'));
      expect(concept.updateOid, isFalse);
      expect(concept.updateCode, isFalse);
      expect(concept.updateWhen, isFalse);
      expect(concept.canAdd, isTrue);
      expect(concept.remove, isTrue);
      expect(concept.description, equals('I am Entity of Concept'));
    });

    test('Concept should be added to model concepts', () {
      // Act
      final concept = Concept(model, 'TestConcept');

      // Assert
      expect(model.concepts.contains(concept), isTrue);
      expect(model.conceptCount, equals(1));
    });

    test('Concept should initialize empty collections', () {
      // Act
      final concept = Concept(model, 'TestConcept');

      // Assert
      expect(concept.attributes, isNotNull);
      expect(concept.attributes.isEmpty, isTrue);
      expect(concept.parents, isNotNull);
      expect(concept.parents.isEmpty, isTrue);
      expect(concept.children, isNotNull);
      expect(concept.children.isEmpty, isTrue);
      expect(concept.sourceParents, isNotNull);
      expect(concept.sourceParents.isEmpty, isTrue);
      expect(concept.sourceChildren, isNotNull);
      expect(concept.sourceChildren.isEmpty, isTrue);
    });
  });
}
