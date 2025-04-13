part of ednet_core_flutter;

/// Factory for creating entities for the UI
class EntityFactory {
  /// Creates an entity instance from concept and data
  static Entity createEntityFromData(
      Concept concept, Map<String, dynamic> data) {
    // This is a simplified factory that creates a basic entity
    // In a real implementation, you would use proper repositories
    final entity = InternalEntity(concept);

    // Set data properties
    data.forEach((key, value) {
      try {
        entity.setAttribute(key, value);
      } catch (e) {
        // Skip attribute errors
      }
    });

    return entity;
  }
}

/// An internal entity implementation used for UI purposes
class InternalEntity implements Entity<InternalEntity> {
  final Concept _concept;
  final Map<String, dynamic> _data = {};
  late final Oid _oid = Oid();
  String? _code;
  DateTime? _whenAdded;
  DateTime? _whenSet;
  DateTime? _whenRemoved;
  final ValidationExceptions _exceptions = ValidationExceptions();
  bool _pre = false;
  bool _post = false;

  InternalEntity(this._concept) {
    _code = 'temp_entity';
    _whenAdded = DateTime.now();
  }

  @override
  Concept get concept => _concept;

  @override
  set concept(Concept concept) {
    throw UnimplementedError('Setting concept not supported in InternalEntity');
  }

  @override
  K? getAttribute<K>(String attributeCode) {
    return _data[attributeCode] as K?;
  }

  @override
  bool setAttribute(String name, Object? value) {
    _data[name] = value;
    _whenSet = DateTime.now();
    return true;
  }

  @override
  bool containsAttribute(String name) {
    return _data.containsKey(name);
  }

  @override
  Oid get oid => _oid;

  @override
  set oid(Oid oid) {
    throw UnimplementedError('Setting oid not supported in InternalEntity');
  }

  @override
  dynamic getRelationship(String name) {
    throw UnimplementedError('Relationships not supported in InternalEntity');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InternalEntity && other._oid == _oid;
  }

  @override
  int get hashCode => _oid.hashCode;

  // Required implementations of Entity interface

  @override
  String get code => _code ?? 'temp_entity';

  @override
  set code(String? code) {
    _code = code;
  }

  @override
  String get codeFirstLetterLower => firstLetterLower(code);

  @override
  String get codeFirstLetterUpper => firstLetterUpper(code);

  @override
  String get codeLowerSpace => camelCaseLowerSeparator(code, ' ');

  @override
  String get codeLowerUnderscore => camelCaseLowerSeparator(code, '_');

  @override
  String get codePlural => plural(code);

  @override
  String get codePluralFirstLetterLower => firstLetterLower(codePlural);

  @override
  String get codePluralFirstLetterUpper => firstLetterUpper(codePlural);

  @override
  String get codePluralLowerUnderscore =>
      camelCaseLowerSeparator(codePlural, '_');

  @override
  String get codePluralFirstLetterUpperSpace =>
      camelCaseFirstLetterUpperSeparator(codePlural, ' ');

  @override
  int compareAttributes(InternalEntity entity) {
    return 0; // Simplified implementation
  }

  @override
  int compareTo(entity) {
    return 0; // Simplified implementation
  }

  @override
  InternalEntity copy() {
    final copy = InternalEntity(_concept);
    _data.forEach((key, value) {
      copy.setAttribute(key, value);
    });
    return copy;
  }

  @override
  void display({
    String prefix = '',
    bool withChildren = false,
    bool withInternalChildren = false,
    bool withOid = false,
  }) {
    // No-op for UI implementation
  }

  @override
  String displayToString() {
    return toString();
  }

  @override
  bool equalContent(InternalEntity entity) {
    return false; // Simplified implementation
  }

  @override
  bool equals(InternalEntity entity) {
    return this == entity;
  }

  @override
  PolicyEvaluationResult evaluatePolicies({String? policyKey}) {
    return PolicyEvaluationResult(
        true, []); // Always succeeds for UI with empty violations list
  }

  @override
  ValidationExceptions get exceptions => _exceptions;

  @override
  set exceptions(IValidationExceptions exceptions) {
    // No-op for UI implementation
  }

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    // No-op for UI implementation
  }

  @override
  void fromJsonMap(Map<String, dynamic> entityMap) {
    entityMap.forEach((key, value) {
      _data[key] = value;
    });
  }

  @override
  Object? getChild(String? name) {
    return null; // No children in this implementation
  }

  @override
  Object? getInternalChild(String name) {
    return null; // No internal children in this implementation
  }

  @override
  Object? getParent(String name) {
    return null; // No parents in this implementation
  }

  @override
  Reference? getReference(String name) {
    return null; // No references in this implementation
  }

  @override
  String? getStringFromAttribute(String name) {
    return _data[name]?.toString();
  }

  @override
  String? getStringOrNullFromAttribute(String name) {
    return _data[name]?.toString();
  }

  @override
  Id? get id {
    return null; // No ID in this implementation
  }

  @override
  Entities<InternalEntity> newEntities() {
    throw UnimplementedError('New entities not supported in InternalEntity');
  }

  @override
  Entity<InternalEntity> newEntity() {
    return InternalEntity(_concept);
  }

  @override
  set policyEvaluator(PolicyEvaluator policyEvaluator) {
    // No-op for UI implementation
  }

  @override
  bool get post => _post;

  @override
  set post(bool post) {
    _post = post;
  }

  @override
  bool postSetAttribute(String name, Object? value) {
    return true; // Always succeeds
  }

  @override
  bool get pre => _pre;

  @override
  set pre(bool pre) {
    _pre = pre;
  }

  @override
  bool preSetAttribute(String name, Object? value) {
    return true; // Always succeeds
  }

  @override
  void removeParent(String name) {
    // No-op for UI implementation
  }

  @override
  bool setAttributesFrom(Entity entity) {
    // Safe implementation that doesn't rely on entity._data
    for (var attribute in entity.concept.attributes) {
      final name = attribute.code;
      final value = entity.getAttribute(name);
      _data[name] = value;
    }
    return true;
  }

  @override
  bool setChild(String name, Object entities) {
    return false; // No children in this implementation
  }

  @override
  bool setParent(String name, entity) {
    return false; // No parents in this implementation
  }

  @override
  void setReference(String name, Reference reference) {
    // No-op for UI implementation
  }

  @override
  bool setStringToAttribute(String name, String string) {
    _data[name] = string;
    return true;
  }

  @override
  Map<String, dynamic> toGraph() {
    return Map<String, dynamic>.from(_data);
  }

  @override
  String toJson() {
    return jsonEncode(toJsonMap());
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return Map<String, dynamic>.from(_data);
  }

  @override
  DateTime? get whenAdded => _whenAdded;

  @override
  set whenAdded(DateTime? whenAdded) {
    _whenAdded = whenAdded;
  }

  @override
  DateTime? get whenRemoved => _whenRemoved;

  @override
  set whenRemoved(DateTime? whenRemoved) {
    _whenRemoved = whenRemoved;
  }

  @override
  DateTime? get whenSet => _whenSet;

  @override
  set whenSet(DateTime? whenSet) {
    _whenSet = whenSet;
  }
}
