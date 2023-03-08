part of ednet_core;

class ValidationExceptions implements IValidationExceptions {
  final List<ValidationException> _exceptionList;

  ValidationExceptions() : _exceptionList = <ValidationException>[];

  @override
  int get length => _exceptionList.length;

  bool get isEmpty => length == 0;

  Iterator<ValidationException> get iterator => _exceptionList.iterator;

  @override
  void add(ValidationException exception) {
    _exceptionList.add(exception);
  }

  @override
  void clear() {
    _exceptionList.clear();
  }

  @override
  List<ValidationException> toList() => _exceptionList.toList();

  /// Returns a string that represents the exceptions.
  @override
  String toString() {
    var messages = '';
    for (var exception in _exceptionList) {
      messages = '${exception.toString()} \n$messages';
    }
    return messages;
  }

  /// Displays (prints) a title, then exceptions.
  void display({String title: 'Entities', bool withOid: true}) {
    if (title == 'Entities') {
      title = 'Errors';
    }
    print('');
    print('************************************************');
    print('$title                                          ');
    print('************************************************');
    print('');
    for (ValidationException exception in _exceptionList) {
      exception.display(prefix: '*** ');
    }
  }
}
