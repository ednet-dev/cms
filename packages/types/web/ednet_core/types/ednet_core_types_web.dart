// web/ednet_core/types/ednet_core_types_web.dart

import 'dart:html';

import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_default_app/ednet_core_default_app.dart';
import 'package:ednet_core_types/ednet_core_types.dart';

void initData(CoreRepository repository) {
  final ednetCoreDomain = repository.getDomainModels('EDNetCore');
  final typesModel = ednetCoreDomain?.getModelEntries('Types');
  (typesModel as TypesModel).init();
  //typesModel.display();
}

void showData(CoreRepository repository) {
  final mainView = View(document, 'main');
  mainView.repo = repository;
  RepoMainSection(mainView);
}

void main() {
  final repository = CoreRepository();
  initData(repository);
  showData(repository);
}
