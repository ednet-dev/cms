part of ednet_core;

abstract class IPast implements ISourceOfPastReaction {
  void add(ICommand command);

  List<ICommand> get commands;

  void clear();

  bool get empty;

  bool get undoLimit;

  bool get redoLimit;

  bool doIt();

  bool undo();

  bool redo();
}
