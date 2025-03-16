part of ednet_core;

/// Represents a generic, domain-driven entity in the EDNet Core framework.
///
/// An Entity holds:
/// - A [concept], which describes the domain's metadata (attributes, parents, children, etc.).
/// - An [oid] (unique object identifier).
/// - A [code] string (human-readable identifier).
/// - Lifecycle timestamps ([whenAdded], [whenSet], [whenRemoved]) for auditing.
/// - Collection mappings for attributes, parent references, and child collections.
///
/// In practice, you subclass [Entity<E>] to define your specific domain entity.
/// The type parameter [E] should be the same subclass type to enable self-referential behaviors.
///
/// This class also enforces domain and model policies, handling attribute/parent/child updates
/// with automatic policy checks.
///
/// Example usage:
/// ```dart
/// class Product extends Entity<Product> {
///   late String name;
///   late double price;
///   // Additional domain-specific fields...
/// }
///
/// final product = Product();
/// product.name = 'Laptop';
/// product.price = 1299.99;
/// ```
class Entity<E extends Entity<E>> implements IEntity<E> {
  /// The [Concept] that defines the metadata for this entity.
  /// It includes the attributes, parents, and child relationships.
  /// If null, the [concept] getter throws an [EDNetException].
  Concept? _concept;

  /// Unique object identifier used to distinguish this entity.
  /// Typically set once, but can be updated if [concept.updateOid] is true.
  var _oid = Oid();

  /// A short string code to identify the entity.
  /// If [_code] is null, defaults to the literal `'code'`.
  String? _code;

  /// Timestamp recorded upon initial insertion or creation.
  /// Can be updated only if [concept.updateWhen] is true.
  DateTime? _whenAdded;

  /// Timestamp recorded whenever an attribute or relationship is updated.
  /// Automatically set to [DateTime.now()] if [concept.updateWhen] is true.
  DateTime? _whenSet;

  /// Timestamp recorded when the entity is logically removed.
  /// Can be updated only if [concept.updateWhen] is true.
  DateTime? _whenRemoved;

  /// Accumulates validation or policy violation exceptions.
  /// Each time entity updates happen, [exceptions] may record domain errors.
  @override
  var exceptions = ValidationExceptions();

  /// Internal policy evaluator used to apply entity-level or model-level policies.
  PolicyEvaluator _policyEvaluator = PolicyEvaluator(PolicyRegistry());

  /// Allows external configuration of the [PolicyEvaluator].
  set policyEvaluator(PolicyEvaluator newPolicyEvaluator) {
    _policyEvaluator = newPolicyEvaluator;
  }

  /// Stores attribute data for this entity.
  /// Key: attribute code; Value: attribute's current value.
  Map<String, Object?> _attributeMap = <String, Object?>{};

  /// Stores references to parents identified by code.
  /// Each parent is represented by a [Reference] linking OID and concept info.
  Map<String, Reference> _referenceMap = <String, Reference>{};

  /// Maps each parent code to the actual parent entity instance.
  Map<String, Object?> _parentMap = <String, Object?>{};

  /// Maps each child code to a collection of child entities ([Entities])
  /// that can be manipulated.
  Map<String, Object?> _childMap = <String, Object?>{};

  /// Similar to [_childMap], but used for internal children (where `child.internal == true`).
  Map<String, Object?> _internalChildMap = <String, Object?>{};

  /// Hooks to control pre/post conditions on attribute/relationship changes.
  /// [pre] indicates if we do pre-validation logic, [post] for post-validation.
  bool pre = false;
  bool post = false;

  /// Creates a new empty instance of this entity type.
  /// The returned entity has the same [Concept] as the original.
  Entity<E> newEntity() {
    var entity = Entity<E>();
    entity.concept = _concept!;
    return entity;
  }

  /// Creates a new [Entities<E>] collection that can hold instances of this entity.
  /// The new collection references the same [Concept].
  Entities<E> newEntities() {
    var entities = Entities<E>();
    entities.concept = _concept!;
    return entities;
  }

  /// The [Concept] describing the domain structure for this entity.
  /// If `_concept` is null, throws [EDNetException].
  @override
  Concept get concept {
    if (_concept == null) {
      throw EDNetException("concept is not set");
    }
    return _concept!;
  }

