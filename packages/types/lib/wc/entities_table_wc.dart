library entities_table_wc;

import 'dart:html';

import 'package:ednet_core/ednet_core.dart';

part 'entities_table_wc/entities_table.dart';
part 'entities_table_wc/entity_table.dart';

class EntitiesTableWc {
  var app;

  late EntitiesTable entitiesTable;
  late EntityTable entityTable;

  EntitiesTableWc(this.app, var entities) {
    entitiesTable = EntitiesTable(this, entities);
    entityTable = EntityTable(entitiesTable, entities);
  }

  void save() {
    app.save();
  }
}
