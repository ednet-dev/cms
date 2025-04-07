import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:uuid/uuid.dart';

/// Status of a project
enum ProjectStatus {
  /// Project is in development
  development,

  /// Project is in testing
  testing,

  /// Project is in production
  production,

  /// Project is archived
  archived,
}

/// Environment for deployment
enum DeploymentEnvironment {
  /// Development environment
  development,

  /// Staging/testing environment
  staging,

  /// Production environment
  production,
}

/// Type of deployment target
enum DeploymentTargetType {
  /// Firebase Hosting
  firebaseHosting,

  /// Netlify
  netlify,

  /// Vercel
  vercel,

  /// GitHub Pages
  githubPages,

  /// Custom server
  customServer,
}

/// Status of a deployment
enum DeploymentStatus {
  /// Deployment is pending
  pending,

  /// Deployment is in progress
  inProgress,

  /// Deployment completed successfully
  successful,

  /// Deployment failed
  failed,

  /// Deployment is active
  active,

  /// Deployment was rolled back
  rolledBack,
}

/// Represents a project in the system
class Project {
  /// Unique identifier
  final String id;

  /// Name of the project
  String name;

  /// Description of the project
  String description;

  /// Status of the project
  ProjectStatus status;

  /// Associated domain code
  String domainCode;

  /// Associated model code
  String? modelCode;

  /// When the project was created
  final DateTime createdAt;

  /// When the project was last updated
  DateTime updatedAt;

  /// List of environments configured for this project
  List<DeploymentEnvironment> environments;

  /// List of deployments for this project
  List<Deployment> deployments;

  /// Constructor
  Project({
    String? id,
    required this.name,
    required this.description,
    required this.domainCode,
    this.modelCode,
    ProjectStatus? status,
    List<DeploymentEnvironment>? environments,
    List<Deployment>? deployments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       status = status ?? ProjectStatus.development,
       environments = environments ?? [DeploymentEnvironment.development],
       deployments = deployments ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.toString(),
      'domainCode': domainCode,
      'modelCode': modelCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'environments': environments.map((e) => e.toString()).toList(),
      'deployments': deployments.map((d) => d.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    // Parse environments
    List<DeploymentEnvironment> environments = [];
    if (json['environments'] != null) {
      List<dynamic> envList = json['environments'];
      for (var envStr in envList) {
        for (var env in DeploymentEnvironment.values) {
          if (envStr.toString().contains(env.toString())) {
            environments.add(env);
            break;
          }
        }
      }
    }

    // Parse deployments
    List<Deployment> deployments = [];
    if (json['deployments'] != null) {
      List<dynamic> deployList = json['deployments'];
      for (var deployJson in deployList) {
        deployments.add(Deployment.fromJson(deployJson));
      }
    }

    // Parse status
    ProjectStatus status = ProjectStatus.development;
    if (json['status'] != null) {
      for (var s in ProjectStatus.values) {
        if (json['status'].toString().contains(s.toString())) {
          status = s;
          break;
        }
      }
    }

    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: status,
      domainCode: json['domainCode'],
      modelCode: json['modelCode'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      environments: environments,
      deployments: deployments,
    );
  }
}

/// Represents a deployment of a project
class Deployment {
  /// Unique identifier
  final String id;

  /// Project ID this deployment belongs to
  final String projectId;

  /// Environment for this deployment
  final DeploymentEnvironment environment;

  /// Type of deployment target
  final DeploymentTargetType targetType;

  /// URL of the deployed application
  String? deployedUrl;

  /// Status of the deployment
  DeploymentStatus status;

  /// Configuration parameters for this deployment
  Map<String, String> configuration;

  /// When the deployment was created
  final DateTime createdAt;

  /// When the deployment was last updated
  DateTime updatedAt;

  /// Domain version deployed
  String modelVersion;

  /// Constructor
  Deployment({
    String? id,
    required this.projectId,
    required this.environment,
    required this.targetType,
    this.deployedUrl,
    DeploymentStatus? status,
    Map<String, String>? configuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? modelVersion,
  }) : id = id ?? const Uuid().v4(),
       status = status ?? DeploymentStatus.pending,
       configuration = configuration ?? {},
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       modelVersion = modelVersion ?? '1.0.0';

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'environment': environment.toString(),
      'targetType': targetType.toString(),
      'deployedUrl': deployedUrl,
      'status': status.toString(),
      'configuration': configuration,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'modelVersion': modelVersion,
    };
  }

