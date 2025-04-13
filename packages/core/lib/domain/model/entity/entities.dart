part of ednet_core;

/// A collection of domain entities that implements the [IEntities] interface.
///
/// The [Entities] class manages a collection of domain entities of type [E], where [E] extends [Entity<E>].
/// It provides functionality for:
/// - Adding, removing, and updating entities
/// - Validating entities against domain rules
/// - Managing entity relationships and references
/// - Serializing/deserializing entities to/from JSON
/// - Applying domain policies and validations
///
/// The class maintains several internal maps for efficient entity lookup:
/// - [_oidEntityMap]: Maps OID timestamps to entities
/// - [_codeEntityMap]: Maps entity codes to entities
/// - [_idEntityMap]: Maps entity IDs to entities
///
/// Example usage:
/// ```dart
/// final entities = Entities<Product>();
/// entities.concept = productConcept;
///
/// final product = Product();
/// product.name = 'Laptop';
/// entities.add(product);
/// ```
class Entities<E extends Entity<E>> implements IEntities<E> {
  /// The [Concept] that defines the metadata for this collection.
  /// If null, operations will throw [ConceptException].
  Concept? _concept;

  /// The underlying list of entities.
  var _entityList = <E>[];

  /// Maps OID timestamps to entities for fast lookup.
  final _oidEntityMap = <int, E>{};

  /// Maps entity codes to entities for fast lookup.
  final _codeEntityMap = <String, E>{};

  /// Maps entity IDs to entities for fast lookup.
  final _idEntityMap = <String, E>{};

  /// Creates a new empty collection of entities.
  Entities();

  /// Accumulates validation exceptions during entity operations.
  @override
  ValidationExceptions exceptions = ValidationExceptions();

  /// Reference to the source collection if this is a derived collection.
  @override
  Entities<E>? source;

  /// Minimum cardinality constraint (default: '0').
  String minC = '0';

  /// Maximum cardinality constraint (default: 'N' for unlimited).
  String maxC = 'N';

  /// Whether to perform pre-validation checks.
  bool pre = false;

  /// Whether to perform post-validation checks.
  bool post = false;

  /// Whether changes should propagate to the source collection.
  bool propagateToSource = false;

  /// Random number generator for entity selection.
  var randomGen = Random();

  /// Creates a new empty collection with the same concept as this one.
  Entities<E> newEntities() {
    var entities = Entities<E>();
    entities.concept = _concept!;
    return entities;
  }

  /// Sets the [concept] for this collection and initializes validation flags.
  set concept(Concept concept) {
    _concept = concept;
    pre = true;
    post = true;
    propagateToSource = true;
  }

  /// Creates a new entity instance with the same concept as this collection.
  Entity<E> newEntity() {
    var conceptEntity = Entity<E>();
    conceptEntity.concept = _concept!;
    return conceptEntity;
  }

  /// Gets the [concept] for this collection.
  /// Throws [ConceptException] if not set.
  @override
  Concept get concept {
    if (_concept == null) {
      throw ConceptException("Concept not set");
    }

    return _concept!;
  }

  /// Returns the first entity in the collection.
  @override
  E get first => _entityList.first;

  /// Whether the collection is empty.
  @override
  bool get isEmpty => _entityList.isEmpty;

  /// Whether the collection has at least one entity.
  @override
  bool get isNotEmpty => _entityList.isNotEmpty;

  /// Returns an iterator over the entities.
  @override
  Iterator<E> get iterator => _entityList.iterator;

  /// Returns the last entity in the collection.
  @override
  E get last => _entityList.last;

  /// Returns the number of entities in the collection.
  @override
  int get length => _entityList.length;

  /// Alias for [length] for convenience.
  int get count => length;

  /// Returns the single entity in the collection.
  /// Throws [StateError] if collection is empty or has multiple entities.
  @override
  E get single => _entityList.single;

  /// Returns the entity at the given [index].
  ///
  /// This operator enables array-like access to entities:
  /// ```dart
  /// domain = domains[0];
  /// model = domain.models[1];
  /// concept = model.concepts[2];
  /// ```
  E operator [](int index) => _entityList[index];

