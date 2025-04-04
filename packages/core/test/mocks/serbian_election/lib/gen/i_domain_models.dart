part of '../serbian_election_core.dart';

class SerbianElectionModels extends DomainModels {
  SerbianElectionModels(Domain domain) : super(domain) {
    final model = Model(domain, 'SerbianElection');
    final electionModel = SerbianElectionModel(model);
    add(electionModel);
  }
}
