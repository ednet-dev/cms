part of ednet_core;

class RemoveCommand extends IEntitiesCommand {
  RemoveCommand(DomainSession session, Entities entities, Entity entity)
      : super('remove', session, entities, entity) {
    category = 'entity';
  }
}
