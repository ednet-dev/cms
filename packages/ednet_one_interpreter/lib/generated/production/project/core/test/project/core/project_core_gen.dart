
// test/project/core/project_core_gen.dart

import 'package:ednet_core/ednet_core.dart';

import '../../../lib/project_core.dart';

void genCode(CoreRepository repository) {
  repository.gen('project_core');
}

void initData(CoreRepository repository) {
  final projectDomain =
    repository.getDomainModels('Project');
  final coreModel =
    projectDomain?.getModelEntries('Core') as CoreModel?;
  coreModel?.init();
  //coreModel.display();
}

void main() {
  final repository = CoreRepository();
  genCode(repository);
  //initData(repository);
}

