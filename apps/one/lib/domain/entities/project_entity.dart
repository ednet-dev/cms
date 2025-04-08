import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:uuid/uuid.dart';

/// ProjectEntity represents a project in our domain model
///
/// As an AggregateRoot, it ensures the consistency boundaries for the
/// project and its related deployments.
class ProjectEntity extends Entity<ProjectEntity> {
  /// Name of the project
  String get _name => getAttribute<String>('name') ?? '';
  set _name(String value) => setAttribute('name', value);

  /// Description of the project
  String get _description => getAttribute<String>('description') ?? '';
  set _description(String value) => setAttribute('description', value);

  /// Status of the project
  ProjectStatus get _status =>
      getAttribute<ProjectStatus>('status') ?? ProjectStatus.development;
  set _status(ProjectStatus value) => setAttribute('status', value);

  /// Associated domain code
  String get _domainCode => getAttribute<String>('domainCode') ?? '';
  set _domainCode(String value) => setAttribute('domainCode', value);

  /// Associated model code
  String? get _modelCode => getAttribute<String>('modelCode');
  set _modelCode(String? value) => setAttribute('modelCode', value);

  /// When the project was created
  DateTime get _createdAt =>
      getAttribute<DateTime>('createdAt') ?? DateTime.now();
  set _createdAt(DateTime value) => setAttribute('createdAt', value);

  /// When the project was last updated
  DateTime get _updatedAt =>
      getAttribute<DateTime>('updatedAt') ?? DateTime.now();
  set _updatedAt(DateTime value) => setAttribute('updatedAt', value);

  /// List of environments configured for this project
  List<DeploymentEnvironment> get _environments =>
      getAttribute<List<DeploymentEnvironment>>('environments') ??
      [DeploymentEnvironment.development];
  set _environments(List<DeploymentEnvironment> value) =>
      setAttribute('environments', value);

  /// List of deployments for this project
  List<DeploymentEntity> get _deployments =>
      getAttribute<List<DeploymentEntity>>('deployments') ?? [];
  set _deployments(List<DeploymentEntity> value) =>
      setAttribute('deployments', value);

  /// Public API that uses attributes internally
  /// This maintains the same interface while using Entity properly

  /// Unique identifier - overriding to match the parent class's Id? return type
  @override
  Id? get id {
    final idStr = getAttribute<String>('id');
    return idStr != null ? Id(idStr) : null;
  }

  /// Set id value
  set idValue(String value) => setAttribute('id', value);

  /// Name of the project
  String get name => _name;
  set name(String value) => _name = value;

  /// Description of the project
  String get description => _description;
  set description(String value) => _description = value;

  /// Status of the project
  ProjectStatus get status => _status;
  set status(ProjectStatus value) => _status = value;

  /// Associated domain code
  String get domainCode => _domainCode;
  set domainCode(String value) => _domainCode = value;

  /// Associated model code
  String? get modelCode => _modelCode;
  set modelCode(String? value) => _modelCode = value;

  /// When the project was created
  DateTime get createdAt => _createdAt;

  /// When the project was last updated
  DateTime get updatedAt => _updatedAt;
  set updatedAt(DateTime value) => _updatedAt = value;

  /// List of environments configured for this project
  List<DeploymentEnvironment> get environments => _environments;
  set environments(List<DeploymentEnvironment> value) => _environments = value;

  /// List of deployments for this project
  List<DeploymentEntity> get deployments => _deployments;

