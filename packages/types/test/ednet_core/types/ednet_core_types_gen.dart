// test/ednet_core/types/ednet_core_types_gen.dart

import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_types/ednet_core_types.dart';

void genCode(CoreRepository repository) {
  repository.gen('ednet_core_types');
}

void initData(CoreRepository repository) {
  final ednetCoreDomain = repository.getDomainModels('EDNetCore');
  final typesModel = ednetCoreDomain?.getModelEntries('Types');
  (typesModel as TypesModel).init();
  //typesModel.display();
}

void main() {
  final repository = CoreRepository();
  genCode(repository);
  //initData(repository);
}
