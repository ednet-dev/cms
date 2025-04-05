import 'package:ednet_core/ednet_core.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:ednet_one_interpreter/generated/staging/democracy/direct/lib/democracy_direct.dart'
    as dydt;
import 'package:ednet_one_interpreter/generated/staging/household/finance/lib/household_finance.dart'
    as hdfe;
import 'package:ednet_one_interpreter/generated/staging/household/member/lib/household_member.dart'
    as hdmr;
import 'package:ednet_one_interpreter/generated/staging/project/brainstorming/lib/project_brainstorming.dart'
    as ptbg;
import 'package:ednet_one_interpreter/generated/staging/project/core/lib/project_core.dart'
    as ptce;
import 'package:ednet_one_interpreter/generated/staging/project/gtd/lib/project_gtd.dart'
    as ptgd;
import 'package:ednet_one_interpreter/generated/staging/project/kanban/lib/project_kanban.dart'
    as ptkn;
import 'package:ednet_one_interpreter/generated/staging/project/planning/lib/project_planning.dart'
    as ptpg;
import 'package:ednet_one_interpreter/generated/staging/project/scheduling/lib/project_scheduling.dart'
    as ptsg;
import 'package:ednet_one_interpreter/generated/staging/project/user/lib/project_user.dart'
    as ptur;
import 'package:ednet_one_interpreter/generated/staging/settings/application/lib/settings_application.dart'
    as ssan;

/// Data class to hold a domain model pair
class DomainModelPair {
  final Domain domain;
  final String modelCode;
  final DomainModels domainModels;

  const DomainModelPair({
    required this.domain,
    required this.modelCode,
    required this.domainModels,
  });
}

/// Central registry for all domain models in the application.
///
/// This class is responsible for initializing and providing access to all
/// domain models used in the application. It serves as a factory for creating
/// domain model instances and manages their lifecycle.
class ModelRegistry {
  /// Dynamically discovers and loads domain models based on the generated directory structure
  static Future<List<DomainModelPair>> discoverDomainModels(
    String environment,
  ) async {
    final List<DomainModelPair> discoveredModels = [];

    // First try the standard, static initialization
    discoveredModels.addAll(getStaticDomainModels());

    if (discoveredModels.isNotEmpty) {
      return discoveredModels;
    }

    // If no real models are found, create sample ones
    return createSampleDomainModels();
  }

