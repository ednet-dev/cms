part of ednet_core;

/// A unique identifier for a domain entity that implements the [IId] interface.
///
/// The [Id] class represents a composite identifier that can be composed of:
/// - References to parent entities (through [Reference] objects)
/// - Attribute values that form part of the identifier
///
/// The class maintains two internal maps:
/// - [_referenceMap]: Maps parent codes to their references
/// - [_attributeMap]: Maps attribute codes to their values
///
/// Example usage:
/// ```dart
/// final id = Id(productConcept);
/// id.setAttribute('code', 'PROD-001');
/// id.setParent('category', categoryEntity);
/// ```
class Id implements IId<Id> {
  /// The [Concept] that defines the metadata for this identifier.
  final Concept _concept;

  /// Maps parent codes to their references.
  final Map<String, Reference?> _referenceMap;

  /// Maps attribute codes to their values.
  final Map<String, Object?> _attributeMap;

  /// Creates a new identifier for the given [concept].
  /// Initializes empty maps for references and attributes.
  /// Removes any identifier parents or attributes from the maps.
  Id(this._concept)
      : _referenceMap = <String, Reference?>{},
        _attributeMap = <String, Object?>{} {
    for (Parent p in _concept.parents.whereType<Parent>()) {
      if (p.identifier) {
        _referenceMap.remove(p.code);
      }
    }
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        _attributeMap.remove(a.code);
      }
    }
  }

  /// Gets the [concept] for this identifier.
  @override
  Concept get concept => _concept;

  /// Gets the number of parent references in this identifier.
  @override
  int get referenceLength => _referenceMap.length;

  /// Gets the number of attributes in this identifier.
  @override
  int get attributeLength => _attributeMap.length;

  /// Gets the total number of components (references + attributes) in this identifier.
  @override
  int get length => referenceLength + attributeLength;

  /// Gets the reference for the given parent [code].
  @override
  Reference? getReference(String code) => _referenceMap[code];

  /// Sets the reference for the given parent [code].
  @override
  void setReference(String code, Reference? reference) {
    _referenceMap[code] = reference;
  }

  /// Sets a parent entity reference for the given parent [code].
  /// Creates a new [Reference] from the entity's OID and concept information.
  void setParent(String code, Entity entity) {
    Reference reference = Reference(entity.oid.toString(), entity.concept.code,
        entity.concept.entryConcept.code);
    setReference(code, reference);
  }

  /// Gets the attribute value for the given attribute [code].
  @override
  Object? getAttribute(String code) => _attributeMap[code];

  /// Sets the attribute value for the given attribute [code].
  @override
  void setAttribute(String code, Object? attribute) {
    _attributeMap[code] = attribute;
  }

  /// Computes the hash code for this identifier based on its concept,
  /// references, and attributes.
  @override
  int get hashCode =>
      (_concept.hashCode + _referenceMap.hashCode + _attributeMap.hashCode)
          .hashCode;

  /// Checks if the parent references of this identifier are equal to those of [id].
  /// Only compares identifier parents (those marked with [Parent.identifier]).
  bool equalParents(Id id) {
    for (Parent p in _concept.parents.whereType<Parent>()) {
      if (p.identifier) {
        final refA = _referenceMap[p.code];
        final refB = id.getReference(p.code);
        if (refA != refB) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the attributes of this identifier are equal to those of [id].
  /// Only compares identifier attributes (those marked with [Attribute.identifier]).
  bool equalAttributes(Id id) {
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        if (_attributeMap[a.code] != id.getAttribute(a.code)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if this identifier is equal in content to the given [id].
  /// Two identifiers are equal if they have:
  /// - The same concept
  /// - Equal parent references
  /// - Equal attributes
  bool equals(Id id) {
    if (_concept != id.concept) {
      return false;
    }
    if (!equalParents(id)) {
      return false;
    }
    if (!equalAttributes(id)) {
      return false;
    }
    return true;
  }

  /// Implements the equality operator (==) for comparing identifiers.
  /// 
  /// Two identifiers are considered equal if:
  /// - They are the same object (identical)
  /// - They are both null
  /// - They have equal content (same concept, references, and attributes)
  @override
  bool operator ==(Object other) {
    if (other is Id) {
      Id id = other;
      if (identical(this, id)) {
        return true;
      } else {
        if ((this as dynamic) == null || (id as dynamic) == null) {
          return false;
        } else {
          return equals(id);
        }
      }
    } else {
      return false;
    }
  }

  /// Compares the parent references of this identifier with those of [id].
  /// 
  /// Returns:
  /// - A negative number if this identifier's parents are less than [id]'s
  /// - Zero if they are equal
  /// - A positive number if this identifier's parents are greater than [id]'s
  /// 
  /// Throws [IdException] if the identifier has no parents.
  int compareParents(Id id) {
    if (id.referenceLength > 0) {
      var compare = 0;
      for (Parent p in _concept.parents.whereType<Parent>()) {
        if (p.identifier) {
          final ref = _referenceMap[p.code];
          final ref2 = id.getReference(p.code);
          if (ref != null && ref2 != null) {
            compare = ref.oid.compareTo(ref2.oid);

            if (compare != 0) {
              break;
            }
          }
        }
      }
      return compare;
    }
    throw IdException('${_concept.code}.id does not have parents.');
  }

  /// Compares the attributes of this identifier with those of [id].
  /// 
  /// Returns:
  /// - A negative number if this identifier's attributes are less than [id]'s
  /// - Zero if they are equal
  /// - A positive number if this identifier's attributes are greater than [id]'s
  /// 
  /// Throws [IdException] if the identifier has no attributes.
  int compareAttributes(Id id) {
    if (id.attributeLength > 0) {
      var compare = 0;
      for (Attribute a in concept.attributes.whereType<Attribute>()) {
        var value1 = _attributeMap[a.code];
        var value2 = id.getAttribute(a.code);
        if (value1 != null && value2 != null) {
          compare = a.type!.compare(value1, value2);
          if (compare != 0) {
            break;
          }
        }
      } // for
      return compare;
    }
    throw IdException('${_concept.code}.id does not have attributes.');
  }

  /// Compares this identifier with [id] based on parent references and attributes.
  /// 
  /// Returns:
  /// - A negative number if this identifier is less than [id]
  /// - Zero if they are equal
  /// - A positive number if this identifier is greater than [id]
  /// 
  /// Throws [IdException] if the identifier is not defined.
  @override
  int compareTo(Id id) {
    if (id.length > 0) {
      var compare = 0;
      if (id.referenceLength > 0) {
        compare = compareParents(id);
      }
      if (compare == 0) {
        compare = compareAttributes(id);
      }
      return compare;
    }
    throw IdException('${_concept.code}.id is not defined.');
  }

  /// Removes the given [end] string from the end of [text] if present.
  String _dropEnd(String text, String end) {
    String withoutEnd = text;
    int endPosition = text.lastIndexOf(end);
    if (endPosition > 0) {
      // Drop the end.
      withoutEnd = text.substring(0, endPosition);
    }
    return withoutEnd;
  }

  /// Returns a string representation of this identifier.
  /// The format includes all parent references and attributes.
  @override
  String toString() {
    String result = '';
    if (referenceLength > 0) {
      _referenceMap.forEach((k, v) => result = '$result $v,');
    }
    if (attributeLength > 0) {
      _attributeMap.forEach((k, v) => result = '$result $k:$v,');
    }
    result = _dropEnd(result, ',');
    return result;
  }

  /// Displays the id in a human-readable format in terminal.
  void display([String title = 'Id']) {
    if (title != '') {
      print('');
      print('======================================');
      print('$title                                ');
      print('======================================');
      print('');
    }
    print(toString());
  }
}