  /// Create from JSON
  factory Deployment.fromJson(Map<String, dynamic> json) {
    // Parse environment
    DeploymentEnvironment environment = DeploymentEnvironment.development;
    for (var env in DeploymentEnvironment.values) {
      if (json['environment'].toString().contains(env.toString())) {
        environment = env;
        break;
      }
    }

    // Parse target type
    DeploymentTargetType targetType = DeploymentTargetType.firebaseHosting;
    for (var type in DeploymentTargetType.values) {
      if (json['targetType'].toString().contains(type.toString())) {
        targetType = type;
        break;
      }
    }

    // Parse status
    DeploymentStatus status = DeploymentStatus.pending;
    for (var s in DeploymentStatus.values) {
      if (json['status'].toString().contains(s.toString())) {
        status = s;
        break;
      }
    }

    return Deployment(
      id: json['id'],
      projectId: json['projectId'],
      environment: environment,
      targetType: targetType,
      deployedUrl: json['deployedUrl'],
      status: status,
      configuration: Map<String, String>.from(json['configuration'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      modelVersion: json['modelVersion'] ?? '1.0.0',
    );
  }
}

/// Service for managing projects and deployments
class ProjectService {
  /// The application instance
  final OneApplication _app;

  /// Persistence service for saving/loading projects
  final PersistenceService _persistenceService;

  /// Map of projects by ID
  final Map<String, Project> _projects = {};

  /// Constructor
  ProjectService(this._app, this._persistenceService);

  /// Get all projects
  List<Project> get allProjects => _projects.values.toList();

  /// Get a project by ID
  Project? getProject(String id) => _projects[id];

  /// Get projects for a specific domain
  List<Project> getProjectsForDomain(String domainCode) {
    return _projects.values
        .where((project) => project.domainCode == domainCode)
        .toList();
  }

  /// Get projects for a specific model
  List<Project> getProjectsForModel(String domainCode, String modelCode) {
    return _projects.values
        .where(
          (project) =>
              project.domainCode == domainCode &&
              project.modelCode == modelCode,
        )
        .toList();
  }

  /// Create a new project
  Future<Project> createProject({
    required String name,
    required String description,
    required String domainCode,
    String? modelCode,
    ProjectStatus? status,
    List<DeploymentEnvironment>? environments,
  }) async {
    final project = Project(
      name: name,
      description: description,
      domainCode: domainCode,
      modelCode: modelCode,
      status: status,
      environments: environments,
    );

    _projects[project.id] = project;
    await _saveProjects();

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
    final project = _projects[id];
    if (project == null) return null;

    if (name != null) project.name = name;
    if (description != null) project.description = description;
    if (status != null) project.status = status;
    if (domainCode != null) project.domainCode = domainCode;
    if (modelCode != null) project.modelCode = modelCode;
    if (environments != null) project.environments = environments;

    project.updatedAt = DateTime.now();
    await _saveProjects();

    return project;
  }

  /// Delete a project
  Future<bool> deleteProject(String id) async {
    final removed = _projects.remove(id);
    if (removed != null) {
      await _saveProjects();
      return true;
    }
    return false;
  }

  /// Create a new deployment for a project
  Future<Deployment?> createDeployment({
    required String projectId,
    required DeploymentEnvironment environment,
    required DeploymentTargetType targetType,
    String? deployedUrl,
    DeploymentStatus? status,
    Map<String, String>? configuration,
    String? modelVersion,
  }) async {
    final project = _projects[projectId];
    if (project == null) return null;

    final deployment = Deployment(
      projectId: projectId,
      environment: environment,
      targetType: targetType,
      deployedUrl: deployedUrl,
      status: status,
      configuration: configuration,
      modelVersion: modelVersion,
    );

    project.deployments.add(deployment);
    project.updatedAt = DateTime.now();
    await _saveProjects();

    return deployment;
  }

  /// Update a deployment
  Future<Deployment?> updateDeployment({
    required String projectId,
    required String deploymentId,
    String? deployedUrl,
    DeploymentStatus? status,
    Map<String, String>? configuration,
  }) async {
    final project = _projects[projectId];
    if (project == null) return null;

    final deploymentIndex = project.deployments.indexWhere(
      (d) => d.id == deploymentId,
    );

    if (deploymentIndex < 0) return null;

    final deployment = project.deployments[deploymentIndex];

    if (deployedUrl != null) deployment.deployedUrl = deployedUrl;
    if (status != null) deployment.status = status;
    if (configuration != null) deployment.configuration = configuration;

    deployment.updatedAt = DateTime.now();
    project.updatedAt = DateTime.now();
    await _saveProjects();

    return deployment;
  }

  /// Get the most recent deployment for a project in a specific environment
  Deployment? getLatestDeployment(
    String projectId,
    DeploymentEnvironment environment,
  ) {
    final project = _projects[projectId];
    if (project == null) return null;

    final deployments =
        project.deployments.where((d) => d.environment == environment).toList();

    if (deployments.isEmpty) return null;

    deployments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return deployments.first;
  }

  /// Load all projects from persistent storage
  Future<void> loadProjects() async {
    try {
      final projectsJson = await _persistenceService.loadConfiguration(
        'projects',
      );

      if (projectsJson != null) {
        final List<dynamic> projectsList = jsonDecode(projectsJson);

        _projects.clear();
        for (final projectMap in projectsList) {
          final project = Project.fromJson(projectMap);
          _projects[project.id] = project;
        }
      }
    } catch (e) {
      debugPrint('Error loading projects: $e');
    }
  }

  /// Save all projects to persistent storage
  Future<bool> _saveProjects() async {
    try {
      final projectsList =
          _projects.values.map((project) => project.toJson()).toList();
      final projectsJson = jsonEncode(projectsList);

      return await _persistenceService.saveConfiguration(
        'projects',
        projectsJson,
      );
    } catch (e) {
      debugPrint('Error saving projects: $e');
      return false;
    }
  }
}
