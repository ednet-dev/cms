part of ednet_core;

/// Interface defining a command that can react to undo/redo state changes.
///
/// This interface represents a command that needs to be aware of and respond to
/// changes in the undo/redo capabilities of the command history. It allows
/// commands to update their state or UI based on whether undo/redo operations
/// are available.
///
/// Example usage:
/// ```dart
/// class UndoableCommand implements IPastCommand {
///   bool _canUndo = false;
///   bool _canRedo = false;
///
///   @override
///   void reactCannotUndo() {
///     _canUndo = false;
///     updateUI();
///   }
///
///   @override
///   void reactCanUndo() {
///     _canUndo = true;
///     updateUI();
///   }
///
///   @override
///   void reactCanRedo() {
///     _canRedo = true;
///     updateUI();
///   }
///
///   @override
///   void reactCannotRedo() {
///     _canRedo = false;
///     updateUI();
///   }
///
///   void updateUI() {
///     // Update UI elements based on undo/redo state
///   }
/// }
/// ```
abstract class IPastCommand {
  /// Called when an undo operation becomes impossible.
  ///
  /// This method should be implemented to handle the case where the command
  /// history reaches its beginning and undo operations are no longer possible.
  void reactCannotUndo();

  /// Called when an undo operation becomes possible.
  ///
  /// This method should be implemented to handle the case where undo operations
  /// become available after previously being unavailable.
  void reactCanUndo();

  /// Called when a redo operation becomes possible.
  ///
  /// This method should be implemented to handle the case where redo operations
  /// become available after previously being unavailable.
  void reactCanRedo();

  /// Called when a redo operation becomes impossible.
  ///
  /// This method should be implemented to handle the case where the command
  /// history reaches its end and redo operations are no longer possible.
  void reactCannotRedo();
}
