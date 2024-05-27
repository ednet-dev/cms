part of ednet_core;

class DomainModels implements IDomainModels {
  final Domain _domain;

  final Map<String, ModelEntries> _modelEntriesMap;

  // for transactions to be able to use multiple models
  final List<ICommandReaction> _actionReactions;

  DomainModels(this._domain)
      : _modelEntriesMap = <String, ModelEntries>{},
        _actionReactions = <ICommandReaction>[];

  void addModelEntries(ModelEntries modelEntries) {
    var domainCode = modelEntries.model.domain.code;
    if (_domain.code != domainCode) {
      var msg = 'The $domainCode domain of the model is different from '
          'the ${_domain.code} domain.';
      throw CodeException(msg);
    }
    var modelCode = modelEntries.model.code;
    var entries = _modelEntriesMap[modelCode];
    if (entries == null) {
      _modelEntriesMap[modelCode] = modelEntries;
    } else {
      throw CodeException(
          'The $modelCode model exists already in the ${_domain.code} domain.');
    }
  }

  @override
  Domain get domain => _domain;

  @override
  Model? getModel(String modelCode) {
    return _domain.getModel(modelCode);
  }

  @override
  ModelEntries? getModelEntries(String modelCode) =>
      _modelEntriesMap[modelCode];

  @override
  DomainSession newSession() {
    return DomainSession(this);
  }

  @override
  void startCommandReaction(ICommandReaction reaction) {
    _actionReactions.add(reaction);
  }

  @override
  void cancelCommandReaction(ICommandReaction reaction) {
    int index = _actionReactions.indexOf(reaction, 0);
    _actionReactions.removeRange(index, 1);
  }

  @override
  void add(IModelEntries modelEntries) {
    addModelEntries(modelEntries as ModelEntries);
  }

  @override
  void notifyCommandReactions(ICommand action) {
    for (ICommandReaction reaction in _actionReactions) {
      reaction.react(action);
    }
  }
}
