import 'package:ednet_core/ednet_core.dart';

/// A factory class for creating real Domain objects for testing.
/// This avoids using mockito and uses actual domain objects instead.
class TestDomainFactory {
  /// Creates a simple domain with basic concepts for testing.
  static Domain createSimpleDomain() {
    // Create a real domain
    final domain = Domain('TestDomain');

    // Create a real model
    final model = Model(domain, 'TestModel');

    // Create a User concept (entry concept)
    final userConcept = Concept(model, 'User');
    userConcept.entry = true;

    // Create attributes for User
    final usernameAttr = Attribute(userConcept, 'username');
    final emailAttr = Attribute(userConcept, 'email');
    final isActiveAttr = Attribute(userConcept, 'isActive');

    return domain;
  }

  /// Creates a more complex domain with multiple models and relationships.
  static Domain createComplexDomain() {
    // Create a real domain
    final domain = Domain('TestDomain');

    // Create real models
    final userModel = Model(domain, 'UserModel');
    final projectModel = Model(domain, 'ProjectModel');

    // Create a User concept (entry concept)
    final userConcept = Concept(userModel, 'User');
    userConcept.entry = true;

    // Create attributes for User
    final usernameAttr = Attribute(userConcept, 'username');
    final emailAttr = Attribute(userConcept, 'email');

    // Create a Project concept (entry concept)
    final projectConcept = Concept(projectModel, 'Project');
    projectConcept.entry = true;

    // Create attributes for Project
    final nameAttr = Attribute(projectConcept, 'name');
    final descriptionAttr = Attribute(projectConcept, 'description');

    // Create relationships between User and Project
    final userToProjectParent = Parent(userConcept, projectConcept, 'projects');

    final projectToUserChild = Child(projectConcept, userConcept, 'owner');

    return domain;
  }
}
