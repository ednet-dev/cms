part of '../../democracy_electoral.dart';

// lib/gen/democracy/i_domain_models.dart
class DemocracyModels extends DomainModels {
  DemocracyModels(Domain domain) : super(domain) {
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart

    final model = fromJsonToModel(
      '',
      domain,
      'Electoral',
      loadYaml(democracyElectoralModelYaml) as Map<dynamic, dynamic>,
    );
    final electoralModel = ElectoralModel(model);
    add(electoralModel);

  }

}
