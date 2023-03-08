part of ednet_core;

class SetChildCommand extends IEntityCommand {
  SetChildCommand(DomainSession session, Entity entity, String property,
      Object after)
      : super(session, entity, property, after) {
    category = 'child';
  }
}
