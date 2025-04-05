part of '../../project_core.dart';

// lib/gen/project/i_domain_models.dart
class ProjectModels extends DomainModels {
  ProjectModels(Domain domain) : super(domain) {
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart

    final model = fromJsonToModel(
      '',
      domain,
      'Core',
      loadYaml(projectCoreModelYaml) as Map<dynamic, dynamic>,
    );
    final coreModel = CoreModel(model);
    add(coreModel);

  }

}
