part of ednet_core;

class Id implements IId<Id> {
  final Concept _concept;

  final Map<String, Reference?> _referenceMap;
  final Map<String, Object?> _attributeMap;

  Id(this._concept)
      : _referenceMap = <String, Reference?>{},
        _attributeMap = <String, Object?>{} {
    for (Parent p in _concept.parents.whereType<Parent>()) {
      if (p.identifier) {
        _referenceMap.remove(p.code!);
      }
    }
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        _attributeMap.remove(a.code!);
      }
    }
  }

  @override
  Concept get concept => _concept;

  @override
  int get referenceLength => _referenceMap.length;

  @override
  int get attributeLength => _attributeMap.length;

  @override
  int get length => referenceLength + attributeLength;

  @override
  Reference? getReference(String code) => _referenceMap[code];

  @override
  void setReference(String code, Reference? reference) {
    _referenceMap[code] = reference;
  }

  void setParent(String code, Entity entity) {
    Reference reference = Reference(entity.oid.toString(), entity.concept.code!,
        entity.concept.entryConcept.code!);
    setReference(code, reference);
  }

  @override
  Object? getAttribute(String code) => _attributeMap[code];

  @override
  void setAttribute(String code, Object? attribute) {
    _attributeMap[code] = attribute;
  }

  @override
  int get hashCode =>
      (_concept.hashCode + _referenceMap.hashCode + _attributeMap.hashCode)
          .hashCode;

  /// Two ids are equal if their parents are equal.
  bool equalParents(Id id) {
    for (Parent p in _concept.parents.whereType<Parent>()) {
      if (p.identifier) {
        final refA = _referenceMap[p.code!];
        final refB = id.getReference(p.code!);
        if (refA != refB) {
          final pOiId = p.oid;
          final pId = p.id;
          final pCode = p.code;
          return false;
        }
      }
    }
    return true;
  }

  /// Two ids are equal if their attributes are equal.
  bool equalAttributes(Id id) {
    for (Attribute a in concept.attributes.whereType<Attribute>()) {
      if (a.identifier) {
        if (_attributeMap[a.code!] != id.getAttribute(a.code!)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the id is equal in content to the given id.
  /// Two ids are equal if they have the same content.
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

  /// == see:
  /// https://www.dartlang.org/docs/dart-up-and-running/contents/ch02.html#op-equality
  /// http://work.j832.com/2014/05/equality-and-dart.html
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
  @override
  bool operator ==(Object other) {
    if (other is Id) {
      Id id = other;
      if (identical(this, id)) {
        return true;
      } else {
        if (this == null || id == null) {
          return false;
        } else {
          return equals(id);
        }
      }
    } else {
      return false;
    }
  }

  /*
   bool operator ==(Object other) {
     if (other is Id) {
       Id id = other;
       if (this == null && id == null) {
         return true;
       } else if (this == null || id == null) {
         return false;
       } else if (identical(this, id)) {
         return true;
       } else {
         return equals(id);
       }
     } else {
       return false;
     }
   }
   */

  /// Compares two ids based on parents.
  /// If the result is less than 0 then the first id is less than the second,
  /// if it is equal to 0 they are equal and
  /// if the result is greater than 0 then the first is greater than the second.
  int compareParents(Id id) {
    if (id.referenceLength > 0) {
      var compare = 0;
      for (Parent p in _concept.parents.whereType<Parent>()) {
        if (p.identifier) {
          final ref = _referenceMap[p.code!];
          final ref2 = id.getReference(p.code!);
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
    throw IdException('${_concept.code!}.id does not have parents.');
  }

  /// Compares two ids based on attributes.
  /// If the result is less than 0 then the first id is less than the second,
  /// if it is equal to 0 they are equal and
  /// if the result is greater than 0 then the first is greater than the second.
  int compareAttributes(Id id) {
    if (id.attributeLength > 0) {
      var compare = 0;
      for (Attribute a in concept.attributes.whereType<Attribute>()) {
        var value1 = _attributeMap[a.code!];
        var value2 = id.getAttribute(a.code!);
        if (value1 != null && value2 != null) {
          compare = a.type!.compare(value1, value2);
          if (compare != 0) {
            break;
          }
        }
      } // for
      return compare;
    }
    throw IdException('${_concept.code!}.id does not have attributes.');
  }

  /// Compares two ids based on parent entity ids and attributes.
  /// If the result is less than 0 then the first id is less than the second,
  /// if it is equal to 0 they are equal and
  /// if the result is greater than 0 then the first is greater than the second.
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
    throw IdException('${_concept.code!}.id is not defined.');
  }

  /// Drops the end of a string.
  String _dropEnd(String text, String end) {
    String withoutEnd = text;
    int endPosition = text.lastIndexOf(end);
    if (endPosition > 0) {
      // Drop the end.
      withoutEnd = text.substring(0, endPosition);
    }
    return withoutEnd;
  }

  /// Returns a string that represents this id.
  @override
  String toString() {
    String result = '';
    if (referenceLength > 0) {
      _referenceMap.forEach((k, v) => result = '$result $v,');
    }
    if (attributeLength > 0) {
      _attributeMap.forEach((k, v) => result = '$result $v,');
    }
    return '(${_dropEnd(result.trim(), ',')})';
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
