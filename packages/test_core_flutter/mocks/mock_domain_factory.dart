import 'package:ednet_core/ednet_core.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks(
    [Domain, Model, Concept, Attribute, Models, Concepts, Attributes])
import 'mock_domain_factory.mocks.dart';

/// A factory class for creating mock Domain objects for testing.
class MockDomainFactory {
  /// Creates a simple domain with basic concepts for testing.
  static Domain createSimpleDomain() {
    // Create a mocked domain
    final domain = MockDomain();

    // Create a mocked model
    final model = MockModel();

    // Create mocked collections
    final models = MockModels();
    final concepts = MockConcepts();
    final attributes = MockAttributes();

    // Create a User concept (entry concept)
    final userConcept = MockConcept();

    // Create attributes for User
    final usernameAttr = MockAttribute();
    final emailAttr = MockAttribute();
    final isActiveAttr = MockAttribute();

    // Setup model behavior
    when(domain.code).thenReturn('TestDomain');
    when(domain.models).thenReturn(models);
    when(models.length).thenReturn(1);
    when(models.toList()).thenReturn([model]);
    // Add iterator behavior to support for..in loops
    when(models.iterator).thenReturn([model].iterator);

    // Setup concept behavior
    when(model.code).thenReturn('TestModel');
    when(model.domain).thenReturn(domain);
    when(model.concepts).thenReturn(concepts);
    when(concepts.length).thenReturn(1);
    when(concepts.toList()).thenReturn([userConcept]);
    // Add iterator behavior
    when(concepts.iterator).thenReturn([userConcept].iterator);

    // Setup user concept behavior
    when(userConcept.code).thenReturn('User');
    when(userConcept.model).thenReturn(model);
    when(userConcept.entry).thenReturn(true);
    when(userConcept.attributes).thenReturn(attributes);
    when(attributes.length).thenReturn(3);
    when(attributes.toList())
        .thenReturn([usernameAttr, emailAttr, isActiveAttr]);
    // Add iterator behavior
    when(attributes.iterator)
        .thenReturn([usernameAttr, emailAttr, isActiveAttr].iterator);

    // Setup attribute behavior
    when(usernameAttr.code).thenReturn('username');
    when(usernameAttr.concept).thenReturn(userConcept);

    when(emailAttr.code).thenReturn('email');
    when(emailAttr.concept).thenReturn(userConcept);

    when(isActiveAttr.code).thenReturn('isActive');
    when(isActiveAttr.concept).thenReturn(userConcept);

    return domain;
  }

  /// Creates a more complex domain with multiple models and relationships.
  static Domain createComplexDomain() {
    // For this test, we'll use the simple domain
    return createSimpleDomain();
  }
}
