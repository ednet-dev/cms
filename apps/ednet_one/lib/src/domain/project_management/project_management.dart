library ednet_project_management;

import 'package:ednet_core/ednet_core.dart';

Model createTodoModel() {
  Domain todoDomain = Domain('Todo');

  Model todoModel = Model(todoDomain, 'GTD');

  Concept projectConcept = Concept(todoModel, 'Project');
  Attribute title = Attribute(projectConcept, 'title');
  Attribute description = Attribute(projectConcept, 'description');
  Attribute creationDate = Attribute(projectConcept, 'creationDate');

  Concept taskConcept = Concept(todoModel, 'Task');
  Attribute taskTitle = Attribute(taskConcept, 'title');
  Attribute taskDescription = Attribute(taskConcept, 'description');
  Attribute taskCreationDate = Attribute(taskConcept, 'creationDate');
  Attribute taskDueDate = Attribute(taskConcept, 'dueDate');
  Attribute taskStatus = Attribute(taskConcept, 'status');
  Attribute taskPriority = Attribute(taskConcept, 'priority');

  Concept personConcept = Concept(todoModel, 'Person');
  Attribute firstName = Attribute(personConcept, 'firstName');
  Attribute lastName = Attribute(personConcept, 'lastName');
  Attribute email = Attribute(personConcept, 'email');
  //
  // Role managerRole = Role(projectConcept, 'manager');
  // Role designerRole = Role(projectConcept, 'designer');
  // Role developerRole = Role(projectConcept, 'developer');
  //
  // managerRole.multiplicity = Multiplicity.ONE_OR_MANY;
  // designerRole.multiplicity = Multiplicity.ONE_OR_MANY;
  // developerRole.multiplicity = Multiplicity.ONE_OR_MANY;
  //
  // managerRole.targetConcept = personConcept;
  // designerRole.targetConcept = personConcept;
  // developerRole.targetConcept = personConcept;
  //
  // Relationship managerRelationship =
  // Relationship(projectConcept, managerRole, 'Manager');
  // Relationship designerRelationship =
  // Relationship(projectConcept, designerRole, 'Designer');
  // Relationship developerRelationship =
  // Relationship(projectConcept, developerRole, 'Developer');
  //
  // managerRelationship.opposite = Reference(personConcept, 'Managed Projects',
  //     managerRole, projectConcept, true);
  // designerRelationship.opposite = Reference(personConcept, 'Designed Projects',
  //     designerRole, projectConcept, true);
  // developerRelationship.opposite = Reference(personConcept,
  //     'Developed Projects', developerRole, projectConcept, true);

  return todoModel;
}



// // Define the subdomain for GTD
// Domain gtdDomain = Domain('GTD');
// Model projectModel = Model(gtdDomain, 'Project');
// Model taskModel = Model(gtdDomain, 'Task');
// Model calendarModel = Model(gtdDomain, 'Calendar');
//
// // Define the concepts for Project model
// Concept projectConcept = Concept(projectModel, 'Project');
// Attribute title = Attribute(projectConcept, 'title');
// Attribute(projectConcept, 'description');
// Attribute(projectConcept, 'status');
// Attribute(projectConcept, 'startDate');
// Attribute(projectConcept, 'endDate');
// Attribute(projectConcept, 'creationDate');
// Attribute(projectConcept, 'modificationDate');
//
// Concept participantConcept = Concept(projectModel, 'Participant');
// Attribute(participantConcept, 'name');
// Attribute(participantConcept, 'email');
//
// Child participantChild =
// Child(projectConcept, participantConcept, 'participants');
// Parent projectParent =
// Parent(participantConcept, projectConcept, 'project');
//
// participantChild.opposite = projectParent;
// projectParent.opposite = participantChild;
//
// // Define the concepts for Task model
// Concept taskConcept = Concept(taskModel, 'Task');
// Attribute(taskConcept, 'title');
// Attribute(taskConcept, 'description');
// Attribute(taskConcept, 'status');
// Attribute(taskConcept, 'priority');
// Attribute(taskConcept, 'dueDate');
// Attribute(taskConcept, 'creationDate');
// Attribute(taskConcept, 'modificationDate');
// Attribute(taskConcept, 'scheduledDate');
// Attribute(taskConcept, 'isRecurring');
//
// Concept roleConcept = Concept(taskModel, 'Role');
// Attribute(roleConcept, 'name');
//
// Child roleChild = Child(taskConcept, roleConcept, 'roles');
// Parent taskParent = Parent(roleConcept, taskConcept, 'task');
//
// roleChild.opposite = taskParent;
// taskParent.opposite = roleChild;
//
// // Define the concepts for Calendar model
// Concept calendarConcept = Concept(calendarModel, 'Calendar');
// Attribute(calendarConcept, 'name');
// Attribute(calendarConcept, 'description');
// Attribute(calendarConcept, 'startDate');
// Attribute(calendarConcept, 'endDate');
//
// Concept eventConcept = Concept(calendarModel, 'Event');
// Attribute(eventConcept, 'title');
// Attribute(eventConcept, 'description');
// Attribute(eventConcept, 'startDate');
// Attribute(eventConcept, 'endDate');
// Attribute(eventConcept, 'location');
// Attribute(eventConcept, 'isRecurring');
// Attribute(eventConcept, 'recurringFrequency');
//
// Child eventChild = Child(calendarConcept, eventConcept, 'events');
// Parent calendarParent =
// Parent(eventConcept, calendarConcept, 'calendar');
//
// eventChild.opposite = calendarParent;
// calendarParent.opposite = eventChild;
//
