part of ednet_core;

class Past implements IPast {
  int cursor = 0;
  @override
  List<IBasicCommand> commands;

  List<IPastCommand> pastReactions;

  Past({
    commands,
    pastReactions,
  })  : commands = commands ?? [],
        pastReactions = pastReactions ?? [];

  @override
  bool get empty => commands.isEmpty;

  @override
  bool get undoLimit => empty || cursor == 0;

  @override
  bool get redoLimit => empty || cursor == commands.length;

  @override
  void add(ICommand action) {
    _removeRightOfCursor();
    commands.add(action as IBasicCommand);
    _moveCursorForward();
  }

  void _removeRightOfCursor() {
    for (int i = commands.length - 1; i >= cursor; i--) {
      commands.removeRange(i, i + 1);
    }
  }

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

  void _moveCursorForward() {
    cursor++;
    _notifyUndoRedo();
  }

  void _moveCursorBackward() {
    if (cursor > 0) {
      cursor--;
    }
    _notifyUndoRedo();
  }

  @override
  void clear() {
    cursor = 0;
    commands.clear();
    _notifyUndoRedo();
  }

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

  bool undoAll() {
    bool allUndone = true;
    while (cursor > 0) {
      if (!undo()) {
        allUndone = false;
      }
    }
    return allUndone;
  }

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

  @override
  void startPastReaction(IPastCommand reaction) {
    pastReactions.add(reaction);
  }

  @override
  void cancelPastReaction(IPastCommand reaction) {
    pastReactions.remove(reaction);
  }

  @override
  void notifyCannotUndo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCannotUndo();
    }
  }

  @override
  void notifyCanUndo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCanUndo();
    }
  }

  @override
  void notifyCanRedo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCanRedo();
    }
  }

  @override
  void notifyCannotRedo() {
    for (IPastCommand reaction in pastReactions) {
      reaction.reactCannotRedo();
    }
  }

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