  /// Returns true if any entity satisfies the predicate [f].
  @override
  bool any(bool Function(E entity) f) => _entityList.any(f);

  /// Checks if the collection contains the given entity.
  /// Compares entities by their OID.
  @override
  bool contains(Object? entity) {
    if (entity == null || !(entity is E) || _oidEntityMap.isEmpty) {
      return false;
    }

    E? element = _oidEntityMap[(entity).oid.timeStamp];
    if (element == null) {
      return false;
    }

    return entity == element;
  }

  /// Returns the entity at the given [index].
  @override
  E elementAt(int index) => _entityList.elementAt(index);

  /// Alias for [elementAt].
  E at(int index) => elementAt(index);

  /// Returns true if all entities satisfy the predicate [f].
  @override
  bool every(bool Function(E entity) f) => _entityList.every(f);

  /// Expands each entity into multiple elements using [toElements].
  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) =>
      _entityList.expand(toElements);

  /// Returns the first entity that satisfies the predicate [f].
  /// If no entity satisfies [f], returns the result of [orElse] if provided.
  @override
  E firstWhere(bool Function(E entity) f, {E Function()? orElse}) =>
      _entityList.firstWhere(f);

  /// Reduces the collection to a single value using [combine].
  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      _entityList.fold(initialValue, combine);

  /// Applies [action] to each entity.
  @override
  void forEach(void Function(E element) action) => _entityList.forEach(action);

  /// Joins the string representations of entities with [separator].
  @override
  String join([String separator = '']) => _entityList.join(separator);

  /// Returns the last entity that satisfies the predicate [f].
  /// If no entity satisfies [f], returns the result of [orElse] if provided.
  @override
  E lastWhere(bool Function(E entity) f, {E Function()? orElse}) =>
      _entityList.lastWhere(f);

  /// Maps each entity to a new value using [f].
  @override
  Iterable<T> map<T>(T Function(E) f) => _entityList.map(f);

  /// Reduces the collection to a single entity using [combine].
  @override
  E reduce(E Function(E value, E entity) combine) =>
      _entityList.reduce(combine);

  /// Returns the single entity that satisfies the predicate [f].
  /// If no entity or multiple entities satisfy [f], returns the result of [orElse] if provided.
  @override
  E singleWhere(bool Function(E entity) f, {E Function()? orElse}) =>
      _entityList.singleWhere(f);

  /// Returns all entities except the first [n].
  @override
  Iterable<E> skip(int n) => _entityList.skip(n);

  /// Returns all entities after the first one that doesn't satisfy [f].
  @override
  Iterable<E> skipWhile(bool Function(E entity) f) => _entityList.skipWhile(f);

  /// Returns the first [n] entities.
  @override
  Iterable<E> take(int n) => _entityList.take(n);

  /// Returns all entities up to but not including the first one that doesn't satisfy [f].
  @override
  Iterable<E> takeWhile(bool Function(E entity) f) => _entityList.takeWhile(f);

  /// Returns a list containing all entities.
  @override
  List<E> toList({bool growable = true}) => _entityList.toList(growable: true);

  /// Returns a set containing all entities.
  @override
  Set<E> toSet() => _entityList.toSet();

  /// Returns all entities that satisfy the predicate [f].
  @override
  Iterable<E> where(bool Function(E entity) f) => _entityList.where(f);

  /// Sets the internal list of entities.
  /// Used for Polymer compatibility.
  set internalList(List<E> observableList) {
    _entityList = observableList;
  }

  /// Returns the first entity that has the given attribute value.
  @override
  E firstWhereAttribute(String code, Object attribute) {
    var selectionEntities = selectWhereAttribute(code, attribute);
    if (selectionEntities.isNotEmpty) {
      return selectionEntities.first;
    }
    throw EDNetException(
      'E firstWhereAttribute(String code, Object attribute): code = $code, attribute = $attribute',
    );
  }

  /// Returns a random entity from the collection.
  @override
  E random() {
    if (!isEmpty) {
      return _entityList[randomGen.nextInt(length)];
    }
    throw EDNetException('E random(): length = $length');
  }

  /// Returns the entity with the given [oid], or null if not found.
  @override
  E? singleWhereOid(Oid oid) {
    if (_oidEntityMap[oid.timeStamp] != null) {
      return _oidEntityMap[oid.timeStamp];
    }

    return null;
  }

  /// Returns the entity with the given [oid] from this collection or its internal children.
  @override
  Entity? internalSingle(Oid oid) {
    if (isEmpty) {
      return null;
    }
    Entity? foundEntity = singleWhereOid(oid);
    if (foundEntity != null) {
      return foundEntity;
    }

    if (_concept?.children.isNotEmpty ?? false) {
      for (Entity entity in _entityList) {
        for (Child child in _concept!.children.whereType<Child>()) {
          if (child.internal) {
            Entities? childEntities = entity.getChild(child.code) as Entities?;
            Entity? childEntity = childEntities?.internalSingle(oid);
            if (childEntity != null) {
              return childEntity;
            }
          }
        }
      }
    }
    return null;
  }

  /// Returns the collection containing the entity with the given [oid].
  @override
  Entities? internalChild(Oid oid) {
    if (isEmpty) {
      return null;
    }
    Entity? foundEntity = singleWhereOid(oid);
    if (foundEntity != null) {
      return this;
    }
    if (_concept?.children.isNotEmpty ?? false) {
      for (Entity entity in _entityList) {
        for (Child child in _concept!.children.whereType<Child>()) {
          if (child.internal) {
            Entities? childEntities = entity.getChild(child.code) as Entities?;
            Entity? childEntity = childEntities?.internalSingle(oid);
            if (childEntity != null) {
              return childEntities;
            }
          }
        }
      }
    }
    return null;
  }

  /// Returns the entity with the given [code], or null if not found.
  @override
  E? singleWhereCode(String? code) {
    return _codeEntityMap[code];
  }

  /// Returns the entity with the given [id], or null if not found.
  @override
  E? singleWhereId(Id id) {
    var entity = _idEntityMap[id.toString()];
    if (entity != null) {
      return entity;
    }

    return null;
  }

  /// Returns the entity with the given attribute value.
  @override
  E? singleWhereAttributeId(String code, Object attribute) {
    return singleWhereId((Id(_concept!))..setAttribute(code, attribute));
  }

  /// Creates a shallow copy of this collection.
  /// The copy shares the same concept but has its own entity list.
  @override
  Entities<E> copy() {
    if (_concept == null) {
      throw new ConceptException('Entities.copy: concept is not defined.');
    }

    Entities<E> copiedEntities = newEntities();
    copiedEntities.pre = false;
    copiedEntities.post = false;
    copiedEntities.propagateToSource = false;
    for (Entity<E> entity in this) {
      copiedEntities.add(entity.copy());
    }
    copiedEntities.pre = true;
    copiedEntities.post = true;
    copiedEntities.propagateToSource = true;
    return copiedEntities;
  }

  /// Orders the entities using the given [compare] function.
  /// If [compare] is not provided, uses the entity's [compareTo] method.
  @override
  Entities<E> order([int Function(E a, E b)? compare]) {
    if (_concept == null) {
      throw new ConceptException('Entities.order: concept is not defined.');
    }

    Entities<E> orderedEntities = newEntities();
    orderedEntities.pre = false;
    orderedEntities.post = false;
    orderedEntities.propagateToSource = false;
    List<E> sortedList = toList();
    sortedList.sort(compare);
    for (var entity in sortedList) {
      orderedEntities.add(entity);
    }
    orderedEntities.pre = true;
    orderedEntities.post = true;
    orderedEntities.propagateToSource = false;
    orderedEntities.source = this;
    return orderedEntities;
  }

  /// Returns entities that satisfy the predicate [f].
  @override
  Entities<E> selectWhere(bool Function(E) f) {
    if (_concept == null) {
      throw new ConceptException(
        'Entities.selectWhere: concept is not defined.',
      );
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    var selectedElements = _entityList.where(f);
    for (var entity in selectedElements) {
      selectedEntities.add(entity);
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns entities that have the given attribute value.
  @override
  Entities<E> selectWhereAttribute(String code, Object attribute) {
    if (_concept == null) {
      throw new ConceptException(
        'Entities.selectWhereAttribute($code, $attribute): concept is not defined.',
      );
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    for (E entity in _entityList) {
      for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
        if (a.code == code) {
          if (entity.getAttribute(a.code) == attribute) {
            selectedEntities.add(entity);
          }
        }
      }
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns entities that have the given parent.
  @override
  Entities<E> selectWhereParent(String code, IEntity parent) {
    if (_concept == null) {
      throw new ConceptException(
        'Entities.selectWhereParent($code, $parent): concept is not defined.',
      );
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    for (E entity in _entityList) {
      for (Parent p in _concept!.parents.whereType<Parent>()) {
        if (p.code == code) {
          if (entity.getParent(p.code) == parent) {
            selectedEntities.add(entity);
          }
        }
      }
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns all entities except the first [n].
  @override
  Entities<E> skipFirst(int n) {
    if (_concept == null) {
      throw new ConceptException('Entities.skipFirst: concept is not defined.');
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    var selectedElements = _entityList.skip(n);
    for (var entity in selectedElements) {
      selectedEntities.add(entity);
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns all entities after the first one that doesn't satisfy [f].
  @override
  Entities<E> skipFirstWhile(bool Function(E entity) f) {
    if (_concept == null) {
      throw new ConceptException(
        'Entities.skipFirstWhile: concept is not defined.',
      );
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    var selectedElements = _entityList.skipWhile(f);
    for (var entity in selectedElements) {
      selectedEntities.add(entity);
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns the first [n] entities.
  @override
  Entities<E> takeFirst(int n) {
    if (_concept == null) {
      throw new ConceptException('Entities.takeFirst: concept is not defined.');
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    var selectedElements = _entityList.take(n);
    for (var entity in selectedElements) {
      selectedEntities.add(entity);
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Returns all entities up to but not including the first one that doesn't satisfy [f].
  @override
  Entities<E> takeFirstWhile(bool Function(E entity) f) {
    if (_concept == null) {
      throw new ConceptException(
        'Entities.takeFirstWhile: concept is not defined.',
      );
    }

    Entities<E> selectedEntities = newEntities();
    selectedEntities.pre = false;
    selectedEntities.post = false;
    selectedEntities.propagateToSource = false;
    var selectedElements = _entityList.takeWhile(f);
    for (var entity in selectedElements) {
      selectedEntities.add(entity);
    }
    selectedEntities.pre = true;
    selectedEntities.post = true;
    selectedEntities.propagateToSource = true;
    selectedEntities.source = this;
    return selectedEntities;
  }

  /// Converts the collection to a JSON string.
  @override
  String toJson() => jsonEncode(toJsonList());

  /// Converts the collection to a list of JSON maps.
  List<Map<String, dynamic>> toJsonList() {
    List<Map<String, dynamic>> entityList = <Map<String, dynamic>>[];
    for (E entity in _entityList) {
      entityList.add(entity.toJsonMap());
    }
    return entityList;
  }

  /// Loads entities from a JSON string.
  @override
  void fromJson(String entitiesJson) {
    List<Map<String, dynamic>> entitiesList = jsonDecode(entitiesJson);
    fromJsonList(entitiesList);
  }

  /// Loads entities from a list of JSON maps.
  /// The collection must be empty before loading.
  void fromJsonList(entitiesList, [Entity? internalParent]) {
    if (_concept == null) {
      throw new ConceptException('entities concept does not exist.');
    }

    if (length > 0) {
      throw JsonException('entities are not empty');
    }
    var beforePre = pre;
    var beforePost = post;
    pre = false;
    post = false;
    for (var entityMap in entitiesList) {
      var entity = newEntity();
      entity.fromJsonMap(entityMap);
      add(entity as E);
    }
    pre = beforePre;
    post = beforePost;
  }

  /// Returns a string representation of this collection.
  @override
  String toString() {
    if (_concept == null) {
      throw new ConceptException('Entities.toString: concept is not defined.');
    }

    return '${_concept!.code}: entities:$length';
  }

  /// Removes all entities from the collection.
  @override
  void clear() {
    _entityList.clear();
    _oidEntityMap.clear();
    _codeEntityMap.clear();
    _idEntityMap.clear();
    exceptions.clear();
  }

  /// Sorts the entities using the given [compare] function.
  /// If [compare] is not provided, uses the entity's [compareTo] method.
  @override
  void sort([int Function(E a, E b)? compare]) {
    _entityList.sort(compare);
  }

  /// Validates an entity before adding it to the collection.
  @override
  bool isValid(E entity) {
    if (!pre) {
      return true;
    }

    if (entity._concept == null) {
      throw new ConceptException(
        'Entity(oid: ${entity.oid}) concept is not defined.',
      );
    }
    if (_concept == null) {
      throw new ConceptException('Entities.add: concept is not defined.');
    }
    if (!_concept!.canAdd) {
      throw new AddException('An entity cannot be added to ${_concept!.code}.');
    }

    // Clear any existing exceptions before validation
    exceptions.clear();

    bool isValid = true;

    // max validation
    isValid = validateCardinality(isValid);

    // increment and required validation
    isValid = validateIncrementAndRequired(entity, isValid);

    // uniqueness validation
    isValid = validateUnique(entity, isValid);

    return isValid;
  }

  /// Validates uniqueness constraints for an entity.
  bool validateUnique(entity, bool isValid) {
    if (entity.id != null && singleWhereId(entity.id) != null) {
      ValidationException exception = new ValidationException(
        'unique',
        '${entity.concept.code}.id ${entity.id.toString()} is not unique.',
      );
      exceptions.add(exception as IValidationExceptions);
      return false;
    }

    return isValid;
  }

  /// Validates increment and required constraints for an entity.
  bool validateIncrementAndRequired(entity, bool isValid) {
    bool result = isValid;

    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      var shouldIncrement = a.increment != null;
      var exists = entity.getAttribute(a.code) != null;
      var isRequired = a.required;
      var isDerived = a.derive;

      if (shouldIncrement) {
        if (length == 0) {
          entity.setAttribute(a.code, a.increment!);
        } else if (a.type?.code == 'int') {
          var lastEntity = last;
          int incrementAttribute = lastEntity.getAttribute(a.code) as int;
          var attributeUpdate = a.update;
          a.update = true;

          // Calculate the next sequence value
          int expectedValue = incrementAttribute + a.increment!;

          // Set the value directly rather than checking first
          entity.setAttribute(a.code, expectedValue);

          a.update = attributeUpdate;
        } else {
          throw TypeException(
            '${a.code} attribute value cannot be incremented.',
          );
        }
      } else if (isRequired && !exists) {
        const category = 'required';
        final message =
            '${entity.concept.code}.${a.code} attribute is required.';
        final exception = ValidationException(category, message);

        exceptions.add(exception);
        result = false;
      } else if (isDerived && exists) {
        // Derived attributes should not be updated by the user
        const category = 'update';
        final message =
            '${entity.concept.code}.${a.code} is a derived attribute and cannot be updated directly.';
        final exception = ValidationException(category, message);

        exceptions.add(exception);
        result = false;
      } else if (exists) {
        var value = entity.getAttribute(a.code);

        // Type validation
        if (!a.type!.validateValue(value)) {
          const category = 'type';
          final message =
              '${entity.concept.code}.${a.code} attribute value is not of type ${a.type!.code}.';
          final exception = ValidationException(category, message);

          exceptions.add(exception);
          result = false;
        }
        // String length validation
        else if (a.type!.base == 'String' &&
            value is String &&
            value.length > a.length) {
          const category = 'length';
          final message =
              '${entity.concept.code}.${a.code} attribute value exceeds maximum length of ${a.length}.';
          final exception = ValidationException(category, message);

          exceptions.add(exception);
          result = false;
        }
        // Email format validation
        else if (a.type!.code == 'Email' &&
            value is String &&
            !a.type!.isEmail(value)) {
          const category = 'format';
          final message =
              '${entity.concept.code}.${a.code} attribute value is not a valid email format.';
          final exception = ValidationException(category, message);

          exceptions.add(exception);
          result = false;
        }
      }
    }

    for (Parent p in _concept!.parents.whereType<Parent>()) {
      if (p.required && entity.getParent(p.code) == null) {
        const category = 'required';
        final message = '${entity.concept.code}.${p.code} parent is required.';
        final exception = ValidationException(category, message);

        exceptions.add(exception);
        result = false;
      }
    }

    return result;
  }

  /// Validates cardinality constraints.
  bool validateCardinality(bool isValid) {
    if (maxC != 'N') {
      int maxInt;
      try {
        maxInt = int.parse(maxC);
        if (length == maxInt) {
          const category = 'max cardinality';
          final message = '${_concept!.code}.max is $maxC.';
          var exception = ValidationException(category, message);

          exceptions.add(exception);
          return false;
        }
      } on FormatException catch (e) {
        throw AddException(
          'Entities max is neither N nor a positive integer string: $e',
        );
      }
    }
    return isValid;
  }

  /// Adds an entity to the collection if it passes validation.
  @override
  bool add(dynamic entity) {
    bool added = false;
    if (isValid(entity)) {
      var propagated = true;
      if (source != null && propagateToSource) {
        propagated = source!.add(entity);
      }
      if (propagated) {
        _entityList.add(entity);
        _oidEntityMap[entity.oid.timeStamp] = entity;
        _codeEntityMap[entity.code] = entity;
        if (entity.id != null) {
          _idEntityMap[entity.id.toString()] = entity;
        }
        if (postAdd(entity)) {
          added = true;
          entity._whenAdded = DateTime.now();
        } else {
          var beforePre = pre;
          var beforePost = post;
          pre = false;
          post = false;
          if (!remove(entity)) {
            var msg =
                '${entity.concept.code} entity (${entity.oid}) '
                'was added, post was not successful, remove was not successful';
            throw RemoveException(msg);
          } else {
            entity._whenAdded = null;
          }
          pre = beforePre;
          post = beforePost;
        }
      } else {
        var msg =
            '${entity.concept.code} entity (${entity.oid}) '
            'was not added - propagation to the source ${source?.concept.code} '
            'entities was not successful';
        throw AddException(msg);
      }
    }
    return added;
  }

  /// Validates an entity after adding it to the collection.
  @override
  bool postAdd(E entity) {
    if (!post) {
      return true;
    }

    if (entity._concept == null) {
      throw new ConceptException(
        'Entity(oid: ${entity.oid}) concept is not defined.',
      );
    }
    if (_concept == null) {
      throw new ConceptException('Entities.add: concept is not defined.');
    }

    bool result = true;

    return result;
  }

  /// Validates an entity before removing it from the collection.
  @override
  bool preRemove(E entity) {
    if (!pre) {
      return true;
    }

    if (entity._concept == null) {
      throw new ConceptException(
        'Entity(oid: ${entity.oid}) concept is not defined.',
      );
    }
    if (_concept == null) {
      throw new ConceptException('Entities.remove: concept is not defined.');
    }
    if (!_concept!.remove) {
      throw new RemoveException(
        'An entity cannot be removed from ${_concept!.code}.',
      );
    }

    bool result = true;

    // min validation
    if (minC != '0') {
      int minInt;
      try {
        minInt = int.parse(minC);
        if (length == minInt) {
          const category = 'min';
          final message = '${_concept!.code}.min is $minC.';
          ValidationException exception = ValidationException(
            category,
            message,
          );

          exceptions.add(exception);
          result = false;
        }
      } on FormatException catch (e) {
        throw RemoveException(
          'Entities min is not a positive integer string: $e',
        );
      }
    }

    return result;
  }

  /// Removes an entity from the collection if it passes validation.
  @override
  bool remove(E entity) {
    bool removed = false;
    if (preRemove(entity)) {
      var propagated = true;
      if (source != null && propagateToSource) {
        propagated = source!.remove(entity);
      }
      if (propagated) {
        if (_entityList.remove(entity)) {
          _oidEntityMap.remove(entity.oid.timeStamp);
          _codeEntityMap.remove(entity.code);
          if (entity._concept != null && entity.id != null) {
            _idEntityMap.remove(entity.id.toString());
          }
          if (postRemove(entity)) {
            removed = true;
            entity._whenRemoved = DateTime.now();
          } else {
            var beforePre = pre;
            var beforePost = post;
            pre = false;
            post = false;
            if (!add(entity)) {
              var msg =
                  '${entity.concept.code} entity (${entity.oid}) '
                  'was removed, post was not successful, add was not successful';
              throw AddException(msg);
            } else {
              entity._whenRemoved = null;
            }
            pre = beforePre;
            post = beforePost;
          }
        }
      } else {
        var msg =
            '${entity.concept.code} entity (${entity.oid}) '
            'was not removed - propagation to the source ${source!.concept.code} '
            'entities was not successful';
        throw RemoveException(msg);
      }
    }
    return removed;
  }

  /// Validates an entity after removing it from the collection.
  @override
  bool postRemove(E entity) {
    if (!post) {
      return true;
    }

    if (entity._concept == null) {
      throw new ConceptException(
        'Entity(oid: ${entity.oid}) concept is not defined.',
      );
    }
    if (_concept == null) {
      throw new ConceptException('Entities.add: concept is not defined.');
    }
    bool result = true;

    return result;
  }

  /// Updates an entity by removing the old version and adding the new version.
  /// Only works if oid, code, or id are changed.
  bool update(E beforeEntity, E afterEntity) {
    if (_concept == null) {
      throw new ConceptException('Entities.update: concept is not defined.');
    }
    if (beforeEntity.oid == afterEntity.oid &&
        beforeEntity.code == afterEntity.code &&
        beforeEntity.id == afterEntity.id) {
      throw UpdateException(
        '${_concept!.code}.update can only be used if oid, code or id set.',
      );
    }
    if (remove(beforeEntity)) {
      if (add(afterEntity)) {
        return true;
      } else {
        print('entities.update: ${exceptions.toList()}');
        if (add(beforeEntity)) {
          const category = 'update';
          final message =
              '${_concept!.code}.update fails to add after update entity.';
          var exception = ValidationException(category, message);
          exceptions.add(exception);
        } else {
          throw UpdateException(
            '${_concept!.code}.update fails to add back before update entity.',
          );
        }
      }
    } else {
      const category = 'update';
      final message =
          '${_concept!.code}.update fails to remove before update entity.';
      var exception = ValidationException(category, message);

      exceptions.add(exception);
    }
    return false;
  }

  /// Adds all entities from another collection.
  bool addFrom(Entities<E> entities) {
    bool allAdded = true;
    if (_concept == entities.concept) {
      for (var entity in entities) {
        add(entity) ? true : allAdded = false;
      }
    } else {
      throw ConceptException('The concept of the argument is different.');
    }
    return allAdded;
  }

  /// Removes all entities from another collection.
  bool removeFrom(Entities<E> entities) {
    bool allRemoved = true;
    if (_concept == entities.concept) {
      for (var entity in entities) {
        remove(entity) ? true : allRemoved = false;
      }
    } else {
      throw ConceptException('The concept of the argument is different.');
    }
    return allRemoved;
  }

  /// Updates attributes of entities from another collection.
  bool setAttributesFrom(Entities<E> entities) {
    bool allSet = true;
    if (_concept == entities.concept) {
      for (var entity in entities) {
        var baseEntity = singleWhereOid(entity.oid);
        if (baseEntity != null) {
          var baseEntitySet = baseEntity.setAttributesFrom(entity);
          if (!baseEntitySet) {
            allSet = false;
          }
        } else {
          allSet = false;
        }
      }
    } else {
      throw ConceptException('The concept of the argument is different.');
    }
    return allSet;
  }

  /// Displays the entities in a formatted way.
  void display({
    String title = 'Entities',
    String prefix = '',
    bool withOid = true,
    bool withChildren = true,
    bool withInternalChildren = true,
  }) {
    if (_concept == null) {
      throw new ConceptException('Entities.display: concept is not defined.');
    }

    var s = prefix;

    bool thereIsNoEntry = !(_concept!.entry);
    bool thereIsEntry = _concept!.entry;
    bool thereIsParent = _concept!.parents.isNotEmpty;

    if (thereIsNoEntry || (thereIsEntry && thereIsParent)) {
      s = '$prefix  ';
    }
    if (title != '') {
      print('$s======================================');
      print('$s$title                                ');
      print('$s======================================');
    }
    for (E e in _entityList) {
      e.display(
        prefix: s,
        withOid: withOid,
        withChildren: withChildren,
        withInternalChildren: withInternalChildren,
      );
    }
  }

  /// Displays the OID map.
  void displayOidMap() {
    _oidEntityMap.forEach((k, v) {
      print('oid $k: $v');
    });
  }

  /// Displays the code map.
  void displayCodeMap() {
    _codeEntityMap.forEach((k, v) {
      print('code $k: $v');
    });
  }

  /// Displays the ID map.
  void displayIdMap() {
    _idEntityMap.forEach((k, v) {
      print('id $k: $v');
    });
  }

  /// Returns an iterable that yields all entities from this collection followed by [other].
  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _entityList.followedBy(other);
  }

  /// Returns an iterable that yields all entities of type [T].
  @override
  Iterable<T> whereType<T>() {
    return _entityList.whereType<T>();
  }

  /// Integrates entities from another collection.
  @override
  void integrate(IEntities<E> fromEntities) {
    for (var entity in toList()) {
      var fromEntity = fromEntities.singleWhereOid(entity.oid);
      if (fromEntity == null) {
        remove(entity);
      }
    }
    for (var fromEntity in fromEntities) {
      var entity = singleWhereOid(fromEntity.oid);
      if (entity != null && entity.whenSet != null) {
        if (entity.whenSet!.millisecondsSinceEpoch <
            fromEntity.whenSet!.millisecondsSinceEpoch) {
          entity.setAttributesFrom(fromEntity);
        }
      } else {
        add(fromEntity);
      }
    }
  }

  /// Integrates entities to add from another collection.
  @override
  void integrateAdd(IEntities<E> addEntities) {
    for (var addEntity in addEntities) {
      var entity = singleWhereOid(addEntity.oid);
      if (entity == null) {
        add(addEntity);
      }
    }
  }

  /// Integrates entities to remove from another collection.
  @override
  void integrateRemove(IEntities<E> removeEntities) {
    for (var removeEntity in removeEntities) {
      var entity = singleWhereOid(removeEntity.oid);
      if (entity != null) {
        remove(entity);
      }
    }
  }

  /// Integrates entities to set from another collection.
  @override
  void integrateSet(IEntities<E> setEntities) {
    for (var setEntity in setEntities) {
      var entity = singleWhereOid(setEntity.oid);
      if (entity != null && entity.whenSet != null) {
        if (entity.whenSet!.millisecondsSinceEpoch <
            setEntity.whenSet!.millisecondsSinceEpoch) {
          entity.setAttributesFrom(setEntity);
        }
      }
    }
  }

  /// Returns an iterable that yields all entities cast to type [T].
  @override
  Iterable<T> cast<T>() {
    final it = () sync* {
      for (var e in this) {
        yield e;
      }
    }();
    try {
      it.elementAt(0);
    } on TypeError catch (_) {
      throw TypeError();
    }
    return it as Iterable<T>;
  }

  /// Converts the collection to a graph structure.
  Map<String, dynamic> toGraph() {
    return {
      'type': runtimeType.toString(),
      'entities': _entityList.map((entity) => entity.toGraph()).toList(),
    };
  }
}
