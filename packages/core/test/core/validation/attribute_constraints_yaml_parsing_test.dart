import 'dart:io';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Attribute Constraints YAML Parsing', () {
    test('should parse numeric constraints from YAML', () {
      // Arrange
      final yamlFile = File('test/yaml_data/test_with_constraints.yaml');
      final yamlContent = yamlFile.readAsStringSync();
      final yamlMap = loadYaml(yamlContent) as YamlMap;

      // Act
      final domain = Domain('TestDomain');
      final model = fromJsonToModel('', domain, 'TestModel', yamlMap);

      // Assert
      expect(model, isNotNull);
      expect(model.concepts.length, equals(2));

      // Verify User concept and its age attribute with numeric constraints
      final userConcept = model.concepts.singleWhereCode('User');
      expect(userConcept, isNotNull);

      final ageAttribute = userConcept?.attributes.singleWhereCode('age');
      expect(ageAttribute, isNotNull);

      // The constraint should be set on the type
      final intType = ageAttribute?.type;
      expect(intType, isNotNull);

      // Test constraint validation directly through the type
      expect(intType?.validateValue(30), isTrue);
      expect(intType?.validateValue(15), isFalse);
      expect(intType?.validateValue(130), isFalse);
    });

    test('should parse string constraints from YAML', () {
      // Arrange
      final yamlFile = File('test/yaml_data/test_with_constraints.yaml');
      final yamlContent = yamlFile.readAsStringSync();
      final yamlMap = loadYaml(yamlContent) as YamlMap;

      // Act
      final domain = Domain('TestDomain');
      final model = fromJsonToModel('', domain, 'TestModel', yamlMap);

      // Assert
      expect(model, isNotNull);

      // Verify User concept and its username attribute with string constraints
      final userConcept = model.concepts.singleWhereCode('User');
      expect(userConcept, isNotNull);

      final usernameAttribute = userConcept?.attributes.singleWhereCode(
        'username',
      );
      expect(usernameAttribute, isNotNull);

      // The constraint should be set on the type
      final stringType = usernameAttribute?.type;
      expect(stringType, isNotNull);

      // Test constraint validation directly through the type
      expect(stringType?.validateValue('john_doe'), isTrue);
      expect(stringType?.validateValue('jo'), isFalse);
      expect(stringType?.validateValue('john-doe'), isFalse);
    });

    test('should parse email and URL constraints from YAML', () {
      // Arrange
      final yamlFile = File('test/yaml_data/test_with_constraints.yaml');
      final yamlContent = yamlFile.readAsStringSync();
      final yamlMap = loadYaml(yamlContent) as YamlMap;

      // Act
      final domain = Domain('TestDomain');
      final model = fromJsonToModel('', domain, 'TestModel', yamlMap);

      // Assert
      expect(model, isNotNull);

      // Verify User concept and its email attribute
      final userConcept = model.concepts.singleWhereCode('User');
      final emailAttribute = userConcept?.attributes.singleWhereCode('email');
      expect(emailAttribute, isNotNull);

      final emailType = emailAttribute?.type;
      expect(emailType, isNotNull);

      // Test email validation directly through the type
      expect(emailType?.validateValue('test@example.com'), isTrue);
      expect(emailType?.validateValue('not-an-email'), isFalse);

      // Verify Project concept and its website attribute
      final projectConcept = model.concepts.singleWhereCode('Project');
      final websiteAttribute = projectConcept?.attributes.singleWhereCode(
        'website',
      );
      expect(websiteAttribute, isNotNull);

      final uriType = websiteAttribute?.type;
      expect(uriType, isNotNull);

      // URI validation requires a Uri object, not just a string
      final validUri = Uri.parse('https://example.com');
      expect(uriType?.validateValue(validUri), isTrue);
    });
  });
}
