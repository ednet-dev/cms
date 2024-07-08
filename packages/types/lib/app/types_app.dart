part of ednet_core_types_app;

class TypesApp {
  late TypesEntries model;

  TypesApp(EDNetCoreModels domain) {
    model = domain.getModelEntries('Types') as TypesEntries;
    _load(model);
    EntitiesTableWc(this, model.types);
  }

  void _load(TypesEntries model) {
    final json = window.localStorage['ednet_core_types_data'];
    if (json != null && model.isEmpty) {
      model.fromJson(json);
    }
  }

  void save() {
    window.localStorage['ednet_core_types_data'] = model.toJson();
  }
}
