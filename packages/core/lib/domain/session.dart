part of ednet_core;

abstract class IDomainSession {
  IDomainModels get domainModels;

  IPast get past;
}

class DomainSession implements IDomainSession {
  final DomainModels _domainModels;
  final Past _past;
  final PolicyEngine policyEngine;

  DomainSession(this._domainModels)
      : _past = Past(),
        policyEngine =
            PolicyEngine(null); // We need to fix this circular dependency

  @override
  DomainModels get domainModels => _domainModels;

  @override
  Past get past => _past;

  void executeCommand(ICommand command) {
    if (command.doIt()) {
      past.add(command);
      for (var event in command.getEvents()) {
        // policyEngine.executePolicies(event.entity);
        print('execute policy ${event.name}');
      }
    }
  }
}
