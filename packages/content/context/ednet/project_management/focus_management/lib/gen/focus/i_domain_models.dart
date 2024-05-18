part of focus_project;

// lib/gen/focus/i_domain_models.dart

class FocusModels extends DomainModels {
  FocusModels(Domain domain) : super(domain) {
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart

    Model model =
        fromJsonToModel('', domain, 'Project', loadYaml(focusProjectModelJson));
    ProjectModel projectModel = ProjectModel(model);
    add(projectModel);
  }
}
