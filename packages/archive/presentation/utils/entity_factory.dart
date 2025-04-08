import 'package:ednet_core/ednet_core.dart';

/// A utility factory for creating test entities
class TestEntityFactory {
  /// Create a test domain with Person concept
  static Domain createTestDomain() {
    // Create domain, model, and concept
    final domain = Domain('TestDomain');
    final model = Model(domain, 'PersonModel');
    domain.models.add(model);

    final personConcept = Concept(model, 'Person');
    personConcept.entry = true; // Mark as aggregate root
    model.concepts.add(personConcept);

    // Add attributes to Person concept
    _addAttribute(personConcept, 'firstName', required: true);
    _addAttribute(personConcept, 'lastName', required: true);
    _addAttribute(personConcept, 'email');
    _addAttribute(personConcept, 'age', type: 'int');
    _addAttribute(personConcept, 'notes', type: 'String', sensitive: true);

    return domain;
  }

  /// Create a test Person entity
  static Entity createTestPerson(
    Domain domain, {
    String id = 'person-1',
    String firstName = 'John',
    String lastName = 'Doe',
    String email = 'john.doe@example.com',
    int age = 32,
  }) {
    // Find Person concept in domain
    Concept? personConcept;
    for (final model in domain.models) {
      for (final concept in model.concepts) {
        if (concept.code == 'Person') {
          personConcept = concept;
          break;
        }
      }
      if (personConcept != null) break;
    }

    if (personConcept == null) {
      throw Exception('Person concept not found in test domain');
    }

    // Create entity
    final entity = personConcept.newEntity();
    entity.code = id;

    // Set attributes
    entity.setAttribute('firstName', firstName);
    entity.setAttribute('lastName', lastName);
    entity.setAttribute('email', email);
    entity.setAttribute('age', age);

    return entity;
  }

  /// Add multiple test Person entities
  static List<Entity> createTestPersons(Domain domain, int count) {
    final result = <Entity>[];

    final firstNames = ['John', 'Jane', 'Robert', 'Sarah', 'Michael', 'Emily'];
    final lastNames = ['Doe', 'Smith', 'Johnson', 'Williams', 'Jones', 'Brown'];

    for (var i = 0; i < count; i++) {
      final firstName = firstNames[i % firstNames.length];
      final lastName = lastNames[i % lastNames.length];
      final email =
          '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com';

      result.add(createTestPerson(
        domain,
        id: 'person-${i + 1}',
        firstName: firstName,
        lastName: lastName,
        email: email,
        age: 25 + i,
      ));
    }

    return result;
  }

  /// Helper to add attribute to concept
  static void _addAttribute(
    Concept concept,
    String name, {
    bool required = false,
    bool identifier = false,
    bool sensitive = false,
    String type = 'String',
  }) {
    final attribute = Attribute(concept, name);

    // Set properties
    attribute.required = required;
    attribute.identifier = identifier;
    attribute.sensitive = sensitive;

    // Create an appropriate type for the attribute based on string name
    // Note: Actual implementation would set correct attribute types
    // This is a temporary solution until we have proper type initialization
    attribute.type = null; // Reset any existing type

    // For now, just record the type name
    // In a real implementation, we would set the actual AttributeType
    attribute.code = name;

    // Add to concept
    concept.attributes.add(attribute);
  }
}
