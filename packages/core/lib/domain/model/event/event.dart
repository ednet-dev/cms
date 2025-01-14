part of ednet_core;

class Event {
  final String name;
  final String description;
  final List<String> handlers;
  final Entity? entity;
  final Map<String, dynamic> data;

  Event(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  Event.SuccessEvent(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  Event.FailureEvent(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  void trigger(DomainSession session) {
    // for (var handler in handlers) {
    // session.executeCommand(handler, entity, data);
    print('session handler');
    // }
  }
}
