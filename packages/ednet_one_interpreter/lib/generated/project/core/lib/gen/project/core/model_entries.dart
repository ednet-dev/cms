part of '../../../project_core.dart';
// Generated code for model entries in lib/gen/project/core/model_entries.dart

class CoreEntries extends ModelEntries {

  CoreEntries(super.model);

  /// Creates a map of new entries for each concept in the model.
  @override
  Map<String, Entities> newEntries() {
    final entries = <String, Entities>{};    
    
        final tasksConcept = model.concepts.singleWhereCode('Task');
    entries['Task'] = Tasks(tasksConcept!);
    
    final projectsConcept = model.concepts.singleWhereCode('Project');
    entries['Project'] = Projects(projectsConcept!);
    
    final milestonesConcept = model.concepts.singleWhereCode('Milestone');
    entries['Milestone'] = Milestones(milestonesConcept!);
    
    final resourcesConcept = model.concepts.singleWhereCode('Resource');
    entries['Resource'] = Resources(resourcesConcept!);
    
    final rolesConcept = model.concepts.singleWhereCode('Role');
    entries['Role'] = Roles(rolesConcept!);
    
    final teamsConcept = model.concepts.singleWhereCode('Team');
    entries['Team'] = Teams(teamsConcept!);
    
    final skillsConcept = model.concepts.singleWhereCode('Skill');
    entries['Skill'] = Skills(skillsConcept!);
    
    final timesConcept = model.concepts.singleWhereCode('Time');
    entries['Time'] = Times(timesConcept!);
    
    final budgetsConcept = model.concepts.singleWhereCode('Budget');
    entries['Budget'] = Budgets(budgetsConcept!);
    
    final initiativesConcept = model.concepts.singleWhereCode('Initiative');
    entries['Initiative'] = Initiatives(initiativesConcept!);
    

    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  @override
  Entities? newEntities(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

        if (concept.code == 'Task') {
      return Tasks(concept);
    }
    
    if (concept.code == 'Project') {
      return Projects(concept);
    }
    
    if (concept.code == 'Milestone') {
      return Milestones(concept);
    }
    
    if (concept.code == 'Resource') {
      return Resources(concept);
    }
    
    if (concept.code == 'Role') {
      return Roles(concept);
    }
    
    if (concept.code == 'Team') {
      return Teams(concept);
    }
    
    if (concept.code == 'Skill') {
      return Skills(concept);
    }
    
    if (concept.code == 'Time') {
      return Times(concept);
    }
    
    if (concept.code == 'Budget') {
      return Budgets(concept);
    }
    
    if (concept.code == 'Initiative') {
      return Initiatives(concept);
    }
    

    return null;
  }

  /// Returns a new entity for the given concept code.
  @override
  Entity? newEntity(String conceptCode) {
    final concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError('$conceptCode concept does not exist.');
    }

        if (concept.code == 'Task') {
      return Task(concept);
    }
    
    if (concept.code == 'Project') {
      return Project(concept);
    }
    
    if (concept.code == 'Milestone') {
      return Milestone(concept);
    }
    
    if (concept.code == 'Resource') {
      return Resource(concept);
    }
    
    if (concept.code == 'Role') {
      return Role(concept);
    }
    
    if (concept.code == 'Team') {
      return Team(concept);
    }
    
    if (concept.code == 'Skill') {
      return Skill(concept);
    }
    
    if (concept.code == 'Time') {
      return Time(concept);
    }
    
    if (concept.code == 'Budget') {
      return Budget(concept);
    }
    
    if (concept.code == 'Initiative') {
      return Initiative(concept);
    }
    

    return null;
  }

    Tasks get tasks => getEntry('Task') as Tasks;
  
  Projects get projects => getEntry('Project') as Projects;
  
  Milestones get milestones => getEntry('Milestone') as Milestones;
  
  Resources get resources => getEntry('Resource') as Resources;
  
  Roles get roles => getEntry('Role') as Roles;
  
  Teams get teams => getEntry('Team') as Teams;
  
  Skills get skills => getEntry('Skill') as Skills;
  
  Times get times => getEntry('Time') as Times;
  
  Budgets get budgets => getEntry('Budget') as Budgets;
  
  Initiatives get initiatives => getEntry('Initiative') as Initiatives;
  
}
