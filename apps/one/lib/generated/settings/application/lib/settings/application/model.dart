part of settings_application;

// lib/settings/application/model.dart

class ApplicationModel extends ApplicationEntries {
  ApplicationModel(Model model) : super(model);

  void fromJsonToModel() {
    fromJson(settingsApplicationModel);
  }

  void init() {}

  // added after code gen - begin

  // added after code gen - end
}
