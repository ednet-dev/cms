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

  @override
  int get hashCode => parentOidString.hashCode;

  Map<String, dynamic> toGraph() {
    return {
      'parentOidString': parentOidString,
      'parentConceptCode': parentConceptCode,
      'entryConceptCode': entryConceptCode
    };
  }
}
