part of ednet_core;

abstract class ICommand {
  bool get done;

  bool get undone;

  bool get redone;

  bool doIt();

  bool undo();

  bool redo();
}

