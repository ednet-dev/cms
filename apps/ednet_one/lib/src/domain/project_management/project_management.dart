library ednet_project_management;

import 'package:ednet_core/ednet_core.dart';

Domains createDomainModels() {
  /// Domains
  Domain projectManagement = Domain('ProjectManagement');
  Domain directDemocracy = Domain('DirectDemocracy');
  Domain socialNetwork = Domain('SocialNetwork');
  Domain legislation = Domain('Legislation');

  Domains domains = Domains()
    ..add(projectManagement)
    ..add(directDemocracy)
    ..add(socialNetwork)
    ..add(legislation);

  /// Models
  Model todoModel = Model(projectManagement, 'GTD');
  Model projectModel = Model(projectManagement, 'Project');
  Model taskModel = Model(projectManagement, 'Task');
  Model calendarModel = Model(projectManagement, 'Calendar');

  /// Concepts
  Concept projectConcept = Concept(todoModel, 'Project');
  Attribute(projectConcept, 'title');
  Attribute(projectConcept, 'title');
  Attribute(projectConcept, 'description');
  Attribute(projectConcept, 'status');
  Attribute(projectConcept, 'startDate');
  Attribute(projectConcept, 'endDate');
  Attribute(projectConcept, 'creationDate');
  Attribute(projectConcept, 'modificationDate');

  Concept taskConcept = Concept(todoModel, 'Task');
  Attribute(taskConcept, 'title');
  Attribute(taskConcept, 'description');
  Attribute(taskConcept, 'creationDate');
  Attribute(taskConcept, 'dueDate');
  Attribute(taskConcept, 'status');
  Attribute(taskConcept, 'priority');
  Attribute(taskConcept, 'modificationDate');
  Attribute(taskConcept, 'scheduledDate');
  Attribute(taskConcept, 'isRecurring');

  Concept personConcept = Concept(todoModel, 'Person');
  Attribute(personConcept, 'firstName');
  Attribute(personConcept, 'lastName');
  Attribute(personConcept, 'email');

  Concept participantConcept = Concept(projectModel, 'Participant');
  Attribute(participantConcept, 'name');
  Attribute(participantConcept, 'email');

  Child participantChild =
      Child(projectConcept, participantConcept, 'participants');
  Parent projectParent = Parent(participantConcept, projectConcept, 'project');

  participantChild.opposite = projectParent;
  projectParent.opposite = participantChild;

  // Concepts for Task model
  Concept roleConcept = Concept(taskModel, 'Role');
  Attribute(roleConcept, 'name');

  Child roleChild = Child(taskConcept, roleConcept, 'roles');
  Parent taskParent = Parent(roleConcept, taskConcept, 'task');

  roleChild.opposite = taskParent;
  taskParent.opposite = roleChild;

  // Concepts for Calendar model
  Concept calendarConcept = Concept(calendarModel, 'Calendar');
  Attribute(calendarConcept, 'name');
  Attribute(calendarConcept, 'description');
  Attribute(calendarConcept, 'startDate');
  Attribute(calendarConcept, 'endDate');

  Concept eventConcept = Concept(calendarModel, 'Event');
  Attribute(eventConcept, 'title');
  Attribute(eventConcept, 'description');
  Attribute(eventConcept, 'startDate');
  Attribute(eventConcept, 'endDate');
  Attribute(eventConcept, 'location');
  Attribute(eventConcept, 'isRecurring');
  Attribute(eventConcept, 'recurringFrequency');

  Child eventChild = Child(calendarConcept, eventConcept, 'events');
  Parent calendarParent = Parent(eventConcept, calendarConcept, 'calendar');

  eventChild.opposite = calendarParent;
  calendarParent.opposite = eventChild;

  return populateDomainModels(domains);
}

Domains populateDomainModels(Domains domains) {
  /// Domains
  final dd = domains.getDomain('DirectDemocracy');
  
  return domains;
}

final domainModel = createDomainModels();
