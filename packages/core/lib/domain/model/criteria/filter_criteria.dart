part of ednet_core;

class FilterCriteria {
  final String attribute;
  final String operator;
  final dynamic value;

  FilterCriteria({
    required this.attribute,
    required this.operator,
    required this.value,
  });
}
