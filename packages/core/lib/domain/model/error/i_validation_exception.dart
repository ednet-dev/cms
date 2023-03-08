part of ednet_core;
abstract class IValidationExceptions {
  int get length;

  void add(ValidationException exception);

  void clear();

  List<ValidationException> toList();
}
