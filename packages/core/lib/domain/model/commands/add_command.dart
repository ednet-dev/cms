part of ednet_core;

class AddCommand extends IEntitiesCommand {
  AddCommand(DomainSession session, Entities entities, Entity entity)
      : super('add', session, entities, entity) {
    category = 'entity';
  }
}

