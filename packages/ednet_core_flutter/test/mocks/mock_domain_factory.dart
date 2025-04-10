import 'package:ednet_core/ednet_core.dart';

/// A factory class for creating mock Domain objects for testing.
class MockDomainFactory {
  /// Creates a simple domain with basic concepts for testing.
  static Domain createSimpleDomain() {
    // Create a test domain
    final domain = Domain('TestDomain');

    // Create a model
    final model = Model(domain, 'TestModel');
    domain.models.add(model);

    // Create a User concept (entry concept)
    final userConcept = Concept(model, 'User');
    userConcept.entry = true;

    // Create attributes for User
    Attribute(userConcept, 'username');
    Attribute(userConcept, 'email');
    Attribute(userConcept, 'isActive');

    model.concepts.add(userConcept);

    // Create a Project concept with parent relationship to User
    final projectConcept = Concept(model, 'Project');

    // Create attributes for Project
    Attribute(projectConcept, 'name');
    Attribute(projectConcept, 'description');
    Attribute(projectConcept, 'startDate');

    projectConcept.parents.add('User');
    model.concepts.add(projectConcept);

    // Create a Task concept with parent relationship to Project
    final taskConcept = Concept(model, 'Task');

    // Create attributes for Task
    Attribute(taskConcept, 'title');
    Attribute(taskConcept, 'completed');
    Attribute(taskConcept, 'dueDate');

    taskConcept.parents.add('Project');
    model.concepts.add(taskConcept);

    return domain;
  }

  /// Creates a more complex domain with multiple models and relationships.
  static Domain createComplexDomain() {
    // Create a test domain
    final domain = Domain('ComplexDomain');

    // Create multiple models
    final userModel = Model(domain, 'UserModel');
    final projectModel = Model(domain, 'ProjectModel');

    // Add models individually
    domain.models.add(userModel);
    domain.models.add(projectModel);

    // UserModel concepts
    final userConcept = Concept(userModel, 'User');
    userConcept.entry = true;

    // Create attributes for User
    Attribute(userConcept, 'username');
    Attribute(userConcept, 'email');

    final roleConcept = Concept(userModel, 'Role');
    roleConcept.entry = true;

    // Create attributes for Role
    Attribute(roleConcept, 'name');
    // Note: List<String> attributes would need special handling
    Attribute(roleConcept, 'permissions');

    final userRoleConcept = Concept(userModel, 'UserRole');

    // Add parents individually
    userRoleConcept.parents.add('User');
    userRoleConcept.parents.add('Role');

    // Create attributes for UserRole
    Attribute(userRoleConcept, 'isActive');

    // Add concepts individually
    userModel.concepts.add(userConcept);
    userModel.concepts.add(roleConcept);
    userModel.concepts.add(userRoleConcept);

    // ProjectModel concepts
    final projectConcept = Concept(projectModel, 'Project');
    projectConcept.entry = true;

    // Create attributes for Project
    Attribute(projectConcept, 'name');
    Attribute(projectConcept, 'startDate');

    final taskConcept = Concept(projectModel, 'Task');
    taskConcept.parents.add('Project');

    // Create attributes for Task
    Attribute(taskConcept, 'title');
    Attribute(taskConcept, 'completed');

    final assignmentConcept = Concept(projectModel, 'Assignment');

    // Add parents individually
    assignmentConcept.parents.add('Task');
    assignmentConcept.parents.add('User');

    // Create attributes for Assignment
    Attribute(assignmentConcept, 'assignedDate');

    // Add concepts individually
    projectModel.concepts.add(projectConcept);
    projectModel.concepts.add(taskConcept);
    projectModel.concepts.add(assignmentConcept);

    return domain;
  }
}
