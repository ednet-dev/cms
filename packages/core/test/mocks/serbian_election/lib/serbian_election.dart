/// Serbian Election System domain model implemented using ednet_core
/// This library models the electoral system of Serbia using domain-driven design
/// principles, implementing concepts like voters, political parties, coalitions,
/// electoral lists, candidates, electoral units, and votes with Serbian terms.
library serbian_election;

// Model exports
export 'src/model.dart';

// Entities
export 'src/entities.dart';

// Utilities
export 'src/dhondt_calculator.dart';
export 'src/demographics_generator.dart';

// Repository
export 'src/repository.dart';

// Domain
export 'src/domain.dart';
