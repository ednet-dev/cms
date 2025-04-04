import 'package:ednet_core/ednet_core.dart';
import '../core/model/serbian_election_model.dart';
import '../../serbian_election/lib/src/domain/serbian_election_domain.dart';
import '../../serbian_election/lib/src/entities/model_entries.dart';

/// Serbian election repository
class SerbianElectionRepo extends CoreRepository {
  static const String repo = 'SerbianElectionRepo';

  SerbianElectionRepo([String code = repo]) : super(code) {
    final srbDomain = Domain(SerbianElectionModel.MODEL_DOMAIN);
    domains.add(srbDomain);

    // Initialize model
    final serbianElectionModel = SerbianElectionModel.initModel(srbDomain);

    // Create entries
    final serbianElectionEntries = SerbianElectionEntries(serbianElectionModel);

    // Add domain models
    add(SerbianElectionDomain(srbDomain, serbianElectionEntries));
  }
}