  /// Returns a list of all domain models used in the application
  static List<DomainModelPair> getStaticDomainModels() {
    final List<DomainModelPair> models = [];

    try {
      // Settings Application
      final settingsApplicationRepo = ssan.SettingsApplicationRepo();
      final settingsApplicationDomain =
          settingsApplicationRepo.getDomainModels("Settings")
              as ssan.SettingsDomain;
      final applicationModel =
          settingsApplicationDomain.getModelEntries("Application")
              as ssan.ApplicationModel;
      applicationModel.init();
      models.add(
        DomainModelPair(
          domain: settingsApplicationDomain.domain,
          modelCode: "Application",
          domainModels: settingsApplicationDomain,
        ),
      );

      // Project Scheduling
      final projectSchedulingRepo = ptsg.ProjectSchedulingRepo();
      final projectSchedulingDomain =
          projectSchedulingRepo.getDomainModels("Project")
              as ptsg.ProjectDomain;
      final schedulingModel =
          projectSchedulingDomain.getModelEntries("Scheduling")
              as ptsg.SchedulingModel;
      schedulingModel.init();
      models.add(
        DomainModelPair(
          domain: projectSchedulingDomain.domain,
          modelCode: "Scheduling",
          domainModels: projectSchedulingDomain,
        ),
      );

      // Project Core
      final projectCoreRepo = ptce.ProjectCoreRepo();
      final projectCoreDomain =
          projectCoreRepo.getDomainModels("Project") as ptce.ProjectDomain;
      final coreModel =
          projectCoreDomain.getModelEntries("Core") as ptce.CoreModel;
      coreModel.init();
      models.add(
        DomainModelPair(
          domain: projectCoreDomain.domain,
          modelCode: "Core",
          domainModels: projectCoreDomain,
        ),
      );

      // Project Brainstorming
      final projectBrainstormingRepo = ptbg.ProjectBrainstormingRepo();
      final projectBrainstormingDomain =
          projectBrainstormingRepo.getDomainModels("Project")
              as ptbg.ProjectDomain;
      final brainstormingModel =
          projectBrainstormingDomain.getModelEntries("Brainstorming")
              as ptbg.BrainstormingModel;
      brainstormingModel.init();
      models.add(
        DomainModelPair(
          domain: projectBrainstormingDomain.domain,
          modelCode: "Brainstorming",
          domainModels: projectBrainstormingDomain,
        ),
      );

      // Project Planning
      final projectPlanningRepo = ptpg.ProjectPlanningRepo();
      final projectPlanningDomain =
          projectPlanningRepo.getDomainModels("Project") as ptpg.ProjectDomain;
      final planningModel =
          projectPlanningDomain.getModelEntries("Planning")
              as ptpg.PlanningModel;
      planningModel.init();
      models.add(
        DomainModelPair(
          domain: projectPlanningDomain.domain,
          modelCode: "Planning",
          domainModels: projectPlanningDomain,
        ),
      );

      // Project Kanban
      final projectKanbanRepo = ptkn.ProjectKanbanRepo();
      final projectKanbanDomain =
          projectKanbanRepo.getDomainModels("Project") as ptkn.ProjectDomain;
      final kanbanModel =
          projectKanbanDomain.getModelEntries("Kanban") as ptkn.KanbanModel;
      kanbanModel.init();
      models.add(
        DomainModelPair(
          domain: projectKanbanDomain.domain,
          modelCode: "Kanban",
          domainModels: projectKanbanDomain,
        ),
      );

      // Project User
      final projectUserRepo = ptur.ProjectUserRepo();
      final projectUserDomain =
          projectUserRepo.getDomainModels("Project") as ptur.ProjectDomain;
      final userModel =
          projectUserDomain.getModelEntries("User") as ptur.UserModel;
      userModel.init();
      models.add(
        DomainModelPair(
          domain: projectUserDomain.domain,
          modelCode: "User",
          domainModels: projectUserDomain,
        ),
      );

      // Project GTD
      final projectGtdRepo = ptgd.ProjectGtdRepo();
      final projectGtdDomain =
          projectGtdRepo.getDomainModels("Project") as ptgd.ProjectDomain;
      final gtdModel = projectGtdDomain.getModelEntries("Gtd") as ptgd.GtdModel;
      gtdModel.init();
      models.add(
        DomainModelPair(
          domain: projectGtdDomain.domain,
          modelCode: "Gtd",
          domainModels: projectGtdDomain,
        ),
      );

      // Household Finance
      final householdFinanceRepo = hdfe.HouseholdFinanceRepo();
      final householdFinanceDomain =
          householdFinanceRepo.getDomainModels("Household")
              as hdfe.HouseholdDomain;
      final financeModel =
          householdFinanceDomain.getModelEntries("Finance")
              as hdfe.FinanceModel;
      financeModel.init();
      models.add(
        DomainModelPair(
          domain: householdFinanceDomain.domain,
          modelCode: "Finance",
          domainModels: householdFinanceDomain,
        ),
      );

      // Household Member
      final householdMemberRepo = hdmr.HouseholdMemberRepo();
      final householdMemberDomain =
          householdMemberRepo.getDomainModels("Household")
              as hdmr.HouseholdDomain;
      final memberModel =
          householdMemberDomain.getModelEntries("Member") as hdmr.MemberModel;
      memberModel.init();
      models.add(
        DomainModelPair(
          domain: householdMemberDomain.domain,
          modelCode: "Member",
          domainModels: householdMemberDomain,
        ),
      );

      // Democracy Direct
      final democracyDirectRepo = dydt.DemocracyDirectRepo();
      final democracyDirectDomain =
          democracyDirectRepo.getDomainModels("Democracy")
              as dydt.DemocracyDomain;
      final directModel =
          democracyDirectDomain.getModelEntries("Direct") as dydt.DirectModel;
      directModel.init();
      models.add(
        DomainModelPair(
          domain: democracyDirectDomain.domain,
          modelCode: "Direct",
          domainModels: democracyDirectDomain,
        ),
      );
    } catch (e) {
      print('Error initializing static domain models: $e');
    }

    return models;
  }

  /// Creates sample domain models for demonstration purposes
  static List<DomainModelPair> createSampleDomainModels() {
    final List<DomainModelPair> models = [];

    try {
      // Create sample Project DomainModels
      final projectSampleDomain = _createSampleProjectDomain();
      models.add(projectSampleDomain);

      // Create sample Customer DomainModels
      final customerSampleDomain = _createSampleCustomerDomain();
      models.add(customerSampleDomain);
    } catch (e) {
      print('Error creating sample domain models: $e');
    }

    return models;
  }

