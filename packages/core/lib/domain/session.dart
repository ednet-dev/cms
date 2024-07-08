part of ednet_core;

abstract class IDomainSession {
  IDomainModels get domainModels;

  IPast get past;
}

class DomainSession implements IDomainSession {
  DomainModels _domainModels;
  Past _past;

  DomainSession(this._domainModels) : _past = Past();

  @override
  DomainModels get domainModels => _domainModels;

  @override
  Past get past => _past;
}
