part of ednet_core;

class Reference {
  String parentOidString;
  String parentConceptCode;
  String entryConceptCode;

  Reference(
      this.parentOidString, this.parentConceptCode, this.entryConceptCode);

  Oid get oid {
    int parentTimeStamp;
    try {
      parentTimeStamp = int.parse(parentOidString);
    } on FormatException catch (e) {
      throw TypeException('$parentConceptCode parent oid is not int: $e');
    }
    return Oid.ts(parentTimeStamp);
  }

  /*
  String toString() {
    String ref = 'parent oid: ${parentOidString}; ';
           ref = '${ref}parent concept: ${parentConceptCode}; ';
           ref = '${ref}entry concept: ${entryConceptCode}';
    return ref;
  */

  @override
  String toString() {
    return parentOidString;
  }

  @override
  bool operator ==(Object other) {
    return this.parentOidString == (other as Reference).parentOidString &&
        this.parentConceptCode == other.parentConceptCode &&
        this.entryConceptCode == other.entryConceptCode;
  }
}
