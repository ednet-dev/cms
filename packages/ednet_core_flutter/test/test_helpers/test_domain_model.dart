import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Creates a test domain with a predefined structure for testing purposes
Domain createTestDomainModel() {
  // Create a domain for project management
  final domain = Domain('ProjectManagement');
  domain.description = 'Test domain for project management';

  // Create a core model
  final coreModel = Model(domain, 'Core');
  domain.models.add(coreModel);

  // Create concepts
  _initCoreModelConcepts(domain, coreModel);

  // Add a secondary model
  final planningModel = Model(domain, 'Planning');
  domain.models.add(planningModel);

  // Create concepts for the planning model
  _initPlanningModelConcepts(domain, planningModel);

  return domain;
}

/// Initialize concepts for the core model
void _initCoreModelConcepts(Domain domain, Model coreModel) {
  // Project concept
  final projectConcept = Concept(coreModel, 'Project');
  projectConcept.entry = true;
  projectConcept.description = 'A project with tasks and resources';

  // Add attributes for Project
  final projectNameAttr = Attribute(projectConcept, 'name');
  projectNameAttr.type = domain.getType('String');
  projectNameAttr.required = true;

  final projectDescAttr = Attribute(projectConcept, 'description');
  projectDescAttr.type = domain.getType('String');

  // Task concept
  final taskConcept = Concept(coreModel, 'Task');
  taskConcept.entry = true;
  taskConcept.description = 'A task within a project';

  // Add attributes for Task
  final taskTitleAttr = Attribute(taskConcept, 'title');
  taskTitleAttr.type = domain.getType('String');
  taskTitleAttr.required = true;

  final taskStatusAttr = Attribute(taskConcept, 'status');
  taskStatusAttr.type = domain.getType('String');

  // Resource concept
  final resourceConcept = Concept(coreModel, 'Resource');
  resourceConcept.entry = true;
  resourceConcept.description = 'A resource assigned to tasks';

  // Add attributes for Resource
  final resourceNameAttr = Attribute(resourceConcept, 'name');
  resourceNameAttr.type = domain.getType('String');
  resourceNameAttr.required = true;

  // Create an abstract concept
  final baseEntityConcept = Concept(coreModel, 'BaseEntity');
  baseEntityConcept.abstract = true;
  baseEntityConcept.description = 'Base entity for all domain objects';

  // Set up inheritance
  final projectParent = Parent(projectConcept, baseEntityConcept, 'baseEntity');
  projectConcept.parents.add(projectParent);

  final taskParent = Parent(taskConcept, baseEntityConcept, 'baseEntity');
  taskConcept.parents.add(taskParent);

  final resourceParent =
      Parent(resourceConcept, baseEntityConcept, 'baseEntity');
  resourceConcept.parents.add(resourceParent);

  // Set up children relationships
  final projectChild = Child(baseEntityConcept, projectConcept, 'projects');
  baseEntityConcept.children.add(projectChild);

  final taskChild = Child(baseEntityConcept, taskConcept, 'tasks');
  baseEntityConcept.children.add(taskChild);

  final resourceChild = Child(baseEntityConcept, resourceConcept, 'resources');
  baseEntityConcept.children.add(resourceChild);
}

/// Initialize concepts for the planning model
void _initPlanningModelConcepts(Domain domain, Model planningModel) {
  // Phase concept
  final phaseConcept = Concept(planningModel, 'Phase');
  phaseConcept.entry = true;
  phaseConcept.description = 'A phase in project planning';

  // Add attributes for Phase
  final phaseNameAttr = Attribute(phaseConcept, 'name');
  phaseNameAttr.type = domain.getType('String');
  phaseNameAttr.required = true;

  final phaseOrderAttr = Attribute(phaseConcept, 'order');
  phaseOrderAttr.type = domain.getType('int');

  // Milestone concept
  final milestoneConcept = Concept(planningModel, 'Milestone');
  milestoneConcept.entry = true;
  milestoneConcept.description = 'A milestone marking significant progress';

  // Add attributes for Milestone
  final milestoneNameAttr = Attribute(milestoneConcept, 'name');
  milestoneNameAttr.type = domain.getType('String');
  milestoneNameAttr.required = true;

  final milestoneDateAttr = Attribute(milestoneConcept, 'date');
  milestoneDateAttr.type = domain.getType('DateTime');
}

/// Creates test entities for a given domain model
void createTestEntities(ShellApp shellApp) {
  // Find concepts to create entities for
  final domain = shellApp.domain;
  for (final model in domain.models) {
    for (final concept in model.concepts) {
      if (concept.entry && !concept.abstract) {
        // Create test entities for this concept
        _createTestEntitiesForConcept(shellApp, concept);
      }
    }
  }
}

/// Create test entities for a specific concept
void _createTestEntitiesForConcept(ShellApp shellApp, Concept concept) {
  final conceptCode = concept.code;

  // Create different numbers of entities based on the concept
  int count = 2;
  if (conceptCode == 'Task') count = 5;
  if (conceptCode == 'Resource') count = 3;

  for (int i = 1; i <= count; i++) {
    final entity = _createEntityData(conceptCode, i);
    shellApp.saveEntity(conceptCode, entity);
  }
}

/// Create entity data based on concept type
Map<String, dynamic> _createEntityData(String conceptCode, int index) {
  final id = '${conceptCode.toLowerCase()}-$index';

  switch (conceptCode) {
    case 'Project':
      return {
        'id': id,
        'name': 'Test Project $index',
        'description': 'This is a test project',
        'startDate':
            DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        'endDate': DateTime.now().add(Duration(days: 30)).toIso8601String(),
      };

    case 'Task':
      return {
        'id': id,
        'title': 'Test Task $index',
        'description': 'This is test task $index',
        'status': index % 3 == 0
            ? 'completed'
            : (index % 3 == 1 ? 'in_progress' : 'not_started'),
        'priority':
            index % 3 == 0 ? 'high' : (index % 3 == 1 ? 'medium' : 'low'),
      };

    case 'Resource':
      return {
        'id': id,
        'name': 'Resource $index',
        'type': index % 2 == 0 ? 'human' : 'material',
        'cost': 100.0 * index,
      };

    case 'Phase':
      return {
        'id': id,
        'name': 'Phase $index',
        'order': index,
        'description': 'Test phase $index',
      };

    case 'Milestone':
      return {
        'id': id,
        'name': 'Milestone $index',
        'date':
            DateTime.now().add(Duration(days: 10 * index)).toIso8601String(),
        'description': 'Test milestone $index',
      };

    default:
      return {
        'id': id,
        'name': '$conceptCode $index',
      };
  }
}
