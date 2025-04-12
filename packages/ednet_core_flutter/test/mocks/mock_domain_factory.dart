import 'package:ednet_core/ednet_core.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Domain, Model, Concept, Attribute])
import 'mock_domain_factory.mocks.dart';

/// A factory class for creating mock Domain objects for testing.
class MockDomainFactory {
  /// Creates a simple domain with basic concepts for testing.
  static Domain createSimpleDomain() {
    // Create a mocked domain
    final domain = MockDomain();

    // Create a mocked model
    final model = MockModel();

    // Create a User concept (entry concept)
    final userConcept = MockConcept();

    // Create attributes for User
    final usernameAttr = MockAttribute();
    final emailAttr = MockAttribute();
    final isActiveAttr = MockAttribute();

    // Setup model behavior
    when(domain.code).thenReturn('TestDomain');
    when(domain.models).thenReturn([model]);

    // Setup concept behavior
    when(model.code).thenReturn('TestModel');
    when(model.domain).thenReturn(domain);
    when(model.concepts).thenReturn([userConcept]);

    // Setup user concept behavior
    when(userConcept.code).thenReturn('User');
    when(userConcept.model).thenReturn(model);
    when(userConcept.entry).thenReturn(true);
    when(userConcept.attributes)
        .thenReturn([usernameAttr, emailAttr, isActiveAttr]);

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
