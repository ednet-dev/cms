part of ednet_core;

class SetParentCommand extends IEntityCommand {
  SetParentCommand(DomainSession session, Entity entity, String property,
      Object after)
      : super(session, entity, property, after) {
    category = 'parent';
  }
}
