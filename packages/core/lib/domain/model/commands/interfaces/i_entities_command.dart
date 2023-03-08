part of ednet_core;

abstract class IEntitiesCommand extends IBasicCommand {
  Entities entities;
  Entity entity;

  IEntitiesCommand(String name, DomainSession session, this.entities, this.entity)
      : super(name, session);

  @override
  bool doIt() {
    bool done = false;
    if (state == 'started') {
      if (name == 'add') {
        done = entities.add(entity);
      } else if (name == 'remove') {
        done = entities.remove(entity);
      } else {
        throw CommandException(
            'Allowed commands on entities for doit are add or remove.');
      }
      if (done) {
        state = 'done';
        if (!partOfTransaction) {
          session.past.add(this);
          session.domainModels.notifyCommandReactions(this);
        }
      }
    }
    return done;
  }

  @override
  bool undo() {
    bool undone = false;
    if (state == 'done' || state == 'redone') {
      if (name == 'add') {
        undone = entities.remove(entity);
      } else if (name == 'remove') {
        undone = entities.add(entity);
      } else {
        throw CommandException(
            'Allowed commands on entities for undo are add or remove.');
      }
      if (undone) {
        state = 'undone';
        if (!partOfTransaction) {
          session.domainModels.notifyCommandReactions(this);
        }
      }
    }
    return undone;
  }

  @override
  bool redo() {
    bool redone = false;
    if (state == 'undone') {
      if (name == 'add') {
        redone = entities.add(entity);
      } else if (name == 'remove') {
        redone = entities.remove(entity);
      } else {
        throw CommandException(
            'Allowed commands on entities for redo are add or remove.');
      }
      if (redone) {
        state = 'redone';
        if (!partOfTransaction) {
          session.domainModels.notifyCommandReactions(this);
        }
      }
    }
    return redone;
  }
}
