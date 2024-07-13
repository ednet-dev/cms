part of ednet_core;

abstract class ICommand {
  String get name;
  String get category;
  String get description;
  String get successEvent;
  String get failureEvent;

  bool get done;

  bool get undone;

  bool get redone;

  bool doIt();

  bool undo();

  bool redo();

  List<Event> getEvents();
}
