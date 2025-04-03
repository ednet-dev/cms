part of ednet_core;

/// Manages a collection of domain models within a specific domain.
///
/// The [DomainModels] class is central to the EDNet Core framework, providing:
/// - Model registration and lookup
/// - Session management
/// - Command reaction handling
/// - Transaction support
///
/// This class implements [IDomainModels] and ensures:
/// - Domain consistency
/// - Model isolation
/// - Command reaction propagation
/// - Session lifecycle management
///
/// Example usage:
/// ```dart
/// final domain = Domain('OrderManagement');
/// final domainModels = DomainModels(domain);
///
/// // Add model entries
/// domainModels.addModelEntries(orderModelEntries);
///
/// // Create a new session
/// final session = domainModels.newSession();
///
/// // Start command reactions
/// domainModels.startCommandReaction(orderReaction);
/// ```
class DomainModels implements IDomainModels {
  /// The domain that owns these models.
  final Domain _domain;

  /// Maps model codes to their corresponding entries.
  /// This provides fast lookup of model entries by code.
  final Map<String, ModelEntries> _modelEntriesMap;

  /// List of command reactions that respond to command execution.
  /// Used for cross-model interactions and transaction support.
  final List<ICommandReaction> _actionReactions;

  /// Creates a new [DomainModels] instance for the given [domain].
  ///
  /// Initializes:
  /// - An empty model entries map
  /// - An empty command reactions list
  ///
  /// Parameters:
  /// - [domain]: The domain that owns these models
  DomainModels(this._domain)
    : _modelEntriesMap = <String, ModelEntries>{},
      _actionReactions = <ICommandReaction>[];

  /// Adds model entries to this domain models collection.
  ///
  /// This method:
  /// - Validates domain consistency
  /// - Ensures model uniqueness
  /// - Registers the model entries
  ///
  /// Parameters:
  /// - [modelEntries]: The model entries to add
  ///
  /// Throws:
  /// - [CodeException] if domain mismatch or duplicate model
  void addModelEntries(ModelEntries modelEntries) {
    var domainCode = modelEntries.model.domain.code;
    if (_domain.code != domainCode) {
      var msg =
          'The $domainCode domain of the model is different from '
          'the ${_domain.code} domain.';
      throw CodeException(msg);
    }
    var modelCode = modelEntries.model.code;
    var entries = _modelEntriesMap[modelCode];
    if (entries == null) {
      _modelEntriesMap[modelCode] = modelEntries;
    } else {
      throw CodeException(
        'The $modelCode model exists already in the ${_domain.code} domain.',
      );
    }
  }

  @override
  Domain get domain => _domain;

  /// Retrieves a model by its code.
  ///
  /// Parameters:
  /// - [modelCode]: The code of the model to retrieve
  ///
  /// Returns:
  /// The model if found, null otherwise
  @override
  Model? getModel(String modelCode) {
    return _domain.getModel(modelCode);
  }

  /// Retrieves model entries by model code.
  ///
  /// Parameters:
  /// - [modelCode]: The code of the model entries to retrieve
  ///
  /// Returns:
  /// The model entries if found, null otherwise
  @override
  ModelEntries? getModelEntries(String modelCode) =>
      _modelEntriesMap[modelCode];

  /// Creates a new domain session for executing commands.
  ///
  /// Returns:
  /// A new [DomainSession] instance
  @override
  DomainSession newSession() {
    return DomainSession(this);
  }

  /// Registers a command reaction to be notified of command execution.
  ///
  /// Parameters:
  /// - [reaction]: The command reaction to register
  @override
  void startCommandReaction(ICommandReaction reaction) {
    _actionReactions.add(reaction);
  }

  /// Removes a command reaction from notification.
  ///
  /// Parameters:
  /// - [reaction]: The command reaction to remove
  @override
  void cancelCommandReaction(ICommandReaction reaction) {
    int index = _actionReactions.indexOf(reaction, 0);
    _actionReactions.removeRange(index, 1);
  }

  /// Adds model entries to this collection.
  ///
  /// This is an implementation of the [IDomainModels] interface.
  ///
  /// Parameters:
  /// - [modelEntries]: The model entries to add
  @override
  void add(IModelEntries modelEntries) {
    addModelEntries(modelEntries as ModelEntries);
  }

  /// Notifies all registered command reactions of a command execution.
  ///
  /// Parameters:
  /// - [action]: The command that was executed
  @override
  void notifyCommandReactions(ICommand action) {
    for (ICommandReaction reaction in _actionReactions) {
      reaction.react(action);
    }
  }
}
