part of ednet_core;

abstract class IBasicCommand implements ICommand {
  final String name;
  late String category;
  String state = 'started';
  String? description;
  final DomainSession session;
  bool partOfTransaction = false;

  IBasicCommand(this.name, this.session);

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

  display({String title: 'BasicCommand'}) {
    print('');
    print('======================================');
    print('$title                                ');
    print('======================================');
    print('');
    print('$this');
    print('');
  }
}
