part of ednet_core;

/// Interface defining a reaction to a command in the domain model.
///
/// This interface represents a component that can react to domain commands.
/// It is part of the command pattern implementation, allowing for decoupled
/// command handling and reaction logic.
///
/// Example usage:
/// ```dart
/// class UserCreationReaction implements ICommandReaction {
///   @override
///   void react(ICommand action) {
///     if (action is CreateUserCommand) {
///       // Handle user creation
///     }
///   }
/// }
/// ```
abstract class ICommandReaction {
  /// Reacts to a domain command.
  ///
  /// [action] is the command that triggered this reaction.
  /// Implementations should define specific behavior based on the command type.
  void react(ICommand action);
}
