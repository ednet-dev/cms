import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/src/shell/interpreter/domain_metadata_interpreter.dart';

import '../test_domain_factory.dart';

void main() {
  group('DomainMetadataInterpreter', () {
    late DomainMetadataInterpreter interpreter;
    late Domain testDomain;

    setUp(() {
      interpreter = DomainMetadataInterpreter();
      testDomain = TestDomainFactory.createSimpleDomain();
    });

    test('should load domain metadata correctly', () {
      // Act
      interpreter.loadDomainModel(testDomain);

      // Assert
      expect(interpreter.hasLoadedDomain(), true);
      expect(interpreter.getDomainCode(), equals(testDomain.code));
    });

    test('should register all concepts from domain', () {
      // Arrange
      final expectedConceptCount = testDomain.models
          .fold<int>(0, (count, model) => count + model.concepts.length);

      // Act
      interpreter.loadDomainModel(testDomain);

      // Assert
      expect(interpreter.getConceptCount(), equals(expectedConceptCount));
    });

    test('should retrieve concept by code', () {
      // Arrange
      final targetConcept = testDomain.models.first.concepts.first;
      final conceptCode = targetConcept.code;

      // Act
      interpreter.loadDomainModel(testDomain);
      final retrievedConcept = interpreter.getConceptByCode(conceptCode);

      // Assert
      expect(retrievedConcept, isNotNull);
      expect(retrievedConcept?.code, equals(conceptCode));
    });

    test('should extract attributes from concept', () {
      // Arrange
      final targetConcept = testDomain.models.first.concepts.first;

      // Act
      interpreter.loadDomainModel(testDomain);
      final attributes = interpreter.getConceptAttributes(targetConcept.code);

      // Assert
      expect(attributes, isNotNull);
      expect(attributes.length, equals(targetConcept.attributes.length));
    });

    test('should detect entry concepts', () {
      // Arrange
      final entryConcepts = testDomain.models
          .expand((model) => model.concepts)
          .where((concept) => concept.entry)
          .toList();

      // Act
      interpreter.loadDomainModel(testDomain);
      final detectedEntryConcepts = interpreter.getEntryConcepts();

      // Assert
      expect(detectedEntryConcepts.length, equals(entryConcepts.length));
      for (final concept in entryConcepts) {
        expect(
            detectedEntryConcepts.any((c) => c.code == concept.code), isTrue);
      }
    });

    test('should map parent-child relationships', () {
      // This test won't work with the simple domain as it has no relationships
      // For relationship testing, we need the complex domain
      // Arrange
      final complexDomain = TestDomainFactory.createComplexDomain();
      interpreter.loadDomainModel(complexDomain);

      // Find concepts with parent references for testing
      final concepts =
          complexDomain.models.expand((model) => model.concepts).toList();

      // Find a concept with parents
      final conceptWithParents = concepts.firstWhere(
          (concept) => concept.parents.isNotEmpty,
          orElse: () => concepts.first);

      // Act
      final parentConcepts =
          interpreter.getParentConcepts(conceptWithParents.code);

      // Assert
      expect(parentConcepts.length, equals(conceptWithParents.parents.length));
    });
  });
}