  /// Constructor that initializes concept for the Entity
  ProjectEntity() {
    final domain = Domain('ProjectDomain');
    var concept = Concept(Model(domain, 'ProjectModel'), 'Project');

    // Define attributes matching our fields
    var idAttr = Attribute(concept, 'id');
    idAttr.type = domain.getType('String');
    concept.attributes.add(idAttr);

    var nameAttr = Attribute(concept, 'name');
    nameAttr.type = domain.getType('String');
    nameAttr.required = true;
    concept.attributes.add(nameAttr);

    var descriptionAttr = Attribute(concept, 'description');
    descriptionAttr.type = domain.getType('String');
    descriptionAttr.required = true;
    concept.attributes.add(descriptionAttr);

    var statusAttr = Attribute(concept, 'status');
    statusAttr.type = domain.getType('ProjectStatus');
    concept.attributes.add(statusAttr);

    var domainCodeAttr = Attribute(concept, 'domainCode');
    domainCodeAttr.type = domain.getType('String');
    domainCodeAttr.required = true;
    concept.attributes.add(domainCodeAttr);

    var modelCodeAttr = Attribute(concept, 'modelCode');
    modelCodeAttr.type = domain.getType('String');
    concept.attributes.add(modelCodeAttr);

    var createdAtAttr = Attribute(concept, 'createdAt');
    createdAtAttr.type = domain.getType('DateTime');
    concept.attributes.add(createdAtAttr);

    var updatedAtAttr = Attribute(concept, 'updatedAt');
    updatedAtAttr.type = domain.getType('DateTime');
    concept.attributes.add(updatedAtAttr);

    var environmentsAttr = Attribute(concept, 'environments');
    environmentsAttr.type = domain.getType('List<DeploymentEnvironment>');
    concept.attributes.add(environmentsAttr);

    var deploymentsAttr = Attribute(concept, 'deployments');
    deploymentsAttr.type = domain.getType('List<DeploymentEntity>');
    concept.attributes.add(deploymentsAttr);

    this.concept = concept;
  }

  /// Factory constructor from the current service-layer Project
  factory ProjectEntity.fromProject(Project project) {
    final projectEntity = ProjectEntity();
    projectEntity.setAttribute('id', project.id);
    projectEntity._name = project.name;
    projectEntity._description = project.description;
    projectEntity._status = project.status;
    projectEntity._domainCode = project.domainCode;
    projectEntity._modelCode = project.modelCode;
    projectEntity._createdAt = project.createdAt;
    projectEntity._updatedAt = project.updatedAt;
    projectEntity._environments = project.environments;
    projectEntity._deployments = project.deployments
        .map((d) => DeploymentEntity.fromDeployment(d))
        .toList();
    return projectEntity;
  }

