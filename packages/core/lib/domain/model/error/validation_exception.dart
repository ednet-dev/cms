part of ednet_core;

class ValidationException implements Exception {
  final String category;
  final String message;

  ValidationException(this.category, this.message) {
    print('EXCEPTION: ' + this.category + ' ' + this.message);
  }

  /// Returns a string that represents the error.
  @override
  String toString() {
    return '$category: $message';
  }

  /// Displays (prints) an exception.
  display({String prefix = ''}) {
    print('$prefix******************************************');
    print('$prefix$category                               ');
    print('$prefix******************************************');
    print('${prefix}message: $message');
    print('$prefix******************************************');
    print('');
  }
}
