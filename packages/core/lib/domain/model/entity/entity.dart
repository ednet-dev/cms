part of ednet_core;

class Entity<E extends Entity<E>> implements IEntity<E> {
  Concept? _concept;
  var _oid = Oid();
  String? _code;
  DateTime? _whenAdded;
  DateTime? _whenSet;
  DateTime? _whenRemoved;
  @override
  var exceptions = ValidationExceptions();

  Map<String, Object?> _attributeMap = <String, Object?>{};

  // cannot use T since a parent is of a different type
  Map<String, Reference> _referenceMap = <String, Reference>{};
  Map<String, Object?> _parentMap = <String, Object?>{};
  Map<String, Object?> _childMap = <String, Object?>{};
  Map<String, Object?> _internalChildMap = <String, Object?>{};

  bool pre = false;
  bool post = false;

  Entity<E> newEntity() {
    var entity = Entity<E>();
    entity.concept = _concept!;
    return entity;
  }

  Entities<E> newEntities() {
    var entities = Entities<E>();
    entities.concept = _concept!;
    return entities;
  }

  @override
  Concept get concept {
    if (_concept == null) {
      throw EDNetException("concept is not set");
    }

    return _concept!;
  }

  set concept(Concept concept) {
    _concept = concept;
    _attributeMap = <String, Object?>{};
    _referenceMap = <String, Reference>{};
    _parentMap = <String, Object?>{};
    _childMap = <String, Object?>{};
    _internalChildMap = <String, Object?>{};

    pre = true;
    post = true;

    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.init == null) {
        // _attributeMap[a.code!] = null;
      } else if (a.type?.code! == 'DateTime' && a.init == 'now') {
        _attributeMap[a.code!] = DateTime.now();
      } else if (a.type?.code! == 'bool' && a.init == 'true') {
        _attributeMap[a.code!] = true;
      } else if (a.type?.code! == 'bool' && a.init == 'false') {
        _attributeMap[a.code!] = false;
      } else if (a.type?.code! == 'int') {
        try {
          _attributeMap[a.code!] = int.parse(a.init);
        } on FormatException catch (e) {
          throw TypeException(
              '${a.code!} attribute init (default) value is not int: $e');
        }
      } else if (a.type?.code! == 'double') {
        try {
          _attributeMap[a.code!] = double.parse(a.init);
        } on FormatException catch (e) {
          throw TypeException(
              '${a.code!} attribute init (default) value is not double: $e');
        }
      } else if (a.type?.code! == 'num') {
        try {
          _attributeMap[a.code!] = int.parse(a.init);
        } on FormatException catch (e1) {
          try {
            _attributeMap[a.code!] = double.parse(a.init);
          } on FormatException catch (e2) {
            throw TypeException(
                '${a.code!} attribute init (default) value is not num: $e1; $e2');
          }
        }
      } else if (a.type?.code! == 'Uri') {
        try {
          _attributeMap[a.code!] = Uri.parse(a.init);
        } on ArgumentError catch (e) {
          throw TypeException(
              '${a.code!} attribute init (default) value is not Uri: $e');
        }
      } else {
        _attributeMap[a.code!] = a.init;
      }
    } // for

    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      _referenceMap.remove(parent.code!);
      _parentMap.remove(parent.code!);
    }

    for (Child child in _concept!.children.whereType<Child>()) {
      var childEntities = Entities<E>();
      childEntities.concept = child.destinationConcept;
      _childMap[child.code!] = childEntities;
      if (child.internal) {
        _internalChildMap[child.code!] = childEntities;
      }
    }
  }

  @override
  Oid get oid => _oid;

  set oid(Oid oid) {
    if (_concept!.updateOid) {
      _oid = oid;
    } else {
      throw OidException('Entity.oid cannot be updated.');
    }
  }

  @override
  Id? get id {
    if (_concept == null) {
      return null;
      // throw new ConceptException('Entity concept is not defined.');
    }
    Id id = Id(_concept!);
    for (Parent p in _concept!.parents.whereType<Parent>()) {
      if (p.identifier) {
        id.setReference(p.code!, _referenceMap[p.code!]);
      }
    }
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        id.setAttribute(a.code!, _attributeMap[a.code!]);
      }
    }
    if (id.length == 0) {
      return null;
    }
    return id;
  }

  @override
  String? get code => _code;

  set code(String? code) {
    if (_code == null || _concept!.updateCode) {
      _code = code;
    } else {
      throw CodeException('Entity.code! cannot be updated.');
    }
  }

  @override
  DateTime? get whenAdded => _whenAdded;

  @override
  set whenAdded(DateTime? whenAdded) {
    if (_concept!.updateWhen) {
      _whenAdded = whenAdded;
    } else {
      throw UpdateException('Entity.whenAdded cannot be updated.');
    }
  }

  @override
  DateTime? get whenSet => _whenSet;

  @override
  set whenSet(DateTime? whenSet) {
    if (_concept!.updateWhen) {
      _whenSet = whenSet;
    } else {
      throw UpdateException('Entity.whenSet cannot be updated.');
    }
  }

  @override
  DateTime? get whenRemoved => _whenRemoved;

  @override
  set whenRemoved(DateTime? whenRemoved) {
    if (_concept!.updateWhen) {
      _whenRemoved = whenRemoved;
    } else {
      throw UpdateException('Entity.whenRemoved cannot be updated.');
    }
  }

  String get codeFirstLetterLower => firstLetterLower(code!);

  String get codeFirstLetterUpper => firstLetterUpper(code!);

  String get codeLowerUnderscore => camelCaseLowerSeparator(code!, '_');

  String get codeLowerSpace => camelCaseLowerSeparator(code!, ' ');

  String get codePlural => plural(code!);

  String get codePluralFirstLetterLower => firstLetterLower(codePlural);

  String get codePluralFirstLetterUpper => firstLetterUpper(codePlural);

  String get codePluralLowerUnderscore =>
      camelCaseLowerSeparator(codePlural, '_');

  String get codePluralFirstLetterUpperSpace =>
      camelCaseFirstLetterUpperSeparator(codePlural, ' ');

  @override
  bool preSetAttribute(String name, Object? value) {
    if (!pre) {
      return true;
    }

    if (_concept == null) {
      throw new ConceptException('Entity(oid: ${oid}) concept is not defined.');
    }
    return true;
  }

  @override
  K? getAttribute<K>(String attributeCode) =>
      _attributeMap[attributeCode] as K?;

  @override
  bool setAttribute(String name, Object? value) {
    bool updated = false;
    if (preSetAttribute(name, value)) {
      if (_concept == null) {
        throw new ConceptException('Entity concept is not defined.');
      }

      var attribute = _concept!.attributes.singleWhereCode(name);
      if (attribute == null) {
        String msg = '${_concept!.code!}.$name is not correct attribute name.';
        throw UpdateException(msg);
      }
      /*
       * validation done in Entities.preAdd
      if (value == null && attribute.minc != '0') {
        String msg = '${_concept!.code!}.$name cannot be null.';
        throw new UpdateException(msg);
      }
      */
      Object? beforeValue = _attributeMap[name];
      if (getAttribute(name) == null) {
        _attributeMap[name] = value;
        updated = true;
        //} else if (!attribute.derive && attribute.update) {
      } else if (attribute.update) {
        _attributeMap[name] = value;
        updated = true;
        _whenSet = DateTime.now();
      } else {
        String msg = '${_concept!.code!}.${attribute.code!} is not updatable.';
        throw UpdateException(msg);
      }
      if (postSetAttribute(name, value)) {
        updated = true;
      } else {
        var beforePre = pre;
        var beforePost = post;
        pre = false;
        post = false;
        if (beforeValue == null || !setAttribute(name, beforeValue)) {
          var msg = '${_concept!.code!}.${attribute.code!} '
              'was set to a new value, post was not successful, '
              'set to the before value was not successful';
          throw RemoveException(msg);
        } else {
          _whenSet = null;
        }
        pre = beforePre;
        post = beforePost;
      }
    }
    return updated;
  }

  @override
  bool postSetAttribute(String name, Object? value) {
    if (!post) {
      return true;
    }

    if (_concept == null) {
      throw new ConceptException('Entity(oid: ${oid}) concept is not defined.');
    }
    return true;
  }

  @override
  String getStringFromAttribute(String name) => _attributeMap[name].toString();

  @override
  String? getStringOrNullFromAttribute(String name) =>
      _attributeMap[name]?.toString();

  @override
  bool setStringToAttribute(String name, String string) {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }
    Attribute? attribute =
        _concept!.attributes.singleWhereCode(name) as Attribute?;
    if (attribute == null) {
      String msg = '${_concept!.code!}.$name is not correct attribute name.';
      throw UpdateException(msg);
    }

    if (string == 'null') {
      return setAttribute(name, null);
    }
    if (attribute.type?.code! == 'DateTime') {
      try {
        return setAttribute(name, DateTime.parse(string));
      } on ArgumentError catch (e) {
        throw TypeException('${_concept!.code!}.${attribute.code!} '
            'attribute value is not DateTime: $e');
      }
    } else if (attribute.type?.code! == 'bool') {
      if (string == 'true') {
        return setAttribute(name, true);
      } else if (string == 'false') {
        return setAttribute(name, false);
      } else {
        throw TypeException('${attribute.code!} '
            'attribute value is not bool.');
      }
    } else if (attribute.type?.code! == 'int') {
      try {
        return setAttribute(name, int.parse(string));
      } on FormatException catch (e) {
        throw TypeException('${attribute.code!} '
            'attribute value is not int: $e');
      }
    } else if (attribute.type?.code! == 'double') {
      try {
        return setAttribute(name, double.parse(string));
      } on FormatException catch (e) {
        throw TypeException('${attribute.code!} '
            'attribute value is not double: $e');
      }
    } else if (attribute.type?.code! == 'num') {
      try {
        return setAttribute(name, int.parse(string));
      } on FormatException catch (e1) {
        try {
          return setAttribute(name, double.parse(string));
        } on FormatException catch (e2) {
          throw TypeException(
              '${attribute.code!} attribute value is not num: $e1; $e2');
        }
      }
    } else if (attribute.type?.code! == 'Uri') {
      try {
        return setAttribute(name, Uri.parse(string));
      } on ArgumentError catch (e) {
        throw TypeException(
            '${attribute.code!} attribute value is not Uri: $e');
      }
    } else {
      // other
      return setAttribute(name, string);
    }
  }

  Reference? getReference(String name) => _referenceMap[name];

  void setReference(String name, Reference reference) {
    if (getParent(name) == null) {
      _referenceMap[name] = reference;
    }
  }

  @override
  Object? getParent(String name) => _parentMap[name];

  Object? getInternalChild(String name) => _internalChildMap[name];

  @override
  Object? getChild(String? name) {
    return _childMap[name];
    // Map<String, Entities<C>> r = _childMap.cast<String, Entities<C>>();
    // var h = r.containsKey(name);
    // Entities<C> val = r[name] as Entities<C>;
    // return val;
  }

  bool setAttributesFrom(Entity entity) {
    bool allSet = true;
    if (entity.whenSet?.millisecondsSinceEpoch != null &&
        whenSet?.millisecondsSinceEpoch != null &&
        (whenSet!.millisecondsSinceEpoch <
            entity.whenSet!.millisecondsSinceEpoch)) {
      for (Attribute attribute in _concept!.nonIdentifierAttributes) {
        var newValue = entity.getAttribute(attribute.code!);
        var attributeSet = setAttribute(attribute.code!, newValue);
        if (!attributeSet) {
          allSet = false;
        }
      }
    } else {
      allSet = false;
    }
    return allSet;
  }

  /// Copies the entity (oid, code, attributes and neighbors).
  /// It is not a deep copy.
  @override
  E copy() {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }

    Entity<E> entity = newEntity();

    var beforeUpdateOid = entity.concept.updateOid;
    entity.concept.updateOid = true;
    entity.oid = _oid;
    entity.concept.updateOid = beforeUpdateOid;

    if (_code != null) {
      var beforeUpdateCode = entity.concept.updateCode;
      entity.concept.updateCode = true;
      entity.code = _code;
      entity.concept.updateCode = beforeUpdateCode;
    }

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

    for (Attribute attribute in _concept!.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        var beforeUpdate = attribute.update;
        attribute.update = true;
        entity.setAttribute(attribute.code!, _attributeMap[attribute.code!]);
        attribute.update = beforeUpdate;
      } else {
        entity.setAttribute(attribute.code!, _attributeMap[attribute.code!]);
      }
    }

    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      if (parent.identifier) {
        final pId = parent.id;
        final pOiId = parent.oid;
        final pCode = parent.code;

        var beforeUpdate = parent.update;
        parent.update = true;
        entity.setParent(parent.code!, _parentMap[parent.code!]);
        parent.update = beforeUpdate;
      } else if (_parentMap[parent.code!] != null) {
        entity.setParent(parent.code!, _parentMap[parent.code!]);
      }
    }

    for (Child child in _concept!.children.whereType<Child>()) {
      entity.setChild(child.code!, _childMap[child.code!]!);
    }

    return entity as E;
  }

  @override
  int get hashCode => _oid.hashCode;

  /// Two entities are equal if their oids are equal.
  bool equals(E entity) {
    if (_oid.equals(entity.oid)) {
      return true;
    }
    return false;
  }

  /// == see:
  /// https://www.dartlang.org/docs/dart-up-and-running/contents/ch02.html#op-equality
  ///
  /// To test whether two objects x and y represent the same thing,
  /// use the == operator.
  ///
  /// (In the rare case where you need to know
  /// whether two objects are the exact same object, use the identical()
  /// function instead.)
  ///
  /// Here is how the == operator works:
  ///
  /// If x or y is null, return true if both are null,
  /// and false if only one is null.
  ///
  /// Return the result of the method invocation x.==(y).
  ///
  /// Evolution:
  ///
  /// If x===y, return true.
  /// Otherwise, if either x or y is null, return false.
  /// Otherwise, return the result of x.equals(y).
  ///
  /// The newer spec is:
  /// a) if either x or y is null, do identical(x, y)
  /// b) otherwise call operator ==
  ///
  /// Read:
  /// http://work.j832.com/2014/05/equality-and-dart.html
  /// http://stackoverflow.com/questions/29567322/how-does-a-set-determine-that-two-objects-are-equal-in-dart
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

  /*
  bool operator ==(Object other) {
    if (other is Entity) {
      Entity entity = other;
      if (this == null && entity == null) {
        return true;
      } else if (this == null || entity == null) {
        return false;
      } else if (identical(this, entity)) {
        return true;
      } else {
        return equals(entity);
      }
    } else {
      return false;
    }
  }
  */

  /// Checks if the entity is equal in content to the given entity.
  /// Two entities are equal if they have the same content, ignoring oid and when.
  bool equalContent(E entity) {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }

    if (_code != entity.code!) {
      return false;
    }
    for (Attribute a in _concept!.attributes.whereType<Attribute>()) {
      if (_attributeMap[a.code!] != entity.getAttribute(a.code!)) {
        return false;
      }
    }
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      if (_parentMap[parent.code!] != entity.getParent(parent.code!)) {
        return false;
      }
    }
    for (Child child in _concept!.children.whereType<Child>()) {
      if (_childMap[child.code!] != entity.getChild(child.code!)) {
        return false;
      }
    }
    return true;
  }

  /// Compares two entities based on codes, ids or attributes.
  /// If the result is less than 0 then the first entity is less than the second,
  /// if it is equal to 0 they are equal and
  /// if the result is greater than 0 then the first is greater than the second.
  @override
  int compareTo(entity) {
    if (code?.isNotEmpty ?? false) {
      return _code!.compareTo(entity.code!);
    } else if (entity.id != null && id != null) {
      return id!.compareTo(entity.id);
    } else if (concept.attributes.isNotEmpty) {
      return compareAttributes(entity);
    } else {
      String msg = '${_concept!.code!} concept does not have attributes.';
      throw IdException(msg);
    }
  }

  /// Compares two entities based on their attributes.
  /// If the result is less than 0 then the first id is less than the second,
  /// if it is equal to 0 they are equal and
  /// if the result is greater than 0 then the first is greater than the second.
  int compareAttributes(E entity) {
    var compare = 0;
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      var value1 = _attributeMap[a.code!];
      var value2 = entity.getAttribute(a.code!);

      // todo: check if this works
      compare = a.type?.compare(value1, value2) ?? 0;
      if (compare != 0) {
        break;
      }
    } // for
    return compare;
  }

  /// Returns a string that represents this entity by using oid and code.
  @override
  String toString() {
    if (_code == null) {
      return '{${_concept!.code!}: {oid:${_oid.toString()}}}';
    } else {
      return '{${_concept!.code!}: {oid:${_oid.toString()}, code:$_code}}';
    }
  }

  void displayToString() {
    print(toString());
  }

  /// Displays (prints) an entity with its attributes, parents and children.
  void display(
      {String prefix = '',
      bool withOid = true,
      bool withChildren = true,
      bool withInternalChildren = true}) {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }

    var s = prefix;
    if (!(_concept!.entry) ||
        ((_concept!.entry) && _concept!.parents.isNotEmpty)) {
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

    _attributeMap.forEach((k, v) {
      if (_concept!.isAttributeSensitive(k)) {
        print('$s$k: **********');
      } else {
        print('$s$k: $v');
      }
    });

    _parentMap.forEach((k, v) {
      if (_concept!.isParentSensitive(k)) {
        print('$s$k: **********');
      } else {
        print('$s$k: ${v.toString()}');
      }
    });

    if (withChildren) {
      if (withInternalChildren) {
        _internalChildMap.forEach((k, v) {
          print('$s$k:');
          if (_concept!.isChildSensitive(k)) {
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
          if (_concept!.isChildSensitive(k)) {
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

  @override
  String toJson() => jsonEncode(toJsonMap());

  Map<String, Object> toJsonMap() {
    Map<String, Object> entityMap = <String, Object>{};
    for (Parent parent in _concept!.parents.whereType<Parent>()) {
      Entity? parentEntity = getParent(parent.code!) as Entity?;
      if (parentEntity != null) {
        var reference = <String, String>{};
        reference['oid'] = parentEntity.oid.toString();
        reference['parent'] = parentEntity.concept.code!;
        reference['entry'] = parentEntity.concept.entryConcept.code!;
        entityMap[parent.code!] = reference;
      } else {
        entityMap[parent.code!] = 'null';
      }
    }
    entityMap['oid'] = _oid.toString();
    entityMap['code'] = _code ?? '';
    entityMap['whenAdded'] = _whenAdded.toString();
    entityMap['whenSet'] = _whenSet.toString();
    entityMap['whenRemoved'] = _whenRemoved.toString();

    for (var k in _attributeMap.keys) {
      entityMap[k] = getStringFromAttribute(k);
    }

    for (var k in _internalChildMap.keys) {
      entityMap[k] = (getInternalChild(k) as Entities).toJsonList();
    }
    return entityMap;
  }

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    Map<String, Object> entityMap = jsonDecode(entityJson);
    fromJsonMap(entityMap);
  }

  /// Loads data from a json map.
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
    var beforeUpdateOid = concept.updateOid;
    concept.updateOid = true;
    oid = Oid.ts(timeStamp);
    concept.updateOid = beforeUpdateOid;

    var beforeUpdateCode = concept.updateCode;
    concept.updateCode = true;
    code = entityMap['code'] as String;
    concept.updateCode = beforeUpdateCode;

    var beforeUpdateWhen = concept.updateWhen;
    concept.updateWhen = true;
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
    for (Attribute attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        var beforeUpdate = attribute.update;
        attribute.update = true;
        setStringToAttribute(attribute.code!, entityMap[attribute.code!]);
        attribute.update = beforeUpdate;
      } else if (attribute.code != null && entityMap[attribute.code!] != null) {
        setStringToAttribute(attribute.code!, entityMap[attribute.code!]);
      }
    }
    _neighborsFromJsonMap(entityMap, internalParent);
    pre = beforePre;
  }

  /// Loads neighbors from a json map.
  void _neighborsFromJsonMap(entityMap, [Entity? internalParent]) {
    for (Child child in concept.children.whereType<Child>()) {
      if (child.internal) {
        var entitiesList = entityMap[child.code!];
        var childEntities = getChild(child.code!) as Entities?;
        childEntities?.fromJsonList(entitiesList, this);
        setChild(child.code!, childEntities as Object);
      }
    }

    for (Parent parent in concept.parents.whereType<Parent>()) {
      var parentReference = entityMap[parent.code!];
      if (parentReference == null || parentReference == 'null') {
        if (parent.minc != '0') {
          throw ParentException('${parent.code!} parent cannot be null.');
        }
      } else if (parentReference != null) {
        String? parentOidString = parentReference['oid'];
        String? parentConceptCode = parentReference['parent'];
        String? entryConceptCode = parentReference['entry'];
        if (parentConceptCode != null &&
            parentOidString != null &&
            entryConceptCode != null) {
          Reference reference =
              Reference(parentOidString, parentConceptCode, entryConceptCode);
          Oid parentOid = reference.oid;
          setReference(parent.code!, reference);
          if (parent.internal) {
            if (parentOid == internalParent?.oid) {
              setParent(parent.code!, internalParent);
            } else {
              var msg = """

              =============================================
              Internal parent oid is wrong, create issue for ${parent.code!}
              on https://github.com/context-dev/cms/issues/new?title=_neighborsFromJsonMap%20bug                           
              ---------------------------------------------                            
              model_entries.dart: entity.setParent(parent.code!, internalParent); 
              internal parent oid: ${internalParent?.oid}                  
              entity concept: ${concept.code!}                   
              entity oid: $oid                                
              parent oid: $parentOidString                           
              parent code: ${parent.code!}                              
              parent concept: $parentConceptCode                     
              entry concept for parent: $entryConceptCode            
              ---------------------------------------------
            """;
              throw ParentException(msg);
            } // else
          }
        }
      } // else
    } // for
  }

  @override
  bool setChild(String name, Object entities) {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }

    Child? child = _concept!.children.singleWhereCode(name) as Child?;
    if (child == null) {
      String msg =
          '${_concept!.code!}.$name is not correct child entities name.';
      throw UpdateException(msg);
    }

    if (child.update) {
      _childMap.update(name, (value) => entities);
      if (child.internal) {
        _internalChildMap[name] = entities;
      }
      return true;
    } else {
      return false;
      // String msg = '${_concept!.code!}.${child.code!} is not updatable.';
      // throw UpdateException(msg);
    }
  }

  @override
  bool setParent(String name, entity) {
    if (_concept == null) {
      throw new ConceptException('Entity concept is not defined.');
    }

    Parent? parent = _concept!.parents.singleWhereCode(name) as Parent?;
    if (parent == null) {
      String msg =
          '${_concept!.code!}.$name is not correct parent entity name.';
      throw UpdateException(msg);
    }

    if (entity != null && getParent(name) == null) {
      var reference = Reference(entity.oid.toString(), entity.concept.code!,
          entity.concept.entryConcept.code!);
      _parentMap[name] = entity;
      _referenceMap[name] = reference;
      return true;
    } else if (entity != null && parent.update) {
      var reference = Reference(entity.oid.toString(), entity.concept.code!,
          entity.concept.entryConcept.code!);
      _parentMap[name] = entity;
      _referenceMap[name] = reference;
      return true;
    } else {
      String msg = '${_concept!.code!}.${parent.code!} is not updatable.';
      throw UpdateException(msg);
    }
  }
}
