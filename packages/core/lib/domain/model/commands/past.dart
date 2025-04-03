part of ednet_core;

/// A concrete implementation of [IPast] that manages a history of commands.
///
/// This class provides functionality for executing, undoing, and redoing commands
/// while maintaining a cursor position in the command history. It also manages
/// reactions to changes in undo/redo capabilities.
///
/// Example usage:
/// ```dart
/// final past = Past(
///   commands: [command1, command2],
///   pastReactions: [reaction1, reaction2],
/// );
///
/// // Execute a command
/// past.add(newCommand);
/// past.doIt();
///
/// // Undo the last command
/// past.undo();
///
/// // Redo the undone command
/// past.redo();
/// ```
class Past implements IPast {
  /// The current position in the command history.
  int cursor = 0;

  /// The list of commands in the history.
  @override
  List<IBasicCommand> commands;

  /// The list of reactions to changes in undo/redo capabilities.
  List<IPastCommand> pastReactions;

  /// Creates a new [Past] instance.
  ///
  /// [commands] is an optional list of initial commands.
  /// [pastReactions] is an optional list of initial reactions.
  Past({
    commands,
    pastReactions,
  })  : commands = commands ?? [],
        pastReactions = pastReactions ?? [];

  /// Returns true if there are no commands in the history.
  @override
  bool get empty => commands.isEmpty;

  /// Returns true if undo operation is not possible (at the beginning of history).
  @override
  bool get undoLimit => empty || cursor == 0;

  /// Returns true if redo operation is not possible (at the end of history).
  @override
  bool get redoLimit => empty || cursor == commands.length;

  /// Adds a new command to the history.
  ///
  /// [action] is the command to be added. Any commands after the current cursor
  /// position will be removed before adding the new command.
  @override
  void add(ICommand action) {
    _removeRightOfCursor();
    commands.add(action as IBasicCommand);
    _moveCursorForward();
  }

  /// Removes all commands after the current cursor position.
  void _removeRightOfCursor() {
    for (int i = commands.length - 1; i >= cursor; i--) {
      commands.removeRange(i, i + 1);
    }
  }

  /// Notifies all registered reactions about changes in undo/redo capabilities.
  void _notifyUndoRedo() {
    if (undoLimit) {
      notifyCannotUndo();
    } else {
      notifyCanUndo();
    }
    if (redoLimit) {
      notifyCannotRedo();
    } else {
      notifyCanRedo();
    }
  }

  /// Moves the cursor forward and notifies reactions.
  void _moveCursorForward() {
    cursor++;
    _notifyUndoRedo();
  }

  /// Moves the cursor backward and notifies reactions.
  void _moveCursorBackward() {
    if (cursor > 0) {
      cursor--;
    }
    _notifyUndoRedo();
  }

  /// Clears all commands from the history and resets the cursor.
  @override
  void clear() {
    cursor = 0;
    commands.clear();
    _notifyUndoRedo();
  }

  /// Executes the command at the current cursor position.
  ///
  /// Returns true if the command was executed successfully, false otherwise.
  @override
  bool doIt() {
    bool done = false;
    if (!empty) {
      IBasicCommand action = commands[cursor];
      done = action.doIt();
      _moveCursorForward();
    }
    return done;
  }

  /// Undoes the command at the current cursor position.
  ///
  /// Returns true if the command was undone successfully, false otherwise.
  @override
  bool undo() {
    bool undone = false;
    if (!empty) {
      _moveCursorBackward();
      IBasicCommand action = commands[cursor];
      undone = action.undo();
    }
    return undone;
  }

  /// Redoes the command at the current cursor position.
  ///
  /// Returns true if the command was redone successfully, false otherwise.
  @override
  bool redo() {
    bool redone = false;
    if (!empty && !redoLimit) {
      IBasicCommand action = commands[cursor];
      redone = action.redo();
      _moveCursorForward();
    }
    return redone;
  }

  /// Executes all commands from the beginning of the history.
  ///
  /// Returns true if all commands were executed successfully, false otherwise.
  bool doAll() {
    bool allDone = true;
    cursor = 0;
    while (cursor < commands.length) {
      if (!doIt()) {
        allDone = false;
      }
    }
    return allDone;
  }

  /// Undoes all commands from the current position to the beginning.
  ///
  /// Returns true if all commands were undone successfully, false otherwise.
  bool undoAll() {
    bool allUndone = true;
    while (cursor > 0) {
      if (!undo()) {
        allUndone = false;
      }
    }
    return allUndone;
  }

  /// Redoes all commands from the current position to the end.
  ///
  /// Returns true if all commands were redone successfully, false otherwise.
  bool redoAll() {
    bool allRedone = true;
    cursor = 0;
    while (cursor < commands.length) {
      if (!redo()) {
        allRedone = false;
      }
    }
    return allRedone;
  }

  /// Registers a new past reaction to receive undo/redo state notifications.
  @override
  void startPastReaction(IPastCommand reaction) {
    pastReactions.add(reaction);
  }

  /// Unregisters a past reaction from receiving undo/redo state notifications.
  @override
  void cancelPastReaction(IPastCommand reaction) {
    pastReactions.remove(reaction);
  }

  /// Notifies all registered reactions that undo operations are no longer possible.
  @override
  void notifyCannotUndo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCannotUndo();
    }
  }

  /// Notifies all registered reactions that undo operations are now possible.
  @override
  void notifyCanUndo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCanUndo();
    }
  }

  /// Notifies all registered reactions that redo operations are now possible.
  @override
  void notifyCanRedo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCanRedo();
    }
  }

  /// Notifies all registered reactions that redo operations are no longer possible.
  @override
  void notifyCannotRedo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCannotRedo();
    }
  }

  /// Displays the current state of the command history.
  ///
  /// [title] is an optional title for the display output.
  void display([String title = 'Past Commands']) {
    print('');
    print('======================================');
    print('$title                                ');
    print('======================================');
    print('');
    print('cursor: $cursor');
    for (IBasicCommand command in commands) {
      command.display();
    }
    print('');
  }
}
