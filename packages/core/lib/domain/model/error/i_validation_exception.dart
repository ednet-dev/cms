part of ednet_core;

abstract class IValidationExceptions {
  int get length;

  void add(IValidationExceptions exception);

  void clear();

  List<IValidationExceptions> toList();

  // Category
  String get category;
}
