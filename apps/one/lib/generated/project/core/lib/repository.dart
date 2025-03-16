part of './project_core.dart';

// lib/repository.dart
class ProjectCoreRepo extends CoreRepository {
  ProjectCoreRepo([super.code = repository]) {
    final domain = Domain('Project');
    domains.add(domain);
    add(ProjectDomain(domain));
  }

  static const repository = 'ProjectCoreRepo';
}
