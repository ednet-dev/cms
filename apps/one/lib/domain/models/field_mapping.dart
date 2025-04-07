import 'package:ednet_core/ednet_core.dart';

/// Represents a field mapping for the ACL layer
class FieldMapping {
  /// The field name in the source data
  final String sourceField;

  /// The field name in the target model
  final String targetField;

  /// Optional transformation expression
  final String? transformation;

  /// Constructor
  const FieldMapping({
    required this.sourceField,
    required this.targetField,
    this.transformation,
  });

  /// Create a FieldMapping from JSON
  factory FieldMapping.fromJson(Map<String, dynamic> json) {
    return FieldMapping(
      sourceField: json['sourceField'] as String,
      targetField: json['targetField'] as String,
      transformation: json['transformation'] as String?,
    );
  }

  /// Convert FieldMapping to JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceField': sourceField,
      'targetField': targetField,
      'transformation': transformation,
    };
  }
}
