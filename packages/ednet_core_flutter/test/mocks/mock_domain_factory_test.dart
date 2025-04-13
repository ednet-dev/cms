import 'package:flutter_test/flutter_test.dart';
import 'mock_domain_factory.dart';

void main() {
  group('MockDomainFactory', () {
    test('createSimpleDomain creates a valid domain', () {
      // Act
      final domain = MockDomainFactory.createSimpleDomain();

      // Assert
      expect(domain, isNotNull);
      expect(domain.code, equals('TestDomain'));
      expect(domain.models, isNotNull);
      expect(domain.models.length, equals(1));

      // Check model
      final model = domain.models.toList().first;
      expect(model.code, equals('TestModel'));
      expect(model.domain, equals(domain));
      expect(model.concepts, isNotNull);
      expect(model.concepts.length, equals(1));

      // Check concept
      final concept = model.concepts.toList().first;
      expect(concept.code, equals('User'));
      expect(concept.model, equals(model));
      expect(concept.entry, isTrue);
      expect(concept.attributes, isNotNull);
      expect(concept.attributes.length, equals(3));

      // Check attributes
      final attributes = concept.attributes.toList();
      expect(attributes.length, equals(3));

      // Verify attribute names
      final attributeCodes = attributes.map((a) => a.code).toList();
      expect(attributeCodes, containsAll(['username', 'email', 'isActive']));
    });

    test('createComplexDomain returns a domain', () {
      // Act
      final domain = MockDomainFactory.createComplexDomain();

      // Assert
      expect(domain, isNotNull);
      expect(domain.code, equals('TestDomain'));
    });
  });
}
