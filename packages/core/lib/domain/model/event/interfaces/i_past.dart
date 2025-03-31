part of ednet_core;

/// Interface defining a command history or undo/redo stack in the domain model.
///
/// This interface represents a component that maintains a history of commands
/// and provides functionality for executing, undoing, and redoing commands.
/// It extends [ISourceOfPastReaction] to allow other components to react to
/// changes in the command history.
///
/// Example usage:
/// ```dart
/// class CommandHistory implements IPast {
///   final List<ICommand> _commands = [];
///   int _currentIndex = -1;
///
///   @override
///   void add(ICommand command) {
///     _commands.add(command);
///     _currentIndex = _commands.length - 1;
///   }
///
///   @override
///   List<ICommand> get commands => List.unmodifiable(_commands);
///
///   @override
///   void clear() {
///     _commands.clear();
///     _currentIndex = -1;
///   }
///
///   @override
///   bool get empty => _commands.isEmpty;
///
///   @override
///   bool get undoLimit => _currentIndex < 0;
///
///   @override
///   bool get redoLimit => _currentIndex >= _commands.length - 1;
///
///   @override
///   bool doIt() {
///     if (redoLimit) return false;
///     _currentIndex++;
///     return _commands[_currentIndex].execute();
///   }
///
///   @override
///   bool undo() {
///     if (undoLimit) return false;
///     _currentIndex--;
///     return true;
///   }
///
///   @override
///   bool redo() {
///     if (redoLimit) return false;
///     _currentIndex++;
///     return _commands[_currentIndex].execute();
///   }
/// }
/// ```
abstract class IPast implements ISourceOfPastReaction {
  /// Adds a new command to the history.
  ///
  /// [command] is the command to be added to the history.
  /// This should be called before executing a new command.
  void add(ICommand command);

  /// Returns the list of all commands in the history.
  ///
  /// The returned list should be unmodifiable to prevent external changes
  /// to the command history.
  List<ICommand> get commands;

  /// Clears all commands from the history.
  ///
  /// This resets the command history to its initial state.
  void clear();

  /// Returns true if there are no commands in the history.
  bool get empty;

  /// Returns true if undo operation is not possible (at the beginning of history).
  bool get undoLimit;

  /// Returns true if redo operation is not possible (at the end of history).
  bool get redoLimit;

  /// Executes the next command in the history.
  ///
  /// Returns true if the command was executed successfully, false otherwise.
  bool doIt();

  /// Undoes the last executed command.
  ///
  /// Returns true if the command was undone successfully, false if at undo limit.
  bool undo();

  /// Redoes the last undone command.
  ///
  /// Returns true if the command was redone successfully, false if at redo limit.
  bool redo();
}