  /// Assign a [Concept] to this entity.
  /// This re-initializes all attribute/parent/child maps, sets pre/post to true,
  /// and applies any attribute defaults defined in the concept.
  set concept(Concept concept) {
    _concept = concept;
    _attributeMap = <String, Object?>{};
    _referenceMap = <String, Reference>{};
    _parentMap = <String, Object?>{};
    _childMap = <String, Object?>{};
    _internalChildMap = <String, Object?>{};

    pre = true;
    post = true;

    // Initialize all attributes with default or init values.
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.init == null) {
        // no default assigned
      } else if (a.type?.code == 'DateTime' && a.init == 'now') {
        _attributeMap[a.code] = DateTime.now();
      } else if (a.type?.code == 'bool' && a.init == 'true') {
        _attributeMap[a.code] = true;
      } else if (a.type?.code == 'bool' && a.init == 'false') {
        _attributeMap[a.code] = false;
      } else if (a.type?.code == 'int') {
        try {
          _attributeMap[a.code] = int.parse(a.init);
        } on FormatException catch (e) {
          throw TypeException(
              '${a.code} attribute init (default) value is not int: $e');
        }
      } else if (a.type?.code == 'double') {
        try {
          _attributeMap[a.code] = double.parse(a.init);
        } on FormatException catch (e) {
          throw TypeException(
              '${a.code} attribute init (default) value is not double: $e');
        }
      } else if (a.type?.code == 'num') {
        try {
          _attributeMap[a.code] = int.parse(a.init);
        } on FormatException catch (e1) {
          try {
            _attributeMap[a.code] = double.parse(a.init);
          } on FormatException catch (e2) {
            throw TypeException(
                '${a.code} attribute init (default) value is not num: $e1; $e2');
          }
        }
      } else if (a.type?.code == 'Uri') {
        try {
          _attributeMap[a.code] = Uri.parse(a.init);
        } on ArgumentError catch (e) {
          throw TypeException(
              '${a.code} attribute init (default) value is not Uri: $e');
        }
      } else {
        // For other types, store raw init.
        _attributeMap[a.code] = a.init;
      }
    }

    // Initialize references for each parent.
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      _referenceMap.remove(parent.code);
      _parentMap.remove(parent.code);
    }

    // Initialize child collections.
    for (Child child in _concept!.children.whereType<Child>()) {
      var childEntities = Entities<E>();
      childEntities.concept = child.destinationConcept;
      _childMap[child.code] = childEntities;
      if (child.internal) {
        _internalChildMap[child.code] = childEntities;
      }
    }
  }

  /// Evaluates entity-level and model-level policies for this entity.
  /// If a [policyKey] is provided, only that specific policy is evaluated.
  PolicyEvaluationResult evaluatePolicies({String? policyKey}) {
    return _policyEvaluator.evaluate(this, policyKey: policyKey);
  }

  /// Unique object identifier (OID) for the entity.
  /// By default, this is assigned on creation, but can be changed if [concept.updateOid] is true.
  @override
  Oid get oid => _oid;

  /// Updates the [oid] if [concept.updateOid] is true, otherwise throws.
  set oid(Oid oid) {
    if (_concept?.updateOid == true) {
      _oid = oid;
    } else {
      throw OidException('Entity.oid cannot be updated.');
    }
  }

  /// The [Id] aggregates all identifier attributes or parent references.
  /// If the concept has none, returns null.
  @override
  Id? get id {
    if (_concept == null) {
      return null;
      // throw new ConceptException('Entity concept is not defined.');
    }
    Id id = Id(_concept!);
    for (Parent p in _concept!.parents.whereType<Parent>()) {
      if (p.identifier) {
        id.setReference(p.code, _referenceMap[p.code]);
      }
    }
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        id.setAttribute(a.code, _attributeMap[a.code]);
      }
    }
    if (id.length == 0) {
      return null;
    }
    return id;
  }

  /// An optional human-readable string code identifying the entity.
  /// If null, defaults to `'code'`. If concept says [updateCode] is false, cannot update.
  @override
  String get code => _code ?? 'code';

  set code(String? code) {
    if (_code == null || _concept?.updateCode == true) {
      _code = code;
    } else {
      throw CodeException('Entity.code cannot be updated.');
    }
  }

  /// Timestamp of when the entity was first created or added.
  /// Only updatable if [concept.updateWhen] is true.
  @override
  DateTime? get whenAdded => _whenAdded;

  @override
  set whenAdded(DateTime? whenAdded) {
    if (_concept?.updateWhen == true) {
      _whenAdded = whenAdded;
    } else {
      throw UpdateException('Entity.whenAdded cannot be updated.');
    }
  }

  /// Timestamp of the latest attribute or relationship update.
  /// Used for partial concurrency or auditing.
  @override
  DateTime? get whenSet => _whenSet;

  @override
  set whenSet(DateTime? whenSet) {
    if (_concept?.updateWhen == true) {
      _whenSet = whenSet;
    } else {
      throw UpdateException('Entity.whenSet cannot be updated.');
    }
  }

  /// Timestamp of when the entity was logically removed.
  /// Only updatable if [concept.updateWhen] is true.
  @override
  DateTime? get whenRemoved => _whenRemoved;

  @override
  set whenRemoved(DateTime? whenRemoved) {
    if (_concept?.updateWhen == true) {
      _whenRemoved = whenRemoved;
    } else {
      throw UpdateException('Entity.whenRemoved cannot be updated.');
    }
  }

  /// Utility property returning the code's first letter in lowercase.
  String get codeFirstLetterLower => firstLetterLower(code);

  /// Utility property returning the code's first letter in uppercase.
  String get codeFirstLetterUpper => firstLetterUpper(code);

  /// Utility property returning the code in lower_snake_case form.
  String get codeLowerUnderscore => camelCaseLowerSeparator(code, '_');

  /// Utility property returning the code in lower space-separated form.
  String get codeLowerSpace => camelCaseLowerSeparator(code, ' ');

  /// Utility property returning the code in plural form.
  String get codePlural => plural(code);

  /// Utility property returning the plural code, first letter lowercased.
  String get codePluralFirstLetterLower => firstLetterLower(codePlural);

  /// Utility property returning the plural code, first letter uppercased.
  String get codePluralFirstLetterUpper => firstLetterUpper(codePlural);

  /// Utility property returning the plural code in lower_snake_case.
  String get codePluralLowerUnderscore =>
      camelCaseLowerSeparator(codePlural, '_');

  /// Utility property returning the plural code in a spaced form with uppercase first letter.
  String get codePluralFirstLetterUpperSpace =>
      camelCaseFirstLetterUpperSeparator(codePlural, ' ');

  /// Called before setting an attribute. If [pre] is true, can run additional checks.
  /// If returns false, attribute set operation is not performed.
  @override
  bool preSetAttribute(String name, Object? value) {
    if (!pre) {
      return true;
    }

    if (_concept == null) {
      throw ConceptException('Entity(oid: ${oid}) concept is not defined.');
    }
    return true;
  }

  /// Retrieves the attribute value for [attributeCode] as type [K].
  /// Returns null if not set.
  @override
  K? getAttribute<K>(String attributeCode) =>
      _attributeMap[attributeCode] as K?;

  /// Sets an attribute by [name] to [value], respecting update rules and calling policy checks.
  /// Returns true if the attribute was successfully updated.
  /// Throws [UpdateException] if the attribute is not updatable or absent.
  /// Also handles policy checks, reverting changes if policies fail.
  @override
  bool setAttribute(String name, Object? value) {
    bool updated = false;

    if (preSetAttribute(name, value)) {
      if (_concept == null) {
        throw ConceptException('Entity concept is not defined.');
      }

      var attribute = _concept?.attributes.singleWhereCode(name);
      if (attribute == null) {
        String msg = '${_concept?.code}.$name is not correct attribute name.';
        throw UpdateException(msg);
      }
      /*
       * validation done in Entities.preAdd
      if (value == null && attribute.minc != '0') {
        String msg = '${_concept?.code}.$name cannot be null.';
        throw new UpdateException(msg);
      }
      */
      Object? beforeValue = _attributeMap[name];
      // If attribute not yet set, or if it is updatable
      if (getAttribute(name) == null) {
        _attributeMap[name] = value;
        updated = true;
        //} else if (!attribute.derive && attribute.update) {
      } else if (attribute.update) {
        _attributeMap[name] = value;
        updated = true;
        _whenSet = DateTime.now();
      } else {
        String msg = '${_concept?.code}.${attribute.code} is not updatable.';
        throw UpdateException(msg);
      }

      // Now handle post-set logic.
      if (postSetAttribute(name, value)) {
        updated = true;
      } else {
        // If postSet fails, revert changes.
        var beforePre = pre;
        var beforePost = post;
        pre = false;
        post = false;
        if (beforeValue == null || !setAttribute(name, beforeValue)) {
          var msg = '${_concept?.code}.${attribute.code} '
              'was set to a new value, post was not successful, '
              'set to the before value was not successful';
          throw RemoveException(msg);
        } else {
          _whenSet = null;
        }
        pre = beforePre;
        post = beforePost;
      }

      // If updated, run policy checks.
      if (updated) {
        var policyResult = evaluatePolicies();
        if (!policyResult.success) {
          // revert change
          _attributeMap[name] = beforeValue;
          updated = false;
          throw PolicyViolationException(policyResult.violations);
        }

        var modelPolicyResult = concept.model.evaluateModelPolicies(this);
        if (!modelPolicyResult) {
          _attributeMap[name] = beforeValue;
          updated = false;
          throw PolicyViolationException(modelPolicyResult.violations);
        }
      }
    }
    return updated;
  }

  /// Called after setting an attribute. If [post] is true, can run additional checks.
  /// Return false if you want to revert the update.
  @override
  bool postSetAttribute(String name, Object? value) {
    if (!post) {
      return true;
    }

    if (_concept == null) {
      throw ConceptException('Entity(oid: ${oid}) concept is not defined.');
    }
    return true;
  }

  /// Returns the attribute value as a string. If the value is null, returns `'null'`.
  @override
  String? getStringFromAttribute(String name) => _attributeMap[name].toString();

  /// Returns the attribute value as a nullable string, or null if no value.
  @override
  String? getStringOrNullFromAttribute(String name) =>
      _attributeMap[name]?.toString();

  /// Helper to parse a [string] and update the attribute [name] accordingly.
  /// If the attribute type is recognized (e.g., int, bool), we parse the string.
  /// Otherwise, store the string as-is.
  @override
  bool setStringToAttribute(String name, String string) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    Attribute? attribute =
        _concept?.attributes.singleWhereCode(name) as Attribute?;
    if (attribute == null) {
      String msg = '${_concept?.code}.$name is not correct attribute name.';
      throw UpdateException(msg);
    }

    // If literal 'null', we interpret that as no value.
    if (string == 'null') {
      return setAttribute(name, null);
    }

    // Attempt to parse based on declared attribute type.
    if (attribute.type?.code == 'DateTime') {
      try {
        return setAttribute(name, DateTime.parse(string));
      } on ArgumentError catch (e) {
        throw TypeException('${_concept?.code}.${attribute.code} '
            'attribute value is not DateTime: $e');
      }
    } else if (attribute.type?.code == 'bool') {
      if (string == 'true') {
        return setAttribute(name, true);
      } else if (string == 'false') {
        return setAttribute(name, false);
      } else {
        throw TypeException('${attribute.code} attribute value is not bool.');
      }
    } else if (attribute.type?.code == 'int') {
      try {
        return setAttribute(name, int.parse(string));
      } on FormatException catch (e) {
        throw TypeException('${attribute.code} '
            'attribute value is not int: $e');
      }
    } else if (attribute.type?.code == 'double') {
      try {
        return setAttribute(name, double.parse(string));
      } on FormatException catch (e) {
        throw TypeException('${attribute.code} '
            'attribute value is not double: $e');
      }
    } else if (attribute.type?.code == 'num') {
      try {
        return setAttribute(name, int.parse(string));
      } on FormatException catch (e1) {
        try {
          return setAttribute(name, double.parse(string));
        } on FormatException catch (e2) {
          throw TypeException(
              '${attribute.code} attribute value is not num: $e1; $e2');
        }
      }
    } else if (attribute.type?.code == 'Uri') {
      try {
        return setAttribute(name, Uri.parse(string));
      } on ArgumentError catch (e) {
        throw TypeException('${attribute.code} attribute value is not Uri: $e');
      }
    } else {
      // For any other or custom type, store string as-is.
      return setAttribute(name, string);
    }
  }

  /// Returns the [Reference] to a parent by [name], if any.
  Reference? getReference(String name) => _referenceMap[name];

  /// Sets a [Reference] for a parent [name], but only if that parent slot is empty.
  void setReference(String name, Reference reference) {
    if (getParent(name) == null) {
      _referenceMap[name] = reference;
    }
  }

  /// Gets the parent entity by [name], or null if none.
  @override
  Object? getParent(String name) => _parentMap[name];

  /// Gets the internal child collection reference by [name].
  Object? getInternalChild(String name) => _internalChildMap[name];

  /// Retrieves the child collection matching [name].
  /// Or null if no such child is defined.
  @override
  Object? getChild(String? name) {
    return _childMap[name];
  }

  /// Bulk-updates this entity’s attributes from another entity if [whenSet] is older.
  /// Only non-identifier attributes are considered. Returns true if all updated.
  bool setAttributesFrom(Entity entity) {
    bool allSet = true;
    if (entity.whenSet?.millisecondsSinceEpoch != null &&
        whenSet?.millisecondsSinceEpoch != null &&
        (whenSet!.millisecondsSinceEpoch <
            entity.whenSet!.millisecondsSinceEpoch)) {
      for (Attribute attribute in _concept!.nonIdentifierAttributes) {
        var newValue = entity.getAttribute(attribute.code);
        var attributeSet = setAttribute(attribute.code, newValue);
        if (!attributeSet) {
          allSet = false;
        }
      }
    } else {
      allSet = false;
    }
    return allSet;
  }

  /// Creates a shallow copy of this entity.
  /// OID, code, attributes, and references are duplicated.
  /// Child/parent references are not deeply cloned but re-linked.
  @override
  E copy() {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    Entity<E> entity = newEntity();

    // Oid updates.
    var beforeUpdateOid = entity.concept.updateOid;
    entity.concept.updateOid = true;
    entity.oid = _oid;
    entity.concept.updateOid = beforeUpdateOid;

    // Code updates.
    if (_code != null) {
      var beforeUpdateCode = entity.concept.updateCode;
      entity.concept.updateCode = true;
      entity.code = _code;
      entity.concept.updateCode = beforeUpdateCode;
    }

    // Lifecycle timestamps.
    var beforeUpdateWhen = concept.updateWhen;
    concept.updateWhen = true;
    if (_whenAdded != null) {
      entity.whenAdded = _whenAdded;
    }
    if (_whenSet != null) {
      entity.whenSet = _whenSet;
    }
    if (_whenRemoved != null) {
      entity.whenRemoved = _whenRemoved;
    }
    concept.updateWhen = beforeUpdateWhen;

    // Copy attributes.
    for (Attribute attribute in _concept!.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        var beforeUpdate = attribute.update;
        attribute.update = true;
        entity.setAttribute(attribute.code, _attributeMap[attribute.code]);
        attribute.update = beforeUpdate;
      } else {
        entity.setAttribute(attribute.code, _attributeMap[attribute.code]);
      }
    }

    // Copy parent references.
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      if (parent.identifier) {
        var beforeUpdate = parent.update;
        parent.update = true;
        entity.setParent(parent.code, _parentMap[parent.code]);
        parent.update = beforeUpdate;
      } else if (_parentMap[parent.code] != null) {
        entity.setParent(parent.code, _parentMap[parent.code]);
      }
    }

    // Copy child references.
    for (Child child in _concept!.children.whereType<Child>()) {
      entity.setChild(child.code, _childMap[child.code]!);
    }

    return entity as E;
  }

  /// Hashes the entity by its [oid].
  @override
  int get hashCode => _oid.hashCode;

  /// Equality is based on [oid]. If their OIDs match, they are considered the same entity.
  bool equals(E entity) {
    if (_oid.equals(entity.oid)) {
      return true;
    }
    return false;
  }

  /// The `==` operator delegates to [equals].
  /// If [other] is not an Entity, returns false.
  @override
  bool operator ==(Object other) {
    if (other is Entity) {
      Entity entity = other;
      if (identical(this, entity)) {
        return true;
      } else {
        return equals(entity as E);
      }
    } else {
      return false;
    }
  }

  /// Checks if the content (attributes, code, parents, children) matches another entity.
  /// Ignores [oid], [whenAdded], [whenSet], [whenRemoved].
  bool equalContent(E entity) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    if (_code != entity.code) {
      return false;
    }
    // Compare each attribute.
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (_attributeMap[a.code] != entity.getAttribute(a.code)) {
        return false;
      }
    }
    // Compare each parent.
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      if (_parentMap[parent.code] != entity.getParent(parent.code)) {
        return false;
      }
    }
    // Compare each child.
    for (Child child in _concept!.children.whereType<Child>()) {
      if (_childMap[child.code] != entity.getChild(child.code)) {
        return false;
      }
    }
    return true;
  }

  /// Compare two entities, primarily using [code], otherwise [id], otherwise attribute comparisons.
  /// If negative, this < that; zero => equal; positive => this > that.
  @override
  int compareTo(entity) {
    if (code.isNotEmpty && _code != null) {
      return _code!.compareTo(entity.code);
    } else if (entity.id != null && id != null) {
      return id!.compareTo(entity.id);
    } else if (concept.attributes.isNotEmpty) {
      return compareAttributes(entity);
    } else {
      var msg = '${_concept?.code} concept does not have attributes.';
      throw IdException(msg);
    }
  }

  /// Compare attributes one by one until a difference is found.
  /// Return negative if this < that; zero if same; positive if this > that.
  int compareAttributes(E entity) {
    var compare = 0;
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      var value1 = _attributeMap[a.code];
      var value2 = entity.getAttribute(a.code);

      compare = a.type?.compare(value1, value2) ?? 0;
      if (compare != 0) {
        break;
      }
    }
    return compare;
  }

  /// Returns a concise string representation using the entity's [oid] and [code].
  @override
  String toString() {
    if (_code == null) {
      return '{${_concept?.code}: {oid:${_oid.toString()}}}';
    } else {
      return '{${_concept?.code}: {oid:${_oid.toString()}, code:$_code}}';
    }
  }

  /// Prints [toString()].
  void displayToString() {
    print(toString());
  }

  /// Displays this entity’s details, including attributes, parents, children.
  ///
  /// Parameters:
  /// - [prefix]: indentation or formatting prefix.
  /// - [withOid]: whether to show the OID in output.
  /// - [withChildren]: whether to recursively display child collections.
  /// - [withInternalChildren]: whether to display internal child sets.
  void display({
    String prefix = '',
    bool withOid = true,
    bool withChildren = true,
    bool withInternalChildren = true,
  }) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    var s = prefix;
    if (!(_concept?.entry == true) ||
        ((_concept?.entry == true) && _concept?.parents.isNotEmpty == true)) {
      s = '$prefix  ';
    }
    print('$s------------------------------------');
    print('$s${toString()}                       ');
    print('$s------------------------------------');
    s = '$s  ';
    if (withOid) {
      print('${s}oid: $_oid');
    }
    print('${s}code: $_code');
    print('${s}id: $id');
    print('${s}whenAdded: $_whenAdded');
    print('${s}whenSet: $_whenSet');
    print('${s}whenRemoved: $_whenRemoved');

    // Display all attributes.
    _attributeMap.forEach((k, v) {
      if (_concept?.isAttributeSensitive(k) == true) {
        print('$s$k: **********');
      } else {
        print('$s$k: $v');
      }
    });

    // Display parents.
    _parentMap.forEach((k, v) {
      if (_concept?.isParentSensitive(k) == true) {
        print('$s$k: **********');
      } else {
        print('$s$k: ${v.toString()}');
      }
    });

    // Optionally display children.
    if (withChildren) {
      if (withInternalChildren) {
        _internalChildMap.forEach((k, v) {
          print('$s$k:');
          if (_concept?.isChildSensitive(k) == true) {
            print('**********');
          } else {
            (v as Entities).display(
                title: '$s$k',
                prefix: '$s  ',
                withOid: withOid,
                withChildren: withChildren,
                withInternalChildren: withInternalChildren);
          }
        });
      } else {
        _childMap.forEach((k, v) {
          print('$s$k:');
          if (_concept?.isChildSensitive(k) == true) {
            print('**********');
          } else {
            (v as Entities).display(
                title: '$s$k',
                prefix: '$s  ',
                withOid: withOid,
                withChildren: withChildren,
                withInternalChildren: withInternalChildren);
          }
        });
      }
    }
    print('');
  }

  /// Serializes this entity to JSON using [toJsonMap].
  @override
  String toJson() => jsonEncode(toJsonMap());

  /// Builds a JSON-like [Map] of this entity's data, including parent references.
  Map<String, Object> toJsonMap() {
    Map<String, Object> entityMap = <String, Object>{};

    // Store parent references.
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      Entity? parentEntity = getParent(parent.code) as Entity?;
      if (parentEntity != null) {
        var reference = <String, String>{};
        reference['oid'] = parentEntity.oid.toString();
        reference['parent'] = parentEntity.concept.code;
        reference['entry'] = parentEntity.concept.entryConcept.code;
        entityMap[parent.code] = reference;
      } else {
        entityMap[parent.code] = 'null';
      }
    }

    // Basic fields.
    entityMap['oid'] = _oid.toString();
    entityMap['code'] = _code ?? '';
    entityMap['whenAdded'] = _whenAdded.toString();
    entityMap['whenSet'] = _whenSet.toString();
    entityMap['whenRemoved'] = _whenRemoved.toString();

    // Attributes.
    for (var k in _attributeMap.keys) {
      entityMap[k] = getStringFromAttribute(k) as Object;
    }

    // Internal children as lists.
    for (var k in _internalChildMap.keys) {
      entityMap[k] = (getInternalChild(k) as Entities).toJsonList();
    }
    return entityMap;
  }

  /// Populates this entity's data from a JSON string.
  /// Deserializes via [fromJsonMap].
  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    Map<String, Object> entityMap = jsonDecode(entityJson);
    fromJsonMap(entityMap);
  }

  /// Internal: loads entity data from a map [entityMap], optionally linking to an [internalParent].
  void fromJsonMap(entityMap, [Entity? internalParent]) {
    int timeStamp = 0;
    try {
      var key = entityMap['oid'];
      if (key != null) {
        timeStamp = int.parse(key.toString());
      }
    } on FormatException catch (e) {
      throw TypeException('${entityMap['oid']} oid is not int: $e');
    }

    // Temporarily allow OID update.
    var beforeUpdateOid = concept.updateOid;
    concept.updateOid = true;
    oid = Oid.ts(timeStamp);
    concept.updateOid = beforeUpdateOid;

    // Temporarily allow code update.
    var beforeUpdateCode = concept.updateCode;
    concept.updateCode = true;
    code = entityMap['code'] as String;
    concept.updateCode = beforeUpdateCode;

    // Temporarily allow when.* updates.
    var beforeUpdateWhen = concept.updateWhen;
    concept.updateWhen = true;

    // Parse timestamps.
    DateTime? whenAddedTime;
    try {
      String? when = entityMap['whenAdded'] as String?;
      if (when != null && when != 'null') {
        whenAddedTime = DateTime.parse(when);
      }
    } on FormatException catch (e) {
      throw TypeException(
          '${entityMap['whenAdded']} whenAdded is not DateTime: $e');
    }
    whenAdded = whenAddedTime;

    DateTime? whenSetTime;
    try {
      String? when = entityMap['whenSet'] as String?;
      if (when != null && when != 'null') {
        whenSetTime = DateTime.parse(when);
      }
    } on FormatException catch (e) {
      throw TypeException(
          '${entityMap['whenSet']} whenSet is not DateTime: $e');
    }
    whenSet = whenSetTime;

    DateTime? whenRemovedTime;
    try {
      String? when = entityMap['whenRemoved'] as String?;
      if (when != null && when != 'null') {
        whenRemovedTime = DateTime.parse(when);
      }
    } on FormatException catch (e) {
      throw TypeException(
          '${entityMap['whenRemoved']} whenRemoved is not DateTime: $e');
    }
    whenRemoved = whenRemovedTime;

    concept.updateWhen = beforeUpdateWhen;

    var beforePre = pre;
    pre = false;

    // For each attribute, parse the stored string.
    for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        var beforeUpdate = attribute.update;
        attribute.update = true;
        setStringToAttribute(attribute.code, entityMap[attribute.code]);
        attribute.update = beforeUpdate;
      } else {
        setStringToAttribute(attribute.code, entityMap[attribute.code]);
      }
    }

    // Load neighbors: parent references, child sets.
    _neighborsFromJsonMap(entityMap, internalParent);

    pre = beforePre;
  }

  /// Internal helper to load parent references and internal child data from [entityMap].
  void _neighborsFromJsonMap(entityMap, [Entity? internalParent]) {
    // Internal children.
    for (Child child in concept.children.whereType<Child>()) {
      if (child.internal) {
        var entitiesList = entityMap[child.code];
        var childEntities = getChild(child.code) as Entities?;
        childEntities?.fromJsonList(entitiesList, this);
        setChild(child.code, childEntities as Object);
      }
    }

    // Parents.
    for (Parent parent in concept.parents.whereType<Parent>()) {
      if (entityMap[parent.code] == null || entityMap[parent.code] == 'null') {
        if (parent.minc != '0') {
          throw ParentException('${parent.code} parent cannot be null.');
        }
      } else if (entityMap[parent.code] != null) {
        String? parentOidString = entityMap[parent.code]['oid'];
        String? entryConceptCode = entityMap[parent.code]['entry'];
        if (entityMap[parent.code]['parent'] != null &&
            parentOidString != null &&
            entryConceptCode != null) {
          Reference reference = Reference(parentOidString,
              entityMap[parent.code]['parent'], entryConceptCode);
          Oid parentOid = reference.oid;
          setReference(parent.code, reference);

          if (parent.internal) {
            if (parentOid == internalParent?.oid) {
              setParent(parent.code, internalParent);
            } else {
              var msg = """

              =============================================
              Internal parent oid is wrong, create issue for ${parent.code}
              on https://github.com/context-dev/cms/issues/new?title=_neighborsFromJsonMap%20bug                           
              ---------------------------------------------                            
              model_entries.dart: entity.setParent(parent.code, internalParent); 
              internal parent oid: ${internalParent?.oid}                  
              entity concept: ${concept.code}                   
              entity oid: $oid                                
              parent oid: $parentOidString                           
              parent code: ${parent.code}                              
              parent concept: ${entityMap[parent.code]['parent']}                     
              entry concept for parent: $entryConceptCode            
              ---------------------------------------------
            """;
              throw ParentException(msg);
            }
          }
        }
      }
    }
  }

  /// Updates a child relationship [name] with [entities].
  /// If child.update is false, we throw an [UpdateException].
  /// If policies fail, we revert.
  @override
  bool setChild(String name, Object entities) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    Child? child = _concept?.children.singleWhereCode(name) as Child?;
    if (child == null) {
      String msg =
          '${_concept?.code}.$name is not correct child entities name.';
      throw UpdateException(msg);
    }

    if (child.update) {
      _childMap.update(name, (value) => entities);
      if (child.internal) {
        _internalChildMap[name] = entities;
      }

      // Evaluate policies after child change.
      var policyResult = evaluatePolicies();
      if (!policyResult.success) {
        _childMap.remove(name);
        if (_internalChildMap.containsKey(name)) {
          _internalChildMap.remove(name);
        }
        throw PolicyViolationException(policyResult.violations);
      }

      // Then model policies.
      var modelPolicyResult = concept.model.evaluateModelPolicies(this);
      if (!modelPolicyResult) {
        _childMap.remove(name);
        if (_internalChildMap.containsKey(name)) {
          _internalChildMap.remove(name);
        }
        throw PolicyViolationException(modelPolicyResult.violations);
      }

      return true;
    } else {
      return false;
      // or throw new UpdateException
    }
  }

  /// Sets or updates a parent relationship named [name] with the given [entity].
  /// If parent is uninitialized or updatable, we store a reference.
  /// If policies fail, we revert.
  @override
  bool setParent(String name, entity) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    Parent? parent = _concept?.parents.singleWhereCode(name) as Parent?;
    if (parent == null) {
      String msg = '${_concept?.code}.$name is not correct parent entity name.';
      throw UpdateException(msg);
    }

    if (entity != null && getParent(name) == null) {
      var reference = Reference(entity.oid.toString(), entity.concept.code,
          entity.concept.entryConcept.code);
      _parentMap[name] = entity;
      _referenceMap[name] = reference;

      var policyResult = evaluatePolicies();
      if (!policyResult.success) {
        _parentMap.remove(name);
        _referenceMap.remove(name);
        throw PolicyViolationException(policyResult.violations);
      }
      return true;
    } else if (entity != null && parent.update) {
      var reference = Reference(entity.oid.toString(), entity.concept.code,
          entity.concept.entryConcept.code);
      _parentMap[name] = entity;
      _referenceMap[name] = reference;

      var policyResult = evaluatePolicies();
      if (!policyResult.success) {
        _parentMap.remove(name);
        _referenceMap.remove(name);
        throw PolicyViolationException(policyResult.violations);
      }

      var modelPolicyResult = concept.model.evaluateModelPolicies(this);
      if (!modelPolicyResult.success) {
        _parentMap.remove(name);
        _referenceMap.remove(name);
        throw PolicyViolationException(modelPolicyResult.violations);
      }
      return true;
    } else {
      String msg = '${_concept?.code}.${parent.code} is not updatable.';
      throw UpdateException(msg);
    }
  }

  /// Removes a parent reference by [name], if [parent.update] is true.
  /// Reverts if policies are violated.
  @override
  removeParent(String name) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    Parent? parent = _concept?.parents.singleWhereCode(name) as Parent?;
    Reference? reference = _referenceMap[name];
    if (parent == null) {
      String msg = '${_concept?.code}.$name is not correct parent entity name.';
      throw UpdateException(msg);
    }

    if (parent.update) {
      _parentMap.remove(name);
      _referenceMap.remove(name);

      var policyResult = evaluatePolicies();
      if (!policyResult.success) {
        _parentMap[name] = parent;
        _referenceMap[name] = reference!;
        throw PolicyViolationException(policyResult.violations);
      }
    } else {
      String msg = '${_concept?.code}.${parent.code} is not updatable.';
      throw UpdateException(msg);
    }
  }

  /// Converts this entity to a graph-like structure, including references to parents.
  @override
  Map<String, dynamic> toGraph() {
    var graph = <String, dynamic>{};
    graph['oid'] = oid.toString();
    graph['code'] = code;
    graph['whenAdded'] = whenAdded.toString();
    graph['whenSet'] = whenSet.toString();
    graph['whenRemoved'] = whenRemoved.toString();

    // Add attributes.
    for (var k in _attributeMap.keys) {
      graph[k] = getStringFromAttribute(k);
    }

    // Add internal child graphs.
    for (var k in _internalChildMap.keys) {
      graph[k] = (getInternalChild(k) as Entities).toGraph();
    }

    // Parent references.
    for (var k in _parentMap.keys) {
      var parent = getParent(k) as Entity;
      var reference = Reference(parent.oid.toString(), parent.concept.code,
          parent.concept.entryConcept.code);
      graph[k] = reference.toGraph();
    }

    return graph;
  }

  /// Retrieves either a parent or child relationship by name.
  /// Returns null if neither is found.
  getRelationship(String relationshipName) {
    if (_concept == null) {
      throw ConceptException('Entity concept is not defined.');
    }

    if (_concept?.isParent(relationshipName) == true) {
      return getParent(relationshipName);
    } else if (_concept?.isChild(relationshipName) == true) {
      return getChild(relationshipName);
    } else {
      return null;
    }
  }
}
