part of ednet_core;

/// A class representing a unique object identifier (OID) in the domain model.
///
/// The [Oid] class provides a way to generate and manage unique identifiers for domain entities.
/// It uses a combination of timestamp and increment to ensure uniqueness.
///
/// Example usage:
/// ```dart
/// // Create a new OID with current timestamp
/// final oid1 = Oid();
///
/// // Create an OID with a specific timestamp
/// final oid2 = Oid.ts(1234567890);
///
/// // Compare OIDs
/// if (oid1.compareTo(oid2) < 0) {
///   print('oid1 is less than oid2');
/// }
/// ```
class Oid implements Comparable<Oid> {
  /// Static counter to ensure uniqueness when multiple OIDs are created in the same millisecond.
  static int _increment = 0;

  /// The timestamp value of this OID.
  int _timeStamp = 0;

  /// Creates a new [Oid] instance with the current timestamp.
  ///
  /// The timestamp is calculated as the current milliseconds since epoch plus an increment
  /// to ensure uniqueness even when multiple OIDs are created in the same millisecond.
  Oid() {
    DateTime nowDate = DateTime.now();
    int nowValue = nowDate.millisecondsSinceEpoch;
    _timeStamp = nowValue + _increment++;
  }

  /// Creates a new [Oid] instance with a specific timestamp.
  ///
  /// [timeStamp] is the timestamp value to use for this OID.
  Oid.ts(int timeStamp) {
    _timeStamp = timeStamp;
  }

  /// Gets the timestamp value of this OID.
  int get timeStamp => _timeStamp;

  /// Returns the hash code of this OID based on its timestamp.
  @override
  int get hashCode => _timeStamp.hashCode;

  /// Checks if this OID is equal to another OID.
  ///
  /// [oid] is the OID to compare with.
  /// Returns true if the timestamps are equal, false otherwise.
  bool equals(Oid oid) {
    if (_timeStamp == oid.timeStamp) {
      return true;
    }
    return false;
  }

  /// Compares this OID with another object for equality.
  ///
  /// [other] is the object to compare with.
  /// Returns true if [other] is an OID with the same timestamp, false otherwise.
  ///
  /// This implementation follows Dart's equality operator guidelines:
  /// 1. If either object is null, returns true only if both are null
  /// 2. If the objects are identical, returns true
  /// 3. Otherwise, compares the timestamps using [equals]
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

  /// Compares this OID with another OID for ordering.
  ///
  /// [oid] is the OID to compare with.
  /// Returns:
  /// - A negative number if this OID is less than [oid]
  /// - Zero if this OID is equal to [oid]
  /// - A positive number if this OID is greater than [oid]
  ///
  /// The comparison is based on the timestamp values.
  @override
  int compareTo(Oid oid) => _timeStamp.compareTo(oid._timeStamp);

  /// Returns a string representation of this OID.
  ///
  /// Returns the timestamp value as a string.
  @override
  String toString() => _timeStamp.toString();
}
