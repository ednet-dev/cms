part of ednet_core;

abstract class IDomainModels implements ISourceOfCommandReaction {
  void add(IModelEntries modelEntries);

  Domain get domain;

  Model? getModel(String modelCode);

  IModelEntries? getModelEntries(String modelCode);

  IDomainSession newSession();
}

