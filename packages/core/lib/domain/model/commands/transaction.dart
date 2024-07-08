part of ednet_core;

class Transaction extends IBasicCommand implements ITransaction {
  final Past _commands;

  Transaction(String name, DomainSession session)
      : _commands = Past(),
        super(name, session);

  @override
  Past get past => _commands;

  @override
  void add(command) {
    _commands.add(command);
    (command as IBasicCommand).partOfTransaction = true;
  }

  @override
  bool doIt() {
    bool done = false;
    if (state == 'started') {
      done = _commands.doAll();
      if (done) {
        state = 'done';
        session.past.add(this);
        session.domainModels.notifyCommandReactions(this);
      } else {
        _commands.undoAll();
      }
    }
    return done;
  }

  @override
  bool undo() {
    bool undone = false;
    if (state == 'done' || state == 'redone') {
      undone = _commands.undoAll();
      if (undone) {
        state = 'undone';
        session.domainModels.notifyCommandReactions(this);
      } else {
        _commands.doAll();
      }
    }
    return undone;
  }

  @override
  bool redo() {
    bool redone = false;
    if (state == 'undone') {
      redone = _commands.redoAll();
      if (redone) {
        state = 'redone';
        session.domainModels.notifyCommandReactions(this);
      } else {
        _commands.undoAll();
      }
    }
    return redone;
  }
}
