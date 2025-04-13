part of ednet_core_flutter;

/// Style options for the domain selector
class DomainSelectorStyle {
  /// Custom styling for text items
  final TextStyle? textStyle;

  /// Custom styling for selected text items
  final TextStyle? selectedTextStyle;

  /// Constructor
  const DomainSelectorStyle({
    this.textStyle,
    this.selectedTextStyle,
  });
}

/// Types of domain selectors
enum DomainSelectorType {
  /// Dropdown selector
  dropdown,

  /// Tab bar selector
  tabs,

  /// Chip-based selector
  chips,
}
