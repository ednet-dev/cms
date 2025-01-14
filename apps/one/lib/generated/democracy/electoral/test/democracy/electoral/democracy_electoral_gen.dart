
// test/democracy/electoral/democracy_electoral_gen.dart

import 'package:ednet_core/ednet_core.dart';

import '../../../lib/democracy_electoral.dart';

void genCode(CoreRepository repository) {
  repository.gen('democracy_electoral');
}

void initData(CoreRepository repository) {
  final democracyDomain =
    repository.getDomainModels('Democracy');
  final electoralModel =
    democracyDomain?.getModelEntries('Electoral') as ElectoralModel?;
  electoralModel?.init();
  //electoralModel.display();
}

void main() {
  final repository = CoreRepository();
  genCode(repository);
  //initData(repository);
}

