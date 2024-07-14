part of ednet_core;

abstract class IBasicCommand implements ICommand {
  final String name;
  late String category;
  String state = 'started';
  String description;
  final DomainSession session;
  bool partOfTransaction = false;
  List<Event> events = [];

  IBasicCommand(
    this.name,
    this.session, {
    this.description = 'Basic command',
  });

  @override
  Event get successEvent => Event.SuccessEvent(name, description, [], null);

  @override
  Event get failureEvent => Event.FailureEvent(name, description, [], null);

  @override
  bool doIt();

  @override
  bool undo();

  @override
  bool redo();

  bool get started => state == 'started' ? true : false;

  @override
  bool get done => state == 'done' ? true : false;

  @override
  bool get undone => state == 'undone' ? true : false;

  @override
  bool get redone => state == 'redone' ? true : false;

  @override
  toString() => 'command: $name; state: $state -- description: $description';

  @override
  List<Event> getEvents() {
    return events;
  }

  void addEvent(Event event) {
    events.add(event);
  }

  display({String title = 'BasicCommand'}) {
    print('');
    print('======================================');
    print('$title                                ');
    print('======================================');
    print('');
    print('$this');
    print('');
  }
}
