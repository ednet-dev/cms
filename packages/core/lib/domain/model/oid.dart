part of ednet_core;

class Oid implements Comparable<Oid> {
  static int _increment = 0;

  int _timeStamp = 0;

  Oid() {
    DateTime nowDate = DateTime.now();
    int nowValue =
        nowDate.millisecondsSinceEpoch; // versus nowDate.millisecond ?
    _timeStamp = nowValue + _increment++;
  }

  Oid.ts(int timeStamp) {
    _timeStamp = timeStamp;
  }

  int get timeStamp => _timeStamp;

  @override
  int get hashCode => _timeStamp.hashCode;

  /// Two oids are equal if their time stamps are equal.
  bool equals(Oid oid) {
    if (_timeStamp == oid.timeStamp) {
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
  @override
  bool operator ==(Object other) {
    if (other is Oid) {
      Oid oid = other;
      if (identical(this, oid)) {
        return true;
      } else {
        return equals(oid);
      }
    } else {
      return false;
    }
  }

  /*
  bool operator ==(Object other) {
    if (other is Oid) {
      Oid oid = other;
      if (this == null && oid == null) {
        return true;
      } else if (this == null || oid == null) {
        return false;
      } else if (identical(this, oid)) {
        return true;
      } else {
        return equals(oid);
      }
    } else {
      return false;
    }
  }
  */

  /// Compares two oids based on unique numbers. If the result is less than 0
  /// then the first entity is less than the second, if it is equal to 0 they
  /// are equal and if the result is greater than 0 then the first is greater
  /// than the second.
  @override
  int compareTo(Oid oid) => _timeStamp.compareTo(oid._timeStamp);

  @override
  String toString() => _timeStamp.toString();
}
