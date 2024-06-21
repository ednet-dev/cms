part of ednet_core_types;

// lib/gen/ednet_core/i_domain_models.dart

class EDNetCoreModels extends DomainModels {
  EDNetCoreModels(Domain domain) : super(domain) {
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart

    final model =
        fromJsonToModel(ednetCoreTypesModelJson, domain, 'Types', null);
    final typesModel = TypesModel(model);
    add(typesModel);
  }
}
