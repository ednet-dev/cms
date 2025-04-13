part of ednet_core_flutter;

/// Command for updating an entity
class EntityUpdateCommand {
  final Map<String, dynamic> entity;

  EntityUpdateCommand(this.entity);

  // Command execution method
  bool doIt() {
    // Command execution happens in the aggregate root
    return true;
  }

  // Undo functionality if needed
  bool undo() {
    return false;
  }

  // Command can generate events
  List<dynamic> getEvents() {
    return [];
  }
}