  /// Creates a sample project domain model
  static DomainModelPair _createSampleProjectDomain() {
    // Create Project domain
    final projectDomain = Domain('Project');
    projectDomain.description = 'Sample Project Domain for demonstration';

    // Create Task Model
    final taskModel = Model(projectDomain, 'Task');
    taskModel.description = 'Task management model';

    // Add task concept
    final taskConcept = Concept(taskModel, 'Task');
    taskConcept.entry = true;
    taskConcept.description = 'A task to be completed';

    // Create some example tasks
    // We need to create a custom DomainModels implementation
    // that wraps our domain and provides the necessary interface
    final domainModels = _SampleDomainModels(projectDomain);

    // Now create a model entries object for task
    final modelEntries = _SampleModelEntries(taskModel);
    domainModels.addModelEntries('Task', modelEntries);

    // Create sample task data
    final task1 = Entity();
    task1.concept = taskConcept;
    task1.setAttribute('name', 'Complete Project Setup');
    task1.setAttribute(
      'description',
      'Set up initial project structure and dependencies',
    );
    task1.setAttribute('completed', false);
    modelEntries.addEntry('Task1', task1);

    final task2 = Entity();
    task2.concept = taskConcept;
    task2.setAttribute('name', 'Implement Core Features');
    task2.setAttribute(
      'description',
      'Develop the main functionality of the application',
    );
    task2.setAttribute('completed', false);
    modelEntries.addEntry('Task2', task2);

    return DomainModelPair(
      domain: projectDomain,
      modelCode: 'Task',
      domainModels: domainModels,
    );
  }

  /// Creates a sample customer domain model
  static DomainModelPair _createSampleCustomerDomain() {
    // Create Customer domain
    final customerDomain = Domain('Customer');
    customerDomain.description = 'Sample Customer Domain for demonstration';

    // Create Customer Model
    final customerModel = Model(customerDomain, 'Profile');
    customerModel.description = 'Customer profile management';

    // Add customer concept
    final customerConcept = Concept(customerModel, 'Customer');
    customerConcept.entry = true;
    customerConcept.description = 'A customer profile';

    // Create a custom DomainModels implementation
    final domainModels = _SampleDomainModels(customerDomain);

    // Create model entries
    final modelEntries = _SampleModelEntries(customerModel);
    domainModels.addModelEntries('Profile', modelEntries);

    // Create sample customer data
    final customer1 = Entity();
    customer1.concept = customerConcept;
    customer1.setAttribute('firstName', 'John');
    customer1.setAttribute('lastName', 'Doe');
    customer1.setAttribute('email', 'john.doe@example.com');
    modelEntries.addEntry('Customer1', customer1);

    final customer2 = Entity();
    customer2.concept = customerConcept;
    customer2.setAttribute('firstName', 'Jane');
    customer2.setAttribute('lastName', 'Smith');
    customer2.setAttribute('email', 'jane.smith@example.com');
    modelEntries.addEntry('Customer2', customer2);

    return DomainModelPair(
      domain: customerDomain,
      modelCode: 'Profile',
      domainModels: domainModels,
    );
  }
}

/// A simple implementation of DomainModels for sample data
class _SampleDomainModels implements DomainModels {
  final Domain _domain;
  final Map<String, _SampleModelEntries> _modelEntriesMap = {};

  _SampleDomainModels(this._domain);

  @override
  Domain get domain => _domain;

  void addModelEntries(String modelCode, _SampleModelEntries modelEntries) {
    _modelEntriesMap[modelCode] = modelEntries;
  }

  @override
  ModelEntries? getModelEntries(String modelCode) {
    return _modelEntriesMap[modelCode];
  }
}

/// A simple implementation of ModelEntries for sample data
class _SampleModelEntries implements ModelEntries {
  final Model _model;
  final Map<String, Entity> _entries = {};

  _SampleModelEntries(this._model);

  @override
  Model get model => _model;

  void addEntry(String code, Entity entity) {
    _entries[code] = entity;
  }

  @override
  Entity? getEntry(String code) {
    return _entries[code];
  }

  @override
  void init() {
    // Not needed for this simple implementation
  }
}
