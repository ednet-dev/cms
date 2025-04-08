import 'package:flutter/material.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_core/ednet_core.dart';

/// Provider for managing project state and operations
class ProjectProvider extends ChangeNotifier {
  /// Project service for CRUD operations
  final ProjectService _projectService;

  /// Reference to the application
  final OneApplication _app;

  /// List of projects
  List<Project> _projects = [];

  /// Currently selected project
  Project? _selectedProject;

  /// Loading state
  bool _isLoading = false;

  /// Constructor
  ProjectProvider(this._projectService, this._app) {
    loadProjects();
  }

  /// Get all projects
  List<Project> get projects => _projects;

  /// Get selected project
  Project? get selectedProject => _selectedProject;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get available domains
  List<Domain> get availableDomains => _app.domains.toList();

  /// Load all projects
  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    await _projectService.loadProjects();
    _projects = _projectService.allProjects;

    _isLoading = false;
    notifyListeners();
  }

  /// Select a project
  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  /// Clear selected project
  void clearSelectedProject() {
    _selectedProject = null;
    notifyListeners();
  }

  /// Create a new project
  Future<Project?> createProject({
    required String name,
    required String description,
    required String domainCode,
    String? modelCode,
    ProjectStatus? status,
    List<DeploymentEnvironment>? environments,
  }) async {
    _isLoading = true;
    notifyListeners();

    final project = await _projectService.createProject(
      name: name,
      description: description,
      domainCode: domainCode,
      modelCode: modelCode,
      status: status,
      environments: environments,
    );

    await loadProjects();
    return project;
  }

  /// Update a project
  Future<Project?> updateProject({
    required String id,
    String? name,
    String? description,
    ProjectStatus? status,
    String? domainCode,
    String? modelCode,
    List<DeploymentEnvironment>? environments,
  }) async {
    _isLoading = true;
    notifyListeners();

    final project = await _projectService.updateProject(
      id: id,
      name: name,
      description: description,
      status: status,
      domainCode: domainCode,
      modelCode: modelCode,
      environments: environments,
    );

    await loadProjects();

    // Update selected project if it was the one modified
    if (_selectedProject?.id == id) {
      _selectedProject = project;
    }

    return project;
  }

  /// Delete a project
  Future<bool> deleteProject(String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _projectService.deleteProject(id);

    // Clear selected project if it was the one deleted
    if (_selectedProject?.id == id) {
      _selectedProject = null;
    }

    await loadProjects();
    return result;
  }

  /// Create a new deployment
  Future<Deployment?> createDeployment({
    required String projectId,
    required DeploymentEnvironment environment,
    required DeploymentTargetType targetType,
    String? deployedUrl,
    Map<String, String>? configuration,
  }) async {
    _isLoading = true;
    notifyListeners();

    final deployment = await _projectService.createDeployment(
      projectId: projectId,
      environment: environment,
      targetType: targetType,
      deployedUrl: deployedUrl,
      configuration: configuration,
    );

    await loadProjects();

    // Update selected project if it was the one modified
    if (_selectedProject?.id == projectId) {
      _selectedProject = _projectService.getProject(projectId);
    }

    return deployment;
  }

  /// Get models for a domain
  List<Model> getModelsForDomain(String domainCode) {
    final domain = _app.domains.firstWhere(
      (d) => d.code == domainCode,
      orElse: () => Domain('null'),
    );

    return domain.models.toList();
  }

  /// Get concepts for a model
  List<Concept> getConceptsForModel(String domainCode, String modelCode) {
    final domain = _app.domains.firstWhere(
      (d) => d.code == domainCode,
      orElse: () => Domain('null'),
    );

    final model = domain.models.firstWhere(
      (m) => m.code == modelCode,
      orElse: () => Model(domain, 'null'),
    );

    return model.concepts.toList();
  }
}
