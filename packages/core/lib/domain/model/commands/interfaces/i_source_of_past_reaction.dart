part of ednet_core;

/// Interface defining a source of past (undo/redo) reactions in the domain model.
///
/// This interface represents a component that can manage reactions to changes
/// in the undo/redo state of the command history. It allows other components
/// to register for and receive notifications about changes in the ability to
/// perform undo and redo operations.
///
/// Example usage:
/// ```dart
/// class UndoRedoManager implements ISourceOfPastReaction {
///   final List<IPastCommand> _reactions = [];
///
///   @override
///   void startPastReaction(IPastCommand reaction) {
///     _reactions.add(reaction);
///   }
///
///   @override
///   void cancelPastReaction(IPastCommand reaction) {
///     _reactions.remove(reaction);
///   }
///
///   @override
///   void notifyCannotUndo() {
///     for (final reaction in _reactions) {
///       reaction.reactCannotUndo();
///     }
///   }
///
///   @override
///   void notifyCanUndo() {
///     for (final reaction in _reactions) {
///       reaction.reactCanUndo();
///     }
///   }
///
///   @override
///   void notifyCanRedo() {
///     for (final reaction in _reactions) {
///       reaction.reactCanRedo();
///     }
///   }
///
///   @override
///   void notifyCannotRedo() {
///     for (final reaction in _reactions) {
///       reaction.reactCannotRedo();
///     }
///   }
/// }
/// ```
abstract class ISourceOfPastReaction {
  /// Registers a new past reaction to receive undo/redo state notifications.
  ///
  /// [reaction] is the component that should receive undo/redo state notifications.
  /// This method should be called when a component wants to start receiving
  /// notifications about changes in undo/redo capabilities.
  void startPastReaction(IPastCommand reaction);

  /// Unregisters a past reaction from receiving undo/redo state notifications.
  ///
  /// [reaction] is the component that should no longer receive undo/redo state
  /// notifications. This method should be called when a component wants to stop
  /// receiving notifications about changes in undo/redo capabilities.
  void cancelPastReaction(IPastCommand reaction);

  /// Notifies all registered reactions that undo operations are no longer possible.
  ///
  /// This method should be called when the command history reaches its beginning
  /// and undo operations become impossible.
  void notifyCannotUndo();

  /// Notifies all registered reactions that undo operations are now possible.
  ///
  /// This method should be called when undo operations become available after
  /// previously being unavailable.
  void notifyCanUndo();

  /// Notifies all registered reactions that redo operations are now possible.
  ///
  /// This method should be called when redo operations become available after
  /// previously being unavailable.
  void notifyCanRedo();

  /// Notifies all registered reactions that redo operations are no longer possible.
  ///
  /// This method should be called when the command history reaches its end
  /// and redo operations become impossible.
  void notifyCannotRedo();
}
