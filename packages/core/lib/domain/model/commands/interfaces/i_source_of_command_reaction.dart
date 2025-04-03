part of ednet_core;

/// Interface defining a source of command reactions in the domain model.
///
/// This interface represents a component that can manage command reactions,
/// allowing other components to register for and receive notifications about
/// command executions. It implements the observer pattern for command handling.
///
/// Example usage:
/// ```dart
/// class CommandManager implements ISourceOfCommandReaction {
///   final List<ICommandReaction> _reactions = [];
///
///   @override
///   void startCommandReaction(ICommandReaction reaction) {
///     _reactions.add(reaction);
///   }
///
///   @override
///   void cancelCommandReaction(ICommandReaction reaction) {
///     _reactions.remove(reaction);
///   }
///
///   @override
///   void notifyCommandReactions(ICommand action) {
///     for (final reaction in _reactions) {
///       reaction.react(action);
///     }
///   }
/// }
/// ```
abstract class ISourceOfCommandReaction {
  /// Registers a new command reaction to receive notifications.
  ///
  /// [reaction] is the component that should receive command notifications.
  /// This method should be called when a component wants to start
  /// receiving command notifications.
  void startCommandReaction(ICommandReaction reaction);

  /// Unregisters a command reaction from receiving notifications.
  ///
  /// [reaction] is the component that should no longer receive command
  /// notifications. This method should be called when a component wants
  /// to stop receiving command notifications.
  void cancelCommandReaction(ICommandReaction reaction);

  /// Notifies all registered reactions about a command execution.
  ///
  /// [action] is the command that was executed and should trigger reactions.
  /// This method should be called after a command is executed to notify
  /// all registered reactions.
  void notifyCommandReactions(ICommand action);
}
