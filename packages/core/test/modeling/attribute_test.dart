import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Attribute Testing', () {
    late Domain domain;
    late Model model;
    late Concept concept;

    setUp(() {
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
      concept = Concept(model, 'TestConcept');
    });

    test('Attribute should be initialized with default values', () {
      final attribute = Attribute(concept, 'testAttribute');

      expect(attribute.code, equals('testAttribute'));
      expect(attribute.type?.code, equals('String')); // Default type
      expect(attribute.guid, isFalse);
      expect(attribute.init, isNull);
      expect(attribute.increment, isNull);
      expect(attribute.sequence, isNull);
      expect(attribute.derive, isFalse);
      expect(attribute.length, equals(64)); // Default String length
      expect(attribute.required, isFalse);
      expect(attribute.identifier, isFalse);
      expect(attribute.essential, isFalse);
      expect(attribute.sensitive, isFalse);
    });

    test('Attribute should be added to concept attributes', () {
      final attribute = Attribute(concept, 'testAttribute');

      expect(concept.attributes.contains(attribute), isTrue);
      expect(concept.attributes.length, equals(1));
    });

    test('Attribute type should be properly set', () {
      final attribute = Attribute(concept, 'testAttribute');
      final intType = domain.getType('int');

      attribute.type = intType;

      expect(attribute.type, equals(intType));
      expect(attribute.length, equals(8)); // int type length
    });

    test('Required attribute should be properly handled', () {
      final attribute = Attribute(concept, 'testAttribute');

      attribute.required = true;

      expect(attribute.required, isTrue);
      expect(attribute.essential, isTrue); // Required attributes are essential
    });

    test('Identifier attribute should be properly handled', () {
      final attribute = Attribute(concept, 'testAttribute');

      attribute.identifier = true;

      expect(attribute.identifier, isTrue);
      expect(concept.hasId, isTrue);
      expect(concept.hasAttributeId, isTrue);
    });

    test('Derived attribute should not be updatable', () {
      final attribute = Attribute(concept, 'testAttribute');

      attribute.derive = true;

      expect(attribute.derive, isTrue);
      expect(attribute.update, isFalse);
    });

    test('Attribute initialization with init value', () {
      final attribute = Attribute(concept, 'testAttribute');

      attribute.init = 'default value';

      expect(attribute.init, equals('default value'));
    });

    test('Attribute with increment should be properly handled', () {
      final attribute = Attribute(concept, 'testAttribute');

      attribute.increment = 1;

      expect(attribute.increment, equals(1));
      expect(concept.incrementAttributes.contains(attribute), isTrue);
    });
  });
}
