part of ednet_core;

class SetAttributeCommand extends IEntityCommand {
  SetAttributeCommand(DomainSession session, Entity entity,
      String property, Object after)
      : super(session, entity, property, after) {
    category = 'attribute';
  }
}
