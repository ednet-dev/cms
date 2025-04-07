part of ednet_core;

/// A utility class for generating random IDs.
class RandomId {
  static final Random _random = Random();

  /// Generate a random ID string with the specified length
  static String generate(int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// Generate a random numeric ID with the specified length
  static String generateNumeric(int length) {
    const String digits = '0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => digits.codeUnitAt(_random.nextInt(digits.length)),
      ),
    );
  }

  /// Generate a random hexadecimal ID with the specified length
  static String generateHex(int length) {
    const String hexChars = '0123456789abcdef';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => hexChars.codeUnitAt(_random.nextInt(hexChars.length)),
      ),
    );
  }
}
