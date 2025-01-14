part of ednet_core;

abstract class IEntityCommand extends IBasicCommand {
  Entity entity;
  String property;
  Object? before;
  Object after;

  IEntityCommand(DomainSession session, this.entity, this.property, this.after)
      : before = entity.getAttribute(property),
        super('set', session);

  @override
  bool doIt() {
    bool done = false;
    if (state == 'started') {
      if (name == 'set' && category == 'attribute') {
        done = entity.setAttribute(property, after);
      } else if (name == 'set' && category == 'parent') {
        done = entity.setParent(property, after as Entity);
      } else if (name == 'set' && category == 'child') {
        done = entity.setChild(property, after);
      } else {
        throw CommandException(
            'Allowed commands on entity for doIt are set attribute, parent or child.');
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
      if (name == 'set' && category == 'attribute') {
        undone = entity.setAttribute(property, before);
      } else if (name == 'set' && category == 'parent') {
        undone = entity.setParent(property, before as Entity);
      } else if (name == 'set' && category == 'child') {
        undone = entity.setChild(property, before!);
      } else {
        throw CommandException(
            'Allowed commands on entity for undo are set attribute, parent or child.');
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
      if (name == 'set' && category == 'attribute') {
        redone = entity.setAttribute(property, after);
      } else if (name == 'set' && category == 'parent') {
        redone = entity.setParent(property, after as Entity<Entity>);
      } else if (name == 'set' && category == 'child') {
        redone = entity.setChild(property, after);
      } else {
        throw CommandException(
            'Allowed commands on entity for redo are set attribute, parent or child.');
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

  @override
  toString() => 'command: $name; category: $category; state: $state -- '
      'property: $property; before: $before; after: $after';
}
