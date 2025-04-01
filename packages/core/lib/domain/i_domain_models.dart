part of ednet_core;

/// Defines the interface for managing domain models in the EDNet Core framework.
///
/// The [IDomainModels] interface is central to the domain layer, providing:
/// - Model registration and lookup
/// - Domain session management
/// - Command reaction handling
/// - Model entries management
///
/// This interface ensures that all domain model collections:
/// - Can register new model entries
/// - Provide access to their domain
/// - Support model lookup by code
/// - Can create new domain sessions
///
/// Example usage:
/// ```dart
/// class CustomDomainModels implements IDomainModels {
///   @override
///   void add(IModelEntries modelEntries) {
///     // Implementation
///   }
///   
///   @override
///   Domain get domain => _domain;
///   
///   // ... implement other required methods
/// }
/// ```
abstract class IDomainModels implements ISourceOfCommandReaction {
  /// Adds model entries to this domain models collection.
  /// 
  /// This method:
  /// - Validates the model entries
  /// - Ensures domain consistency
  /// - Registers the entries
  /// 
  /// Parameters:
  /// - [modelEntries]: The model entries to add
  void add(IModelEntries modelEntries);

  /// The domain that owns these models.
  /// 
  /// Returns:
  /// The [Domain] instance
  Domain get domain;

  /// Retrieves a model by its code.
  /// 
  /// Parameters:
  /// - [modelCode]: The code of the model to retrieve
  /// 
  /// Returns:
  /// The [Model] if found, null otherwise
  Model? getModel(String modelCode);

  /// Retrieves model entries by model code.
  /// 
  /// Parameters:
  /// - [modelCode]: The code of the model entries to retrieve
  /// 
  /// Returns:
  /// The [IModelEntries] if found, null otherwise
  IModelEntries? getModelEntries(String modelCode);

  /// Creates a new domain session for executing commands.
  /// 
  /// Returns:
  /// A new [IDomainSession] instance
  IDomainSession newSession();
}
