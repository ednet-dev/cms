part of ednet_core;

abstract class IEntity<E extends IEntity<E>> implements Comparable {
  Concept get concept;

  IValidationExceptions get exceptions;

  Oid get oid;

  IId? get id;

  String? get code;

  /// Log
  DateTime? whenAdded;
  DateTime? whenSet;
  DateTime? whenRemoved;

  K? getAttribute<K>(String attributeCode);

  bool preSetAttribute(String name, Object value);

  bool setAttribute(String name, Object value);

  bool postSetAttribute(String name, Object value);

  String getStringFromAttribute(String name);

  String? getStringOrNullFromAttribute(String name);

  bool setStringToAttribute(String name, String string);

  Object? getParent(String name);

  bool setParent(String name, entity);

  Object? getChild(String name);

  bool setChild(String name, Object entities);

  E copy();

  String toJson();

  void fromJson<K extends Entity<K>>(String entityJson);
}
