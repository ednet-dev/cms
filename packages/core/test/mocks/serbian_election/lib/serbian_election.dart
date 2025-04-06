/// Serbian Election System domain model implemented using ednet_core
/// This library models the electoral system of Serbia using domain-driven design
/// principles, implementing concepts like voters, political parties, coalitions,
/// electoral lists, candidates, electoral units, and votes with Serbian terms.
library serbian_election;

// Model exports
export 'src/model.dart';

// Entities - hiding SerbianElectionEntries to avoid conflict with repository
export 'src/entities.dart' hide SerbianElectionEntries;

// Utilities
export 'src/dhondt_calculator.dart';
export 'src/demographics_generator.dart';

// Domain
export 'src/domain.dart';

// Repository - contains SerbianElectionRepo class
export 'src/repository.dart';