  /// Convert to service-layer Project
  Project toProject() {
    return Project(
      id: getAttribute<String>('id') ?? '',
      name: name,
      description: description,
      domainCode: domainCode,
      modelCode: modelCode,
      status: status,
      environments: environments,
      deployments: deployments.map((d) => d.toDeployment()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a new project
  static ProjectEntity create({
    required String name,
    required String description,
    required String domainCode,
    String? modelCode,
    ProjectStatus? status,
    List<DeploymentEnvironment>? environments,
  }) {
    final projectEntity = ProjectEntity();

    // Set attributes
    projectEntity.setAttribute('id', const Uuid().v4());
    projectEntity._name = name;
    projectEntity._description = description;
    projectEntity._domainCode = domainCode;
    projectEntity._modelCode = modelCode;
    projectEntity._status = status ?? ProjectStatus.development;
    projectEntity._environments =
        environments ?? [DeploymentEnvironment.development];
    projectEntity._createdAt = DateTime.now();
    projectEntity._updatedAt = DateTime.now();
    projectEntity._deployments = [];

    // Create event data
    final eventData = {
      'name': name,
      'description': description,
      'domainCode': domainCode,
      'modelCode': modelCode,
      'status': status?.toString() ?? ProjectStatus.development.toString(),
      'environments': environments?.map((e) => e.toString()).toList() ??
          [DeploymentEnvironment.development.toString()],
    };

    // Use the Entity base class event recording method
    projectEntity.recordEvent(
      'ProjectCreated',
      'A new project was created',
      ['ProjectCreatedHandler'],
      data: eventData,
    );

    return projectEntity;
  }

  /// Add a new deployment
  DeploymentEntity addDeployment({
    required DeploymentEnvironment environment,
    required DeploymentTargetType targetType,
    String? deployedUrl,
    Map<String, String>? configuration,
  }) {
    final deployment = DeploymentEntity(
      id: const Uuid().v4(),
      projectId: getAttribute<String>('id') ?? '',
      environment: environment,
      targetType: targetType,
      deployedUrl: deployedUrl,
      status: DeploymentStatus.pending,
      configuration: configuration ?? {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      modelVersion: '1.0.0',
    );

    final updatedDeployments = List<DeploymentEntity>.from(deployments);
    updatedDeployments.add(deployment);
    _deployments = updatedDeployments;
    _updatedAt = DateTime.now();

    // Create event data
    final eventData = {
      'deploymentId': deployment.getAttribute<String>('id'),
      'environment': environment.toString(),
      'targetType': targetType.toString(),
    };

    // Use the Entity base class event recording method
    recordEvent(
      'DeploymentAdded',
      'A new deployment was added to project',
      ['DeploymentAddedHandler'],
      data: eventData,
    );

    return deployment;
  }

  /// Update project details
  void update({
    String? name,
    String? description,
    ProjectStatus? status,
    String? domainCode,
    String? modelCode,
    List<DeploymentEnvironment>? environments,
  }) {
    final updates = <String, dynamic>{};

    if (name != null && name != this.name) {
      updates['name'] = name;
      this.name = name;
    }

    if (description != null && description != this.description) {
      updates['description'] = description;
      this.description = description;
    }

    if (status != null && status != this.status) {
      updates['status'] = status.toString();
      this.status = status;
    }

    if (domainCode != null && domainCode != this.domainCode) {
      updates['domainCode'] = domainCode;
      this.domainCode = domainCode;
    }

    if (modelCode != null && modelCode != this.modelCode) {
      updates['modelCode'] = modelCode;
      this.modelCode = modelCode;
    }

    if (environments != null) {
      updates['environments'] = environments.map((e) => e.toString()).toList();
      this.environments = environments;
    }

    if (updates.isNotEmpty) {
      _updatedAt = DateTime.now();

      // Record the update event using Entity base class method
      recordEvent(
        'ProjectUpdated',
        'Project details were updated',
        ['ProjectUpdatedHandler'],
        data: updates,
      );
    }
  }

  @override
  void applyEvent(dynamic event) {
    switch (event.name) {
      case 'ProjectCreated':
        setAttribute('id', const Uuid().v4());
        _name = event.data['name'];
        _description = event.data['description'];
        _domainCode = event.data['domainCode'];
        _modelCode = event.data['modelCode'];

        // Parse status
        final statusStr = event.data['status'];
        for (var s in ProjectStatus.values) {
          if (statusStr.contains(s.toString())) {
            _status = s;
            break;
          }
        }

        // Parse environments
        final envList = event.data['environments'] as List;
        final environments = <DeploymentEnvironment>[];
        for (var envStr in envList) {
          for (var env in DeploymentEnvironment.values) {
            if (envStr.toString().contains(env.toString())) {
              environments.add(env);
              break;
            }
          }
        }
        _environments = environments;

        _deployments = [];
        _createdAt = DateTime.now();
        _updatedAt = DateTime.now();
        break;

      case 'ProjectUpdated':
        if (event.data.containsKey('name')) {
          _name = event.data['name'];
        }
        if (event.data.containsKey('description')) {
          _description = event.data['description'];
        }
        if (event.data.containsKey('domainCode')) {
          _domainCode = event.data['domainCode'];
        }
        if (event.data.containsKey('modelCode')) {
          _modelCode = event.data['modelCode'];
        }
        if (event.data.containsKey('status')) {
          final statusStr = event.data['status'];
          for (var s in ProjectStatus.values) {
            if (statusStr.contains(s.toString())) {
              _status = s;
              break;
            }
          }
        }
        if (event.data.containsKey('environments')) {
          final envList = event.data['environments'] as List;
          final environments = <DeploymentEnvironment>[];
          for (var envStr in envList) {
            for (var env in DeploymentEnvironment.values) {
              if (envStr.toString().contains(env.toString())) {
                environments.add(env);
                break;
              }
            }
          }
          _environments = environments;
        }
        _updatedAt = DateTime.now();
        break;

      case 'DeploymentAdded':
        // This is handled by adding the deployment directly to the deployments list
        break;
    }
  }

  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();

    // Validate project name
    if (name.isEmpty) {
      exceptions.add(ValidationException('name', 'Project name cannot be empty',
          entity: this));
    }

    // Validate project description
    if (description.isEmpty) {
      exceptions.add(ValidationException(
          'description', 'Project description cannot be empty',
          entity: this));
    }

    // Validate domain code
    if (domainCode.isEmpty) {
      exceptions.add(ValidationException(
          'domainCode', 'Domain code must be specified',
          entity: this));
    }

    // Validate environments list is not empty
    if (environments.isEmpty) {
      exceptions.add(ValidationException(
          'environments', 'Project must have at least one environment',
          entity: this));
    }

    return exceptions;
  }
}

/// DeploymentEntity represents a deployment in our domain model
///
/// Although not an AggregateRoot itself, it is an important entity within
/// the Project aggregate
class DeploymentEntity extends Entity<DeploymentEntity> {
  /// Unique identifier
  String get _id => getAttribute<String>('id') ?? '';
  set _id(String value) => setAttribute('id', value);

  /// Project ID this deployment belongs to
  String get _projectId => getAttribute<String>('projectId') ?? '';
  set _projectId(String value) => setAttribute('projectId', value);

  /// Environment for this deployment
  DeploymentEnvironment get _environment =>
      getAttribute<DeploymentEnvironment>('environment') ??
      DeploymentEnvironment.development;
  set _environment(DeploymentEnvironment value) =>
      setAttribute('environment', value);

  /// Type of deployment target
  DeploymentTargetType get _targetType =>
      getAttribute<DeploymentTargetType>('targetType') ??
      DeploymentTargetType.firebaseHosting;
  set _targetType(DeploymentTargetType value) =>
      setAttribute('targetType', value);

  /// URL of the deployed application
  String? get _deployedUrl => getAttribute<String>('deployedUrl');
  set _deployedUrl(String? value) => setAttribute('deployedUrl', value);

  /// Status of the deployment
  DeploymentStatus get _status =>
      getAttribute<DeploymentStatus>('status') ?? DeploymentStatus.pending;
  set _status(DeploymentStatus value) => setAttribute('status', value);

  /// Configuration parameters for this deployment
  Map<String, String> get _configuration =>
      getAttribute<Map<String, String>>('configuration') ?? {};
  set _configuration(Map<String, String> value) =>
      setAttribute('configuration', value);

  /// When the deployment was created
  DateTime get _createdAt =>
      getAttribute<DateTime>('createdAt') ?? DateTime.now();
  set _createdAt(DateTime value) => setAttribute('createdAt', value);

  /// When the deployment was last updated
  DateTime get _updatedAt =>
      getAttribute<DateTime>('updatedAt') ?? DateTime.now();
  set _updatedAt(DateTime value) => setAttribute('updatedAt', value);

  /// Domain version deployed
  String get _modelVersion => getAttribute<String>('modelVersion') ?? '1.0.0';
  set _modelVersion(String value) => setAttribute('modelVersion', value);

  /// Public API that uses attributes internally

  /// Unique identifier - overriding to match the parent class's Id? return type
  @override
  Id? get id {
    final idStr = getAttribute<String>('id');
    return idStr != null ? Id(idStr) : null;
  }

  /// Project ID this deployment belongs to
  String get projectId => _projectId;

  /// Environment for this deployment
  DeploymentEnvironment get environment => _environment;

  /// Type of deployment target
  DeploymentTargetType get targetType => _targetType;

  /// URL of the deployed application
  String? get deployedUrl => _deployedUrl;
  set deployedUrl(String? value) => _deployedUrl = value;

  /// Status of the deployment
  DeploymentStatus get status => _status;
  set status(DeploymentStatus value) => _status = value;

  /// Configuration parameters for this deployment
  Map<String, String> get configuration => _configuration;
  set configuration(Map<String, String> value) => _configuration = value;

  /// When the deployment was created
  DateTime get createdAt => _createdAt;

  /// When the deployment was last updated
  DateTime get updatedAt => _updatedAt;
  set updatedAt(DateTime value) => _updatedAt = value;

  /// Domain version deployed
  String get modelVersion => _modelVersion;
  set modelVersion(String value) => _modelVersion = value;

  /// Constructor
  DeploymentEntity({
    required String id,
    required String projectId,
    required DeploymentEnvironment environment,
    required DeploymentTargetType targetType,
    String? deployedUrl,
    required DeploymentStatus status,
    required Map<String, String> configuration,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String modelVersion,
  }) {
    final domain = Domain('DeploymentDomain');
    var concept = Concept(Model(domain, 'DeploymentModel'), 'Deployment');

    // Define attributes matching our fields
    var idAttr = Attribute(concept, 'id');
    idAttr.type = domain.getType('String');
    concept.attributes.add(idAttr);

    var projectIdAttr = Attribute(concept, 'projectId');
    projectIdAttr.type = domain.getType('String');
    projectIdAttr.required = true;
    concept.attributes.add(projectIdAttr);

    var environmentAttr = Attribute(concept, 'environment');
    environmentAttr.type = domain.getType('DeploymentEnvironment');
    concept.attributes.add(environmentAttr);

    var targetTypeAttr = Attribute(concept, 'targetType');
    targetTypeAttr.type = domain.getType('DeploymentTargetType');
    concept.attributes.add(targetTypeAttr);

    var deployedUrlAttr = Attribute(concept, 'deployedUrl');
    deployedUrlAttr.type = domain.getType('String');
    concept.attributes.add(deployedUrlAttr);

    var statusAttr = Attribute(concept, 'status');
    statusAttr.type = domain.getType('DeploymentStatus');
    concept.attributes.add(statusAttr);

    var configurationAttr = Attribute(concept, 'configuration');
    configurationAttr.type = domain.getType('Map<String, String>');
    concept.attributes.add(configurationAttr);

    var createdAtAttr = Attribute(concept, 'createdAt');
    createdAtAttr.type = domain.getType('DateTime');
    concept.attributes.add(createdAtAttr);

    var updatedAtAttr = Attribute(concept, 'updatedAt');
    updatedAtAttr.type = domain.getType('DateTime');
    concept.attributes.add(updatedAtAttr);

    var modelVersionAttr = Attribute(concept, 'modelVersion');
    modelVersionAttr.type = domain.getType('String');
    concept.attributes.add(modelVersionAttr);

    this.concept = concept;

    // Set values
    _id = id;
    _projectId = projectId;
    _environment = environment;
    _targetType = targetType;
    _deployedUrl = deployedUrl;
    _status = status;
    _configuration = configuration;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _modelVersion = modelVersion;
  }

  /// Factory constructor from the current service-layer Deployment
  factory DeploymentEntity.fromDeployment(Deployment deployment) {
    return DeploymentEntity(
      id: deployment.id,
      projectId: deployment.projectId,
      environment: deployment.environment,
      targetType: deployment.targetType,
      deployedUrl: deployment.deployedUrl,
      status: deployment.status,
      configuration: deployment.configuration,
      createdAt: deployment.createdAt,
      updatedAt: deployment.updatedAt,
      modelVersion: deployment.modelVersion,
    );
  }

  /// Convert to service-layer Deployment
  Deployment toDeployment() {
    return Deployment(
      id: getAttribute<String>('id') ?? '',
      projectId: projectId,
      environment: environment,
      targetType: targetType,
      deployedUrl: deployedUrl,
      status: status,
      configuration: configuration,
      createdAt: createdAt,
      updatedAt: updatedAt,
      modelVersion: modelVersion,
    );
  }

  /// Update deployment status
  void updateStatus(DeploymentStatus newStatus) {
    status = newStatus;
    updatedAt = DateTime.now();
  }

  /// Update deployment URL
  void updateDeployedUrl(String url) {
    deployedUrl = url;
    updatedAt = DateTime.now();
  }
}
