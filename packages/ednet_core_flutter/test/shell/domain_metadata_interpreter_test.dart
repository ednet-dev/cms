import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/src/shell/interpreter/domain_metadata_interpreter.dart';

import '../mocks/mock_domain_factory.dart';

void main() {
  group('DomainMetadataInterpreter', () {
    late DomainMetadataInterpreter interpreter;
    late Domain mockDomain;

    setUp(() {
      interpreter = DomainMetadataInterpreter();
      mockDomain = MockDomainFactory.createSimpleDomain();
    });

    test('should load domain metadata correctly', () {
      // Act
      interpreter.loadDomainModel(mockDomain);

      // Assert
      expect(interpreter.hasLoadedDomain(), true);
      expect(interpreter.getDomainCode(), equals(mockDomain.code));
    });

    test('should register all concepts from domain', () {
      // Arrange
      final expectedConceptCount = mockDomain.models
          .fold<int>(0, (count, model) => count + model.concepts.length);

      // Act
      interpreter.loadDomainModel(mockDomain);

      // Assert
      expect(interpreter.getConceptCount(), equals(expectedConceptCount));
    });

    test('should retrieve concept by code', () {
      // Arrange
      final targetConcept = mockDomain.models.first.concepts.first;
      final conceptCode = targetConcept.code;

      // Act
      interpreter.loadDomainModel(mockDomain);
      final retrievedConcept = interpreter.getConceptByCode(conceptCode);

      // Assert
      expect(retrievedConcept, isNotNull);
      expect(retrievedConcept?.code, equals(conceptCode));
    });

    test('should extract attributes from concept', () {
      // Arrange
      final targetConcept = mockDomain.models.first.concepts.first;

      // Act
      interpreter.loadDomainModel(mockDomain);
      final attributes = interpreter.getConceptAttributes(targetConcept.code);

      // Assert
      expect(attributes, isNotNull);
      expect(attributes.length, equals(targetConcept.attributes.length));
    });

    test('should detect entry concepts', () {
      // Arrange
      final entryConcepts = mockDomain.models
          .expand((model) => model.concepts)
          .where((concept) => concept.entry)
          .toList();

      // Act
      interpreter.loadDomainModel(mockDomain);
      final detectedEntryConcepts = interpreter.getEntryConcepts();

      // Assert
      expect(detectedEntryConcepts.length, equals(entryConcepts.length));
      for (final concept in entryConcepts) {
        expect(
            detectedEntryConcepts.any((c) => c.code == concept.code), isTrue);
      }
    });

    test('should map parent-child relationships', () {
      // Arrange
      // Find a concept with parent references for testing
      final childConcept = mockDomain.models
          .expand((model) => model.concepts)
          .firstWhere((concept) => concept.parents.isNotEmpty,
              orElse: () => mockDomain.models.first.concepts.first);

      // Act
      interpreter.loadDomainModel(mockDomain);
      final parentConcepts = interpreter.getParentConcepts(childConcept.code);

      // Assert
      expect(parentConcepts.length, equals(childConcept.parents.length));
    });
  });
}
